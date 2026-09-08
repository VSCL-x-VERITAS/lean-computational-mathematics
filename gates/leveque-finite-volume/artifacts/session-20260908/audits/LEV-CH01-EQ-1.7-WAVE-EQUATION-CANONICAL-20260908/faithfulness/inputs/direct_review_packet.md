# Declaration dossier for LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_equation07_pressureWave
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density)
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density)
    (x t ptt pxx uxt utx : ℝ)
    (hptt : HasDerivAt
      (fun τ => partialTimeDerivative system.pressure x τ) ptt t)
    (huxt : HasDerivAt
      (fun τ => partialSpaceDerivative system.velocity x τ) uxt t)
    (hutx : HasDerivAt
      (fun ξ => partialTimeDerivative system.velocity ξ t) utx x)
    (hpxx : HasDerivAt
      (fun ξ => partialSpaceDerivative system.pressure ξ t) pxx x)
    (hmixed : uxt = utx) :
    ptt = (Real.sqrt (bulkModulus / density)) ^ 2 * pxx
```

## Elaborated target type

```lean
∀ {bulkModulus density : Real} (system : NumStability.LinearAcousticsSolution bulkModulus density),
  Real.instLT.lt 0 bulkModulus →
    Real.instLT.lt 0 density →
      ∀ (x t ptt pxx uxt utx : Real),
        HasDerivAt (fun τ => NumStability.partialTimeDerivative system.pressure x τ) ptt t →
          HasDerivAt (fun τ => NumStability.partialSpaceDerivative system.velocity x τ) uxt t →
            HasDerivAt (fun ξ => NumStability.partialTimeDerivative system.velocity ξ t) utx x →
              HasDerivAt (fun ξ => NumStability.partialSpaceDerivative system.pressure ξ t) pxx x →
                Eq uxt utx → Eq ptt (instHMul.hMul (instHPow.hPow (instHDiv.hDiv bulkModulus density).sqrt 2) pxx)
