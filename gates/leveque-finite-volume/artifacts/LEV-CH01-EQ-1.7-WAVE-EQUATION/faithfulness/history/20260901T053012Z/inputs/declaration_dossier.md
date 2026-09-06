# Declaration dossier for LEV-CH01-EQ-1.7-WAVE-EQUATION

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

- `AuditTarget` imports: `NumStability.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation`, `NumStability.Source.LeVeque.Chapter01.Equation05`
- `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics` imports: `Mathlib.LinearAlgebra.Matrix.Notation`, `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`, `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection`
- `NumStability.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation` imports: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- `NumStability.Source.LeVeque.Chapter01.Equation05` imports: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.LinearAcousticsSolution`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a3c971e11ec2df7777beca54117c6744591b08fa8096b9234ae1bb09b6205903`

Type:

```lean
Real → Real → Type
```

Fully explicit type:

```lean
(bulkModulus density : Real) → Type
```

### D002: `NumStability.LinearAcousticsSolution.pressure`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c77573e8c8b7997dfa0f4d261aa3b1dbd7b41732d105a861a68b1d43712d8d4a`

Type:

```lean
{bulkModulus density : Real} → NumStability.LinearAcousticsSolution bulkModulus density → Real → Real → Real
```

Fully explicit type:

```lean
{bulkModulus density : Real} → (self : NumStability.LinearAcousticsSolution bulkModulus density) → Real → Real → Real
```

Definition body (one-level semantic boundary):

```lean
fun bulkModulus density self => self.2
```

### D003: `NumStability.LinearAcousticsSolution.velocity`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6fbdd8bd68b9a595ac20ddca5f70ce439337394ca8280edf2eb3c37edeb8a1aa`

Type:

```lean
{bulkModulus density : Real} → NumStability.LinearAcousticsSolution bulkModulus density → Real → Real → Real
```

Fully explicit type:

```lean
{bulkModulus density : Real} → (self : NumStability.LinearAcousticsSolution bulkModulus density) → Real → Real → Real
```

Definition body (one-level semantic boundary):

```lean
fun bulkModulus density self => self.3
```

### D004: `NumStability.partialSpaceDerivative`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `71a530f8fe8f5a2017a80cb22ad3e0674eb45f8e680052291f4eb347d5d0f5e5`

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
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `56ad6bc2336b4305365767bdba690fffe42acf54cb04114ad7e794134e899802`

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
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `e4d6b37d2fa2308d4129d264bd9153bb5877454b02a65f2e59cd44fe5cf54711`

Type:

```lean
{bulkModulus density : Real} →
  Ne density 0 →
    (pressure velocity : Real → Real → Real) →
      (∀ (x t : Real), NumStability.IsLinearAcousticsSolutionAt pressure velocity bulkModulus density x t) →
        NumStability.LinearAcousticsSolution bulkModulus density
```

Fully explicit type:

```lean
{bulkModulus density : Real} →
  (density_ne_zero : @Ne.{1} Real density (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))) →
    (pressure velocity : Real → Real → Real) →
      (satisfies : ∀ (x t : Real), NumStability.IsLinearAcousticsSolutionAt pressure velocity bulkModulus density x t) →
        NumStability.LinearAcousticsSolution bulkModulus density
```

### D007: `NumStability.IsLinearAcousticsSolutionAt`

- Role: `local`
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `70a088e70ef907afe73263ead88df0a73c504c9f119be0476170e2033f5f744c`

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
- Owner module: `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `88e883c1fd1ab9463fb0831e3b5525699e3cb43599a2605ce17c794af6366b34`

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

Type:

```lean
{α : Type u_2} → [DenselyNormedField α] → NontriviallyNormedField α
```

Fully explicit type:

```lean
{α : Type u_2} → [DenselyNormedField.{u_2} α] → NontriviallyNormedField.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : DenselyNormedField α] => { toNormedField := inst.toNormedField, non_trivial := ⋯ }
```

### D011: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D012: `Eq`

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

### D013: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

Type:

```lean
{𝕜 : Type u} →
  [inst : NontriviallyNormedField 𝕜] →
    {F : Type v} →
      [inst_1 : AddCommGroup F] →
        [inst_2 : Module 𝕜 F] → [inst_3 : TopologicalSpace F] → [ContinuousSMul 𝕜 F] → (𝕜 → F) → F → 𝕜 → Prop
