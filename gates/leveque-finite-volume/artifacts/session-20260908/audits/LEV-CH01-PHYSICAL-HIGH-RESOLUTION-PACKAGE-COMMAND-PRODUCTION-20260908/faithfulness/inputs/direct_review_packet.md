# Declaration dossier for LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_coordinateHighResolutionMethods_sourceContract
    (hm : 0 < m) (hD : 0 < Fintype.card D)
    (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m)
    (quality : family.HasHighResolution) (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → Fin m → ℝ)
    (initial : family.Cell level → Fin m → ℝ) (steps : ℕ)
    (hschedule : ∀ d : D, ∃ k < steps, direction k = d)
    (hvalid : NumStability.PhysicalHighResolutionSweep.ValidSubsteps family level direction duration ghost initial steps) :
    0 < m ∧ 0 < Fintype.card D ∧
      NumStability.PhysicalHighResolutionSweep.Specification family level direction duration ghost initial steps ∧
      NumStability.PhysicalHighResolutionSweep.ValidSubsteps family level direction duration ghost initial steps
```

## Elaborated target type

```lean
∀ {D : Type u_1} {FacePoint : Type u_2} [inst : Fintype D] [inst_1 : DecidableEq D] [inst_2 : MeasurableSpace FacePoint]
  {m : Nat},
  instLTNat.lt 0 m →
    instLTNat.lt 0 (Fintype.card D) →
      ∀ (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m),
        family.HasHighResolution →
          ∀ (level : Nat) (direction : Nat → D) (duration : Nat → Real)
            (ghost : Nat → D → family.Line level → Int → Fin m → Real) (initial : family.Cell level → Fin m → Real)
            (steps : Nat),
            (∀ (d : D), Exists fun k => And (instLTNat.lt k steps) (Eq (direction k) d)) →
              NumStability.PhysicalHighResolutionSweep.ValidSubsteps family level direction duration ghost initial
                  steps →
                And (instLTNat.lt 0 m)
                  (And (instLTNat.lt 0 (Fintype.card D))
                    (And
                      (NumStability.PhysicalHighResolutionSweep.Specification family level direction duration ghost
                        initial steps)
                      (NumStability.PhysicalHighResolutionSweep.ValidSubsteps family level direction duration ghost
                        initial steps)))
```

## Fully explicit elaborated target type

```lean
∀ {D : Type u_1} {FacePoint : Type u_2} [inst : Fintype.{u_1} D] [inst_1 : DecidableEq.{u_1 + 1} D]
  [inst_2 : MeasurableSpace.{u_2} FacePoint] {m : Nat}
  (hm : @LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
  (hD :
    @LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) (@Fintype.card.{u_1} D inst))
  (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_2 m)
  (quality :
    @NumStability.PhysicalRefinementQuality.Family.HasHighResolution.{u_1, u_2} D FacePoint inst inst_2 m family)
  (level : Nat) (direction : Nat → D) (duration : Nat → Real)
  (ghost :
    Nat →
      D →
        @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family level →
          Int → Fin m → Real)
  (initial :
    @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level →
      Fin m → Real)
  (steps : Nat)
  (hschedule :
    ∀ (d : D),
      @Exists.{1} Nat fun (k : Nat) => And (@LT.lt.{0} Nat instLTNat k steps) (@Eq.{u_1 + 1} D (direction k) d))
  (hvalid :
    @NumStability.PhysicalHighResolutionSweep.ValidSubsteps.{u_1, u_2} D FacePoint inst inst_2 m family level direction
      duration ghost initial steps),
  And (@LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
    (And
      (@LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))
        (@Fintype.card.{u_1} D inst))
      (And
        (@NumStability.PhysicalHighResolutionSweep.Specification.{u_1, u_2} D FacePoint inst inst_1 inst_2 m family
          level direction duration ghost initial steps)
        (@NumStability.PhysicalHighResolutionSweep.ValidSubsteps.{u_1, u_2} D FacePoint inst inst_2 m family level
          direction duration ghost initial steps)))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep`
- `ComputationalMathematics.Analysis.Normed.Group.SequentialError` imports: `Mathlib.Algebra.Order.Ring.Pow`, `Mathlib.Analysis.Normed.Group.Basic`, `Mathlib.Tactic.Linarith`, `Mathlib.Tactic.NormNum`, `Mathlib.Tactic.Push`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates` imports: `Mathlib.Analysis.Normed.Group.Constructions`, `Mathlib.Analysis.Normed.Group.Real`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `Mathlib.Analysis.Calculus.FDeriv.Basic`, `Mathlib.Analysis.Calculus.FDeriv.Const`, `Mathlib.LinearAlgebra.Matrix.ToLin`, `Mathlib.LinearAlgebra.StdBasis`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.MeasureTheory.Integral.Average`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Tactic.Module`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting` imports: `Mathlib.Data.List.Basic`, `Mathlib.Data.Real.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalLineCapacity` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate`, `Mathlib.Tactic.NormNum`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalLineCapacity`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalFluxError` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateSweep` imports: `ComputationalMathematics.Analysis.Normed.Group.SequentialError`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalFluxError`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`, `Mathlib.MeasureTheory.Measure.Lebesgue.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCellProjection` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage`, `Mathlib.MeasureTheory.Integral.Pi`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference` imports: `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.Module`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`, `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianGeometry` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`, `Mathlib.MeasureTheory.Integral.Pi`, `Mathlib.Topology.Instances.Int`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCellProjection`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianGeometry`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineVariation` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`, `Mathlib.Algebra.BigOperators.Ring.Finset`, `Mathlib.Algebra.Order.BigOperators.Group.Finset`, `Mathlib.Tactic.Linarith`, `Mathlib.Tactic.NormNum`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCellMesh` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage`, `Mathlib.Data.Finset.Lattice.Fold`, `Mathlib.Topology.MetricSpace.Bounded`
- `Mathlib.Analysis.Calculus.ContDiff.Defs` imports: none
- `Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries` imports: none
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineVariation`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalFluxError`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCellMesh`, `Mathlib.Analysis.Calculus.ContDiff.Defs`, `Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateSweep`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.PhysicalHighResolutionSweep.Specification`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `b4d8678ff35e53c10d208b41b2dffbd3855c40b957981f2595dcf6e6e2fbac09`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [DecidableEq D] →
        [inst_2 : MeasurableSpace FacePoint] →
          {m : Nat} →
            (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
              (level : Nat) →
                (Nat → D) →
                  (Nat → Real) →
                    (Nat → D → family.Line level → Int → Fin m → Real) → (family.Cell level → Fin m → Real) → Nat → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [DecidableEq.{u_1 + 1} D] →
        [inst_2 : MeasurableSpace.{u_2} FacePoint] →
          {m : Nat} →
            (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_2 m) →
              (level : Nat) →
                (direction : Nat → D) →
                  (duration : Nat → Real) →
                    (ghost :
                        Nat →
                          D →
                            @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m
                                family level →
                              Int → Fin m → Real) →
                      (initial :
                          @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                              family level →
                            Fin m → Real) →
                        (steps : Nat) → Prop
```

### D002: `NumStability.PhysicalHighResolutionSweep.ValidSubsteps`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `661610011867c9966a8cb66b4f243b15ab10bcbdf527008ae5b092bbbb74f10e`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (level : Nat) →
              (Nat → D) →
                (Nat → Real) →
                  (Nat → D → family.Line level → Int → Fin m → Real) → (family.Cell level → Fin m → Real) → Nat → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m) →
            (level : Nat) →
              (direction : Nat → D) →
                (duration : Nat → Real) →
                  (ghost :
                      Nat →
                        D →
                          @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m
                              family level →
                            Int → Fin m → Real) →
                    (initial :
                        @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family
                            level →
                          Fin m → Real) →
                      (steps : Nat) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {D} {FacePoint} [Fintype D] [MeasurableSpace FacePoint] {m} family level direction duration ghost initial steps =>
  ∀ (k : Nat),
    instLTNat.lt k steps →
      And (Real.instLT.lt 0 (duration k))
        (And (Real.instLE.le (duration k) family.horizon)
          ((NumStability.PhysicalHighResolutionSweep.method family level ghost k).Admitted (direction k) (duration k)
            (NumStability.PhysicalHighResolutionSweep.execution family level direction duration ghost initial k)))
```

### D003: `NumStability.PhysicalRefinementQuality.Family`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `4620b892eafeb1a80bf5a129e919f124658e3b9da6038d258ee3aab9152e0c5f`

Type:

```lean
(D : Type u_3) → (FacePoint : Type u_4) → [Fintype D] → [MeasurableSpace FacePoint] → Nat → Type (max (max 1 u_3) u_4)
```

Fully explicit type:

```lean
(D : Type u_3) →
  (FacePoint : Type u_4) →
    [Fintype.{u_3} D] → [MeasurableSpace.{u_4} FacePoint] → (m : Nat) → Type (max (max 1 u_3) u_4)
```

### D004: `NumStability.PhysicalRefinementQuality.Family.Cell`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `d817f9a50f775b70fce7b9533c6c705757028d9a47bbe114e7fa76cdd40cbeb5`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} → NumStability.PhysicalRefinementQuality.Family D FacePoint m → Nat → Type
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) → Nat → Type
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.1
```

### D005: `NumStability.PhysicalRefinementQuality.Family.HasHighResolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `4bb2c31d633a3ff478ce137beefd822c260baf929f4e58a87c9369375b9e2dc8`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} → NumStability.PhysicalRefinementQuality.Family D FacePoint m → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m) → Prop
```

### D006: `NumStability.PhysicalRefinementQuality.Family.Line`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `9ae1b53e76208b7a2a3c0f87fe1646b60a434e80140235aa5899fb7727d79965`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} → NumStability.PhysicalRefinementQuality.Family D FacePoint m → Nat → Type
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) → Nat → Type
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.3
```

### D007: `NumStability.CapacityCoordinate.Method.Admitted`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `192673b4e279cc7ebf66319fc8d8ff8cec9f75ecc675399fedbbb80357e1a29e`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        NumStability.CapacityCoordinate.Method data coord → D → Real → (Cell → Fin m → Real) → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        (method :
                            @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point
                              FacePoint Line inst inst_1 inst_2 m data coord) →
                          (d : D) → (dt : Real) → (current : Cell → Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} {data} {coord} method d dt current =>
  ∀ (cell : Cell), method.admitted d (coord.cellLine d cell) dt (coord.extract d (coord.cellLine d cell) current)
```

### D008: `NumStability.PhysicalHighResolutionSweep.Specification.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `554d7aa87b42c78b9a7f4057b929a2553be58a20a53b08009b0f00f0bd15724d`

Type:

```lean
∀ {D : Type u_1} {FacePoint : Type u_2} [inst : Fintype D] [inst_1 : DecidableEq D] [inst_2 : MeasurableSpace FacePoint]
  {m : Nat} {family : NumStability.PhysicalRefinementQuality.Family D FacePoint m} {level : Nat} {direction : Nat → D}
  {duration : Nat → Real} {ghost : Nat → D → family.Line level → Int → Fin m → Real}
  {initial : family.Cell level → Fin m → Real} {steps : Nat},
  family.HasHighResolution →
    (∀ (d : D), Exists fun k => And (instLTNat.lt k steps) (Eq (direction k) d)) →
      (∀ (k : Nat),
          instLENat.le k steps →
            Eq (NumStability.PhysicalHighResolutionSweep.execution family level direction duration ghost initial k)
              (NumStability.orderedOperatorSweep
                (List.map
                  (NumStability.CapacityCoordinate.Sweep.step
                    (NumStability.PhysicalHighResolutionSweep.method family level ghost) direction duration)
                  (List.range k))
                initial)) →
        (∀ (k : Nat),
            instLTNat.lt k steps →
              ∀ (cell : family.Cell level),
                Eq
                  (NumStability.PhysicalHighResolutionSweep.execution family level direction duration ghost initial
                    (instHAdd.hAdd k 1) cell)
                  (NumStability.FiniteCoordinate.PhysicalLine.lineAdvance (family.data level) (family.coordinates level)
                    (family.method level).numericalFlux (direction k)
                    ((family.coordinates level).cellLine (direction k) cell) (duration k)
                    (((family.coordinates level).withGhost (ghost k)).extract (direction k)
                      ((family.coordinates level).cellLine (direction k) cell)
                      (NumStability.PhysicalHighResolutionSweep.execution family level direction duration ghost initial
                        k))
                    ((family.coordinates level).cellIndex (direction k) cell))) →
          (∀ (k : Nat),
              instLTNat.lt k steps →
                Eq
                  (Finset.univ.sum fun cell =>
                    instHSMul.hSMul ((family.data level).cellVolume cell)
                      (NumStability.PhysicalHighResolutionSweep.execution family level direction duration ghost initial
                        (instHAdd.hAdd k 1) cell))
                  (instHSub.hSub
                    (Finset.univ.sum fun cell =>
                      instHSMul.hSMul ((family.data level).cellVolume cell)
                        (NumStability.PhysicalHighResolutionSweep.execution family level direction duration ghost
                          initial k cell))
                    (instHSMul.hSMul (duration k)
                      (Finset.univ.sum fun cell =>
                        instHSub.hSub
                          ((NumStability.PhysicalHighResolutionSweep.method family level ghost k).rule (direction k)
                            (duration k)
                            (NumStability.PhysicalHighResolutionSweep.execution family level direction duration ghost
                              initial k)
                            ((family.data level).rightFace (direction k) cell))
                          ((NumStability.PhysicalHighResolutionSweep.method family level ghost k).rule (direction k)
                            (duration k)
                            (NumStability.PhysicalHighResolutionSweep.execution family level direction duration ghost
                              initial k)
                            ((family.data level).leftFace (direction k) cell)))))) →
            (∀ (k : Nat),
                instLTNat.lt k steps →
                  ∀ (cell : family.Cell level) (current other : family.Cell level → Fin m → Real),
                    (∀ (c : family.Cell level),
                        Eq ((family.coordinates level).cellLine (direction k) c)
                            ((family.coordinates level).cellLine (direction k) cell) →
                          Eq (current c) (other c)) →
                      Eq
                        (NumStability.FiniteCoordinate.advance (family.data level)
                          (NumStability.PhysicalHighResolutionSweep.method family level ghost k).rule (direction k)
                          (duration k) current cell)
                        (NumStability.FiniteCoordinate.advance (family.data level)
                          (NumStability.PhysicalHighResolutionSweep.method family level ghost k).rule (direction k)
                          (duration k) other cell)) →
              (∀ (d : D) (q : (D → Real) → Real → Fin m → Real) (p : Real)
                  (certificate : family.AccuracyCertificate d q p) (n : Nat),
                  instLENat.le certificate.threshold n →
                    ∀ (dt : Real),
                      Real.instLT.lt 0 dt →
                        Real.instLE.le dt family.horizon →
                          ∀ (boundary : D → family.Line n → Int → Fin m → Real)
                            (current : family.Cell n → Fin m → Real),
                            ((family.method n).withGhost boundary).Admitted d dt current →
                              ((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
                                  (family.projected n q 0) →
                                ∀ (A E G : Real),
                                  (family.method n).StableAt d dt A →
                                    (∀ (cell : family.Cell n),
                                        Real.instLE.le
                                          (Pi.normedRing.norm
                                            (instHSub.hSub (current cell) (family.projected n q 0 cell)))
                                          E) →
                                      (∀ (cell : family.Cell n) (j : Int),
                                          Eq
                                              ((family.coordinates n).lookup d ((family.coordinates n).cellLine d cell)
                                                j)
                                              Option.none →
                                            Real.instLE.le
                                              (Pi.normedRing.norm
                                                (instHSub.hSub (boundary d ((family.coordinates n).cellLine d cell) j)
                                                  (family.referenceGhost n q d ((family.coordinates n).cellLine d cell)
                                                    j)))
                                              G) →
                                        ∀ (cell : family.Cell n),
                                          Real.instLE.le
                                            (Pi.normedRing.norm
                                              (instHSub.hSub
                                                (NumStability.FiniteCoordinate.advance (family.data n)
                                                  ((family.method n).withGhost boundary).rule d dt current cell)
                                                (family.projected n q dt cell)))
                                            (instHAdd.hAdd (instHMul.hMul A (Real.instMax.max E G))
                                              (instHMul.hMul (instHMul.hMul certificate.constant dt)
                                                (instHPow.hPow (family.mesh n) p)))) →
                (∀ (physical : Nat → (D → Real) → Real → Fin m → Real)
                    (amplification localDefect splittingDefect : Nat → Real) (initialError : Real)
                    (netError : Nat → family.Cell level → Real),
                    (∀ (k : Nat), instLTNat.lt k steps → Real.instLT.lt 0 (duration k)) →
                      (∀ (k : Nat),
                          instLTNat.lt k steps →
                            (family.data level).ReferenceOn (direction k) (physical k) 0 (duration k)) →
                        (∀ (cell : family.Cell level),
                            Real.instLE.le
                              (Pi.normedRing.norm
                                (instHSub.hSub (initial cell) ((family.data level).cellMean (physical 0) cell 0)))
                              initialError) →
                          (∀ (k : Nat),
                              instLTNat.lt k steps →
                                (NumStability.PhysicalHighResolutionSweep.method family level ghost k).Admitted
                                  (direction k) (duration k)
                                  (NumStability.PhysicalHighResolutionSweep.execution family level direction duration
                                    ghost initial k)) →
                            (∀ (k : Nat),
                                instLTNat.lt k steps →
                                  (NumStability.PhysicalHighResolutionSweep.method family level ghost k).Admitted
                                    (direction k) (duration k) fun cell =>
                                    (family.data level).cellMean (physical k) cell 0) →
                              (∀ (k : Nat),
                                  instLTNat.lt k steps →
                                    (NumStability.PhysicalHighResolutionSweep.method family level ghost k).StableAt
                                      (direction k) (duration k) (amplification k)) →
                                (∀ (k : Nat),
                                    instLTNat.lt k steps →
                                      ∀ (cell : family.Cell level),
                                        Real.instLE.le
                                          (Pi.normedRing.norm
                                            (NumStability.FiniteCoordinate.netFluxDefect (family.data level)
                                              (NumStability.PhysicalHighResolutionSweep.method family level ghost
                                                  k).rule
                                              (direction k) (fun c => (family.data level).cellMean (physical k) c 0)
                                              (physical k) 0 (duration k) cell))
                                          (netError k cell)) →
                                  (∀ (k : Nat),
                                      instLTNat.lt k steps →
                                        ∀ (cell : family.Cell level),
                                          Real.instLE.le
                                            (instHMul.hMul
                                              (instHDiv.hDiv (duration k) ((family.data level).cellVolume cell))
                                              (netError k cell))
                                            (localDefect k)) →
                                    (∀ (k : Nat),
                                        instLTNat.lt k steps →
                                          ∀ (cell : family.Cell level),
                                            Real.instLE.le
                                              (Pi.normedRing.norm
                                                (instHSub.hSub
                                                  ((family.data level).cellMean (physical k) cell (duration k))
                                                  ((family.data level).cellMean (physical (instHAdd.hAdd k 1)) cell 0)))
                                              (splittingDefect k)) →
                                      ∀ (k : Nat),
                                        instLENat.le k steps →
                                          ∀ (cell : family.Cell level),
                                            Real.instLE.le
                                              (Pi.normedRing.norm
                                                (instHSub.hSub
                                                  (NumStability.PhysicalHighResolutionSweep.execution family level
                                                    direction duration ghost initial k cell)
                                                  ((family.data level).cellMean (physical k) cell 0)))
                                              (NumStability.SequentialError.errorBudget amplification localDefect
                                                splittingDefect initialError k)) →
                  (∀ (axes : D → NumStability.OneDimensionalFiniteVolumeGrid)
                      (cellPosition : family.Cell level → D → Int) (facePosition : D → family.Face level → D → Int)
                      (flux : D → (Fin m → Real) → Fin m → Real),
                      NumStability.FiniteCartesian.CartesianIdentification (family.data level) axes cellPosition
                          facePosition flux →
                        And
                          (∀ (cell : family.Cell level),
                            Eq ((family.data level).cellVolume cell)
                              (NumStability.CartesianGrid.cellVolume axes (cellPosition cell)))
                          (And
                            (∀ (q : (D → Real) → Real → Fin m → Real) (cell : family.Cell level) (t : Real),
                              Eq ((family.data level).cellMean q cell t)
                                (NumStability.cellVolumeAverage MeasureTheory.MeasureSpace.pi.volume
                                  (NumStability.CartesianGrid.cellBox axes (cellPosition cell)) fun x => q x t))
                            (And
                              (∀ (q : Real → Real → Fin m → Real) (d : D) (face : family.Face level) (t : Real),
                                Eq ((family.data level).faceFlux d (fun x τ => q (x d) τ) face t)
                                  (instHSMul.hSMul (NumStability.CartesianGrid.faceArea axes d (facePosition d face))
                                    (flux d (q ((axes d).cellLeft (facePosition d face d)) t))))
                              (∀ (q : Real → Real → Fin m → Real) (d : D),
                                NumStability.IsRectangleConservationLawSolution q (flux d) →
                                  ∀ (cell : family.Cell level) (s t : Real),
                                    Eq
                                      (instHSMul.hSMul ((family.data level).cellVolume cell)
                                        (instHSub.hSub ((family.data level).cellMean (fun x τ => q (x d) τ) cell t)
                                          ((family.data level).cellMean (fun x τ => q (x d) τ) cell s)))
                                      (intervalIntegral
                                        (fun τ =>
                                          instHSub.hSub
                                            ((family.data level).faceFlux d (fun x σ => q (x d) σ)
                                              ((family.data level).leftFace d cell) τ)
                                            ((family.data level).faceFlux d (fun x σ => q (x d) σ)
                                              ((family.data level).rightFace d cell) τ))
                                        s t Real.measureSpace.volume))))) →
                    NumStability.PhysicalHighResolutionSweep.Specification family level direction duration ghost initial
                      steps
```

Fully explicit type:

```lean
∀ {D : ⋯} {FacePoint : ⋯} [inst : ⋯] [inst_1 : ⋯] [inst_2 : ⋯] {m : ⋯} {family : ⋯} {level : ⋯} {direction : ⋯}
  {duration : ⋯} {ghost : ⋯} {initial : ⋯} {steps : ⋯} (quality : ⋯) (schedule : ⋯) (ordered : ⋯) (constituent : ⋯)
  (conservative :
    ∀ (k : ⋯),
      ⋯ →
        @Eq.{1} (Fin m → Real)
          (@Finset.sum.{0, 0}
            (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
            (Fin m → Real)
            (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
            (@Finset.univ.{0}
              (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
              (@NumStability.PhysicalRefinementQuality.Family.finiteCell.{u_1, u_2} D FacePoint inst inst_2 m family
                level))
            fun
              (cell :
                @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                  level) =>
            @HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
              (@instHSMul.{0, 0} Real (Fin m → Real)
                (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                    (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                    (@Algebra.id.{0} Real Real.instCommSemiring))))
              (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, 0, 0, u_1, u_2} D
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (D → Real) FacePoint
                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                inst_2 m
                (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family level)
                cell)
              (@NumStability.PhysicalHighResolutionSweep.execution.{u_1, u_2} D FacePoint inst inst_2 m family level
                direction duration ghost initial
                (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) k
                  (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1))))
                cell))
          (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
            (@instHSub.{0} (Fin m → Real)
              (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
            (@Finset.sum.{0, 0}
              (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
              (Fin m → Real)
              (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
              (@Finset.univ.{0}
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (@NumStability.PhysicalRefinementQuality.Family.finiteCell.{u_1, u_2} D FacePoint inst inst_2 m family
                  level))
              fun
                (cell :
                  @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                    level) =>
              @HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                (@instHSMul.{0, 0} Real (Fin m → Real)
                  (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                    (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                      (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                      (@Algebra.id.{0} Real Real.instCommSemiring))))
                (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, 0, 0, u_1, u_2} D
                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (D → Real) FacePoint
                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  inst_2 m
                  (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  cell)
                (@NumStability.PhysicalHighResolutionSweep.execution.{u_1, u_2} D FacePoint inst inst_2 m family level
                  direction duration ghost initial k cell))
            (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
              (@instHSMul.{0, 0} Real (Fin m → Real)
                (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                    (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                    (@Algebra.id.{0} Real Real.instCommSemiring))))
              (duration k)
              (@Finset.sum.{0, 0}
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (Fin m → Real)
                (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instAddCommMonoid)
                (@Finset.univ.{0}
                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (@NumStability.PhysicalRefinementQuality.Family.finiteCell.{u_1, u_2} D FacePoint inst inst_2 m family
                    level))
                fun (cell : ⋯) =>
                @HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                  (@instHSub.{0} (Fin m → Real)
                    (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                  (@NumStability.CapacityCoordinate.Method.rule.{u_1, 0, 0, u_1, u_2, 0} D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (D → Real) FacePoint
                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                      @UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    inst_2 m
                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalHighResolutionSweep.coordinates.{u_1, u_2} D FacePoint inst inst_2 m family
                      level ghost k)
                    (@NumStability.PhysicalHighResolutionSweep.method.{u_1, u_2} D FacePoint inst inst_2 m family level
                      ghost k)
                    (direction k) (duration k)
                    (@NumStability.PhysicalHighResolutionSweep.execution.{u_1, u_2} D FacePoint inst inst_2 m family
                      level direction duration ghost initial k)
                    (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, 0, 0, u_1, u_2} D
                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (D → Real) FacePoint
                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      inst_2 m
                      (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (direction k) cell))
                  (@NumStability.CapacityCoordinate.Method.rule.{u_1, 0, 0, u_1, u_2, 0} D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (D → Real) FacePoint
                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                      @UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    inst_2 m
                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalHighResolutionSweep.coordinates.{u_1, u_2} D FacePoint inst inst_2 m family
                      level ghost k)
                    (@NumStability.PhysicalHighResolutionSweep.method.{u_1, u_2} D FacePoint inst inst_2 m family level
                      ghost k)
                    (direction k) (duration k)
                    (@NumStability.PhysicalHighResolutionSweep.execution.{u_1, u_2} D FacePoint inst inst_2 m family
                      level direction duration ghost initial k)
                    (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, 0, 0, u_1, u_2} D
                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (D → Real) FacePoint
                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : ⋯) => ⋯) ⋯) ⋯ ⋯ ⋯ ⋯ ⋯))))))
  (line_local :
    ∀ (k : Nat),
      @LT.lt.{0} Nat instLTNat k steps →
        ∀ (cell : @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
          (current other :
            @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level →
              Fin m → Real),
          (∀
              (c :
                @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level),
              @Eq.{1}
                  (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, 0, 0, 0} m D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst inst_2 m
                      family level)
                    (direction k) c)
                  (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, 0, 0, 0} m D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst inst_2 m
                      family level)
                    (direction k) cell) →
                @Eq.{1} (Fin m → Real) (current c) (other c)) →
            @Eq.{1} (Fin m → Real)
              (@NumStability.FiniteCoordinate.advance.{u_1, 0, 0, u_1, u_2} D
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (D → Real) FacePoint
                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                inst_2 m
                (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (@NumStability.CapacityCoordinate.Method.rule.{u_1, 0, 0, u_1, u_2, 0} D
                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (D → Real) FacePoint
                  (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  inst_2 m
                  (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (@NumStability.PhysicalHighResolutionSweep.coordinates.{u_1, u_2} D FacePoint inst inst_2 m family
                    level ghost k)
                  (@NumStability.PhysicalHighResolutionSweep.method.{u_1, u_2} D FacePoint inst inst_2 m family level
                    ghost k))
                (direction k) (duration k) current cell)
              (@NumStability.FiniteCoordinate.advance.{u_1, 0, 0, u_1, u_2} D
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (D → Real) FacePoint
                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                inst_2 m
                (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (@NumStability.CapacityCoordinate.Method.rule.{u_1, 0, 0, u_1, u_2, 0} D
                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (D → Real) FacePoint
                  (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  inst_2 m
                  (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (@NumStability.PhysicalHighResolutionSweep.coordinates.{u_1, u_2} D FacePoint inst inst_2 m family
                    level ghost k)
                  (@NumStability.PhysicalHighResolutionSweep.method.{u_1, u_2} D FacePoint inst inst_2 m family level
                    ghost k))
                (direction k) (duration k) other cell))
  (accuracy :
    ∀ (d : D) (q : (D → Real) → Real → Fin m → Real) (p : Real)
      (certificate :
        @NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.{u_1, u_2} D FacePoint inst inst_2 m family d
          q p)
      (n : Nat),
      @LE.le.{0} Nat instLENat
          (@NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.threshold.{u_1, u_2} D FacePoint inst
            inst_2 m family d q p certificate)
          n →
        ∀ (dt : Real),
          @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) dt →
            @LE.le.{0} Real Real.instLE dt
                (@NumStability.PhysicalRefinementQuality.Family.horizon.{u_1, u_2} D FacePoint inst inst_2 m family) →
              ∀
                (boundary :
                  D →
                    @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family n →
                      Int → Fin m → Real)
                (current :
                  @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family n →
                    Fin m → Real),
                @NumStability.CapacityCoordinate.Method.Admitted.{u_1, 0, 0, u_1, u_2, 0} D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family n)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family n)
                    (D → Real) FacePoint
                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family n)
                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                      @UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    inst_2 m
                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family n)
                    (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, 0, 0, 0} D
                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      m
                      (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst inst_2 m
                        family n)
                      boundary)
                    (@NumStability.CapacityCoordinate.Method.withGhost.{u_1, 0, 0, u_1, u_2, 0} D
                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      (D → Real) FacePoint
                      (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      inst_2 m
                      (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst inst_2 m
                        family n)
                      (@NumStability.PhysicalRefinementQuality.Family.method.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      boundary)
                    d dt current →
                  @NumStability.CapacityCoordinate.Method.Admitted.{u_1, 0, 0, u_1, u_2, 0} D
                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      (D → Real) FacePoint
                      (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      inst_2 m
                      (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                        n)
                      (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, 0, 0, 0} D
                        (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                          n)
                        (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                          n)
                        (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                          n)
                        m
                        (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst inst_2 m
                          family n)
                        (@NumStability.PhysicalRefinementQuality.Family.referenceGhost.{u_1, u_2} D FacePoint inst
                          inst_2 m family n q))
                      (@NumStability.CapacityCoordinate.Method.withGhost.{u_1, 0, 0, u_1, u_2, 0} D
                        (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                          n)
                        (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                          n)
                        (D → Real) FacePoint
                        (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                          n)
                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        inst_2 m
                        (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                          n)
                        (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst inst_2 m
                          family n)
                        (@NumStability.PhysicalRefinementQuality.Family.method.{u_1, u_2} D FacePoint inst inst_2 m
                          family n)
                        (@NumStability.PhysicalRefinementQuality.Family.referenceGhost.{u_1, u_2} D FacePoint inst
                          inst_2 m family n q))
                      d dt
                      (@NumStability.PhysicalRefinementQuality.Family.projected.{u_1, u_2} D FacePoint inst inst_2 m
                        family n q (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))) →
                    ∀ (A E G : Real),
                      @NumStability.CapacityCoordinate.Method.StableAt.{u_1, 0, 0, u_1, u_2, 0} D
                          (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                            family n)
                          (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m
                            family n)
                          (D → Real) FacePoint
                          (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m
                            family n)
                          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                            @UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          inst_2 m
                          (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m
                            family n)
                          (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst inst_2
                            m family n)
                          (@NumStability.PhysicalRefinementQuality.Family.method.{u_1, u_2} D FacePoint inst inst_2 m
                            family n)
                          d dt A →
                        (∀
                            (cell :
                              @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                                family n),
                            @LE.le.{0} Real Real.instLE
                              (@Norm.norm.{0} (Fin m → Real)
                                (@NormedRing.toNorm.{0} (Fin m → Real)
                                  (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                    fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                  (@instHSub.{0} (Fin m → Real)
                                    (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                      Real.instSub))
                                  (current cell)
                                  (@NumStability.PhysicalRefinementQuality.Family.projected.{u_1, u_2} D FacePoint inst
                                    inst_2 m family n q
                                    (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) cell)))
                              E) →
                          (∀
                              (cell :
                                @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                                  family n)
                              (j : Int),
                              @Eq.{1}
                                  (Option.{0}
                                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                      inst_2 m family n))
                                  (@NumStability.FiniteCoordinate.LineCoordinates.lookup.{u_1, 0, 0, 0} m D
                                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                      inst_2 m family n)
                                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                      inst_2 m family n)
                                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst
                                      inst_2 m family n)
                                    (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint
                                      inst inst_2 m family n)
                                    d
                                    (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, 0, 0, 0} m D
                                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                        inst_2 m family n)
                                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                        inst_2 m family n)
                                      (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst
                                        inst_2 m family n)
                                      (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint
                                        inst inst_2 m family n)
                                      d cell)
                                    j)
                                  (@Option.none.{0}
                                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                      inst_2 m family n)) →
                                @LE.le.{0} Real Real.instLE
                                  (@Norm.norm.{0} (Fin m → Real)
                                    (@NormedRing.toNorm.{0} (Fin m → Real)
                                      (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                        fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                    (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                      (@instHSub.{0} (Fin m → Real)
                                        (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                          Real.instSub))
                                      (boundary d
                                        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, 0, 0, 0} m D
                                          (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D
                                            FacePoint inst inst_2 m family n)
                                          d cell)
                                        j)
                                      (@NumStability.PhysicalRefinementQuality.Family.referenceGhost.{u_1, u_2} D
                                        FacePoint inst inst_2 m family n q d
                                        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, 0, 0, 0} m D
                                          (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D
                                            FacePoint inst inst_2 m family n)
                                          d cell)
                                        j)))
                                  G) →
                            ∀
                              (cell :
                                @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                                  family n),
                              @LE.le.{0} Real Real.instLE
                                (@Norm.norm.{0} (Fin m → Real)
                                  (@NormedRing.toNorm.{0} (Fin m → Real)
                                    (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                      fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                    (@instHSub.{0} (Fin m → Real)
                                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                        Real.instSub))
                                    (@NumStability.FiniteCoordinate.advance.{u_1, 0, 0, u_1, u_2} D
                                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                        inst_2 m family n)
                                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                        inst_2 m family n)
                                      (D → Real) FacePoint
                                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                        Real.measurableSpace)
                                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                        @UniformSpace.toTopologicalSpace.{0} Real
                                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                      inst_2 m
                                      (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                        inst_2 m family n)
                                      (@NumStability.CapacityCoordinate.Method.rule.{u_1, 0, 0, u_1, u_2, 0} D
                                        (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                          inst_2 m family n)
                                        (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                          inst_2 m family n)
                                        (D → Real) FacePoint
                                        (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst
                                          inst_2 m family n)
                                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                          Real.measurableSpace)
                                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                          @UniformSpace.toTopologicalSpace.{0} Real
                                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                        inst_2 m
                                        (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                          inst_2 m family n)
                                        (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, 0, 0, 0} D
                                          (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          m
                                          (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D
                                            FacePoint inst inst_2 m family n)
                                          boundary)
                                        (@NumStability.CapacityCoordinate.Method.withGhost.{u_1, 0, 0, u_1, u_2, 0} D
                                          (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (D → Real) FacePoint
                                          (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                            Real.measurableSpace)
                                          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                            @UniformSpace.toTopologicalSpace.{0} Real
                                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                          inst_2 m
                                          (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D
                                            FacePoint inst inst_2 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.method.{u_1, u_2} D FacePoint
                                            inst inst_2 m family n)
                                          boundary))
                                      d dt current cell)
                                    (@NumStability.PhysicalRefinementQuality.Family.projected.{u_1, u_2} D FacePoint
                                      inst inst_2 m family n q dt cell)))
                                (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                                  (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) A
                                    (@Max.max.{0} Real Real.instMax E G))
                                  (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                                    (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                                      (@NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.constant.{u_1,
                                            u_2}
                                        D FacePoint inst inst_2 m family d q p certificate)
                                      dt)
                                    (@HPow.hPow.{0, 0, 0} Real Real Real (@instHPow.{0, 0} Real Real Real.instPow)
                                      (@NumStability.PhysicalRefinementQuality.Family.mesh.{u_1, u_2} D FacePoint inst
                                        inst_2 m family n)
                                      p))))
  (physical_error :
    ∀ (physical : Nat → (D → Real) → Real → Fin m → Real) (amplification localDefect splittingDefect : Nat → Real)
      (initialError : Real)
      (netError :
        Nat →
          @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level → Real),
      (∀ (k : Nat),
          @LT.lt.{0} Nat instLTNat k steps →
            @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
              (duration k)) →
        (∀ (k : Nat),
            @LT.lt.{0} Nat instLTNat k steps →
              @NumStability.FiniteCoordinate.PhysicalData.ReferenceOn.{u_1, 0, 0, u_1, u_2} D
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (D → Real) FacePoint
                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                inst_2 m
                (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (direction k) (physical k) (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                (duration k)) →
          (∀
              (cell :
                @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level),
              @LE.le.{0} Real Real.instLE
                (@Norm.norm.{0} (Fin m → Real)
                  (@NormedRing.toNorm.{0} (Fin m → Real)
                    (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                      @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                    (@instHSub.{0} (Fin m → Real)
                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                    (initial cell)
                    (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, 0, 0, u_1, u_2} D
                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (D → Real) FacePoint
                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      inst_2 m
                      (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (physical (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))) cell
                      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))))
                initialError) →
            (∀ (k : Nat),
                @LT.lt.{0} Nat instLTNat k steps →
                  @NumStability.CapacityCoordinate.Method.Admitted.{u_1, 0, 0, u_1, u_2, 0} D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (D → Real) FacePoint
                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                      @UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    inst_2 m
                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalHighResolutionSweep.coordinates.{u_1, u_2} D FacePoint inst inst_2 m family
                      level ghost k)
                    (@NumStability.PhysicalHighResolutionSweep.method.{u_1, u_2} D FacePoint inst inst_2 m family level
                      ghost k)
                    (direction k) (duration k)
                    (@NumStability.PhysicalHighResolutionSweep.execution.{u_1, u_2} D FacePoint inst inst_2 m family
                      level direction duration ghost initial k)) →
              (∀ (k : Nat),
                  @LT.lt.{0} Nat instLTNat k steps →
                    @NumStability.CapacityCoordinate.Method.Admitted.{u_1, 0, 0, u_1, u_2, 0} D
                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (D → Real) FacePoint
                      (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      inst_2 m
                      (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                      (@NumStability.PhysicalHighResolutionSweep.coordinates.{u_1, u_2} D FacePoint inst inst_2 m family
                        level ghost k)
                      (@NumStability.PhysicalHighResolutionSweep.method.{u_1, u_2} D FacePoint inst inst_2 m family
                        level ghost k)
                      (direction k) (duration k)
                      fun
                        (cell :
                          @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                            family level) =>
                      @NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, 0, 0, u_1, u_2} D
                        (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                          level)
                        (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                          level)
                        (D → Real) FacePoint
                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        inst_2 m
                        (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                          level)
                        (physical k) cell (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))) →
                (∀ (k : Nat),
                    @LT.lt.{0} Nat instLTNat k steps →
                      @NumStability.CapacityCoordinate.Method.StableAt.{u_1, 0, 0, u_1, u_2, 0} D
                        (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                          level)
                        (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                          level)
                        (D → Real) FacePoint
                        (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_2 m family
                          level)
                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        inst_2 m
                        (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                          level)
                        (@NumStability.PhysicalHighResolutionSweep.coordinates.{u_1, u_2} D FacePoint inst inst_2 m
                          family level ghost k)
                        (@NumStability.PhysicalHighResolutionSweep.method.{u_1, u_2} D FacePoint inst inst_2 m family
                          level ghost k)
                        (direction k) (duration k) (amplification k)) →
                  (∀ (k : Nat),
                      @LT.lt.{0} Nat instLTNat k steps →
                        ∀
                          (cell :
                            @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                              family level),
                          @LE.le.{0} Real Real.instLE
                            (@Norm.norm.{0} (Fin m → Real)
                              (@NormedRing.toNorm.{0} (Fin m → Real)
                                (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                  fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                              (@NumStability.FiniteCoordinate.netFluxDefect.{u_1, 0, 0, u_1, u_2} D
                                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2
                                  m family level)
                                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2
                                  m family level)
                                (D → Real) FacePoint
                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                  Real.measurableSpace)
                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                  @UniformSpace.toTopologicalSpace.{0} Real
                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                inst_2 m
                                (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2
                                  m family level)
                                (@NumStability.CapacityCoordinate.Method.rule.{u_1, 0, 0, u_1, u_2, 0} D
                                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                    inst_2 m family level)
                                  (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                    inst_2 m family level)
                                  (D → Real) FacePoint
                                  (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst
                                    inst_2 m family level)
                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                    Real.measurableSpace)
                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                    @UniformSpace.toTopologicalSpace.{0} Real
                                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                  inst_2 m
                                  (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                    inst_2 m family level)
                                  (@NumStability.PhysicalHighResolutionSweep.coordinates.{u_1, u_2} D FacePoint inst
                                    inst_2 m family level ghost k)
                                  (@NumStability.PhysicalHighResolutionSweep.method.{u_1, u_2} D FacePoint inst inst_2 m
                                    family level ghost k))
                                (direction k)
                                (fun
                                    (c :
                                      @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                        inst_2 m family level) =>
                                  @NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, 0, 0, u_1, u_2} D
                                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                      inst_2 m family level)
                                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                      inst_2 m family level)
                                    (D → Real) FacePoint
                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                      Real.measurableSpace)
                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                      @UniformSpace.toTopologicalSpace.{0} Real
                                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                    inst_2 m
                                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                      inst_2 m family level)
                                    (physical k) c
                                    (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
                                (physical k) (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                                (duration k) cell))
                            (netError k cell)) →
                    (∀ (k : Nat),
                        @LT.lt.{0} Nat instLTNat k steps →
                          ∀
                            (cell :
                              @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                                family level),
                            @LE.le.{0} Real Real.instLE
                              (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                                (@HDiv.hDiv.{0, 0, 0} Real Real Real
                                  (@instHDiv.{0} Real (@DivInvMonoid.toDiv.{0} Real Real.instDivInvMonoid)) (duration k)
                                  (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, 0, 0, u_1, u_2} D
                                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                      inst_2 m family level)
                                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                      inst_2 m family level)
                                    (D → Real) FacePoint
                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                      Real.measurableSpace)
                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                      @UniformSpace.toTopologicalSpace.{0} Real
                                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                    inst_2 m
                                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                      inst_2 m family level)
                                    cell))
                                (netError k cell))
                              (localDefect k)) →
                      (∀ (k : Nat),
                          @LT.lt.{0} Nat instLTNat k steps →
                            ∀
                              (cell :
                                @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                                  family level),
                              @LE.le.{0} Real Real.instLE
                                (@Norm.norm.{0} (Fin m → Real)
                                  (@NormedRing.toNorm.{0} (Fin m → Real)
                                    (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                      fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                    (@instHSub.{0} (Fin m → Real)
                                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                        Real.instSub))
                                    (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, 0, 0, u_1, u_2} D
                                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                        inst_2 m family level)
                                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                        inst_2 m family level)
                                      (D → Real) FacePoint
                                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                        Real.measurableSpace)
                                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                        @UniformSpace.toTopologicalSpace.{0} Real
                                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                      inst_2 m
                                      (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                        inst_2 m family level)
                                      (physical k) cell (duration k))
                                    (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, 0, 0, u_1, u_2} D
                                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                        inst_2 m family level)
                                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                        inst_2 m family level)
                                      (D → Real) FacePoint
                                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                        Real.measurableSpace)
                                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                        @UniformSpace.toTopologicalSpace.{0} Real
                                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                      inst_2 m
                                      (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                        inst_2 m family level)
                                      (physical
                                        (@HAdd.hAdd.{0, 0, 0} Nat Nat Nat (@instHAdd.{0} Nat instAddNat) k
                                          (@OfNat.ofNat.{0} Nat (nat_lit 1) (instOfNatNat (nat_lit 1)))))
                                      cell
                                      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))))
                                (splittingDefect k)) →
                        ∀ (k : Nat),
                          @LE.le.{0} Nat instLENat k steps →
                            ∀
                              (cell :
                                @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                                  family level),
                              @LE.le.{0} Real Real.instLE
                                (@Norm.norm.{0} (Fin m → Real)
                                  (@NormedRing.toNorm.{0} (Fin m → Real)
                                    (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                                      fun (i : Fin m) => @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                  (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                    (@instHSub.{0} (Fin m → Real)
                                      (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                        Real.instSub))
                                    (@NumStability.PhysicalHighResolutionSweep.execution.{u_1, u_2} D FacePoint inst
                                      inst_2 m family level direction duration ghost initial k cell)
                                    (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, 0, 0, u_1, u_2} D
                                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                        inst_2 m family level)
                                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                        inst_2 m family level)
                                      (D → Real) FacePoint
                                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                        Real.measurableSpace)
                                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                        @UniformSpace.toTopologicalSpace.{0} Real
                                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                      inst_2 m
                                      (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                        inst_2 m family level)
                                      (physical k) cell
                                      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))))
                                (NumStability.SequentialError.errorBudget amplification localDefect splittingDefect
                                  initialError k))
  (cartesian :
    ∀ (axes : D → NumStability.OneDimensionalFiniteVolumeGrid)
      (cellPosition :
        @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level → D → Int)
      (facePosition :
        D →
          @NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family level →
            D → Int)
      (flux : D → (Fin m → Real) → Fin m → Real),
      @NumStability.FiniteCartesian.CartesianIdentification.{u_1, 0, 0, u_2} D
          (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
          (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family level)
          FacePoint inst inst_1 inst_2 m
          (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family level) axes
          cellPosition facePosition flux →
        And
          (∀
            (cell :
              @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level),
            @Eq.{1} Real
              (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, 0, 0, u_1, u_2} D
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (D → Real) FacePoint
                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                inst_2 m
                (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family level)
                cell)
              (@NumStability.CartesianGrid.cellVolume.{u_1} D inst axes (cellPosition cell)))
          (And
            (∀ (q : (D → Real) → Real → Fin m → Real)
              (cell :
                @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family level)
              (t : Real),
              @Eq.{1} (Fin m → Real)
                (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, 0, 0, u_1, u_2} D
                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  (D → Real) FacePoint
                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  inst_2 m
                  (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                    level)
                  q cell t)
                (@NumStability.cellVolumeAverage.{u_1, 0} (D → Real) (Fin m → Real)
                  (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1} (D → Real)
                    (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst (fun (a : D) => Real) fun (i : D) =>
                      Real.measureSpace))
                  (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                    Real.normedAddCommGroup)
                  (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                    (fun (i : Fin m) =>
                      @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                    fun (i : Fin m) =>
                    @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                      (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                        (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                          (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                            (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                  (@MeasureTheory.MeasureSpace.volume.{u_1} (D → Real)
                    (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst (fun (a : D) => Real) fun (i : D) =>
                      Real.measureSpace))
                  (@NumStability.CartesianGrid.cellBox.{u_1} D axes (cellPosition cell)) fun (x : D → Real) => q x t))
            (And
              (∀ (q : Real → Real → Fin m → Real) (d : D)
                (face :
                  @NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family level)
                (t : Real),
                @Eq.{1} (Fin m → Real)
                  (@NumStability.FiniteCoordinate.PhysicalData.faceFlux.{u_1, 0, 0, u_1, u_2} D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    (D → Real) FacePoint
                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                      @UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    inst_2 m
                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m family
                      level)
                    d (fun (x : D → Real) (τ : Real) => q (x d) τ) face t)
                  (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                    (@instHSMul.{0, 0} Real (Fin m → Real)
                      (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                        (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                          (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                          (@Algebra.id.{0} Real Real.instCommSemiring))))
                    (@NumStability.CartesianGrid.faceArea.{u_1} D inst inst_1 axes d (facePosition d face))
                    (flux d
                      (q (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft (axes d) (facePosition d face d)) t))))
              (∀ (q : Real → Real → Fin m → Real) (d : D),
                @NumStability.IsRectangleConservationLawSolution.{0} (Fin m → Real)
                    (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
                      Real.normedAddCommGroup)
                    (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                      (fun (i : Fin m) =>
                        @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                      fun (i : Fin m) =>
                      @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                        (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                          (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                            (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                              (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                    q (flux d) →
                  ∀
                    (cell :
                      @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m family
                        level)
                    (s t : Real),
                    @Eq.{1} (Fin m → Real)
                      (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                        (@instHSMul.{0, 0} Real (Fin m → Real)
                          (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                            (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                              (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                              (@Algebra.id.{0} Real Real.instCommSemiring))))
                        (@NumStability.FiniteCoordinate.PhysicalData.cellVolume.{u_1, 0, 0, u_1, u_2} D
                          (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                            family level)
                          (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m
                            family level)
                          (D → Real) FacePoint
                          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                            @UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          inst_2 m
                          (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m
                            family level)
                          cell)
                        (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                          (@instHSub.{0} (Fin m → Real)
                            (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                          (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, 0, 0, u_1, u_2} D
                            (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                              family level)
                            (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m
                              family level)
                            (D → Real) FacePoint
                            (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                              @UniformSpace.toTopologicalSpace.{0} Real
                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            inst_2 m
                            (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m
                              family level)
                            (fun (x : D → Real) (τ : Real) => q (x d) τ) cell t)
                          (@NumStability.FiniteCoordinate.PhysicalData.cellMean.{u_1, 0, 0, u_1, u_2} D
                            (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                              family level)
                            (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m
                              family level)
                            (D → Real) FacePoint
                            (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                              @UniformSpace.toTopologicalSpace.{0} Real
                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            inst_2 m
                            (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m
                              family level)
                            (fun (x : D → Real) (τ : Real) => q (x d) τ) cell s)))
                      (@intervalIntegral.{0} (Fin m → Real)
                        (@Pi.normedAddCommGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m)
                          fun (i : Fin m) => Real.normedAddCommGroup)
                        (@Pi.normedSpace.{0, 0, 0} Real Real.normedField (Fin m) (fun (a : Fin m) => Real)
                          (Fin.fintype m)
                          (fun (i : Fin m) =>
                            @NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          fun (i : Fin m) =>
                          @InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                            (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                              (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                  (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                            (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                        (fun (τ : Real) =>
                          @HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                            (@instHSub.{0} (Fin m → Real)
                              (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) => Real.instSub))
                            (@NumStability.FiniteCoordinate.PhysicalData.faceFlux.{u_1, 0, 0, u_1, u_2} D
                              (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                                family level)
                              (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m
                                family level)
                              (D → Real) FacePoint
                              (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                @UniformSpace.toTopologicalSpace.{0} Real
                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              inst_2 m
                              (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m
                                family level)
                              d (fun (x : D → Real) (σ : Real) => q (x d) σ)
                              (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, 0, 0, u_1, u_2} D
                                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2
                                  m family level)
                                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2
                                  m family level)
                                (D → Real) FacePoint
                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                  Real.measurableSpace)
                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                  @UniformSpace.toTopologicalSpace.{0} Real
                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                inst_2 m
                                (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2
                                  m family level)
                                d cell)
                              τ)
                            (@NumStability.FiniteCoordinate.PhysicalData.faceFlux.{u_1, 0, 0, u_1, u_2} D
                              (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2 m
                                family level)
                              (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2 m
                                family level)
                              (D → Real) FacePoint
                              (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                @UniformSpace.toTopologicalSpace.{0} Real
                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              inst_2 m
                              (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2 m
                                family level)
                              d (fun (x : D → Real) (σ : Real) => q (x d) σ)
                              (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, 0, 0, u_1, u_2} D
                                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_2
                                  m family level)
                                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_2
                                  m family level)
                                (D → Real) FacePoint
                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                  Real.measurableSpace)
                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                  @UniformSpace.toTopologicalSpace.{0} Real
                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                inst_2 m
                                (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_2
                                  m family level)
                                d cell)
                              τ))
                        s t (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace)))))),
  @NumStability.PhysicalHighResolutionSweep.Specification.{u_1, u_2} D FacePoint inst inst_1 inst_2 m family level
    direction duration ghost initial steps
```

### D009: `NumStability.PhysicalHighResolutionSweep.coordinates`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `2d4707ca751672b2f980aca600b06cd47885297778d5c813698ebec661fb53d5`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (level : Nat) →
              (Nat → D → family.Line level → Int → Fin m → Real) →
                Nat →
                  NumStability.FiniteCoordinate.LineCoordinates D (family.Cell level) (family.Face level)
                    (family.Line level)
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m) →
            (level : Nat) →
              (ghost :
                  Nat →
                    D →
                      @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family
                          level →
                        Int → Fin m → Real) →
                (k : Nat) →
                  @NumStability.FiniteCoordinate.LineCoordinates.{u_1, 0, 0, 0} m D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_1 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family
                      level)
```

Definition body (one-level semantic boundary):

```lean
fun {D} {FacePoint} [Fintype D] [MeasurableSpace FacePoint] {m} family level ghost k =>
  (family.coordinates level).withGhost (ghost k)
```

### D010: `NumStability.PhysicalHighResolutionSweep.execution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `25d9baf8f5a37ab9fb15af41620e311d6b54f370b2d784c7d0efdeb93885d9c3`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (level : Nat) →
              (Nat → D) →
                (Nat → Real) →
                  (Nat → D → family.Line level → Int → Fin m → Real) →
                    (family.Cell level → Fin m → Real) → Nat → family.Cell level → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m) →
            (level : Nat) →
              (direction : Nat → D) →
                (duration : Nat → Real) →
                  (ghost :
                      Nat →
                        D →
                          @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m
                              family level →
                            Int → Fin m → Real) →
                    (initial :
                        @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family
                            level →
                          Fin m → Real) →
                      Nat →
                        @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family
                            level →
                          Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {FacePoint} [Fintype D] [MeasurableSpace FacePoint] {m} family level direction duration ghost initial =>
  NumStability.CapacityCoordinate.Sweep.run (NumStability.PhysicalHighResolutionSweep.method family level ghost)
    direction duration initial
```

### D011: `NumStability.PhysicalHighResolutionSweep.method`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `76651a8fa50d12fbd8599d0b2195a0535f52bd66ddf5819615ebff0226f2d540`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (level : Nat) →
              (ghost : Nat → D → family.Line level → Int → Fin m → Real) →
                (k : Nat) →
                  NumStability.CapacityCoordinate.Method (family.data level)
                    (NumStability.PhysicalHighResolutionSweep.coordinates family level ghost k)
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m) →
            (level : Nat) →
              (ghost :
                  Nat →
                    D →
                      @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family
                          level →
                        Int → Fin m → Real) →
                (k : Nat) →
                  @NumStability.CapacityCoordinate.Method.{u_1, 0, 0, u_1, u_2, 0} D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family
                      level)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_1 m family
                      level)
                    (D → Real) FacePoint
                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family
                      level)
                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                      @UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    inst_1 m
                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_1 m family
                      level)
                    (@NumStability.PhysicalHighResolutionSweep.coordinates.{u_1, u_2} D FacePoint inst inst_1 m family
                      level ghost k)
```

Definition body (one-level semantic boundary):

```lean
fun {D} {FacePoint} [Fintype D] [MeasurableSpace FacePoint] {m} family level ghost k =>
  (family.method level).withGhost (ghost k)
```

### D012: `NumStability.PhysicalRefinementQuality.Family.Face`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `16f27fb4eebfc9260d59ffa179af656c629451346d18e9e29729b68bfd2df56f`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} → NumStability.PhysicalRefinementQuality.Family D FacePoint m → Nat → Type
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) → Nat → Type
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.2
```

### D013: `NumStability.PhysicalRefinementQuality.Family.HasHighResolution.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `c1cbea527f3e119d5de91cf1c3343bccf0b2a65a9eb524919ada593bbc2f49d2`

Type:

```lean
∀ {D : Type u_1} {FacePoint : Type u_2} [inst : Fintype D] [inst_1 : MeasurableSpace FacePoint] {m : Nat}
  {family : NumStability.PhysicalRefinementQuality.Family D FacePoint m},
  (∀ (n : Nat) (d : D) (ghost : D → family.Line n → Int → Fin m → Real) (current : family.Cell n → Fin m → Real),
      (∀ (cell : family.Cell n), Set.instMembership.mem (family.states d) (current cell)) →
        (∀ (line : family.Line n) (j : Int),
            Eq ((family.coordinates n).lookup d line j) Option.none →
              Set.instMembership.mem (family.states d) (ghost d line j)) →
          Exists fun dt =>
            And (Real.instLT.lt 0 dt)
              (And (Real.instLE.le dt family.horizon) (((family.method n).withGhost ghost).Admitted d dt current))) →
    (∀ (d : D),
        Exists fun p =>
          And (Real.instLT.lt 1 p)
            (∀ (q : (D → Real) → Real → Fin m → Real),
              family.SmoothReference d q → Nonempty (family.AccuracyCertificate d q p))) →
      (∀ (d : D),
          Exists fun K =>
            And (Real.instLE.le 0 K)
              (Exists fun noise =>
                And (∀ (n : Nat), Real.instLE.le 0 (noise n))
                  (And (Filter.Tendsto noise Filter.atTop (nhds 0))
                    (∀ (n : Nat) (ghost : D → family.Line n → Int → Fin m → Real)
                      (current : family.Cell n → Fin m → Real) (dt : Real),
                      Real.instLT.lt 0 dt →
                        Real.instLE.le dt family.horizon →
                          ((family.method n).withGhost ghost).Admitted d dt current →
                            ∀ (line : family.Line n),
                              Real.instLE.le
                                (family.variation n d line ghost
                                  (NumStability.FiniteCoordinate.advance (family.data n)
                                    ((family.method n).withGhost ghost).rule d dt current))
                                (instHAdd.hAdd
                                  (instHMul.hMul (instHAdd.hAdd 1 (instHMul.hMul K dt))
                                    (family.variation n d line ghost current))
                                  (instHMul.hMul dt (noise n))))))) →
        family.HasHighResolution
```

Fully explicit type:

```lean
∀ {D : Type u_1} {FacePoint : Type u_2} [inst : Fintype.{u_1} D] [inst_1 : MeasurableSpace.{u_2} FacePoint] {m : Nat}
  {family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m}
  (input_available :
    ∀ (n : Nat) (d : D)
      (ghost :
        D →
          @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family n →
            Int → Fin m → Real)
      (current :
        @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family n →
          Fin m → Real),
      (∀ (cell : @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family n),
          @Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
            (@NumStability.PhysicalRefinementQuality.Family.states.{u_1, u_2} D FacePoint inst inst_1 m family d)
            (current cell)) →
        (∀ (line : @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family n)
            (j : Int),
            @Eq.{1}
                (Option.{0}
                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family n))
                (@NumStability.FiniteCoordinate.LineCoordinates.lookup.{u_1, 0, 0, 0} m D
                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family n)
                  (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_1 m family n)
                  (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family n)
                  (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst inst_1 m
                    family n)
                  d line j)
                (@Option.none.{0}
                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family n)) →
              @Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
                (@NumStability.PhysicalRefinementQuality.Family.states.{u_1, u_2} D FacePoint inst inst_1 m family d)
                (ghost d line j)) →
          @Exists.{1} Real fun (dt : Real) =>
            And
              (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                dt)
              (And
                (@LE.le.{0} Real Real.instLE dt
                  (@NumStability.PhysicalRefinementQuality.Family.horizon.{u_1, u_2} D FacePoint inst inst_1 m family))
                (@NumStability.CapacityCoordinate.Method.Admitted.{u_1, 0, 0, u_1, u_2, 0} D
                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family n)
                  (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_1 m family n)
                  (D → Real) FacePoint
                  (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family n)
                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  inst_1 m
                  (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_1 m family n)
                  (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, 0, 0, 0} D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family n)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_1 m family n)
                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family n)
                    m
                    (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst inst_1 m
                      family n)
                    ghost)
                  (@NumStability.CapacityCoordinate.Method.withGhost.{u_1, 0, 0, u_1, u_2, 0} D
                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family n)
                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_1 m family n)
                    (D → Real) FacePoint
                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family n)
                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                      @UniformSpace.toTopologicalSpace.{0} Real
                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    inst_1 m
                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_1 m family n)
                    (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst inst_1 m
                      family n)
                    (@NumStability.PhysicalRefinementQuality.Family.method.{u_1, u_2} D FacePoint inst inst_1 m family
                      n)
                    ghost)
                  d dt current)))
  (order :
    ∀ (d : D),
      @Exists.{1} Real fun (p : Real) =>
        And (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne)) p)
          (∀ (q : (D → Real) → Real → Fin m → Real),
            @NumStability.PhysicalRefinementQuality.Family.SmoothReference.{u_1, u_2} D FacePoint inst inst_1 m family d
                q →
              Nonempty.{1}
                (@NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.{u_1, u_2} D FacePoint inst inst_1 m
                  family d q p)))
  (oscillation :
    ∀ (d : D),
      @Exists.{1} Real fun (K : Real) =>
        And (@LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) K)
          (@Exists.{1} (Nat → Real) fun (noise : Nat → Real) =>
            And
              (∀ (n : Nat),
                @LE.le.{0} Real Real.instLE (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
                  (noise n))
              (And
                (@Filter.Tendsto.{0, 0} Nat Real noise (@Filter.atTop.{0} Nat Nat.instPreorder)
                  (@nhds.{0} Real
                    (@UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                    (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))))
                (∀ (n : Nat)
                  (ghost :
                    D →
                      @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family
                          n →
                        Int → Fin m → Real)
                  (current :
                    @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family n →
                      Fin m → Real)
                  (dt : Real),
                  @LT.lt.{0} Real Real.instLT
                      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) dt →
                    @LE.le.{0} Real Real.instLE dt
                        (@NumStability.PhysicalRefinementQuality.Family.horizon.{u_1, u_2} D FacePoint inst inst_1 m
                          family) →
                      @NumStability.CapacityCoordinate.Method.Admitted.{u_1, 0, 0, u_1, u_2, 0} D
                          (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m
                            family n)
                          (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_1 m
                            family n)
                          (D → Real) FacePoint
                          (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m
                            family n)
                          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                            @UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          inst_1 m
                          (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_1 m
                            family n)
                          (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, 0, 0, 0} D
                            (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m
                              family n)
                            (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_1 m
                              family n)
                            (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m
                              family n)
                            m
                            (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst
                              inst_1 m family n)
                            ghost)
                          (@NumStability.CapacityCoordinate.Method.withGhost.{u_1, 0, 0, u_1, u_2, 0} D
                            (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m
                              family n)
                            (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_1 m
                              family n)
                            (D → Real) FacePoint
                            (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m
                              family n)
                            (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                              @UniformSpace.toTopologicalSpace.{0} Real
                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                            inst_1 m
                            (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_1 m
                              family n)
                            (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint inst
                              inst_1 m family n)
                            (@NumStability.PhysicalRefinementQuality.Family.method.{u_1, u_2} D FacePoint inst inst_1 m
                              family n)
                            ghost)
                          d dt current →
                        ∀
                          (line :
                            @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m
                              family n),
                          @LE.le.{0} Real Real.instLE
                            (@NumStability.PhysicalRefinementQuality.Family.variation.{u_1, u_2} D FacePoint inst inst_1
                              m family n d line ghost
                              (@NumStability.FiniteCoordinate.advance.{u_1, 0, 0, u_1, u_2} D
                                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1
                                  m family n)
                                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst inst_1
                                  m family n)
                                (D → Real) FacePoint
                                (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                  Real.measurableSpace)
                                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                  @UniformSpace.toTopologicalSpace.{0} Real
                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                inst_1 m
                                (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst inst_1
                                  m family n)
                                (@NumStability.CapacityCoordinate.Method.rule.{u_1, 0, 0, u_1, u_2, 0} D
                                  (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                    inst_1 m family n)
                                  (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                    inst_1 m family n)
                                  (D → Real) FacePoint
                                  (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst
                                    inst_1 m family n)
                                  (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                    Real.measurableSpace)
                                  (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                    @UniformSpace.toTopologicalSpace.{0} Real
                                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                  inst_1 m
                                  (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                    inst_1 m family n)
                                  (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, 0, 0, 0} D
                                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                      inst_1 m family n)
                                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                      inst_1 m family n)
                                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst
                                      inst_1 m family n)
                                    m
                                    (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint
                                      inst inst_1 m family n)
                                    ghost)
                                  (@NumStability.CapacityCoordinate.Method.withGhost.{u_1, 0, 0, u_1, u_2, 0} D
                                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                      inst_1 m family n)
                                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                      inst_1 m family n)
                                    (D → Real) FacePoint
                                    (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst
                                      inst_1 m family n)
                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                      Real.measurableSpace)
                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                      @UniformSpace.toTopologicalSpace.{0} Real
                                        (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                    inst_1 m
                                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                      inst_1 m family n)
                                    (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D FacePoint
                                      inst inst_1 m family n)
                                    (@NumStability.PhysicalRefinementQuality.Family.method.{u_1, u_2} D FacePoint inst
                                      inst_1 m family n)
                                    ghost))
                                d dt current))
                            (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                              (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                                (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                                  (@OfNat.ofNat.{0} Real (nat_lit 1) (@One.toOfNat1.{0} Real Real.instOne))
                                  (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) K dt))
                                (@NumStability.PhysicalRefinementQuality.Family.variation.{u_1, u_2} D FacePoint inst
                                  inst_1 m family n d line ghost current))
                              (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) dt (noise n))))))),
  @NumStability.PhysicalRefinementQuality.Family.HasHighResolution.{u_1, u_2} D FacePoint inst inst_1 m family
```

### D014: `NumStability.PhysicalRefinementQuality.Family.data`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `2a63c58d66af4f67a2c7ae559e7bda67a7419171e1d06b7c38c454948477cc59`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (self : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (n : Nat) → NumStability.FiniteCoordinate.PhysicalData D (self.Cell n) (self.Face n) (D → Real) FacePoint m
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) →
            (n : Nat) →
              @NumStability.FiniteCoordinate.PhysicalData.{u_3, 0, 0, u_3, u_4} D
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_3, u_4} D FacePoint inst inst_1 m self n)
                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_3, u_4} D FacePoint inst inst_1 m self n)
                (D → Real) FacePoint
                (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real) fun (i : D) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                inst_1 m
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.5
```

### D015: `NumStability.PhysicalRefinementQuality.Family.horizon`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `13eb935a0538803c41eca8a50035a49a500c8967cd6906546120040e753d116e`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} → NumStability.PhysicalRefinementQuality.Family D FacePoint m → Real
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} → (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) → Real
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.27
```

### D016: `NumStability.PhysicalRefinementQuality.Family.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `4d9c244e5c5508662aac2cd60f106a0c1f7c85f7941f87308464942e3d76c2b3`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (Cell Face Line : Nat → Type) →
            (finiteCell : (n : Nat) → Fintype (Cell n)) →
              (data :
                  (n : Nat) → NumStability.FiniteCoordinate.PhysicalData D (Cell n) (Face n) (D → Real) FacePoint m) →
                (coordinates : (n : Nat) → NumStability.FiniteCoordinate.LineCoordinates D (Cell n) (Face n) (Line n)) →
                  ((n : Nat) → NumStability.CapacityCoordinate.Method (data n) (coordinates n)) →
                    (measure : MeasureTheory.Measure (D → Real)) →
                      (∀ (n : Nat), Eq (data n).measure measure) →
                        (states : D → Set (Fin m → Real)) →
                          (∀ (d : D), (states d).Nonempty) →
                            (∀ (n : Nat) (d : D), Eq ((data n).admissibleStates d) (states d)) →
                              (physicalFlux : (D → Real) → (Fin m → Real) → D → Fin m → Real) →
                                (normal : (n : Nat) → D → Face n → FacePoint → D → Real) →
                                  (∀ (n : Nat) (d : D) (face : Face n) (point : FacePoint) (state : Fin m → Real),
                                      Eq ((data n).normalFlux d face point state)
                                        (Finset.univ.sum fun k =>
                                          instHSMul.hSMul (normal n d face point k)
                                            (physicalFlux ((data n).facePoint d face point) state k))) →
                                    (region target : Set (D → Real)) →
                                      (interior target).Nonempty →
                                        Set.instHasSubset.Subset target region →
                                          (∀ (n : Nat) (cell : Cell n),
                                              Set.instHasSubset.Subset ((data n).cells.cellRegion cell) region) →
                                            (∀ (n : Nat) (x : D → Real),
                                                Set.instMembership.mem target x →
                                                  Exists fun cell =>
                                                    Set.instMembership.mem ((data n).cells.cellRegion cell) x) →
                                              (∀ (n : Nat) (cell : Cell n),
                                                  Bornology.IsBounded ((data n).cells.cellRegion cell)) →
                                                (mesh : Nat → Real) →
                                                  (∀ (n : Nat), Eq (mesh n) (data n).cells.mesh) →
                                                    (∀ (n : Nat), Real.instLT.lt 0 (mesh n)) →
                                                      Filter.Tendsto mesh Filter.atTop (nhds 0) →
                                                        (horizon : Real) →
                                                          Real.instLT.lt 0 horizon →
                                                            (boundaryRegion :
                                                                (n : Nat) → D → Line n → Int → Set (D → Real)) →
                                                              (∀ (n : Nat) (d : D) (line : Line n) (j : Int),
                                                                  MeasurableSet (boundaryRegion n d line j)) →
                                                                (∀ (n : Nat) (d : D) (line : Line n) (j : Int),
                                                                    Ne
                                                                      (MeasureTheory.Measure.instFunLike.coe measure
                                                                        (boundaryRegion n d line j))
                                                                      0) →
                                                                  (∀ (n : Nat) (d : D) (line : Line n) (j : Int),
                                                                      Ne
                                                                        (MeasureTheory.Measure.instFunLike.coe measure
                                                                          (boundaryRegion n d line j))
                                                                        instTopENNReal.top) →
                                                                    (∀ (n : Nat) (d : D) (line : Line n) (j : Int),
                                                                        Set.instHasSubset.Subset
                                                                          (boundaryRegion n d line j) region) →
                                                                      NumStability.PhysicalRefinementQuality.Family D
                                                                        FacePoint m
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (Cell Face Line : Nat → Type) →
            (finiteCell : (n : Nat) → Fintype.{0} (Cell n)) →
              (data :
                  (n : Nat) →
                    @NumStability.FiniteCoordinate.PhysicalData.{u_3, 0, 0, u_3, u_4} D (Cell n) (Face n) (D → Real)
                      FacePoint
                      (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                      (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real) fun (i : D) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      inst_1 m) →
                (coordinates :
                    (n : Nat) →
                      @NumStability.FiniteCoordinate.LineCoordinates.{u_3, 0, 0, 0} m D (Cell n) (Face n) (Line n)) →
                  (method :
                      (n : Nat) →
                        @NumStability.CapacityCoordinate.Method.{u_3, 0, 0, u_3, u_4, 0} D (Cell n) (Face n) (D → Real)
                          FacePoint (Line n)
                          (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                          (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real) fun (i : D) =>
                            @UniformSpace.toTopologicalSpace.{0} Real
                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                          inst_1 m (data n) (coordinates n)) →
                    (measure :
                        @MeasureTheory.Measure.{u_3} (D → Real)
                          (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)) →
                      (measure_eq :
                          ∀ (n : Nat),
                            @Eq.{u_3 + 1}
                              (@MeasureTheory.Measure.{u_3} (D → Real)
                                (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) =>
                                  Real.measurableSpace))
                              (@NumStability.FiniteCoordinate.PhysicalData.measure.{u_3, 0, 0, u_3, u_4} D (Cell n)
                                (Face n) (D → Real) FacePoint
                                (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) =>
                                  Real.measurableSpace)
                                (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real) fun (i : D) =>
                                  @UniformSpace.toTopologicalSpace.{0} Real
                                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                inst_1 m (data n))
                              measure) →
                        (states : D → Set.{0} (Fin m → Real)) →
                          (states_nonempty : ∀ (d : D), @Set.Nonempty.{0} (Fin m → Real) (states d)) →
                            (states_eq :
                                ∀ (n : Nat) (d : D),
                                  @Eq.{1} (Set.{0} (Fin m → Real))
                                    (@NumStability.FiniteCoordinate.PhysicalData.admissibleStates.{u_3, 0, 0, u_3, u_4}
                                      D (Cell n) (Face n) (D → Real) FacePoint
                                      (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) =>
                                        Real.measurableSpace)
                                      (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real) fun (i : D) =>
                                        @UniformSpace.toTopologicalSpace.{0} Real
                                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                      inst_1 m (data n) d)
                                    (states d)) →
                              (physicalFlux : (D → Real) → (Fin m → Real) → D → Fin m → Real) →
                                (normal : (n : Nat) → D → Face n → FacePoint → D → Real) →
                                  (normal_flux_eq :
                                      ∀ (n : Nat) (d : D) (face : Face n) (point : FacePoint) (state : Fin m → Real),
                                        @Eq.{1} (Fin m → Real)
                                          (@NumStability.FiniteCoordinate.PhysicalData.normalFlux.{u_3, 0, 0, u_3, u_4}
                                            D (Cell n) (Face n) (D → Real) FacePoint
                                            (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) =>
                                              Real.measurableSpace)
                                            (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real) fun (i : D) =>
                                              @UniformSpace.toTopologicalSpace.{0} Real
                                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                            inst_1 m (data n) d face point state)
                                          (@Finset.sum.{u_3, 0} D (Fin m → Real)
                                            (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                              fun (i : Fin m) => Real.instAddCommMonoid)
                                            (@Finset.univ.{u_3} D inst) fun (k : D) =>
                                            @HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                                              (@instHSMul.{0, 0} Real (Fin m → Real)
                                                (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                                                  (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                                    (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                                    (@Algebra.id.{0} Real Real.instCommSemiring))))
                                              (normal n d face point k)
                                              (physicalFlux
                                                (@NumStability.FiniteCoordinate.PhysicalData.facePoint.{u_3, 0, 0, u_3,
                                                      u_4}
                                                  D (Cell n) (Face n) (D → Real) FacePoint
                                                  (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                    Real.measurableSpace)
                                                  (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real) fun (i : D) =>
                                                    @UniformSpace.toTopologicalSpace.{0} Real
                                                      (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                        Real.pseudoMetricSpace))
                                                  inst_1 m (data n) d face point)
                                                state k))) →
                                    (region target : Set.{u_3} (D → Real)) →
                                      (target_interior_nonempty :
                                          @Set.Nonempty.{u_3} (D → Real)
                                            (@interior.{u_3} (D → Real)
                                              (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real) fun (i : D) =>
                                                @UniformSpace.toTopologicalSpace.{0} Real
                                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                              target)) →
                                        (target_inside :
                                            @HasSubset.Subset.{u_3} (Set.{u_3} (D → Real))
                                              (@Set.instHasSubset.{u_3} (D → Real)) target region) →
                                          (active_inside :
                                              ∀ (n : Nat) (cell : Cell n),
                                                @HasSubset.Subset.{u_3} (Set.{u_3} (D → Real))
                                                  (@Set.instHasSubset.{u_3} (D → Real))
                                                  (@NumStability.FiniteVolumeCellPartition.cellRegion.{0, u_3} (Cell n)
                                                    (D → Real)
                                                    (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                      Real.measurableSpace)
                                                    (@NumStability.FiniteCoordinate.PhysicalData.cells.{u_3, 0, 0, u_3,
                                                          u_4}
                                                      D (Cell n) (Face n) (D → Real) FacePoint
                                                      (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real)
                                                        fun (a : D) => Real.measurableSpace)
                                                      (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real)
                                                        fun (i : D) =>
                                                        @UniformSpace.toTopologicalSpace.{0} Real
                                                          (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                            Real.pseudoMetricSpace))
                                                      inst_1 m (data n))
                                                    cell)
                                                  region) →
                                            (target_covered :
                                                ∀ (n : Nat) (x : D → Real),
                                                  @Membership.mem.{u_3, u_3} (D → Real) (Set.{u_3} (D → Real))
                                                      (@Set.instMembership.{u_3} (D → Real)) target x →
                                                    @Exists.{1} (Cell n) fun (cell : Cell n) =>
                                                      @Membership.mem.{u_3, u_3} (D → Real) (Set.{u_3} (D → Real))
                                                        (@Set.instMembership.{u_3} (D → Real))
                                                        (@NumStability.FiniteVolumeCellPartition.cellRegion.{0, u_3}
                                                          (Cell n) (D → Real)
                                                          (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real)
                                                            fun (a : D) => Real.measurableSpace)
                                                          (@NumStability.FiniteCoordinate.PhysicalData.cells.{u_3, 0, 0,
                                                                u_3, u_4}
                                                            D (Cell n) (Face n) (D → Real) FacePoint
                                                            (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real)
                                                              fun (a : D) => Real.measurableSpace)
                                                            (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real)
                                                              fun (i : D) =>
                                                              @UniformSpace.toTopologicalSpace.{0} Real
                                                                (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                  Real.pseudoMetricSpace))
                                                            inst_1 m (data n))
                                                          cell)
                                                        x) →
                                              (bounded_cells :
                                                  ∀ (n : Nat) (cell : Cell n),
                                                    @Bornology.IsBounded.{u_3} (D → Real)
                                                      (@Pi.instBornology.{u_3, 0} D (fun (a : D) => Real) fun (i : D) =>
                                                        @PseudoMetricSpace.toBornology.{0} Real Real.pseudoMetricSpace)
                                                      (@NumStability.FiniteVolumeCellPartition.cellRegion.{0, u_3}
                                                        (Cell n) (D → Real)
                                                        (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real)
                                                          fun (a : D) => Real.measurableSpace)
                                                        (@NumStability.FiniteCoordinate.PhysicalData.cells.{u_3, 0, 0,
                                                              u_3, u_4}
                                                          D (Cell n) (Face n) (D → Real) FacePoint
                                                          (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real)
                                                            fun (a : D) => Real.measurableSpace)
                                                          (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real)
                                                            fun (i : D) =>
                                                            @UniformSpace.toTopologicalSpace.{0} Real
                                                              (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                Real.pseudoMetricSpace))
                                                          inst_1 m (data n))
                                                        cell)) →
                                                (mesh : Nat → Real) →
                                                  (mesh_actual :
                                                      ∀ (n : Nat),
                                                        @Eq.{1} Real (mesh n)
                                                          (@NumStability.FiniteVolumeCellPartition.mesh.{0, u_3}
                                                            (Cell n) (D → Real) (finiteCell n)
                                                            (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real)
                                                              fun (a : D) => Real.measurableSpace)
                                                            (@pseudoMetricSpacePi.{u_3, 0} D (fun (a : D) => Real) inst
                                                              fun (b : D) => Real.pseudoMetricSpace)
                                                            (@NumStability.FiniteCoordinate.PhysicalData.cells.{u_3, 0,
                                                                  0, u_3, u_4}
                                                              D (Cell n) (Face n) (D → Real) FacePoint
                                                              (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real)
                                                                fun (a : D) => Real.measurableSpace)
                                                              (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real)
                                                                fun (i : D) =>
                                                                @UniformSpace.toTopologicalSpace.{0} Real
                                                                  (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                    Real.pseudoMetricSpace))
                                                              inst_1 m (data n)))) →
                                                    (mesh_pos :
                                                        ∀ (n : Nat),
                                                          @LT.lt.{0} Real Real.instLT
                                                            (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                              (@Zero.toOfNat0.{0} Real Real.instZero))
                                                            (mesh n)) →
                                                      (mesh_tendsto :
                                                          @Filter.Tendsto.{0, 0} Nat Real mesh
                                                            (@Filter.atTop.{0} Nat Nat.instPreorder)
                                                            (@nhds.{0} Real
                                                              (@UniformSpace.toTopologicalSpace.{0} Real
                                                                (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                                  Real.pseudoMetricSpace))
                                                              (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                                (@Zero.toOfNat0.{0} Real Real.instZero)))) →
                                                        (horizon : Real) →
                                                          (horizon_pos :
                                                              @LT.lt.{0} Real Real.instLT
                                                                (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                                  (@Zero.toOfNat0.{0} Real Real.instZero))
                                                                horizon) →
                                                            (boundaryRegion :
                                                                (n : Nat) → D → Line n → Int → Set.{u_3} (D → Real)) →
                                                              (boundary_measurable :
                                                                  ∀ (n : Nat) (d : D) (line : Line n) (j : Int),
                                                                    @MeasurableSet.{u_3} (D → Real)
                                                                      (@MeasurableSpace.pi.{u_3, 0} D
                                                                        (fun (a : D) => Real) fun (a : D) =>
                                                                        Real.measurableSpace)
                                                                      (boundaryRegion n d line j)) →
                                                                (boundary_positive :
                                                                    ∀ (n : Nat) (d : D) (line : Line n) (j : Int),
                                                                      @Ne.{1} ENNReal
                                                                        (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1}
                                                                          (@MeasureTheory.Measure.{u_3} (D → Real)
                                                                            (@MeasurableSpace.pi.{u_3, 0} D
                                                                              (fun (a : D) => Real) fun (a : D) =>
                                                                              Real.measurableSpace))
                                                                          (Set.{u_3} (D → Real))
                                                                          (fun (x : Set.{u_3} (D → Real)) => ENNReal)
                                                                          (@MeasureTheory.Measure.instFunLike.{u_3}
                                                                            (D → Real)
                                                                            (@MeasurableSpace.pi.{u_3, 0} D
                                                                              (fun (a : D) => Real) fun (a : D) =>
                                                                              Real.measurableSpace))
                                                                          measure (boundaryRegion n d line j))
                                                                        (@OfNat.ofNat.{0} ENNReal (nat_lit 0)
                                                                          (@Zero.toOfNat0.{0} ENNReal
                                                                            instZeroENNReal))) →
                                                                  (boundary_finite :
                                                                      ∀ (n : Nat) (d : D) (line : Line n) (j : Int),
                                                                        @Ne.{1} ENNReal
                                                                          (@DFunLike.coe.{u_3 + 1, u_3 + 1, 1}
                                                                            (@MeasureTheory.Measure.{u_3} (D → Real)
                                                                              (@MeasurableSpace.pi.{u_3, 0} D
                                                                                (fun (a : D) => Real) fun (a : D) =>
                                                                                Real.measurableSpace))
                                                                            (Set.{u_3} (D → Real))
                                                                            (fun (x : Set.{u_3} (D → Real)) => ENNReal)
                                                                            (@MeasureTheory.Measure.instFunLike.{u_3}
                                                                              (D → Real)
                                                                              (@MeasurableSpace.pi.{u_3, 0} D
                                                                                (fun (a : D) => Real) fun (a : D) =>
                                                                                Real.measurableSpace))
                                                                            measure (boundaryRegion n d line j))
                                                                          (@Top.top.{0} ENNReal instTopENNReal)) →
                                                                    (boundary_inside :
                                                                        ∀ (n : Nat) (d : D) (line : Line n) (j : Int),
                                                                          @HasSubset.Subset.{u_3} (Set.{u_3} (D → Real))
                                                                            (@Set.instHasSubset.{u_3} (D → Real))
                                                                            (boundaryRegion n d line j) region) →
                                                                      @NumStability.PhysicalRefinementQuality.Family.{u_3,
                                                                            u_4}
                                                                        D FacePoint inst inst_1 m
```

### D017: `NumStability.CapacityCoordinate.Method`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `7fe1b8d81dde68d0aa9a22e310c459de00a4aea6739b52182719570d9063f441`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                      NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → Type (max u_1 u_6)
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    (data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m) →
                      (coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line) →
                        Type (max u_1 u_6)
```

### D018: `NumStability.CapacityCoordinate.Method.StableAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `0b383f883cd6802a5ec2ec73b164e7bd913d5cffb598f127bd60d6613fde5a4d`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        NumStability.CapacityCoordinate.Method data coord → D → Real → Real → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        (method :
                            @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point
                              FacePoint Line inst inst_1 inst_2 m data coord) →
                          (d : D) → (dt A : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} {data} {coord} method d dt A =>
  ∀ (cell : Cell) (values other : Int → Fin m → Real),
    method.admitted d (coord.cellLine d cell) dt values →
      method.admitted d (coord.cellLine d cell) dt other →
        ∀ (E : Real),
          Real.instLE.le 0 E →
            (∀ (j : Int), Real.instLE.le (Pi.normedRing.norm (instHSub.hSub (values j) (other j))) E) →
              Real.instLE.le
                (Pi.normedRing.norm
                  (instHSub.hSub
                    (NumStability.FiniteCoordinate.PhysicalLine.lineAdvance data coord method.numericalFlux d
                      (coord.cellLine d cell) dt values (coord.cellIndex d cell))
                    (NumStability.FiniteCoordinate.PhysicalLine.lineAdvance data coord method.numericalFlux d
                      (coord.cellLine d cell) dt other (coord.cellIndex d cell))))
                (instHMul.hMul A E)
```

### D019: `NumStability.CapacityCoordinate.Method.admitted`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `d9c9eb450e1b758ac60074d8e4ef307f0ebe59f363d84c03f1cfee7ab56e39ae`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        NumStability.CapacityCoordinate.Method data coord →
                          D → Line → Real → (Int → Fin m → Real) → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        (self :
                            @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point
                              FacePoint Line inst inst_1 inst_2 m data coord) →
                          D → Line → Real → (Int → Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint Line [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m data
    coord self =>
  self.3
```

### D020: `NumStability.CapacityCoordinate.Method.numericalFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4d5e36080bdcb8ee36071f560313d21153063cd85ff42041a9eb351a60b33603`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        NumStability.CapacityCoordinate.Method data coord →
                          D → Line → Real → (Int → Fin m → Real) → Int → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        (self :
                            @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point
                              FacePoint Line inst inst_1 inst_2 m data coord) →
                          D → Line → Real → (Int → Fin m → Real) → Int → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint Line [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m data
    coord self =>
  self.2
```

### D021: `NumStability.CapacityCoordinate.Method.rule`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `bd83e8914eca5003a20e0e0ab2cc0d0e871c145e27bb96943a3af063fc67636d`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        NumStability.CapacityCoordinate.Method data coord →
                          D → Real → (Cell → Fin m → Real) → Face → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        (method :
                            @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point
                              FacePoint Line inst inst_1 inst_2 m data coord) →
                          (d : D) → (dt : Real) → (current : Cell → Fin m → Real) → (face : Face) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} {data} {coord} method =>
  NumStability.FiniteCoordinate.PhysicalLine.faceRule coord method.numericalFlux
```

### D022: `NumStability.CapacityCoordinate.Method.withGhost`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `46bf62a8d1bfbc7d25cd0f5baea02ef873a524ac42929e026b04902e688568bb`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        NumStability.CapacityCoordinate.Method data coord →
                          (newGhost : D → Line → Int → Fin m → Real) →
                            NumStability.CapacityCoordinate.Method data (coord.withGhost newGhost)
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        (method :
                            @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point
                              FacePoint Line inst inst_1 inst_2 m data coord) →
                          (newGhost : D → Line → Int → Fin m → Real) →
                            @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point
                              FacePoint Line inst inst_1 inst_2 m data
                              (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, u_2, u_3, u_6} D Cell Face
                                Line m coord newGhost)
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} {data} {coord} method newGhost =>
  { incidence := ⋯, numericalFlux := method.numericalFlux, admitted := method.admitted }
```

### D023: `NumStability.CapacityCoordinate.Sweep.run`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateSweep`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `94d524dbf5d9c42e7a27e9eeb571e52f16fdf7f174eadff964189dde87f97804`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : Nat → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        ((k : Nat) → NumStability.CapacityCoordinate.Method data (coord k)) →
                          (Nat → D) → (Nat → Real) → (Cell → Fin m → Real) → Nat → Cell → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord :
                          Nat →
                            @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        (method :
                            (k : Nat) →
                              @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point
                                FacePoint Line inst inst_1 inst_2 m data (coord k)) →
                          (direction : Nat → D) →
                            (duration : Nat → Real) → (initial : Cell → Fin m → Real) → Nat → Cell → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} {data} {coord} method direction duration initial =>
  NumStability.SequentialError.execution (NumStability.CapacityCoordinate.Sweep.step method direction duration) initial
```

### D024: `NumStability.CapacityCoordinate.Sweep.step`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateSweep`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `6a8b3e854213d2700697d2dfba707972c099dd5d077508017cccdb3d249da6cf`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : Nat → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        ((k : Nat) → NumStability.CapacityCoordinate.Method data (coord k)) →
                          (Nat → D) → (Nat → Real) → Nat → (Cell → Fin m → Real) → Cell → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord :
                          Nat →
                            @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        (method :
                            (k : Nat) →
                              @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point
                                FacePoint Line inst inst_1 inst_2 m data (coord k)) →
                          (direction : Nat → D) →
                            (duration : Nat → Real) → (n : Nat) → (Cell → Fin m → Real) → Cell → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} {data} {coord} method direction duration n =>
  NumStability.FiniteCoordinate.advance data (method n).rule (direction n) (duration n)
```

### D025: `NumStability.CartesianGrid.cellBox`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `d98a429751fc75f171b958d377c6c9899691b75351f20921fd09cff68df67a58`

Type:

```lean
{D : Type u_1} → (D → NumStability.OneDimensionalFiniteVolumeGrid) → (D → Int) → Set (D → Real)
```

Fully explicit type:

```lean
{D : Type u_1} → (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) → (cell : D → Int) → Set.{u_1} (D → Real)
```

Definition body (one-level semantic boundary):

```lean
fun {D} axes cell => Set.univ.pi fun d => Set.Ico ((axes d).cellLeft (cell d)) ((axes d).cellRight (cell d))
```

### D026: `NumStability.CartesianGrid.cellVolume`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `b2c577258c5fb7c0706c03a3c2c5a1d18a889d5f555b229b2fc11de44c0243ea`

Type:

```lean
{D : Type u_1} → [Fintype D] → (D → NumStability.OneDimensionalFiniteVolumeGrid) → (D → Int) → Real
```

Fully explicit type:

```lean
{D : Type u_1} → [Fintype.{u_1} D] → (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) → (cell : D → Int) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} [Fintype D] axes cell => Finset.univ.prod fun d => (axes d).cellVolume (cell d)
```

### D027: `NumStability.CartesianGrid.faceArea`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `51648336baeec9a7c5985999877892e66b8ac454f3300738dcfe2126a1cfd017`

Type:

```lean
{D : Type u_1} →
  [Fintype D] → [DecidableEq D] → (D → NumStability.OneDimensionalFiniteVolumeGrid) → D → (D → Int) → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  [Fintype.{u_1} D] →
    [DecidableEq.{u_1 + 1} D] →
      (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) → (d : D) → (cell : D → Int) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} [Fintype D] [DecidableEq D] axes d cell => (Finset.univ.erase d).prod fun e => (axes e).cellVolume (cell e)
```

### D028: `NumStability.FiniteCartesian.CartesianIdentification`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `2e3439768a0fbc54c1d41b6a497acfde4f9ad5db17875a864377dbde7ef3dd8d`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {FacePoint : Type u_4} →
        [Fintype D] →
          [DecidableEq D] →
            [inst : MeasurableSpace FacePoint] →
              {m : Nat} →
                NumStability.FiniteCoordinate.PhysicalData D Cell Face (D → Real) FacePoint m →
                  (D → NumStability.OneDimensionalFiniteVolumeGrid) →
                    (Cell → D → Int) → (D → Face → D → Int) → (D → (Fin m → Real) → Fin m → Real) → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {FacePoint : Type u_4} →
        [Fintype.{u_1} D] →
          [DecidableEq.{u_1 + 1} D] →
            [inst : MeasurableSpace.{u_4} FacePoint] →
              {m : Nat} →
                (data :
                    @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
                      FacePoint
                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                        @UniformSpace.toTopologicalSpace.{0} Real
                          (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                      inst m) →
                  (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) →
                    (cellPosition : Cell → D → Int) →
                      (facePosition : D → Face → D → Int) → (flux : D → (Fin m → Real) → Fin m → Real) → Prop
```

### D029: `NumStability.FiniteCoordinate.LineCoordinates`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `59dee5f979b8edefac128d6f364207d8d4c4a33238b58657ad6e0b9384a9aa82`

Type:

```lean
{m : Nat} → Type u_5 → Type u_6 → Type u_7 → Type u_8 → Type (max (max (max u_5 u_6) u_7) u_8)
```

Fully explicit type:

```lean
{m : Nat} →
  (D : Type u_5) → (Cell : Type u_6) → (Face : Type u_7) → (Line : Type u_8) → Type (max (max (max u_5 u_6) u_7) u_8)
```

### D030: `NumStability.FiniteCoordinate.LineCoordinates.cellIndex`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `7b1d1ea9733ff7c1765154636b01bca010437fb97f43cb85c67bd6e7185debf4`

Type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Cell → Int
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_5, u_6, u_7, u_8} m D Cell Face Line) →
            D → Cell → Int
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.2
```

### D031: `NumStability.FiniteCoordinate.LineCoordinates.cellLine`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `e2034887094da942515579cf5ec21e28c92b89ff50d587608231cbcb82644c2a`

Type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Cell → Line
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_5, u_6, u_7, u_8} m D Cell Face Line) →
            D → Cell → Line
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.1
```

### D032: `NumStability.FiniteCoordinate.LineCoordinates.extract`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `3d466e8f1b8cbdd57b56e9d9e25fbc5288f68c84b2ae07b30dbc4387c0f51211`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Line : Type u_4} →
        {m : Nat} →
          NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line →
            D → Line → (Cell → Fin m → Real) → Int → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Line : Type u_4} →
        {m : Nat} →
          (coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_4} m D Cell Face Line) →
            (d : D) → (line : Line) → (current : Cell → Fin m → Real) → (j : Int) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Line} {m} coord d line current j =>
  NumStability.FiniteCoordinate.LineCoordinates.extract.match_1 (fun x => Fin m → Real) (coord.lookup d line j)
    (fun cell => current cell) fun _ => coord.ghost d line j
```

### D033: `NumStability.FiniteCoordinate.LineCoordinates.lookup`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ffb4654e220a2cfbea1fae3bc4ca035fb779d23dcca9fa6332810e0234d52d1c`

Type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} →
          NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Line → Int → Option Cell
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_5, u_6, u_7, u_8} m D Cell Face Line) →
            D → Line → Int → Option.{u_6} Cell
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.5
```

### D034: `NumStability.FiniteCoordinate.LineCoordinates.withGhost`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a6eaee2b949d3a248d5c8b49a6f5e2258b824951eeb1cfc465d4f5269b956db4`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Line : Type u_4} →
        {m : Nat} →
          NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line →
            (D → Line → Int → Fin m → Real) → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Line : Type u_4} →
        {m : Nat} →
          (coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_4} m D Cell Face Line) →
            (newGhost : D → Line → Int → Fin m → Real) →
              @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_4} m D Cell Face Line
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Line} {m} coord newGhost =>
  { cellLine := coord.cellLine, cellIndex := coord.cellIndex, faceLine := coord.faceLine, faceIndex := coord.faceIndex,
    lookup := coord.lookup, lookup_cell := ⋯, lookup_sound := ⋯, ghost := newGhost }
```

### D035: `NumStability.FiniteCoordinate.PhysicalData`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `d9acae0614eda36259cbe72ec8a6b53e8cbee9ee4318f08ffddfe952511ee822`

Type:

```lean
Type u_1 →
  Type u_2 →
    Type u_3 →
      (Point : Type u_4) →
        (FacePoint : Type u_5) →
          [MeasurableSpace Point] →
            [TopologicalSpace Point] →
              [MeasurableSpace FacePoint] → Nat → Type (max (max (max (max u_1 u_2) u_3) u_4) u_5)
```

Fully explicit type:

```lean
(D : Type u_1) →
  (Cell : Type u_2) →
    (Face : Type u_3) →
      (Point : Type u_4) →
        (FacePoint : Type u_5) →
          [MeasurableSpace.{u_4} Point] →
            [TopologicalSpace.{u_4} Point] →
              [MeasurableSpace.{u_5} FacePoint] → (m : Nat) → Type (max (max (max (max u_1 u_2) u_3) u_4) u_5)
```

### D036: `NumStability.FiniteCoordinate.PhysicalData.ReferenceOn`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `97864db533199bfffab129e823620c9471721f55f30c32eace06515ec03530b8`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    D → (Point → Real → Fin m → Real) → Real → Real → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (d : D) → (q : Point → Real → Fin m → Real) → (s t : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data d q s t =>
  And
    (∀ (cell : Cell) (τ : Real),
      Set.instMembership.mem (Set.uIcc s t) τ →
        MeasureTheory.IntegrableOn (fun x => q x τ) (data.cells.cellRegion cell) data.measure)
    (And
      (∀ (cell : Cell) (τ : Real),
        Set.instMembership.mem (Set.uIcc s t) τ →
          And
            (MeasureTheory.Integrable
              (fun point =>
                data.normalFlux d (data.leftFace d cell) point (q (data.facePoint d (data.leftFace d cell) point) τ))
              (data.faceMeasure d (data.leftFace d cell)))
            (MeasureTheory.Integrable
              (fun point =>
                data.normalFlux d (data.rightFace d cell) point (q (data.facePoint d (data.rightFace d cell) point) τ))
              (data.faceMeasure d (data.rightFace d cell))))
      (And
        (∀ (x : Point),
          Set.instMembership.mem data.cells.domain x →
            ∀ (τ : Real),
              Set.instMembership.mem (Set.uIcc s t) τ → Set.instMembership.mem (data.admissibleStates d) (q x τ))
        (∀ (u : Real),
          Set.instMembership.mem (Set.uIcc s t) u →
            ∀ (v : Real),
              Set.instMembership.mem (Set.uIcc s t) v →
                And
                  (∀ (cell : Cell),
                    And (IntervalIntegrable (data.faceFlux d q (data.leftFace d cell)) Real.measureSpace.volume u v)
                      (IntervalIntegrable (data.faceFlux d q (data.rightFace d cell)) Real.measureSpace.volume u v))
                  (∀ (cell : Cell),
                    Eq
                      (instHSMul.hSMul (data.cellVolume cell)
                        (instHSub.hSub (data.cellMean q cell v) (data.cellMean q cell u)))
                      (intervalIntegral
                        (fun τ =>
                          instHSub.hSub (data.faceFlux d q (data.leftFace d cell) τ)
                            (data.faceFlux d q (data.rightFace d cell) τ))
                        u v Real.measureSpace.volume)))))
```

### D037: `NumStability.FiniteCoordinate.PhysicalData.admissibleStates`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `0c48dda27ed14c7015d2edc0b2f3ee757195ea317f236b4a384d7eef8e022399`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m → D → Set (Fin m → Real)
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Set.{0} (Fin m → Real)
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.11
```

### D038: `NumStability.FiniteCoordinate.PhysicalData.cellMean`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `7b645175230b06ccfdc98256713a331c11e663b8958c8b71ba97902ea37d8738`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    (Point → Real → Fin m → Real) → Cell → Real → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (q : Point → Real → Fin m → Real) → (cell : Cell) → (t : Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data q cell t =>
  NumStability.cellVolumeAverage data.measure (data.cells.cellRegion cell) fun x => q x t
```

### D039: `NumStability.FiniteCoordinate.PhysicalData.cellVolume`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `3740809241090b0fa337df1ea6f347bce37508ae5f099a58d1bb40482c9e1de6`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} → NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m → Cell → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (cell : Cell) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data cell =>
  (MeasureTheory.Measure.instFunLike.coe data.measure (data.cells.cellRegion cell)).toReal
```

### D040: `NumStability.FiniteCoordinate.PhysicalData.cells`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `94036f4fe18549ad26ea64b90e1c90e52c45baa0cfa079c61b9e6ff1921bed2b`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    NumStability.FiniteVolumeCellPartition Cell Point
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    @NumStability.FiniteVolumeCellPartition.{u_2, u_4} Cell Point inst
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.1
```

### D041: `NumStability.FiniteCoordinate.PhysicalData.faceFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `84b61d6ae40dc926057db05bb70fe6684afe2771af942506ef9767ffb3d9c7ed`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    D → (Point → Real → Fin m → Real) → Face → Real → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (d : D) → (q : Point → Real → Fin m → Real) → (face : Face) → (t : Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data d q face t =>
  MeasureTheory.integral (data.faceMeasure d face) fun point =>
    data.normalFlux d face point (q (data.facePoint d face point) t)
```

### D042: `NumStability.FiniteCoordinate.PhysicalData.facePoint`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `6bfc8f55388278fc8fb34c1520d136a00ccc6ddc67865b67fc067888138be154`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    D → Face → FacePoint → Point
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Face → FacePoint → Point
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.8
```

### D043: `NumStability.FiniteCoordinate.PhysicalData.leftFace`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `f0c97fbc4dfc618572b13da72459e2376fc2f1f5ad8e382df2b3f6b0c5914363`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} → NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m → D → Cell → Face
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Cell → Face
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.5
```

### D044: `NumStability.FiniteCoordinate.PhysicalData.measure`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `967a8b8c99c6c7e20f030623e5538d7c0f600586623ab46aaddb3d63534c2e2f`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m → MeasureTheory.Measure Point
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    @MeasureTheory.Measure.{u_4} Point inst
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.2
```

### D045: `NumStability.FiniteCoordinate.PhysicalData.normalFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `b6886690342b2d280916b55714903f8d01ae83e9df5270b33a078c8d384bffa6`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    D → Face → FacePoint → (Fin m → Real) → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Face → FacePoint → (Fin m → Real) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.12
```

### D046: `NumStability.FiniteCoordinate.PhysicalData.rightFace`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8d17eb50708ace3c80d39f12f9794b0dc63f49d4fd6a3b65b527a7e48bd1ea8c`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} → NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m → D → Cell → Face
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Cell → Face
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.6
```

### D047: `NumStability.FiniteCoordinate.PhysicalLine.lineAdvance`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalLineCapacity`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `87b947b673928fd23119acfcebc93698f9d445bda3b8d6ee8b2eac490490fbce`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                      NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line →
                        (D → Line → Real → (Int → Fin m → Real) → Int → Fin m → Real) →
                          D → Line → Real → (Int → Fin m → Real) → Int → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    (data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m) →
                      (coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line) →
                        (numericalFlux : D → Line → Real → (Int → Fin m → Real) → Int → Fin m → Real) →
                          (d : D) →
                            (line : Line) → (dt : Real) → (values : Int → Fin m → Real) → (j : Int) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} data coord numericalFlux d line dt values j =>
  NumStability.finiteVolumeCellAverageUpdate dt
    (NumStability.FiniteCoordinate.PhysicalLine.capacity data coord d line j) (values j)
    (instHSub.hSub (numericalFlux d line dt values (instHAdd.hAdd j 1)) (numericalFlux d line dt values j))
```

### D048: `NumStability.FiniteCoordinate.advance`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `b2254dd74a7c5a9b75a35e1a4d7149a146256d9df6a6ab3ee00b212e6802c339`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    (D → Real → (Cell → Fin m → Real) → Face → Fin m → Real) →
                      D → Real → (Cell → Fin m → Real) → Cell → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (rule : D → Real → (Cell → Fin m → Real) → Face → Fin m → Real) →
                      (d : D) → (dt : Real) → (current : Cell → Fin m → Real) → (cell : Cell) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data rule d dt current cell =>
  NumStability.finiteVolumeCellAverageUpdate dt (data.cellVolume cell) (current cell)
    (instHSub.hSub (rule d dt current (data.rightFace d cell)) (rule d dt current (data.leftFace d cell)))
```

### D049: `NumStability.FiniteCoordinate.netFluxDefect`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalFluxError`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a3c8dda11e1162da6e807cae24b82d29d4d1699223b88e91a2f5e9e3f4d20db9`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    (D → Real → (Cell → Fin m → Real) → Face → Fin m → Real) →
                      D → (Cell → Fin m → Real) → (Point → Real → Fin m → Real) → Real → Real → Cell → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (data :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    (rule : D → Real → (Cell → Fin m → Real) → Face → Fin m → Real) →
                      (d : D) →
                        (current : Cell → Fin m → Real) →
                          (q : Point → Real → Fin m → Real) → (s t : Real) → (cell : Cell) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]
    {m} data rule d current q s t cell =>
  instHSub.hSub
    (instHSub.hSub (rule d (instHSub.hSub t s) current (data.leftFace d cell))
      (NumStability.oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t))
    (instHSub.hSub (rule d (instHSub.hSub t s) current (data.rightFace d cell))
      (NumStability.oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t))
```

### D050: `NumStability.FiniteVolumeCellPartition.cellRegion`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `32dd6b17c69eb1ad645253a6f164e371ce8f60b4e07173cb0964fefc72bfff00`

Type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace Point] → NumStability.FiniteVolumeCellPartition Cell Point → Cell → Set Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace.{u_2} Point] →
      (self : @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst) → Cell → Set.{u_2} Point
```

Definition body (one-level semantic boundary):

```lean
fun Cell Point [MeasurableSpace Point] self => self.2
```

### D051: `NumStability.FiniteVolumeCellPartition.mesh`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCellMesh`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `a9a337d8229e4c745e57be7b7969754be89e0d1b6090aee42d864a02cebf62a8`

Type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [Fintype Cell] →
      [inst : MeasurableSpace Point] →
        [PseudoMetricSpace Point] → NumStability.FiniteVolumeCellPartition Cell Point → Real
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [Fintype.{u_1} Cell] →
      [inst : MeasurableSpace.{u_2} Point] →
        [PseudoMetricSpace.{u_2} Point] →
          (cells : @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} {Point} [Fintype Cell] [MeasurableSpace Point] [PseudoMetricSpace Point] cells =>
  Finset.univ.sup' ⋯ fun cell => Metric.diam (cells.cellRegion cell)
```

### D052: `NumStability.IsRectangleConservationLawSolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `fbb14b5d2b7941d655b995775ba7559106550b42dada80ff310b1923062aded3`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → Real → E) → (E → E) → Prop
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} E] →
    [@NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)] →
      (q : Real → Real → E) → (flux : E → E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] q flux =>
  And (∀ (a b t : Real), IntervalIntegrable (fun x => q x t) Real.measureSpace.volume a b)
    (And (∀ (x s t : Real), IntervalIntegrable (fun τ => flux (q x τ)) Real.measureSpace.volume s t)
      (∀ (a b s t : Real),
        Eq
          (instHSub.hSub (intervalIntegral (fun x => q x t) a b Real.measureSpace.volume)
            (intervalIntegral (fun x => q x s) a b Real.measureSpace.volume))
          (intervalIntegral (fun τ => instHSub.hSub (flux (q a τ)) (flux (q b τ))) s t Real.measureSpace.volume)))
```

### D053: `NumStability.OneDimensionalFiniteVolumeGrid`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `f45b4f5e41b1c7954e0f18cce119693e8b371eeee4d32f4d849109d5363609ce`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D054: `NumStability.OneDimensionalFiniteVolumeGrid.cellLeft`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `b7710f4b704055e41f311498ad422f4456733c8825429083c430d39299154b76`

Type:

```lean
NumStability.OneDimensionalFiniteVolumeGrid → Int → Real
```

Fully explicit type:

```lean
(self : NumStability.OneDimensionalFiniteVolumeGrid) → Int → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.1
```

### D055: `NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `d3757f42f8ae2e6cd7fb494b2c9fabccc81647d0ec2e95b576d9478b032d913a`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          NumStability.PhysicalRefinementQuality.Family D FacePoint m →
            D → ((D → Real) → Real → Fin m → Real) → Real → Type
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m) →
            (d : D) → (q : (D → Real) → Real → Fin m → Real) → (p : Real) → Type
```

### D056: `NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.constant`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `d274cff607c3a772e82ac61523ef1fe970a0ae3a7848f6b4c61c30f0ae90ee4f`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          {family : NumStability.PhysicalRefinementQuality.Family D FacePoint m} →
            {d : D} → {q : (D → Real) → Real → Fin m → Real} → {p : Real} → family.AccuracyCertificate d q p → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          {family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m} →
            {d : D} →
              {q : (D → Real) → Real → Fin m → Real} →
                {p : Real} →
                  (self :
                      @NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.{u_1, u_2} D FacePoint inst
                        inst_1 m family d q p) →
                    Real
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m family d q p self => self.1
```

### D057: `NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.threshold`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `74607ae40f95c62a0c679353521f76f54e8527db1f8c2f871803c696f4cbe9d0`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          {family : NumStability.PhysicalRefinementQuality.Family D FacePoint m} →
            {d : D} → {q : (D → Real) → Real → Fin m → Real} → {p : Real} → family.AccuracyCertificate d q p → Nat
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          {family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m} →
            {d : D} →
              {q : (D → Real) → Real → Fin m → Real} →
                {p : Real} →
                  (self :
                      @NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.{u_1, u_2} D FacePoint inst
                        inst_1 m family d q p) →
                    Nat
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m family d q p self => self.3
```

### D058: `NumStability.PhysicalRefinementQuality.Family.SmoothReference`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ec6aa91bad24ef2757cd4491749a0c87a4a5d06b8a9e7817523a0fd77451fe80`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          NumStability.PhysicalRefinementQuality.Family D FacePoint m → D → ((D → Real) → Real → Fin m → Real) → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m) →
            (d : D) → (q : (D → Real) → Real → Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {D} {FacePoint} [Fintype D] [MeasurableSpace FacePoint] {m} family d q =>
  And
    (ContDiffOn Real (WithTop.some instTopENat.top) (Function.uncurry q)
      (Set.instSProd.sprod (closure family.region) (Set.Icc 0 family.horizon)))
    (And (∀ (n : Nat), (family.data n).ReferenceOn d q 0 family.horizon)
      (∀ (n : Nat) (line : family.Line n) (j : Int),
        MeasureTheory.IntegrableOn (fun x => q x 0) (family.boundaryRegion n d line j) family.measure))
```

### D059: `NumStability.PhysicalRefinementQuality.Family.coordinates`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `cbbccad3b2ef4434b17d3ecbe4b62ba2ecfa4fd13c5e9dd5f93b8d4a7d6b5724`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (self : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (n : Nat) → NumStability.FiniteCoordinate.LineCoordinates D (self.Cell n) (self.Face n) (self.Line n)
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) →
            (n : Nat) →
              @NumStability.FiniteCoordinate.LineCoordinates.{u_3, 0, 0, 0} m D
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_3, u_4} D FacePoint inst inst_1 m self n)
                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_3, u_4} D FacePoint inst inst_1 m self n)
                (@NumStability.PhysicalRefinementQuality.Family.Line.{u_3, u_4} D FacePoint inst inst_1 m self n)
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.6
```

### D060: `NumStability.PhysicalRefinementQuality.Family.finiteCell`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `9c6c84781a5992940aa8e93c1caf6dddc2cf9f6869af4c0286fb4a06acdcad6a`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (self : NumStability.PhysicalRefinementQuality.Family D FacePoint m) → (n : Nat) → Fintype (self.Cell n)
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) →
            (n : Nat) →
              Fintype.{0}
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_3, u_4} D FacePoint inst inst_1 m self n)
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.4
```

### D061: `NumStability.PhysicalRefinementQuality.Family.mesh`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `52d62b3cc9b9475924c351aaa593c58b65c04f6d570389b5e036d5162f9c702f`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} → NumStability.PhysicalRefinementQuality.Family D FacePoint m → Nat → Real
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) → Nat → Real
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.23
```

### D062: `NumStability.PhysicalRefinementQuality.Family.method`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `c1fe488ce0e5a2398e67591dbaec3ff37b8f9d0f0969d3efdf2650cc9ba340df`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (self : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (n : Nat) → NumStability.CapacityCoordinate.Method (self.data n) (self.coordinates n)
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) →
            (n : Nat) →
              @NumStability.CapacityCoordinate.Method.{u_3, 0, 0, u_3, u_4, 0} D
                (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_3, u_4} D FacePoint inst inst_1 m self n)
                (@NumStability.PhysicalRefinementQuality.Family.Face.{u_3, u_4} D FacePoint inst inst_1 m self n)
                (D → Real) FacePoint
                (@NumStability.PhysicalRefinementQuality.Family.Line.{u_3, u_4} D FacePoint inst inst_1 m self n)
                (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                (@Pi.topologicalSpace.{0, u_3} D (fun (a : D) => Real) fun (i : D) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                inst_1 m
                (@NumStability.PhysicalRefinementQuality.Family.data.{u_3, u_4} D FacePoint inst inst_1 m self n)
                (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_3, u_4} D FacePoint inst inst_1 m self n)
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.7
```

### D063: `NumStability.PhysicalRefinementQuality.Family.projected`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `afae1896c8de7a48feb634b855d822d81587b46570283e6c7ee77b2e7566c05a`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (n : Nat) → ((D → Real) → Real → Fin m → Real) → Real → family.Cell n → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m) →
            (n : Nat) →
              (q : (D → Real) → Real → Fin m → Real) →
                (t : Real) →
                  @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family n →
                    Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {FacePoint} [Fintype D] [MeasurableSpace FacePoint] {m} family n q t cell => (family.data n).cellMean q cell t
```

### D064: `NumStability.PhysicalRefinementQuality.Family.referenceGhost`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `763a077f06590f17ffeec6ee3a9b0ad29e9edcc9f3110e0db72d3cd4f536fa18`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (n : Nat) → ((D → Real) → Real → Fin m → Real) → D → family.Line n → Int → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m) →
            (n : Nat) →
              (q : (D → Real) → Real → Fin m → Real) →
                D →
                  @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family n →
                    Int → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {FacePoint} [Fintype D] [MeasurableSpace FacePoint] {m} family n q d line j =>
  NumStability.cellVolumeAverage family.measure (family.boundaryRegion n d line j) fun x => q x 0
```

### D065: `NumStability.PhysicalRefinementQuality.Family.states`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `1c15a25f50eda423c461565a04e19a6dea27d4891e1d8143b53b8094f21069ff`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} → NumStability.PhysicalRefinementQuality.Family D FacePoint m → D → Set (Fin m → Real)
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) →
            D → Set.{0} (Fin m → Real)
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.10
```

### D066: `NumStability.PhysicalRefinementQuality.Family.variation`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `39eecfc41225310bdba1fab507a2f74d3f42b06f50134d5855d2cd40f97d732c`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (n : Nat) →
              D → family.Line n → (D → family.Line n → Int → Fin m → Real) → (family.Cell n → Fin m → Real) → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          (family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m) →
            (n : Nat) →
              (d : D) →
                (line :
                    @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family n) →
                  (ghost :
                      D →
                        @NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst inst_1 m family
                            n →
                          Int → Fin m → Real) →
                    (current :
                        @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst inst_1 m family
                            n →
                          Fin m → Real) →
                      Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {FacePoint} [Fintype D] [MeasurableSpace FacePoint] {m} family n d line ghost current =>
  (family.coordinates n).onceEdgeVariation d line ghost current
```

### D067: `NumStability.SequentialError.errorBudget`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.Normed.Group.SequentialError`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `d984609811fa87c7e033b59409eb7e5f0258effa210ef9867c92064d3800705d`

Type:

```lean
(Nat → Real) → (Nat → Real) → (Nat → Real) → Real → Nat → Real
```

Fully explicit type:

```lean
(amplification localDefect splittingDefect : Nat → Real) → (initialError : Real) → Nat → Real
```

Definition body (one-level semantic boundary):

```lean
fun amplification localDefect splittingDefect initialError x =>
  Nat.brecOn x fun x f =>
    NumStability.SequentialError.execution.match_1 (fun x => Nat.below x → Real) x (fun _ x => initialError)
      (fun n x =>
        instHAdd.hAdd (instHAdd.hAdd (instHMul.hMul (amplification n) x.1) (localDefect n)) (splittingDefect n))
      f
```

### D068: `NumStability.cellVolumeAverage`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `bc8800385daf12f69f5f7359f6f4ae6dcc02bae04ea06c59c19ad641935524ed`

Type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace Point] →
      [inst_1 : NormedAddCommGroup E] → [NormedSpace Real E] → MeasureTheory.Measure Point → Set Point → (Point → E) → E
```

Fully explicit type:

```lean
{Point : Type u_1} →
  {E : Type u_2} →
    [inst : MeasurableSpace.{u_1} Point] →
      [inst_1 : NormedAddCommGroup.{u_2} E] →
        [@NormedSpace.{0, u_2} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1)] →
          (μ : @MeasureTheory.Measure.{u_1} Point inst) → (region : Set.{u_1} Point) → (field : Point → E) → E
```

Definition body (one-level semantic boundary):

```lean
fun {Point} {E} [MeasurableSpace Point] [NormedAddCommGroup E] [NormedSpace Real E] μ region field =>
  instHSMul.hSMul (Real.instInv.inv (MeasureTheory.Measure.instFunLike.coe μ region).toReal)
    (MeasureTheory.integral (μ.restrict region) fun point => field point)
```

### D069: `NumStability.orderedOperatorSweep`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5830ce6de1bee8addeaf85abcbff49e9482235cb48e3ee7fec77df9b25815735`

Type:

```lean
{State : Type u_1} → List (State → State) → State → State
```

Fully explicit type:

```lean
{State : Type u_1} → (operators : List.{u_1} (State → State)) → (state : State) → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} operators state => List.foldl (fun current step => step current) state operators
```

### D070: `ContDiffOn`

- Role: `local`
- Owner module: `Mathlib.Analysis.Calculus.ContDiff.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `91ab156153c53f308b4d00d3e9f11d2d1af7628ac5401952845092471ae1aef4`

Type:

```lean
(𝕜 : Type u) →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type uE} →
      [inst_1 : NormedAddCommGroup E] →
        [NormedSpace 𝕜 E] →
          {F : Type uF} → [inst_3 : NormedAddCommGroup F] → [NormedSpace 𝕜 F] → WithTop ENat → (E → F) → Set E → Prop
```

Fully explicit type:

```lean
(𝕜 : Type u) →
  [inst : NontriviallyNormedField.{u} 𝕜] →
    {E : Type uE} →
      [inst_1 : NormedAddCommGroup.{uE} E] →
        [@NormedSpace.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1)] →
          {F : Type uF} →
            [inst_3 : NormedAddCommGroup.{uF} F] →
              [@NormedSpace.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)] →
                (n : WithTop.{0} ENat) → (f : E → F) → (s : Set.{uE} E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 [NontriviallyNormedField 𝕜] {E} [NormedAddCommGroup E] [NormedSpace 𝕜 E] {F} [NormedAddCommGroup F]
    [NormedSpace 𝕜 F] n f s =>
  ∀ (x : E), Set.instMembership.mem s x → ContDiffWithinAt 𝕜 n f s x
```

### D071: `NumStability.CapacityCoordinate.Method.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `dc07bab46fe26f103691c008a456b327c414f720fa13ead072df9b312b742711`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m} →
                      {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line} →
                        NumStability.FiniteCoordinate.PhysicalLine.Incidence data coord →
                          (D → Line → Real → (Int → Fin m → Real) → Int → Fin m → Real) →
                            (D → Line → Real → (Int → Fin m → Real) → Prop) →
                              NumStability.CapacityCoordinate.Method data coord
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    {data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m} →
                      {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line} →
                        (incidence :
                            @NumStability.FiniteCoordinate.PhysicalLine.Incidence.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell
                              Face Point FacePoint Line inst inst_1 inst_2 m data coord) →
                          (numericalFlux : D → Line → Real → (Int → Fin m → Real) → Int → Fin m → Real) →
                            (admitted : D → Line → Real → (Int → Fin m → Real) → Prop) →
                              @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point
                                FacePoint Line inst inst_1 inst_2 m data coord
```

### D072: `NumStability.CapacityCoordinate.Method.withGhost._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CapacityCoordinateMethod`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `a9f54c77d20690481a5cb7b0d77c268ba7ca52c4f64013037dd1cd10994cdd20`

Type:

```lean
∀ {D : Type u_1} {Cell : Type u_2} {Face : Type u_3} {Point : Type u_4} {FacePoint : Type u_5} {Line : Type u_6}
  [inst : MeasurableSpace Point] [inst_1 : TopologicalSpace Point] [inst_2 : MeasurableSpace FacePoint] {m : Nat}
  {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m}
  {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line}
  (method : NumStability.CapacityCoordinate.Method data coord) (newGhost : D → Line → Int → Fin m → Real),
  NumStability.FiniteCoordinate.PhysicalLine.Incidence data (coord.withGhost newGhost)
```

Fully explicit type:

```lean
∀ {D : Type u_1} {Cell : Type u_2} {Face : Type u_3} {Point : Type u_4} {FacePoint : Type u_5} {Line : Type u_6}
  [inst : MeasurableSpace.{u_4} Point] [inst_1 : TopologicalSpace.{u_4} Point]
  [inst_2 : MeasurableSpace.{u_5} FacePoint] {m : Nat}
  {data :
    @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint inst inst_1 inst_2
      m}
  {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line}
  (method :
    @NumStability.CapacityCoordinate.Method.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point FacePoint Line inst inst_1
      inst_2 m data coord)
  (newGhost : D → Line → Int → Fin m → Real),
  @NumStability.FiniteCoordinate.PhysicalLine.Incidence.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point FacePoint Line
    inst inst_1 inst_2 m data
    (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, u_2, u_3, u_6} D Cell Face Line m coord newGhost)
```

### D073: `NumStability.FiniteCartesian.CartesianIdentification.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `d2f9c3d27cf4021723a7478628984ca77467b14aa4905c7f76cb12405bd5e633`

Type:

```lean
∀ {D : Type u_1} {Cell : Type u_2} {Face : Type u_3} {FacePoint : Type u_4} [inst : Fintype D] [inst_1 : DecidableEq D]
  [inst_2 : MeasurableSpace FacePoint] {m : Nat}
  {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face (D → Real) FacePoint m}
  {axes : D → NumStability.OneDimensionalFiniteVolumeGrid} {cellPosition : Cell → D → Int}
  {facePosition : D → Face → D → Int} {flux : D → (Fin m → Real) → Fin m → Real},
  (∀ (d : D) (cell : Cell), Eq (facePosition d (data.leftFace d cell)) (cellPosition cell)) →
    (∀ (d : D) (cell : Cell),
        Eq (facePosition d (data.rightFace d cell))
          (Function.update (cellPosition cell) d (instHAdd.hAdd (cellPosition cell d) 1))) →
      (∀ (cell : Cell),
          Eq (data.measure.restrict (data.cells.cellRegion cell))
            (MeasureTheory.MeasureSpace.pi.volume.restrict
              (NumStability.CartesianGrid.cellBox axes (cellPosition cell)))) →
        (∀ (d : D) (face : Face), AEMeasurable (data.facePoint d face) (data.faceMeasure d face)) →
          (∀ (d : D) (face : Face),
              Eq (MeasureTheory.Measure.map (data.facePoint d face) (data.faceMeasure d face))
                (MeasureTheory.Measure.map (NumStability.CartesianGrid.facePoint axes d (facePosition d face))
                  (MeasureTheory.MeasureSpace.pi.volume.restrict
                    (NumStability.CartesianGrid.tangentialFaceBox axes d (facePosition d face))))) →
            (∀ (d : D) (face : Face),
                Filter.Eventually
                  (fun point => ∀ (value : Fin m → Real), Eq (data.normalFlux d face point value) (flux d value))
                  (MeasureTheory.ae (data.faceMeasure d face))) →
              NumStability.FiniteCartesian.CartesianIdentification data axes cellPosition facePosition flux
```

Fully explicit type:

```lean
∀ {D : Type u_1} {Cell : Type u_2} {Face : Type u_3} {FacePoint : Type u_4} [inst : Fintype.{u_1} D]
  [inst_1 : DecidableEq.{u_1 + 1} D] [inst_2 : MeasurableSpace.{u_4} FacePoint] {m : Nat}
  {data :
    @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real) FacePoint
      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
        @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
      inst_2 m}
  {axes : D → NumStability.OneDimensionalFiniteVolumeGrid} {cellPosition : Cell → D → Int}
  {facePosition : D → Face → D → Int} {flux : D → (Fin m → Real) → Fin m → Real}
  (left_position :
    ∀ (d : D) (cell : Cell),
      @Eq.{u_1 + 1} (D → Int)
        (facePosition d
          (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data d cell))
        (cellPosition cell))
  (right_position :
    ∀ (d : D) (cell : Cell),
      @Eq.{u_1 + 1} (D → Int)
        (facePosition d
          (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data d cell))
        (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst_1 (cellPosition cell) d
          (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) (cellPosition cell d)
            (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))))
  (cell_measure :
    ∀ (cell : Cell),
      @Eq.{u_1 + 1}
        (@MeasureTheory.Measure.{u_1} (D → Real)
          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace))
        (@MeasureTheory.Measure.restrict.{u_1} (D → Real)
          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
          (@NumStability.FiniteCoordinate.PhysicalData.measure.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data)
          (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_1} Cell (D → Real)
            (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@NumStability.FiniteCoordinate.PhysicalData.cells.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
              FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                @UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              inst_2 m data)
            cell))
        (@MeasureTheory.Measure.restrict.{u_1} (D → Real)
          (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1} (D → Real)
            (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst (fun (a : D) => Real) fun (i : D) => Real.measureSpace))
          (@MeasureTheory.MeasureSpace.volume.{u_1} (D → Real)
            (@MeasureTheory.MeasureSpace.pi.{u_1, 0} D inst (fun (a : D) => Real) fun (i : D) => Real.measureSpace))
          (@NumStability.CartesianGrid.cellBox.{u_1} D axes (cellPosition cell))))
  (face_measurable :
    ∀ (d : D) (face : Face),
      @AEMeasurable.{u_4, u_1} FacePoint (D → Real)
        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace) inst_2
        (@NumStability.FiniteCoordinate.PhysicalData.facePoint.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
          FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
            @UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          inst_2 m data d face)
        (@NumStability.FiniteCoordinate.PhysicalData.faceMeasure.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
          FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
            @UniformSpace.toTopologicalSpace.{0} Real
              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
          inst_2 m data d face))
  (face_measure :
    ∀ (d : D) (face : Face),
      @Eq.{u_1 + 1}
        (@MeasureTheory.Measure.{u_1} (D → Real)
          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace))
        (@MeasureTheory.Measure.map.{u_4, u_1} FacePoint (D → Real) inst_2
          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
          (@NumStability.FiniteCoordinate.PhysicalData.facePoint.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data d face)
          (@NumStability.FiniteCoordinate.PhysicalData.faceMeasure.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data d face))
        (@MeasureTheory.Measure.map.{u_1, u_1} ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
          (D → Real)
          (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1}
            ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
            (@MeasureTheory.MeasureSpace.pi.{u_1, 0} (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d)
              (@Subtype.fintype.{u_1} D (fun (e : D) => @Ne.{u_1 + 1} D e d)
                (fun (a : D) => @instDecidableNot (@Eq.{u_1 + 1} D a d) (inst_1 a d)) inst)
              (fun (a : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real)
              fun (i : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real.measureSpace))
          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
          (@NumStability.CartesianGrid.facePoint.{u_1} D inst_1 axes d (facePosition d face))
          (@MeasureTheory.Measure.restrict.{u_1} ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
            (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_1}
              ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
              (@MeasureTheory.MeasureSpace.pi.{u_1, 0} (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d)
                (@Subtype.fintype.{u_1} D (fun (e : D) => @Ne.{u_1 + 1} D e d)
                  (fun (a : D) => @instDecidableNot (@Eq.{u_1 + 1} D a d) (inst_1 a d)) inst)
                (fun (a : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real)
                fun (i : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real.measureSpace))
            (@MeasureTheory.MeasureSpace.volume.{u_1} ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
              (@MeasureTheory.MeasureSpace.pi.{u_1, 0} (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d)
                (@Subtype.fintype.{u_1} D (fun (e : D) => @Ne.{u_1 + 1} D e d)
                  (fun (a : D) => @instDecidableNot (@Eq.{u_1 + 1} D a d) (inst_1 a d)) inst)
                (fun (a : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real)
                fun (i : @Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) => Real.measureSpace))
            (@NumStability.CartesianGrid.tangentialFaceBox.{u_1} D axes d (facePosition d face)))))
  (normal_flux :
    ∀ (d : D) (face : Face),
      @Filter.Eventually.{u_4} FacePoint
        (fun (point : FacePoint) =>
          ∀ (value : Fin m → Real),
            @Eq.{1} (Fin m → Real)
              (@NumStability.FiniteCoordinate.PhysicalData.normalFlux.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
                FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
                (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                  @UniformSpace.toTopologicalSpace.{0} Real
                    (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                inst_2 m data d face point value)
              (flux d value))
        (@MeasureTheory.ae.{u_4, u_4} FacePoint (@MeasureTheory.Measure.{u_4} FacePoint inst_2)
          (@MeasureTheory.Measure.instFunLike.{u_4} FacePoint inst_2)
          (@MeasureTheory.Measure.instOuterMeasureClass.{u_4} FacePoint inst_2)
          (@NumStability.FiniteCoordinate.PhysicalData.faceMeasure.{u_1, u_2, u_3, u_1, u_4} D Cell Face (D → Real)
            FacePoint (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
              @UniformSpace.toTopologicalSpace.{0} Real
                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
            inst_2 m data d face))),
  @NumStability.FiniteCartesian.CartesianIdentification.{u_1, u_2, u_3, u_4} D Cell Face FacePoint inst inst_1 inst_2 m
    data axes cellPosition facePosition flux
```

### D074: `NumStability.FiniteCoordinate.LineCoordinates.extract.match_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `2e4d839afaf13f2da8ed62ea4cfa6ceda0fa824da3bf71d83f0f0141fc132705`

Type:

```lean
{Cell : Type u_1} →
  (motive : Option Cell → Sort u_2) →
    (x : Option Cell) → ((cell : Cell) → motive (Option.some cell)) → (Unit → motive Option.none) → motive x
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  (motive : Option.{u_1} Cell → Sort u_2) →
    (x : Option.{u_1} Cell) →
      (h_1 : (cell : Cell) → motive (@Option.some.{u_1} Cell cell)) →
        (h_2 : (a : Unit) → motive (@Option.none.{u_1} Cell)) → motive x
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} motive x h_1 h_2 => Option.casesOn x (h_2 Unit.unit) fun val => h_1 val
```

### D075: `NumStability.FiniteCoordinate.LineCoordinates.faceIndex`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `509086140f863614dab69f44609b39b8903d1de0ffbff3ae5f5713a1b776d2b5`

Type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Face → Int
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_5, u_6, u_7, u_8} m D Cell Face Line) →
            D → Face → Int
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.4
```

### D076: `NumStability.FiniteCoordinate.LineCoordinates.faceLine`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `04d99c346fd44193a0499bd789cd8739303fee0c691edc733404f330ab487248`

Type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Face → Line
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_5, u_6, u_7, u_8} m D Cell Face Line) →
            D → Face → Line
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.3
```

### D077: `NumStability.FiniteCoordinate.LineCoordinates.ghost`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `653539b80425be203fe14a0680e4a07a7eee41afb80be7d79d4745ad6ba3062d`

Type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} →
          NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Line → Int → Fin m → Real
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} →
          (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_5, u_6, u_7, u_8} m D Cell Face Line) →
            D → Line → Int → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun m D Cell Face Line self => self.8
```

### D078: `NumStability.FiniteCoordinate.LineCoordinates.lookup_cell`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `3e2736d198c3f38cd6318bd06f0705f48477484a80ca2ff18d6526ce5404421f`

Type:

```lean
∀ {m : Nat} {D : Type u_5} {Cell : Type u_6} {Face : Type u_7} {Line : Type u_8}
  (self : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line) (d : D) (cell : Cell),
  Eq (self.lookup d (self.cellLine d cell) (self.cellIndex d cell)) (Option.some cell)
```

Fully explicit type:

```lean
∀ {m : Nat} {D : Type u_5} {Cell : Type u_6} {Face : Type u_7} {Line : Type u_8}
  (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_5, u_6, u_7, u_8} m D Cell Face Line) (d : D) (cell : Cell),
  @Eq.{u_6 + 1} (Option.{u_6} Cell)
    (@NumStability.FiniteCoordinate.LineCoordinates.lookup.{u_5, u_6, u_7, u_8} m D Cell Face Line self d
      (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_5, u_6, u_7, u_8} m D Cell Face Line self d cell)
      (@NumStability.FiniteCoordinate.LineCoordinates.cellIndex.{u_5, u_6, u_7, u_8} m D Cell Face Line self d cell))
    (@Option.some.{u_6} Cell cell)
```

### D079: `NumStability.FiniteCoordinate.LineCoordinates.lookup_sound`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `71b8465d460f78674b9383553a9b2ae5271fb480dc4fd02b7a74f9eba11ff5e2`

Type:

```lean
∀ {m : Nat} {D : Type u_5} {Cell : Type u_6} {Face : Type u_7} {Line : Type u_8}
  (self : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line) (d : D) (line : Line) (j : Int) (cell : Cell),
  Eq (self.lookup d line j) (Option.some cell) → And (Eq (self.cellLine d cell) line) (Eq (self.cellIndex d cell) j)
```

Fully explicit type:

```lean
∀ {m : Nat} {D : Type u_5} {Cell : Type u_6} {Face : Type u_7} {Line : Type u_8}
  (self : @NumStability.FiniteCoordinate.LineCoordinates.{u_5, u_6, u_7, u_8} m D Cell Face Line) (d : D) (line : Line)
  (j : Int) (cell : Cell),
  @Eq.{u_6 + 1} (Option.{u_6} Cell)
      (@NumStability.FiniteCoordinate.LineCoordinates.lookup.{u_5, u_6, u_7, u_8} m D Cell Face Line self d line j)
      (@Option.some.{u_6} Cell cell) →
    And
      (@Eq.{u_8 + 1} Line
        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_5, u_6, u_7, u_8} m D Cell Face Line self d cell)
        line)
      (@Eq.{1} Int
        (@NumStability.FiniteCoordinate.LineCoordinates.cellIndex.{u_5, u_6, u_7, u_8} m D Cell Face Line self d cell)
        j)
```

### D080: `NumStability.FiniteCoordinate.LineCoordinates.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `019467a052a7c368326dd5601840a5403c488951cb7c72eb0a7c7a9d7293533b`

Type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} →
          (cellLine : D → Cell → Line) →
            (cellIndex : D → Cell → Int) →
              (D → Face → Line) →
                (D → Face → Int) →
                  (lookup : D → Line → Int → Option Cell) →
                    (∀ (d : D) (cell : Cell), Eq (lookup d (cellLine d cell) (cellIndex d cell)) (Option.some cell)) →
                      (∀ (d : D) (line : Line) (j : Int) (cell : Cell),
                          Eq (lookup d line j) (Option.some cell) →
                            And (Eq (cellLine d cell) line) (Eq (cellIndex d cell) j)) →
                        (D → Line → Int → Fin m → Real) → NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line
```

Fully explicit type:

```lean
{m : Nat} →
  {D : Type u_5} →
    {Cell : Type u_6} →
      {Face : Type u_7} →
        {Line : Type u_8} →
          (cellLine : D → Cell → Line) →
            (cellIndex : D → Cell → Int) →
              (faceLine : D → Face → Line) →
                (faceIndex : D → Face → Int) →
                  (lookup : D → Line → Int → Option.{u_6} Cell) →
                    (lookup_cell :
                        ∀ (d : D) (cell : Cell),
                          @Eq.{u_6 + 1} (Option.{u_6} Cell) (lookup d (cellLine d cell) (cellIndex d cell))
                            (@Option.some.{u_6} Cell cell)) →
                      (lookup_sound :
                          ∀ (d : D) (line : Line) (j : Int) (cell : Cell),
                            @Eq.{u_6 + 1} (Option.{u_6} Cell) (lookup d line j) (@Option.some.{u_6} Cell cell) →
                              And (@Eq.{u_8 + 1} Line (cellLine d cell) line) (@Eq.{1} Int (cellIndex d cell) j)) →
                        (ghost : D → Line → Int → Fin m → Real) →
                          @NumStability.FiniteCoordinate.LineCoordinates.{u_5, u_6, u_7, u_8} m D Cell Face Line
```

### D081: `NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineVariation`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `7e854796676506f0a5fd325508e6303268855f3714bcaa3bb83dcd94a595d4a4`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Line : Type u_4} →
        {m : Nat} →
          [Fintype Cell] →
            NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line →
              D → Line → (D → Line → Int → Fin m → Real) → (Cell → Fin m → Real) → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Line : Type u_4} →
        {m : Nat} →
          [Fintype.{u_2} Cell] →
            (coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_4} m D Cell Face Line) →
              (d : D) → (line : Line) → (ghost : D → Line → Int → Fin m → Real) → (current : Cell → Fin m → Real) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Line} {m} [Fintype Cell] coord d line ghost current =>
  have actual := coord.withGhost ghost;
  Finset.univ.sum fun cell =>
    ite (Eq (actual.cellLine d cell) line)
      (instHAdd.hAdd
        (Pi.normedAddCommGroup.norm
          (instHSub.hSub (current cell) (actual.extract d line current (instHSub.hSub (actual.cellIndex d cell) 1))))
        (ite (Eq (actual.lookup d line (instHAdd.hAdd (actual.cellIndex d cell) 1)) Option.none)
          (Pi.normedAddCommGroup.norm
            (instHSub.hSub (actual.extract d line current (instHAdd.hAdd (actual.cellIndex d cell) 1)) (current cell)))
          0))
      0
```

### D082: `NumStability.FiniteCoordinate.PhysicalData.faceMeasure`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `7f0dd068d0d47bb896cf1df482df291793cf4c62c0e2ed633e437c696ad153d4`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                    D → Face → MeasureTheory.Measure FacePoint
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (self :
                      @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
                        inst inst_1 inst_2 m) →
                    D → Face → @MeasureTheory.Measure.{u_5} FacePoint inst_2
```

Definition body (one-level semantic boundary):

```lean
fun D Cell Face Point FacePoint [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] m self =>
  self.7
```

### D083: `NumStability.FiniteCoordinate.PhysicalData.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `d206a659634d6c81a56b36c9fef3bab8417e39cd53fb5e7202739a80c03c6765`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace Point] →
            [inst_1 : TopologicalSpace Point] →
              [inst_2 : MeasurableSpace FacePoint] →
                {m : Nat} →
                  (cells : NumStability.FiniteVolumeCellPartition Cell Point) →
                    (measure : MeasureTheory.Measure Point) →
                      (∀ (cell : Cell), Ne (MeasureTheory.Measure.instFunLike.coe measure (cells.cellRegion cell)) 0) →
                        (∀ (cell : Cell),
                            Ne (MeasureTheory.Measure.instFunLike.coe measure (cells.cellRegion cell))
                              instTopENNReal.top) →
                          (leftFace rightFace : D → Cell → Face) →
                            (faceMeasure : D → Face → MeasureTheory.Measure FacePoint) →
                              (facePoint : D → Face → FacePoint → Point) →
                                (∀ (d : D) (cell : Cell),
                                    Filter.Eventually
                                      (fun point =>
                                        Set.instMembership.mem (closure (cells.cellRegion cell))
                                          (facePoint d (leftFace d cell) point))
                                      (MeasureTheory.ae (faceMeasure d (leftFace d cell)))) →
                                  (∀ (d : D) (cell : Cell),
                                      Filter.Eventually
                                        (fun point =>
                                          Set.instMembership.mem (closure (cells.cellRegion cell))
                                            (facePoint d (rightFace d cell) point))
                                        (MeasureTheory.ae (faceMeasure d (rightFace d cell)))) →
                                    (admissibleStates : D → Set (Fin m → Real)) →
                                      (normalFlux : D → Face → FacePoint → (Fin m → Real) → Fin m → Real) →
                                        (∀ (d : D) (face : Face) (point : FacePoint),
                                            NumStability.IsHyperbolicFluxOn (normalFlux d face point)
                                              (admissibleStates d)) →
                                          NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          [inst : MeasurableSpace.{u_4} Point] →
            [inst_1 : TopologicalSpace.{u_4} Point] →
              [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                {m : Nat} →
                  (cells : @NumStability.FiniteVolumeCellPartition.{u_2, u_4} Cell Point inst) →
                    (measure : @MeasureTheory.Measure.{u_4} Point inst) →
                      (positive :
                          ∀ (cell : Cell),
                            @Ne.{1} ENNReal
                              (@DFunLike.coe.{u_4 + 1, u_4 + 1, 1} (@MeasureTheory.Measure.{u_4} Point inst)
                                (Set.{u_4} Point) (fun (x : Set.{u_4} Point) => ENNReal)
                                (@MeasureTheory.Measure.instFunLike.{u_4} Point inst) measure
                                (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_4} Cell Point inst cells
                                  cell))
                              (@OfNat.ofNat.{0} ENNReal (nat_lit 0) (@Zero.toOfNat0.{0} ENNReal instZeroENNReal))) →
                        (finite :
                            ∀ (cell : Cell),
                              @Ne.{1} ENNReal
                                (@DFunLike.coe.{u_4 + 1, u_4 + 1, 1} (@MeasureTheory.Measure.{u_4} Point inst)
                                  (Set.{u_4} Point) (fun (x : Set.{u_4} Point) => ENNReal)
                                  (@MeasureTheory.Measure.instFunLike.{u_4} Point inst) measure
                                  (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_4} Cell Point inst cells
                                    cell))
                                (@Top.top.{0} ENNReal instTopENNReal)) →
                          (leftFace rightFace : D → Cell → Face) →
                            (faceMeasure : D → Face → @MeasureTheory.Measure.{u_5} FacePoint inst_2) →
                              (facePoint : D → Face → FacePoint → Point) →
                                (left_incidence :
                                    ∀ (d : D) (cell : Cell),
                                      @Filter.Eventually.{u_5} FacePoint
                                        (fun (point : FacePoint) =>
                                          @Membership.mem.{u_4, u_4} Point (Set.{u_4} Point)
                                            (@Set.instMembership.{u_4} Point)
                                            (@closure.{u_4} Point inst_1
                                              (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_4} Cell Point
                                                inst cells cell))
                                            (facePoint d (leftFace d cell) point))
                                        (@MeasureTheory.ae.{u_5, u_5} FacePoint
                                          (@MeasureTheory.Measure.{u_5} FacePoint inst_2)
                                          (@MeasureTheory.Measure.instFunLike.{u_5} FacePoint inst_2)
                                          (@MeasureTheory.Measure.instOuterMeasureClass.{u_5} FacePoint inst_2)
                                          (faceMeasure d (leftFace d cell)))) →
                                  (right_incidence :
                                      ∀ (d : D) (cell : Cell),
                                        @Filter.Eventually.{u_5} FacePoint
                                          (fun (point : FacePoint) =>
                                            @Membership.mem.{u_4, u_4} Point (Set.{u_4} Point)
                                              (@Set.instMembership.{u_4} Point)
                                              (@closure.{u_4} Point inst_1
                                                (@NumStability.FiniteVolumeCellPartition.cellRegion.{u_2, u_4} Cell
                                                  Point inst cells cell))
                                              (facePoint d (rightFace d cell) point))
                                          (@MeasureTheory.ae.{u_5, u_5} FacePoint
                                            (@MeasureTheory.Measure.{u_5} FacePoint inst_2)
                                            (@MeasureTheory.Measure.instFunLike.{u_5} FacePoint inst_2)
                                            (@MeasureTheory.Measure.instOuterMeasureClass.{u_5} FacePoint inst_2)
                                            (faceMeasure d (rightFace d cell)))) →
                                    (admissibleStates : D → Set.{0} (Fin m → Real)) →
                                      (normalFlux : D → Face → FacePoint → (Fin m → Real) → Fin m → Real) →
                                        (hyperbolic :
                                            ∀ (d : D) (face : Face) (point : FacePoint),
                                              @NumStability.IsHyperbolicFluxOn m (normalFlux d face point)
                                                (admissibleStates d)) →
                                          @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell
                                            Face Point FacePoint inst inst_1 inst_2 m
```

### D084: `NumStability.FiniteCoordinate.PhysicalLine.capacity`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalLineCapacity`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `adbb10d3b8f403fd9e28db8dfeca1754fa2967fc0a89b7f557cdfd744c233084`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                      NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → D → Line → Int → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    (data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m) →
                      (coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line) →
                        (d : D) → (line : Line) → (j : Int) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Point} {FacePoint} {Line} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] {m} data coord d line j =>
  NumStability.FiniteCoordinate.PhysicalLine.capacity.match_1 (fun x => Real) (coord.lookup d line j)
    (fun cell => data.cellVolume cell) fun _ => 1
```

### D085: `NumStability.FiniteCoordinate.PhysicalLine.faceRule`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalLineCapacity`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `e02c1aba9993a737c85dfc78da2944f8dac6b18b2ef944645538aaa90aec52b0`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Line : Type u_6} →
        {m : Nat} →
          NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line →
            (D → Line → Real → (Int → Fin m → Real) → Int → Fin m → Real) →
              D → Real → (Cell → Fin m → Real) → Face → Fin m → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Line : Type u_6} →
        {m : Nat} →
          (coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line) →
            (numericalFlux : D → Line → Real → (Int → Fin m → Real) → Int → Fin m → Real) →
              (d : D) → (dt : Real) → (current : Cell → Fin m → Real) → (face : Face) → Fin m → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} {Cell} {Face} {Line} {m} coord numericalFlux d dt current face =>
  numericalFlux d (coord.faceLine d face) dt (coord.extract d (coord.faceLine d face) current) (coord.faceIndex d face)
```

### D086: `NumStability.FiniteVolumeCellPartition`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `643d6beb37c358dd676e40a0ed44bb8a1161a339bf1a86fade7e9a749db8accc`

Type:

```lean
Type u_1 → (Point : Type u_2) → [MeasurableSpace Point] → Type (max u_1 u_2)
```

Fully explicit type:

```lean
(Cell : Type u_1) → (Point : Type u_2) → [MeasurableSpace.{u_2} Point] → Type (max u_1 u_2)
```

### D087: `NumStability.FiniteVolumeCellPartition.domain`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `cb0a0118a712ffbf02f6fbd9b166402e15f1bf39f75b88baf56f9f032c269ce2`

Type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} → [inst : MeasurableSpace Point] → NumStability.FiniteVolumeCellPartition Cell Point → Set Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace.{u_2} Point] →
      (self : @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst) → Set.{u_2} Point
```

Definition body (one-level semantic boundary):

```lean
fun Cell Point [MeasurableSpace Point] self => self.1
```

### D088: `NumStability.FiniteVolumeCellPartition.mesh._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCellMesh`
- Declaration kind: `theorem`
- Distance from target type: `4`
- Semantic SHA-256: `8977d313a17899c16c4ba925dcaf308c3810de409b64798d47404da2983c8f60`

Type:

```lean
∀ {Cell : Type u_1} {Point : Type u_2} [inst : Fintype Cell] [inst_1 : MeasurableSpace Point]
  (cells : NumStability.FiniteVolumeCellPartition Cell Point), Finset.univ.Nonempty
```

Fully explicit type:

```lean
∀ {Cell : Type u_1} {Point : Type u_2} [inst : Fintype.{u_1} Cell] [inst_1 : MeasurableSpace.{u_2} Point]
  (cells : @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst_1),
  @Finset.Nonempty.{u_1} Cell (@Finset.univ.{u_1} Cell inst)
```

### D089: `NumStability.OneDimensionalFiniteVolumeGrid.cellRight`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `e793c9aec7a283c6d560c9430d496d51051f9329f075b5c3daabfb5ebdc1e5fb`

Type:

```lean
NumStability.OneDimensionalFiniteVolumeGrid → Int → Real
```

Fully explicit type:

```lean
(self : NumStability.OneDimensionalFiniteVolumeGrid) → Int → Real
```

Definition body (one-level semantic boundary):

```lean
fun self => self.2
```

### D090: `NumStability.OneDimensionalFiniteVolumeGrid.cellVolume`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `1b11f8006577d74cfa9d8b4175b4078ee6606a698c5053cb84064b8c194a49d3`

Type:

```lean
NumStability.OneDimensionalFiniteVolumeGrid → Int → Real
```

Fully explicit type:

```lean
(grid : NumStability.OneDimensionalFiniteVolumeGrid) → (i : Int) → Real
```

Definition body (one-level semantic boundary):

```lean
fun grid i => instHSub.hSub (grid.cellRight i) (grid.cellLeft i)
```

### D091: `NumStability.OneDimensionalFiniteVolumeGrid.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `a5756070c766460340964fdc56e62557e58afc0dc8fd8cce2029d5d3262db199`

Type:

```lean
(cellLeft cellRight : Int → Real) →
  (∀ (i : Int), Real.instLT.lt (cellLeft i) (cellRight i)) →
    (∀ (i : Int), Eq (cellRight (instHSub.hSub i 1)) (cellLeft i)) → NumStability.OneDimensionalFiniteVolumeGrid
```

Fully explicit type:

```lean
(cellLeft cellRight : Int → Real) →
  (cell_nonempty : ∀ (i : Int), @LT.lt.{0} Real Real.instLT (cellLeft i) (cellRight i)) →
    (adjacent :
        ∀ (i : Int),
          @Eq.{1} Real
            (cellRight
              (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
            (cellLeft i)) →
      NumStability.OneDimensionalFiniteVolumeGrid
```

### D092: `NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `9f472766e3e9f089530558f1b65f05c48678df0330f1042fd3b87e183303561c`

Type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          {family : NumStability.PhysicalRefinementQuality.Family D FacePoint m} →
            {d : D} →
              {q : (D → Real) → Real → Fin m → Real} →
                {p : Real} →
                  (constant : Real) →
                    Real.instLE.le 0 constant →
                      (threshold : Nat) →
                        (∀ (n : Nat),
                            instLENat.le threshold n →
                              Exists fun dt =>
                                And (Real.instLT.lt 0 dt)
                                  (And (Real.instLE.le dt family.horizon)
                                    (((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
                                      (family.projected n q 0)))) →
                          (∀ (n : Nat),
                              instLENat.le threshold n →
                                ∀ (dt : Real),
                                  Real.instLT.lt 0 dt →
                                    Real.instLE.le dt family.horizon →
                                      ((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
                                          (family.projected n q 0) →
                                        ∀ (cell : family.Cell n),
                                          Real.instLE.le
                                            (Pi.normedRing.norm
                                              (instHSub.hSub
                                                (NumStability.FiniteCoordinate.advance (family.data n)
                                                  ((family.method n).withGhost (family.referenceGhost n q)).rule d dt
                                                  (family.projected n q 0) cell)
                                                (family.projected n q dt cell)))
                                            (instHMul.hMul (instHMul.hMul constant dt)
                                              (instHPow.hPow (family.mesh n) p))) →
                            family.AccuracyCertificate d q p
```

Fully explicit type:

```lean
{D : Type u_1} →
  {FacePoint : Type u_2} →
    [inst : Fintype.{u_1} D] →
      [inst_1 : MeasurableSpace.{u_2} FacePoint] →
        {m : Nat} →
          {family : @NumStability.PhysicalRefinementQuality.Family.{u_1, u_2} D FacePoint inst inst_1 m} →
            {d : D} →
              {q : (D → Real) → Real → Fin m → Real} →
                {p : Real} →
                  (constant : Real) →
                    (constant_nonneg :
                        @LE.le.{0} Real Real.instLE
                          (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) constant) →
                      (threshold : Nat) →
                        (projection_available :
                            ∀ (n : Nat),
                              @LE.le.{0} Nat instLENat threshold n →
                                @Exists.{1} Real fun (dt : Real) =>
                                  And
                                    (@LT.lt.{0} Real Real.instLT
                                      (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) dt)
                                    (And
                                      (@LE.le.{0} Real Real.instLE dt
                                        (@NumStability.PhysicalRefinementQuality.Family.horizon.{u_1, u_2} D FacePoint
                                          inst inst_1 m family))
                                      (@NumStability.CapacityCoordinate.Method.Admitted.{u_1, 0, 0, u_1, u_2, 0} D
                                        (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint inst
                                          inst_1 m family n)
                                        (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint inst
                                          inst_1 m family n)
                                        (D → Real) FacePoint
                                        (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint inst
                                          inst_1 m family n)
                                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                          Real.measurableSpace)
                                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                          @UniformSpace.toTopologicalSpace.{0} Real
                                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                        inst_1 m
                                        (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint inst
                                          inst_1 m family n)
                                        (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, 0, 0, 0} D
                                          (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint
                                            inst inst_1 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint
                                            inst inst_1 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint
                                            inst inst_1 m family n)
                                          m
                                          (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D
                                            FacePoint inst inst_1 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.referenceGhost.{u_1, u_2} D
                                            FacePoint inst inst_1 m family n q))
                                        (@NumStability.CapacityCoordinate.Method.withGhost.{u_1, 0, 0, u_1, u_2, 0} D
                                          (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint
                                            inst inst_1 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint
                                            inst inst_1 m family n)
                                          (D → Real) FacePoint
                                          (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint
                                            inst inst_1 m family n)
                                          (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                            Real.measurableSpace)
                                          (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                            @UniformSpace.toTopologicalSpace.{0} Real
                                              (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                          inst_1 m
                                          (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint
                                            inst inst_1 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D
                                            FacePoint inst inst_1 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.method.{u_1, u_2} D FacePoint
                                            inst inst_1 m family n)
                                          (@NumStability.PhysicalRefinementQuality.Family.referenceGhost.{u_1, u_2} D
                                            FacePoint inst inst_1 m family n q))
                                        d dt
                                        (@NumStability.PhysicalRefinementQuality.Family.projected.{u_1, u_2} D FacePoint
                                          inst inst_1 m family n q
                                          (@OfNat.ofNat.{0} Real (nat_lit 0)
                                            (@Zero.toOfNat0.{0} Real Real.instZero)))))) →
                          (bound :
                              ∀ (n : Nat),
                                @LE.le.{0} Nat instLENat threshold n →
                                  ∀ (dt : Real),
                                    @LT.lt.{0} Real Real.instLT
                                        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) dt →
                                      @LE.le.{0} Real Real.instLE dt
                                          (@NumStability.PhysicalRefinementQuality.Family.horizon.{u_1, u_2} D FacePoint
                                            inst inst_1 m family) →
                                        @NumStability.CapacityCoordinate.Method.Admitted.{u_1, 0, 0, u_1, u_2, 0} D
                                            (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint
                                              inst inst_1 m family n)
                                            (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D FacePoint
                                              inst inst_1 m family n)
                                            (D → Real) FacePoint
                                            (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D FacePoint
                                              inst inst_1 m family n)
                                            (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                              Real.measurableSpace)
                                            (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                              @UniformSpace.toTopologicalSpace.{0} Real
                                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                            inst_1 m
                                            (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D FacePoint
                                              inst inst_1 m family n)
                                            (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, 0, 0, 0} D
                                              (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D
                                                FacePoint inst inst_1 m family n)
                                              (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D
                                                FacePoint inst inst_1 m family n)
                                              (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D
                                                FacePoint inst inst_1 m family n)
                                              m
                                              (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D
                                                FacePoint inst inst_1 m family n)
                                              (@NumStability.PhysicalRefinementQuality.Family.referenceGhost.{u_1, u_2}
                                                D FacePoint inst inst_1 m family n q))
                                            (@NumStability.CapacityCoordinate.Method.withGhost.{u_1, 0, 0, u_1, u_2, 0}
                                              D
                                              (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D
                                                FacePoint inst inst_1 m family n)
                                              (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D
                                                FacePoint inst inst_1 m family n)
                                              (D → Real) FacePoint
                                              (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D
                                                FacePoint inst inst_1 m family n)
                                              (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                Real.measurableSpace)
                                              (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real) fun (i : D) =>
                                                @UniformSpace.toTopologicalSpace.{0} Real
                                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                              inst_1 m
                                              (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D
                                                FacePoint inst inst_1 m family n)
                                              (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1, u_2} D
                                                FacePoint inst inst_1 m family n)
                                              (@NumStability.PhysicalRefinementQuality.Family.method.{u_1, u_2} D
                                                FacePoint inst inst_1 m family n)
                                              (@NumStability.PhysicalRefinementQuality.Family.referenceGhost.{u_1, u_2}
                                                D FacePoint inst inst_1 m family n q))
                                            d dt
                                            (@NumStability.PhysicalRefinementQuality.Family.projected.{u_1, u_2} D
                                              FacePoint inst inst_1 m family n q
                                              (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                (@Zero.toOfNat0.{0} Real Real.instZero))) →
                                          ∀
                                            (cell :
                                              @NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D FacePoint
                                                inst inst_1 m family n),
                                            @LE.le.{0} Real Real.instLE
                                              (@Norm.norm.{0} (Fin m → Real)
                                                (@NormedRing.toNorm.{0} (Fin m → Real)
                                                  (@Pi.normedRing.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                    (Fin.fintype m) fun (i : Fin m) =>
                                                    @NormedCommRing.toNormedRing.{0} Real Real.normedCommRing))
                                                (@HSub.hSub.{0, 0, 0} (Fin m → Real) (Fin m → Real) (Fin m → Real)
                                                  (@instHSub.{0} (Fin m → Real)
                                                    (@Pi.instSub.{0, 0} (Fin m) (fun (a : Fin m) => Real)
                                                      fun (i : Fin m) => Real.instSub))
                                                  (@NumStability.FiniteCoordinate.advance.{u_1, 0, 0, u_1, u_2} D
                                                    (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D
                                                      FacePoint inst inst_1 m family n)
                                                    (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D
                                                      FacePoint inst inst_1 m family n)
                                                    (D → Real) FacePoint
                                                    (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real) fun (a : D) =>
                                                      Real.measurableSpace)
                                                    (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real)
                                                      fun (i : D) =>
                                                      @UniformSpace.toTopologicalSpace.{0} Real
                                                        (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                          Real.pseudoMetricSpace))
                                                    inst_1 m
                                                    (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D
                                                      FacePoint inst inst_1 m family n)
                                                    (@NumStability.CapacityCoordinate.Method.rule.{u_1, 0, 0, u_1, u_2,
                                                          0}
                                                      D
                                                      (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2} D
                                                        FacePoint inst inst_1 m family n)
                                                      (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2} D
                                                        FacePoint inst inst_1 m family n)
                                                      (D → Real) FacePoint
                                                      (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2} D
                                                        FacePoint inst inst_1 m family n)
                                                      (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real)
                                                        fun (a : D) => Real.measurableSpace)
                                                      (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real)
                                                        fun (i : D) =>
                                                        @UniformSpace.toTopologicalSpace.{0} Real
                                                          (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                            Real.pseudoMetricSpace))
                                                      inst_1 m
                                                      (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2} D
                                                        FacePoint inst inst_1 m family n)
                                                      (@NumStability.FiniteCoordinate.LineCoordinates.withGhost.{u_1, 0,
                                                            0, 0}
                                                        D
                                                        (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2}
                                                          D FacePoint inst inst_1 m family n)
                                                        (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2}
                                                          D FacePoint inst inst_1 m family n)
                                                        (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2}
                                                          D FacePoint inst inst_1 m family n)
                                                        m
                                                        (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1,
                                                              u_2}
                                                          D FacePoint inst inst_1 m family n)
                                                        (@NumStability.PhysicalRefinementQuality.Family.referenceGhost.{u_1,
                                                              u_2}
                                                          D FacePoint inst inst_1 m family n q))
                                                      (@NumStability.CapacityCoordinate.Method.withGhost.{u_1, 0, 0,
                                                            u_1, u_2, 0}
                                                        D
                                                        (@NumStability.PhysicalRefinementQuality.Family.Cell.{u_1, u_2}
                                                          D FacePoint inst inst_1 m family n)
                                                        (@NumStability.PhysicalRefinementQuality.Family.Face.{u_1, u_2}
                                                          D FacePoint inst inst_1 m family n)
                                                        (D → Real) FacePoint
                                                        (@NumStability.PhysicalRefinementQuality.Family.Line.{u_1, u_2}
                                                          D FacePoint inst inst_1 m family n)
                                                        (@MeasurableSpace.pi.{u_1, 0} D (fun (a : D) => Real)
                                                          fun (a : D) => Real.measurableSpace)
                                                        (@Pi.topologicalSpace.{0, u_1} D (fun (a : D) => Real)
                                                          fun (i : D) =>
                                                          @UniformSpace.toTopologicalSpace.{0} Real
                                                            (@PseudoMetricSpace.toUniformSpace.{0} Real
                                                              Real.pseudoMetricSpace))
                                                        inst_1 m
                                                        (@NumStability.PhysicalRefinementQuality.Family.data.{u_1, u_2}
                                                          D FacePoint inst inst_1 m family n)
                                                        (@NumStability.PhysicalRefinementQuality.Family.coordinates.{u_1,
                                                              u_2}
                                                          D FacePoint inst inst_1 m family n)
                                                        (@NumStability.PhysicalRefinementQuality.Family.method.{u_1,
                                                              u_2}
                                                          D FacePoint inst inst_1 m family n)
                                                        (@NumStability.PhysicalRefinementQuality.Family.referenceGhost.{u_1,
                                                              u_2}
                                                          D FacePoint inst inst_1 m family n q)))
                                                    d dt
                                                    (@NumStability.PhysicalRefinementQuality.Family.projected.{u_1, u_2}
                                                      D FacePoint inst inst_1 m family n q
                                                      (@OfNat.ofNat.{0} Real (nat_lit 0)
                                                        (@Zero.toOfNat0.{0} Real Real.instZero)))
                                                    cell)
                                                  (@NumStability.PhysicalRefinementQuality.Family.projected.{u_1, u_2} D
                                                    FacePoint inst inst_1 m family n q dt cell)))
                                              (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                                                (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul)
                                                  constant dt)
                                                (@HPow.hPow.{0, 0, 0} Real Real Real
                                                  (@instHPow.{0, 0} Real Real Real.instPow)
                                                  (@NumStability.PhysicalRefinementQuality.Family.mesh.{u_1, u_2} D
                                                    FacePoint inst inst_1 m family n)
                                                  p))) →
                            @NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate.{u_1, u_2} D FacePoint
                              inst inst_1 m family d q p
```

### D093: `NumStability.PhysicalRefinementQuality.Family.boundaryRegion`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `3d55c1f52c3ca3688c70e89aa38f2dcdd59e580c6208b20e262a5922bc3db6fc`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} →
          (self : NumStability.PhysicalRefinementQuality.Family D FacePoint m) →
            (n : Nat) → D → self.Line n → Int → Set (D → Real)
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) →
            (n : Nat) →
              D →
                @NumStability.PhysicalRefinementQuality.Family.Line.{u_3, u_4} D FacePoint inst inst_1 m self n →
                  Int → Set.{u_3} (D → Real)
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.29
```

### D094: `NumStability.PhysicalRefinementQuality.Family.measure`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `80ff14885d4e12ddc0b35d17593e5867d3db1f02995e1db2eea0ae78aab117db`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} → NumStability.PhysicalRefinementQuality.Family D FacePoint m → MeasureTheory.Measure (D → Real)
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) →
            @MeasureTheory.Measure.{u_3} (D → Real)
              (@MeasurableSpace.pi.{u_3, 0} D (fun (a : D) => Real) fun (a : D) => Real.measurableSpace)
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.8
```

### D095: `NumStability.PhysicalRefinementQuality.Family.region`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `4c472fe1fc01bd183d80e2078794b19fd06ae30c3ac8f6506a3b5198db21ca54`

Type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype D] →
      [inst_1 : MeasurableSpace FacePoint] →
        {m : Nat} → NumStability.PhysicalRefinementQuality.Family D FacePoint m → Set (D → Real)
```

Fully explicit type:

```lean
{D : Type u_3} →
  {FacePoint : Type u_4} →
    [inst : Fintype.{u_3} D] →
      [inst_1 : MeasurableSpace.{u_4} FacePoint] →
        {m : Nat} →
          (self : @NumStability.PhysicalRefinementQuality.Family.{u_3, u_4} D FacePoint inst inst_1 m) →
            Set.{u_3} (D → Real)
```

Definition body (one-level semantic boundary):

```lean
fun D FacePoint [Fintype D] [MeasurableSpace FacePoint] m self => self.16
```

### D096: `NumStability.SequentialError.execution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.Normed.Group.SequentialError`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `dffe0d7bfc398c78596e06554cd6b0cd8214af1ab1c1c9241325b9339d392364`

Type:

```lean
{Cell : Type u_1} → {E : Type u_2} → (Nat → (Cell → E) → Cell → E) → (Cell → E) → Nat → Cell → E
```

Fully explicit type:

```lean
{Cell : Type u_1} → {E : Type u_2} → (step : Nat → (Cell → E) → Cell → E) → (initial : Cell → E) → Nat → Cell → E
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} {E} step initial x =>
  Nat.brecOn (motive := fun x => Cell → E) x fun x f =>
    NumStability.SequentialError.execution.match_1 (fun x => Nat.below (motive := fun x => Cell → E) x → Cell → E) x
      (fun _ x => initial) (fun n x => step n x.1) f
```

### D097: `NumStability.SequentialError.execution.match_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.Normed.Group.SequentialError`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `1002990472a6f1d27abf945ffc4f52229f9865c87ec1dbdd4fab6f4862ae127c`

Type:

```lean
(motive : Nat → Sort u_1) → (x : Nat) → (Unit → motive 0) → ((n : Nat) → motive n.succ) → motive x
```

Fully explicit type:

```lean
(motive : Nat → Sort u_1) →
  (x : Nat) →
    (h_1 : (a : Unit) → motive (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))) →
      (h_2 : (n : Nat) → motive (Nat.succ n)) → motive x
```

Definition body (one-level semantic boundary):

```lean
fun motive x h_1 h_2 => Nat.casesOn x (h_1 Unit.unit) fun n => h_2 n
```

### D098: `NumStability.finiteVolumeCellAverageUpdate`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `2c211fbf68ab80aa19f6cbb49d99879941ac27a6722aa66c55bbad97b5f33d56`

Type:

```lean
{E : Type u_1} → [inst : AddCommGroup E] → [Module Real E] → Real → Real → E → E → E
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : AddCommGroup.{u_1} E] →
    [@Module.{0, u_1} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_1} E inst)] →
      (timeStep cellVolume : Real) → (oldAverage netOutwardFlux : E) → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [AddCommGroup E] [Module Real E] timeStep cellVolume oldAverage netOutwardFlux =>
  instHSub.hSub oldAverage (instHSMul.hSMul (instHDiv.hDiv timeStep cellVolume) netOutwardFlux)
```

### D099: `NumStability.oneDimensionalCellAverage`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `0c59840079f273e3900b018ab6f6dbe73c00e7370875b883e4413e18c63ddc92`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → E
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} E] →
    [@NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)] →
      (field : Real → E) → (left right : Real) → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] field left right =>
  instHSMul.hSMul (Real.instInv.inv (instHSub.hSub right left))
    (intervalIntegral (fun x => field x) left right Real.measureSpace.volume)
```

### D100: `ContDiffWithinAt`

- Role: `local`
- Owner module: `Mathlib.Analysis.Calculus.ContDiff.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `6fce6017ee2c63e37457accde2dd639524ea2baebec7f66a2e378f52bc09c114`

Type:

```lean
(𝕜 : Type u) →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type uE} →
      [inst_1 : NormedAddCommGroup E] →
        [NormedSpace 𝕜 E] →
          {F : Type uF} →
            [inst_3 : NormedAddCommGroup F] → [NormedSpace 𝕜 F] → WithTop ENat → (E → F) → Set E → E → Prop
```

Fully explicit type:

```lean
(𝕜 : Type u) →
  [inst : NontriviallyNormedField.{u} 𝕜] →
    {E : Type uE} →
      [inst_1 : NormedAddCommGroup.{uE} E] →
        [@NormedSpace.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1)] →
          {F : Type uF} →
            [inst_3 : NormedAddCommGroup.{uF} F] →
              [@NormedSpace.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)] →
                (n : WithTop.{0} ENat) → (f : E → F) → (s : Set.{uE} E) → (x : E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 [NontriviallyNormedField 𝕜] {E} [NormedAddCommGroup E] [NormedSpace 𝕜 E] {F} [NormedAddCommGroup F]
    [NormedSpace 𝕜 F] n f s x =>
  ContDiffWithinAt.match_1 (fun n => Prop) n
    (fun _ =>
      Exists fun u =>
        And (Filter.instMembership.mem (nhdsWithin x (Set.instInsert.insert x s)) u)
          (Exists fun p =>
            And (HasFTaylorSeriesUpToOn WithTop.top.top f p u) (∀ (i : Nat), AnalyticOn 𝕜 (fun x => p x i) u)))
    fun n =>
    ∀ (m : Nat),
      CompleteLattice.instOmegaCompletePartialOrder.le m.cast n →
        Exists fun u =>
          And (Filter.instMembership.mem (nhdsWithin x (Set.instInsert.insert x s)) u)
            (Exists fun p => HasFTaylorSeriesUpToOn m.cast f p u)
```

### D101: `NumStability.CartesianGrid.facePoint`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `4c747f89f36977c53c80c7f670f81c119ebec661ebcbd97dfc64a43027269df9`

Type:

```lean
{D : Type u_1} →
  [DecidableEq D] →
    (D → NumStability.OneDimensionalFiniteVolumeGrid) →
      (d : D) → (D → Int) → ((Subtype fun e => Ne e d) → Real) → D → Real
```

Fully explicit type:

```lean
{D : Type u_1} →
  [DecidableEq.{u_1 + 1} D] →
    (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) →
      (d : D) → (cell : D → Int) → (point : (@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real) → D → Real
```

Definition body (one-level semantic boundary):

```lean
fun {D} [DecidableEq D] axes d cell point e => if h : Eq e d then (axes d).cellLeft (cell d) else point ⟨e, h⟩
```

### D102: `NumStability.CartesianGrid.tangentialFaceBox`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `34633c4e8e7cd18c85f69e619e5085227df05ab49501e6441e3deffb29265b81`

Type:

```lean
{D : Type u_1} →
  (D → NumStability.OneDimensionalFiniteVolumeGrid) → (d : D) → (D → Int) → Set ((Subtype fun e => Ne e d) → Real)
```

Fully explicit type:

```lean
{D : Type u_1} →
  (axes : D → NumStability.OneDimensionalFiniteVolumeGrid) →
    (d : D) → (cell : D → Int) → Set.{u_1} ((@Subtype.{u_1 + 1} D fun (e : D) => @Ne.{u_1 + 1} D e d) → Real)
```

Definition body (one-level semantic boundary):

```lean
fun {D} axes d cell =>
  Set.univ.pi fun e => Set.Ico ((axes e.val).cellLeft (cell e.val)) ((axes e.val).cellRight (cell e.val))
```

### D103: `NumStability.FiniteCoordinate.PhysicalLine.Incidence`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalLineCapacity`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `b5e87bfc78f6bcaea386f31ea039c453dbfc944af6122b07077e23f4b1d50359`

Type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace Point] →
              [inst_1 : TopologicalSpace Point] →
                [inst_2 : MeasurableSpace FacePoint] →
                  {m : Nat} →
                    NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m →
                      NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line → Prop
```

Fully explicit type:

```lean
{D : Type u_1} →
  {Cell : Type u_2} →
    {Face : Type u_3} →
      {Point : Type u_4} →
        {FacePoint : Type u_5} →
          {Line : Type u_6} →
            [inst : MeasurableSpace.{u_4} Point] →
              [inst_1 : TopologicalSpace.{u_4} Point] →
                [inst_2 : MeasurableSpace.{u_5} FacePoint] →
                  {m : Nat} →
                    (data :
                        @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point
                          FacePoint inst inst_1 inst_2 m) →
                      (coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line) →
                        Prop
```

### D104: `NumStability.FiniteCoordinate.PhysicalLine.capacity.match_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalLineCapacity`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `678a2fc832cdc403a15810e93512f4f516b218f987092598f659cfb6ef071a21`

Type:

```lean
{Cell : Type u_1} →
  (motive : Option Cell → Sort u_2) →
    (x : Option Cell) → ((cell : Cell) → motive (Option.some cell)) → (Unit → motive Option.none) → motive x
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  (motive : Option.{u_1} Cell → Sort u_2) →
    (x : Option.{u_1} Cell) →
      (h_1 : (cell : Cell) → motive (@Option.some.{u_1} Cell cell)) →
        (h_2 : (a : Unit) → motive (@Option.none.{u_1} Cell)) → motive x
```

Definition body (one-level semantic boundary):

```lean
fun {Cell} motive x h_1 h_2 => Option.casesOn x (h_2 Unit.unit) fun val => h_1 val
```

### D105: `NumStability.FiniteVolumeCellPartition.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `constructor`
- Distance from target type: `5`
- Semantic SHA-256: `739bab2b22ae879c4f9ff0943c6641c3a50b089aa099d9b3ca55f7e3dbb2945b`

Type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace Point] →
      (domain : Set Point) →
        (cellRegion : Cell → Set Point) →
          Nonempty Cell →
            (∀ (cell : Cell), MeasurableSet (cellRegion cell)) →
              (∀ {cell₁ cell₂ : Cell}, Ne cell₁ cell₂ → Disjoint (cellRegion cell₁) (cellRegion cell₂)) →
                (∀ (point : Point),
                    Iff (Set.instMembership.mem domain point)
                      (Exists fun cell => Set.instMembership.mem (cellRegion cell) point)) →
                  NumStability.FiniteVolumeCellPartition Cell Point
```

Fully explicit type:

```lean
{Cell : Type u_1} →
  {Point : Type u_2} →
    [inst : MeasurableSpace.{u_2} Point] →
      (domain : Set.{u_2} Point) →
        (cellRegion : Cell → Set.{u_2} Point) →
          (cells_nonempty : Nonempty.{u_1 + 1} Cell) →
            (measurable_cell : ∀ (cell : Cell), @MeasurableSet.{u_2} Point inst (cellRegion cell)) →
              (disjoint_cells :
                  ∀ {cell₁ cell₂ : Cell},
                    @Ne.{u_1 + 1} Cell cell₁ cell₂ →
                      @Disjoint.{u_2} (Set.{u_2} Point)
                        (@OmegaCompletePartialOrder.toPartialOrder.{u_2} (Set.{u_2} Point)
                          (@CompleteLattice.instOmegaCompletePartialOrder.{u_2} (Set.{u_2} Point)
                            (@CompleteBooleanAlgebra.toCompleteLattice.{u_2} (Set.{u_2} Point)
                              (@CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra.{u_2} (Set.{u_2} Point)
                                (@Set.instCompleteAtomicBooleanAlgebra.{u_2} Point)))))
                        (@HeytingAlgebra.toOrderBot.{u_2} (Set.{u_2} Point)
                          (@Order.Frame.toHeytingAlgebra.{u_2} (Set.{u_2} Point)
                            (@CompleteDistribLattice.toFrame.{u_2} (Set.{u_2} Point)
                              (@CompleteBooleanAlgebra.toCompleteDistribLattice.{u_2} (Set.{u_2} Point)
                                (@CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra.{u_2} (Set.{u_2} Point)
                                  (@Set.instCompleteAtomicBooleanAlgebra.{u_2} Point))))))
                        (cellRegion cell₁) (cellRegion cell₂)) →
                (covers_domain :
                    ∀ (point : Point),
                      Iff
                        (@Membership.mem.{u_2, u_2} Point (Set.{u_2} Point) (@Set.instMembership.{u_2} Point) domain
                          point)
                        (@Exists.{u_1 + 1} Cell fun (cell : Cell) =>
                          @Membership.mem.{u_2, u_2} Point (Set.{u_2} Point) (@Set.instMembership.{u_2} Point)
                            (cellRegion cell) point)) →
                  @NumStability.FiniteVolumeCellPartition.{u_1, u_2} Cell Point inst
```

### D106: `NumStability.IsHyperbolicFluxOn`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `94bad8b852444c4d21cfba9a629ee1e790e006684d925ba21373a3f9b6d00a01`

Type:

```lean
{m : Nat} → ((Fin m → Real) → Fin m → Real) → Set (Fin m → Real) → Prop
```

Fully explicit type:

```lean
{m : Nat} → (flux : (Fin m → Real) → Fin m → Real) → (states : Set.{0} (Fin m → Real)) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} flux states =>
  ∀ (state : Fin m → Real), Set.instMembership.mem states state → NumStability.IsHyperbolicFluxAt flux state
```

### D107: `ContDiffWithinAt._proof_1`

- Role: `local`
- Owner module: `Mathlib.Analysis.Calculus.ContDiff.Defs`
- Declaration kind: `theorem`
- Distance from target type: `6`
- Semantic SHA-256: `c5d321d2d1cba930fc6ab2cbb39979e890ae10ab9a76880bd118147e203fdf8f`

Type:

```lean
∀ {E : Type u_1} [inst : NormedAddCommGroup E], ContinuousAdd E
```

Fully explicit type:

```lean
∀ {E : Type u_1} [inst : NormedAddCommGroup.{u_1} E],
  @ContinuousAdd.{u_1} E
    (@UniformSpace.toTopologicalSpace.{u_1} E
      (@PseudoMetricSpace.toUniformSpace.{u_1} E
        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_1} E
          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst))))
    (@AddSemigroup.toAdd.{u_1} E
      (@AddMonoid.toAddSemigroup.{u_1} E
        (@SubNegMonoid.toAddMonoid.{u_1} E
          (@AddGroup.toSubNegMonoid.{u_1} E
            (@NormedAddGroup.toAddGroup.{u_1} E (@NormedAddCommGroup.toNormedAddGroup.{u_1} E inst))))))
```

### D108: `ContDiffWithinAt._proof_2`

- Role: `local`
- Owner module: `Mathlib.Analysis.Calculus.ContDiff.Defs`
- Declaration kind: `theorem`
- Distance from target type: `6`
- Semantic SHA-256: `279288866f888a70969b0bda89d2504d0f2830afa2d61c0c016199148e3c2875`

Type:

```lean
∀ (𝕜 : Type u_1) [inst : NontriviallyNormedField 𝕜] {E : Type u_2} [inst_1 : NormedAddCommGroup E]
  [inst_2 : NormedSpace 𝕜 E], ContinuousConstSMul 𝕜 E
```

Fully explicit type:

```lean
∀ (𝕜 : Type u_1) [inst : NontriviallyNormedField.{u_1} 𝕜] {E : Type u_2} [inst_1 : NormedAddCommGroup.{u_2} E]
  [inst_2 :
    @NormedSpace.{u_1, u_2} 𝕜 E (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)
      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1)],
  @ContinuousConstSMul.{u_1, u_2} 𝕜 E
    (@UniformSpace.toTopologicalSpace.{u_2} E
      (@PseudoMetricSpace.toUniformSpace.{u_2} E
        (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} E
          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1))))
    (@SMulZeroClass.toSMul.{u_1, u_2} 𝕜 E
      (@AddZero.toZero.{u_2} E
        (@AddZeroClass.toAddZero.{u_2} E
          (@AddMonoid.toAddZeroClass.{u_2} E
            (@AddCommMonoid.toAddMonoid.{u_2} E
              (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_2} E
                (@UniformSpace.toTopologicalSpace.{u_2} E
                  (@PseudoMetricSpace.toUniformSpace.{u_2} E
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} E
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1))))
                (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_2} E
                  (@UniformSpace.toTopologicalSpace.{u_2} E
                    (@PseudoMetricSpace.toUniformSpace.{u_2} E
                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} E
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1))))
                  (@NormedAddCommGroup.toENormedAddCommMonoid.{u_2} E inst_1)))))))
      (@DistribSMul.toSMulZeroClass.{u_1, u_2} 𝕜 E
        (@AddMonoid.toAddZeroClass.{u_2} E
          (@AddCommMonoid.toAddMonoid.{u_2} E
            (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_2} E
              (@UniformSpace.toTopologicalSpace.{u_2} E
                (@PseudoMetricSpace.toUniformSpace.{u_2} E
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} E
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1))))
              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_2} E
                (@UniformSpace.toTopologicalSpace.{u_2} E
                  (@PseudoMetricSpace.toUniformSpace.{u_2} E
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} E
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1))))
                (@NormedAddCommGroup.toENormedAddCommMonoid.{u_2} E inst_1)))))
        (@DistribMulAction.toDistribSMul.{u_1, u_2} 𝕜 E
          (@MonoidWithZero.toMonoid.{u_1} 𝕜
            (@Semiring.toMonoidWithZero.{u_1} 𝕜
              (@DivisionSemiring.toSemiring.{u_1} 𝕜
                (@Semifield.toDivisionSemiring.{u_1} 𝕜
                  (@Field.toSemifield.{u_1} 𝕜
                    (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))))
          (@AddCommMonoid.toAddMonoid.{u_2} E
            (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_2} E
              (@UniformSpace.toTopologicalSpace.{u_2} E
                (@PseudoMetricSpace.toUniformSpace.{u_2} E
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} E
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1))))
              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_2} E
                (@UniformSpace.toTopologicalSpace.{u_2} E
                  (@PseudoMetricSpace.toUniformSpace.{u_2} E
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} E
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1))))
                (@NormedAddCommGroup.toENormedAddCommMonoid.{u_2} E inst_1))))
          (@Module.toDistribMulAction.{u_1, u_2} 𝕜 E
            (@DivisionSemiring.toSemiring.{u_1} 𝕜
              (@Semifield.toDivisionSemiring.{u_1} 𝕜
                (@Field.toSemifield.{u_1} 𝕜
                  (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
            (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_2} E
              (@UniformSpace.toTopologicalSpace.{u_2} E
                (@PseudoMetricSpace.toUniformSpace.{u_2} E
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} E
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1))))
              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_2} E
                (@UniformSpace.toTopologicalSpace.{u_2} E
                  (@PseudoMetricSpace.toUniformSpace.{u_2} E
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} E
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1))))
                (@NormedAddCommGroup.toENormedAddCommMonoid.{u_2} E inst_1)))
            (@NormedSpace.toModule.{u_1, u_2} 𝕜 E (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1) inst_2)))))
```

### D109: `ContDiffWithinAt._proof_3`

- Role: `local`
- Owner module: `Mathlib.Analysis.Calculus.ContDiff.Defs`
- Declaration kind: `theorem`
- Distance from target type: `6`
- Semantic SHA-256: `0bd0eb2fe80ae85218b0f5183ef55c06f2f2b64dc90289fb3d09117c4ce7b16f`

Type:

```lean
∀ (𝕜 : Type u_1) [inst : NontriviallyNormedField 𝕜] {F : Type u_2} [inst_1 : NormedAddCommGroup F]
  [inst_2 : NormedSpace 𝕜 F], SMulCommClass 𝕜 𝕜 F
```

Fully explicit type:

```lean
∀ (𝕜 : Type u_1) [inst : NontriviallyNormedField.{u_1} 𝕜] {F : Type u_2} [inst_1 : NormedAddCommGroup.{u_2} F]
  [inst_2 :
    @NormedSpace.{u_1, u_2} 𝕜 F (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)
      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1)],
  @SMulCommClass.{u_1, u_1, u_2} 𝕜 𝕜 F
    (@SemigroupAction.toSMul.{u_1, u_2} 𝕜 F
      (@Monoid.toSemigroup.{u_1} 𝕜
        (@CommMonoid.toMonoid.{u_1} 𝕜
          (@CommRing.toCommMonoid.{u_1} 𝕜
            (@Field.toCommRing.{u_1} 𝕜
              (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst))))))
      (@MulAction.toSemigroupAction.{u_1, u_2} 𝕜 F
        (@CommMonoid.toMonoid.{u_1} 𝕜
          (@CommRing.toCommMonoid.{u_1} 𝕜
            (@Field.toCommRing.{u_1} 𝕜
              (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
        (@DistribMulAction.toMulAction.{u_1, u_2} 𝕜 F
          (@CommMonoid.toMonoid.{u_1} 𝕜
            (@CommRing.toCommMonoid.{u_1} 𝕜
              (@Field.toCommRing.{u_1} 𝕜
                (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
          (@AddCommMonoid.toAddMonoid.{u_2} F
            (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_2} F
              (@UniformSpace.toTopologicalSpace.{u_2} F
                (@PseudoMetricSpace.toUniformSpace.{u_2} F
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} F
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1))))
              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_2} F
                (@UniformSpace.toTopologicalSpace.{u_2} F
                  (@PseudoMetricSpace.toUniformSpace.{u_2} F
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1))))
                (@NormedAddCommGroup.toENormedAddCommMonoid.{u_2} F inst_1))))
          (@Module.toDistribMulAction.{u_1, u_2} 𝕜 F
            (@DivisionSemiring.toSemiring.{u_1} 𝕜
              (@Semifield.toDivisionSemiring.{u_1} 𝕜
                (@Field.toSemifield.{u_1} 𝕜
                  (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
            (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_2} F
              (@UniformSpace.toTopologicalSpace.{u_2} F
                (@PseudoMetricSpace.toUniformSpace.{u_2} F
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} F
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1))))
              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_2} F
                (@UniformSpace.toTopologicalSpace.{u_2} F
                  (@PseudoMetricSpace.toUniformSpace.{u_2} F
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1))))
                (@NormedAddCommGroup.toENormedAddCommMonoid.{u_2} F inst_1)))
            (@NormedSpace.toModule.{u_1, u_2} 𝕜 F (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1) inst_2)))))
    (@SemigroupAction.toSMul.{u_1, u_2} 𝕜 F
      (@Monoid.toSemigroup.{u_1} 𝕜
        (@CommMonoid.toMonoid.{u_1} 𝕜
          (@CommRing.toCommMonoid.{u_1} 𝕜
            (@Field.toCommRing.{u_1} 𝕜
              (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst))))))
      (@MulAction.toSemigroupAction.{u_1, u_2} 𝕜 F
        (@CommMonoid.toMonoid.{u_1} 𝕜
          (@CommRing.toCommMonoid.{u_1} 𝕜
            (@Field.toCommRing.{u_1} 𝕜
              (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
        (@DistribMulAction.toMulAction.{u_1, u_2} 𝕜 F
          (@CommMonoid.toMonoid.{u_1} 𝕜
            (@CommRing.toCommMonoid.{u_1} 𝕜
              (@Field.toCommRing.{u_1} 𝕜
                (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
          (@AddCommMonoid.toAddMonoid.{u_2} F
            (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_2} F
              (@UniformSpace.toTopologicalSpace.{u_2} F
                (@PseudoMetricSpace.toUniformSpace.{u_2} F
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} F
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1))))
              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_2} F
                (@UniformSpace.toTopologicalSpace.{u_2} F
                  (@PseudoMetricSpace.toUniformSpace.{u_2} F
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1))))
                (@NormedAddCommGroup.toENormedAddCommMonoid.{u_2} F inst_1))))
          (@Module.toDistribMulAction.{u_1, u_2} 𝕜 F
            (@DivisionSemiring.toSemiring.{u_1} 𝕜
              (@Semifield.toDivisionSemiring.{u_1} 𝕜
                (@Field.toSemifield.{u_1} 𝕜
                  (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
            (@ESeminormedAddCommMonoid.toAddCommMonoid.{u_2} F
              (@UniformSpace.toTopologicalSpace.{u_2} F
                (@PseudoMetricSpace.toUniformSpace.{u_2} F
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} F
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1))))
              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{u_2} F
                (@UniformSpace.toTopologicalSpace.{u_2} F
                  (@PseudoMetricSpace.toUniformSpace.{u_2} F
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1))))
                (@NormedAddCommGroup.toENormedAddCommMonoid.{u_2} F inst_1)))
            (@NormedSpace.toModule.{u_1, u_2} 𝕜 F (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} F inst_1) inst_2)))))
```

### D110: `ContDiffWithinAt.match_1`

- Role: `local`
- Owner module: `Mathlib.Analysis.Calculus.ContDiff.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `3fb82ad3d7bc836ca5754a6ef57c10fbf626fd11270993095a0e2aa7243fcedc`

Type:

```lean
(motive : WithTop ENat → Sort u_1) →
  (n : WithTop ENat) → (Unit → motive Option.none) → ((n : ENat) → motive (Option.some n)) → motive n
```

Fully explicit type:

```lean
(motive : WithTop.{0} ENat → Sort u_1) →
  (n : WithTop.{0} ENat) →
    (h_1 : (a : Unit) → motive (@Option.none.{0} ENat)) →
      (h_2 : (n : ENat) → motive (@Option.some.{0} ENat n)) → motive n
```

Definition body (one-level semantic boundary):

```lean
fun motive n h_1 h_2 => Option.casesOn n (h_1 Unit.unit) fun val => h_2 val
```

### D111: `HasFTaylorSeriesUpToOn`

- Role: `local`
- Owner module: `Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries`
- Declaration kind: `inductive`
- Distance from target type: `6`
- Semantic SHA-256: `e23cab32e63e501bc7866464d24f16d3d932a57d8fe9b4283b9270835f2ea6e2`

Type:

```lean
{𝕜 : Type u} →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type uE} →
      [inst_1 : NormedAddCommGroup E] →
        [inst_2 : NormedSpace 𝕜 E] →
          {F : Type uF} →
            [inst_3 : NormedAddCommGroup F] →
              [inst_4 : NormedSpace 𝕜 F] → WithTop ENat → (E → F) → (E → FormalMultilinearSeries 𝕜 E F) → Set E → Prop
```

Fully explicit type:

```lean
{𝕜 : Type u} →
  [inst : NontriviallyNormedField.{u} 𝕜] →
    {E : Type uE} →
      [inst_1 : NormedAddCommGroup.{uE} E] →
        [inst_2 :
            @NormedSpace.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1)] →
          {F : Type uF} →
            [inst_3 : NormedAddCommGroup.{uF} F] →
              [inst_4 :
                  @NormedSpace.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)] →
                (n : WithTop.{0} ENat) →
                  (f : E → F) →
                    (p :
                        E →
                          @FormalMultilinearSeries.{u, uE, uF} 𝕜 E F
                            (@DivisionSemiring.toSemiring.{u} 𝕜
                              (@Semifield.toDivisionSemiring.{u} 𝕜
                                (@Field.toSemifield.{u} 𝕜
                                  (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                            (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                              (@UniformSpace.toTopologicalSpace.{uE} E
                                (@PseudoMetricSpace.toUniformSpace.{uE} E
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                                (@UniformSpace.toTopologicalSpace.{uE} E
                                  (@PseudoMetricSpace.toUniformSpace.{uE} E
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))
                            (@NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)
                            (@UniformSpace.toTopologicalSpace.{uE} E
                              (@PseudoMetricSpace.toUniformSpace.{uE} E
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                            (@IsTopologicalAddGroup.toContinuousAdd.{uE} E
                              (@UniformSpace.toTopologicalSpace.{uE} E
                                (@PseudoMetricSpace.toUniformSpace.{uE} E
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                              (@NormedAddGroup.toAddGroup.{uE} E (@NormedAddCommGroup.toNormedAddGroup.{uE} E inst_1))
                              (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{uE} E
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1)))
                            (@UniformContinuousConstSMul.to_continuousConstSMul.{u, uE} 𝕜 E
                              (@PseudoMetricSpace.toUniformSpace.{uE} E
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1)))
                              (@SMulZeroClass.toSMul.{u, uE} 𝕜 E
                                (@AddZero.toZero.{uE} E
                                  (@AddZeroClass.toAddZero.{uE} E
                                    (@AddMonoid.toAddZeroClass.{uE} E
                                      (@AddCommMonoid.toAddMonoid.{uE} E
                                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                                          (@UniformSpace.toTopologicalSpace.{uE} E
                                            (@PseudoMetricSpace.toUniformSpace.{uE} E
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                                            (@UniformSpace.toTopologicalSpace.{uE} E
                                              (@PseudoMetricSpace.toUniformSpace.{uE} E
                                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                            (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))))))
                                (@DistribSMul.toSMulZeroClass.{u, uE} 𝕜 E
                                  (@AddMonoid.toAddZeroClass.{uE} E
                                    (@AddCommMonoid.toAddMonoid.{uE} E
                                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                                        (@UniformSpace.toTopologicalSpace.{uE} E
                                          (@PseudoMetricSpace.toUniformSpace.{uE} E
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                                          (@UniformSpace.toTopologicalSpace.{uE} E
                                            (@PseudoMetricSpace.toUniformSpace.{uE} E
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                          (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))))
                                  (@DistribMulAction.toDistribSMul.{u, uE} 𝕜 E
                                    (@MonoidWithZero.toMonoid.{u} 𝕜
                                      (@Semiring.toMonoidWithZero.{u} 𝕜
                                        (@DivisionSemiring.toSemiring.{u} 𝕜
                                          (@Semifield.toDivisionSemiring.{u} 𝕜
                                            (@Field.toSemifield.{u} 𝕜
                                              (@NormedField.toField.{u} 𝕜
                                                (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                                    (@AddCommMonoid.toAddMonoid.{uE} E
                                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                                        (@UniformSpace.toTopologicalSpace.{uE} E
                                          (@PseudoMetricSpace.toUniformSpace.{uE} E
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                                          (@UniformSpace.toTopologicalSpace.{uE} E
                                            (@PseudoMetricSpace.toUniformSpace.{uE} E
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                          (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1))))
                                    (@Module.toDistribMulAction.{u, uE} 𝕜 E
                                      (@DivisionSemiring.toSemiring.{u} 𝕜
                                        (@Semifield.toDivisionSemiring.{u} 𝕜
                                          (@Field.toSemifield.{u} 𝕜
                                            (@NormedField.toField.{u} 𝕜
                                              (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                                        (@UniformSpace.toTopologicalSpace.{uE} E
                                          (@PseudoMetricSpace.toUniformSpace.{uE} E
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                                          (@UniformSpace.toTopologicalSpace.{uE} E
                                            (@PseudoMetricSpace.toUniformSpace.{uE} E
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                          (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))
                                      (@NormedSpace.toModule.{u, uE} 𝕜 E
                                        (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)))))
                              (@IsBoundedSMul.toUniformContinuousConstSMul.{u, uE} 𝕜 E
                                (@SeminormedRing.toPseudoMetricSpace.{u} 𝕜
                                  (@SeminormedCommRing.toSeminormedRing.{u} 𝕜
                                    (@NormedCommRing.toSeminormedCommRing.{u} 𝕜
                                      (@NormedField.toNormedCommRing.{u} 𝕜
                                        (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))
                                (@MulZeroClass.toZero.{u} 𝕜
                                  (@NonUnitalNonAssocSemiring.toMulZeroClass.{u} 𝕜
                                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} 𝕜
                                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} 𝕜
                                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u} 𝕜
                                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{u} 𝕜
                                            (@NormedCommRing.toNonUnitalNormedCommRing.{u} 𝕜
                                              (@NormedField.toNormedCommRing.{u} 𝕜
                                                (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))))
                                (@NegZeroClass.toZero.{uE} E
                                  (@SubNegZeroMonoid.toNegZeroClass.{uE} E
                                    (@SubtractionMonoid.toSubNegZeroMonoid.{uE} E
                                      (@SubtractionCommMonoid.toSubtractionMonoid.{uE} E
                                        (@AddCommGroup.toDivisionAddCommMonoid.{uE} E
                                          (@NormedAddCommGroup.toAddCommGroup.{uE} E inst_1))))))
                                (@SMulZeroClass.toSMul.{u, uE} 𝕜 E
                                  (@AddZero.toZero.{uE} E
                                    (@AddZeroClass.toAddZero.{uE} E
                                      (@AddMonoid.toAddZeroClass.{uE} E
                                        (@AddCommMonoid.toAddMonoid.{uE} E
                                          (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                                            (@UniformSpace.toTopologicalSpace.{uE} E
                                              (@PseudoMetricSpace.toUniformSpace.{uE} E
                                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                            (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                                              (@UniformSpace.toTopologicalSpace.{uE} E
                                                (@PseudoMetricSpace.toUniformSpace.{uE} E
                                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                              (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))))))
                                  (@DistribSMul.toSMulZeroClass.{u, uE} 𝕜 E
                                    (@AddMonoid.toAddZeroClass.{uE} E
                                      (@AddCommMonoid.toAddMonoid.{uE} E
                                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                                          (@UniformSpace.toTopologicalSpace.{uE} E
                                            (@PseudoMetricSpace.toUniformSpace.{uE} E
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                                            (@UniformSpace.toTopologicalSpace.{uE} E
                                              (@PseudoMetricSpace.toUniformSpace.{uE} E
                                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                            (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))))
                                    (@DistribMulAction.toDistribSMul.{u, uE} 𝕜 E
                                      (@MonoidWithZero.toMonoid.{u} 𝕜
                                        (@Semiring.toMonoidWithZero.{u} 𝕜
                                          (@DivisionSemiring.toSemiring.{u} 𝕜
                                            (@Semifield.toDivisionSemiring.{u} 𝕜
                                              (@Field.toSemifield.{u} 𝕜
                                                (@NormedField.toField.{u} 𝕜
                                                  (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                                      (@AddCommMonoid.toAddMonoid.{uE} E
                                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                                          (@UniformSpace.toTopologicalSpace.{uE} E
                                            (@PseudoMetricSpace.toUniformSpace.{uE} E
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                                            (@UniformSpace.toTopologicalSpace.{uE} E
                                              (@PseudoMetricSpace.toUniformSpace.{uE} E
                                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                            (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1))))
                                      (@Module.toDistribMulAction.{u, uE} 𝕜 E
                                        (@DivisionSemiring.toSemiring.{u} 𝕜
                                          (@Semifield.toDivisionSemiring.{u} 𝕜
                                            (@Field.toSemifield.{u} 𝕜
                                              (@NormedField.toField.{u} 𝕜
                                                (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                                          (@UniformSpace.toTopologicalSpace.{uE} E
                                            (@PseudoMetricSpace.toUniformSpace.{uE} E
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                                            (@UniformSpace.toTopologicalSpace.{uE} E
                                              (@PseudoMetricSpace.toUniformSpace.{uE} E
                                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                                            (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))
                                        (@NormedSpace.toModule.{u, uE} 𝕜 E
                                          (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)))))
                                (@NormedSpace.toIsBoundedSMul.{u, uE} 𝕜 E
                                  (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)))
                            (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                              (@UniformSpace.toTopologicalSpace.{uF} F
                                (@PseudoMetricSpace.toUniformSpace.{uF} F
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                (@UniformSpace.toTopologicalSpace.{uF} F
                                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
                            (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)
                            (@UniformSpace.toTopologicalSpace.{uF} F
                              (@PseudoMetricSpace.toUniformSpace.{uF} F
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                            (@IsTopologicalAddGroup.toContinuousAdd.{uF} F
                              (@UniformSpace.toTopologicalSpace.{uF} F
                                (@PseudoMetricSpace.toUniformSpace.{uF} F
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                              (@NormedAddGroup.toAddGroup.{uF} F (@NormedAddCommGroup.toNormedAddGroup.{uF} F inst_3))
                              (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{uF} F
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))
                            (@UniformContinuousConstSMul.to_continuousConstSMul.{u, uF} 𝕜 F
                              (@PseudoMetricSpace.toUniformSpace.{uF} F
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))
                              (@SMulZeroClass.toSMul.{u, uF} 𝕜 F
                                (@AddZero.toZero.{uF} F
                                  (@AddZeroClass.toAddZero.{uF} F
                                    (@AddMonoid.toAddZeroClass.{uF} F
                                      (@AddCommMonoid.toAddMonoid.{uF} F
                                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                                          (@UniformSpace.toTopologicalSpace.{uF} F
                                            (@PseudoMetricSpace.toUniformSpace.{uF} F
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                            (@UniformSpace.toTopologicalSpace.{uF} F
                                              (@PseudoMetricSpace.toUniformSpace.{uF} F
                                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                            (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))))
                                (@DistribSMul.toSMulZeroClass.{u, uF} 𝕜 F
                                  (@AddMonoid.toAddZeroClass.{uF} F
                                    (@AddCommMonoid.toAddMonoid.{uF} F
                                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                                        (@UniformSpace.toTopologicalSpace.{uF} F
                                          (@PseudoMetricSpace.toUniformSpace.{uF} F
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                          (@UniformSpace.toTopologicalSpace.{uF} F
                                            (@PseudoMetricSpace.toUniformSpace.{uF} F
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                          (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))
                                  (@DistribMulAction.toDistribSMul.{u, uF} 𝕜 F
                                    (@MonoidWithZero.toMonoid.{u} 𝕜
                                      (@Semiring.toMonoidWithZero.{u} 𝕜
                                        (@DivisionSemiring.toSemiring.{u} 𝕜
                                          (@Semifield.toDivisionSemiring.{u} 𝕜
                                            (@Field.toSemifield.{u} 𝕜
                                              (@NormedField.toField.{u} 𝕜
                                                (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                                    (@AddCommMonoid.toAddMonoid.{uF} F
                                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                                        (@UniformSpace.toTopologicalSpace.{uF} F
                                          (@PseudoMetricSpace.toUniformSpace.{uF} F
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                          (@UniformSpace.toTopologicalSpace.{uF} F
                                            (@PseudoMetricSpace.toUniformSpace.{uF} F
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                          (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3))))
                                    (@Module.toDistribMulAction.{u, uF} 𝕜 F
                                      (@DivisionSemiring.toSemiring.{u} 𝕜
                                        (@Semifield.toDivisionSemiring.{u} 𝕜
                                          (@Field.toSemifield.{u} 𝕜
                                            (@NormedField.toField.{u} 𝕜
                                              (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                                        (@UniformSpace.toTopologicalSpace.{uF} F
                                          (@PseudoMetricSpace.toUniformSpace.{uF} F
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                          (@UniformSpace.toTopologicalSpace.{uF} F
                                            (@PseudoMetricSpace.toUniformSpace.{uF} F
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                          (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
                                      (@NormedSpace.toModule.{u, uF} 𝕜 F
                                        (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)))))
                              (@IsBoundedSMul.toUniformContinuousConstSMul.{u, uF} 𝕜 F
                                (@SeminormedRing.toPseudoMetricSpace.{u} 𝕜
                                  (@SeminormedCommRing.toSeminormedRing.{u} 𝕜
                                    (@NormedCommRing.toSeminormedCommRing.{u} 𝕜
                                      (@NormedField.toNormedCommRing.{u} 𝕜
                                        (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))
                                (@MulZeroClass.toZero.{u} 𝕜
                                  (@NonUnitalNonAssocSemiring.toMulZeroClass.{u} 𝕜
                                    (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} 𝕜
                                      (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} 𝕜
                                        (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u} 𝕜
                                          (@NonUnitalNormedCommRing.toNonUnitalCommRing.{u} 𝕜
                                            (@NormedCommRing.toNonUnitalNormedCommRing.{u} 𝕜
                                              (@NormedField.toNormedCommRing.{u} 𝕜
                                                (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))))
                                (@NegZeroClass.toZero.{uF} F
                                  (@SubNegZeroMonoid.toNegZeroClass.{uF} F
                                    (@SubtractionMonoid.toSubNegZeroMonoid.{uF} F
                                      (@SubtractionCommMonoid.toSubtractionMonoid.{uF} F
                                        (@AddCommGroup.toDivisionAddCommMonoid.{uF} F
                                          (@NormedAddCommGroup.toAddCommGroup.{uF} F inst_3))))))
                                (@SMulZeroClass.toSMul.{u, uF} 𝕜 F
                                  (@AddZero.toZero.{uF} F
                                    (@AddZeroClass.toAddZero.{uF} F
                                      (@AddMonoid.toAddZeroClass.{uF} F
                                        (@AddCommMonoid.toAddMonoid.{uF} F
                                          (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                                            (@UniformSpace.toTopologicalSpace.{uF} F
                                              (@PseudoMetricSpace.toUniformSpace.{uF} F
                                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                            (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                              (@UniformSpace.toTopologicalSpace.{uF} F
                                                (@PseudoMetricSpace.toUniformSpace.{uF} F
                                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                              (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))))
                                  (@DistribSMul.toSMulZeroClass.{u, uF} 𝕜 F
                                    (@AddMonoid.toAddZeroClass.{uF} F
                                      (@AddCommMonoid.toAddMonoid.{uF} F
                                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                                          (@UniformSpace.toTopologicalSpace.{uF} F
                                            (@PseudoMetricSpace.toUniformSpace.{uF} F
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                            (@UniformSpace.toTopologicalSpace.{uF} F
                                              (@PseudoMetricSpace.toUniformSpace.{uF} F
                                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                            (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))
                                    (@DistribMulAction.toDistribSMul.{u, uF} 𝕜 F
                                      (@MonoidWithZero.toMonoid.{u} 𝕜
                                        (@Semiring.toMonoidWithZero.{u} 𝕜
                                          (@DivisionSemiring.toSemiring.{u} 𝕜
                                            (@Semifield.toDivisionSemiring.{u} 𝕜
                                              (@Field.toSemifield.{u} 𝕜
                                                (@NormedField.toField.{u} 𝕜
                                                  (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                                      (@AddCommMonoid.toAddMonoid.{uF} F
                                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                                          (@UniformSpace.toTopologicalSpace.{uF} F
                                            (@PseudoMetricSpace.toUniformSpace.{uF} F
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                            (@UniformSpace.toTopologicalSpace.{uF} F
                                              (@PseudoMetricSpace.toUniformSpace.{uF} F
                                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                            (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3))))
                                      (@Module.toDistribMulAction.{u, uF} 𝕜 F
                                        (@DivisionSemiring.toSemiring.{u} 𝕜
                                          (@Semifield.toDivisionSemiring.{u} 𝕜
                                            (@Field.toSemifield.{u} 𝕜
                                              (@NormedField.toField.{u} 𝕜
                                                (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                                          (@UniformSpace.toTopologicalSpace.{uF} F
                                            (@PseudoMetricSpace.toUniformSpace.{uF} F
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                            (@UniformSpace.toTopologicalSpace.{uF} F
                                              (@PseudoMetricSpace.toUniformSpace.{uF} F
                                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                            (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
                                        (@NormedSpace.toModule.{u, uF} 𝕜 F
                                          (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)))))
                                (@NormedSpace.toIsBoundedSMul.{u, uF} 𝕜 F
                                  (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)))) →
                      (s : Set.{uE} E) → Prop
```

### D112: `NumStability.FiniteCoordinate.PhysicalLine.Incidence.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalLineCapacity`
- Declaration kind: `constructor`
- Distance from target type: `6`
- Semantic SHA-256: `8839d87aee74a1aa642e1087b274c883e883f4199c93c236788f0b82ad0b526a`

Type:

```lean
∀ {D : Type u_1} {Cell : Type u_2} {Face : Type u_3} {Point : Type u_4} {FacePoint : Type u_5} {Line : Type u_6}
  [inst : MeasurableSpace Point] [inst_1 : TopologicalSpace Point] [inst_2 : MeasurableSpace FacePoint] {m : Nat}
  {data : NumStability.FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m}
  {coord : NumStability.FiniteCoordinate.LineCoordinates D Cell Face Line},
  (∀ (d : D) (cell : Cell), Eq (coord.faceLine d (data.leftFace d cell)) (coord.cellLine d cell)) →
    (∀ (d : D) (cell : Cell), Eq (coord.faceLine d (data.rightFace d cell)) (coord.cellLine d cell)) →
      (∀ (d : D) (cell : Cell), Eq (coord.faceIndex d (data.leftFace d cell)) (coord.cellIndex d cell)) →
        (∀ (d : D) (cell : Cell),
            Eq (coord.faceIndex d (data.rightFace d cell)) (instHAdd.hAdd (coord.cellIndex d cell) 1)) →
          NumStability.FiniteCoordinate.PhysicalLine.Incidence data coord
```

Fully explicit type:

```lean
∀ {D : Type u_1} {Cell : Type u_2} {Face : Type u_3} {Point : Type u_4} {FacePoint : Type u_5} {Line : Type u_6}
  [inst : MeasurableSpace.{u_4} Point] [inst_1 : TopologicalSpace.{u_4} Point]
  [inst_2 : MeasurableSpace.{u_5} FacePoint] {m : Nat}
  {data :
    @NumStability.FiniteCoordinate.PhysicalData.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint inst inst_1 inst_2
      m}
  {coord : @NumStability.FiniteCoordinate.LineCoordinates.{u_1, u_2, u_3, u_6} m D Cell Face Line}
  (left_line :
    ∀ (d : D) (cell : Cell),
      @Eq.{u_6 + 1} Line
        (@NumStability.FiniteCoordinate.LineCoordinates.faceLine.{u_1, u_2, u_3, u_6} m D Cell Face Line coord d
          (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
            inst inst_1 inst_2 m data d cell))
        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3, u_6} m D Cell Face Line coord d cell))
  (right_line :
    ∀ (d : D) (cell : Cell),
      @Eq.{u_6 + 1} Line
        (@NumStability.FiniteCoordinate.LineCoordinates.faceLine.{u_1, u_2, u_3, u_6} m D Cell Face Line coord d
          (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
            inst inst_1 inst_2 m data d cell))
        (@NumStability.FiniteCoordinate.LineCoordinates.cellLine.{u_1, u_2, u_3, u_6} m D Cell Face Line coord d cell))
  (left_index :
    ∀ (d : D) (cell : Cell),
      @Eq.{1} Int
        (@NumStability.FiniteCoordinate.LineCoordinates.faceIndex.{u_1, u_2, u_3, u_6} m D Cell Face Line coord d
          (@NumStability.FiniteCoordinate.PhysicalData.leftFace.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
            inst inst_1 inst_2 m data d cell))
        (@NumStability.FiniteCoordinate.LineCoordinates.cellIndex.{u_1, u_2, u_3, u_6} m D Cell Face Line coord d cell))
  (right_index :
    ∀ (d : D) (cell : Cell),
      @Eq.{1} Int
        (@NumStability.FiniteCoordinate.LineCoordinates.faceIndex.{u_1, u_2, u_3, u_6} m D Cell Face Line coord d
          (@NumStability.FiniteCoordinate.PhysicalData.rightFace.{u_1, u_2, u_3, u_4, u_5} D Cell Face Point FacePoint
            inst inst_1 inst_2 m data d cell))
        (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd)
          (@NumStability.FiniteCoordinate.LineCoordinates.cellIndex.{u_1, u_2, u_3, u_6} m D Cell Face Line coord d
            cell)
          (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1))))),
  @NumStability.FiniteCoordinate.PhysicalLine.Incidence.{u_1, u_2, u_3, u_4, u_5, u_6} D Cell Face Point FacePoint Line
    inst inst_1 inst_2 m data coord
```

### D113: `NumStability.IsHyperbolicFluxAt`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `f3c7e9b05681e761c2bdf245f341cbda0480762d7a41c10863afad36b06495ac`

Type:

```lean
{m : Nat} → ((Fin m → Real) → Fin m → Real) → (Fin m → Real) → Prop
```

Fully explicit type:

```lean
{m : Nat} → (flux : (Fin m → Real) → Fin m → Real) → (state : Fin m → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {m} flux state =>
  Exists fun derivative =>
    And (HasFDerivAt flux derivative state)
      (NumStability.IsRealHyperbolicMatrix (EquivLike.toFunLike.coe LinearMap.toMatrix' derivative.toLinearMap))
```

### D114: `HasFTaylorSeriesUpToOn.mk`

- Role: `local`
- Owner module: `Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries`
- Declaration kind: `constructor`
- Distance from target type: `7`
- Semantic SHA-256: `fba76df696c066488b38c5132b7927b154575685ab83d759fbb6c805cba627bf`

Type:

```lean
∀ {𝕜 : Type u} [inst : NontriviallyNormedField 𝕜] {E : Type uE} [inst_1 : NormedAddCommGroup E]
  [inst_2 : NormedSpace 𝕜 E] {F : Type uF} [inst_3 : NormedAddCommGroup F] [inst_4 : NormedSpace 𝕜 F] {n : WithTop ENat}
  {f : E → F} {p : E → FormalMultilinearSeries 𝕜 E F} {s : Set E},
  (∀ (x : E), Set.instMembership.mem s x → Eq (p x 0).curry0 (f x)) →
    (∀ (m : Nat),
        WithTop.instPreorder.lt m.cast n →
          ∀ (x : E), Set.instMembership.mem s x → HasFDerivWithinAt (fun x => p x m) (p x m.succ).curryLeft s x) →
      (∀ (m : Nat), WithTop.instPreorder.le m.cast n → ContinuousOn (fun x => p x m) s) → HasFTaylorSeriesUpToOn n f p s
```

Fully explicit type:

```lean
∀ {𝕜 : Type u} [inst : NontriviallyNormedField.{u} 𝕜] {E : Type uE} [inst_1 : NormedAddCommGroup.{uE} E]
  [inst_2 :
    @NormedSpace.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1)]
  {F : Type uF} [inst_3 : NormedAddCommGroup.{uF} F]
  [inst_4 :
    @NormedSpace.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)]
  {n : WithTop.{0} ENat} {f : E → F}
  {p :
    E →
      @FormalMultilinearSeries.{u, uE, uF} 𝕜 E F
        (@DivisionSemiring.toSemiring.{u} 𝕜
          (@Semifield.toDivisionSemiring.{u} 𝕜
            (@Field.toSemifield.{u} 𝕜
              (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
        (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
          (@UniformSpace.toTopologicalSpace.{uE} E
            (@PseudoMetricSpace.toUniformSpace.{uE} E
              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
            (@UniformSpace.toTopologicalSpace.{uE} E
              (@PseudoMetricSpace.toUniformSpace.{uE} E
                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
            (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))
        (@NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)
        (@UniformSpace.toTopologicalSpace.{uE} E
          (@PseudoMetricSpace.toUniformSpace.{uE} E
            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
        (@IsTopologicalAddGroup.toContinuousAdd.{uE} E
          (@UniformSpace.toTopologicalSpace.{uE} E
            (@PseudoMetricSpace.toUniformSpace.{uE} E
              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
          (@NormedAddGroup.toAddGroup.{uE} E (@NormedAddCommGroup.toNormedAddGroup.{uE} E inst_1))
          (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{uE} E
            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1)))
        (@UniformContinuousConstSMul.to_continuousConstSMul.{u, uE} 𝕜 E
          (@PseudoMetricSpace.toUniformSpace.{uE} E
            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1)))
          (@SMulZeroClass.toSMul.{u, uE} 𝕜 E
            (@AddZero.toZero.{uE} E
              (@AddZeroClass.toAddZero.{uE} E
                (@AddMonoid.toAddZeroClass.{uE} E
                  (@AddCommMonoid.toAddMonoid.{uE} E
                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                      (@UniformSpace.toTopologicalSpace.{uE} E
                        (@PseudoMetricSpace.toUniformSpace.{uE} E
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                        (@UniformSpace.toTopologicalSpace.{uE} E
                          (@PseudoMetricSpace.toUniformSpace.{uE} E
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                        (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))))))
            (@DistribSMul.toSMulZeroClass.{u, uE} 𝕜 E
              (@AddMonoid.toAddZeroClass.{uE} E
                (@AddCommMonoid.toAddMonoid.{uE} E
                  (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                    (@UniformSpace.toTopologicalSpace.{uE} E
                      (@PseudoMetricSpace.toUniformSpace.{uE} E
                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                      (@UniformSpace.toTopologicalSpace.{uE} E
                        (@PseudoMetricSpace.toUniformSpace.{uE} E
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                      (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))))
              (@DistribMulAction.toDistribSMul.{u, uE} 𝕜 E
                (@MonoidWithZero.toMonoid.{u} 𝕜
                  (@Semiring.toMonoidWithZero.{u} 𝕜
                    (@DivisionSemiring.toSemiring.{u} 𝕜
                      (@Semifield.toDivisionSemiring.{u} 𝕜
                        (@Field.toSemifield.{u} 𝕜
                          (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                (@AddCommMonoid.toAddMonoid.{uE} E
                  (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                    (@UniformSpace.toTopologicalSpace.{uE} E
                      (@PseudoMetricSpace.toUniformSpace.{uE} E
                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                      (@UniformSpace.toTopologicalSpace.{uE} E
                        (@PseudoMetricSpace.toUniformSpace.{uE} E
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                      (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1))))
                (@Module.toDistribMulAction.{u, uE} 𝕜 E
                  (@DivisionSemiring.toSemiring.{u} 𝕜
                    (@Semifield.toDivisionSemiring.{u} 𝕜
                      (@Field.toSemifield.{u} 𝕜
                        (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                  (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                    (@UniformSpace.toTopologicalSpace.{uE} E
                      (@PseudoMetricSpace.toUniformSpace.{uE} E
                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                      (@UniformSpace.toTopologicalSpace.{uE} E
                        (@PseudoMetricSpace.toUniformSpace.{uE} E
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                      (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))
                  (@NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)))))
          (@IsBoundedSMul.toUniformContinuousConstSMul.{u, uE} 𝕜 E
            (@SeminormedRing.toPseudoMetricSpace.{u} 𝕜
              (@SeminormedCommRing.toSeminormedRing.{u} 𝕜
                (@NormedCommRing.toSeminormedCommRing.{u} 𝕜
                  (@NormedField.toNormedCommRing.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))
            (@MulZeroClass.toZero.{u} 𝕜
              (@NonUnitalNonAssocSemiring.toMulZeroClass.{u} 𝕜
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} 𝕜
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} 𝕜
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u} 𝕜
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{u} 𝕜
                        (@NormedCommRing.toNonUnitalNormedCommRing.{u} 𝕜
                          (@NormedField.toNormedCommRing.{u} 𝕜
                            (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))))
            (@NegZeroClass.toZero.{uE} E
              (@SubNegZeroMonoid.toNegZeroClass.{uE} E
                (@SubtractionMonoid.toSubNegZeroMonoid.{uE} E
                  (@SubtractionCommMonoid.toSubtractionMonoid.{uE} E
                    (@AddCommGroup.toDivisionAddCommMonoid.{uE} E
                      (@NormedAddCommGroup.toAddCommGroup.{uE} E inst_1))))))
            (@SMulZeroClass.toSMul.{u, uE} 𝕜 E
              (@AddZero.toZero.{uE} E
                (@AddZeroClass.toAddZero.{uE} E
                  (@AddMonoid.toAddZeroClass.{uE} E
                    (@AddCommMonoid.toAddMonoid.{uE} E
                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                        (@UniformSpace.toTopologicalSpace.{uE} E
                          (@PseudoMetricSpace.toUniformSpace.{uE} E
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                          (@UniformSpace.toTopologicalSpace.{uE} E
                            (@PseudoMetricSpace.toUniformSpace.{uE} E
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                          (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))))))
              (@DistribSMul.toSMulZeroClass.{u, uE} 𝕜 E
                (@AddMonoid.toAddZeroClass.{uE} E
                  (@AddCommMonoid.toAddMonoid.{uE} E
                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                      (@UniformSpace.toTopologicalSpace.{uE} E
                        (@PseudoMetricSpace.toUniformSpace.{uE} E
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                        (@UniformSpace.toTopologicalSpace.{uE} E
                          (@PseudoMetricSpace.toUniformSpace.{uE} E
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                        (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))))
                (@DistribMulAction.toDistribSMul.{u, uE} 𝕜 E
                  (@MonoidWithZero.toMonoid.{u} 𝕜
                    (@Semiring.toMonoidWithZero.{u} 𝕜
                      (@DivisionSemiring.toSemiring.{u} 𝕜
                        (@Semifield.toDivisionSemiring.{u} 𝕜
                          (@Field.toSemifield.{u} 𝕜
                            (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                  (@AddCommMonoid.toAddMonoid.{uE} E
                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                      (@UniformSpace.toTopologicalSpace.{uE} E
                        (@PseudoMetricSpace.toUniformSpace.{uE} E
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                        (@UniformSpace.toTopologicalSpace.{uE} E
                          (@PseudoMetricSpace.toUniformSpace.{uE} E
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                        (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1))))
                  (@Module.toDistribMulAction.{u, uE} 𝕜 E
                    (@DivisionSemiring.toSemiring.{u} 𝕜
                      (@Semifield.toDivisionSemiring.{u} 𝕜
                        (@Field.toSemifield.{u} 𝕜
                          (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                      (@UniformSpace.toTopologicalSpace.{uE} E
                        (@PseudoMetricSpace.toUniformSpace.{uE} E
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                        (@UniformSpace.toTopologicalSpace.{uE} E
                          (@PseudoMetricSpace.toUniformSpace.{uE} E
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                        (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))
                    (@NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)))))
            (@NormedSpace.toIsBoundedSMul.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)))
        (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
          (@UniformSpace.toTopologicalSpace.{uF} F
            (@PseudoMetricSpace.toUniformSpace.{uF} F
              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
            (@UniformSpace.toTopologicalSpace.{uF} F
              (@PseudoMetricSpace.toUniformSpace.{uF} F
                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
            (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
        (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)
        (@UniformSpace.toTopologicalSpace.{uF} F
          (@PseudoMetricSpace.toUniformSpace.{uF} F
            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
        (@IsTopologicalAddGroup.toContinuousAdd.{uF} F
          (@UniformSpace.toTopologicalSpace.{uF} F
            (@PseudoMetricSpace.toUniformSpace.{uF} F
              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
          (@NormedAddGroup.toAddGroup.{uF} F (@NormedAddCommGroup.toNormedAddGroup.{uF} F inst_3))
          (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{uF} F
            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))
        (@UniformContinuousConstSMul.to_continuousConstSMul.{u, uF} 𝕜 F
          (@PseudoMetricSpace.toUniformSpace.{uF} F
            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))
          (@SMulZeroClass.toSMul.{u, uF} 𝕜 F
            (@AddZero.toZero.{uF} F
              (@AddZeroClass.toAddZero.{uF} F
                (@AddMonoid.toAddZeroClass.{uF} F
                  (@AddCommMonoid.toAddMonoid.{uF} F
                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                      (@UniformSpace.toTopologicalSpace.{uF} F
                        (@PseudoMetricSpace.toUniformSpace.{uF} F
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                        (@UniformSpace.toTopologicalSpace.{uF} F
                          (@PseudoMetricSpace.toUniformSpace.{uF} F
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                        (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))))
            (@DistribSMul.toSMulZeroClass.{u, uF} 𝕜 F
              (@AddMonoid.toAddZeroClass.{uF} F
                (@AddCommMonoid.toAddMonoid.{uF} F
                  (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                    (@UniformSpace.toTopologicalSpace.{uF} F
                      (@PseudoMetricSpace.toUniformSpace.{uF} F
                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                      (@UniformSpace.toTopologicalSpace.{uF} F
                        (@PseudoMetricSpace.toUniformSpace.{uF} F
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                      (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))
              (@DistribMulAction.toDistribSMul.{u, uF} 𝕜 F
                (@MonoidWithZero.toMonoid.{u} 𝕜
                  (@Semiring.toMonoidWithZero.{u} 𝕜
                    (@DivisionSemiring.toSemiring.{u} 𝕜
                      (@Semifield.toDivisionSemiring.{u} 𝕜
                        (@Field.toSemifield.{u} 𝕜
                          (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                (@AddCommMonoid.toAddMonoid.{uF} F
                  (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                    (@UniformSpace.toTopologicalSpace.{uF} F
                      (@PseudoMetricSpace.toUniformSpace.{uF} F
                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                      (@UniformSpace.toTopologicalSpace.{uF} F
                        (@PseudoMetricSpace.toUniformSpace.{uF} F
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                      (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3))))
                (@Module.toDistribMulAction.{u, uF} 𝕜 F
                  (@DivisionSemiring.toSemiring.{u} 𝕜
                    (@Semifield.toDivisionSemiring.{u} 𝕜
                      (@Field.toSemifield.{u} 𝕜
                        (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                  (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                    (@UniformSpace.toTopologicalSpace.{uF} F
                      (@PseudoMetricSpace.toUniformSpace.{uF} F
                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                      (@UniformSpace.toTopologicalSpace.{uF} F
                        (@PseudoMetricSpace.toUniformSpace.{uF} F
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                      (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
                  (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)))))
          (@IsBoundedSMul.toUniformContinuousConstSMul.{u, uF} 𝕜 F
            (@SeminormedRing.toPseudoMetricSpace.{u} 𝕜
              (@SeminormedCommRing.toSeminormedRing.{u} 𝕜
                (@NormedCommRing.toSeminormedCommRing.{u} 𝕜
                  (@NormedField.toNormedCommRing.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))
            (@MulZeroClass.toZero.{u} 𝕜
              (@NonUnitalNonAssocSemiring.toMulZeroClass.{u} 𝕜
                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} 𝕜
                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} 𝕜
                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u} 𝕜
                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{u} 𝕜
                        (@NormedCommRing.toNonUnitalNormedCommRing.{u} 𝕜
                          (@NormedField.toNormedCommRing.{u} 𝕜
                            (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))))
            (@NegZeroClass.toZero.{uF} F
              (@SubNegZeroMonoid.toNegZeroClass.{uF} F
                (@SubtractionMonoid.toSubNegZeroMonoid.{uF} F
                  (@SubtractionCommMonoid.toSubtractionMonoid.{uF} F
                    (@AddCommGroup.toDivisionAddCommMonoid.{uF} F
                      (@NormedAddCommGroup.toAddCommGroup.{uF} F inst_3))))))
            (@SMulZeroClass.toSMul.{u, uF} 𝕜 F
              (@AddZero.toZero.{uF} F
                (@AddZeroClass.toAddZero.{uF} F
                  (@AddMonoid.toAddZeroClass.{uF} F
                    (@AddCommMonoid.toAddMonoid.{uF} F
                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                        (@UniformSpace.toTopologicalSpace.{uF} F
                          (@PseudoMetricSpace.toUniformSpace.{uF} F
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                          (@UniformSpace.toTopologicalSpace.{uF} F
                            (@PseudoMetricSpace.toUniformSpace.{uF} F
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                          (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))))
              (@DistribSMul.toSMulZeroClass.{u, uF} 𝕜 F
                (@AddMonoid.toAddZeroClass.{uF} F
                  (@AddCommMonoid.toAddMonoid.{uF} F
                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                      (@UniformSpace.toTopologicalSpace.{uF} F
                        (@PseudoMetricSpace.toUniformSpace.{uF} F
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                        (@UniformSpace.toTopologicalSpace.{uF} F
                          (@PseudoMetricSpace.toUniformSpace.{uF} F
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                        (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))
                (@DistribMulAction.toDistribSMul.{u, uF} 𝕜 F
                  (@MonoidWithZero.toMonoid.{u} 𝕜
                    (@Semiring.toMonoidWithZero.{u} 𝕜
                      (@DivisionSemiring.toSemiring.{u} 𝕜
                        (@Semifield.toDivisionSemiring.{u} 𝕜
                          (@Field.toSemifield.{u} 𝕜
                            (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                  (@AddCommMonoid.toAddMonoid.{uF} F
                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                      (@UniformSpace.toTopologicalSpace.{uF} F
                        (@PseudoMetricSpace.toUniformSpace.{uF} F
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                        (@UniformSpace.toTopologicalSpace.{uF} F
                          (@PseudoMetricSpace.toUniformSpace.{uF} F
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                        (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3))))
                  (@Module.toDistribMulAction.{u, uF} 𝕜 F
                    (@DivisionSemiring.toSemiring.{u} 𝕜
                      (@Semifield.toDivisionSemiring.{u} 𝕜
                        (@Field.toSemifield.{u} 𝕜
                          (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                      (@UniformSpace.toTopologicalSpace.{uF} F
                        (@PseudoMetricSpace.toUniformSpace.{uF} F
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                        (@UniformSpace.toTopologicalSpace.{uF} F
                          (@PseudoMetricSpace.toUniformSpace.{uF} F
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                        (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
                    (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)))))
            (@NormedSpace.toIsBoundedSMul.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)))}
  {s : Set.{uE} E}
  (zero_eq :
    ∀ (x : E),
      @Membership.mem.{uE, uE} E (Set.{uE} E) (@Set.instMembership.{uE} E) s x →
        @Eq.{uF + 1} F
          (@ContinuousMultilinearMap.curry0.{u, uE, uF} 𝕜 E F inst inst_1 inst_2 inst_3 inst_4
            (p x (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))))
          (f x))
  (fderivWithin :
    ∀ (m : Nat),
      @LT.lt.{0} (WithTop.{0} ENat)
          (@Preorder.toLT.{0} (WithTop.{0} ENat)
            (@WithTop.instPreorder.{0} ENat
              (@PartialOrder.toPreorder.{0} ENat
                (@OmegaCompletePartialOrder.toPartialOrder.{0} ENat
                  (@CompleteLattice.instOmegaCompletePartialOrder.{0} ENat
                    (@CompletelyDistribLattice.toCompleteLattice.{0} ENat
                      (@CompleteLinearOrder.toCompletelyDistribLattice.{0} ENat instCompleteLinearOrderENat)))))))
          (@Nat.cast.{0} (WithTop.{0} ENat)
            (@AddMonoidWithOne.toNatCast.{0} (WithTop.{0} ENat)
              (@WithTop.addMonoidWithOne.{0} ENat
                (@AddCommMonoidWithOne.toAddMonoidWithOne.{0} ENat
                  (@NonAssocSemiring.toAddCommMonoidWithOne.{0} ENat
                    (@Semiring.toNonAssocSemiring.{0} ENat (@CommSemiring.toSemiring.{0} ENat instCommSemiringENat))))))
            m)
          n →
        ∀ (x : E),
          @Membership.mem.{uE, uE} E (Set.{uE} E) (@Set.instMembership.{uE} E) s x →
            @HasFDerivWithinAt.{u, uE, max uE uF} 𝕜 inst E (@NormedAddCommGroup.toAddCommGroup.{uE} E inst_1)
              (@NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)
              (@UniformSpace.toTopologicalSpace.{uE} E
                (@PseudoMetricSpace.toUniformSpace.{uE} E
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
              (@ContinuousMultilinearMap.{u, 0, uE, uF} 𝕜 (Fin m) (fun (i : Fin m) => E) F
                (@DivisionSemiring.toSemiring.{u} 𝕜
                  (@Semifield.toDivisionSemiring.{u} 𝕜
                    (@Field.toSemifield.{u} 𝕜
                      (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                (fun (i : Fin m) =>
                  @ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                    (@UniformSpace.toTopologicalSpace.{uE} E
                      (@PseudoMetricSpace.toUniformSpace.{uE} E
                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                      (@UniformSpace.toTopologicalSpace.{uE} E
                        (@PseudoMetricSpace.toUniformSpace.{uE} E
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                      (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))
                (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                  (@UniformSpace.toTopologicalSpace.{uF} F
                    (@PseudoMetricSpace.toUniformSpace.{uF} F
                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                    (@UniformSpace.toTopologicalSpace.{uF} F
                      (@PseudoMetricSpace.toUniformSpace.{uF} F
                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                    (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
                (fun (i : Fin m) =>
                  @NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)
                (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)
                (fun (i : Fin m) =>
                  @UniformSpace.toTopologicalSpace.{uE} E
                    (@PseudoMetricSpace.toUniformSpace.{uE} E
                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                (@UniformSpace.toTopologicalSpace.{uF} F
                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))))
              (@ContinuousMultilinearMap.instAddCommGroup.{u, 0, uE, uF} 𝕜 (Fin m) (fun (i : Fin m) => E) F
                (@NormedRing.toRing.{u} 𝕜
                  (@NormedCommRing.toNormedRing.{u} 𝕜
                    (@NormedField.toNormedCommRing.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst))))
                (fun (i : Fin m) => @NormedAddCommGroup.toAddCommGroup.{uE} E inst_1)
                (@NormedAddCommGroup.toAddCommGroup.{uF} F inst_3)
                (fun (i : Fin m) =>
                  @NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)
                (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)
                (fun (i : Fin m) =>
                  @UniformSpace.toTopologicalSpace.{uE} E
                    (@PseudoMetricSpace.toUniformSpace.{uE} E
                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                (@UniformSpace.toTopologicalSpace.{uF} F
                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{uF} F
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))
              (@ContinuousMultilinearMap.instModule.{0, uE, uF, u, u} (Fin m) (fun (i : Fin m) => E) F 𝕜 𝕜
                (@DivisionSemiring.toSemiring.{u} 𝕜
                  (@Semifield.toDivisionSemiring.{u} 𝕜
                    (@Field.toSemifield.{u} 𝕜
                      (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                (@DivisionSemiring.toSemiring.{u} 𝕜
                  (@Semifield.toDivisionSemiring.{u} 𝕜
                    (@Field.toSemifield.{u} 𝕜
                      (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                (fun (i : Fin m) =>
                  @ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                    (@UniformSpace.toTopologicalSpace.{uE} E
                      (@PseudoMetricSpace.toUniformSpace.{uE} E
                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                      (@UniformSpace.toTopologicalSpace.{uE} E
                        (@PseudoMetricSpace.toUniformSpace.{uE} E
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                      (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))
                (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                  (@UniformSpace.toTopologicalSpace.{uF} F
                    (@PseudoMetricSpace.toUniformSpace.{uF} F
                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                  (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                    (@UniformSpace.toTopologicalSpace.{uF} F
                      (@PseudoMetricSpace.toUniformSpace.{uF} F
                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                    (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
                (fun (i : Fin m) =>
                  @UniformSpace.toTopologicalSpace.{uE} E
                    (@PseudoMetricSpace.toUniformSpace.{uE} E
                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                (@UniformSpace.toTopologicalSpace.{uF} F
                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                (@IsTopologicalAddGroup.toContinuousAdd.{uF} F
                  (@UniformSpace.toTopologicalSpace.{uF} F
                    (@PseudoMetricSpace.toUniformSpace.{uF} F
                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                  (@NormedAddGroup.toAddGroup.{uF} F (@NormedAddCommGroup.toNormedAddGroup.{uF} F inst_3))
                  (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{uF} F
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))
                (fun (i : Fin m) =>
                  @NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)
                (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)
                (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)
                (@UniformContinuousConstSMul.to_continuousConstSMul.{u, uF} 𝕜 F
                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))
                  (@SMulZeroClass.toSMul.{u, uF} 𝕜 F
                    (@AddZero.toZero.{uF} F
                      (@AddZeroClass.toAddZero.{uF} F
                        (@AddMonoid.toAddZeroClass.{uF} F
                          (@AddCommMonoid.toAddMonoid.{uF} F
                            (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                              (@UniformSpace.toTopologicalSpace.{uF} F
                                (@PseudoMetricSpace.toUniformSpace.{uF} F
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                (@UniformSpace.toTopologicalSpace.{uF} F
                                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))))
                    (@DistribSMul.toSMulZeroClass.{u, uF} 𝕜 F
                      (@AddMonoid.toAddZeroClass.{uF} F
                        (@AddCommMonoid.toAddMonoid.{uF} F
                          (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                            (@UniformSpace.toTopologicalSpace.{uF} F
                              (@PseudoMetricSpace.toUniformSpace.{uF} F
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                            (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                              (@UniformSpace.toTopologicalSpace.{uF} F
                                (@PseudoMetricSpace.toUniformSpace.{uF} F
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                              (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))
                      (@DistribMulAction.toDistribSMul.{u, uF} 𝕜 F
                        (@MonoidWithZero.toMonoid.{u} 𝕜
                          (@Semiring.toMonoidWithZero.{u} 𝕜
                            (@DivisionSemiring.toSemiring.{u} 𝕜
                              (@Semifield.toDivisionSemiring.{u} 𝕜
                                (@Field.toSemifield.{u} 𝕜
                                  (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                        (@AddCommMonoid.toAddMonoid.{uF} F
                          (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                            (@UniformSpace.toTopologicalSpace.{uF} F
                              (@PseudoMetricSpace.toUniformSpace.{uF} F
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                            (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                              (@UniformSpace.toTopologicalSpace.{uF} F
                                (@PseudoMetricSpace.toUniformSpace.{uF} F
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                              (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3))))
                        (@Module.toDistribMulAction.{u, uF} 𝕜 F
                          (@DivisionSemiring.toSemiring.{u} 𝕜
                            (@Semifield.toDivisionSemiring.{u} 𝕜
                              (@Field.toSemifield.{u} 𝕜
                                (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                          (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                            (@UniformSpace.toTopologicalSpace.{uF} F
                              (@PseudoMetricSpace.toUniformSpace.{uF} F
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                            (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                              (@UniformSpace.toTopologicalSpace.{uF} F
                                (@PseudoMetricSpace.toUniformSpace.{uF} F
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                              (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
                          (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)))))
                  (@IsBoundedSMul.toUniformContinuousConstSMul.{u, uF} 𝕜 F
                    (@SeminormedRing.toPseudoMetricSpace.{u} 𝕜
                      (@SeminormedCommRing.toSeminormedRing.{u} 𝕜
                        (@NormedCommRing.toSeminormedCommRing.{u} 𝕜
                          (@NormedField.toNormedCommRing.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))
                    (@MulZeroClass.toZero.{u} 𝕜
                      (@NonUnitalNonAssocSemiring.toMulZeroClass.{u} 𝕜
                        (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} 𝕜
                          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} 𝕜
                            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u} 𝕜
                              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{u} 𝕜
                                (@NormedCommRing.toNonUnitalNormedCommRing.{u} 𝕜
                                  (@NormedField.toNormedCommRing.{u} 𝕜
                                    (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))))
                    (@NegZeroClass.toZero.{uF} F
                      (@SubNegZeroMonoid.toNegZeroClass.{uF} F
                        (@SubtractionMonoid.toSubNegZeroMonoid.{uF} F
                          (@SubtractionCommMonoid.toSubtractionMonoid.{uF} F
                            (@AddCommGroup.toDivisionAddCommMonoid.{uF} F
                              (@NormedAddCommGroup.toAddCommGroup.{uF} F inst_3))))))
                    (@SMulZeroClass.toSMul.{u, uF} 𝕜 F
                      (@AddZero.toZero.{uF} F
                        (@AddZeroClass.toAddZero.{uF} F
                          (@AddMonoid.toAddZeroClass.{uF} F
                            (@AddCommMonoid.toAddMonoid.{uF} F
                              (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                                (@UniformSpace.toTopologicalSpace.{uF} F
                                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                  (@UniformSpace.toTopologicalSpace.{uF} F
                                    (@PseudoMetricSpace.toUniformSpace.{uF} F
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                  (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))))
                      (@DistribSMul.toSMulZeroClass.{u, uF} 𝕜 F
                        (@AddMonoid.toAddZeroClass.{uF} F
                          (@AddCommMonoid.toAddMonoid.{uF} F
                            (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                              (@UniformSpace.toTopologicalSpace.{uF} F
                                (@PseudoMetricSpace.toUniformSpace.{uF} F
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                (@UniformSpace.toTopologicalSpace.{uF} F
                                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))))
                        (@DistribMulAction.toDistribSMul.{u, uF} 𝕜 F
                          (@MonoidWithZero.toMonoid.{u} 𝕜
                            (@Semiring.toMonoidWithZero.{u} 𝕜
                              (@DivisionSemiring.toSemiring.{u} 𝕜
                                (@Semifield.toDivisionSemiring.{u} 𝕜
                                  (@Field.toSemifield.{u} 𝕜
                                    (@NormedField.toField.{u} 𝕜
                                      (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                          (@AddCommMonoid.toAddMonoid.{uF} F
                            (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                              (@UniformSpace.toTopologicalSpace.{uF} F
                                (@PseudoMetricSpace.toUniformSpace.{uF} F
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                (@UniformSpace.toTopologicalSpace.{uF} F
                                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3))))
                          (@Module.toDistribMulAction.{u, uF} 𝕜 F
                            (@DivisionSemiring.toSemiring.{u} 𝕜
                              (@Semifield.toDivisionSemiring.{u} 𝕜
                                (@Field.toSemifield.{u} 𝕜
                                  (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                            (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                              (@UniformSpace.toTopologicalSpace.{uF} F
                                (@PseudoMetricSpace.toUniformSpace.{uF} F
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                                (@UniformSpace.toTopologicalSpace.{uF} F
                                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                                (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
                            (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)))))
                    (@NormedSpace.toIsBoundedSMul.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)))
                (@smulCommClass_self.{u, uF} 𝕜 F
                  (@CommRing.toCommMonoid.{u} 𝕜
                    (@Field.toCommRing.{u} 𝕜
                      (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst))))
                  (@DistribMulAction.toMulAction.{u, uF} 𝕜 F
                    (@CommMonoid.toMonoid.{u} 𝕜
                      (@CommRing.toCommMonoid.{u} 𝕜
                        (@Field.toCommRing.{u} 𝕜
                          (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                    (@AddCommMonoid.toAddMonoid.{uF} F
                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                        (@UniformSpace.toTopologicalSpace.{uF} F
                          (@PseudoMetricSpace.toUniformSpace.{uF} F
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                          (@UniformSpace.toTopologicalSpace.{uF} F
                            (@PseudoMetricSpace.toUniformSpace.{uF} F
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                          (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3))))
                    (@Module.toDistribMulAction.{u, uF} 𝕜 F
                      (@DivisionSemiring.toSemiring.{u} 𝕜
                        (@Semifield.toDivisionSemiring.{u} 𝕜
                          (@Field.toSemifield.{u} 𝕜
                            (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
                        (@UniformSpace.toTopologicalSpace.{uF} F
                          (@PseudoMetricSpace.toUniformSpace.{uF} F
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                          (@UniformSpace.toTopologicalSpace.{uF} F
                            (@PseudoMetricSpace.toUniformSpace.{uF} F
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                          (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
                      (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)))))
              (@ContinuousMultilinearMap.instTopologicalSpace.{u, 0, uE, uF} 𝕜 (Fin m) (fun (i : Fin m) => E) F
                (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                (fun (i : Fin m) =>
                  @UniformSpace.toTopologicalSpace.{uE} E
                    (@PseudoMetricSpace.toUniformSpace.{uE} E
                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                (fun (i : Fin m) => @NormedAddCommGroup.toAddCommGroup.{uE} E inst_1)
                (fun (i : Fin m) =>
                  @NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)
                (@NormedAddCommGroup.toAddCommGroup.{uF} F inst_3)
                (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)
                (@UniformSpace.toTopologicalSpace.{uF} F
                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{uF} F
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))
              (fun (x : E) => p x m)
              (@ContinuousMultilinearMap.curryLeft.{u, uE, uF} 𝕜 m (fun (i : Fin (Nat.succ m)) => E) F inst
                (fun (i : Fin (Nat.succ m)) => inst_1) (fun (i : Fin (Nat.succ m)) => inst_2) inst_3 inst_4
                (p x (Nat.succ m)))
              s x)
  (cont :
    ∀ (m : Nat),
      @LE.le.{0} (WithTop.{0} ENat)
          (@Preorder.toLE.{0} (WithTop.{0} ENat)
            (@WithTop.instPreorder.{0} ENat
              (@PartialOrder.toPreorder.{0} ENat
                (@OmegaCompletePartialOrder.toPartialOrder.{0} ENat
                  (@CompleteLattice.instOmegaCompletePartialOrder.{0} ENat
                    (@CompletelyDistribLattice.toCompleteLattice.{0} ENat
                      (@CompleteLinearOrder.toCompletelyDistribLattice.{0} ENat instCompleteLinearOrderENat)))))))
          (@Nat.cast.{0} (WithTop.{0} ENat)
            (@AddMonoidWithOne.toNatCast.{0} (WithTop.{0} ENat)
              (@WithTop.addMonoidWithOne.{0} ENat
                (@AddCommMonoidWithOne.toAddMonoidWithOne.{0} ENat
                  (@NonAssocSemiring.toAddCommMonoidWithOne.{0} ENat
                    (@Semiring.toNonAssocSemiring.{0} ENat (@CommSemiring.toSemiring.{0} ENat instCommSemiringENat))))))
            m)
          n →
        @ContinuousOn.{uE, max uE uF} E
          (@ContinuousMultilinearMap.{u, 0, uE, uF} 𝕜 (Fin m) (fun (i : Fin m) => E) F
            (@DivisionSemiring.toSemiring.{u} 𝕜
              (@Semifield.toDivisionSemiring.{u} 𝕜
                (@Field.toSemifield.{u} 𝕜
                  (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
            (fun (i : Fin m) =>
              @ESeminormedAddCommMonoid.toAddCommMonoid.{uE} E
                (@UniformSpace.toTopologicalSpace.{uE} E
                  (@PseudoMetricSpace.toUniformSpace.{uE} E
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uE} E
                  (@UniformSpace.toTopologicalSpace.{uE} E
                    (@PseudoMetricSpace.toUniformSpace.{uE} E
                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
                  (@NormedAddCommGroup.toENormedAddCommMonoid.{uE} E inst_1)))
            (@ESeminormedAddCommMonoid.toAddCommMonoid.{uF} F
              (@UniformSpace.toTopologicalSpace.{uF} F
                (@PseudoMetricSpace.toUniformSpace.{uF} F
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
              (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{uF} F
                (@UniformSpace.toTopologicalSpace.{uF} F
                  (@PseudoMetricSpace.toUniformSpace.{uF} F
                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
                (@NormedAddCommGroup.toENormedAddCommMonoid.{uF} F inst_3)))
            (fun (i : Fin m) =>
              @NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)
            (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)
            (fun (i : Fin m) =>
              @UniformSpace.toTopologicalSpace.{uE} E
                (@PseudoMetricSpace.toUniformSpace.{uE} E
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
            (@UniformSpace.toTopologicalSpace.{uF} F
              (@PseudoMetricSpace.toUniformSpace.{uF} F
                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))))
          (@UniformSpace.toTopologicalSpace.{uE} E
            (@PseudoMetricSpace.toUniformSpace.{uE} E
              (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
          (@ContinuousMultilinearMap.instTopologicalSpace.{u, 0, uE, uF} 𝕜 (Fin m) (fun (i : Fin m) => E) F
            (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
            (fun (i : Fin m) =>
              @UniformSpace.toTopologicalSpace.{uE} E
                (@PseudoMetricSpace.toUniformSpace.{uE} E
                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{uE} E
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1))))
            (fun (i : Fin m) => @NormedAddCommGroup.toAddCommGroup.{uE} E inst_1)
            (fun (i : Fin m) =>
              @NormedSpace.toModule.{u, uE} 𝕜 E (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                (@NormedAddCommGroup.toSeminormedAddCommGroup.{uE} E inst_1) inst_2)
            (@NormedAddCommGroup.toAddCommGroup.{uF} F inst_3)
            (@NormedSpace.toModule.{u, uF} 𝕜 F (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3) inst_4)
            (@UniformSpace.toTopologicalSpace.{uF} F
              (@PseudoMetricSpace.toUniformSpace.{uF} F
                (@SeminormedAddCommGroup.toPseudoMetricSpace.{uF} F
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3))))
            (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{uF} F
              (@NormedAddCommGroup.toSeminormedAddCommGroup.{uF} F inst_3)))
          (fun (x : E) => p x m) s),
  @HasFTaylorSeriesUpToOn.{u, uE, uF} 𝕜 inst E inst_1 inst_2 F inst_3 inst_4 n f p s
```

### D115: `NumStability.IsHyperbolicFluxAt._proof_1`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `theorem`
- Distance from target type: `7`
- Semantic SHA-256: `56914ea600c008889cf7a321fb9725518cbcfbc35c6f46b7b5ae2efa1e8016a6`

Type:

```lean
RingHomInvPair (RingHom.id Real) (RingHom.id Real)
```

Fully explicit type:

```lean
@RingHomInvPair.{0, 0} Real Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
  (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
  (@RingHom.id.{0} Real
    (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
  (@RingHom.id.{0} Real
    (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
```

### D116: `NumStability.IsHyperbolicFluxAt._proof_2`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity`
- Declaration kind: `theorem`
- Distance from target type: `7`
- Semantic SHA-256: `45d3d1103b49ff0e7e5c94c9e228d5836e8f391818c033dff1ce8e9b522d12e0`

Type:

```lean
∀ {m : Nat}, SMulCommClass Real Real (Fin m → Real)
```

Fully explicit type:

```lean
∀ {m : Nat},
  @SMulCommClass.{0, 0, 0} Real Real (Fin m → Real)
    (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
      (@SemigroupAction.toSMul.{0, 0} Real Real
        (@Monoid.toSemigroup.{0} Real
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring))))
        (@MulAction.toSemigroupAction.{0, 0} Real Real
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
          (@DistribMulAction.toMulAction.{0, 0} Real Real
            (@MonoidWithZero.toMonoid.{0} Real
              (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
            (@AddCommMonoid.toAddMonoid.{0} Real
              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                  (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))))
            (@Module.toDistribMulAction.{0, 0} Real Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                  (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring))))
              (@Semiring.toModule.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))))))
    (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
      (@SemigroupAction.toSMul.{0, 0} Real Real
        (@Monoid.toSemigroup.{0} Real
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring))))
        (@MulAction.toSemigroupAction.{0, 0} Real Real
          (@MonoidWithZero.toMonoid.{0} Real
            (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
          (@DistribMulAction.toMulAction.{0, 0} Real Real
            (@MonoidWithZero.toMonoid.{0} Real
              (@Semiring.toMonoidWithZero.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))
            (@AddCommMonoid.toAddMonoid.{0} Real
              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                  (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))))
            (@Module.toDistribMulAction.{0, 0} Real Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
              (@NonUnitalNonAssocSemiring.toAddCommMonoid.{0} Real
                (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{0} Real
                  (@Semiring.toNonAssocSemiring.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring))))
              (@Semiring.toModule.{0} Real (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)))))))
```

### D117: `NumStability.IsRealHyperbolicMatrix`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `d47cd84c44b0c456ec06f4b48845c39c02daf4bc4240508afd66168e57eb795c`

Type:

```lean
{ι : Type u_1} → [Fintype ι] → Matrix ι ι Real → Prop
```

Fully explicit type:

```lean
{ι : Type u_1} → [Fintype.{u_1} ι] → (coefficient : Matrix.{u_1, u_1, 0} ι ι Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] coefficient =>
  Exists fun eigenvalues =>
    Exists fun eigenbasis =>
      ∀ (p : ι),
        Eq (coefficient.mulVec (Module.Basis.instFunLike.coe eigenbasis p))
          (instHSMul.hSMul (eigenvalues p) (Module.Basis.instFunLike.coe eigenbasis p))
```

### D118: `And`

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

### D119: `DecidableEq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ceb5edcca38a0d8e0cbe42efd319eed4e877a75211690cacfd89ee5799fb1004`

Type:

```lean
Sort u → Sort (max 1 u)
```

Fully explicit type:

```lean
(α : Sort u) → Sort (max 1 u)
```

Definition body (one-level semantic boundary):

```lean
fun α => (a b : α) → Decidable (Eq a b)
```

### D120: `Eq`

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

### D121: `Exists`

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

### D122: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Type:

```lean
Nat → Type
```

Fully explicit type:

```lean
(n : Nat) → Type
```

### D123: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Type:

```lean
Type u_4 → Type u_4
```

Fully explicit type:

```lean
(α : Type u_4) → Type u_4
```

### D124: `Fintype.card`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Card`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d671060b6c3404522971da5a02da4d36f016d436f12fae1266ef0720d68247cd`

Type:

```lean
(α : Type u_4) → [Fintype α] → Nat
```

Fully explicit type:

```lean
(α : Type u_4) → [Fintype.{u_4} α] → Nat
```

Definition body (one-level semantic boundary):

```lean
fun α [Fintype α] => Finset.univ.card
```

### D125: `Int`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `257bf50f640447b541733c8fd9c6bcca584fc9dd85c221eb4f37888655c88e08`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D126: `LT.lt`

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

### D127: `MeasurableSpace`

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

### D128: `Nat`

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

### D129: `OfNat.ofNat`

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

### D130: `Real`

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

### D131: `instLTNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `4054f2341fdda887b2040c624c0867866ab56eabf3441d6ffc9451c94ae1663c`

Type:

```lean
LT Nat
```

Fully explicit type:

```lean
LT.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
{ lt := Nat.lt }
```

### D132: `instOfNatNat`

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

### D133: `LE.le`

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

### D134: `MeasurableSpace.pi`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Constructions`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `5abd6255cb5a248caaba9dbb79fda4690e04ec72945aca88c3e0fba53f12972b`

Type:

```lean
{δ : Type u_4} → {X : δ → Type u_6} → [m : (a : δ) → MeasurableSpace (X a)] → MeasurableSpace ((a : δ) → X a)
```

Fully explicit type:

```lean
{δ : Type u_4} →
  {X : δ → Type u_6} → [m : (a : δ) → MeasurableSpace.{u_6} (X a)] → MeasurableSpace.{max u_4 u_6} ((a : δ) → X a)
```

Definition body (one-level semantic boundary):

```lean
fun {δ} {X} [m : (a : δ) → MeasurableSpace (X a)] => iSup fun a => MeasurableSpace.comap (fun b => b a) (m a)
```

### D135: `Pi.topologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `a81381c20af462683322c70d792fc61454007e60d0781bb4fda6103a009c8abd`

Type:

```lean
{ι : Type u_5} → {Y : ι → Type v} → [t₂ : (i : ι) → TopologicalSpace (Y i)] → TopologicalSpace ((i : ι) → Y i)
```

Fully explicit type:

```lean
{ι : Type u_5} →
  {Y : ι → Type v} → [t₂ : (i : ι) → TopologicalSpace.{v} (Y i)] → TopologicalSpace.{max u_5 v} ((i : ι) → Y i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {Y} [t₂ : (i : ι) → TopologicalSpace (Y i)] => iInf fun i => TopologicalSpace.induced (fun f => f i) (t₂ i)
```

### D136: `PseudoMetricSpace.toUniformSpace`

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

### D137: `Real.instLE`

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

### D138: `Real.instLT`

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

### D139: `Real.instZero`

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

### D140: `Real.measurableSpace`

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

### D141: `Real.pseudoMetricSpace`

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

### D142: `UniformSpace.toTopologicalSpace`

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

### D143: `Zero.toOfNat0`

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

### D144: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D145: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D146: `Bornology.IsBounded`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Bornology.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `e31816f5dd1670de7a855c46196c59407073cac9717c17a6e0b9856ca702fc81`

Type:

```lean
{α : Type u_2} → [Bornology α] → Set α → Prop
```

Fully explicit type:

```lean
{α : Type u_2} → [Bornology.{u_2} α] → (s : Set.{u_2} α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Bornology α] s => Bornology.IsCobounded (Set.instCompl.compl s)
```

### D147: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D148: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `9db5c150b3c86d10b50e19602d0c0af9e5012dfe5f13b0d7b57925729f2478f0`

Type:

```lean
{F : Sort u_1} → {α : outParam (Sort u_2)} → {β : outParam (α → Sort u_3)} → [self : DFunLike F α β] → F → (a : α) → β a
```

Fully explicit type:

```lean
{F : Sort u_1} →
  {α : outParam.{u_2 + 1} (Sort u_2)} →
    {β : outParam.{max u_2 (u_3 + 1)} (α → Sort u_3)} → [self : DFunLike.{u_1, u_2, u_3} F α β] → F → (a : α) → β a
```

Definition body (one-level semantic boundary):

```lean
fun F {α} {β} [self : DFunLike F α β] => self.1
```

### D149: `DivInvMonoid.toDiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D150: `ENNReal`

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

### D151: `Filter.Tendsto`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D152: `Filter.atTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.AtTopBot.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D153: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Type:

```lean
(n : Nat) → Fintype (Fin n)
```

Fully explicit type:

```lean
(n : Nat) → Fintype.{0} (Fin n)
```

Definition body (one-level semantic boundary):

```lean
fun n => { elems := { val := Multiset.ofList (List.finRange n), nodup := ⋯ }, complete := ⋯ }
```

### D154: `Finset.sum`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.BigOperators.Group.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `931ceac4e9efb5833f58970d10ced4621362e020ea1119492a8d379b7e692372`

Type:

```lean
{ι : Type u_1} → {M : Type u_3} → [AddCommMonoid M] → Finset ι → (ι → M) → M
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : Type u_3} → [AddCommMonoid.{u_3} M] → (s : Finset.{u_1} ι) → (f : ι → M) → M
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [AddCommMonoid M] s f => (Multiset.map f s.val).sum
```

### D155: `Finset.univ`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `194413a784fbc0b27d0cb6b1ab67ed060210172bf16ba24045aa439e58f9a8c7`

Type:

```lean
{α : Type u_1} → [Fintype α] → Finset α
```

Fully explicit type:

```lean
{α : Type u_1} → [Fintype.{u_1} α] → Finset.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Fintype α] => inst.elems
```

### D156: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `9e0cc1e812ed29ffd61aa88cc157fd57b24a4728a006314eec34a80ac32a5f63`

Type:

```lean
{ι : Type u_1} → {M : Type u_2} → {α : Type u_7} → [SMul M α] → SMul M (ι → α)
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : Type u_2} → {α : Type u_7} → [SMul.{u_2, u_7} M α] → SMul.{u_2, max u_1 u_7} M (ι → α)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} {α} [SMul M α] => Pi.instSMul
```

### D157: `HAdd.hAdd`

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

### D158: `HDiv.hDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D159: `HMul.hMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D160: `HPow.hPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D161: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D162: `HSub.hSub`

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

### D163: `HasSubset.Subset`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `7c9560733523c0ce0c86bc53889a57a7fea2b2cc4c4a116fba2021bed1745efa`

Type:

```lean
{α : Type u} → [self : HasSubset α] → α → α → Prop
```

Fully explicit type:

```lean
{α : Type u} → [self : HasSubset.{u} α] → α → α → Prop
```

Definition body (one-level semantic boundary):

```lean
fun α [self : HasSubset α] => self.1
```

### D164: `InnerProductSpace.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D165: `List.map`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `509306b13208ac7c4830c43f93dc873d045ae0ae6b1984beea3ee3ecf89cb205`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → (α → β) → List α → List β
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → (f : α → β) → (l : List.{u_1} α) → List.{u_2} β
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f x =>
  List.brecOn x fun x f_1 =>
    instDecidableEqList.match_1 (fun x => List.below x → List β) x (fun _ x => List.nil)
      (fun a as x => List.cons (f a) x.1) f_1
```

### D166: `List.range`

- Role: `external-frontier`
- Owner module: `Init.Data.List.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `18d1b115003fcdf01cbb5adfb076945d24a2a8edcbc8804f6e5f9f4f4b7a6375`

Type:

```lean
Nat → List Nat
```

Fully explicit type:

```lean
(n : Nat) → List.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
fun n => List.range.loop n List.nil
```

### D167: `Max.max`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `6fa198061d1b8595a7b8b0ed74bd9e48f2c7a18aa01bf39d9c30be49c1d4741c`

Type:

```lean
{α : Type u} → [self : Max α] → α → α → α
```

Fully explicit type:

```lean
{α : Type u} → [self : Max.{u} α] → α → α → α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Max α] => self.1
```

### D168: `MeasurableSet`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.MeasurableSpace.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `2e9235174f4747f2e37b86692acc96182e23810c202fe6e159a326c4a72cf4ff`

Type:

```lean
{α : Type u_1} → [MeasurableSpace α] → Set α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → [MeasurableSpace.{u_1} α] → (s : Set.{u_1} α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : MeasurableSpace α] s => inst.MeasurableSet' s
```

### D169: `MeasureTheory.Measure`

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

### D170: `MeasureTheory.Measure.instFunLike`

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

### D171: `MeasureTheory.MeasureSpace.pi`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Constructions.Pi`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `b44ca2107139ebd9cd90a857fbd25dbe0be4e82716a918fd216df60edd75bf62`

Type:

```lean
{ι : Type u_1} →
  [Fintype ι] →
    {α : ι → Type u_4} → [(i : ι) → MeasureTheory.MeasureSpace (α i)] → MeasureTheory.MeasureSpace ((i : ι) → α i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  [Fintype.{u_1} ι] →
    {α : ι → Type u_4} →
      [(i : ι) → MeasureTheory.MeasureSpace.{u_4} (α i)] → MeasureTheory.MeasureSpace.{max u_1 u_4} ((i : ι) → α i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] {α} [inst_1 : (i : ι) → MeasureTheory.MeasureSpace (α i)] =>
  { toMeasurableSpace := MeasurableSpace.pi, volume := MeasureTheory.Measure.pi fun x => (inst_1 x).volume }
```

### D172: `MeasureTheory.MeasureSpace.toMeasurableSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `9fcb81af41d67aceded7670716064bc53819a6094bbccd3cb85d7a18952295d3`

Type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace α] → MeasurableSpace α
```

Fully explicit type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace.{u_6} α] → MeasurableSpace.{u_6} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : MeasureTheory.MeasureSpace α] => self.1
```

### D173: `MeasureTheory.MeasureSpace.volume`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `8aa44f6be6ed612f15d809220aa22d43c0715b7383456cd968b96336c71bcb65`

Type:

```lean
{α : Type u_6} → [self : MeasureTheory.MeasureSpace α] → MeasureTheory.Measure α
```

Fully explicit type:

```lean
{α : Type u_6} →
  [self : MeasureTheory.MeasureSpace.{u_6} α] →
    @MeasureTheory.Measure.{u_6} α (@MeasureTheory.MeasureSpace.toMeasurableSpace.{u_6} α self)
```

Definition body (one-level semantic boundary):

```lean
fun α [self : MeasureTheory.MeasureSpace α] => self.2
```

### D174: `Membership.mem`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D175: `Nat.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5ea89e9915200c8782bc933f9184e28eb38f4c9610b00cf1310cc6e6435642d8`

Type:

```lean
Preorder Nat
```

Fully explicit type:

```lean
Preorder.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D176: `Ne`

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

### D177: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

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

### D178: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

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

### D179: `Nonempty`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `37c79de378d44cb9dc334502b161bb140da0544579086aded2cf83ff99c462c7`

Type:

```lean
Sort u → Prop
```

Fully explicit type:

```lean
(α : Sort u) → Prop
```

### D180: `Norm.norm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D181: `NormedCommRing.toNormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ff5852fa6ac00f6a258a1d8fe950a0ed74f219c79c926896eb081436331a480e`

Type:

```lean
{α : Type u_5} → [self : NormedCommRing α] → NormedRing α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NormedCommRing.{u_5} α] → NormedRing.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedCommRing α] => self.1
```

### D182: `NormedCommRing.toSeminormedCommRing`

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

### D183: `NormedRing.toNorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `0957abfc66401a60ac36872f31eb54890d14b0b45613e38ba8f235c467f63751`

Type:

```lean
{α : Type u_5} → [self : NormedRing α] → Norm α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NormedRing.{u_5} α] → Norm.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedRing α] => self.1
```

### D184: `One.toOfNat1`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D185: `Option`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `f8032ff16991de9a44b60e677d281af2d3581ac7df43657647bc43faa3161b32`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

### D186: `Option.none`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `fc62ffaad8d042f4eec99bba251ffd4d2254863bc9071098e1e1ae18d8cb0694`

Type:

```lean
{α : Type u} → Option α
```

Fully explicit type:

```lean
{α : Type u} → Option.{u} α
```

### D187: `Pi.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D188: `Pi.instBornology`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Bornology.Constructions`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `1a0eacff9f418d1b53aea91589f074a566c2e937a800653d7fcb80b2b1d4db73`

Type:

```lean
{ι : Type u_3} → {X : ι → Type u_4} → [(i : ι) → Bornology (X i)] → Bornology ((i : ι) → X i)
```

Fully explicit type:

```lean
{ι : Type u_3} → {X : ι → Type u_4} → [(i : ι) → Bornology.{u_4} (X i)] → Bornology.{max u_3 u_4} ((i : ι) → X i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {X} [inst : (i : ι) → Bornology (X i)] =>
  { cobounded := Filter.coprodᵢ fun i => (inst i).cobounded (X i), le_cofinite := ⋯ }
```

### D189: `Pi.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `5deaec32b4deac749a5db5453affea1938386e569380df7daeec26aee3cfd7c2`

Type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [(i : ι) → Sub (G i)] → Sub ((i : ι) → G i)
```

Fully explicit type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [(i : ι) → Sub.{u_4} (G i)] → Sub.{max u_1 u_4} ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [(i : ι) → Sub (G i)] => { sub := fun f g i => instHSub.hSub (f i) (g i) }
```

### D190: `Pi.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `6c82ababc565a0a95c28bec085e8f86c2438699bb486e0ae0b52b3836c28e80e`

Type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} → [Fintype ι] → [(i : ι) → NormedAddCommGroup (G i)] → NormedAddCommGroup ((i : ι) → G i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} →
    [Fintype.{u_1} ι] → [(i : ι) → NormedAddCommGroup.{u_4} (G i)] → NormedAddCommGroup.{max u_1 u_4} ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [Fintype ι] [(i : ι) → NormedAddCommGroup (G i)] =>
  let __src := Pi.seminormedAddGroup;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, add_comm := ⋯,
    toPseudoMetricSpace := __src.toPseudoMetricSpace, eq_of_dist_eq_zero := ⋯, dist_eq := ⋯ }
```

### D191: `Pi.normedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Lemmas`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `f9dab15f307cbf227004c74c0bb06dec60fd13239b8d79b0751df5ec0ca2a0d9`

Type:

```lean
{ι : Type u_3} → {R : ι → Type u_4} → [Fintype ι] → [(i : ι) → NormedRing (R i)] → NormedRing ((i : ι) → R i)
```

Fully explicit type:

```lean
{ι : Type u_3} →
  {R : ι → Type u_4} → [Fintype.{u_3} ι] → [(i : ι) → NormedRing.{u_4} (R i)] → NormedRing.{max u_3 u_4} ((i : ι) → R i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {R} [Fintype ι] [(i : ι) → NormedRing (R i)] =>
  let __src := Pi.seminormedRing;
  have __src_1 := Pi.normedAddCommGroup;
  { toNorm := __src.toNorm, toRing := __src.toRing, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    eq_of_dist_eq_zero := ⋯, dist_eq := ⋯, norm_mul_le := ⋯ }
```

### D192: `Pi.normedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `d355935213de78232f83237164c0ae5a33cf298df9f793729cab1e7594836114`

Type:

```lean
{𝕜 : Type u_1} →
  [inst : NormedField 𝕜] →
    {ι : Type u_6} →
      {E : ι → Type u_7} →
        [inst_1 : Fintype ι] →
          [inst_2 : (i : ι) → SeminormedAddCommGroup (E i)] →
            [(i : ι) → NormedSpace 𝕜 (E i)] → NormedSpace 𝕜 ((i : ι) → E i)
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  [inst : NormedField.{u_1} 𝕜] →
    {ι : Type u_6} →
      {E : ι → Type u_7} →
        [inst_1 : Fintype.{u_6} ι] →
          [inst_2 : (i : ι) → SeminormedAddCommGroup.{u_7} (E i)] →
            [(i : ι) → @NormedSpace.{u_1, u_7} 𝕜 (E i) inst (inst_2 i)] →
              @NormedSpace.{u_1, max u_6 u_7} 𝕜 ((i : ι) → E i) inst
                (@Pi.seminormedAddCommGroup.{u_6, u_7} ι E inst_1 inst_2)
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NormedField 𝕜] {ι} {E} [Fintype ι] [(i : ι) → SeminormedAddCommGroup (E i)] [(i : ι) → NormedSpace 𝕜 (E i)] =>
  { toModule := Pi.module ι E 𝕜, norm_smul_le := ⋯ }
```

### D193: `PseudoMetricSpace.toBornology`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4d821f3f7568b27eacc6dc27fc3e48cc3ed599623be444144b03d23a86ef99bc`

Type:

```lean
{α : Type u} → [self : PseudoMetricSpace α] → Bornology α
```

Fully explicit type:

```lean
{α : Type u} → [self : PseudoMetricSpace.{u} α] → Bornology.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : PseudoMetricSpace α] => self.9
```

### D194: `RCLike.toInnerProductSpaceReal`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.InnerProductSpace.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D195: `Real.instAdd`

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

### D196: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D197: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D198: `Real.instDivInvMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D199: `Real.instMax`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `313f6558836157f8e8b4ea7be18fb6953bf9aefc4dcb68940ef5c4889e18a763`

Type:

```lean
Max Real
```

Fully explicit type:

```lean
Max.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ max := Real.sup✝ }
```

### D200: `Real.instMul`

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

### D201: `Real.instOne`

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

### D202: `Real.instPow`

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

### D203: `Real.instRCLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.RCLike.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D204: `Real.instSub`

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

### D205: `Real.measureSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Haar.OfBasis`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `d9de6598dfa4dc9b2cc1dfbccf206b37d159db61f4b35cc745a68902fbc74b22`

Type:

```lean
MeasureTheory.MeasureSpace Real
```

Fully explicit type:

```lean
MeasureTheory.MeasureSpace.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D206: `Real.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Real`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D207: `Real.normedCommRing`

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

### D208: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D209: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

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

### D210: `Set`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D211: `Set.Nonempty`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4d0a3924740c10191cfb6c1c08284658302adfba25570735173b8897f9e6aabe`

Type:

```lean
{α : Type u} → Set α → Prop
```

Fully explicit type:

```lean
{α : Type u} → (s : Set.{u} α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} s => Exists fun x => Set.instMembership.mem s x
```

### D212: `Set.instHasSubset`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `11142942c466ba33b3ececb8fe039ee973b13ca9402508e46589944dfc90173a`

Type:

```lean
{α : Type u} → HasSubset (Set α)
```

Fully explicit type:

```lean
{α : Type u} → HasSubset.{u} (Set.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { Subset := fun x1 x2 => Set.instLE.le x1 x2 }
```

### D213: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D214: `Top.top`

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

### D215: `TopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Basic`
- Declaration kind: `inductive`
- Distance from target type: `3`
- Semantic SHA-256: `c85328c9b77ed49bcba2dd67e9f87b53aaf251834d29c69856ef079a9ec4b57b`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(X : Type u) → Type u
```

### D216: `instAddNat`

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

### D217: `instHAdd`

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

### D218: `instHDiv`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D219: `instHMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D220: `instHPow`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D221: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D222: `instHSub`

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

### D223: `instLENat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `002e628e28a06e89ab80e69408fa3be9fc3e200fafd33e0f71d9111a8944875e`

Type:

```lean
LE Nat
```

Fully explicit type:

```lean
LE.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
{ le := Nat.le }
```

### D224: `instTopENNReal`

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

### D225: `instZeroENNReal`

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

### D226: `interior`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `47b532ccc7af0b2ad1a2b0b0b8627f0cba4a866392c774b97ced7b3216d8edc4`

Type:

```lean
{X : Type u} → [TopologicalSpace X] → Set X → Set X
```

Fully explicit type:

```lean
{X : Type u} → [TopologicalSpace.{u} X] → (s : Set.{u} X) → Set.{u} X
```

Definition body (one-level semantic boundary):

```lean
fun {X} [TopologicalSpace X] s => (setOf fun t => And (IsOpen t) (Set.instHasSubset.Subset t s)).sUnion
```

### D227: `intervalIntegral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `e2e08df1f4ea189c5c8b18b5894e96ab72c9a6e408e68c9dbbb6462e003414b2`

Type:

```lean
{E : Type u_5} →
  [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → MeasureTheory.Measure Real → E
```

Fully explicit type:

```lean
{E : Type u_5} →
  [inst : NormedAddCommGroup.{u_5} E] →
    [@NormedSpace.{0, u_5} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_5} E inst)] →
      (f : Real → E) → (a b : Real) → (μ : @MeasureTheory.Measure.{0} Real Real.measurableSpace) → E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] f a b μ =>
  instHSub.hSub (MeasureTheory.integral (μ.restrict (Set.Ioc a b)) fun x => f x)
    (MeasureTheory.integral (μ.restrict (Set.Ioc b a)) fun x => f x)
```

### D228: `nhds`

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

### D229: `pseudoMetricSpacePi`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Pi`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `3cbbcd26cab02f70a67e4d5064ccc29eb09b7778910a9117ff7beba37c8c3584`

Type:

```lean
{β : Type u_2} →
  {X : β → Type u_3} → [Fintype β] → [(b : β) → PseudoMetricSpace (X b)] → PseudoMetricSpace ((b : β) → X b)
```

Fully explicit type:

```lean
{β : Type u_2} →
  {X : β → Type u_3} →
    [Fintype.{u_2} β] → [(b : β) → PseudoMetricSpace.{u_3} (X b)] → PseudoMetricSpace.{max u_2 u_3} ((b : β) → X b)
```

Definition body (one-level semantic boundary):

```lean
fun {β} {X} [Fintype β] [(b : β) → PseudoMetricSpace (X b)] =>
  let i :=
    PseudoEMetricSpace.toPseudoMetricSpaceOfDist
      (fun f g => (Finset.univ.sup fun b => PseudoMetricSpace.toNNDist.nndist (f b) (g b)).toReal) ⋯ ⋯;
  i.replaceBornology ⋯
```

### D230: `AddGroup.toSubNegMonoid`

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

### D231: `AddMonoid.toAddZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D232: `AddZero.toZero`

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

### D233: `AddZeroClass.toAddZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D234: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D235: `DistribMulAction.toDistribSMul`

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

### D236: `DistribSMul.toSMulZeroClass`

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

### D237: `ENNReal.toReal`

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

### D238: `ENat`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENat.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `16349df6eaf312f3e93f26d366e785c80c82626298cced892c553952ae67d08a`

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
WithTop Nat
```

### D239: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `7d58c19063063d627291b91068fa4bf2bf5ff88679897376ac465b9f52e93642`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ENormedAddCommMonoid E] → ESeminormedAddCommMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} →
  {inst : TopologicalSpace.{u_8} E} →
    [self : @ENormedAddCommMonoid.{u_8} E inst] → @ESeminormedAddCommMonoid.{u_8} E inst
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ENormedAddCommMonoid E] => self.1
```

### D240: `ESeminormedAddCommMonoid.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `38db724db757c42f8e8affdaa0b60310db98b78e8ba320c452775788f7191220`

Type:

```lean
{E : Type u_8} → [inst : TopologicalSpace E] → [self : ESeminormedAddCommMonoid E] → AddCommMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} →
  [inst : TopologicalSpace.{u_8} E] → [self : @ESeminormedAddCommMonoid.{u_8} E inst] → AddCommMonoid.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [TopologicalSpace E] self => { toAddMonoid := self.toAddMonoid, add_comm := ⋯ }
```

### D241: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `ad2e3c6c509dab0e1668564037784368e6c01e3dc381545577f451993c8283a4`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ESeminormedAddCommMonoid E] → ESeminormedAddMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} →
  {inst : TopologicalSpace.{u_8} E} →
    [self : @ESeminormedAddCommMonoid.{u_8} E inst] → @ESeminormedAddMonoid.{u_8} E inst
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ESeminormedAddCommMonoid E] => self.1
```

### D242: `ESeminormedAddMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `bf6ea4b699c55bfcdc7d32c89ca4d866413afa4dc5af86c3f4ff641d96cab901`

Type:

```lean
{E : Type u_8} → {inst : TopologicalSpace E} → [self : ESeminormedAddMonoid E] → AddMonoid E
```

Fully explicit type:

```lean
{E : Type u_8} → {inst : TopologicalSpace.{u_8} E} → [self : @ESeminormedAddMonoid.{u_8} E inst] → AddMonoid.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E {inst} [self : ESeminormedAddMonoid E] => self.2
```

### D243: `Finset.erase`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Erase`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `960c1ae47eed3bfc6648bebbab6704a872a71528db7f21683cd55b77654a2701`

Type:

```lean
{α : Type u_1} → [DecidableEq α] → Finset α → α → Finset α
```

Fully explicit type:

```lean
{α : Type u_1} → [DecidableEq.{u_1 + 1} α] → (s : Finset.{u_1} α) → (a : α) → Finset.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [DecidableEq α] s a => { val := s.val.erase a, nodup := ⋯ }
```

### D244: `Finset.prod`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.BigOperators.Group.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `e364cffe1f2457eedceca9fe0617d7a66084963ffb6e6ed760d1f3fe74eee841`

Type:

```lean
{ι : Type u_1} → {M : Type u_3} → [CommMonoid M] → Finset ι → (ι → M) → M
```

Fully explicit type:

```lean
{ι : Type u_1} → {M : Type u_3} → [CommMonoid.{u_3} M] → (s : Finset.{u_1} ι) → (f : ι → M) → M
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M} [CommMonoid M] s f => (Multiset.map f s.val).prod
```

### D245: `Finset.sup'`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Lattice.Fold`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f60aa2669fe61f525e27954772ac7266c71b507a2bf91aaf68fc80f020ef7def`

Type:

```lean
{α : Type u_2} → {β : Type u_3} → [SemilatticeSup α] → (s : Finset β) → s.Nonempty → (β → α) → α
```

Fully explicit type:

```lean
{α : Type u_2} →
  {β : Type u_3} → [SemilatticeSup.{u_2} α] → (s : Finset.{u_3} β) → (H : @Finset.Nonempty.{u_3} β s) → (f : β → α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [SemilatticeSup α] s H f => (s.sup (Function.comp WithBot.some f)).unbot ⋯
```

### D246: `Function.uncurry`

- Role: `external-frontier`
- Owner module: `Init.Data.Function`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `588a8e97090f93380cd47f82f5e1a8f3dfe6781e800ef2678c60dfdc97617dcd`

Type:

```lean
{α : Type u_1} → {β : Type u_2} → {φ : Sort u_3} → (α → β → φ) → Prod α β → φ
```

Fully explicit type:

```lean
{α : Type u_1} → {β : Type u_2} → {φ : Sort u_3} → (α → β → φ) → Prod.{u_1, u_2} α β → φ
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} {φ} f a => f a.fst a.snd
```

### D247: `Int.instAdd`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f3fe827ffb6fc81658773a6ada6451aeb9c1a54d32b216d8dede8eae9142825b`

Type:

```lean
Add Int
```

Fully explicit type:

```lean
Add.{0} Int
```

Definition body (one-level semantic boundary):

```lean
{ add := Int.add }
```

### D248: `IntervalIntegrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `438d3df5ccfcf0ec98ba944c6cd9e02b599992e15f8bcb33aaf6cc91c6e2c352`

Type:

```lean
{ε : Type u_3} →
  [inst : TopologicalSpace ε] → [ENormedAddMonoid ε] → (Real → ε) → MeasureTheory.Measure Real → Real → Real → Prop
```

Fully explicit type:

```lean
{ε : Type u_3} →
  [inst : TopologicalSpace.{u_3} ε] →
    [@ENormedAddMonoid.{u_3} ε inst] →
      (f : Real → ε) → (μ : @MeasureTheory.Measure.{0} Real Real.measurableSpace) → (a b : Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ε} [TopologicalSpace ε] [ENormedAddMonoid ε] f μ a b =>
  And (MeasureTheory.IntegrableOn f (Set.Ioc a b) μ) (MeasureTheory.IntegrableOn f (Set.Ioc b a) μ)
```

### D249: `Inv.inv`

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

### D250: `List`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `ec06a72bb009eecaedd9dbf6a3349bbea0bbc480e0a21179f4e21b3e219b952d`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

### D251: `List.foldl`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `528cbed637e4ef546b621011d5cf13a5a950202dac919ee6cff2046010954d44`

Type:

```lean
{α : Type u} → {β : Type v} → (α → β → α) → α → List β → α
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (f : α → β → α) → (init : α) → List.{v} β → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} f x x_1 =>
  List.brecOn (motive := fun x => α → α) x_1
    (fun x f_1 x_2 =>
      List.foldl.match_1 (fun x x_3 => List.below (motive := fun x => α → α) x_3 → α) x_2 x (fun a x => a)
        (fun a b l x => x.1 (f a b)) f_1)
    x
```

### D252: `MeasureTheory.Integrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Function.L1Space.Integrable`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D253: `MeasureTheory.IntegrableOn`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntegrableOn`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `dabc1688ef0e599a1f54ac0aa2c596e2bf70ce60ba22c33b537a76452e7cb6ed`

Type:

```lean
{α : Type u_1} →
  {ε : Type u_3} →
    {mα : MeasurableSpace α} →
      [inst : TopologicalSpace ε] →
        [ContinuousENorm ε] →
          (α → ε) → Set α → autoParam (MeasureTheory.Measure α) MeasureTheory.IntegrableOn._auto_1 → Prop
```

Fully explicit type:

```lean
{α : Type u_1} →
  {ε : Type u_3} →
    {mα : MeasurableSpace.{u_1} α} →
      [inst : TopologicalSpace.{u_3} ε] →
        [@ContinuousENorm.{u_3} ε inst] →
          (f : α → ε) →
            (s : Set.{u_1} α) →
              (μ : autoParam.{u_1 + 1} (@MeasureTheory.Measure.{u_1} α mα) MeasureTheory.IntegrableOn._auto_1) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} {ε} {mα} [TopologicalSpace ε] [ContinuousENorm ε] f s μ => MeasureTheory.Integrable f (μ.restrict s)
```

### D254: `MeasureTheory.Measure.restrict`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Restrict`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `63c4446a3ae02833cbb1104dcc4f2ea534c0eae36f5642bfa8858a6593aa11e8`

Type:

```lean
{α : Type u_2} → {_m0 : MeasurableSpace α} → MeasureTheory.Measure α → Set α → MeasureTheory.Measure α
```

Fully explicit type:

```lean
{α : Type u_2} →
  {_m0 : MeasurableSpace.{u_2} α} →
    (μ : @MeasureTheory.Measure.{u_2} α _m0) → (s : Set.{u_2} α) → @MeasureTheory.Measure.{u_2} α _m0
```

Definition body (one-level semantic boundary):

```lean
fun {α} {_m0} μ s => LinearMap.instFunLike.coe (MeasureTheory.Measure.restrictₗ s) μ
```

### D255: `MeasureTheory.integral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D256: `Metric.diam`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Bounded`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `872d589939ac5686f7355ddcda30256f5416fd2b7191f3da87e9d88bfc81404e`

Type:

```lean
{α : Type u} → [PseudoMetricSpace α] → Set α → Real
```

Fully explicit type:

```lean
{α : Type u} → [PseudoMetricSpace.{u} α] → (s : Set.{u} α) → Real
```

Definition body (one-level semantic boundary):

```lean
fun {α} [PseudoMetricSpace α] s => (Metric.ediam s).toReal
```

### D257: `Module.toDistribMulAction`

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

### D258: `Nat.below`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `04a84157ffe59e0d301c0043561b314a7ab23e9ec7be060ff84461bda2e48a65`

Type:

```lean
{motive : Nat → Sort u} → Nat → Sort (max 1 u)
```

Fully explicit type:

```lean
{motive : (t : Nat) → Sort u} → (t : Nat) → Sort (max 1 u)
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t => Nat.rec PUnit (fun n n_ih => PProd (motive n) n_ih) t
```

### D259: `Nat.brecOn`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `112a5e33ebc43ed10219858c8cc3892005a54c63ed7cb7590213f5a7791f9c14`

Type:

```lean
{motive : Nat → Sort u} → (t : Nat) → ((t : Nat) → Nat.below t → motive t) → motive t
```

Fully explicit type:

```lean
{motive : (t : Nat) → Sort u} → (t : Nat) → (F_1 : (t : Nat) → (f : @Nat.below.{u} motive t) → motive t) → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t F_1 => (Nat.brecOn.go t F_1).1
```

### D260: `Nat.succ`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `4`
- Semantic SHA-256: `c069f332a974e3dbf1dc48acb0a49ab7d732c776b5cccdbe836db99ce812bdb2`

Type:

```lean
Nat → Nat
```

Fully explicit type:

```lean
(n : Nat) → Nat
```

### D261: `NonUnitalNonAssocSemiring.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `fc6b0a41257a855dbb5b09cfe7e3150884caf2b0f898b30e688420784d3b6e76`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring α] → AddCommMonoid α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring.{u} α] → AddCommMonoid.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalNonAssocSemiring α] => self.1
```

### D262: `NonUnitalSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `240f532586ad43548ebc46dcbda3efacdb04f947093d623a575ee7a0a49b9e32`

Type:

```lean
{α : Type u} → [self : NonUnitalSemiring α] → NonUnitalNonAssocSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalSemiring.{u} α] → NonUnitalNonAssocSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NonUnitalSemiring α] => self.1
```

### D263: `NontriviallyNormedField.toNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D264: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

Fully explicit type:

```lean
(E : Type u_8) → Type u_8
```

### D265: `NormedAddCommGroup.toENormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `eac639a9ae15f19554f668c9811538a135f4f05df04330bd8145b300efe57cfb`

Type:

```lean
{E : Type u_4} → [inst : NormedAddCommGroup E] → ENormedAddCommMonoid E
```

Fully explicit type:

```lean
{E : Type u_4} →
  [inst : NormedAddCommGroup.{u_4} E] →
    @ENormedAddCommMonoid.{u_4} E
      (@UniformSpace.toTopologicalSpace.{u_4} E
        (@PseudoMetricSpace.toUniformSpace.{u_4} E
          (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_4} E
            (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_4} E inst))))
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  let __spread.0 := NormedAddGroup.toENormedAddMonoid;
  have __spread.1 := inst;
  { toESeminormedAddMonoid := __spread.0.toESeminormedAddMonoid, add_comm := ⋯, enorm_eq_zero := ⋯ }
```

### D266: `NormedAddCommGroup.toNormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `cdc7999c66248f7b0f68477de30ff4d9ea7a7f0df0bc6f092bc024f699d646fe`

Type:

```lean
{E : Type u_5} → [NormedAddCommGroup E] → NormedAddGroup E
```

Fully explicit type:

```lean
{E : Type u_5} → [NormedAddCommGroup.{u_5} E] → NormedAddGroup.{u_5} E
```

Definition body (one-level semantic boundary):

```lean
fun {E} [inst : NormedAddCommGroup E] =>
  have __src := inst;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toMetricSpace := __src.toMetricSpace, dist_eq := ⋯ }
```

### D267: `NormedAddCommGroup.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D268: `NormedAddGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `06ba17aab699c28aaa8877d0b107536ebd2aefd8bf59143b2357c84bb820d89e`

Type:

```lean
{E : Type u_8} → [self : NormedAddGroup E] → AddGroup E
```

Fully explicit type:

```lean
{E : Type u_8} → [self : NormedAddGroup.{u_8} E] → AddGroup.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : NormedAddGroup E] => self.2
```

### D269: `NormedAddGroup.toENormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `c2e4373a88aee873807ebe0c84a9ad97e86c59f70ff5cf5af4d6497b3024e91a`

Type:

```lean
{F : Type u_7} → [inst : NormedAddGroup F] → ENormedAddMonoid F
```

Fully explicit type:

```lean
{F : Type u_7} →
  [inst : NormedAddGroup.{u_7} F] →
    @ENormedAddMonoid.{u_7} F
      (@UniformSpace.toTopologicalSpace.{u_7} F
        (@PseudoMetricSpace.toUniformSpace.{u_7} F
          (@SeminormedAddGroup.toPseudoMetricSpace.{u_7} F (@NormedAddGroup.toSeminormedAddGroup.{u_7} F inst))))
```

Definition body (one-level semantic boundary):

```lean
fun {F} [inst : NormedAddGroup F] =>
  { toContinuousENorm := SeminormedAddGroup.toContinuousENorm, toAddMonoid := inst.toAddMonoid, enorm_zero := ⋯,
    enorm_add_le := ⋯, enorm_eq_zero := ⋯ }
```

### D270: `NormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `6b6b5b2582dac5d94b5d2a99eac51e4b8bee1f8e652cdec27b52f9c5d5ca5960`

Type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField 𝕜] → [SeminormedAddCommGroup E] → Type (max u_6 u_7)
```

Fully explicit type:

```lean
(𝕜 : Type u_6) → (E : Type u_7) → [NormedField.{u_6} 𝕜] → [SeminormedAddCommGroup.{u_7} E] → Type (max u_6 u_7)
```

### D271: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D272: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D273: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D274: `Pi.normedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `e1d8c48f10ab6dcecabe68ad092908fcd0f83c41f7ec434a1553f79491f53fdb`

Type:

```lean
{ι : Type u_1} → {G : ι → Type u_4} → [Fintype ι] → [(i : ι) → NormedAddGroup (G i)] → NormedAddGroup ((i : ι) → G i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} →
    [Fintype.{u_1} ι] → [(i : ι) → NormedAddGroup.{u_4} (G i)] → NormedAddGroup.{max u_1 u_4} ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [Fintype ι] [(i : ι) → NormedAddGroup (G i)] =>
  let __src := Pi.seminormedAddGroup;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, toPseudoMetricSpace := __src.toPseudoMetricSpace,
    eq_of_dist_eq_zero := ⋯, dist_eq := ⋯ }
```

### D275: `Pi.seminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `44ef291083756b8ed4dcdb745f9c537989525c10e19d60aed1bd242ba80c3113`

Type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} → [Fintype ι] → [(i : ι) → SeminormedAddGroup (G i)] → SeminormedAddGroup ((i : ι) → G i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {G : ι → Type u_4} →
    [Fintype.{u_1} ι] → [(i : ι) → SeminormedAddGroup.{u_4} (G i)] → SeminormedAddGroup.{max u_1 u_4} ((i : ι) → G i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {G} [Fintype ι] [(i : ι) → SeminormedAddGroup (G i)] =>
  { norm := fun f => (Finset.univ.sup fun b => SeminormedAddGroup.toNNNorm.nnnorm (f b)).toReal,
    toAddGroup := Pi.addGroup, toPseudoMetricSpace := pseudoMetricSpacePi, dist_eq := ⋯ }
```

### D276: `Prod`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `3df3b0cff45fb04022db70edff8e5747def6cae602cd8c33e673abac1bb4e347`

Type:

```lean
Type u → Type v → Type (max u v)
```

Fully explicit type:

```lean
(α : Type u) → (β : Type v) → Type (max u v)
```

### D277: `Prod.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `27e0d8aa96ebce1ea21b6abcaf95b2c6b98b7dfe173d5ad327db0cc367a5cb55`

Type:

```lean
{E : Type u_2} → {F : Type u_3} → [NormedAddCommGroup E] → [NormedAddCommGroup F] → NormedAddCommGroup (Prod E F)
```

Fully explicit type:

```lean
{E : Type u_2} →
  {F : Type u_3} →
    [NormedAddCommGroup.{u_2} E] → [NormedAddCommGroup.{u_3} F] → NormedAddCommGroup.{max u_3 u_2} (Prod.{u_2, u_3} E F)
```

Definition body (one-level semantic boundary):

```lean
fun {E} {F} [NormedAddCommGroup E] [NormedAddCommGroup F] =>
  let __src := Prod.seminormedAddGroup;
  { toNorm := __src.toNorm, toAddGroup := __src.toAddGroup, add_comm := ⋯,
    toPseudoMetricSpace := __src.toPseudoMetricSpace, eq_of_dist_eq_zero := ⋯, dist_eq := ⋯ }
```

### D278: `Prod.normedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `3cbe8225107eb42f7977e2aa7f0dce7094ba4bf6550143c5c6f82e0753202f50`

Type:

```lean
{𝕜 : Type u_1} →
  {E : Type u_3} →
    {F : Type u_4} →
      [inst : NormedField 𝕜] →
        [inst_1 : SeminormedAddCommGroup E] →
          [inst_2 : SeminormedAddCommGroup F] → [NormedSpace 𝕜 E] → [NormedSpace 𝕜 F] → NormedSpace 𝕜 (Prod E F)
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  {E : Type u_3} →
    {F : Type u_4} →
      [inst : NormedField.{u_1} 𝕜] →
        [inst_1 : SeminormedAddCommGroup.{u_3} E] →
          [inst_2 : SeminormedAddCommGroup.{u_4} F] →
            [@NormedSpace.{u_1, u_3} 𝕜 E inst inst_1] →
              [@NormedSpace.{u_1, u_4} 𝕜 F inst inst_2] →
                @NormedSpace.{u_1, max u_4 u_3} 𝕜 (Prod.{u_3, u_4} E F) inst
                  (@Prod.seminormedAddCommGroup.{u_3, u_4} E F inst_1 inst_2)
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} {E} {F} [NormedField 𝕜] [SeminormedAddCommGroup E] [SeminormedAddCommGroup F] [NormedSpace 𝕜 E]
    [NormedSpace 𝕜 F] =>
  have __src := Prod.seminormedAddCommGroup;
  let __src := Prod.instModule;
  { toModule := __src, norm_smul_le := ⋯ }
```

### D279: `PseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
- Semantic SHA-256: `ced2596579b646d14f26912490c9bd88960f97f3b07c85d5f31f9d510c44c238`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

### D280: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D281: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D282: `Real.instCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `f537dc5e9be2b886066e25d0f560dc52fd1be771759ec3e7b40a5f5f3e6c6467`

Type:

```lean
CommMonoid Real
```

Fully explicit type:

```lean
CommMonoid.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D283: `Real.instInv`

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

### D284: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D285: `Real.instPreorder`

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

### D286: `Real.instRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D287: `Real.instSemilatticeSup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `b9cb05dd18ecf54b95e91d974c1dc2bfabef3e742078517441d99c93e4ad6426`

Type:

```lean
SemilatticeSup Real
```

Fully explicit type:

```lean
SemilatticeSup.{0} Real
```

Definition body (one-level semantic boundary):

```lean
inferInstance
```

### D288: `Real.lattice`

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

### D289: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D290: `Ring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `167479b8a8bd861d283398cd7ed47b3bc2699266c1cebddbc243ee2ac503a88e`

Type:

```lean
{R : Type u} → [self : Ring R] → Semiring R
```

Fully explicit type:

```lean
{R : Type u} → [self : Ring.{u} R] → Semiring.{u} R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : Ring R] => self.1
```

### D291: `SMulZeroClass.toSMul`

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

### D292: `SProd.sprod`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.SProd`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `5f7389129230ea3e3c1e3bd52b23a5c8506ec2ec85a3e7b594a9337adeccb818`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : SProd α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : SProd.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : SProd α β γ] => self.1
```

### D293: `SeminormedAddCommGroup.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
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

### D294: `SeminormedAddCommGroup.toSeminormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D295: `SeminormedAddGroup.toContinuousENorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D296: `Semiring.toNonUnitalSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `0a8a55914b4c4681e0b76728e731a700196986460aa03a9048377aa35a373323`

Type:

```lean
{α : Type u} → [self : Semiring α] → NonUnitalSemiring α
```

Fully explicit type:

```lean
{α : Type u} → [self : Semiring.{u} α] → NonUnitalSemiring.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : Semiring α] => self.1
```

### D297: `Set.Icc`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `5d4d1d0cca151d5f96eb45776025e642f79e9040e66fffcf889bd1224442ecc8`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Preorder.{u_1} α] → (a b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] a b => setOf fun x => And (inst.le a x) (inst.le x b)
```

### D298: `Set.Ico`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `48aa2cf5736dd57481b68491490245577ea0b7b50fe2429fb88f717769ea5830`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Preorder.{u_1} α] → (a b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] a b => setOf fun x => And (inst.le a x) (inst.lt x b)
```

### D299: `Set.instSProd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Operations`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `7150b196c4ee63f112470ff0614afca7bcfd16b80b4ae6a7361ac8dd84b3e14d`

Type:

```lean
{α : Type u} → {β : Type v} → SProd (Set α) (Set β) (Set (Prod α β))
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → SProd.{u, v, max v u} (Set.{u} α) (Set.{v} β) (Set.{max v u} (Prod.{u, v} α β))
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} => { sprod := Set.prod }
```

### D300: `Set.pi`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Operations`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `6647c8b93a11dd04ffa0bc45a571cdfcb8ddabfa023a6b0e8e8790df7b56186f`

Type:

```lean
{ι : Type u_1} → {α : ι → Type u_2} → Set ι → ((i : ι) → Set (α i)) → Set ((i : ι) → α i)
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {α : ι → Type u_2} → (s : Set.{u_1} ι) → (t : (i : ι) → Set.{u_2} (α i)) → Set.{max u_1 u_2} ((i : ι) → α i)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {α} s t => setOf fun f => ∀ (i : ι), Set.instMembership.mem s i → Set.instMembership.mem (t i) (f i)
```

### D301: `Set.uIcc`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.UnorderedInterval`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `53623b127289993b0a6b152099093b949fab395160dd4c87afcb2f3e4b86821e`

Type:

```lean
{α : Type u_1} → [Lattice α] → α → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Lattice.{u_1} α] → (a b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Lattice α] a b => Set.Icc (SemilatticeInf.toMin.min a b) (SemilatticeSup.toMax.max a b)
```

### D302: `Set.univ`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `4a477fd0b844ae25dae2fe8488226265a7c6b23c8087f3feda3f6197172b13e7`

Type:

```lean
{α : Type u} → Set α
```

Fully explicit type:

```lean
{α : Type u} → Set.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} => setOf fun _a => True
```

### D303: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `f60885ee7a5e97dbc3d343ecb54849b15ae9ca7cc989f350d3b7fee2d2d0724b`

Type:

```lean
{G : Type u} → [self : SubNegMonoid G] → Sub G
```

Fully explicit type:

```lean
{G : Type u} → [self : SubNegMonoid.{u} G] → Sub.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : SubNegMonoid G] => self.3
```

### D304: `Unit`

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

### D305: `WithTop.some`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.TypeTags`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `fab821a6d7e88794a074517c41beafffe80ca57518190a24542770483b8de322`

Type:

```lean
{α : Type u_1} → α → WithTop α
```

Fully explicit type:

```lean
{α : Type u_1} → α → WithTop.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} => Option.some
```

### D306: `closure`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `581a7071ff8fbc236d0005c1e7b3ef84a2ffaaab4eb7812b63823d4654a40942`

Type:

```lean
{X : Type u} → [TopologicalSpace X] → Set X → Set X
```

Fully explicit type:

```lean
{X : Type u} → [TopologicalSpace.{u} X] → (s : Set.{u} X) → Set.{u} X
```

Definition body (one-level semantic boundary):

```lean
fun {X} [TopologicalSpace X] s => (setOf fun t => And (IsClosed t) (Set.instHasSubset.Subset s t)).sInter
```

### D307: `instOfNat`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `d01cf83431e28a96433c57a624e20a771e5e0ddc02355969c5044adf1ba168a5`

Type:

```lean
{n : Nat} → OfNat Int n
```

Fully explicit type:

```lean
{n : Nat} → OfNat.{0} Int n
```

Definition body (one-level semantic boundary):

```lean
fun {n} => { ofNat := Int.ofNat n }
```

### D308: `instTopENat`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENat.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
- Semantic SHA-256: `e498efa7ee5717af6ab85559f6d16b149c1b25de80fac04e495e78222a59ead4`

Type:

```lean
Top ENat
```

Fully explicit type:

```lean
Top.{0} ENat
```

Definition body (one-level semantic boundary):

```lean
WithTop.top
```

### D309: `AEMeasurable`

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

### D310: `AddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `087ff419a44ee7e835bedcf1beda5a1fee5971b4ef4f17124a5a63cd2b0beb30`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(G : Type u) → Type u
```

### D311: `AddCommGroup.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D312: `AddCommGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D313: `Classical.propDecidable`

- Role: `external-frontier`
- Owner module: `Init.Classical`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `823c02cb7dcdb8ce30edfb12a2496dda0849f0773c65f9e91e289fab27c36c46`

Type:

```lean
(a : Prop) → Decidable a
```

Fully explicit type:

```lean
(a : Prop) → Decidable a
```

Definition body (one-level semantic boundary):

```lean
fun a => Classical.choice ⋯
```

### D314: `Filter.Eventually`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `48c8fc03616b0f899835653f1d062e3de4f566255a80b15231ebdedcb0a5c4c4`

Type:

```lean
{α : Type u_1} → (α → Prop) → Filter α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → (p : α → Prop) → (f : Filter.{u_1} α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} p f => Filter.instMembership.mem f (setOf fun x => p x)
```

### D315: `Finset.Nonempty`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Empty`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `878addd64a8203faf13743e77244e6fa37c28def81f79565fbe0cb6267fd20e0`

Type:

```lean
{α : Type u_1} → Finset α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} → (s : Finset.{u_1} α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} s => Exists fun x => SetLike.instMembership.mem s x
```

### D316: `Function.update`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Function.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `092e6c4864b94365603f748d7cf0dd798223b04b127d4c37969b0c09cac29193`

Type:

```lean
{α : Sort u} → {β : α → Sort v} → [DecidableEq α] → ((a : α) → β a) → (a' : α) → β a' → (a : α) → β a
```

Fully explicit type:

```lean
{α : Sort u} → {β : α → Sort v} → [DecidableEq.{u} α] → (f : (a : α) → β a) → (a' : α) → (v : β a') → (a : α) → β a
```

Definition body (one-level semantic boundary):

```lean
fun {α} {β} [DecidableEq α] f a' v a => if h : Eq a a' then Eq.ndrec v ⋯ else f a
```

### D317: `Int.instSub`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `cdec027f4b1a52ca9841248e8efbabc901ed4e9b4220aa4074044d4c9537c68c`

Type:

```lean
Sub Int
```

Fully explicit type:

```lean
Sub.{0} Int
```

Definition body (one-level semantic boundary):

```lean
{ sub := Int.sub }
```

### D318: `MeasureTheory.Measure.instOuterMeasureClass`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `theorem`
- Distance from target type: `5`
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

### D319: `MeasureTheory.Measure.map`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Map`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D320: `MeasureTheory.ae`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.OuterMeasure.AE`
- Declaration kind: `def`
- Distance from target type: `5`
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

### D321: `Module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `132ed119db2ae117b4c85e91594e4fcde0e02a8fde0fb2ee5c57a7a9263c219c`

Type:

```lean
(R : Type u) → (M : Type v) → [Semiring R] → [AddCommMonoid M] → Type (max u v)
```

Fully explicit type:

```lean
(R : Type u) → (M : Type v) → [Semiring.{u} R] → [AddCommMonoid.{v} M] → Type (max u v)
```

### D322: `Nat.casesOn`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `ef6de7a898de834052ce3878aa9641c2b9e400122a4e012169c25b12d9da029d`

Type:

```lean
{motive : Nat → Sort u} → (t : Nat) → motive Nat.zero → ((n : Nat) → motive n.succ) → motive t
```

Fully explicit type:

```lean
{motive : (t : Nat) → Sort u} →
  (t : Nat) → (zero : motive Nat.zero) → (succ : (n : Nat) → motive (Nat.succ n)) → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {motive} t zero succ => Nat.rec zero (fun n n_ih => succ n) t
```

### D323: `NontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `75e499c29066ef6bae585f2160a3eee863a6b751a5e2a132e1ba414ed78e0111`

Type:

```lean
Type u_5 → Type u_5
```

Fully explicit type:

```lean
(α : Type u_5) → Type u_5
```

### D324: `NormedAddCommGroup.toNorm`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `702f98e978ba8cf9fe1b4ce130f011682d6d486d71ba0f7d12f36ec9925cd59b`

Type:

```lean
{E : Type u_8} → [self : NormedAddCommGroup E] → Norm E
```

Fully explicit type:

```lean
{E : Type u_8} → [self : NormedAddCommGroup.{u_8} E] → Norm.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : NormedAddCommGroup E] => self.1
```

### D325: `Option.casesOn`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `5`
- Semantic SHA-256: `f5c7fcf26356582d01d4d242e269e57122d269619688ef18143c576ae90dc704`

Type:

```lean
{α : Type u} →
  {motive : Option α → Sort u_1} →
    (t : Option α) → motive Option.none → ((val : α) → motive (Option.some val)) → motive t
```

Fully explicit type:

```lean
{α : Type u} →
  {motive : (t : Option.{u} α) → Sort u_1} →
    (t : Option.{u} α) →
      (none : motive (@Option.none.{u} α)) → (some : (val : α) → motive (@Option.some.{u} α val)) → motive t
```

Definition body (one-level semantic boundary):

```lean
fun {α} {motive} t none some => Option.rec none (fun val => some val) t
```

### D326: `Option.decidableEqNone`

- Role: `external-frontier`
- Owner module: `Init.Data.Option.Basic`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `8468f65f79ffa0d6427dcb04e3f313da39a9fe3bf58e249e1f156cee9daf4e3b`

Type:

```lean
{α : Type u_1} → (o : Option α) → Decidable (Eq o Option.none)
```

Fully explicit type:

```lean
{α : Type u_1} → (o : Option.{u_1} α) → Decidable (@Eq.{u_1 + 1} (Option.{u_1} α) o (@Option.none.{u_1} α))
```

Definition body (one-level semantic boundary):

```lean
fun {α} o =>
  Option.instDecidableEq.match_1 (fun o => Decidable (Eq o Option.none)) o (fun _ => Decidable.isTrue ⋯) fun val =>
    Decidable.isFalse ⋯
```

### D327: `Option.some`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `5`
- Semantic SHA-256: `ad8453c20fc76a257ee5d58ea22396778d3ef25ba2f1aa634b2e7c5bd2d584d9`

Type:

```lean
{α : Type u} → α → Option α
```

Fully explicit type:

```lean
{α : Type u} → (val : α) → Option.{u} α
```

### D328: `SubNegMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `5`
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

### D329: `Subtype`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `5`
- Semantic SHA-256: `3b0bb8433bd0c981dbdb4d6256bf74c50e9883207dae8d309dcb705135cf932c`

Type:

```lean
{α : Sort u} → (α → Prop) → Sort (max 1 u)
```

Fully explicit type:

```lean
{α : Sort u} → (p : α → Prop) → Sort (max 1 u)
```

### D330: `Subtype.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Sets`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `8045b4145e4e6f4c0a3e8bc7388454b389fa1e5daa8d17fa79b03bf4447dde18`

Type:

```lean
{α : Type u_1} → (p : α → Prop) → [DecidablePred p] → [Fintype α] → Fintype (Subtype fun x => p x)
```

Fully explicit type:

```lean
{α : Type u_1} →
  (p : α → Prop) →
    [@DecidablePred.{u_1 + 1} α p] → [Fintype.{u_1} α] → Fintype.{u_1} (@Subtype.{u_1 + 1} α fun (x : α) => p x)
```

Definition body (one-level semantic boundary):

```lean
fun {α} p [DecidablePred p] [Fintype α] => Fintype.subtype (Finset.filter p Finset.univ) ⋯
```

### D331: `Unit.unit`

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

### D332: `WithTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.TypeTags`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `457f8131bb826c2c59be9b2ca994625740814f42ae0f92a7247987f009756f2a`

Type:

```lean
Type u_2 → Type u_2
```

Fully explicit type:

```lean
(α : Type u_2) → Type u_2
```

Definition body (one-level semantic boundary):

```lean
fun α => Option α
```

### D333: `instDecidableNot`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `37aa26a947d5738f12ec544d42841f48b475aa5a77621b11677f5a37fce0c2f9`

Type:

```lean
{p : Prop} → [dp : Decidable p] → Decidable (Not p)
```

Fully explicit type:

```lean
{p : Prop} → [dp : Decidable p] → Decidable (Not p)
```

Definition body (one-level semantic boundary):

```lean
fun {p} [dp : Decidable p] =>
  instDecidableAnd.match_1 (fun dp => Decidable (Not p)) dp (fun hp => Decidable.isFalse ⋯) fun hp =>
    Decidable.isTrue hp
```

### D334: `ite`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `5`
- Semantic SHA-256: `3029bae29d2d16b5aeb879ad3c12a1b3c4e78998083bf1ab4614942fafdece0e`

Type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → α → α → α
```

Fully explicit type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → (t e : α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} c [h : Decidable c] t e => Decidable.casesOn h (fun x => e) fun x => t
```

### D335: `AddCommMonoidWithOne.toAddMonoidWithOne`

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

### D336: `AddMonoidWithOne.toNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `6b956e88ee642e7533983b76ff8087f4537eea04f025165ce1fa45dc80e795a2`

Type:

```lean
{R : Type u_2} → [self : AddMonoidWithOne R] → NatCast R
```

Fully explicit type:

```lean
{R : Type u_2} → [self : AddMonoidWithOne.{u_2} R] → NatCast.{u_2} R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : AddMonoidWithOne R] => self.1
```

### D337: `AnalyticOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Analytic.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `2a48f01310697e466c9116c718d4ae4cb9c566d6a2aac088a99f2afb65170fc2`

Type:

```lean
(𝕜 : Type u_1) →
  {E : Type u_2} →
    {F : Type u_3} →
      [inst : NontriviallyNormedField 𝕜] →
        [inst_1 : NormedAddCommGroup E] →
          [NormedSpace 𝕜 E] → [inst_3 : NormedAddCommGroup F] → [NormedSpace 𝕜 F] → (E → F) → Set E → Prop
```

Fully explicit type:

```lean
(𝕜 : Type u_1) →
  {E : Type u_2} →
    {F : Type u_3} →
      [inst : NontriviallyNormedField.{u_1} 𝕜] →
        [inst_1 : NormedAddCommGroup.{u_2} E] →
          [@NormedSpace.{u_1, u_2} 𝕜 E (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)
                (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_2} E inst_1)] →
            [inst_3 : NormedAddCommGroup.{u_3} F] →
              [@NormedSpace.{u_1, u_3} 𝕜 F (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_3} F inst_3)] →
                (f : E → F) → (s : Set.{u_2} E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 {E} {F} [NontriviallyNormedField 𝕜] [NormedAddCommGroup E] [NormedSpace 𝕜 E] [NormedAddCommGroup F]
    [NormedSpace 𝕜 F] f s =>
  ∀ (x : E), Set.instMembership.mem s x → AnalyticWithinAt 𝕜 f s x
```

### D338: `CompleteAtomicBooleanAlgebra.toCompleteBooleanAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `3a25d65eea18eac65c870b595439bf5f5b25e6d990cea7e3a635eb81bad4a258`

Type:

```lean
{α : Type u} → [self : CompleteAtomicBooleanAlgebra α] → CompleteBooleanAlgebra α
```

Fully explicit type:

```lean
{α : Type u} → [self : CompleteAtomicBooleanAlgebra.{u} α] → CompleteBooleanAlgebra.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : CompleteAtomicBooleanAlgebra α] => self.1
```

### D339: `CompleteBooleanAlgebra.toCompleteDistribLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `5b7b6334d9d65401dbf1e65d1fba2f464f54b88cbfb541ea9f6fe64419b9d357`

Type:

```lean
{α : Type u} → [CompleteBooleanAlgebra α] → CompleteDistribLattice α
```

Fully explicit type:

```lean
{α : Type u} → [CompleteBooleanAlgebra.{u} α] → CompleteDistribLattice.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : CompleteBooleanAlgebra α] =>
  let __spread.0 := inst;
  let __spread.1 := BooleanAlgebra.toBiheytingAlgebra;
  { toCompleteLattice := __spread.0.toCompleteLattice, toHImp := __spread.0.toHImp, le_himp_iff := ⋯,
    toCompl := __spread.0.toCompl, himp_bot := ⋯, toSDiff := __spread.0.toSDiff, sdiff_le_iff := ⋯,
    toHNot := __spread.1.toHNot, top_sdiff := ⋯ }
```

### D340: `CompleteBooleanAlgebra.toCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `ef39a255ef10c0230be1cee558369fc7eb1b981c98d0e640e56097b98344a675`

Type:

```lean
{α : Type u_1} → [self : CompleteBooleanAlgebra α] → CompleteLattice α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : CompleteBooleanAlgebra.{u_1} α] → CompleteLattice.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : CompleteBooleanAlgebra α] => self.1
```

### D341: `CompleteDistribLattice.toFrame`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `9575e3922b928b13137e39541f6916c83a8c3d846f283ef286612bada2e926b1`

Type:

```lean
{α : Type u_1} → [self : CompleteDistribLattice α] → Order.Frame α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : CompleteDistribLattice.{u_1} α] → Order.Frame.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : CompleteDistribLattice α] => self.1
```

### D342: `CompleteLattice.instOmegaCompletePartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.OmegaCompletePartialOrder`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `a588686a2b08b742c60791d874ae481ba89fc2f75533682f87dbe461bb89639e`

Type:

```lean
{α : Type u_2} → [CompleteLattice α] → OmegaCompletePartialOrder α
```

Fully explicit type:

```lean
{α : Type u_2} → [CompleteLattice.{u_2} α] → OmegaCompletePartialOrder.{u_2} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : CompleteLattice α] =>
  { toPartialOrder := inst.toCompleteSemilatticeInf.toPartialOrder,
    ωSup := fun c => iSup fun i => OmegaCompletePartialOrder.Chain.instFunLikeNat.coe c i, le_ωSup := ⋯, ωSup_le := ⋯ }
```

### D343: `CompleteLinearOrder.toCompletelyDistribLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `5b84fa49364336f8f06dc450d333aa3c21bfc04d88f5ca022ab32169b533ec73`

Type:

```lean
{α : Type u} → [CompleteLinearOrder α] → CompletelyDistribLattice α
```

Fully explicit type:

```lean
{α : Type u} → [CompleteLinearOrder.{u} α] → CompletelyDistribLattice.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : CompleteLinearOrder α] =>
  let __spread.0 := inst;
  { toCompleteLattice := __spread.0.toCompleteLattice, toHImp := __spread.0.toHImp, le_himp_iff := ⋯,
    toCompl := __spread.0.toCompl, himp_bot := ⋯, toSDiff := __spread.0.toSDiff, toHNot := __spread.0.toHNot,
    sdiff_le_iff := ⋯, top_sdiff := ⋯, iInf_iSup_eq := ⋯ }
```

### D344: `CompletelyDistribLattice.toCompleteLattice`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `abca77a347ef8f122fccdffab3dcf3eaabd62b1eba44b4765158be0bf1af9b61`

Type:

```lean
{α : Type u} → [self : CompletelyDistribLattice α] → CompleteLattice α
```

Fully explicit type:

```lean
{α : Type u} → [self : CompletelyDistribLattice.{u} α] → CompleteLattice.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : CompletelyDistribLattice α] => self.1
```

### D345: `ContinuousMultilinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.Multilinear.Basic`
- Declaration kind: `inductive`
- Distance from target type: `6`
- Semantic SHA-256: `e52fb20a564a5f5fb3d0f497ebb8ee6c5e352107e958eab8a11d3815dbf6b4f5`

Type:

```lean
(R : Type u) →
  {ι : Type v} →
    (M₁ : ι → Type w₁) →
      (M₂ : Type w₂) →
        [inst : Semiring R] →
          [inst_1 : (i : ι) → AddCommMonoid (M₁ i)] →
            [inst_2 : AddCommMonoid M₂] →
              [(i : ι) → Module R (M₁ i)] →
                [Module R M₂] → [(i : ι) → TopologicalSpace (M₁ i)] → [TopologicalSpace M₂] → Type (max (max v w₁) w₂)
```

Fully explicit type:

```lean
(R : Type u) →
  {ι : Type v} →
    (M₁ : ι → Type w₁) →
      (M₂ : Type w₂) →
        [inst : Semiring.{u} R] →
          [inst_1 : (i : ι) → AddCommMonoid.{w₁} (M₁ i)] →
            [inst_2 : AddCommMonoid.{w₂} M₂] →
              [(i : ι) → @Module.{u, w₁} R (M₁ i) inst (inst_1 i)] →
                [@Module.{u, w₂} R M₂ inst inst_2] →
                  [(i : ι) → TopologicalSpace.{w₁} (M₁ i)] → [TopologicalSpace.{w₂} M₂] → Type (max (max v w₁) w₂)
```

### D346: `ContinuousMultilinearMap.normedAddCommGroup'`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Multilinear.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `60f0157569a6414452c8db29b50e3fc3d4671da8cda3ab3debed5ce3c99ddd46`

Type:

```lean
{𝕜 : Type u} →
  {ι : Type v} →
    {G : Type wG} →
      {G' : Type wG'} →
        [Fintype ι] →
          [inst : NontriviallyNormedField 𝕜] →
            [inst_1 : NormedAddCommGroup G] →
              [inst_2 : NormedSpace 𝕜 G] →
                [inst_3 : SeminormedAddCommGroup G'] →
                  [inst_4 : NormedSpace 𝕜 G'] → NormedAddCommGroup (ContinuousMultilinearMap 𝕜 (fun x => G') G)
```

Fully explicit type:

```lean
{𝕜 : Type u} →
  {ι : Type v} →
    {G : Type wG} →
      {G' : Type wG'} →
        [Fintype.{v} ι] →
          [inst : NontriviallyNormedField.{u} 𝕜] →
            [inst_1 : NormedAddCommGroup.{wG} G] →
              [inst_2 :
                  @NormedSpace.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_1)] →
                [inst_3 : SeminormedAddCommGroup.{wG'} G'] →
                  [inst_4 : @NormedSpace.{u, wG'} 𝕜 G' (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst) inst_3] →
                    NormedAddCommGroup.{max (max wG wG') v}
                      (@ContinuousMultilinearMap.{u, v, wG', wG} 𝕜 ι (fun (x : ι) => G') G
                        (@DivisionSemiring.toSemiring.{u} 𝕜
                          (@Semifield.toDivisionSemiring.{u} 𝕜
                            (@Field.toSemifield.{u} 𝕜
                              (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                        (fun (i : ι) =>
                          @AddCommGroup.toAddCommMonoid.{wG'} G'
                            (@SeminormedAddCommGroup.toAddCommGroup.{wG'} G' inst_3))
                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                          (@UniformSpace.toTopologicalSpace.{wG} G
                            (@PseudoMetricSpace.toUniformSpace.{wG} G
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_1))))
                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                            (@UniformSpace.toTopologicalSpace.{wG} G
                              (@PseudoMetricSpace.toUniformSpace.{wG} G
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_1))))
                            (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_1)))
                        (fun (i : ι) =>
                          @NormedSpace.toModule.{u, wG'} 𝕜 G' (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst) inst_3
                            inst_4)
                        (@NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_1) inst_2)
                        (fun (i : ι) =>
                          @UniformSpace.toTopologicalSpace.{wG'} G'
                            (@PseudoMetricSpace.toUniformSpace.{wG'} G'
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG'} G' inst_3)))
                        (@UniformSpace.toTopologicalSpace.{wG} G
                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_1)))))
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} {ι} {G} {G'} [Fintype ι] [NontriviallyNormedField 𝕜] [NormedAddCommGroup G] [NormedSpace 𝕜 G]
    [SeminormedAddCommGroup G'] [NormedSpace 𝕜 G'] =>
  ContinuousMultilinearMap.normedAddCommGroup
```

### D347: `ContinuousMultilinearMap.normedSpace'`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Multilinear.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `9cf48fb219dbc200c1a9c385aa634b3426e62128e3cfa6465f14d1860ae6fbe5`

Type:

```lean
{𝕜 : Type u} →
  {ι : Type v} →
    {G : Type wG} →
      {G' : Type wG'} →
        [inst : NontriviallyNormedField 𝕜] →
          [inst_1 : SeminormedAddCommGroup G] →
            [inst_2 : NormedSpace 𝕜 G] →
              [inst_3 : SeminormedAddCommGroup G'] →
                [inst_4 : NormedSpace 𝕜 G'] →
                  [inst_5 : Fintype ι] →
                    {𝕜' : Type u_2} →
                      [inst_6 : NormedField 𝕜'] →
                        [inst_7 : NormedSpace 𝕜' G] →
                          [SMulCommClass 𝕜 𝕜' G] → NormedSpace 𝕜' (ContinuousMultilinearMap 𝕜 (fun x => G') G)
```

Fully explicit type:

```lean
{𝕜 : Type u} →
  {ι : Type v} →
    {G : Type wG} →
      {G' : Type wG'} →
        [inst : NontriviallyNormedField.{u} 𝕜] →
          [inst_1 : SeminormedAddCommGroup.{wG} G] →
            [inst_2 : @NormedSpace.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst) inst_1] →
              [inst_3 : SeminormedAddCommGroup.{wG'} G'] →
                [inst_4 : @NormedSpace.{u, wG'} 𝕜 G' (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst) inst_3] →
                  [inst_5 : Fintype.{v} ι] →
                    {𝕜' : Type u_2} →
                      [inst_6 : NormedField.{u_2} 𝕜'] →
                        [inst_7 : @NormedSpace.{u_2, wG} 𝕜' G inst_6 inst_1] →
                          [@SMulCommClass.{u, u_2, wG} 𝕜 𝕜' G
                                (@SMulZeroClass.toSMul.{u, wG} 𝕜 G
                                  (@AddZero.toZero.{wG} G
                                    (@AddZeroClass.toAddZero.{wG} G
                                      (@AddMonoid.toAddZeroClass.{wG} G
                                        (@SubNegMonoid.toAddMonoid.{wG} G
                                          (@AddGroup.toSubNegMonoid.{wG} G
                                            (@SeminormedAddGroup.toAddGroup.{wG} G
                                              (@SeminormedAddCommGroup.toSeminormedAddGroup.{wG} G inst_1)))))))
                                  (@DistribSMul.toSMulZeroClass.{u, wG} 𝕜 G
                                    (@AddMonoid.toAddZeroClass.{wG} G
                                      (@SubNegMonoid.toAddMonoid.{wG} G
                                        (@AddGroup.toSubNegMonoid.{wG} G
                                          (@SeminormedAddGroup.toAddGroup.{wG} G
                                            (@SeminormedAddCommGroup.toSeminormedAddGroup.{wG} G inst_1)))))
                                    (@DistribMulAction.toDistribSMul.{u, wG} 𝕜 G
                                      (@MonoidWithZero.toMonoid.{u} 𝕜
                                        (@Semiring.toMonoidWithZero.{u} 𝕜
                                          (@DivisionSemiring.toSemiring.{u} 𝕜
                                            (@Semifield.toDivisionSemiring.{u} 𝕜
                                              (@Field.toSemifield.{u} 𝕜
                                                (@NormedField.toField.{u} 𝕜
                                                  (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                                      (@SubNegMonoid.toAddMonoid.{wG} G
                                        (@AddGroup.toSubNegMonoid.{wG} G
                                          (@SeminormedAddGroup.toAddGroup.{wG} G
                                            (@SeminormedAddCommGroup.toSeminormedAddGroup.{wG} G inst_1))))
                                      (@Module.toDistribMulAction.{u, wG} 𝕜 G
                                        (@DivisionSemiring.toSemiring.{u} 𝕜
                                          (@Semifield.toDivisionSemiring.{u} 𝕜
                                            (@Field.toSemifield.{u} 𝕜
                                              (@NormedField.toField.{u} 𝕜
                                                (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                                        (@AddCommGroup.toAddCommMonoid.{wG} G
                                          (@SeminormedAddCommGroup.toAddCommGroup.{wG} G inst_1))
                                        (@NormedSpace.toModule.{u, wG} 𝕜 G
                                          (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst) inst_1 inst_2)))))
                                (@SMulZeroClass.toSMul.{u_2, wG} 𝕜' G
                                  (@AddZero.toZero.{wG} G
                                    (@AddZeroClass.toAddZero.{wG} G
                                      (@AddMonoid.toAddZeroClass.{wG} G
                                        (@SubNegMonoid.toAddMonoid.{wG} G
                                          (@AddGroup.toSubNegMonoid.{wG} G
                                            (@SeminormedAddGroup.toAddGroup.{wG} G
                                              (@SeminormedAddCommGroup.toSeminormedAddGroup.{wG} G inst_1)))))))
                                  (@DistribSMul.toSMulZeroClass.{u_2, wG} 𝕜' G
                                    (@AddMonoid.toAddZeroClass.{wG} G
                                      (@SubNegMonoid.toAddMonoid.{wG} G
                                        (@AddGroup.toSubNegMonoid.{wG} G
                                          (@SeminormedAddGroup.toAddGroup.{wG} G
                                            (@SeminormedAddCommGroup.toSeminormedAddGroup.{wG} G inst_1)))))
                                    (@DistribMulAction.toDistribSMul.{u_2, wG} 𝕜' G
                                      (@MonoidWithZero.toMonoid.{u_2} 𝕜'
                                        (@Semiring.toMonoidWithZero.{u_2} 𝕜'
                                          (@DivisionSemiring.toSemiring.{u_2} 𝕜'
                                            (@Semifield.toDivisionSemiring.{u_2} 𝕜'
                                              (@Field.toSemifield.{u_2} 𝕜' (@NormedField.toField.{u_2} 𝕜' inst_6))))))
                                      (@SubNegMonoid.toAddMonoid.{wG} G
                                        (@AddGroup.toSubNegMonoid.{wG} G
                                          (@SeminormedAddGroup.toAddGroup.{wG} G
                                            (@SeminormedAddCommGroup.toSeminormedAddGroup.{wG} G inst_1))))
                                      (@Module.toDistribMulAction.{u_2, wG} 𝕜' G
                                        (@DivisionSemiring.toSemiring.{u_2} 𝕜'
                                          (@Semifield.toDivisionSemiring.{u_2} 𝕜'
                                            (@Field.toSemifield.{u_2} 𝕜' (@NormedField.toField.{u_2} 𝕜' inst_6))))
                                        (@AddCommGroup.toAddCommMonoid.{wG} G
                                          (@SeminormedAddCommGroup.toAddCommGroup.{wG} G inst_1))
                                        (@NormedSpace.toModule.{u_2, wG} 𝕜' G inst_6 inst_1 inst_7)))))] →
                            @NormedSpace.{u_2, max (max wG wG') v} 𝕜'
                              (@ContinuousMultilinearMap.{u, v, wG', wG} 𝕜 ι (fun (x : ι) => G') G
                                (@DivisionSemiring.toSemiring.{u} 𝕜
                                  (@Semifield.toDivisionSemiring.{u} 𝕜
                                    (@Field.toSemifield.{u} 𝕜
                                      (@NormedField.toField.{u} 𝕜
                                        (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                                (fun (i : ι) =>
                                  @AddCommGroup.toAddCommMonoid.{wG'} G'
                                    (@SeminormedAddCommGroup.toAddCommGroup.{wG'} G' inst_3))
                                (@AddCommGroup.toAddCommMonoid.{wG} G
                                  (@SeminormedAddCommGroup.toAddCommGroup.{wG} G inst_1))
                                (fun (i : ι) =>
                                  @NormedSpace.toModule.{u, wG'} 𝕜 G'
                                    (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst) inst_3 inst_4)
                                (@NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                                  inst_1 inst_2)
                                (fun (i : ι) =>
                                  @UniformSpace.toTopologicalSpace.{wG'} G'
                                    (@PseudoMetricSpace.toUniformSpace.{wG'} G'
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG'} G' inst_3)))
                                (@UniformSpace.toTopologicalSpace.{wG} G
                                  (@PseudoMetricSpace.toUniformSpace.{wG} G
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G inst_1))))
                              inst_6
                              (@ContinuousMultilinearMap.seminormedAddCommGroup'.{u, v, wG', wG} 𝕜 ι G' G inst inst_3
                                inst_4 inst_1 inst_2 inst_5)
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} {ι} {G} {G'} [NontriviallyNormedField 𝕜] [SeminormedAddCommGroup G] [NormedSpace 𝕜 G]
    [SeminormedAddCommGroup G'] [NormedSpace 𝕜 G'] [Fintype ι] {𝕜'} [NormedField 𝕜'] [NormedSpace 𝕜' G]
    [SMulCommClass 𝕜 𝕜' G] =>
  ContinuousMultilinearMap.normedSpace
```

### D348: `Disjoint`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Disjoint`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `b3c1a3f72029bdabf392b01ef59e09df14985ee45c8304a6e3013b31345ac3bb`

Type:

```lean
{α : Type u_1} → [inst : PartialOrder α] → [OrderBot α] → α → α → Prop
```

Fully explicit type:

```lean
{α : Type u_1} →
  [inst : PartialOrder.{u_1} α] →
    [@OrderBot.{u_1} α (@Preorder.toLE.{u_1} α (@PartialOrder.toPreorder.{u_1} α inst))] → (a b : α) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : PartialOrder α] [inst_1 : OrderBot α] a b => ∀ ⦃x : α⦄, inst.le x a → inst.le x b → inst.le x inst_1.bot
```

### D349: `DivisionSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
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

### D350: `ENat.instNatCast`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENat.Defs`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `ec1653668e6dc28446634dd47404419b62127b84ac1d4eaec068379e533a74e6`

Type:

```lean
NatCast ENat
```

Fully explicit type:

```lean
NatCast.{0} ENat
```

Definition body (one-level semantic boundary):

```lean
{ natCast := WithTop.some }
```

### D351: `Field.toSemifield`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `def`
- Distance from target type: `6`
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

### D352: `Filter`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `inductive`
- Distance from target type: `6`
- Semantic SHA-256: `f178b01470c6b39d870c442162d6d76a8f2124db69fab7f84fe3f0f559dd4616`

Type:

```lean
Type u_1 → Type u_1
```

Fully explicit type:

```lean
(α : Type u_1) → Type u_1
```

### D353: `Filter.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `8a48a37648ad8e37238fd07c5d291dcae10f43e85c8d08a7df0e60af7a5ece6e`

Type:

```lean
{α : Type u_1} → Membership (Set α) (Filter α)
```

Fully explicit type:

```lean
{α : Type u_1} → Membership.{u_1, u_1} (Set.{u_1} α) (Filter.{u_1} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { mem := fun F U => Set.instMembership.mem F.sets U }
```

### D354: `FormalMultilinearSeries`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.FormalMultilinearSeries`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `76465fac4e1e5686b59e285e6e85a3e1a538e6c06b933d0a67b2eb0148d5739d`

Type:

```lean
(𝕜 : Type u_1) →
  (E : Type u_2) →
    (F : Type u_3) →
      [inst : Semiring 𝕜] →
        [inst_1 : AddCommMonoid E] →
          [inst_2 : Module 𝕜 E] →
            [inst_3 : TopologicalSpace E] →
              [ContinuousAdd E] →
                [ContinuousConstSMul 𝕜 E] →
                  [inst_6 : AddCommMonoid F] →
                    [inst_7 : Module 𝕜 F] →
                      [inst_8 : TopologicalSpace F] →
                        [ContinuousAdd F] → [ContinuousConstSMul 𝕜 F] → Type (max (max u_3 u_2) 0)
```

Fully explicit type:

```lean
(𝕜 : Type u_1) →
  (E : Type u_2) →
    (F : Type u_3) →
      [inst : Semiring.{u_1} 𝕜] →
        [inst_1 : AddCommMonoid.{u_2} E] →
          [inst_2 : @Module.{u_1, u_2} 𝕜 E inst inst_1] →
            [inst_3 : TopologicalSpace.{u_2} E] →
              [@ContinuousAdd.{u_2} E inst_3
                    (@AddCommMagma.toAdd.{u_2} E
                      (@AddCommSemigroup.toAddCommMagma.{u_2} E (@AddCommMonoid.toAddCommSemigroup.{u_2} E inst_1)))] →
                [@ContinuousConstSMul.{u_1, u_2} 𝕜 E inst_3
                      (@SMulZeroClass.toSMul.{u_1, u_2} 𝕜 E
                        (@AddZero.toZero.{u_2} E
                          (@AddZeroClass.toAddZero.{u_2} E
                            (@AddMonoid.toAddZeroClass.{u_2} E (@AddCommMonoid.toAddMonoid.{u_2} E inst_1))))
                        (@DistribSMul.toSMulZeroClass.{u_1, u_2} 𝕜 E
                          (@AddMonoid.toAddZeroClass.{u_2} E (@AddCommMonoid.toAddMonoid.{u_2} E inst_1))
                          (@DistribMulAction.toDistribSMul.{u_1, u_2} 𝕜 E
                            (@MonoidWithZero.toMonoid.{u_1} 𝕜 (@Semiring.toMonoidWithZero.{u_1} 𝕜 inst))
                            (@AddCommMonoid.toAddMonoid.{u_2} E inst_1)
                            (@Module.toDistribMulAction.{u_1, u_2} 𝕜 E inst inst_1 inst_2))))] →
                  [inst_6 : AddCommMonoid.{u_3} F] →
                    [inst_7 : @Module.{u_1, u_3} 𝕜 F inst inst_6] →
                      [inst_8 : TopologicalSpace.{u_3} F] →
                        [@ContinuousAdd.{u_3} F inst_8
                              (@AddCommMagma.toAdd.{u_3} F
                                (@AddCommSemigroup.toAddCommMagma.{u_3} F
                                  (@AddCommMonoid.toAddCommSemigroup.{u_3} F inst_6)))] →
                          [@ContinuousConstSMul.{u_1, u_3} 𝕜 F inst_8
                                (@SMulZeroClass.toSMul.{u_1, u_3} 𝕜 F
                                  (@AddZero.toZero.{u_3} F
                                    (@AddZeroClass.toAddZero.{u_3} F
                                      (@AddMonoid.toAddZeroClass.{u_3} F (@AddCommMonoid.toAddMonoid.{u_3} F inst_6))))
                                  (@DistribSMul.toSMulZeroClass.{u_1, u_3} 𝕜 F
                                    (@AddMonoid.toAddZeroClass.{u_3} F (@AddCommMonoid.toAddMonoid.{u_3} F inst_6))
                                    (@DistribMulAction.toDistribSMul.{u_1, u_3} 𝕜 F
                                      (@MonoidWithZero.toMonoid.{u_1} 𝕜 (@Semiring.toMonoidWithZero.{u_1} 𝕜 inst))
                                      (@AddCommMonoid.toAddMonoid.{u_3} F inst_6)
                                      (@Module.toDistribMulAction.{u_1, u_3} 𝕜 F inst inst_6 inst_7))))] →
                            Type (max (max u_3 u_2) 0)
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 E F [Semiring 𝕜] [AddCommMonoid E] [Module 𝕜 E] [TopologicalSpace E] [ContinuousAdd E] [ContinuousConstSMul 𝕜 E]
    [AddCommMonoid F] [Module 𝕜 F] [TopologicalSpace F] [ContinuousAdd F] [ContinuousConstSMul 𝕜 F] =>
  (n : Nat) → ContinuousMultilinearMap 𝕜 (fun i => E) F
```

### D355: `HeytingAlgebra.toOrderBot`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Heyting.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `2ee82a12c7227f6741bb957fb8033ec6bd4dc5696e0118ba976cd5cc433ce74c`

Type:

```lean
{α : Type u_4} → [self : HeytingAlgebra α] → OrderBot α
```

Fully explicit type:

```lean
{α : Type u_4} →
  [self : HeytingAlgebra.{u_4} α] →
    @OrderBot.{u_4} α
      (@Preorder.toLE.{u_4} α
        (@PartialOrder.toPreorder.{u_4} α
          (@SemilatticeSup.toPartialOrder.{u_4} α
            (@Lattice.toSemilatticeSup.{u_4} α
              (@GeneralizedHeytingAlgebra.toLattice.{u_4} α
                (@HeytingAlgebra.toGeneralizedHeytingAlgebra.{u_4} α self))))))
```

Definition body (one-level semantic boundary):

```lean
fun α [self : HeytingAlgebra α] => self.2
```

### D356: `Iff`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `6`
- Semantic SHA-256: `b9f48489cd9ca513eeae7e3e4fb154f354b93867eda8b67d1630275c4cb4f30b`

Type:

```lean
Prop → Prop → Prop
```

Fully explicit type:

```lean
(a b : Prop) → Prop
```

### D357: `Insert.insert`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `5297fbf3e0254687c57cc18bd1545028774077d7b16a44db69b7608f84215e2c`

Type:

```lean
{α : outParam (Type u)} → {γ : Type v} → [self : Insert α γ] → α → γ → γ
```

Fully explicit type:

```lean
{α : outParam.{u + 2} (Type u)} → {γ : Type v} → [self : Insert.{u, v} α γ] → α → γ → γ
```

Definition body (one-level semantic boundary):

```lean
fun {α} γ [self : Insert α γ] => self.1
```

### D358: `Nat.cast`

- Role: `external-frontier`
- Owner module: `Init.Data.Cast`
- Declaration kind: `def`
- Distance from target type: `6`
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

### D359: `NonAssocSemiring.toAddCommMonoidWithOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `6e4c898b19286580a5053df0525278998daaf3b1687c7526ed8df20324dc7aa0`

Type:

```lean
{α : Type u} → [self : NonAssocSemiring α] → AddCommMonoidWithOne α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonAssocSemiring.{u} α] → AddCommMonoidWithOne.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toNatCast := self.toNatCast, toAddMonoid := self.toAddMonoid, toOne := self.toOne, natCast_zero := ⋯,
    natCast_succ := ⋯, add_comm := ⋯ }
```

### D360: `NormedField.toField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `6`
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

### D361: `Not`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `6`
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

### D362: `OmegaCompletePartialOrder.toPartialOrder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.OmegaCompletePartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `04c999d7f177b80a86d128413a961873b394ba8a928e9f40ec1711b6050fc2de`

Type:

```lean
{α : Type u_6} → [self : OmegaCompletePartialOrder α] → PartialOrder α
```

Fully explicit type:

```lean
{α : Type u_6} → [self : OmegaCompletePartialOrder.{u_6} α] → PartialOrder.{u_6} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : OmegaCompletePartialOrder α] => self.1
```

### D363: `Order.Frame.toHeytingAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.CompleteBooleanAlgebra`
- Declaration kind: `abbrev`
- Distance from target type: `6`
- Semantic SHA-256: `d4cf848cdacfde27a40baabeb09bc470dcfcc4d195ff7dedbad201a5ff6a03ab`

Type:

```lean
{α : Type u_1} → [self : Order.Frame α] → HeytingAlgebra α
```

Fully explicit type:

```lean
{α : Type u_1} → [self : Order.Frame.{u_1} α] → HeytingAlgebra.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toLattice := self.toLattice, toOrderTop := self.toOrderTop, toHImp := self.toHImp, le_himp_iff := ⋯,
    toOrderBot := self.toOrderBot, toCompl := self.toCompl, himp_bot := ⋯ }
```

### D364: `PartialOrder.toPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `6`
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

### D365: `Preorder.toLE`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `6`
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

### D366: `Semifield.toDivisionSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
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

### D367: `Semiring.toNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `6`
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

### D368: `Set.instCompleteAtomicBooleanAlgebra`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.BooleanAlgebra`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `5ebef163c77bbddf9cd7439ed0b00fe337f343e5a1bbb203a126211604f9e398`

Type:

```lean
{α : Type u_1} → CompleteAtomicBooleanAlgebra (Set α)
```

Fully explicit type:

```lean
{α : Type u_1} → CompleteAtomicBooleanAlgebra.{u_1} (Set.{u_1} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} =>
  let __src := Set.instBooleanAlgebra;
  { toLattice := __src.toLattice, toSupSet := Set.instSupSet, le_sSup := ⋯, sSup_le := ⋯, toInfSet := Set.instInfSet,
    sInf_le := ⋯, le_sInf := ⋯, toTop := __src.toTop, le_top := ⋯, toBot := __src.toBot, bot_le := ⋯, le_sup_inf := ⋯,
    toCompl := __src.toCompl, toSDiff := __src.toSDiff, toHImp := __src.toHImp, inf_compl_le_bot := ⋯,
    top_le_sup_compl := ⋯, sdiff_eq := ⋯, himp_eq := ⋯, iInf_iSup_eq := ⋯ }
```

### D369: `Set.instInsert`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `60a51cff52006bf73e74f7327c45555e9424715d378dd9550cf7e5b3b2394485`

Type:

```lean
{α : Type u} → Insert α (Set α)
```

Fully explicit type:

```lean
{α : Type u} → Insert.{u, u} α (Set.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { insert := Set.insert }
```

### D370: `Subtype.mk`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `6`
- Semantic SHA-256: `488ac61b6d3c07fb9a2f54a03a39e6001a4c7cedfd07515f0f9865e7fef9ef51`

Type:

```lean
{α : Sort u} → {p : α → Prop} → (val : α) → p val → Subtype p
```

Fully explicit type:

```lean
{α : Sort u} → {p : α → Prop} → (val : α) → (property : p val) → @Subtype.{u} α p
```

### D371: `Subtype.val`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `6`
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

### D372: `WithTop.addMonoidWithOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Monoid.Unbundled.WithTop`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `22fb9b30034cd29c905c92b4541387b1a135eec24d7797d9ead83e7e83e9a121`

Type:

```lean
{α : Type u} → [AddMonoidWithOne α] → AddMonoidWithOne (WithTop α)
```

Fully explicit type:

```lean
{α : Type u} → [AddMonoidWithOne.{u} α] → AddMonoidWithOne.{u} (WithTop.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} [AddMonoidWithOne α] =>
  let __src := WithTop.one;
  let __src_1 := WithTop.addMonoid;
  { natCast := fun n => WithTop.some n.cast, toAddMonoid := __src_1, toOne := __src, natCast_zero := ⋯,
    natCast_succ := ⋯ }
```

### D373: `WithTop.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.TypeTags`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `7656af4828558ad72ccc643779cf6d88b0845b677b37efa1d18644d0fbbd959f`

Type:

```lean
{α : Type u_1} → Top (WithTop α)
```

Fully explicit type:

```lean
{α : Type u_1} → Top.{u_1} (WithTop.{u_1} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { top := Option.none }
```

### D374: `dite`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `a2551097d29bac847f3c59e8213b5882afd4a95e9247c2382e8bce33011974b5`

Type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → (c → α) → (Not c → α) → α
```

Fully explicit type:

```lean
{α : Sort u} → (c : Prop) → [h : Decidable c] → (t : c → α) → (e : Not c → α) → α
```

Definition body (one-level semantic boundary):

```lean
fun {α} c [h : Decidable c] t e => Decidable.casesOn h e t
```

### D375: `instCommSemiringENat`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENat.Basic`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `2006433d7e59786b5adfaf48bdee5d2cc185777329583880663b3a671d4381ff`

Type:

```lean
CommSemiring ENat
```

Fully explicit type:

```lean
CommSemiring.{0} ENat
```

Definition body (one-level semantic boundary):

```lean
let __spread.0 := inferInstanceAs (CommSemiring (WithTop Nat));
let __NatCast := inferInstance;
{ toNonUnitalSemiring := __spread.0.toNonUnitalSemiring, toOne := __spread.0.toOne,
  one_mul := instCommSemiringENat._proof_1, mul_one := instCommSemiringENat._proof_2, toNatCast := __NatCast,
  natCast_zero := instCommSemiringENat._proof_3, natCast_succ := instCommSemiringENat._proof_4, npow := __spread.0.npow,
  npow_zero := instCommSemiringENat._proof_5, npow_succ := instCommSemiringENat._proof_6,
  mul_comm := instCommSemiringENat._proof_7 }
```

### D376: `instCompleteLinearOrderENat`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENat.Lattice`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `59b443ca7499b32cb61e0cf0527c5feee0d08d9aaa8d8ba52d51545f960bb9f9`

Type:

```lean
CompleteLinearOrder ENat
```

Fully explicit type:

```lean
CompleteLinearOrder.{0} ENat
```

Definition body (one-level semantic boundary):

```lean
WithTop.instCompleteLinearOrder
```

### D377: `nhdsWithin`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `6`
- Semantic SHA-256: `ae7b5c1971244e63e32407fed747da989ad9fef3a4d9c3a64643427eaf071f05`

Type:

```lean
{X : Type u_1} → [TopologicalSpace X] → X → Set X → Filter X
```

Fully explicit type:

```lean
{X : Type u_1} → [TopologicalSpace.{u_1} X] → (x : X) → (s : Set.{u_1} X) → Filter.{u_1} X
```

Definition body (one-level semantic boundary):

```lean
fun {X} [TopologicalSpace X] x s => Filter.instInf.min (nhds x) (Filter.principal s)
```

### D378: `AddCommGroup.toDivisionAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `7`
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

### D379: `AddCommMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D380: `AddMonoid.toAddSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `53035db9e0775eb45fee0c79e256c7afbc00434e9d21556466e32261d7ed2f3f`

Type:

```lean
{M : Type u} → [self : AddMonoid M] → AddSemigroup M
```

Fully explicit type:

```lean
{M : Type u} → [self : AddMonoid.{u} M] → AddSemigroup.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : AddMonoid M] => self.1
```

### D381: `AddSemigroup.toAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `2a646160a862e3e4924b269991cf3ad847d649f1a455f3579749acff93f6476f`

Type:

```lean
{G : Type u} → [self : AddSemigroup G] → Add G
```

Fully explicit type:

```lean
{G : Type u} → [self : AddSemigroup.{u} G] → Add.{u} G
```

Definition body (one-level semantic boundary):

```lean
fun G [self : AddSemigroup G] => self.1
```

### D382: `CommMonoid.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `65ddc9c50077d680b1b091e3d6fa142a8c9b3ba8e7598e50b7119db31edeea4b`

Type:

```lean
{M : Type u} → [self : CommMonoid M] → Monoid M
```

Fully explicit type:

```lean
{M : Type u} → [self : CommMonoid.{u} M] → Monoid.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : CommMonoid M] => self.1
```

### D383: `CommRing.toCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `d28081503ff2e302e92f588f31cce8f13be2bf8e9795275534ba8dfb0118a276`

Type:

```lean
{α : Type u} → [self : CommRing α] → CommMonoid α
```

Fully explicit type:

```lean
{α : Type u} → [self : CommRing.{u} α] → CommMonoid.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self =>
  { toMul := self.toMul, mul_assoc := ⋯, toOne := self.toOne, one_mul := ⋯, mul_one := ⋯, npow := self.npow,
    npow_zero := ⋯, npow_succ := ⋯, mul_comm := ⋯ }
```

### D384: `ContinuousAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Monoid.Defs`
- Declaration kind: `inductive`
- Distance from target type: `7`
- Semantic SHA-256: `44c7f6f7a51f3c30a91ca5d7893f82c6b3bde265d86991f75bca55c7d5619bdc`

Type:

```lean
(M : Type u_1) → [TopologicalSpace M] → [Add M] → Prop
```

Fully explicit type:

```lean
(M : Type u_1) → [TopologicalSpace.{u_1} M] → [Add.{u_1} M] → Prop
```

### D385: `ContinuousConstSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.ConstMulAction`
- Declaration kind: `inductive`
- Distance from target type: `7`
- Semantic SHA-256: `64bb493562027db04039f38b3ff75d4943825dfb4dc78774e9b54eb26a0ac9c9`

Type:

```lean
(Γ : Type u_1) → (T : Type u_2) → [TopologicalSpace T] → [SMul Γ T] → Prop
```

Fully explicit type:

```lean
(Γ : Type u_1) → (T : Type u_2) → [TopologicalSpace.{u_2} T] → [SMul.{u_1, u_2} Γ T] → Prop
```

### D386: `ContinuousLinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `inductive`
- Distance from target type: `7`
- Semantic SHA-256: `0755150640fdc13f3d12ef9d25818b269a296f4838674f17959fc49dd8cab962`

Type:

```lean
{R : Type u_1} →
  {S : Type u_2} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        RingHom R S →
          (M : Type u_3) →
            [TopologicalSpace M] →
              [inst_3 : AddCommMonoid M] →
                (M₂ : Type u_4) →
                  [TopologicalSpace M₂] →
                    [inst_5 : AddCommMonoid M₂] → [Module R M] → [Module S M₂] → Type (max u_3 u_4)
```

Fully explicit type:

```lean
{R : Type u_1} →
  {S : Type u_2} →
    [inst : Semiring.{u_1} R] →
      [inst_1 : Semiring.{u_2} S] →
        (σ :
            @RingHom.{u_1, u_2} R S (@Semiring.toNonAssocSemiring.{u_1} R inst)
              (@Semiring.toNonAssocSemiring.{u_2} S inst_1)) →
          (M : Type u_3) →
            [TopologicalSpace.{u_3} M] →
              [inst_3 : AddCommMonoid.{u_3} M] →
                (M₂ : Type u_4) →
                  [TopologicalSpace.{u_4} M₂] →
                    [inst_5 : AddCommMonoid.{u_4} M₂] →
                      [@Module.{u_1, u_3} R M inst inst_3] →
                        [@Module.{u_2, u_4} S M₂ inst_1 inst_5] → Type (max u_3 u_4)
```

### D387: `ContinuousLinearMap.toLinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `9f9853b750cccc494240df6aaa291df7574b484c4ef82b93b35f4e8d951fb171`

Type:

```lean
{R : Type u_1} →
  {S : Type u_2} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        {σ : RingHom R S} →
          {M : Type u_3} →
            [inst_2 : TopologicalSpace M] →
              [inst_3 : AddCommMonoid M] →
                {M₂ : Type u_4} →
                  [inst_4 : TopologicalSpace M₂] →
                    [inst_5 : AddCommMonoid M₂] →
                      [inst_6 : Module R M] → [inst_7 : Module S M₂] → ContinuousLinearMap σ M M₂ → LinearMap σ M M₂
```

Fully explicit type:

```lean
{R : Type u_1} →
  {S : Type u_2} →
    [inst : Semiring.{u_1} R] →
      [inst_1 : Semiring.{u_2} S] →
        {σ :
            @RingHom.{u_1, u_2} R S (@Semiring.toNonAssocSemiring.{u_1} R inst)
              (@Semiring.toNonAssocSemiring.{u_2} S inst_1)} →
          {M : Type u_3} →
            [inst_2 : TopologicalSpace.{u_3} M] →
              [inst_3 : AddCommMonoid.{u_3} M] →
                {M₂ : Type u_4} →
                  [inst_4 : TopologicalSpace.{u_4} M₂] →
                    [inst_5 : AddCommMonoid.{u_4} M₂] →
                      [inst_6 : @Module.{u_1, u_3} R M inst inst_3] →
                        [inst_7 : @Module.{u_2, u_4} S M₂ inst_1 inst_5] →
                          (self :
                              @ContinuousLinearMap.{u_1, u_2, u_3, u_4} R S inst inst_1 σ M inst_2 inst_3 M₂ inst_4
                                inst_5 inst_6 inst_7) →
                            @LinearMap.{u_1, u_2, u_3, u_4} R S inst inst_1 σ M M₂ inst_3 inst_5 inst_6 inst_7
```

Definition body (one-level semantic boundary):

```lean
fun R S [Semiring R] [Semiring S] σ M [TopologicalSpace M] [AddCommMonoid M] M₂ [TopologicalSpace M₂] [AddCommMonoid M₂]
    [Module R M] [Module S M₂] self =>
  self.1
```

### D388: `DFinsupp.instEquivLikeLinearEquiv`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.DFinsupp`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `fe0373c4e4a236db57ec78aa51496bc89dab4fb0097dc18c96c70c6df789463d`

Type:

```lean
{R : Type u_7} →
  {S : Type u_8} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        (σ : RingHom R S) →
          {σ' : RingHom S R} →
            [inst_2 : RingHomInvPair σ σ'] →
              [inst_3 : RingHomInvPair σ' σ] →
                (M : Type u_9) →
                  (M₂ : Type u_10) →
                    [inst_4 : AddCommMonoid M] →
                      [inst_5 : AddCommMonoid M₂] →
                        [inst_6 : Module R M] → [inst_7 : Module S M₂] → EquivLike (LinearEquiv σ M M₂) M M₂
```

Fully explicit type:

```lean
{R : Type u_7} →
  {S : Type u_8} →
    [inst : Semiring.{u_7} R] →
      [inst_1 : Semiring.{u_8} S] →
        (σ :
            @RingHom.{u_7, u_8} R S (@Semiring.toNonAssocSemiring.{u_7} R inst)
              (@Semiring.toNonAssocSemiring.{u_8} S inst_1)) →
          {σ' :
              @RingHom.{u_8, u_7} S R (@Semiring.toNonAssocSemiring.{u_8} S inst_1)
                (@Semiring.toNonAssocSemiring.{u_7} R inst)} →
            [inst_2 : @RingHomInvPair.{u_7, u_8} R S inst inst_1 σ σ'] →
              [inst_3 : @RingHomInvPair.{u_8, u_7} S R inst_1 inst σ' σ] →
                (M : Type u_9) →
                  (M₂ : Type u_10) →
                    [inst_4 : AddCommMonoid.{u_9} M] →
                      [inst_5 : AddCommMonoid.{u_10} M₂] →
                        [inst_6 : @Module.{u_7, u_9} R M inst inst_4] →
                          [inst_7 : @Module.{u_8, u_10} S M₂ inst_1 inst_5] →
                            EquivLike.{max (u_10 + 1) (u_9 + 1), u_9 + 1, u_10 + 1}
                              (@LinearEquiv.{u_7, u_8, u_9, u_10} R S inst inst_1 σ σ' inst_2 inst_3 M M₂ inst_4 inst_5
                                inst_6 inst_7)
                              M M₂
```

Definition body (one-level semantic boundary):

```lean
fun {R} {S} [Semiring R] [Semiring S] σ {σ'} [RingHomInvPair σ σ'] [RingHomInvPair σ' σ] M M₂ [AddCommMonoid M]
    [AddCommMonoid M₂] [Module R M] [Module S M₂] =>
  inferInstance
```

### D389: `DistribMulAction.toMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `ea6124156f152313d3298dd94738351217f9626c6fc23cb2b63efa1528a4f9b9`

Type:

```lean
{M : Type u_12} →
  {A : Type u_13} → {inst : Monoid M} → {inst_1 : AddMonoid A} → [self : DistribMulAction M A] → MulAction M A
```

Fully explicit type:

```lean
{M : Type u_12} →
  {A : Type u_13} →
    {inst : Monoid.{u_12} M} →
      {inst_1 : AddMonoid.{u_13} A} →
        [self : @DistribMulAction.{u_12, u_13} M A inst inst_1] → @MulAction.{u_12, u_13} M A inst
```

Definition body (one-level semantic boundary):

```lean
fun M A {inst} {inst_1} [self : DistribMulAction M A] => self.1
```

### D390: `EquivLike.toFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Equiv`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `0f60978070e976ff8040a5b974a5b08a27d74758a8f4361a6276a17c12a1d96a`

Type:

```lean
{E : Sort u_1} → {α : Sort u_3} → {β : Sort u_4} → [EquivLike E α β] → FunLike E α β
```

Fully explicit type:

```lean
{E : Sort u_1} → {α : Sort u_3} → {β : Sort u_4} → [EquivLike.{u_1, u_3, u_4} E α β] → FunLike.{u_1, u_3, u_4} E α β
```

Definition body (one-level semantic boundary):

```lean
fun {E} {α} {β} [inst : EquivLike E α β] => { coe := inst.coe, coe_injective' := ⋯ }
```

### D391: `Field.toCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Field.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `98951e9070266958fafffa7fc952443a20356644a3efe2feef5693e8097011e4`

Type:

```lean
{K : Type u} → [self : Field K] → CommRing K
```

Fully explicit type:

```lean
{K : Type u} → [self : Field.{u} K] → CommRing.{u} K
```

Definition body (one-level semantic boundary):

```lean
fun K [self : Field K] => self.1
```

### D392: `HasFDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.FDeriv.Defs`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `c88b26f5f3fc2e71d02af18ecf4a0d54c0195c980c065fee932526f3a7dc8335`

Type:

```lean
{𝕜 : Type u_1} →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type u_2} →
      [inst_1 : AddCommGroup E] →
        [inst_2 : Module 𝕜 E] →
          [inst_3 : TopologicalSpace E] →
            {F : Type u_3} →
              [inst_4 : AddCommGroup F] →
                [inst_5 : Module 𝕜 F] →
                  [inst_6 : TopologicalSpace F] → (E → F) → ContinuousLinearMap (RingHom.id 𝕜) E F → E → Prop
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  [inst : NontriviallyNormedField.{u_1} 𝕜] →
    {E : Type u_2} →
      [inst_1 : AddCommGroup.{u_2} E] →
        [inst_2 :
            @Module.{u_1, u_2} 𝕜 E
              (@DivisionSemiring.toSemiring.{u_1} 𝕜
                (@Semifield.toDivisionSemiring.{u_1} 𝕜
                  (@Field.toSemifield.{u_1} 𝕜
                    (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
              (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1)] →
          [inst_3 : TopologicalSpace.{u_2} E] →
            {F : Type u_3} →
              [inst_4 : AddCommGroup.{u_3} F] →
                [inst_5 :
                    @Module.{u_1, u_3} 𝕜 F
                      (@DivisionSemiring.toSemiring.{u_1} 𝕜
                        (@Semifield.toDivisionSemiring.{u_1} 𝕜
                          (@Field.toSemifield.{u_1} 𝕜
                            (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
                      (@AddCommGroup.toAddCommMonoid.{u_3} F inst_4)] →
                  [inst_6 : TopologicalSpace.{u_3} F] →
                    (f : E → F) →
                      (f' :
                          @ContinuousLinearMap.{u_1, u_1, u_2, u_3} 𝕜 𝕜
                            (@DivisionSemiring.toSemiring.{u_1} 𝕜
                              (@Semifield.toDivisionSemiring.{u_1} 𝕜
                                (@Field.toSemifield.{u_1} 𝕜
                                  (@NormedField.toField.{u_1} 𝕜
                                    (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
                            (@DivisionSemiring.toSemiring.{u_1} 𝕜
                              (@Semifield.toDivisionSemiring.{u_1} 𝕜
                                (@Field.toSemifield.{u_1} 𝕜
                                  (@NormedField.toField.{u_1} 𝕜
                                    (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
                            (@RingHom.id.{u_1} 𝕜
                              (@Semiring.toNonAssocSemiring.{u_1} 𝕜
                                (@DivisionSemiring.toSemiring.{u_1} 𝕜
                                  (@Semifield.toDivisionSemiring.{u_1} 𝕜
                                    (@Field.toSemifield.{u_1} 𝕜
                                      (@NormedField.toField.{u_1} 𝕜
                                        (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))))
                            E inst_3 (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) F inst_6
                            (@AddCommGroup.toAddCommMonoid.{u_3} F inst_4) inst_2 inst_5) →
                        (x : E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NontriviallyNormedField 𝕜] {E} [AddCommGroup E] [Module 𝕜 E] [TopologicalSpace E] {F} [AddCommGroup F]
    [Module 𝕜 F] [TopologicalSpace F] f f' x =>
  HasFDerivAtFilter f f' (Filter.instSProd.sprod (nhds x) (Filter.instPure.pure x))
```

### D393: `IsBoundedSMul.toUniformContinuousConstSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Algebra`
- Declaration kind: `theorem`
- Distance from target type: `7`
- Semantic SHA-256: `d335cebf53a55ecddc46ebc5040ac4b546c8975509593c88e246d389aabd088f`

Type:

```lean
∀ {α : Type u_1} {β : Type u_2} [inst : PseudoMetricSpace α] [inst_1 : PseudoMetricSpace β] [inst_2 : Zero α]
  [inst_3 : Zero β] [inst_4 : SMul α β] [IsBoundedSMul α β], UniformContinuousConstSMul α β
```

Fully explicit type:

```lean
∀ {α : Type u_1} {β : Type u_2} [inst : PseudoMetricSpace.{u_1} α] [inst_1 : PseudoMetricSpace.{u_2} β]
  [inst_2 : Zero.{u_1} α] [inst_3 : Zero.{u_2} β] [inst_4 : SMul.{u_1, u_2} α β]
  [@IsBoundedSMul.{u_1, u_2} α β inst inst_1 inst_2 inst_3 inst_4],
  @UniformContinuousConstSMul.{u_1, u_2} α β (@PseudoMetricSpace.toUniformSpace.{u_2} β inst_1) inst_4
```

### D394: `IsTopologicalAddGroup.toContinuousAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Group.Defs`
- Declaration kind: `theorem`
- Distance from target type: `7`
- Semantic SHA-256: `00bbb219e39e3965f427193652fe8dfc131e13996206bb78baba02a444f1253a`

Type:

```lean
∀ {G : Type u} {inst : TopologicalSpace G} {inst_1 : AddGroup G} [self : IsTopologicalAddGroup G], ContinuousAdd G
```

Fully explicit type:

```lean
∀ {G : Type u} {inst : TopologicalSpace.{u} G} {inst_1 : AddGroup.{u} G}
  [self : @IsTopologicalAddGroup.{u} G inst inst_1],
  @ContinuousAdd.{u} G inst
    (@AddSemigroup.toAdd.{u} G
      (@AddMonoid.toAddSemigroup.{u} G (@SubNegMonoid.toAddMonoid.{u} G (@AddGroup.toSubNegMonoid.{u} G inst_1))))
```

### D395: `LinearEquiv`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Equiv.Defs`
- Declaration kind: `inductive`
- Distance from target type: `7`
- Semantic SHA-256: `6a1e194e5e1f3458fc29174b3ebc7e52b4b228d4e72f70b8b3129d5a513816a3`

Type:

```lean
{R : Type u_14} →
  {S : Type u_15} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        (σ : RingHom R S) →
          {σ' : RingHom S R} →
            [RingHomInvPair σ σ'] →
              [RingHomInvPair σ' σ] →
                (M : Type u_16) →
                  (M₂ : Type u_17) →
                    [inst_4 : AddCommMonoid M] →
                      [inst_5 : AddCommMonoid M₂] → [Module R M] → [Module S M₂] → Type (max u_16 u_17)
```

Fully explicit type:

```lean
{R : Type u_14} →
  {S : Type u_15} →
    [inst : Semiring.{u_14} R] →
      [inst_1 : Semiring.{u_15} S] →
        (σ :
            @RingHom.{u_14, u_15} R S (@Semiring.toNonAssocSemiring.{u_14} R inst)
              (@Semiring.toNonAssocSemiring.{u_15} S inst_1)) →
          {σ' :
              @RingHom.{u_15, u_14} S R (@Semiring.toNonAssocSemiring.{u_15} S inst_1)
                (@Semiring.toNonAssocSemiring.{u_14} R inst)} →
            [@RingHomInvPair.{u_14, u_15} R S inst inst_1 σ σ'] →
              [@RingHomInvPair.{u_15, u_14} S R inst_1 inst σ' σ] →
                (M : Type u_16) →
                  (M₂ : Type u_17) →
                    [inst_4 : AddCommMonoid.{u_16} M] →
                      [inst_5 : AddCommMonoid.{u_17} M₂] →
                        [@Module.{u_14, u_16} R M inst inst_4] →
                          [@Module.{u_15, u_17} S M₂ inst_1 inst_5] → Type (max u_16 u_17)
```

### D396: `LinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `inductive`
- Distance from target type: `7`
- Semantic SHA-256: `4d6a16b4507b37ff97503f46684751acdb916a859224b68a1c2a8b68af63e31c`

Type:

```lean
{R : Type u_14} →
  {S : Type u_15} →
    [inst : Semiring R] →
      [inst_1 : Semiring S] →
        RingHom R S →
          (M : Type u_16) →
            (M₂ : Type u_17) →
              [inst_2 : AddCommMonoid M] →
                [inst_3 : AddCommMonoid M₂] → [Module R M] → [Module S M₂] → Type (max u_16 u_17)
```

Fully explicit type:

```lean
{R : Type u_14} →
  {S : Type u_15} →
    [inst : Semiring.{u_14} R] →
      [inst_1 : Semiring.{u_15} S] →
        (σ :
            @RingHom.{u_14, u_15} R S (@Semiring.toNonAssocSemiring.{u_14} R inst)
              (@Semiring.toNonAssocSemiring.{u_15} S inst_1)) →
          (M : Type u_16) →
            (M₂ : Type u_17) →
              [inst_2 : AddCommMonoid.{u_16} M] →
                [inst_3 : AddCommMonoid.{u_17} M₂] →
                  [@Module.{u_14, u_16} R M inst inst_2] →
                    [@Module.{u_15, u_17} S M₂ inst_1 inst_3] → Type (max u_16 u_17)
```

### D397: `LinearMap.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `ab4e5f87ffe446bf4b1a818669f80f82d003b1d88bffa60d6568767a5b492e76`

Type:

```lean
{R₁ : Type u_2} →
  {R₂ : Type u_3} →
    {M : Type u_8} →
      {M₂ : Type u_10} →
        [inst : Semiring R₁] →
          [inst_1 : Semiring R₂] →
            [inst_2 : AddCommMonoid M] →
              [inst_3 : AddCommMonoid M₂] →
                [inst_4 : Module R₁ M] →
                  [inst_5 : Module R₂ M₂] → {σ₁₂ : RingHom R₁ R₂} → AddCommMonoid (LinearMap σ₁₂ M M₂)
```

Fully explicit type:

```lean
{R₁ : Type u_2} →
  {R₂ : Type u_3} →
    {M : Type u_8} →
      {M₂ : Type u_10} →
        [inst : Semiring.{u_2} R₁] →
          [inst_1 : Semiring.{u_3} R₂] →
            [inst_2 : AddCommMonoid.{u_8} M] →
              [inst_3 : AddCommMonoid.{u_10} M₂] →
                [inst_4 : @Module.{u_2, u_8} R₁ M inst inst_2] →
                  [inst_5 : @Module.{u_3, u_10} R₂ M₂ inst_1 inst_3] →
                    {σ₁₂ :
                        @RingHom.{u_2, u_3} R₁ R₂ (@Semiring.toNonAssocSemiring.{u_2} R₁ inst)
                          (@Semiring.toNonAssocSemiring.{u_3} R₂ inst_1)} →
                      AddCommMonoid.{max u_10 u_8}
                        (@LinearMap.{u_2, u_3, u_8, u_10} R₁ R₂ inst inst_1 σ₁₂ M M₂ inst_2 inst_3 inst_4 inst_5)
```

Definition body (one-level semantic boundary):

```lean
fun {R₁} {R₂} {M} {M₂} [Semiring R₁] [Semiring R₂] [AddCommMonoid M] [AddCommMonoid M₂] [Module R₁ M] [Module R₂ M₂]
    {σ₁₂} =>
  Function.Injective.addCommMonoid (fun f => LinearMap.instFunLike.coe f) ⋯ ⋯ ⋯ ⋯
```

### D398: `LinearMap.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.LinearMap.Defs`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `017b40e990cc84887be863ba33792de76923fe3ca657329d8c9158a2e880ffee`

Type:

```lean
{R : Type u_1} →
  {R₂ : Type u_3} →
    {S : Type u_5} →
      {M : Type u_8} →
        {M₂ : Type u_10} →
          [inst : Semiring R] →
            [inst_1 : Semiring R₂] →
              [inst_2 : AddCommMonoid M] →
                [inst_3 : AddCommMonoid M₂] →
                  [inst_4 : Module R M] →
                    [inst_5 : Module R₂ M₂] →
                      {σ₁₂ : RingHom R R₂} →
                        [inst_6 : Semiring S] →
                          [inst_7 : Module S M₂] → [SMulCommClass R₂ S M₂] → Module S (LinearMap σ₁₂ M M₂)
```

Fully explicit type:

```lean
{R : Type u_1} →
  {R₂ : Type u_3} →
    {S : Type u_5} →
      {M : Type u_8} →
        {M₂ : Type u_10} →
          [inst : Semiring.{u_1} R] →
            [inst_1 : Semiring.{u_3} R₂] →
              [inst_2 : AddCommMonoid.{u_8} M] →
                [inst_3 : AddCommMonoid.{u_10} M₂] →
                  [inst_4 : @Module.{u_1, u_8} R M inst inst_2] →
                    [inst_5 : @Module.{u_3, u_10} R₂ M₂ inst_1 inst_3] →
                      {σ₁₂ :
                          @RingHom.{u_1, u_3} R R₂ (@Semiring.toNonAssocSemiring.{u_1} R inst)
                            (@Semiring.toNonAssocSemiring.{u_3} R₂ inst_1)} →
                        [inst_6 : Semiring.{u_5} S] →
                          [inst_7 : @Module.{u_5, u_10} S M₂ inst_6 inst_3] →
                            [@SMulCommClass.{u_3, u_5, u_10} R₂ S M₂
                                  (@SMulZeroClass.toSMul.{u_3, u_10} R₂ M₂
                                    (@AddZero.toZero.{u_10} M₂
                                      (@AddZeroClass.toAddZero.{u_10} M₂
                                        (@AddMonoid.toAddZeroClass.{u_10} M₂
                                          (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3))))
                                    (@DistribSMul.toSMulZeroClass.{u_3, u_10} R₂ M₂
                                      (@AddMonoid.toAddZeroClass.{u_10} M₂
                                        (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3))
                                      (@DistribMulAction.toDistribSMul.{u_3, u_10} R₂ M₂
                                        (@MonoidWithZero.toMonoid.{u_3} R₂ (@Semiring.toMonoidWithZero.{u_3} R₂ inst_1))
                                        (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3)
                                        (@Module.toDistribMulAction.{u_3, u_10} R₂ M₂ inst_1 inst_3 inst_5))))
                                  (@SMulZeroClass.toSMul.{u_5, u_10} S M₂
                                    (@AddZero.toZero.{u_10} M₂
                                      (@AddZeroClass.toAddZero.{u_10} M₂
                                        (@AddMonoid.toAddZeroClass.{u_10} M₂
                                          (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3))))
                                    (@DistribSMul.toSMulZeroClass.{u_5, u_10} S M₂
                                      (@AddMonoid.toAddZeroClass.{u_10} M₂
                                        (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3))
                                      (@DistribMulAction.toDistribSMul.{u_5, u_10} S M₂
                                        (@MonoidWithZero.toMonoid.{u_5} S (@Semiring.toMonoidWithZero.{u_5} S inst_6))
                                        (@AddCommMonoid.toAddMonoid.{u_10} M₂ inst_3)
                                        (@Module.toDistribMulAction.{u_5, u_10} S M₂ inst_6 inst_3 inst_7))))] →
                              @Module.{u_5, max u_10 u_8} S
                                (@LinearMap.{u_1, u_3, u_8, u_10} R R₂ inst inst_1 σ₁₂ M M₂ inst_2 inst_3 inst_4 inst_5)
                                inst_6
                                (@LinearMap.addCommMonoid.{u_1, u_3, u_8, u_10} R R₂ M M₂ inst inst_1 inst_2 inst_3
                                  inst_4 inst_5 σ₁₂)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {R₂} {S} {M} {M₂} [Semiring R] [Semiring R₂] [AddCommMonoid M] [AddCommMonoid M₂] [Module R M] [Module R₂ M₂]
    {σ₁₂} [Semiring S] [Module S M₂] [SMulCommClass R₂ S M₂] =>
  { toDistribMulAction := LinearMap.instDistribMulAction, add_smul := ⋯, zero_smul := ⋯ }
```

### D399: `LinearMap.toMatrix'`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.ToLin`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `e6a54896ef32827c20d64677b2bde29030c3fcd47def618d946669e8a97f5747`

Type:

```lean
{R : Type u_1} →
  [inst : CommSemiring R] →
    {m : Type u_4} →
      {n : Type u_5} →
        [DecidableEq n] →
          [Fintype n] → LinearEquiv (RingHom.id R) (LinearMap (RingHom.id R) (n → R) (m → R)) (Matrix m n R)
```

Fully explicit type:

```lean
{R : Type u_1} →
  [inst : CommSemiring.{u_1} R] →
    {m : Type u_4} →
      {n : Type u_5} →
        [DecidableEq.{u_5 + 1} n] →
          [Fintype.{u_5} n] →
            @LinearEquiv.{u_1, u_1, max (max u_1 u_4) u_1 u_5, max (max u_1 u_5) u_4} R R
              (@CommSemiring.toSemiring.{u_1} R inst) (@CommSemiring.toSemiring.{u_1} R inst)
              (@RingHom.id.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
              (@RingHom.id.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
              (@RingHomInvPair.ids.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))
              (@RingHomInvPair.ids.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))
              (@LinearMap.{u_1, u_1, max u_1 u_5, max u_1 u_4} R R (@CommSemiring.toSemiring.{u_1} R inst)
                (@CommSemiring.toSemiring.{u_1} R inst)
                (@RingHom.id.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (n → R) (m → R)
                (@Pi.addCommMonoid.{u_5, u_1} n (fun (a : n) => R) fun (i : n) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.addCommMonoid.{u_4, u_1} m (fun (a : m) => R) fun (i : m) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.Function.module.{u_5, u_1, u_1} n R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@Pi.Function.module.{u_4, u_1, u_1} m R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
              (Matrix.{u_4, u_5, u_1} m n R)
              (@LinearMap.addCommMonoid.{u_1, u_1, max u_1 u_5, max u_1 u_4} R R (n → R) (m → R)
                (@CommSemiring.toSemiring.{u_1} R inst) (@CommSemiring.toSemiring.{u_1} R inst)
                (@Pi.addCommMonoid.{u_5, u_1} n (fun (a : n) => R) fun (i : n) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.addCommMonoid.{u_4, u_1} m (fun (a : m) => R) fun (i : m) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.Function.module.{u_5, u_1, u_1} n R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@Pi.Function.module.{u_4, u_1, u_1} m R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@RingHom.id.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
              (@Matrix.addCommMonoid.{u_1, u_4, u_5} m n R
                (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                  (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                    (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))))
              (@LinearMap.module.{u_1, u_1, u_1, max u_1 u_5, max u_1 u_4} R R R (n → R) (m → R)
                (@CommSemiring.toSemiring.{u_1} R inst) (@CommSemiring.toSemiring.{u_1} R inst)
                (@Pi.addCommMonoid.{u_5, u_1} n (fun (a : n) => R) fun (i : n) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.addCommMonoid.{u_4, u_1} m (fun (a : m) => R) fun (i : m) =>
                  @NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Pi.Function.module.{u_5, u_1, u_1} n R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@Pi.Function.module.{u_4, u_1, u_1} m R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@RingHom.id.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@CommSemiring.toSemiring.{u_1} R inst)
                (@Pi.Function.module.{u_4, u_1, u_1} m R R (@CommSemiring.toSemiring.{u_1} R inst)
                  (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                    (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                      (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                  (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                (@Function.smulCommClass.{u_4, u_1, u_1, u_1} m R R R
                  (@SemigroupAction.toSMul.{u_1, u_1} R R
                    (@Monoid.toSemigroup.{u_1} R
                      (@MonoidWithZero.toMonoid.{u_1} R
                        (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                    (@MulAction.toSemigroupAction.{u_1, u_1} R R
                      (@MonoidWithZero.toMonoid.{u_1} R
                        (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                      (@DistribMulAction.toMulAction.{u_1, u_1} R R
                        (@MonoidWithZero.toMonoid.{u_1} R
                          (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                        (@AddCommMonoid.toAddMonoid.{u_1} R
                          (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                              (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))))
                        (@Module.toDistribMulAction.{u_1, u_1} R R (@CommSemiring.toSemiring.{u_1} R inst)
                          (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                              (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                          (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))))
                  (@SemigroupAction.toSMul.{u_1, u_1} R R
                    (@Monoid.toSemigroup.{u_1} R
                      (@MonoidWithZero.toMonoid.{u_1} R
                        (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                    (@MulAction.toSemigroupAction.{u_1, u_1} R R
                      (@MonoidWithZero.toMonoid.{u_1} R
                        (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                      (@DistribMulAction.toMulAction.{u_1, u_1} R R
                        (@MonoidWithZero.toMonoid.{u_1} R
                          (@Semiring.toMonoidWithZero.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
                        (@AddCommMonoid.toAddMonoid.{u_1} R
                          (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                              (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))))
                        (@Module.toDistribMulAction.{u_1, u_1} R R (@CommSemiring.toSemiring.{u_1} R inst)
                          (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                            (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                              (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                          (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))))
                  (@Algebra.to_smulCommClass.{u_1, u_1} R R inst (@CommSemiring.toSemiring.{u_1} R inst)
                    (@Algebra.id.{u_1} R inst))))
              (@Matrix.module.{u_1, u_4, u_5, u_1} m n R R (@CommSemiring.toSemiring.{u_1} R inst)
                (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
                  (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R
                    (@Semiring.toNonAssocSemiring.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst))))
                (@Semiring.toModule.{u_1} R (@CommSemiring.toSemiring.{u_1} R inst)))
```

Definition body (one-level semantic boundary):

```lean
fun {R} [CommSemiring R] {m} {n} [DecidableEq n] [Fintype n] =>
  { toFun := fun f => EquivLike.toFunLike.coe Matrix.of fun i j => LinearMap.instFunLike.coe f (Pi.single j 1) i,
    map_add' := ⋯, map_smul' := ⋯, invFun := Matrix.mulVecLin, left_inv := ⋯, right_inv := ⋯ }
```

### D400: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `e552ffc8c85b917dca38e5965ad91773fdb989246623a528d91526b75d68c2f1`

Type:

```lean
Type u → Type u' → Type v → Type (max u u' v)
```

Fully explicit type:

```lean
(m : Type u) → (n : Type u') → (α : Type v) → Type (max u u' v)
```

Definition body (one-level semantic boundary):

```lean
fun m n α => m → n → α
```

### D401: `Matrix.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `6b893d81bc298230772e16cd0c8ddf7d2638ac0d6127094b06a1290d88f8c3ae`

Type:

```lean
{m : Type u_2} → {n : Type u_3} → {α : Type v} → [AddCommMonoid α] → AddCommMonoid (Matrix m n α)
```

Fully explicit type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {α : Type v} → [AddCommMonoid.{v} α] → AddCommMonoid.{max (max v u_3) u_2} (Matrix.{u_2, u_3, v} m n α)
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {α} [AddCommMonoid α] => Pi.addCommMonoid
```

### D402: `Matrix.module`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `4fdec58292003fac825b4ffe1900f940d4ef3c8d02e84e23484d4b31f8742856`

Type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {R : Type u_7} →
      {α : Type v} → [inst : Semiring R] → [inst_1 : AddCommMonoid α] → [Module R α] → Module R (Matrix m n α)
```

Fully explicit type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {R : Type u_7} →
      {α : Type v} →
        [inst : Semiring.{u_7} R] →
          [inst_1 : AddCommMonoid.{v} α] →
            [@Module.{u_7, v} R α inst inst_1] →
              @Module.{u_7, max (max v u_3) u_2} R (Matrix.{u_2, u_3, v} m n α) inst
                (@Matrix.addCommMonoid.{v, u_2, u_3} m n α inst_1)
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {R} {α} [Semiring R] [AddCommMonoid α] [Module R α] => Pi.module m (fun a => n → α) R
```

### D403: `Monoid.toSemigroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `136930a747dcd73895587cb4c7ea1df27360fed0a4adb57efb71bb8949f0fa71`

Type:

```lean
{M : Type u} → [self : Monoid M] → Semigroup M
```

Fully explicit type:

```lean
{M : Type u} → [self : Monoid.{u} M] → Semigroup.{u} M
```

Definition body (one-level semantic boundary):

```lean
fun M [self : Monoid M] => self.1
```

### D404: `MonoidWithZero.toMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D405: `MulAction.toSemigroupAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `2a4074e38a7cedd1ecdaf86a42d3be01ad9728988610178bf9a698f57a876516`

Type:

```lean
{α : Type u_9} → {β : Type u_10} → {inst : Monoid α} → [self : MulAction α β] → SemigroupAction α β
```

Fully explicit type:

```lean
{α : Type u_9} →
  {β : Type u_10} →
    {inst : Monoid.{u_9} α} →
      [self : @MulAction.{u_9, u_10} α β inst] → @SemigroupAction.{u_9, u_10} α β (@Monoid.toSemigroup.{u_9} α inst)
```

Definition body (one-level semantic boundary):

```lean
fun α β {inst} [self : MulAction α β] => self.1
```

### D406: `MulZeroClass.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `a3f3ff8a43fb45098d9029196fe0a081ace6a8cc0c485317c7c17e719ec29c60`

Type:

```lean
{M₀ : Type u} → [self : MulZeroClass M₀] → Zero M₀
```

Fully explicit type:

```lean
{M₀ : Type u} → [self : MulZeroClass.{u} M₀] → Zero.{u} M₀
```

Definition body (one-level semantic boundary):

```lean
fun M₀ [self : MulZeroClass M₀] => self.2
```

### D407: `NegZeroClass.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D408: `NonAssocSemiring.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D409: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D410: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D411: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D412: `NonUnitalNonAssocSemiring.toMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `87ddc8012963f013675a2d3b6dbd069bd2e6eeeafa9e7aff6d92bfbf7d848152`

Type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring α] → MulZeroClass α
```

Fully explicit type:

```lean
{α : Type u} → [self : NonUnitalNonAssocSemiring.{u} α] → MulZeroClass.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun α self => { toMul := self.toMul, toZero := self.toZero, zero_mul := ⋯, mul_zero := ⋯ }
```

### D413: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D414: `NormedAddCommGroup.toAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `c92bdde4376567f29ebdebaf4a7dd986bfb96211cd0306e14540b80cd23009d2`

Type:

```lean
{E : Type u_8} → [self : NormedAddCommGroup E] → AddCommGroup E
```

Fully explicit type:

```lean
{E : Type u_8} → [self : NormedAddCommGroup.{u_8} E] → AddCommGroup.{u_8} E
```

Definition body (one-level semantic boundary):

```lean
fun E [self : NormedAddCommGroup E] => self.2
```

### D415: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `7`
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

### D416: `NormedField.toNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `7`
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

### D417: `NormedSpace.toIsBoundedSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `theorem`
- Distance from target type: `7`
- Semantic SHA-256: `10014495827261758559eb6422ef20a2cb6d701446d195d0bb709e288208c7e6`

Type:

```lean
∀ {𝕜 : Type u_1} {E : Type u_3} [inst : NormedField 𝕜] [inst_1 : SeminormedAddCommGroup E] [inst_2 : NormedSpace 𝕜 E],
  IsBoundedSMul 𝕜 E
```

Fully explicit type:

```lean
∀ {𝕜 : Type u_1} {E : Type u_3} [inst : NormedField.{u_1} 𝕜] [inst_1 : SeminormedAddCommGroup.{u_3} E]
  [inst_2 : @NormedSpace.{u_1, u_3} 𝕜 E inst inst_1],
  @IsBoundedSMul.{u_1, u_3} 𝕜 E
    (@SeminormedRing.toPseudoMetricSpace.{u_1} 𝕜
      (@SeminormedCommRing.toSeminormedRing.{u_1} 𝕜
        (@NormedCommRing.toSeminormedCommRing.{u_1} 𝕜 (@NormedField.toNormedCommRing.{u_1} 𝕜 inst))))
    (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_3} E inst_1)
    (@MulZeroClass.toZero.{u_1} 𝕜
      (@NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} 𝕜
        (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} 𝕜
          (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u_1} 𝕜
            (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u_1} 𝕜
              (@NonUnitalNormedCommRing.toNonUnitalCommRing.{u_1} 𝕜
                (@NormedCommRing.toNonUnitalNormedCommRing.{u_1} 𝕜 (@NormedField.toNormedCommRing.{u_1} 𝕜 inst))))))))
    (@NegZeroClass.toZero.{u_3} E
      (@SubNegZeroMonoid.toNegZeroClass.{u_3} E
        (@SubtractionMonoid.toSubNegZeroMonoid.{u_3} E
          (@SubtractionCommMonoid.toSubtractionMonoid.{u_3} E
            (@AddCommGroup.toDivisionAddCommMonoid.{u_3} E (@SeminormedAddCommGroup.toAddCommGroup.{u_3} E inst_1))))))
    (@SMulZeroClass.toSMul.{u_1, u_3} 𝕜 E
      (@AddZero.toZero.{u_3} E
        (@AddZeroClass.toAddZero.{u_3} E
          (@AddMonoid.toAddZeroClass.{u_3} E
            (@SubNegMonoid.toAddMonoid.{u_3} E
              (@AddGroup.toSubNegMonoid.{u_3} E
                (@SeminormedAddGroup.toAddGroup.{u_3} E
                  (@SeminormedAddCommGroup.toSeminormedAddGroup.{u_3} E inst_1)))))))
      (@DistribSMul.toSMulZeroClass.{u_1, u_3} 𝕜 E
        (@AddMonoid.toAddZeroClass.{u_3} E
          (@SubNegMonoid.toAddMonoid.{u_3} E
            (@AddGroup.toSubNegMonoid.{u_3} E
              (@SeminormedAddGroup.toAddGroup.{u_3} E (@SeminormedAddCommGroup.toSeminormedAddGroup.{u_3} E inst_1)))))
        (@DistribMulAction.toDistribSMul.{u_1, u_3} 𝕜 E
          (@MonoidWithZero.toMonoid.{u_1} 𝕜
            (@Semiring.toMonoidWithZero.{u_1} 𝕜
              (@DivisionSemiring.toSemiring.{u_1} 𝕜
                (@Semifield.toDivisionSemiring.{u_1} 𝕜
                  (@Field.toSemifield.{u_1} 𝕜 (@NormedField.toField.{u_1} 𝕜 inst))))))
          (@SubNegMonoid.toAddMonoid.{u_3} E
            (@AddGroup.toSubNegMonoid.{u_3} E
              (@SeminormedAddGroup.toAddGroup.{u_3} E (@SeminormedAddCommGroup.toSeminormedAddGroup.{u_3} E inst_1))))
          (@Module.toDistribMulAction.{u_1, u_3} 𝕜 E
            (@DivisionSemiring.toSemiring.{u_1} 𝕜
              (@Semifield.toDivisionSemiring.{u_1} 𝕜 (@Field.toSemifield.{u_1} 𝕜 (@NormedField.toField.{u_1} 𝕜 inst))))
            (@AddCommGroup.toAddCommMonoid.{u_3} E (@SeminormedAddCommGroup.toAddCommGroup.{u_3} E inst_1))
            (@NormedSpace.toModule.{u_1, u_3} 𝕜 E inst inst_1 inst_2)))))
```

### D418: `RingHom.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Hom.Defs`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `a6f90353b229eb95293a3c089ae20ade7711021afe852d8f78a4f79577dab479`

Type:

```lean
(α : Type u_5) → [inst : NonAssocSemiring α] → RingHom α α
```

Fully explicit type:

```lean
(α : Type u_5) → [inst : NonAssocSemiring.{u_5} α] → @RingHom.{u_5, u_5} α α inst inst
```

Definition body (one-level semantic boundary):

```lean
fun α [NonAssocSemiring α] => { toFun := id, map_one' := ⋯, map_mul' := ⋯, map_zero' := ⋯, map_add' := ⋯ }
```

### D419: `SMulCommClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `inductive`
- Distance from target type: `7`
- Semantic SHA-256: `25ca5b6e5618ba5262412f36bda1bf0ec64f56ca37162dc1ff3be3719f8983c5`

Type:

```lean
(M : Type u_9) → (N : Type u_10) → (α : Type u_11) → [SMul M α] → [SMul N α] → Prop
```

Fully explicit type:

```lean
(M : Type u_9) → (N : Type u_10) → (α : Type u_11) → [SMul.{u_9, u_11} M α] → [SMul.{u_10, u_11} N α] → Prop
```

### D420: `SemigroupAction.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
- Semantic SHA-256: `5a8783c66a2e56a4cc509bbb0651eda5b66e25c197307a42445cac31c4a4bb6c`

Type:

```lean
{α : Type u_9} → {β : Type u_10} → {inst : Semigroup α} → [self : SemigroupAction α β] → SMul α β
```

Fully explicit type:

```lean
{α : Type u_9} →
  {β : Type u_10} → {inst : Semigroup.{u_9} α} → [self : @SemigroupAction.{u_9, u_10} α β inst] → SMul.{u_9, u_10} α β
```

Definition body (one-level semantic boundary):

```lean
fun α β {inst} [self : SemigroupAction α β] => self.1
```

### D421: `SeminormedAddCommGroup.toIsTopologicalAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Uniform`
- Declaration kind: `theorem`
- Distance from target type: `7`
- Semantic SHA-256: `57ac324cd1f48e09b911b5d7b20ab6fe80f7a2aa45a806902a33ba5d8ae4a031`

Type:

```lean
∀ {E : Type u_2} [inst : SeminormedAddCommGroup E], IsTopologicalAddGroup E
```

Fully explicit type:

```lean
∀ {E : Type u_2} [inst : SeminormedAddCommGroup.{u_2} E],
  @IsTopologicalAddGroup.{u_2} E
    (@UniformSpace.toTopologicalSpace.{u_2} E
      (@PseudoMetricSpace.toUniformSpace.{u_2} E (@SeminormedAddCommGroup.toPseudoMetricSpace.{u_2} E inst)))
    (@SeminormedAddGroup.toAddGroup.{u_2} E (@SeminormedAddCommGroup.toSeminormedAddGroup.{u_2} E inst))
```

### D422: `SeminormedCommRing.toSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D423: `SeminormedRing.toPseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D424: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `ff102bae4edee1f1bb819368914caf0ac2ec810b7e80210cd357fd643729a472`

Type:

```lean
{R : Type u_1} → [inst : Semiring R] → Module R R
```

Fully explicit type:

```lean
{R : Type u_1} →
  [inst : Semiring.{u_1} R] →
    @Module.{u_1, u_1} R R inst
      (@NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R
        (@NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R (@Semiring.toNonAssocSemiring.{u_1} R inst)))
```

Definition body (one-level semantic boundary):

```lean
fun {R} [Semiring R] =>
  { toMulAction := (MonoidWithZero.toMulActionWithZero R).toMulAction, smul_zero := ⋯, smul_add := ⋯, add_smul := ⋯,
    zero_smul := ⋯ }
```

### D425: `Semiring.toMonoidWithZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D426: `SubNegZeroMonoid.toNegZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D427: `SubtractionCommMonoid.toSubtractionMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `7`
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

### D428: `SubtractionMonoid.toSubNegZeroMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Basic`
- Declaration kind: `def`
- Distance from target type: `7`
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

### D429: `UniformContinuousConstSMul.to_continuousConstSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.UniformMulAction`
- Declaration kind: `theorem`
- Distance from target type: `7`
- Semantic SHA-256: `1fc099f3b0aae146bf9d226579fcc3612c4e9735c5ac8407ac17ff4201d2d1a3`

Type:

```lean
∀ (M : Type v) (X : Type x) [inst : UniformSpace X] [inst_1 : SMul M X] [UniformContinuousConstSMul M X],
  ContinuousConstSMul M X
```

Fully explicit type:

```lean
∀ (M : Type v) (X : Type x) [inst : UniformSpace.{x} X] [inst_1 : SMul.{v, x} M X]
  [@UniformContinuousConstSMul.{v, x} M X inst inst_1],
  @ContinuousConstSMul.{v, x} M X (@UniformSpace.toTopologicalSpace.{x} X inst) inst_1
```

### D430: `instDecidableEqFin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `7`
- Semantic SHA-256: `7f6d785554f797d18d5ae0b7475c25e8deca421e6ee688f036987ac99c66e1cd`

Type:

```lean
(n : Nat) → DecidableEq (Fin n)
```

Fully explicit type:

```lean
(n : Nat) → DecidableEq.{1} (Fin n)
```

Definition body (one-level semantic boundary):

```lean
fun n i j =>
  instDecidableEqFin.match_1 n i j (fun x => Decidable (Eq i j)) (decEq i.val j.val) (fun h => Decidable.isTrue ⋯)
    fun h => Decidable.isFalse ⋯
```

### D431: `CommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `1c9ac43c2f2e02a3e345036ace32d209b04abe0516407e31bcb54ee4c7201d0d`

Type:

```lean
{α : Type u} → [s : CommRing α] → NonUnitalCommRing α
```

Fully explicit type:

```lean
{α : Type u} → [s : CommRing.{u} α] → NonUnitalCommRing.{u} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [s : CommRing α] =>
  { toAddMonoid := s.toAddMonoid, toNeg := s.toNeg, toSub := s.toSub, sub_eq_add_neg := ⋯, zsmul := s.zsmul,
    zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯, toMul := s.toMul,
    left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯, mul_comm := ⋯ }
```

### D432: `ContinuousMultilinearMap.curry0`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Multilinear.Curry`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `db5d48b12e67dc70427fb54ad44d7e1c0ec9caa74a5bfca8e15f36835b30a1bc`

Type:

```lean
{𝕜 : Type u} →
  {G : Type wG} →
    {G' : Type wG'} →
      [inst : NontriviallyNormedField 𝕜] →
        [inst_1 : NormedAddCommGroup G] →
          [inst_2 : NormedSpace 𝕜 G] →
            [inst_3 : NormedAddCommGroup G'] →
              [inst_4 : NormedSpace 𝕜 G'] → ContinuousMultilinearMap 𝕜 (fun x => G) G' → G'
```

Fully explicit type:

```lean
{𝕜 : Type u} →
  {G : Type wG} →
    {G' : Type wG'} →
      [inst : NontriviallyNormedField.{u} 𝕜] →
        [inst_1 : NormedAddCommGroup.{wG} G] →
          [inst_2 :
              @NormedSpace.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_1)] →
            [inst_3 : NormedAddCommGroup.{wG'} G'] →
              [inst_4 :
                  @NormedSpace.{u, wG'} 𝕜 G' (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG'} G' inst_3)] →
                (f :
                    @ContinuousMultilinearMap.{u, 0, wG, wG'} 𝕜
                      (Fin (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))))
                      (fun (x : Fin (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))) => G) G'
                      (@DivisionSemiring.toSemiring.{u} 𝕜
                        (@Semifield.toDivisionSemiring.{u} 𝕜
                          (@Field.toSemifield.{u} 𝕜
                            (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                      (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))) =>
                        @ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                          (@UniformSpace.toTopologicalSpace.{wG} G
                            (@PseudoMetricSpace.toUniformSpace.{wG} G
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_1))))
                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                            (@UniformSpace.toTopologicalSpace.{wG} G
                              (@PseudoMetricSpace.toUniformSpace.{wG} G
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_1))))
                            (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_1)))
                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG'} G'
                        (@UniformSpace.toTopologicalSpace.{wG'} G'
                          (@PseudoMetricSpace.toUniformSpace.{wG'} G'
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG'} G'
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG'} G' inst_3))))
                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG'} G'
                          (@UniformSpace.toTopologicalSpace.{wG'} G'
                            (@PseudoMetricSpace.toUniformSpace.{wG'} G'
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG'} G'
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG'} G' inst_3))))
                          (@NormedAddCommGroup.toENormedAddCommMonoid.{wG'} G' inst_3)))
                      (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))) =>
                        @NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_1) inst_2)
                      (@NormedSpace.toModule.{u, wG'} 𝕜 G' (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG'} G' inst_3) inst_4)
                      (fun (i : Fin (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0)))) =>
                        @UniformSpace.toTopologicalSpace.{wG} G
                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_1))))
                      (@UniformSpace.toTopologicalSpace.{wG'} G'
                        (@PseudoMetricSpace.toUniformSpace.{wG'} G'
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG'} G'
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG'} G' inst_3))))) →
                  G'
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} {G} {G'} [NontriviallyNormedField 𝕜] [NormedAddCommGroup G] [NormedSpace 𝕜 G] [NormedAddCommGroup G']
    [NormedSpace 𝕜 G'] f =>
  ContinuousMultilinearMap.funLike.coe f 0
```

### D433: `ContinuousMultilinearMap.curryLeft`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Multilinear.Curry`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `1b0757822166d7b1d6ddad2ac10bb9b13b620cdc42f76d4c7d1e4e019579ab4f`

Type:

```lean
{𝕜 : Type u} →
  {n : Nat} →
    {Ei : Fin n.succ → Type wEi} →
      {G : Type wG} →
        [inst : NontriviallyNormedField 𝕜] →
          [inst_1 : (i : Fin n.succ) → NormedAddCommGroup (Ei i)] →
            [inst_2 : (i : Fin n.succ) → NormedSpace 𝕜 (Ei i)] →
              [inst_3 : NormedAddCommGroup G] →
                [inst_4 : NormedSpace 𝕜 G] →
                  ContinuousMultilinearMap 𝕜 Ei G →
                    ContinuousLinearMap (RingHom.id 𝕜) (Ei 0) (ContinuousMultilinearMap 𝕜 (fun i => Ei i.succ) G)
```

Fully explicit type:

```lean
{𝕜 : Type u} →
  {n : Nat} →
    {Ei : Fin (Nat.succ n) → Type wEi} →
      {G : Type wG} →
        [inst : NontriviallyNormedField.{u} 𝕜] →
          [inst_1 : (i : Fin (Nat.succ n)) → NormedAddCommGroup.{wEi} (Ei i)] →
            [inst_2 :
                (i : Fin (Nat.succ n)) →
                  @NormedSpace.{u, wEi} 𝕜 (Ei i) (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei i) (inst_1 i))] →
              [inst_3 : NormedAddCommGroup.{wG} G] →
                [inst_4 :
                    @NormedSpace.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3)] →
                  (f :
                      @ContinuousMultilinearMap.{u, 0, wEi, wG} 𝕜 (Fin (Nat.succ n)) Ei G
                        (@DivisionSemiring.toSemiring.{u} 𝕜
                          (@Semifield.toDivisionSemiring.{u} 𝕜
                            (@Field.toSemifield.{u} 𝕜
                              (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                        (fun (i : Fin (Nat.succ n)) =>
                          @ESeminormedAddCommMonoid.toAddCommMonoid.{wEi} (Ei i)
                            (@UniformSpace.toTopologicalSpace.{wEi} (Ei i)
                              (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei i)
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei i)
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei i) (inst_1 i)))))
                            (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wEi} (Ei i)
                              (@UniformSpace.toTopologicalSpace.{wEi} (Ei i)
                                (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei i)
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei i)
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei i) (inst_1 i)))))
                              (@NormedAddCommGroup.toENormedAddCommMonoid.{wEi} (Ei i) (inst_1 i))))
                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                          (@UniformSpace.toTopologicalSpace.{wG} G
                            (@PseudoMetricSpace.toUniformSpace.{wG} G
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                            (@UniformSpace.toTopologicalSpace.{wG} G
                              (@PseudoMetricSpace.toUniformSpace.{wG} G
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                            (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))
                        (fun (i : Fin (Nat.succ n)) =>
                          @NormedSpace.toModule.{u, wEi} 𝕜 (Ei i) (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei i) (inst_1 i)) (inst_2 i))
                        (@NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3) inst_4)
                        (fun (i : Fin (Nat.succ n)) =>
                          @UniformSpace.toTopologicalSpace.{wEi} (Ei i)
                            (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei i)
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei i)
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei i) (inst_1 i)))))
                        (@UniformSpace.toTopologicalSpace.{wG} G
                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))) →
                    @ContinuousLinearMap.{u, u, wEi, max wG wEi} 𝕜 𝕜
                      (@DivisionSemiring.toSemiring.{u} 𝕜
                        (@Semifield.toDivisionSemiring.{u} 𝕜
                          (@Field.toSemifield.{u} 𝕜
                            (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                      (@DivisionSemiring.toSemiring.{u} 𝕜
                        (@Semifield.toDivisionSemiring.{u} 𝕜
                          (@Field.toSemifield.{u} 𝕜
                            (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                      (@RingHom.id.{u} 𝕜
                        (@Semiring.toNonAssocSemiring.{u} 𝕜
                          (@DivisionSemiring.toSemiring.{u} 𝕜
                            (@Semifield.toDivisionSemiring.{u} 𝕜
                              (@Field.toSemifield.{u} 𝕜
                                (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                      (Ei
                        (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                          (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                      (@UniformSpace.toTopologicalSpace.{wEi}
                        (Ei
                          (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                            (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                        (@PseudoMetricSpace.toUniformSpace.{wEi}
                          (Ei
                            (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                              (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi}
                            (Ei
                              (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi}
                              (Ei
                                (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                  (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                              (inst_1
                                (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                  (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))))))
                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{wEi}
                        (Ei
                          (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                            (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                        (@UniformSpace.toTopologicalSpace.{wEi}
                          (Ei
                            (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                              (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                          (@PseudoMetricSpace.toUniformSpace.{wEi}
                            (Ei
                              (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi}
                              (Ei
                                (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                  (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi}
                                (Ei
                                  (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                    (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                                (inst_1
                                  (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                    (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))))))
                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wEi}
                          (Ei
                            (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                              (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                          (@UniformSpace.toTopologicalSpace.{wEi}
                            (Ei
                              (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                            (@PseudoMetricSpace.toUniformSpace.{wEi}
                              (Ei
                                (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                  (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi}
                                (Ei
                                  (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                    (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi}
                                  (Ei
                                    (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                      (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                                  (inst_1
                                    (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                      (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))))))
                          (@NormedAddCommGroup.toENormedAddCommMonoid.{wEi}
                            (Ei
                              (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                            (inst_1
                              (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                                (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0)))))))
                      (@ContinuousMultilinearMap.{u, 0, wEi, wG} 𝕜 (Fin n) (fun (i : Fin n) => Ei (@Fin.succ n i)) G
                        (@DivisionSemiring.toSemiring.{u} 𝕜
                          (@Semifield.toDivisionSemiring.{u} 𝕜
                            (@Field.toSemifield.{u} 𝕜
                              (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                        (fun (i : Fin n) =>
                          @ESeminormedAddCommMonoid.toAddCommMonoid.{wEi} (Ei (@Fin.succ n i))
                            (@UniformSpace.toTopologicalSpace.{wEi} (Ei (@Fin.succ n i))
                              (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei (@Fin.succ n i))
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei (@Fin.succ n i))
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                                    (inst_1 (@Fin.succ n i))))))
                            (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wEi} (Ei (@Fin.succ n i))
                              (@UniformSpace.toTopologicalSpace.{wEi} (Ei (@Fin.succ n i))
                                (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei (@Fin.succ n i))
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei (@Fin.succ n i))
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                                      (inst_1 (@Fin.succ n i))))))
                              (@NormedAddCommGroup.toENormedAddCommMonoid.{wEi} (Ei (@Fin.succ n i))
                                (inst_1 (@Fin.succ n i)))))
                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                          (@UniformSpace.toTopologicalSpace.{wG} G
                            (@PseudoMetricSpace.toUniformSpace.{wG} G
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                            (@UniformSpace.toTopologicalSpace.{wG} G
                              (@PseudoMetricSpace.toUniformSpace.{wG} G
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                            (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))
                        (fun (i : Fin n) =>
                          @NormedSpace.toModule.{u, wEi} 𝕜 (Ei (@Fin.succ n i))
                            (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                              (inst_1 (@Fin.succ n i)))
                            (inst_2 (@Fin.succ n i)))
                        (@NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3) inst_4)
                        (fun (i : Fin n) =>
                          @UniformSpace.toTopologicalSpace.{wEi} (Ei (@Fin.succ n i))
                            (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei (@Fin.succ n i))
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei (@Fin.succ n i))
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                                  (inst_1 (@Fin.succ n i))))))
                        (@UniformSpace.toTopologicalSpace.{wG} G
                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3)))))
                      (@ContinuousMultilinearMap.instTopologicalSpace.{u, 0, wEi, wG} 𝕜 (Fin n)
                        (fun (i : Fin n) => Ei (@Fin.succ n i)) G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                        (fun (i : Fin n) =>
                          @UniformSpace.toTopologicalSpace.{wEi} (Ei (@Fin.succ n i))
                            (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei (@Fin.succ n i))
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei (@Fin.succ n i))
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                                  (inst_1 (@Fin.succ n i))))))
                        (fun (i : Fin n) =>
                          @NormedAddCommGroup.toAddCommGroup.{wEi} (Ei (@Fin.succ n i)) (inst_1 (@Fin.succ n i)))
                        (fun (i : Fin n) =>
                          @NormedSpace.toModule.{u, wEi} 𝕜 (Ei (@Fin.succ n i))
                            (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                              (inst_1 (@Fin.succ n i)))
                            (inst_2 (@Fin.succ n i)))
                        (@NormedAddCommGroup.toAddCommGroup.{wG} G inst_3)
                        (@NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3) inst_4)
                        (@UniformSpace.toTopologicalSpace.{wG} G
                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                        (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{wG} G
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3)))
                      (@ContinuousMultilinearMap.addCommMonoid.{u, 0, wEi, wG} 𝕜 (Fin n)
                        (fun (i : Fin n) => Ei (@Fin.succ n i)) G
                        (@DivisionSemiring.toSemiring.{u} 𝕜
                          (@Semifield.toDivisionSemiring.{u} 𝕜
                            (@Field.toSemifield.{u} 𝕜
                              (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                        (fun (i : Fin n) =>
                          @ESeminormedAddCommMonoid.toAddCommMonoid.{wEi} (Ei (@Fin.succ n i))
                            (@UniformSpace.toTopologicalSpace.{wEi} (Ei (@Fin.succ n i))
                              (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei (@Fin.succ n i))
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei (@Fin.succ n i))
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                                    (inst_1 (@Fin.succ n i))))))
                            (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wEi} (Ei (@Fin.succ n i))
                              (@UniformSpace.toTopologicalSpace.{wEi} (Ei (@Fin.succ n i))
                                (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei (@Fin.succ n i))
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei (@Fin.succ n i))
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                                      (inst_1 (@Fin.succ n i))))))
                              (@NormedAddCommGroup.toENormedAddCommMonoid.{wEi} (Ei (@Fin.succ n i))
                                (inst_1 (@Fin.succ n i)))))
                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                          (@UniformSpace.toTopologicalSpace.{wG} G
                            (@PseudoMetricSpace.toUniformSpace.{wG} G
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                            (@UniformSpace.toTopologicalSpace.{wG} G
                              (@PseudoMetricSpace.toUniformSpace.{wG} G
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                            (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))
                        (fun (i : Fin n) =>
                          @NormedSpace.toModule.{u, wEi} 𝕜 (Ei (@Fin.succ n i))
                            (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                              (inst_1 (@Fin.succ n i)))
                            (inst_2 (@Fin.succ n i)))
                        (@NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3) inst_4)
                        (fun (i : Fin n) =>
                          @UniformSpace.toTopologicalSpace.{wEi} (Ei (@Fin.succ n i))
                            (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei (@Fin.succ n i))
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei (@Fin.succ n i))
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                                  (inst_1 (@Fin.succ n i))))))
                        (@UniformSpace.toTopologicalSpace.{wG} G
                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                        (@IsTopologicalAddGroup.toContinuousAdd.{wG} G
                          (@UniformSpace.toTopologicalSpace.{wG} G
                            (@PseudoMetricSpace.toUniformSpace.{wG} G
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                          (@NormedAddGroup.toAddGroup.{wG} G (@NormedAddCommGroup.toNormedAddGroup.{wG} G inst_3))
                          (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{wG} G
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                      (@NormedSpace.toModule.{u, wEi} 𝕜
                        (Ei
                          (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                            (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                        (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi}
                          (Ei
                            (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                              (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0))))
                          (inst_1
                            (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                              (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0)))))
                        (inst_2
                          (@OfNat.ofNat.{0} (Fin (Nat.succ n)) (nat_lit 0)
                            (@Fin.instOfNat (Nat.succ n) (@Nat.instNeZeroSucc n) (nat_lit 0)))))
                      (@ContinuousMultilinearMap.instModule.{0, wEi, wG, u, u} (Fin n)
                        (fun (i : Fin n) => Ei (@Fin.succ n i)) G 𝕜 𝕜
                        (@DivisionSemiring.toSemiring.{u} 𝕜
                          (@Semifield.toDivisionSemiring.{u} 𝕜
                            (@Field.toSemifield.{u} 𝕜
                              (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                        (@DivisionSemiring.toSemiring.{u} 𝕜
                          (@Semifield.toDivisionSemiring.{u} 𝕜
                            (@Field.toSemifield.{u} 𝕜
                              (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                        (fun (i : Fin n) =>
                          @ESeminormedAddCommMonoid.toAddCommMonoid.{wEi} (Ei (@Fin.succ n i))
                            (@UniformSpace.toTopologicalSpace.{wEi} (Ei (@Fin.succ n i))
                              (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei (@Fin.succ n i))
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei (@Fin.succ n i))
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                                    (inst_1 (@Fin.succ n i))))))
                            (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wEi} (Ei (@Fin.succ n i))
                              (@UniformSpace.toTopologicalSpace.{wEi} (Ei (@Fin.succ n i))
                                (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei (@Fin.succ n i))
                                  (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei (@Fin.succ n i))
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                                      (inst_1 (@Fin.succ n i))))))
                              (@NormedAddCommGroup.toENormedAddCommMonoid.{wEi} (Ei (@Fin.succ n i))
                                (inst_1 (@Fin.succ n i)))))
                        (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                          (@UniformSpace.toTopologicalSpace.{wG} G
                            (@PseudoMetricSpace.toUniformSpace.{wG} G
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                          (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                            (@UniformSpace.toTopologicalSpace.{wG} G
                              (@PseudoMetricSpace.toUniformSpace.{wG} G
                                (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                            (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))
                        (fun (i : Fin n) =>
                          @UniformSpace.toTopologicalSpace.{wEi} (Ei (@Fin.succ n i))
                            (@PseudoMetricSpace.toUniformSpace.{wEi} (Ei (@Fin.succ n i))
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wEi} (Ei (@Fin.succ n i))
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                                  (inst_1 (@Fin.succ n i))))))
                        (@UniformSpace.toTopologicalSpace.{wG} G
                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                        (@IsTopologicalAddGroup.toContinuousAdd.{wG} G
                          (@UniformSpace.toTopologicalSpace.{wG} G
                            (@PseudoMetricSpace.toUniformSpace.{wG} G
                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                          (@NormedAddGroup.toAddGroup.{wG} G (@NormedAddCommGroup.toNormedAddGroup.{wG} G inst_3))
                          (@SeminormedAddCommGroup.toIsTopologicalAddGroup.{wG} G
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3)))
                        (fun (i : Fin n) =>
                          @NormedSpace.toModule.{u, wEi} 𝕜 (Ei (@Fin.succ n i))
                            (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wEi} (Ei (@Fin.succ n i))
                              (inst_1 (@Fin.succ n i)))
                            (inst_2 (@Fin.succ n i)))
                        (@NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3) inst_4)
                        (@NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3) inst_4)
                        (@UniformContinuousConstSMul.to_continuousConstSMul.{u, wG} 𝕜 G
                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3)))
                          (@SMulZeroClass.toSMul.{u, wG} 𝕜 G
                            (@AddZero.toZero.{wG} G
                              (@AddZeroClass.toAddZero.{wG} G
                                (@AddMonoid.toAddZeroClass.{wG} G
                                  (@AddCommMonoid.toAddMonoid.{wG} G
                                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                                      (@UniformSpace.toTopologicalSpace.{wG} G
                                        (@PseudoMetricSpace.toUniformSpace.{wG} G
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                                        (@UniformSpace.toTopologicalSpace.{wG} G
                                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                        (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))))))
                            (@DistribSMul.toSMulZeroClass.{u, wG} 𝕜 G
                              (@AddMonoid.toAddZeroClass.{wG} G
                                (@AddCommMonoid.toAddMonoid.{wG} G
                                  (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                                    (@UniformSpace.toTopologicalSpace.{wG} G
                                      (@PseudoMetricSpace.toUniformSpace.{wG} G
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                                      (@UniformSpace.toTopologicalSpace.{wG} G
                                        (@PseudoMetricSpace.toUniformSpace.{wG} G
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                      (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))))
                              (@DistribMulAction.toDistribSMul.{u, wG} 𝕜 G
                                (@MonoidWithZero.toMonoid.{u} 𝕜
                                  (@Semiring.toMonoidWithZero.{u} 𝕜
                                    (@DivisionSemiring.toSemiring.{u} 𝕜
                                      (@Semifield.toDivisionSemiring.{u} 𝕜
                                        (@Field.toSemifield.{u} 𝕜
                                          (@NormedField.toField.{u} 𝕜
                                            (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                                (@AddCommMonoid.toAddMonoid.{wG} G
                                  (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                                    (@UniformSpace.toTopologicalSpace.{wG} G
                                      (@PseudoMetricSpace.toUniformSpace.{wG} G
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                                      (@UniformSpace.toTopologicalSpace.{wG} G
                                        (@PseudoMetricSpace.toUniformSpace.{wG} G
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                      (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3))))
                                (@Module.toDistribMulAction.{u, wG} 𝕜 G
                                  (@DivisionSemiring.toSemiring.{u} 𝕜
                                    (@Semifield.toDivisionSemiring.{u} 𝕜
                                      (@Field.toSemifield.{u} 𝕜
                                        (@NormedField.toField.{u} 𝕜
                                          (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                                  (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                                    (@UniformSpace.toTopologicalSpace.{wG} G
                                      (@PseudoMetricSpace.toUniformSpace.{wG} G
                                        (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                          (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                    (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                                      (@UniformSpace.toTopologicalSpace.{wG} G
                                        (@PseudoMetricSpace.toUniformSpace.{wG} G
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                      (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))
                                  (@NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                                    (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3) inst_4)))))
                          (@IsBoundedSMul.toUniformContinuousConstSMul.{u, wG} 𝕜 G
                            (@SeminormedRing.toPseudoMetricSpace.{u} 𝕜
                              (@SeminormedCommRing.toSeminormedRing.{u} 𝕜
                                (@NormedCommRing.toSeminormedCommRing.{u} 𝕜
                                  (@NormedField.toNormedCommRing.{u} 𝕜
                                    (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))
                            (@MulZeroClass.toZero.{u} 𝕜
                              (@NonUnitalNonAssocSemiring.toMulZeroClass.{u} 𝕜
                                (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} 𝕜
                                  (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} 𝕜
                                    (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u} 𝕜
                                      (@NonUnitalNormedCommRing.toNonUnitalCommRing.{u} 𝕜
                                        (@NormedCommRing.toNonUnitalNormedCommRing.{u} 𝕜
                                          (@NormedField.toNormedCommRing.{u} 𝕜
                                            (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))))
                            (@NegZeroClass.toZero.{wG} G
                              (@SubNegZeroMonoid.toNegZeroClass.{wG} G
                                (@SubtractionMonoid.toSubNegZeroMonoid.{wG} G
                                  (@SubtractionCommMonoid.toSubtractionMonoid.{wG} G
                                    (@AddCommGroup.toDivisionAddCommMonoid.{wG} G
                                      (@NormedAddCommGroup.toAddCommGroup.{wG} G inst_3))))))
                            (@SMulZeroClass.toSMul.{u, wG} 𝕜 G
                              (@AddZero.toZero.{wG} G
                                (@AddZeroClass.toAddZero.{wG} G
                                  (@AddMonoid.toAddZeroClass.{wG} G
                                    (@AddCommMonoid.toAddMonoid.{wG} G
                                      (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                                        (@UniformSpace.toTopologicalSpace.{wG} G
                                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                        (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                                          (@UniformSpace.toTopologicalSpace.{wG} G
                                            (@PseudoMetricSpace.toUniformSpace.{wG} G
                                              (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                          (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))))))
                              (@DistribSMul.toSMulZeroClass.{u, wG} 𝕜 G
                                (@AddMonoid.toAddZeroClass.{wG} G
                                  (@AddCommMonoid.toAddMonoid.{wG} G
                                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                                      (@UniformSpace.toTopologicalSpace.{wG} G
                                        (@PseudoMetricSpace.toUniformSpace.{wG} G
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                                        (@UniformSpace.toTopologicalSpace.{wG} G
                                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                        (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))))
                                (@DistribMulAction.toDistribSMul.{u, wG} 𝕜 G
                                  (@MonoidWithZero.toMonoid.{u} 𝕜
                                    (@Semiring.toMonoidWithZero.{u} 𝕜
                                      (@DivisionSemiring.toSemiring.{u} 𝕜
                                        (@Semifield.toDivisionSemiring.{u} 𝕜
                                          (@Field.toSemifield.{u} 𝕜
                                            (@NormedField.toField.{u} 𝕜
                                              (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))))
                                  (@AddCommMonoid.toAddMonoid.{wG} G
                                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                                      (@UniformSpace.toTopologicalSpace.{wG} G
                                        (@PseudoMetricSpace.toUniformSpace.{wG} G
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                                        (@UniformSpace.toTopologicalSpace.{wG} G
                                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                        (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3))))
                                  (@Module.toDistribMulAction.{u, wG} 𝕜 G
                                    (@DivisionSemiring.toSemiring.{u} 𝕜
                                      (@Semifield.toDivisionSemiring.{u} 𝕜
                                        (@Field.toSemifield.{u} 𝕜
                                          (@NormedField.toField.{u} 𝕜
                                            (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                                    (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                                      (@UniformSpace.toTopologicalSpace.{wG} G
                                        (@PseudoMetricSpace.toUniformSpace.{wG} G
                                          (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                            (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                      (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                                        (@UniformSpace.toTopologicalSpace.{wG} G
                                          (@PseudoMetricSpace.toUniformSpace.{wG} G
                                            (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                        (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))
                                    (@NormedSpace.toModule.{u, wG} 𝕜 G
                                      (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3) inst_4)))))
                            (@NormedSpace.toIsBoundedSMul.{u, wG} 𝕜 G
                              (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                              (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3) inst_4)))
                        (@smulCommClass_self.{u, wG} 𝕜 G
                          (@CommRing.toCommMonoid.{u} 𝕜
                            (@Field.toCommRing.{u} 𝕜
                              (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst))))
                          (@DistribMulAction.toMulAction.{u, wG} 𝕜 G
                            (@CommMonoid.toMonoid.{u} 𝕜
                              (@CommRing.toCommMonoid.{u} 𝕜
                                (@Field.toCommRing.{u} 𝕜
                                  (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                            (@AddCommMonoid.toAddMonoid.{wG} G
                              (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                                (@UniformSpace.toTopologicalSpace.{wG} G
                                  (@PseudoMetricSpace.toUniformSpace.{wG} G
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                                  (@UniformSpace.toTopologicalSpace.{wG} G
                                    (@PseudoMetricSpace.toUniformSpace.{wG} G
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                  (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3))))
                            (@Module.toDistribMulAction.{u, wG} 𝕜 G
                              (@DivisionSemiring.toSemiring.{u} 𝕜
                                (@Semifield.toDivisionSemiring.{u} 𝕜
                                  (@Field.toSemifield.{u} 𝕜
                                    (@NormedField.toField.{u} 𝕜 (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)))))
                              (@ESeminormedAddCommMonoid.toAddCommMonoid.{wG} G
                                (@UniformSpace.toTopologicalSpace.{wG} G
                                  (@PseudoMetricSpace.toUniformSpace.{wG} G
                                    (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                (@ENormedAddCommMonoid.toESeminormedAddCommMonoid.{wG} G
                                  (@UniformSpace.toTopologicalSpace.{wG} G
                                    (@PseudoMetricSpace.toUniformSpace.{wG} G
                                      (@SeminormedAddCommGroup.toPseudoMetricSpace.{wG} G
                                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3))))
                                  (@NormedAddCommGroup.toENormedAddCommMonoid.{wG} G inst_3)))
                              (@NormedSpace.toModule.{u, wG} 𝕜 G (@NontriviallyNormedField.toNormedField.{u} 𝕜 inst)
                                (@NormedAddCommGroup.toSeminormedAddCommGroup.{wG} G inst_3) inst_4)))))
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} {n} {Ei} {G} [NontriviallyNormedField 𝕜] [(i : Fin n.succ) → NormedAddCommGroup (Ei i)]
    [(i : Fin n.succ) → NormedSpace 𝕜 (Ei i)] [NormedAddCommGroup G] [NormedSpace 𝕜 G] f =>
  MultilinearMap.mkContinuousLinear f.curryLeft (ContinuousMultilinearMap.hasOpNorm.norm f) ⋯
```

### D434: `ContinuousMultilinearMap.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.Multilinear.Basic`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `ad9085fb678260707d2e893d1b8a670708a8b3016e50b5993e5c9d3eb48900a2`

Type:

```lean
{R : Type u} →
  {ι : Type v} →
    {M₁ : ι → Type w₁} →
      {M₂ : Type w₂} →
        [inst : Ring R] →
          [inst_1 : (i : ι) → AddCommGroup (M₁ i)] →
            [inst_2 : AddCommGroup M₂] →
              [inst_3 : (i : ι) → Module R (M₁ i)] →
                [inst_4 : Module R M₂] →
                  [inst_5 : (i : ι) → TopologicalSpace (M₁ i)] →
                    [inst_6 : TopologicalSpace M₂] →
                      [IsTopologicalAddGroup M₂] → AddCommGroup (ContinuousMultilinearMap R M₁ M₂)
```

Fully explicit type:

```lean
{R : Type u} →
  {ι : Type v} →
    {M₁ : ι → Type w₁} →
      {M₂ : Type w₂} →
        [inst : Ring.{u} R] →
          [inst_1 : (i : ι) → AddCommGroup.{w₁} (M₁ i)] →
            [inst_2 : AddCommGroup.{w₂} M₂] →
              [inst_3 :
                  (i : ι) →
                    @Module.{u, w₁} R (M₁ i) (@Ring.toSemiring.{u} R inst)
                      (@AddCommGroup.toAddCommMonoid.{w₁} (M₁ i) (inst_1 i))] →
                [inst_4 :
                    @Module.{u, w₂} R M₂ (@Ring.toSemiring.{u} R inst) (@AddCommGroup.toAddCommMonoid.{w₂} M₂ inst_2)] →
                  [inst_5 : (i : ι) → TopologicalSpace.{w₁} (M₁ i)] →
                    [inst_6 : TopologicalSpace.{w₂} M₂] →
                      [@IsTopologicalAddGroup.{w₂} M₂ inst_6 (@AddCommGroup.toAddGroup.{w₂} M₂ inst_2)] →
                        AddCommGroup.{max (max w₂ w₁) v}
                          (@ContinuousMultilinearMap.{u, v, w₁, w₂} R ι M₁ M₂ (@Ring.toSemiring.{u} R inst)
                            (fun (i : ι) => @AddCommGroup.toAddCommMonoid.{w₁} (M₁ i) (inst_1 i))
                            (@AddCommGroup.toAddCommMonoid.{w₂} M₂ inst_2) inst_3 inst_4 inst_5 inst_6)
```

Definition body (one-level semantic boundary):

```lean
fun {R} {ι} {M₁} {M₂} [Ring R] [(i : ι) → AddCommGroup (M₁ i)] [AddCommGroup M₂] [(i : ι) → Module R (M₁ i)]
    [Module R M₂] [(i : ι) → TopologicalSpace (M₁ i)] [TopologicalSpace M₂] [IsTopologicalAddGroup M₂] =>
  { toAddMonoid := ContinuousMultilinearMap.addCommMonoid.toAddMonoid, toNeg := ContinuousMultilinearMap.instNeg,
    toSub := ContinuousMultilinearMap.instSub, sub_eq_add_neg := ⋯,
    zsmul := (Function.Injective.addGroup ContinuousMultilinearMap.toMultilinearMap ⋯ ⋯ ⋯ ⋯ ⋯ ⋯ ⋯).zsmul,
    zsmul_zero' := ⋯, zsmul_succ' := ⋯, zsmul_neg' := ⋯, neg_add_cancel := ⋯, add_comm := ⋯ }
```

### D435: `ContinuousMultilinearMap.instModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.Multilinear.Basic`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `28c76183f7aa8be67a291d5c6e1c721071ab84ba7b1020c2a8182760a4cdce0b`

Type:

```lean
{ι : Type v} →
  {M₁ : ι → Type w₁} →
    {M₂ : Type w₂} →
      {R' : Type u_1} →
        {A : Type u_2} →
          [inst : Semiring R'] →
            [inst_1 : Semiring A] →
              [inst_2 : (i : ι) → AddCommMonoid (M₁ i)] →
                [inst_3 : AddCommMonoid M₂] →
                  [inst_4 : (i : ι) → TopologicalSpace (M₁ i)] →
                    [inst_5 : TopologicalSpace M₂] →
                      [inst_6 : ContinuousAdd M₂] →
                        [inst_7 : (i : ι) → Module A (M₁ i)] →
                          [inst_8 : Module A M₂] →
                            [inst_9 : Module R' M₂] →
                              [ContinuousConstSMul R' M₂] →
                                [SMulCommClass A R' M₂] → Module R' (ContinuousMultilinearMap A M₁ M₂)
```

Fully explicit type:

```lean
{ι : Type v} →
  {M₁ : ι → Type w₁} →
    {M₂ : Type w₂} →
      {R' : Type u_1} →
        {A : Type u_2} →
          [inst : Semiring.{u_1} R'] →
            [inst_1 : Semiring.{u_2} A] →
              [inst_2 : (i : ι) → AddCommMonoid.{w₁} (M₁ i)] →
                [inst_3 : AddCommMonoid.{w₂} M₂] →
                  [inst_4 : (i : ι) → TopologicalSpace.{w₁} (M₁ i)] →
                    [inst_5 : TopologicalSpace.{w₂} M₂] →
                      [inst_6 :
                          @ContinuousAdd.{w₂} M₂ inst_5
                            (@AddCommMagma.toAdd.{w₂} M₂
                              (@AddCommSemigroup.toAddCommMagma.{w₂} M₂
                                (@AddCommMonoid.toAddCommSemigroup.{w₂} M₂ inst_3)))] →
                        [inst_7 : (i : ι) → @Module.{u_2, w₁} A (M₁ i) inst_1 (inst_2 i)] →
                          [inst_8 : @Module.{u_2, w₂} A M₂ inst_1 inst_3] →
                            [inst_9 : @Module.{u_1, w₂} R' M₂ inst inst_3] →
                              [@ContinuousConstSMul.{u_1, w₂} R' M₂ inst_5
                                    (@SMulZeroClass.toSMul.{u_1, w₂} R' M₂
                                      (@AddZero.toZero.{w₂} M₂
                                        (@AddZeroClass.toAddZero.{w₂} M₂
                                          (@AddMonoid.toAddZeroClass.{w₂} M₂
                                            (@AddCommMonoid.toAddMonoid.{w₂} M₂ inst_3))))
                                      (@DistribSMul.toSMulZeroClass.{u_1, w₂} R' M₂
                                        (@AddMonoid.toAddZeroClass.{w₂} M₂ (@AddCommMonoid.toAddMonoid.{w₂} M₂ inst_3))
                                        (@DistribMulAction.toDistribSMul.{u_1, w₂} R' M₂
                                          (@MonoidWithZero.toMonoid.{u_1} R' (@Semiring.toMonoidWithZero.{u_1} R' inst))
                                          (@AddCommMonoid.toAddMonoid.{w₂} M₂ inst_3)
                                          (@Module.toDistribMulAction.{u_1, w₂} R' M₂ inst inst_3 inst_9))))] →
                                [@SMulCommClass.{u_2, u_1, w₂} A R' M₂
                                      (@SMulZeroClass.toSMul.{u_2, w₂} A M₂
                                        (@AddZero.toZero.{w₂} M₂
                                          (@AddZeroClass.toAddZero.{w₂} M₂
                                            (@AddMonoid.toAddZeroClass.{w₂} M₂
                                              (@AddCommMonoid.toAddMonoid.{w₂} M₂ inst_3))))
                                        (@DistribSMul.toSMulZeroClass.{u_2, w₂} A M₂
                                          (@AddMonoid.toAddZeroClass.{w₂} M₂
                                            (@AddCommMonoid.toAddMonoid.{w₂} M₂ inst_3))
                                          (@DistribMulAction.toDistribSMul.{u_2, w₂} A M₂
                                            (@MonoidWithZero.toMonoid.{u_2} A
                                              (@Semiring.toMonoidWithZero.{u_2} A inst_1))
                                            (@AddCommMonoid.toAddMonoid.{w₂} M₂ inst_3)
                                            (@Module.toDistribMulAction.{u_2, w₂} A M₂ inst_1 inst_3 inst_8))))
                                      (@SMulZeroClass.toSMul.{u_1, w₂} R' M₂
                                        (@AddZero.toZero.{w₂} M₂
                                          (@AddZeroClass.toAddZero.{w₂} M₂
                                            (@AddMonoid.toAddZeroClass.{w₂} M₂
                                              (@AddCommMonoid.toAddMonoid.{w₂} M₂ inst_3))))
                                        (@DistribSMul.toSMulZeroClass.{u_1, w₂} R' M₂
                                          (@AddMonoid.toAddZeroClass.{w₂} M₂
                                            (@AddCommMonoid.toAddMonoid.{w₂} M₂ inst_3))
                                          (@DistribMulAction.toDistribSMul.{u_1, w₂} R' M₂
                                            (@MonoidWithZero.toMonoid.{u_1} R'
                                              (@Semiring.toMonoidWithZero.{u_1} R' inst))
                                            (@AddCommMonoid.toAddMonoid.{w₂} M₂ inst_3)
                                            (@Module.toDistribMulAction.{u_1, w₂} R' M₂ inst inst_3 inst_9))))] →
                                  @Module.{u_1, max (max w₂ w₁) v} R'
                                    (@ContinuousMultilinearMap.{u_2, v, w₁, w₂} A ι M₁ M₂ inst_1 inst_2 inst_3 inst_7
                                      inst_8 inst_4 inst_5)
                                    inst
                                    (@ContinuousMultilinearMap.addCommMonoid.{u_2, v, w₁, w₂} A ι M₁ M₂ inst_1 inst_2
                                      inst_3 inst_7 inst_8 inst_4 inst_5 inst_6)
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {M₁} {M₂} {R'} {A} [Semiring R'] [Semiring A] [(i : ι) → AddCommMonoid (M₁ i)] [AddCommMonoid M₂]
    [(i : ι) → TopologicalSpace (M₁ i)] [TopologicalSpace M₂] [ContinuousAdd M₂] [(i : ι) → Module A (M₁ i)]
    [Module A M₂] [Module R' M₂] [ContinuousConstSMul R' M₂] [SMulCommClass A R' M₂] =>
  { toDistribMulAction := ContinuousMultilinearMap.instDistribMulAction, add_smul := ⋯, zero_smul := ⋯ }
```

### D436: `ContinuousMultilinearMap.instTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.Multilinear.Topology`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `979aad55a57b89ce6eddc856a9ea611a8c17618f496237e6546c5daf220f4832`

Type:

```lean
{𝕜 : Type u_1} →
  {ι : Type u_2} →
    {E : ι → Type u_3} →
      {F : Type u_4} →
        [inst : NormedField 𝕜] →
          [inst_1 : (i : ι) → TopologicalSpace (E i)] →
            [inst_2 : (i : ι) → AddCommGroup (E i)] →
              [inst_3 : (i : ι) → Module 𝕜 (E i)] →
                [inst_4 : AddCommGroup F] →
                  [inst_5 : Module 𝕜 F] →
                    [inst_6 : TopologicalSpace F] →
                      [IsTopologicalAddGroup F] → TopologicalSpace (ContinuousMultilinearMap 𝕜 E F)
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  {ι : Type u_2} →
    {E : ι → Type u_3} →
      {F : Type u_4} →
        [inst : NormedField.{u_1} 𝕜] →
          [inst_1 : (i : ι) → TopologicalSpace.{u_3} (E i)] →
            [inst_2 : (i : ι) → AddCommGroup.{u_3} (E i)] →
              [inst_3 :
                  (i : ι) →
                    @Module.{u_1, u_3} 𝕜 (E i)
                      (@DivisionSemiring.toSemiring.{u_1} 𝕜
                        (@Semifield.toDivisionSemiring.{u_1} 𝕜
                          (@Field.toSemifield.{u_1} 𝕜 (@NormedField.toField.{u_1} 𝕜 inst))))
                      (@AddCommGroup.toAddCommMonoid.{u_3} (E i) (inst_2 i))] →
                [inst_4 : AddCommGroup.{u_4} F] →
                  [inst_5 :
                      @Module.{u_1, u_4} 𝕜 F
                        (@DivisionSemiring.toSemiring.{u_1} 𝕜
                          (@Semifield.toDivisionSemiring.{u_1} 𝕜
                            (@Field.toSemifield.{u_1} 𝕜 (@NormedField.toField.{u_1} 𝕜 inst))))
                        (@AddCommGroup.toAddCommMonoid.{u_4} F inst_4)] →
                    [inst_6 : TopologicalSpace.{u_4} F] →
                      [@IsTopologicalAddGroup.{u_4} F inst_6 (@AddCommGroup.toAddGroup.{u_4} F inst_4)] →
                        TopologicalSpace.{max (max u_4 u_3) u_2}
                          (@ContinuousMultilinearMap.{u_1, u_2, u_3, u_4} 𝕜 ι E F
                            (@DivisionSemiring.toSemiring.{u_1} 𝕜
                              (@Semifield.toDivisionSemiring.{u_1} 𝕜
                                (@Field.toSemifield.{u_1} 𝕜 (@NormedField.toField.{u_1} 𝕜 inst))))
                            (fun (i : ι) => @AddCommGroup.toAddCommMonoid.{u_3} (E i) (inst_2 i))
                            (@AddCommGroup.toAddCommMonoid.{u_4} F inst_4) inst_3 inst_5 inst_1 inst_6)
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} {ι} {E} {F} [NormedField 𝕜] [(i : ι) → TopologicalSpace (E i)] [(i : ι) → AddCommGroup (E i)]
    [(i : ι) → Module 𝕜 (E i)] [AddCommGroup F] [Module 𝕜 F] [TopologicalSpace F] [IsTopologicalAddGroup F] =>
  TopologicalSpace.induced ContinuousMultilinearMap.toUniformOnFun
    (UniformOnFun.topologicalSpace ((i : ι) → E i) F (setOf fun s => Bornology.IsVonNBounded 𝕜 s))
```

### D437: `ContinuousOn`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `8eccc5c9f77f90484deda327d9fdd17103bf4952b74f2423930f53c01df131c3`

Type:

```lean
{X : Type u_1} → {Y : Type u_2} → [TopologicalSpace X] → [TopologicalSpace Y] → (X → Y) → Set X → Prop
```

Fully explicit type:

```lean
{X : Type u_1} →
  {Y : Type u_2} → [TopologicalSpace.{u_1} X] → [TopologicalSpace.{u_2} Y] → (f : X → Y) → (s : Set.{u_1} X) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {X} {Y} [TopologicalSpace X] [TopologicalSpace Y] f s =>
  ∀ (x : X), Set.instMembership.mem s x → ContinuousWithinAt f s x
```

### D438: `HasFDerivWithinAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.FDeriv.Defs`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `c80e15969266244dee2a6f549eaebbae6fc48614cbc96064290ee1019b0ea27c`

Type:

```lean
{𝕜 : Type u_1} →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type u_2} →
      [inst_1 : AddCommGroup E] →
        [inst_2 : Module 𝕜 E] →
          [inst_3 : TopologicalSpace E] →
            {F : Type u_3} →
              [inst_4 : AddCommGroup F] →
                [inst_5 : Module 𝕜 F] →
                  [inst_6 : TopologicalSpace F] → (E → F) → ContinuousLinearMap (RingHom.id 𝕜) E F → Set E → E → Prop
```

Fully explicit type:

```lean
{𝕜 : Type u_1} →
  [inst : NontriviallyNormedField.{u_1} 𝕜] →
    {E : Type u_2} →
      [inst_1 : AddCommGroup.{u_2} E] →
        [inst_2 :
            @Module.{u_1, u_2} 𝕜 E
              (@DivisionSemiring.toSemiring.{u_1} 𝕜
                (@Semifield.toDivisionSemiring.{u_1} 𝕜
                  (@Field.toSemifield.{u_1} 𝕜
                    (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
              (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1)] →
          [inst_3 : TopologicalSpace.{u_2} E] →
            {F : Type u_3} →
              [inst_4 : AddCommGroup.{u_3} F] →
                [inst_5 :
                    @Module.{u_1, u_3} 𝕜 F
                      (@DivisionSemiring.toSemiring.{u_1} 𝕜
                        (@Semifield.toDivisionSemiring.{u_1} 𝕜
                          (@Field.toSemifield.{u_1} 𝕜
                            (@NormedField.toField.{u_1} 𝕜 (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
                      (@AddCommGroup.toAddCommMonoid.{u_3} F inst_4)] →
                  [inst_6 : TopologicalSpace.{u_3} F] →
                    (f : E → F) →
                      (f' :
                          @ContinuousLinearMap.{u_1, u_1, u_2, u_3} 𝕜 𝕜
                            (@DivisionSemiring.toSemiring.{u_1} 𝕜
                              (@Semifield.toDivisionSemiring.{u_1} 𝕜
                                (@Field.toSemifield.{u_1} 𝕜
                                  (@NormedField.toField.{u_1} 𝕜
                                    (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
                            (@DivisionSemiring.toSemiring.{u_1} 𝕜
                              (@Semifield.toDivisionSemiring.{u_1} 𝕜
                                (@Field.toSemifield.{u_1} 𝕜
                                  (@NormedField.toField.{u_1} 𝕜
                                    (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))
                            (@RingHom.id.{u_1} 𝕜
                              (@Semiring.toNonAssocSemiring.{u_1} 𝕜
                                (@DivisionSemiring.toSemiring.{u_1} 𝕜
                                  (@Semifield.toDivisionSemiring.{u_1} 𝕜
                                    (@Field.toSemifield.{u_1} 𝕜
                                      (@NormedField.toField.{u_1} 𝕜
                                        (@NontriviallyNormedField.toNormedField.{u_1} 𝕜 inst)))))))
                            E inst_3 (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) F inst_6
                            (@AddCommGroup.toAddCommMonoid.{u_3} F inst_4) inst_2 inst_5) →
                        (s : Set.{u_2} E) → (x : E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {𝕜} [NontriviallyNormedField 𝕜] {E} [AddCommGroup E] [Module 𝕜 E] [TopologicalSpace E] {F} [AddCommGroup F]
    [Module 𝕜 F] [TopologicalSpace F] f f' s x =>
  HasFDerivAtFilter f f' (Filter.instSProd.sprod (nhdsWithin x s) (Filter.instPure.pure x))
```

### D439: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `715de3f0bd9e7bcf034726e1efbf1b4dad42a16e2ce790d4403774d16ed5b549`

Type:

```lean
{m : Type u_2} →
  {n : Type u_3} → {α : Type v} → [NonUnitalNonAssocSemiring α] → [Fintype n] → Matrix m n α → (n → α) → m → α
```

Fully explicit type:

```lean
{m : Type u_2} →
  {n : Type u_3} →
    {α : Type v} →
      [NonUnitalNonAssocSemiring.{v} α] → [Fintype.{u_3} n] → (M : Matrix.{u_2, u_3, v} m n α) → (v : n → α) → m → α
```

Definition body (one-level semantic boundary):

```lean
fun {m} {n} {α} [NonUnitalNonAssocSemiring α] [Fintype n] M v x =>
  have i := x;
  dotProduct (fun j => M i j) v
```

### D440: `Module.Basis`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `inductive`
- Distance from target type: `8`
- Semantic SHA-256: `91ccb83aac9752d74388b4b5edfdf55080a7f53ae5fb386c8f8ffab46ed2ceab`

Type:

```lean
Type u_1 →
  (R : Type u_3) →
    (M : Type u_6) → [inst : Semiring R] → [inst_1 : AddCommMonoid M] → [Module R M] → Type (max (max u_1 u_3) u_6)
```

Fully explicit type:

```lean
(ι : Type u_1) →
  (R : Type u_3) →
    (M : Type u_6) →
      [inst : Semiring.{u_3} R] →
        [inst_1 : AddCommMonoid.{u_6} M] → [@Module.{u_3, u_6} R M inst inst_1] → Type (max (max u_1 u_3) u_6)
```

### D441: `Module.Basis.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `09f2e6b4c6d86c2bb88f692b220637928f7ce01a1c3f043a706fedea853492be`

Type:

```lean
{ι : Type u_1} →
  {R : Type u_3} →
    {M : Type u_6} →
      [inst : Semiring R] → [inst_1 : AddCommMonoid M] → [inst_2 : Module R M] → FunLike (Module.Basis ι R M) ι M
```

Fully explicit type:

```lean
{ι : Type u_1} →
  {R : Type u_3} →
    {M : Type u_6} →
      [inst : Semiring.{u_3} R] →
        [inst_1 : AddCommMonoid.{u_6} M] →
          [inst_2 : @Module.{u_3, u_6} R M inst inst_1] →
            FunLike.{max (max (u_6 + 1) (u_3 + 1)) (u_1 + 1), u_1 + 1, u_6 + 1}
              (@Module.Basis.{u_1, u_3, u_6} ι R M inst inst_1 inst_2) ι M
```

Definition body (one-level semantic boundary):

```lean
fun {ι} {R} {M} [Semiring R] [AddCommMonoid M] [Module R M] =>
  { coe := fun b i => EquivLike.toFunLike.coe b.repr.symm (Finsupp.single i 1), coe_injective' := ⋯ }
```

### D442: `NormedRing.toRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `8`
- Semantic SHA-256: `0c36f01716edb26d66bcdc6ecf2e6e4fbbade7871af3f64b48a6e4168110de75`

Type:

```lean
{α : Type u_5} → [self : NormedRing α] → Ring α
```

Fully explicit type:

```lean
{α : Type u_5} → [self : NormedRing.{u_5} α] → Ring.{u_5} α
```

Definition body (one-level semantic boundary):

```lean
fun α [self : NormedRing α] => self.2
```

### D443: `Preorder.toLT`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Defs.PartialOrder`
- Declaration kind: `abbrev`
- Distance from target type: `8`
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

### D444: `Real.commRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `da00a22f1d267a99bad32236c81af717f9f20a554bd227178f282f3393d64a7e`

Type:

```lean
CommRing Real
```

Fully explicit type:

```lean
CommRing.{0} Real
```

Definition body (one-level semantic boundary):

```lean
{ toAdd := Real.instAdd, add_assoc := ⋯, toZero := Real.instZero, zero_add := ⋯, add_zero := ⋯, nsmul := nsmulRec,
  nsmul_zero := Real.commRing._proof_4, nsmul_succ := Real.commRing._proof_5, add_comm := ⋯, toMul := Real.instMul,
  left_distrib := ⋯, right_distrib := ⋯, zero_mul := ⋯, mul_zero := ⋯, mul_assoc := ⋯, toOne := Real.instOne,
  one_mul := ⋯, mul_one := ⋯, natCast := fun n => { cauchy := n.cast }, natCast_zero := Real.commRing._proof_14,
  natCast_succ := ⋯, npow := npowRec, npow_zero := Real.commRing._proof_16, npow_succ := Real.commRing._proof_17,
  toNeg := Real.instNeg, toSub := Real.instSub, sub_eq_add_neg := Real.commRing._proof_18, zsmul := zsmulRec,
  zsmul_zero' := Real.commRing._proof_19, zsmul_succ' := Real.commRing._proof_20, zsmul_neg' := Real.commRing._proof_21,
  neg_add_cancel := ⋯, intCast := fun z => { cauchy := z.cast }, intCast_ofNat := Real.commRing._proof_23,
  intCast_negSucc := ⋯, mul_comm := ⋯ }
```

### D445: `RingHomInvPair`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.CompTypeclasses`
- Declaration kind: `inductive`
- Distance from target type: `8`
- Semantic SHA-256: `eba5e79959e8652c489365b8e4a0a1562cfc528d141ca51502769b8b6f807ad9`

Type:

```lean
{R₁ : Type u_1} →
  {R₂ : Type u_2} → [inst : Semiring R₁] → [inst_1 : Semiring R₂] → RingHom R₁ R₂ → outParam (RingHom R₂ R₁) → Prop
```

Fully explicit type:

```lean
{R₁ : Type u_1} →
  {R₂ : Type u_2} →
    [inst : Semiring.{u_1} R₁] →
      [inst_1 : Semiring.{u_2} R₂] →
        (σ :
            @RingHom.{u_1, u_2} R₁ R₂ (@Semiring.toNonAssocSemiring.{u_1} R₁ inst)
              (@Semiring.toNonAssocSemiring.{u_2} R₂ inst_1)) →
          (σ' :
              outParam.{max (u_1 + 1) (u_2 + 1)}
                (@RingHom.{u_2, u_1} R₂ R₁ (@Semiring.toNonAssocSemiring.{u_2} R₂ inst_1)
                  (@Semiring.toNonAssocSemiring.{u_1} R₁ inst))) →
            Prop
```

### D446: `WithTop.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.WithBot`
- Declaration kind: `def`
- Distance from target type: `8`
- Semantic SHA-256: `9f2f565fd26ff7117c2bb02e0f5f9ac5d7a841fb96a82161fa7549abda532cc4`

Type:

```lean
{α : Type u_1} → [Preorder α] → Preorder (WithTop α)
```

Fully explicit type:

```lean
{α : Type u_1} → [Preorder.{u_1} α] → Preorder.{u_1} (WithTop.{u_1} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} [Preorder α] => Preorder.mk' ⋯ ⋯ ⋯
```

### D447: `smulCommClass_self`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Defs`
- Declaration kind: `theorem`
- Distance from target type: `8`
- Semantic SHA-256: `7be00a135c47f182025680c3d611a310d93491fd74ca783a9f62082daef5e9d3`

Type:

```lean
∀ (M : Type u_9) (α : Type u_10) [inst : CommMonoid M] [inst_1 : MulAction M α], SMulCommClass M M α
```

Fully explicit type:

```lean
∀ (M : Type u_9) (α : Type u_10) [inst : CommMonoid.{u_9} M]
  [inst_1 : @MulAction.{u_9, u_10} M α (@CommMonoid.toMonoid.{u_9} M inst)],
  @SMulCommClass.{u_9, u_9, u_10} M M α
    (@SemigroupAction.toSMul.{u_9, u_10} M α (@Monoid.toSemigroup.{u_9} M (@CommMonoid.toMonoid.{u_9} M inst))
      (@MulAction.toSemigroupAction.{u_9, u_10} M α (@CommMonoid.toMonoid.{u_9} M inst) inst_1))
    (@SemigroupAction.toSMul.{u_9, u_10} M α (@Monoid.toSemigroup.{u_9} M (@CommMonoid.toMonoid.{u_9} M inst))
      (@MulAction.toSemigroupAction.{u_9, u_10} M α (@CommMonoid.toMonoid.{u_9} M inst) inst_1))
```