```

## Fully explicit elaborated target type

```lean
∀ {bulkModulus density : Real} (system : NumStability.LinearAcousticsSolution bulkModulus density)
  (hbulkModulus :
    @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) bulkModulus)
  (hdensity :
    @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) density)
  (x t ptt pxx uxt utx : Real)
  (hptt :
    @HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField) Real
      Real.instAddCommGroup
      (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
        (@NormedField.toNormedSpace.{0} Real Real.normedField))
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@ContinuousMul.to_continuousSMul.{0} Real
        (@UniformSpace.toTopologicalSpace.{0} Real
          (@PseudoMetricSpace.toUniformSpace.{0} Real
            (@SeminormedRing.toPseudoMetricSpace.{0} Real
              (@SeminormedCommRing.toSeminormedRing.{0} Real
                (@NormedCommRing.toSeminormedCommRing.{0} Real
                  (@NormedField.toNormedCommRing.{0} Real
                    (@NontriviallyNormedField.toNormedField.{0} Real
                      (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
        Real.instMul
        (@IsTopologicalSemiring.toContinuousMul.{0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real
              (@SeminormedRing.toPseudoMetricSpace.{0} Real
                (@SeminormedCommRing.toSeminormedRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real
                    (@NormedField.toNormedCommRing.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real
                (@SeminormedRing.toPseudoMetricSpace.{0} Real
                  (@SeminormedCommRing.toSeminormedRing.{0} Real
                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                      (@NormedField.toNormedCommRing.{0} Real
                        (@NontriviallyNormedField.toNormedField.{0} Real
                          (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
            instIsTopologicalRingReal)))
      (fun (τ : Real) =>
        NumStability.partialTimeDerivative (@NumStability.LinearAcousticsSolution.pressure bulkModulus density system) x
          τ)
      ptt t)
  (huxt :
    @HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField) Real
      Real.instAddCommGroup
      (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
        (@NormedField.toNormedSpace.{0} Real Real.normedField))
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@ContinuousMul.to_continuousSMul.{0} Real
        (@UniformSpace.toTopologicalSpace.{0} Real
          (@PseudoMetricSpace.toUniformSpace.{0} Real
            (@SeminormedRing.toPseudoMetricSpace.{0} Real
              (@SeminormedCommRing.toSeminormedRing.{0} Real
                (@NormedCommRing.toSeminormedCommRing.{0} Real
                  (@NormedField.toNormedCommRing.{0} Real
                    (@NontriviallyNormedField.toNormedField.{0} Real
                      (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
        Real.instMul
        (@IsTopologicalSemiring.toContinuousMul.{0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real
              (@SeminormedRing.toPseudoMetricSpace.{0} Real
                (@SeminormedCommRing.toSeminormedRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real
                    (@NormedField.toNormedCommRing.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real
                (@SeminormedRing.toPseudoMetricSpace.{0} Real
                  (@SeminormedCommRing.toSeminormedRing.{0} Real
                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                      (@NormedField.toNormedCommRing.{0} Real
                        (@NontriviallyNormedField.toNormedField.{0} Real
                          (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
            instIsTopologicalRingReal)))
      (fun (τ : Real) =>
        NumStability.partialSpaceDerivative (@NumStability.LinearAcousticsSolution.velocity bulkModulus density system)
          x τ)
      uxt t)
  (hutx :
    @HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField) Real
      Real.instAddCommGroup
      (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
        (@NormedField.toNormedSpace.{0} Real Real.normedField))
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@ContinuousMul.to_continuousSMul.{0} Real
        (@UniformSpace.toTopologicalSpace.{0} Real
          (@PseudoMetricSpace.toUniformSpace.{0} Real
            (@SeminormedRing.toPseudoMetricSpace.{0} Real
              (@SeminormedCommRing.toSeminormedRing.{0} Real
                (@NormedCommRing.toSeminormedCommRing.{0} Real
                  (@NormedField.toNormedCommRing.{0} Real
                    (@NontriviallyNormedField.toNormedField.{0} Real
                      (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
        Real.instMul
        (@IsTopologicalSemiring.toContinuousMul.{0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real
              (@SeminormedRing.toPseudoMetricSpace.{0} Real
                (@SeminormedCommRing.toSeminormedRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real
                    (@NormedField.toNormedCommRing.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real
                (@SeminormedRing.toPseudoMetricSpace.{0} Real
                  (@SeminormedCommRing.toSeminormedRing.{0} Real
                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                      (@NormedField.toNormedCommRing.{0} Real
                        (@NontriviallyNormedField.toNormedField.{0} Real
                          (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
            instIsTopologicalRingReal)))
      (fun (ξ : Real) =>
        NumStability.partialTimeDerivative (@NumStability.LinearAcousticsSolution.velocity bulkModulus density system) ξ
          t)
      utx x)
  (hpxx :
    @HasDerivAt.{0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField) Real
      Real.instAddCommGroup
      (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
        (@NormedField.toNormedSpace.{0} Real Real.normedField))
      (@UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      (@ContinuousMul.to_continuousSMul.{0} Real
        (@UniformSpace.toTopologicalSpace.{0} Real
          (@PseudoMetricSpace.toUniformSpace.{0} Real
            (@SeminormedRing.toPseudoMetricSpace.{0} Real
              (@SeminormedCommRing.toSeminormedRing.{0} Real
                (@NormedCommRing.toSeminormedCommRing.{0} Real
                  (@NormedField.toNormedCommRing.{0} Real
                    (@NontriviallyNormedField.toNormedField.{0} Real
                      (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
        Real.instMul
        (@IsTopologicalSemiring.toContinuousMul.{0} Real
          (@UniformSpace.toTopologicalSpace.{0} Real
            (@PseudoMetricSpace.toUniformSpace.{0} Real
              (@SeminormedRing.toPseudoMetricSpace.{0} Real
                (@SeminormedCommRing.toSeminormedRing.{0} Real
                  (@NormedCommRing.toSeminormedCommRing.{0} Real
                    (@NormedField.toNormedCommRing.{0} Real
                      (@NontriviallyNormedField.toNormedField.{0} Real
                        (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
          (@IsTopologicalRing.toIsTopologicalSemiring.{0} Real
            (@UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real
                (@SeminormedRing.toPseudoMetricSpace.{0} Real
                  (@SeminormedCommRing.toSeminormedRing.{0} Real
                    (@NormedCommRing.toSeminormedCommRing.{0} Real
                      (@NormedField.toNormedCommRing.{0} Real
                        (@NontriviallyNormedField.toNormedField.{0} Real
                          (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing))))
            instIsTopologicalRingReal)))
      (fun (ξ : Real) =>
        NumStability.partialSpaceDerivative (@NumStability.LinearAcousticsSolution.pressure bulkModulus density system)
          ξ t)
      pxx x)
  (hmixed : @Eq.{1} Real uxt utx),
  @Eq.{1} Real ptt
    (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
      (@HPow.hPow.{0, 0, 0} Real Nat Real (@instHPow.{0, 0} Real Nat (@Monoid.toNatPow.{0} Real Real.instMonoid))
        (Real.sqrt
          (@HDiv.hDiv.{0, 0, 0} Real Real Real (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid))
            bulkModulus density))
        (@OfNat.ofNat.{0} Nat (nat_lit 2) (instOfNatNat (nat_lit 2))))
      pxx)
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation`, `ComputationalMathematics.Source.LeVeque.Chapter01.Equation05`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics` imports: `Mathlib.LinearAlgebra.Matrix.Notation`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics`
- `ComputationalMathematics.Source.LeVeque.Chapter01.Equation05` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.LinearAcousticsSolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `513d5c753b15b2b1f95a285bb56b9dd76ddd4972998efb42ee52b3c971d3b6b6`

Hash-verified prior declaration review:

- Reuse SHA-256: `ff52dea514c94f9ce2a0017167b16c9cb219fe6f3bb95a78dd507149a1d41de4`
- Reviewed interpretation: By D007, a bundle of two real space-time fields, nonzero density, and the acoustic equations everywhere.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D002: `NumStability.LinearAcousticsSolution.pressure`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fac56789e51d0c1cafd03a15add7c34377bfca4487bfba267c6daca97829d35b`

Hash-verified prior declaration review:

- Reuse SHA-256: `92d703fa9b98ae6eebe9724e7ea75d769c37da76a91e568b947373ad361a2b44`
- Reviewed interpretation: Projects the second field of the bundle, the pressure function supplied to D007.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D003: `NumStability.LinearAcousticsSolution.velocity`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `2187ffc4039fadc466ba239fc25c765ecf4332177f9cf6c4c7c5652632f0e0af`

Hash-verified prior declaration review:

- Reuse SHA-256: `60c76b266006aacd87e6befd3ff9ef387ab296a7f8ba248fca9eac43d3892617`
- Reviewed interpretation: Projects the third field of the bundle, the velocity function supplied to D007.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D004: `NumStability.partialSpaceDerivative`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `89aca11388fb44639065a959d237534d955526105ba428029c33b91753221255`

Type:

```lean
(Real → Real → Real) → Real → Real → Real
```

Fully explicit type:

```lean
(field : Real → Real → Real) → (x t : Real) → Real
```

Definition body (one-level semantic boundary):

```lean
fun field x t => deriv (fun ξ => field ξ t) x
```

### D005: `NumStability.partialTimeDerivative`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `975a44b51ddd95a407caa1322bf2ccf67f5521d7586e9d6703be84177c183a8b`

Type:

```lean
(Real → Real → Real) → Real → Real → Real
```

Fully explicit type:

```lean
(field : Real → Real → Real) → (x t : Real) → Real
```

Definition body (one-level semantic boundary):

```lean
fun field x t => deriv (fun τ => field x τ) t
```

### D006: `NumStability.LinearAcousticsSolution.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `c7b7672e137213e409f8491f0f821839f9c839e0e524b92d16ebb829b22b70ea`

Hash-verified prior declaration review:

- Reuse SHA-256: `4001d0b94553ecf529523ba5538471c4e152c240e949fd549ee2c599907e0e11`
- Reviewed interpretation: Constructs a solution from density≠0, arbitrary real pressure and velocity fields, and D008 at all real x,t.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D007: `NumStability.IsLinearAcousticsSolutionAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4f0fb7d4e861f61b5778eb9b29e92abd8b800718338043fbe9cdfc17a8a4d533`

Type:

```lean
(Real → Real → Real) → (Real → Real → Real) → Real → Real → Real → Real → Prop
```

Fully explicit type:

```lean
(pressure velocity : Real → Real → Real) → (bulkModulus density x t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun pressure velocity bulkModulus density x t =>
  Exists fun pt =>
    Exists fun px =>
      Exists fun ut =>
        Exists fun ux =>
          And (HasDerivAt (fun τ => pressure x τ) pt t)
            (And (HasDerivAt (fun ξ => pressure ξ t) px x)
              (And (HasDerivAt (fun τ => velocity x τ) ut t)
                (And (HasDerivAt (fun ξ => velocity ξ t) ux x)
                  (And (Eq (instHAdd.hAdd pt (instHMul.hMul bulkModulus ux)) 0)
                    (Eq (instHAdd.hAdd ut (instHMul.hMul (Real.instInv.inv density) px)) 0)))))
```

### D008: `NumStability.IsLinearAcousticsSolutionAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `9b6e5a1727ee3c4534bcbde8284344df8cb944ad51f1336292aa12c9b2121989`

Type:

```lean
ContinuousSMul Real Real
```

Fully explicit type:

```lean
@ContinuousSMul.{0, 0} Real Real (@instSMulOfMul.{0} Real Real.instMul)
  (@UniformSpace.toTopologicalSpace.{0} Real
    (@PseudoMetricSpace.toUniformSpace.{0} Real
      (@SeminormedRing.toPseudoMetricSpace.{0} Real
        (@SeminormedCommRing.toSeminormedRing.{0} Real
          (@NormedCommRing.toSeminormedCommRing.{0} Real
            (@NormedField.toNormedCommRing.{0} Real
              (@NontriviallyNormedField.toNormedField.{0} Real
                (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
  (@UniformSpace.toTopologicalSpace.{0} Real
    (@PseudoMetricSpace.toUniformSpace.{0} Real
      (@SeminormedRing.toPseudoMetricSpace.{0} Real
        (@SeminormedCommRing.toSeminormedRing.{0} Real
          (@NormedCommRing.toSeminormedCommRing.{0} Real
            (@NormedField.toNormedCommRing.{0} Real
              (@NontriviallyNormedField.toNormedField.{0} Real
                (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField))))))))
```

### D009: `ContinuousMul.to_continuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Monoid`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `f0c5d378c0acb7a136cec4dc063f034495e42fd5022786b7c0b6595115d372ae`

Type:

```lean
∀ {M : Type u_3} [inst : TopologicalSpace M] [inst_1 : Mul M] [ContinuousMul M], ContinuousSMul M M
```

Fully explicit type:

```lean
∀ {M : Type u_3} [inst : TopologicalSpace.{u_3} M] [inst_1 : Mul.{u_3} M] [@ContinuousMul.{u_3} M inst inst_1],
  @ContinuousSMul.{u_3, u_3} M M (@instSMulOfMul.{u_3} M inst_1) inst inst
```

### D010: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `22b7c7d8fc79e8fdde53f4c5f0f7e47a5b48886ac404b11b983a20e9fe547215`

Hash-verified prior declaration review:

- Reuse SHA-256: `621e4144ebb3e8607aba65644985b4ca558485b74bfdbd83ad512f0da7e128d2`
- Reviewed interpretation: Retains the normed field and obtains nontrivial norm from norm density.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D011: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cf21e4a4c962ee0db8a97bd649d849a798a693692bf09312f7855ddcbeb125ea`

Hash-verified prior declaration review:

- Reuse SHA-256: `a2e8ca89fe0eb84867011acd4828a44373e4e86de88eadeed0101fbb6098a591`
- Reviewed interpretation: Projects the division structure from the supplied division-inverse monoid.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D012: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `7c0a706a1e00baaee306c860274ca9dfd7b2a99a2ca6d2d056f1f8a84ec43f58`
- Reviewed interpretation: Equality of two terms of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D013: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `10d75d9f08ad8c923109392866fba5fb3645de144bc824cefdd353658fe9f06b`

Hash-verified prior declaration review:

- Reuse SHA-256: `cd288550d151f033a4be6edd0181961cb70137f6387e325eb758e25e521814a6`
- Reviewed interpretation: Projects the binary division operation from its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D014: `HMul.hMul`

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

### D015: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D016: `HasDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.Deriv.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `425ec9578fd20d63923b9588cbb7761a6e92f281528630fe03d0dc3dc1bc60a2`

Hash-verified prior declaration review:

- Reuse SHA-256: `b34f09fc3c9ab0f90fb06d93ac2f1d8b0efbed23466dfdfee30f2ba314ec3fc6`
- Reviewed interpretation: Derivative-at-point predicate defined through HasDerivAtFilter at the neighborhood of the point with fixed base point.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D017: `IsTopologicalRing.toIsTopologicalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
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

### D018: `IsTopologicalSemiring.toContinuousMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Basic`
- Declaration kind: `theorem`
- Distance from target type: `1`
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

### D019: `LT.lt`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `fd5699899f1a49c91982cb363d3a71557ab1b53ee772cd777c9ee7717abc2009`

Hash-verified prior declaration review:

- Reuse SHA-256: `43c3b385c6b61a11a3e8c45df4b0fbc41de2e9696163d4cbf2319672b4581eee`
- Reviewed interpretation: Projects the strict comparison relation from its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D020: `Monoid.toNatPow`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D021: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D022: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D023: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D024: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D025: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D026: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Hash-verified prior declaration review:

- Reuse SHA-256: `91163318489530ec0eab5ba81c4a93cdb213eba211491042a40ffb4901ac834a`
- Reviewed interpretation: Projects the underlying nonunital seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D027: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `67f908490d5c78d544ac6feb0c14a4a7a734686b52cb61f94e51177d4d64194b`
- Reviewed interpretation: Retains norm, additive group, and pseudometric from the ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D028: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `dc08b02d757cccbd21bce550b40d3f76d2ee704ec2cd7f5507023d827296474f`

Hash-verified prior declaration review:

- Reuse SHA-256: `bc35a00cf97ae1c8c3c866f30f7ddc25beaab57a4a7bce4bee00091950012c01`
- Reviewed interpretation: Projects the underlying normed field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D029: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D030: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `8eb4ff5d914bece130f8c916caf7ac99f086cf4d32cdf9855233eee2fee619f9`
- Reviewed interpretation: Retains norm, ring, and pseudometric while forgetting separation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D031: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4aa3dba57859ca72552799005279a2b5a65b8c083980070fbbff11fd1de56dec`

Hash-verified prior declaration review:

- Reuse SHA-256: `c479cea7e1d600dcdde22dc4acdbaf3b3d02267c12bd280ebde84b9e465fbccc`
- Reviewed interpretation: Retains norm, ring, and metric from a normed field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D032: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Hash-verified prior declaration review:

- Reuse SHA-256: `5146ee029cc24a921b12e7bbfa6af981f0947f3eaceb633c72dcfd8261161921`
- Reviewed interpretation: Makes a normed field a normed space over itself using its multiplication-based module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D033: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Hash-verified prior declaration review:

- Reuse SHA-256: `c05db2574a218e4cc457262bebdb378e5194526e65ced53580ccf3eaf2e01c59`
- Reviewed interpretation: Projects the underlying module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D034: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `709c19d978b0e632bce8db27c88dc92ca33a4c31aae8bffc005cbe405016878f`
- Reviewed interpretation: Extracts the value of the specified numeral from its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D035: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Hash-verified prior declaration review:

- Reuse SHA-256: `b612f2f020672600d76129fd02f6087dcb758d3b4b7f4768e8947728396115dc`
- Reviewed interpretation: Projects the uniform-space field of the pseudometric structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D036: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `4f8a68078e1c976cd298d5b27f9a96f836fd16e03a12f3e09653e8482c9a36dc`
- Reviewed interpretation: The library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D037: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Hash-verified prior declaration review:

- Reuse SHA-256: `ef800b837cf0306a84165e1ad7bd5b60840fb54c1f50dcfa83117561aa42a922`
- Reviewed interpretation: The real normed field equipped with density of norm values.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D038: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Hash-verified prior declaration review:

- Reuse SHA-256: `8a1c748cd60b9aeb92b06cb3f817ad917141480849ba036d1c3d6923ba63b322`
- Reviewed interpretation: The inferred library additive commutative group on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D039: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `166f2abb65bf1271e5e8d70fdb78c55672c7e366b30439e83b517f803cdefac3`

Hash-verified prior declaration review:

- Reuse SHA-256: `f23baf263055138f4a880fc78cb01e57b9c2017bdce64e14ee71758cf67c9516`
- Reviewed interpretation: Real multiplicative structure with inverse and division satisfying division equals multiplication by inverse.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D040: `Real.instLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `573bcfac2b62a55b90ee93bf35473d500cc64581698a699b2152c52f40d0e14a`

Hash-verified prior declaration review:

- Reuse SHA-256: `530f1db419d2d44c508ac682b1964082aa285ebb9a2788f5b0cdb8d121936198`
- Reviewed interpretation: Selects the library strict order on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D041: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `37978679365b30167654c1ef9ecb0fa938325c2047191daa7208aee389c0b4b8`

Hash-verified prior declaration review:

- Reuse SHA-256: `81c473a3e0bfbf2fdbd6685eb490be28d5288cd8694e7d46635868ed6ddd78a2`
- Reviewed interpretation: The inferred library multiplicative monoid on Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D042: `Real.instMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `459ccbe28a1d29ccd2b329ea29e1a84b329b8064b8a8ecc52764b69b23e229ed`

Hash-verified prior declaration review:

- Reuse SHA-256: `2467af1d21607180c4283d3a54020b1c415bf2a8aca5ae2e273709a99e899b52`
- Reviewed interpretation: Selects real multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D043: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `86078ab054939371a16840a724e316c60ffb1d1dde7c0c3286c8b44161e8807b`
- Reviewed interpretation: Selects the real additive zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D044: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Hash-verified prior declaration review:

- Reuse SHA-256: `0205314787987cdbd8b9544c454218e0e61dffaebf8386ec658fc97c431de441`
- Reviewed interpretation: Combines the real commutative ring with the standard real norm and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D045: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Hash-verified prior declaration review:

- Reuse SHA-256: `232cc9ae21dad7be4308e3b4fbb94e37a9e35320b125954d802d6cf8e0ecf81d`
- Reviewed interpretation: Combines the real field with the real norm and metric, retaining their operations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D046: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Hash-verified prior declaration review:

- Reuse SHA-256: `4d4f0245435919c5cc3162efe18bea45a1bca595b23e22118b7711a380091c85`
- Reviewed interpretation: Real distance is abs(x-y), with the corresponding metric uniformity.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D047: `Real.sqrt`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Sqrt`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `67f9248ae1acb851b5392be301057ebb8b8ef2fb20f76d2d53a2d07ec8f30553`

Hash-verified prior declaration review:

- Reuse SHA-256: `660e31e67bfc058cb1d690c276d280a85a2381b1648288bcba887d408a4ff4b9`
- Reviewed interpretation: Maps through the nonnegative reals, takes their square root, and returns a real; negative inputs are truncated before taking the root.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D048: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Hash-verified prior declaration review:

- Reuse SHA-256: `01395c70e5199478d04301b270ec55fbfabde2088f2422c42142f95b836fa6ac`
- Reviewed interpretation: Retains norm, additive and multiplicative operations, and pseudometric while forgetting the unit requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D049: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e3cbc92d1d5e37d9eaeb1d595c83a78f7af7e3a8d249a700fa3676ab4e0c3d60`

Hash-verified prior declaration review:

- Reuse SHA-256: `c255c997f2ce742dc973fff7159ea489da0cbe7b3c4492a251761b0b620c0986`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D050: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e6ea9296e8643d5ae7cf334c065c9d6ebe4a95de22d3b0708a585db80e17322a`

Hash-verified prior declaration review:

- Reuse SHA-256: `463c0e7b16d518ee4dfae0e19dae4e8faac0b071700275181a92fe7f7b6d93ba`
- Reviewed interpretation: Projects the pseudometric field.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D051: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Hash-verified prior declaration review:

- Reuse SHA-256: `6005a0985b00a0582ee73b1bc57fdeb09cbfd5cac3ac0571ff6c27224e78c663`
- Reviewed interpretation: Projects the underlying topology.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D052: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `7da29d4041d224597c58b777aefd83ebf935cd487d108bb80ec57cdf854d31c1`
- Reviewed interpretation: Constructs the numeral-zero instance from an existing zero operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D053: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ea3478ce3daf37e2cbdcd4bfaf7b5142fd7d274b56d75d2fae007c15e1b89871`

Hash-verified prior declaration review:

- Reuse SHA-256: `60a2cc0458d898dae42381198492c635420dbbd70dedb54bc01bd86fe2673fef`
- Reviewed interpretation: Lifts same-type division to heterogeneous-division notation without changing its operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D054: `instHMul`

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

### D055: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D056: `instIsTopologicalRingReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Ring.Real`
- Declaration kind: `theorem`
- Distance from target type: `1`
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

### D057: `instOfNatNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D058: `deriv`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.Deriv.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `b63bef2a9d0b32438871cfa8d3f368a5222b28c62626c9441180cd39e274baa8`

Type:

```lean
{𝕜 : Type u} →
  [inst : NontriviallyNormedField 𝕜] →
    {F : Type v} → [inst_1 : AddCommGroup F] → [Module 𝕜 F] → [TopologicalSpace F] → (𝕜 → F) → 𝕜 → F
```

Fully explicit type:

```lean
{𝕜 : Type u} →
  [inst : NontriviallyNormedField.{u} 𝕜] →
    {F : Type v} →
      [inst_1 : AddCommGroup.{v} F] →
        [@Module.{u, v} 𝕜 F
              (@DivisionSemiring.toSemiring.{u} 𝕜
                (@Semifield.toDivisionSemiring.{u} 𝕜
                  (@Field.toSemifield.{u} 𝕜
                    (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
              (@AddCommGroup.toAddCommMonoid.{v} F inst_1)] →
          [TopologicalSpace.{v} F] → (f : 𝕜 → F) → (x : 𝕜) → F
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NontriviallyNormedField 𝕜] {F} [AddCommGroup F] [Module 𝕜 F] [TopologicalSpace F] f x =>
  ContinuousLinearMap.funLike.coe (fderiv 𝕜 f x) 1
```

### D059: `Ne`

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

### D060: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `8269528b972c7d9d73a8b2cd8e0cf25c78a22d0a650eba88b5cf133955c78449`
- Reviewed interpretation: Logical conjunction of two propositions.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D061: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `943e35a3b83e65aa898ff3f539d251e9e60c058f0663880bcf2f8ece9a800a94`
- Reviewed interpretation: Existential quantification over a predicate's witness type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D062: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Hash-verified prior declaration review:

- Reuse SHA-256: `69f183a8512c62f35d24ca2ed6b18e0e1de79c1405e7a0b174a4a0c678726c53`
- Reviewed interpretation: Projects the addition operation from its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D063: `Inv.inv`

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

### D064: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f99208c181266311bec9c890b688378f329076f9e6be38fe93d9cedf4d7f50ce`

Hash-verified prior declaration review:

- Reuse SHA-256: `6c1b3fd230a1404c788da86a4fc204178d39046f96fb9499fc2167ba1d789960`
- Reviewed interpretation: Selects real addition.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D065: `Real.instInv`

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

### D066: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Hash-verified prior declaration review:

- Reuse SHA-256: `52bdba0ca8904cbb2cdcf4b237fa7c203306c7eab2d9bef517a232dfc725d395`
- Reviewed interpretation: Lifts same-type addition to HAdd using the original addition operation.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D067: `ContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `b36800b38dbbf71323d517896ed68ecf785e1c2dc2b52f5265b6b5be545cb4c1`

Hash-verified prior declaration review:

- Reuse SHA-256: `4af256e1848f6562b88655e1c8de1a4669fe4908c90add058a16f3b49e91d472`
- Reviewed interpretation: The library proposition asserting continuity of the specified scalar action in the specified topologies.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D068: `instSMulOfMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `5`
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