```

Fully explicit type:

```lean
{𝕜 : Type u} →
  [inst : NontriviallyNormedField.{u} 𝕜] →
    {F : Type v} →
      [inst_1 : AddCommGroup.{v} F] →
        [inst_2 :
            @Module.{u, v} 𝕜 F
              (@DivisionSemiring.toSemiring.{u} 𝕜
                (@Semifield.toDivisionSemiring.{u} 𝕜
                  (@Field.toSemifield.{u} 𝕜
                    (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
              (@AddCommGroup.toAddCommMonoid.{v} F inst_1)] →
          [inst_3 : TopologicalSpace.{v} F] →
            [@ContinuousSMul.{u, v} 𝕜 F
                  (@SMulZeroClass.toSMul.{u, v} 𝕜 F
                    (@AddZero.toZero.{v} F
                      (@AddZeroClass.toAddZero.{v} F
                        (@AddMonoid.toAddZeroClass.{v} F
                          (@SubNegMonoid.toAddMonoid.{v} F
                            (@AddGroup.toSubNegMonoid.{v} F (@AddCommGroup.toAddGroup.{v} F inst_1))))))
                    (@DistribSMul.toSMulZeroClass.{u, v} 𝕜 F
                      (@AddMonoid.toAddZeroClass.{v} F
                        (@SubNegMonoid.toAddMonoid.{v} F
                          (@AddGroup.toSubNegMonoid.{v} F (@AddCommGroup.toAddGroup.{v} F inst_1))))
                      (@DistribMulAction.toDistribSMul.{u, v} 𝕜 F
                        (@MonoidWithZero.toMonoid.{u} 𝕜
                          (@Semiring.toMonoidWithZero.{u} 𝕜
                            (@DivisionSemiring.toSemiring.{u} 𝕜
                              (@Semifield.toDivisionSemiring.{u} 𝕜
                                (@Field.toSemifield.{u} 𝕜
                                  (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                        (@SubNegMonoid.toAddMonoid.{v} F
                          (@AddGroup.toSubNegMonoid.{v} F (@AddCommGroup.toAddGroup.{v} F inst_1)))
                        (@Module.toDistribMulAction.{u, v} 𝕜 F
                          (@DivisionSemiring.toSemiring.{u} 𝕜
                            (@Semifield.toDivisionSemiring.{u} 𝕜
                              (@Field.toSemifield.{u} 𝕜
                                (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                          (@AddCommGroup.toAddCommMonoid.{v} F inst_1) inst_2))))
                  (@UniformSpace.toTopologicalSpace.{u} 𝕜
                    (@PseudoMetricSpace.toUniformSpace.{u} 𝕜
                      (@SeminormedRing.toPseudoMetricSpace.{u} 𝕜
                        (@SeminormedCommRing.toSeminormedRing.{u} 𝕜
                          (@NormedCommRing.toSeminormedCommRing.{u} 𝕜
                            (@NormedField.toNormedCommRing.{u} 𝕜
                              (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                  inst_3] →
              (f : 𝕜 → F) → (f' : F) → (x : 𝕜) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NontriviallyNormedField 𝕜] {F} [AddCommGroup F] [Module 𝕜 F] [TopologicalSpace F] [ContinuousSMul 𝕜 F] f f'
    x =>
  HasDerivAtFilter f f' (Filter.instSProd.sprod (nhds x) (Filter.instPure.pure x))
```

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

### D027: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

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

### D028: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `dc08b02d757cccbd21bce550b40d3f76d2ee704ec2cd7f5507023d827296474f`

Type:

```lean
{α : Type u_5} → [self : NontriviallyNormedField α] → NormedField α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NontriviallyNormedField.{u_5} α] → NormedField.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NontriviallyNormedField α] => self.1
```

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

### D031: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4aa3dba57859ca72552799005279a2b5a65b8c083980070fbbff11fd1de56dec`

Type:

```lean
{α : Type u_2} → [NormedField α] → NormedCommRing α
```

Fully explicit type:

```lean
{α : Type u_2} → [NormedField.{u_2} α] → NormedCommRing.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : NormedField α] =>
  let __src := inst;
  { toNorm := __src.toNorm, toRing := __src.toRing, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯,
    norm_mul_le := ⋯, mul_comm := ⋯ }
```

### D032: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Type:

```lean
{𝕜 : Type u_1} → [inst : NormedField 𝕜] → NormedSpace 𝕜 𝕜
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  [inst : NormedField.{u_1} 𝕜] →
    @NormedSpace.{u_1, u_1} 𝕜 𝕜 inst
      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{u_1} 𝕜
        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{u_1} 𝕜
          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{u_1} 𝕜
            (@NormedCommRing.toSeminormedCommRing.{u_1} 𝕜 (@NormedField.toNormedCommRing.{u_1} 𝕜 inst)))))
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NormedField 𝕜] => { toModule := Semiring.toModule, norm_smul_le := ⋯ }
```

### D033: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D034: `OfNat.ofNat`

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

### D035: `PseudoMetricSpace.toUniformSpace`

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

### D036: `Real`

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

### D037: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Type:

```lean
DenselyNormedField Real
```

Fully explicit type:

```lean
DenselyNormedField.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toNormedField := Real.normedField, lt_norm_lt := Real.denselyNormedField._proof_1 }
```

### D038: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D039: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D040: `Real.instLT`

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

### D041: `Real.instMonoid`

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

### D042: `Real.instMul`

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

### D043: `Real.instZero`

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

### D044: `Real.normedCommRing`

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

### D045: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D046: `Real.pseudoMetricSpace`

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

### D047: `Real.sqrt`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Sqrt`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D048: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

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

### D049: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e3cbc92d1d5e37d9eaeb1d595c83a78f7af7e3a8d249a700fa3676ab4e0c3d60`

Type:

```lean
{α : Type u_5} → [self : SeminormedCommRing α] → SeminormedRing α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : SeminormedCommRing.{u_5} α] → SeminormedRing.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : SeminormedCommRing α] => self.1
```

### D050: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `e6ea9296e8643d5ae7cf334c065c9d6ebe4a95de22d3b0708a585db80e17322a`

Type:

```lean
{α : Type u_5} → [self : SeminormedRing α] → PseudoMetricSpace α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : SeminormedRing.{u_5} α] → PseudoMetricSpace.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : SeminormedRing α] => self.3
```

### D051: `UniformSpace.toTopologicalSpace`

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

### D052: `Zero.toOfNat0`

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

### D053: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D061: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Type:

```lean
{α : Sort u} → (α → Prop) → Prop
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Prop
```

### D062: `HAdd.hAdd`

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

### D067: `ContinuousSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.MulAction`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `b36800b38dbbf71323d517896ed68ecf785e1c2dc2b52f5265b6b5be545cb4c1`

Type:

```lean
(M : Type u_1) → (X : Type u_2) → [SMul M X] → [TopologicalSpace M] → [TopologicalSpace X] → Prop
```

Fully explicit type:

```lean
(M : Type u_1) → (X : Type u_2) → [SMul.{u_1, u_2} M X] → [TopologicalSpace.{u_1} M] → [TopologicalSpace.{u_2} X] → Prop
```

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

## Complete local imported sources

### `NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`

Path: `NumStability/Analysis/PartialDifferentialEquations/ConstantCoefficientLinearSystem.lean`
SHA-256: `8e30275f872bc75df1944834277a7bfaa78b63ff1d0cb4fc617a22b8fb4d2526`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Data.Matrix.Basic

/-!
# Constant-coefficient first-order linear systems

Source-independent pointwise solution predicates for systems of the form
`q_t + A q_x = 0`, together with the canonical one-component matrix and state
used to recover scalar linear advection.
-/

namespace NumStability

/-- A function satisfies the constant-coefficient first-order system
`q_t + A q_x = 0` at a point. -/
def IsConstantCoefficientLinearSystemSolutionAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ)) (coefficient : Matrix ι ι ℝ)
    (x t : ℝ) : Prop :=
  ∃ qt qx : ι → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
        qt + coefficient.mulVec qx = 0

/-- A space-time state together with a proof that it solves one fixed
constant-coefficient linear system at every point. -/
structure ConstantCoefficientLinearSystemSolution
    {ι : Type*} [Fintype ι] (coefficient : Matrix ι ι ℝ) where
  state : ℝ → ℝ → (ι → ℝ)
  satisfies : ∀ x t,
    IsConstantCoefficientLinearSystemSolutionAt state coefficient x t

/-- The one-by-one matrix whose only coefficient is `speed`. -/
def constantCoefficientScalarMatrix (speed : ℝ) : Matrix (Fin 1) (Fin 1) ℝ :=
  fun _ _ => speed

/-- Regard a scalar space-time field as a one-component system state. -/
def scalarAsOneComponentSystem
    (q : ℝ → ℝ → ℝ) : ℝ → ℝ → (Fin 1 → ℝ) :=
  fun x t _ => q x t

end NumStability
```

### `NumStability.Analysis.PartialDifferentialEquations.LinearAdvection`

Path: `NumStability/Analysis/PartialDifferentialEquations/LinearAdvection.lean`
SHA-256: `c81a4b5ce8d9936d51f9aae7a02bc34db770b4d7213ac8c6581f5b577d11efe2`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Constant-coefficient linear advection

Source-independent local solution predicates and traveling-wave solutions for
`q_t + a q_x = 0`, for profiles valued in a real normed vector space.
-/

namespace NumStability

/-- A profile translated at constant speed. -/
def travelingWave {E : Type*} (profile : ℝ → E) (speed x t : ℝ) : E :=
  profile (x - speed * t)

/-- The translated profile agrees with the original profile at time zero. -/
@[simp] theorem travelingWave_zero {E : Type*}
    (profile : ℝ → E) (speed x : ℝ) :
    travelingWave profile speed x 0 = profile x := by
  simp [travelingWave]

/-- The value initially at `x` is at `x + speed * t` at time `t`. -/
theorem travelingWave_at_translated_point {E : Type*}
    (profile : ℝ → E) (speed x t : ℝ) :
    travelingWave profile speed (x + speed * t) t = profile x := by
  simp [travelingWave]

section LinearAdvection

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- A function satisfies `q_t + speed q_x = 0` at a point. -/
def IsLinearAdvectionSolutionAt
    (q : ℝ → ℝ → E) (speed x t : ℝ) : Prop :=
  ∃ qt qx : E,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
        qt + speed • qx = 0

/-- Every differentiable translated profile solves linear advection at the
corresponding point. -/
theorem travelingWave_isLinearAdvectionSolutionAt
    {profile : ℝ → E} {profile' : E} (speed x t : ℝ)
    (hprofile : HasDerivAt profile profile' (x - speed * t)) :
    IsLinearAdvectionSolutionAt
      (travelingWave profile speed) speed x t := by
  refine ⟨(-speed) • profile', profile', ?_, ?_, ?_⟩
  · have ht : HasDerivAt (fun τ : ℝ => x - speed * τ) (-speed) t := by
      simpa using
        (hasDerivAt_const t x).sub ((hasDerivAt_id t).const_mul speed)
    simpa [travelingWave, Function.comp_def] using hprofile.scomp t ht
  · have hx : HasDerivAt (fun ξ : ℝ => ξ - speed * t) 1 x := by
      simpa using (hasDerivAt_id x).sub_const (speed * t)
    simpa [travelingWave, Function.comp_def] using hprofile.scomp x hx
  · simp

end LinearAdvection

end NumStability
```

### `NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics`

Path: `NumStability/Analysis/PartialDifferentialEquations/LinearAcoustics.lean`
SHA-256: `640863d597faf04d52966cfd27f8d7732373c9c9d5c216a87308d5345da9d8b3`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.LinearAlgebra.Matrix.Notation
import NumStability.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import NumStability.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# One-dimensional linear acoustics

Source-independent pointwise and global solution data for the constant
coefficient pressure--velocity system, together with its two-component matrix
representation.
-/

namespace NumStability

/-- Pressure and particle velocity satisfy the one-dimensional linear
acoustics system at `(x,t)`. -/
def IsLinearAcousticsSolutionAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) : Prop :=
  ∃ pt px ut ux : ℝ,
    HasDerivAt (fun τ => pressure x τ) pt t ∧
      HasDerivAt (fun ξ => pressure ξ t) px x ∧
        HasDerivAt (fun τ => velocity x τ) ut t ∧
          HasDerivAt (fun ξ => velocity ξ t) ux x ∧
            pt + bulkModulus * ux = 0 ∧
              ut + density⁻¹ * px = 0

/-- A pressure--velocity field together with a global proof of the linear
acoustics equations for fixed material coefficients. -/
structure LinearAcousticsSolution (bulkModulus density : ℝ) where
  density_ne_zero : density ≠ 0
  pressure : ℝ → ℝ → ℝ
  velocity : ℝ → ℝ → ℝ
  satisfies : ∀ x t,
    IsLinearAcousticsSolutionAt pressure velocity bulkModulus density x t

/-- Package pressure and velocity as the two-component acoustics state. -/
def linearAcousticsState
    (pressure velocity : ℝ → ℝ → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  fun x t => ![pressure x t, velocity x t]

/-- The constant coefficient matrix of the one-dimensional linear acoustics
system. -/
noncomputable def linearAcousticsMatrix
    (bulkModulus density : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![(0 : ℝ), bulkModulus; density⁻¹, 0]

/-- The right-going characteristic combination of pressure and velocity. -/
def linearAcousticsRightInvariant
    (pressure velocity : ℝ → ℝ → ℝ) (density soundSpeed : ℝ) :
    ℝ → ℝ → ℝ :=
  fun x t => pressure x t + density * soundSpeed * velocity x t

/-- The left-going characteristic combination of pressure and velocity. -/
def linearAcousticsLeftInvariant
    (pressure velocity : ℝ → ℝ → ℝ) (density soundSpeed : ℝ) :
    ℝ → ℝ → ℝ :=
  fun x t => pressure x t - density * soundSpeed * velocity x t

/-- A right eigenvector of the acoustics matrix when `K = ρ c²`. -/
def linearAcousticsRightEigenvector
    (density soundSpeed : ℝ) : Fin 2 → ℝ :=
  ![density * soundSpeed, 1]

/-- A left eigenvector of the acoustics matrix when `K = ρ c²`. -/
def linearAcousticsLeftEigenvector
    (density soundSpeed : ℝ) : Fin 2 → ℝ :=
  ![-density * soundSpeed, 1]

/-- The right acoustics vector has eigenvalue `c`. -/
theorem linearAcousticsMatrix_mulVec_rightEigenvector
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    (linearAcousticsMatrix bulkModulus density).mulVec
        (linearAcousticsRightEigenvector density soundSpeed) =
      soundSpeed • linearAcousticsRightEigenvector density soundSpeed := by
  funext i
  fin_cases i <;>
    simp [linearAcousticsMatrix, linearAcousticsRightEigenvector,
      Matrix.mulVec, dotProduct, Fin.sum_univ_two, hmaterial, hdensity];
    ring

/-- The left acoustics vector has eigenvalue `-c`. -/
theorem linearAcousticsMatrix_mulVec_leftEigenvector
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    (linearAcousticsMatrix bulkModulus density).mulVec
        (linearAcousticsLeftEigenvector density soundSpeed) =
      (-soundSpeed) • linearAcousticsLeftEigenvector density soundSpeed := by
  funext i
  fin_cases i <;>
    simp [linearAcousticsMatrix, linearAcousticsLeftEigenvector,
      Matrix.mulVec, dotProduct, Fin.sum_univ_two, hmaterial, hdensity];
    ring

/-- The right characteristic combination satisfies scalar advection at the
positive acoustic speed whenever `K = ρ c²`. -/
theorem linearAcousticsRightInvariant_isLinearAdvectionSolutionAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density soundSpeed x t : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2)
    (hsystem : IsLinearAcousticsSolutionAt
      pressure velocity bulkModulus density x t) :
    IsLinearAdvectionSolutionAt
      (linearAcousticsRightInvariant pressure velocity density soundSpeed)
      soundSpeed x t := by
  rcases hsystem with
    ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
  refine ⟨pt + density * soundSpeed * ut,
    px + density * soundSpeed * ux, ?_, ?_, ?_⟩
  · simpa [linearAcousticsRightInvariant, mul_assoc] using
      hpt.add (hut.const_mul (density * soundSpeed))
  · simpa [linearAcousticsRightInvariant, mul_assoc] using
      hpx.add (hux.const_mul (density * soundSpeed))
  · rw [hmaterial] at hpressure
    field_simp [hdensity] at hvelocity
    dsimp
    calc
      pt + density * soundSpeed * ut +
          soundSpeed * (px + density * soundSpeed * ux) =
        (pt + density * soundSpeed ^ 2 * ux) +
          soundSpeed * (ut * density + px) := by ring
      _ = 0 := by rw [hpressure, hvelocity]; ring

/-- The left characteristic combination satisfies scalar advection at speed
`-c` whenever `K = ρ c²`. -/
theorem linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density soundSpeed x t : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2)
    (hsystem : IsLinearAcousticsSolutionAt
      pressure velocity bulkModulus density x t) :
    IsLinearAdvectionSolutionAt
      (linearAcousticsLeftInvariant pressure velocity density soundSpeed)
      (-soundSpeed) x t := by
  rcases hsystem with
    ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
  refine ⟨pt - density * soundSpeed * ut,
    px - density * soundSpeed * ux, ?_, ?_, ?_⟩
  · simpa [linearAcousticsLeftInvariant, mul_assoc] using
      hpt.sub (hut.const_mul (density * soundSpeed))
  · simpa [linearAcousticsLeftInvariant, mul_assoc] using
      hpx.sub (hux.const_mul (density * soundSpeed))
  · rw [hmaterial] at hpressure
    field_simp [hdensity] at hvelocity
    dsimp
    calc
      pt - density * soundSpeed * ut +
          -soundSpeed * (px - density * soundSpeed * ux) =
        (pt + density * soundSpeed ^ 2 * ux) -
          soundSpeed * (ut * density + px) := by ring
      _ = 0 := by rw [hpressure, hvelocity]; ring

/-- The two scalar acoustics equations are exactly their two-component
constant-matrix system representation. -/
theorem linearAcoustics_matrixForm_iff
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) :
    IsConstantCoefficientLinearSystemSolutionAt
        (linearAcousticsState pressure velocity)
        (linearAcousticsMatrix bulkModulus density) x t ↔
      IsLinearAcousticsSolutionAt
        pressure velocity bulkModulus density x t := by
  constructor
  · rintro ⟨qt, qx, ht, hx, hresidual⟩
    refine ⟨qt 0, qx 0, qt 1, qx 1, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp ht 0)
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp hx 0)
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp ht 1)
    · simpa [linearAcousticsState] using (hasDerivAt_pi.mp hx 1)
    · have hcomponent := congrFun hresidual (0 : Fin 2)
      simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two] using hcomponent
    · have hcomponent := congrFun hresidual (1 : Fin 2)
      simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
        Fin.sum_univ_two] using hcomponent
  · rintro ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
    refine ⟨![pt, ut], ![px, ux], ?_, ?_, ?_⟩
    · rw [hasDerivAt_pi]
      intro i
      fin_cases i
      · simpa [linearAcousticsState] using hpt
      · simpa [linearAcousticsState] using hut
    · rw [hasDerivAt_pi]
      intro i
      fin_cases i
      · simpa [linearAcousticsState] using hpx
      · simpa [linearAcousticsState] using hux
    · funext i
      fin_cases i
      · simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two, mul_comm] using hpressure
      · simpa [linearAcousticsMatrix, Matrix.mulVec, dotProduct,
          Fin.sum_univ_two, mul_comm] using hvelocity

end NumStability
```

### `NumStability.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation`

Path: `NumStability/Analysis/PartialDifferentialEquations/LinearAcousticsWaveEquation.lean`
SHA-256: `31acbb4b69dad9716b91efec714f779e1b1c461d8d6fa316b286c72b9fecd62f`

```lean
/-
SPDX-License-Identifier: MIT
-/

import NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# The pressure wave equation from linear acoustics

This module makes the second-derivative and mixed-partial assumptions explicit
when eliminating velocity from the first-order acoustics system.
-/

namespace NumStability

/-- Classical partial derivative in the time coordinate. -/
noncomputable def partialTimeDerivative
    (field : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  deriv (fun τ => field x τ) t

/-- Classical partial derivative in the space coordinate. -/
noncomputable def partialSpaceDerivative
    (field : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  deriv (fun ξ => field ξ t) x

/-- Differentiating the two global first-order acoustic equations and equating
the mixed derivatives gives the scalar second-order pressure wave equation. -/
theorem LinearAcousticsSolution.pressureSecondOrderWaveAt
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density)
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
    ptt = (bulkModulus / density) * pxx := by
  have hfirst (s : ℝ) :
      partialTimeDerivative system.pressure x s +
          bulkModulus * partialSpaceDerivative system.velocity x s = 0 := by
    rcases system.satisfies x s with
      ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
    simpa [partialTimeDerivative, partialSpaceDerivative,
      hpt.deriv, hux.deriv] using hpressure
  have hsecond (y : ℝ) :
      partialTimeDerivative system.velocity y t +
          density⁻¹ * partialSpaceDerivative system.pressure y t = 0 := by
    rcases system.satisfies y t with
      ⟨pt, px, ut, ux, hpt, hpx, hut, hux, hpressure, hvelocity⟩
    simpa [partialTimeDerivative, partialSpaceDerivative,
      hut.deriv, hpx.deriv] using hvelocity
  have hfirstDerivative : ptt + bulkModulus * uxt = 0 := by
    have hsum := hptt.add (huxt.const_mul bulkModulus)
    have hzero : HasDerivAt (fun _ : ℝ => 0)
        (ptt + bulkModulus * uxt) t :=
      hsum.congr_of_eventuallyEq
        (Filter.Eventually.of_forall fun s => (hfirst s).symm)
    exact hzero.unique (hasDerivAt_const t 0)
  have hsecondDerivative : utx * density + pxx = 0 := by
    have hsum := hutx.add (hpxx.const_mul density⁻¹)
    have hzero : HasDerivAt (fun _ : ℝ => 0)
        (utx + density⁻¹ * pxx) x :=
      hsum.congr_of_eventuallyEq
        (Filter.Eventually.of_forall fun y => (hsecond y).symm)
    have hraw : utx + density⁻¹ * pxx = 0 :=
      hzero.unique (hasDerivAt_const x 0)
    field_simp [system.density_ne_zero] at hraw
    simpa using hraw
  rw [hmixed] at hfirstDerivative
  field_simp [system.density_ne_zero]
  linear_combination
    density * hfirstDerivative - bulkModulus * hsecondDerivative

end NumStability
```

### `NumStability.Source.LeVeque.Chapter01.Equation05`

Path: `NumStability/Source/LeVeque/Chapter01/Equation05.lean`
SHA-256: `426c914d7a53540185a3fa66a2e319285db30d9eaf81a8da28ee21b5ca0bf67b`

```lean
/-
SPDX-License-Identifier: MIT
-/

import NumStability.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# LeVeque Chapter 1, Equation (1.5)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24), equation (1.5).
-/

namespace NumStability

/-- Equation (1.5), as a pointwise pressure--velocity residual. -/
abbrev leveque01_equation05_linearAcousticsAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) : Prop :=
  IsLinearAcousticsSolutionAt
    pressure velocity bulkModulus density x t

/-- Equation (1.5): a proof-carrying acoustic field has nonzero density and
satisfies both displayed equations globally. -/
theorem leveque01_equation05_linearAcoustics
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density) :
    density ≠ 0 ∧
      ∀ x t, ∃ pt px ut ux : ℝ,
        HasDerivAt (fun τ => system.pressure x τ) pt t ∧
          HasDerivAt (fun ξ => system.pressure ξ t) px x ∧
            HasDerivAt (fun τ => system.velocity x τ) ut t ∧
              HasDerivAt (fun ξ => system.velocity ξ t) ux x ∧
                pt + bulkModulus * ux = 0 ∧
                  ut + density⁻¹ * px = 0 := by
  refine ⟨system.density_ne_zero, ?_⟩
  intro x t
  exact system.satisfies x t

end NumStability
```
