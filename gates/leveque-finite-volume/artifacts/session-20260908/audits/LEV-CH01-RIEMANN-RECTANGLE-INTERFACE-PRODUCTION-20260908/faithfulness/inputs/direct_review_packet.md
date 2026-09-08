# Declaration dossier for LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_rectangleRiemannInterfaceFlux_sourceContract
    {m : ℕ} (hm : 0 < m) {Information : Type*}
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (grid : OneDimensionalFiniteVolumeGrid)
    (initialState : ℝ → (Fin m → ℝ))
    (hintegrable : ∀ i, IntervalIntegrable initialState volume
      (grid.cellLeft i) (grid.cellRight i))
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (hdomain : ∀ i, method.domain
      (adjacentCellRiemannProblem law (finiteVolumeCellAverageOn grid initialState) i))
    (timeStep : ℝ) (htimeStep : 0 < timeStep) :
    0 < m ∧ 0 < timeStep ∧
    ∃ cellAverages : ℤ → (Fin m → ℝ),
      (∀ i, IsOneDimensionalCellAverage initialState
        (grid.cellLeft i) (grid.cellRight i) (cellAverages i)) ∧
      (∀ i, grid.cellRight (i - 1) = grid.cellLeft i) ∧
      (∀ i, method.domain (adjacentCellRiemannProblem law cellAverages i)) ∧
      ∃ solved : (i : ℤ) → CertifiedRectangleRiemannSolution law
          (adjacentCellRiemannProblem law cellAverages i),
        (∀ i, IsRiemannData (fun x => (solved i).solution x 0)
          (cellAverages (i - 1)) (cellAverages i)) ∧
        (∀ i, IsRectangleConservationLawSolution (solved i).solution law.physicalFlux) ∧
        ∃ information : ℤ → Information,
          (∀ i, information i = method.extractInformation (solved i)) ∧
          ∃ numericalFlux : ℤ → (Fin m → ℝ),
            (∀ i, numericalFlux i = method.numericalFluxFromInformation (information i)) ∧
            (∀ state, method.numericalFluxFromInformation
              (method.extractInformation
                (method.solve
                  ({ leftState
```

## Elaborated target type

```lean
∀ {m : Nat},
  instLTNat.lt 0 m →
    ∀ {Information : Type u_1} (law : NumStability.OneDimensionalHyperbolicConservationLaw (Fin m))
      (grid : NumStability.OneDimensionalFiniteVolumeGrid) (initialState : Real → Fin m → Real),
      (∀ (i : Int), IntervalIntegrable initialState Real.measureSpace.volume (grid.cellLeft i) (grid.cellRight i)) →
        ∀ (method : NumStability.RectangleRiemannInterfaceFluxMethod law Information),
          (∀ (i : Int),
              method.domain
                (NumStability.adjacentCellRiemannProblem law (NumStability.finiteVolumeCellAverageOn grid initialState)
                  i)) →
            ∀ (timeStep : Real),
              Real.instLT.lt 0 timeStep →
                And (instLTNat.lt 0 m)
                  (And (Real.instLT.lt 0 timeStep)
                    (Exists fun cellAverages =>
                      And
                        (∀ (i : Int),
                          NumStability.IsOneDimensionalCellAverage initialState (grid.cellLeft i) (grid.cellRight i)
                            (cellAverages i))
                        (And (∀ (i : Int), Eq (grid.cellRight (instHSub.hSub i 1)) (grid.cellLeft i))
                          (And (∀ (i : Int), method.domain (NumStability.adjacentCellRiemannProblem law cellAverages i))
                            (Exists fun solved =>
                              And
                                (∀ (i : Int),
                                  NumStability.IsRiemannData (fun x => (solved i).solution x 0)
                                    (cellAverages (instHSub.hSub i 1)) (cellAverages i))
                                (And
                                  (∀ (i : Int),
                                    NumStability.IsRectangleConservationLawSolution (solved i).solution
                                      law.physicalFlux)
                                  (Exists fun information =>
                                    And (∀ (i : Int), Eq (information i) (method.extractInformation (solved i)))
                                      (Exists fun numericalFlux =>
                                        And
                                          (∀ (i : Int),
                                            Eq (numericalFlux i) (method.numericalFluxFromInformation (information i)))
                                          (And
                                            (∀ (state : Fin m → Real),
                                              Eq
                                                (method.numericalFluxFromInformation
                                                  (method.extractInformation
                                                    (method.solve { leftState := state, rightState := state } ⋯)))
                                                (law.physicalFlux state))
                                            (Exists fun updatedCellAverages =>
                                              ∀ (i : Int),
                                                Eq (updatedCellAverages i)
                                                  (NumStability.riemannFiniteVolumeUpdate grid timeStep cellAverages
                                                    numericalFlux i)))))))))))
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} (hm : @LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
  {Information : Type u_1} (law : @NumStability.OneDimensionalHyperbolicConservationLaw.{0} (Fin m) (Fin.fintype m))
  (grid : NumStability.OneDimensionalFiniteVolumeGrid) (initialState : Real → Fin m → Real)
  (hintegrable :
    ∀ (i : Int),
      @IntervalIntegrable.{0} (Fin m → Real)
        (@Pi.topologicalSpace.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
          @UniformSpace.toTopologicalSpace.{0} Real (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
        (@NormedAddGroup.toENormedAddMonoid.{0} (Fin m → Real)
          (@Pi.normedAddGroup.{0, 0} (Fin m) (fun (a : Fin m) => Real) (Fin.fintype m) fun (i : Fin m) =>
            @NormedAddCommGroup.toNormedAddGroup.{0} Real Real.normedAddCommGroup))
        initialState (@MeasureTheory.MeasureSpace.volume.{0} Real Real.measureSpace)
        (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft grid i)
        (NumStability.OneDimensionalFiniteVolumeGrid.cellRight grid i))
  (method : @NumStability.RectangleRiemannInterfaceFluxMethod.{0, u_1} (Fin m) (Fin.fintype m) law Information)
  (hdomain :
    ∀ (i : Int),
      @NumStability.RectangleRiemannInterfaceFluxMethod.domain.{0, u_1} (Fin m) (Fin.fintype m) law Information method
        (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law
          (@NumStability.finiteVolumeCellAverageOn.{0} (Fin m → Real)
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
            grid initialState)
          i))
  (timeStep : Real)
  (htimeStep :
    @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) timeStep),
  And (@LT.lt.{0} Nat instLTNat (@OfNat.ofNat.{0} Nat (nat_lit 0) (instOfNatNat (nat_lit 0))) m)
    (And
      (@LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) timeStep)
      (@Exists.{1} (Int → Fin m → Real) fun (cellAverages : Int → Fin m → Real) =>
        And
          (∀ (i : Int),
            @NumStability.IsOneDimensionalCellAverage.{0} (Fin m → Real)
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
              initialState (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft grid i)
              (NumStability.OneDimensionalFiniteVolumeGrid.cellRight grid i) (cellAverages i))
          (And
            (∀ (i : Int),
              @Eq.{1} Real
                (NumStability.OneDimensionalFiniteVolumeGrid.cellRight grid
                  (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                    (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                (NumStability.OneDimensionalFiniteVolumeGrid.cellLeft grid i))
            (And
              (∀ (i : Int),
                @NumStability.RectangleRiemannInterfaceFluxMethod.domain.{0, u_1} (Fin m) (Fin.fintype m) law
                  Information method
                  (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law cellAverages i))
              (@Exists.{1}
                ((i : Int) →
                  @NumStability.CertifiedRectangleRiemannSolution.{0} (Fin m) (Fin.fintype m) law
                    (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law cellAverages i))
                fun
                  (solved :
                    (i : Int) →
                      @NumStability.CertifiedRectangleRiemannSolution.{0} (Fin m) (Fin.fintype m) law
                        (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law cellAverages i)) =>
                And
                  (∀ (i : Int),
                    @NumStability.IsRiemannData.{0} (Fin m → Real)
                      (fun (x : Real) =>
                        @NumStability.CertifiedRectangleRiemannSolution.solution.{0} (Fin m) (Fin.fintype m) law
                          (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law cellAverages i)
                          (solved i) x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
                      (cellAverages
                        (@HSub.hSub.{0, 0, 0} Int Int Int (@instHSub.{0} Int Int.instSub) i
                          (@OfNat.ofNat.{0} Int (nat_lit 1) (@instOfNat (nat_lit 1)))))
                      (cellAverages i))
                  (And
                    (∀ (i : Int),
                      @NumStability.IsRectangleConservationLawSolution.{0} (Fin m → Real)
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
                        (@NumStability.CertifiedRectangleRiemannSolution.solution.{0} (Fin m) (Fin.fintype m) law
                          (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law cellAverages i)
                          (solved i))
                        (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m) (Fin.fintype m)
                          law))
                    (@Exists.{u_1 + 1} (Int → Information) fun (information : Int → Information) =>
                      And
                        (∀ (i : Int),
                          @Eq.{u_1 + 1} Information (information i)
                            (@NumStability.RectangleRiemannInterfaceFluxMethod.extractInformation.{0, u_1} (Fin m)
                              (Fin.fintype m) law Information method
                              (@NumStability.adjacentCellRiemannProblem.{0} (Fin m) (Fin.fintype m) law cellAverages i)
                              (solved i)))
                        (@Exists.{1} (Int → Fin m → Real) fun (numericalFlux : Int → Fin m → Real) =>
                          And
                            (∀ (i : Int),
                              @Eq.{1} (Fin m → Real) (numericalFlux i)
                                (@NumStability.RectangleRiemannInterfaceFluxMethod.numericalFluxFromInformation.{0, u_1}
                                  (Fin m) (Fin.fintype m) law Information method (information i)))
                            (And
                              (∀ (state : Fin m → Real),
                                @Eq.{1} (Fin m → Real)
                                  (@NumStability.RectangleRiemannInterfaceFluxMethod.numericalFluxFromInformation.{0,
                                        u_1}
                                    (Fin m) (Fin.fintype m) law Information method
                                    (@NumStability.RectangleRiemannInterfaceFluxMethod.extractInformation.{0, u_1}
                                      (Fin m) (Fin.fintype m) law Information method
                                      (@NumStability.HyperbolicRiemannProblem.mk.{0} (Fin m) (Fin.fintype m) law state
                                        state)
                                      (@NumStability.RectangleRiemannInterfaceFluxMethod.solve.{0, u_1} (Fin m)
                                        (Fin.fintype m) law Information method
                                        (@NumStability.HyperbolicRiemannProblem.mk.{0} (Fin m) (Fin.fintype m) law state
                                          state)
                                        (@NumStability.RectangleRiemannInterfaceFluxMethod.constants_in_domain.{0, u_1}
                                          (Fin m) (Fin.fintype m) law Information method state))))
                                  (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{0} (Fin m)
                                    (Fin.fintype m) law state))
                              (@Exists.{1} (Int → Fin m → Real) fun (updatedCellAverages : Int → Fin m → Real) =>
                                ∀ (i : Int),
                                  @Eq.{1} (Fin m → Real) (updatedCellAverages i)
                                    (@NumStability.riemannFiniteVolumeUpdate.{0} (Fin m) grid timeStep cellAverages
                                      numericalFlux i)))))))))))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`, `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution`, `Mathlib.Topology.Algebra.Module.FiniteDimension`, `Mathlib.LinearAlgebra.Matrix.ToLin`, `Mathlib.Analysis.Calculus.FDeriv.Linear`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.CertifiedRectangleRiemannSolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ad7b208324194dc2b00f33ad397b55406a1213aba11a9774c6ed4889c74ceb5d`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    (law : NumStability.OneDimensionalHyperbolicConservationLaw Component) →
      NumStability.HyperbolicRiemannProblem law → Type u_1
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst) →
      (problem : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law) → Type u_1
```

### D002: `NumStability.CertifiedRectangleRiemannSolution.solution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `17162b14965b9a7f324e9a71eddb865ec68adebdeb0c930140089375bac95799`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      {problem : NumStability.HyperbolicRiemannProblem law} →
        NumStability.CertifiedRectangleRiemannSolution law problem → Real → Real → Component → Real
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      {problem : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law} →
        (self : @NumStability.CertifiedRectangleRiemannSolution.{u_1} Component inst law problem) →
          Real → Real → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] law problem self => self.1
```

### D003: `NumStability.HyperbolicRiemannProblem.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `5f2a16f85d2b80003fb80ed3245e4ce1b46cef93c017e75ebf4e2d8c42303cc8`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {_law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      (Component → Real) → (Component → Real) → NumStability.HyperbolicRiemannProblem _law
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {_law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      (leftState rightState : Component → Real) → @NumStability.HyperbolicRiemannProblem.{u_1} Component inst _law
```

### D004: `NumStability.IsOneDimensionalCellAverage`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ac4875f1788587b8337fca28f0d4ec0e9a076fe45ed035a31c5cd8fdac11ff`

Type:

```lean
{E : Type u_1} → [inst : NormedAddCommGroup E] → [NormedSpace Real E] → (Real → E) → Real → Real → E → Prop
```

Fully explicit type:

```lean
{E : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} E] →
    [@NormedSpace.{0, u_1} Real E Real.normedField (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} E inst)] →
      (field : Real → E) → (left right : Real) → (average : E) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {E} [NormedAddCommGroup E] [NormedSpace Real E] field left right average =>
  And (Real.instLT.lt left right)
    (And (IntervalIntegrable field Real.measureSpace.volume left right)
      (Eq average (NumStability.oneDimensionalCellAverage field left right)))
```

### D005: `NumStability.IsRectangleConservationLawSolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D006: `NumStability.IsRiemannData`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9986cca09fad513510d98d589879bd7b67d633458b39e176f9124be154775712`

Type:

```lean
{State : Type u_1} → (Real → State) → State → State → Prop
```

Fully explicit type:

```lean
{State : Type u_1} → (data : Real → State) → (leftState rightState : State) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {State} data leftState rightState =>
  And (∀ (x : Real), Real.instLT.lt x 0 → Eq (data x) leftState)
    (∀ (x : Real), Real.instLT.lt 0 x → Eq (data x) rightState)
```

### D007: `NumStability.OneDimensionalFiniteVolumeGrid`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `f45b4f5e41b1c7954e0f18cce119693e8b371eeee4d32f4d849109d5363609ce`

Type:

```lean
Type
```

Fully explicit type:

```lean
Type
```

### D008: `NumStability.OneDimensionalFiniteVolumeGrid.cellLeft`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D009: `NumStability.OneDimensionalFiniteVolumeGrid.cellRight`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D010: `NumStability.OneDimensionalHyperbolicConservationLaw`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2d256393d65a30707d17543757fdaf16f312e530ad830b462498f9a004f47d13`

Type:

```lean
(Component : Type u_1) → [Fintype Component] → Type u_1
```

Fully explicit type:

```lean
(Component : Type u_1) → [Fintype.{u_1} Component] → Type u_1
```

### D011: `NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `38e8edada8c0a662e811fec59ac2b9f5ec90a5208b05e306b00d9cadf14503fa`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    NumStability.OneDimensionalHyperbolicConservationLaw Component → (Component → Real) → Component → Real
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (self : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst) →
      (Component → Real) → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] self => self.1
```

### D012: `NumStability.RectangleRiemannInterfaceFluxMethod`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `818ac7446117674ee1119052a5ad287106f465d0a683e5e73b94d07ea90df093`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    NumStability.OneDimensionalHyperbolicConservationLaw Component → Type u_2 → Type (max u_1 u_2)
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst) →
      (Information : Type u_2) → Type (max u_1 u_2)
```

### D013: `NumStability.RectangleRiemannInterfaceFluxMethod.constants_in_domain`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `theorem`
- Distance from target type: `1`
- Semantic SHA-256: `35d98eaacc4a54db350b5f642457a15d41f89bfaf1eb50306f7030acab9b2d13`

Type:

```lean
∀ {Component : Type u_1} [inst : Fintype Component]
  {law : NumStability.OneDimensionalHyperbolicConservationLaw Component} {Information : Type u_2}
  (self : NumStability.RectangleRiemannInterfaceFluxMethod law Information) (state : Component → Real),
  self.domain { leftState := state, rightState := state }
```

Fully explicit type:

```lean
∀ {Component : Type u_1} [inst : Fintype.{u_1} Component]
  {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} {Information : Type u_2}
  (self : @NumStability.RectangleRiemannInterfaceFluxMethod.{u_1, u_2} Component inst law Information)
  (state : Component → Real),
  @NumStability.RectangleRiemannInterfaceFluxMethod.domain.{u_1, u_2} Component inst law Information self
    (@NumStability.HyperbolicRiemannProblem.mk.{u_1} Component inst law state state)
```

### D014: `NumStability.RectangleRiemannInterfaceFluxMethod.domain`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `cd7cc84451905487fd98c8dc1299f3244cf4c6c50ab11b3680dda5d7fc8a8833`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      {Information : Type u_2} →
        NumStability.RectangleRiemannInterfaceFluxMethod law Information →
          NumStability.HyperbolicRiemannProblem law → Prop
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      {Information : Type u_2} →
        (self : @NumStability.RectangleRiemannInterfaceFluxMethod.{u_1, u_2} Component inst law Information) →
          @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law → Prop
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] law Information self => self.1
```

### D015: `NumStability.RectangleRiemannInterfaceFluxMethod.extractInformation`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4de896d39a34997877f4cf81b0d42024b15a51e413e53671aa18cd81b2f33f90`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      {Information : Type u_2} →
        NumStability.RectangleRiemannInterfaceFluxMethod law Information →
          {problem : NumStability.HyperbolicRiemannProblem law} →
            NumStability.CertifiedRectangleRiemannSolution law problem → Information
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      {Information : Type u_2} →
        (self : @NumStability.RectangleRiemannInterfaceFluxMethod.{u_1, u_2} Component inst law Information) →
          {problem : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law} →
            @NumStability.CertifiedRectangleRiemannSolution.{u_1} Component inst law problem → Information
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] law Information self => self.3
```

### D016: `NumStability.RectangleRiemannInterfaceFluxMethod.numericalFluxFromInformation`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `01f45d21aa8bc4fd7533cc12b94eabf7cd4be50fb857ca6615d75b7cab897d73`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      {Information : Type u_2} →
        NumStability.RectangleRiemannInterfaceFluxMethod law Information → Information → Component → Real
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      {Information : Type u_2} →
        (self : @NumStability.RectangleRiemannInterfaceFluxMethod.{u_1, u_2} Component inst law Information) →
          Information → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] law Information self => self.4
```

### D017: `NumStability.RectangleRiemannInterfaceFluxMethod.solve`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `bf5d2f21a9ba7596b8b7805a9959aec2a98f3df52bc5283ed1262dca5b5ec224`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      {Information : Type u_2} →
        (self : NumStability.RectangleRiemannInterfaceFluxMethod law Information) →
          (problem : NumStability.HyperbolicRiemannProblem law) →
            self.domain problem → NumStability.CertifiedRectangleRiemannSolution law problem
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      {Information : Type u_2} →
        (self : @NumStability.RectangleRiemannInterfaceFluxMethod.{u_1, u_2} Component inst law Information) →
          (problem : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law) →
            @NumStability.RectangleRiemannInterfaceFluxMethod.domain.{u_1, u_2} Component inst law Information self
                problem →
              @NumStability.CertifiedRectangleRiemannSolution.{u_1} Component inst law problem
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] law Information self => self.2
```

### D018: `NumStability.adjacentCellRiemannProblem`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `56780f75b263e1f0d30a97d1fcf699bf801f6e3354096e62a8a4196cd271cd61`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    (law : NumStability.OneDimensionalHyperbolicConservationLaw Component) →
      (Int → Component → Real) → Int → NumStability.HyperbolicRiemannProblem law
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst) →
      (cellAverages : Int → Component → Real) →
        (i : Int) → @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law
```

Definition body (one-level semantic boundary):

```lean
fun {Component} [Fintype Component] law cellAverages i =>
  { leftState := cellAverages (instHSub.hSub i 1), rightState := cellAverages i }
```

### D019: `NumStability.finiteVolumeCellAverageOn`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `65e6559cfb9ca07940be04cbe50ab95271f5d1de635854144495cca35ed0c4d9`

Type:

```lean
{State : Type u_1} →
  [inst : NormedAddCommGroup State] →
    [NormedSpace Real State] → NumStability.OneDimensionalFiniteVolumeGrid → (Real → State) → Int → State
```

Fully explicit type:

```lean
{State : Type u_1} →
  [inst : NormedAddCommGroup.{u_1} State] →
    [@NormedSpace.{0, u_1} Real State Real.normedField
          (@NormedAddCommGroup.toSeminormedAddCommGroup.{u_1} State inst)] →
      (grid : NumStability.OneDimensionalFiniteVolumeGrid) → (state : Real → State) → (i : Int) → State
```

Definition body (one-level semantic boundary):

```lean
fun {State} [NormedAddCommGroup State] [NormedSpace Real State] grid state i =>
  NumStability.oneDimensionalCellAverage state (grid.cellLeft i) (grid.cellRight i)
```

### D020: `NumStability.riemannFiniteVolumeUpdate`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `5f0ca989def21ed8e967fb586b47106a111ff6c121a5cdc0b0e980f00a72171b`

Type:

```lean
{Component : Type u_1} →
  NumStability.OneDimensionalFiniteVolumeGrid →
    Real → (Int → Component → Real) → (Int → Component → Real) → Int → Component → Real
```

Fully explicit type:

```lean
{Component : Type u_1} →
  (grid : NumStability.OneDimensionalFiniteVolumeGrid) →
    (timeStep : Real) → (cellAverages edgeFlux : Int → Component → Real) → (i : Int) → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun {Component} grid timeStep cellAverages edgeFlux i =>
  instHSub.hSub (cellAverages i)
    (instHSMul.hSMul (instHDiv.hDiv timeStep (grid.cellVolume i))
      (instHSub.hSub (edgeFlux (instHAdd.hAdd i 1)) (edgeFlux i)))
```

### D021: `NumStability.CertifiedRectangleRiemannSolution.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `4b2df3624ff0c4c9bd75e9adb436566a64b46696205bfe5a53ee001412a62470`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      {problem : NumStability.HyperbolicRiemannProblem law} →
        (solution : Real → Real → Component → Real) →
          NumStability.IsRectangleHyperbolicRiemannSolution law problem solution →
            NumStability.CertifiedRectangleRiemannSolution law problem
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      {problem : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law} →
        (solution : Real → Real → Component → Real) →
          (solves : @NumStability.IsRectangleHyperbolicRiemannSolution.{u_1} Component inst law problem solution) →
            @NumStability.CertifiedRectangleRiemannSolution.{u_1} Component inst law problem
```

### D022: `NumStability.HyperbolicRiemannProblem`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ef94dbe7341f421784d8b34d4523d9de830fbcdb2525e47718ca5d89eeb6e2fa`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] → NumStability.OneDimensionalHyperbolicConservationLaw Component → Type u_1
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (_law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst) → Type u_1
```

### D023: `NumStability.OneDimensionalFiniteVolumeGrid.cellVolume`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D024: `NumStability.OneDimensionalFiniteVolumeGrid.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `constructor`
- Distance from target type: `2`
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

### D025: `NumStability.OneDimensionalHyperbolicConservationLaw.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `5716f52b65018ff9f19eddfb7cda99a4810b6558b57e23cf0e8bda3ba9150ca4`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    (physicalFlux : (Component → Real) → Component → Real) →
      (fluxDerivative :
          (Component → Real) → ContinuousLinearMap (RingHom.id Real) (Component → Real) (Component → Real)) →
        (fluxJacobian : (Component → Real) → Matrix Component Component Real) →
          (∀ (state : Component → Real), HasFDerivAt physicalFlux (fluxDerivative state) state) →
            (∀ (state direction : Component → Real),
                Eq (ContinuousLinearMap.funLike.coe (fluxDerivative state) direction)
                  ((fluxJacobian state).mulVec direction)) →
              (∀ (state : Component → Real), NumStability.IsRealHyperbolicMatrix (fluxJacobian state)) →
                NumStability.OneDimensionalHyperbolicConservationLaw Component
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (physicalFlux : (Component → Real) → Component → Real) →
      (fluxDerivative :
          (Component → Real) →
            @ContinuousLinearMap.{0, 0, u_1, u_1} Real Real Real.semiring Real.semiring
              (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)) (Component → Real)
              (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                @UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                Real.instAddCommMonoid)
              (Component → Real)
              (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                @UniformSpace.toTopologicalSpace.{0} Real
                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
              (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                Real.instAddCommMonoid)
              (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
              (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                    (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))))) →
        (fluxJacobian : (Component → Real) → Matrix.{u_1, u_1, 0} Component Component Real) →
          (hasFDerivAt_physicalFlux :
              ∀ (state : Component → Real),
                @HasFDerivAt.{0, u_1, u_1} Real
                  (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField) (Component → Real)
                  (@Pi.addCommGroup.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                    Real.instAddCommGroup)
                  (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                  (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  (Component → Real)
                  (@Pi.addCommGroup.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                    Real.instAddCommGroup)
                  (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                  (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                    @UniformSpace.toTopologicalSpace.{0} Real
                      (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                  physicalFlux (fluxDerivative state) state) →
            (fluxDerivative_eq_jacobian_mulVec :
                ∀ (state direction : Component → Real),
                  @Eq.{u_1 + 1} (Component → Real)
                    (@DFunLike.coe.{u_1 + 1, u_1 + 1, u_1 + 1}
                      (@ContinuousLinearMap.{0, 0, u_1, u_1} Real Real Real.semiring Real.semiring
                        (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)) (Component → Real)
                        (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                          Real.instAddCommMonoid)
                        (Component → Real)
                        (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                          Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                        (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                      (Component → Real) (fun (x : Component → Real) => Component → Real)
                      (@ContinuousLinearMap.funLike.{0, 0, u_1, u_1} Real Real Real.semiring Real.semiring
                        (@RingHom.id.{0} Real (@Semiring.toNonAssocSemiring.{0} Real Real.semiring)) (Component → Real)
                        (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                          Real.instAddCommMonoid)
                        (Component → Real)
                        (@Pi.topologicalSpace.{0, u_1} Component (fun (a : Component) => Real) fun (i : Component) =>
                          @UniformSpace.toTopologicalSpace.{0} Real
                            (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                        (@Pi.addCommMonoid.{u_1, 0} Component (fun (a : Component) => Real) fun (i : Component) =>
                          Real.instAddCommMonoid)
                        (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                        (@Pi.Function.module.{u_1, 0, 0} Component Real Real Real.semiring Real.instAddCommMonoid
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
                      (fluxDerivative state) direction)
                    (@Matrix.mulVec.{0, u_1, u_1} Component Component Real
                      (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                        (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                          (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                            (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                              (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                      inst (fluxJacobian state) direction)) →
              (jacobian_hyperbolic :
                  ∀ (state : Component → Real),
                    @NumStability.IsRealHyperbolicMatrix.{u_1} Component inst (fluxJacobian state)) →
                @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst
```

### D026: `NumStability.RectangleRiemannInterfaceFluxMethod.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `2c7f1aade6b5df7a68472f88c59b77adf311acc3d3c673fa4848913812018313`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      {Information : Type u_2} →
        (domain : NumStability.HyperbolicRiemannProblem law → Prop) →
          (solve :
              (problem : NumStability.HyperbolicRiemannProblem law) →
                domain problem → NumStability.CertifiedRectangleRiemannSolution law problem) →
            (extractInformation :
                {problem : NumStability.HyperbolicRiemannProblem law} →
                  NumStability.CertifiedRectangleRiemannSolution law problem → Information) →
              (numericalFluxFromInformation : Information → Component → Real) →
                (constants_in_domain :
                    ∀ (state : Component → Real), domain { leftState := state, rightState := state }) →
                  (∀ (state : Component → Real),
                      Eq
                        (numericalFluxFromInformation
                          (extractInformation (solve { leftState := state, rightState := state } ⋯)))
                        (law.physicalFlux state)) →
                    NumStability.RectangleRiemannInterfaceFluxMethod law Information
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      {Information : Type u_2} →
        (domain : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law → Prop) →
          (solve :
              (problem : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law) →
                domain problem → @NumStability.CertifiedRectangleRiemannSolution.{u_1} Component inst law problem) →
            (extractInformation :
                {problem : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law} →
                  @NumStability.CertifiedRectangleRiemannSolution.{u_1} Component inst law problem → Information) →
              (numericalFluxFromInformation : Information → Component → Real) →
                (constants_in_domain :
                    ∀ (state : Component → Real),
                      domain (@NumStability.HyperbolicRiemannProblem.mk.{u_1} Component inst law state state)) →
                  (consistent_on_constant_states :
                      ∀ (state : Component → Real),
                        @Eq.{u_1 + 1} (Component → Real)
                          (numericalFluxFromInformation
                            (@extractInformation
                              (@NumStability.HyperbolicRiemannProblem.mk.{u_1} Component inst law state state)
                              (solve (@NumStability.HyperbolicRiemannProblem.mk.{u_1} Component inst law state state)
                                (constants_in_domain state))))
                          (@NumStability.OneDimensionalHyperbolicConservationLaw.physicalFlux.{u_1} Component inst law
                            state)) →
                    @NumStability.RectangleRiemannInterfaceFluxMethod.{u_1, u_2} Component inst law Information
```

### D027: `NumStability.oneDimensionalCellAverage`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D028: `NumStability.IsRealHyperbolicMatrix`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D029: `NumStability.IsRectangleHyperbolicRiemannSolution`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `469cc5321bdbb587d3252e1629d85b053c4fa0ca53e010634752bc27ba88893d`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    (law : NumStability.OneDimensionalHyperbolicConservationLaw Component) →
      NumStability.HyperbolicRiemannProblem law → (Real → Real → Component → Real) → Prop
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    (law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst) →
      (problem : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst law) →
        (solution : Real → Real → Component → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {Component} [Fintype Component] law problem solution =>
  And (NumStability.IsRiemannData (fun x => solution x 0) problem.leftState problem.rightState)
    (NumStability.IsRectangleConservationLawSolution solution law.physicalFlux)
```

### D030: `NumStability.HyperbolicRiemannProblem.leftState`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `34f07343b7d88ae80f17bc569a25c144ea62ce8e15e46bc7a6a2bdf9556ea71a`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {_law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      NumStability.HyperbolicRiemannProblem _law → Component → Real
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {_law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      (self : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst _law) → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] _law self => self.1
```

### D031: `NumStability.HyperbolicRiemannProblem.rightState`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- Declaration kind: `abbrev`
- Distance from target type: `4`
- Semantic SHA-256: `5c0b21b126c5177fcabe9b75b65bddbe73bf9436d65b364982678e91820e6803`

Type:

```lean
{Component : Type u_1} →
  [inst : Fintype Component] →
    {_law : NumStability.OneDimensionalHyperbolicConservationLaw Component} →
      NumStability.HyperbolicRiemannProblem _law → Component → Real
```

Fully explicit type:

```lean
{Component : Type u_1} →
  [inst : Fintype.{u_1} Component] →
    {_law : @NumStability.OneDimensionalHyperbolicConservationLaw.{u_1} Component inst} →
      (self : @NumStability.HyperbolicRiemannProblem.{u_1} Component inst _law) → Component → Real
```

Definition body (one-level semantic boundary):

```lean
fun Component [Fintype Component] _law self => self.2
```

### D032: `And`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `37ecdc009aa953e3d4924ef10e6a1fb591f6af993cd344fd5a6b5321466517c9`

Hash-verified prior declaration review:

- Reuse SHA-256: `7b91eb8ccb379917fdd91e364b1caaec6c1c286daa76b30037abf16c3593dcdb`
- Reviewed interpretation: Logical conjunction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D033: `Eq`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `63e9afa87e04d13393a2fe09e8e76489d96be3982734b4b40a52fc6ebea863d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `8c9107a5f2416ef47d86cb3f72449050ef6d38bc4f90aa353708793f7d7b5e2e`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D034: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `723e4e810183a70e6ea00a5362b2a340d9362b22ac8889000dad8fc2208330e5`
- Reviewed interpretation: Existential quantification over a specified type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D035: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Hash-verified prior declaration review:

- Reuse SHA-256: `64909fdce530f606b08116a40d96e269950ad8ef71b75f88d141cfeaf26db2bb`
- Reviewed interpretation: The standard finite index type of natural numbers below its parameter.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D036: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Hash-verified prior declaration review:

- Reuse SHA-256: `3b23d1771bc2d60505b069e55d54c41a51d5ae3a04a2fd45ca506af07ff053ba`
- Reviewed interpretation: Enumerates Fin n using List.finRange n, with completeness and absence of duplicates.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D037: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D038: `InnerProductSpace.toNormedSpace`

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

### D039: `Int`

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

### D040: `Int.instSub`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D041: `IntervalIntegrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D042: `LT.lt`

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

### D043: `MeasureTheory.MeasureSpace.volume`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D044: `Nat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `2e1c25ca42e1e377a41827f0d2f09ae02cfb28ab155c30e277f1000f5e79b32c`

Hash-verified prior declaration review:

- Reuse SHA-256: `e5e9dfc09bf7b25f01ed0dae7ff5067bf153a15a6effaaaa4eaa92e5fef30444`
- Reviewed interpretation: Natural numbers, including zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D045: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Hash-verified prior declaration review:

- Reuse SHA-256: `aba329f01fe1a483789ac86918df395d5c066d445a93e7c1dc54ddf045a102c5`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D046: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `cb1f6b5464ffbe445c485a81bf47ea559d7eef549cfe34a9b4923b3bc8310d41`
- Reviewed interpretation: Retains the norm, additive group, and pseudometric of the supplied ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D047: `NormedAddCommGroup.toNormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D048: `NormedAddGroup.toENormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D049: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `d6ffcf555b0957c936cc49a29b12460f22feaff3f1a34306f54e4eff66d0be6c`
- Reviewed interpretation: Retains the norm, ring, and induced pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D050: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `a81df408b6b5aa855e8821f6db1af48bcd2b59ad721bf6392fd4f355c43bb713`
- Reviewed interpretation: Extracts the value assigned to a natural-number literal by its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D051: `Pi.normedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D052: `Pi.normedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D053: `Pi.normedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D054: `Pi.topologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Constructions`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a81381c20af462683322c70d792fc61454007e60d0781bb4fda6103a009c8abd`

Hash-verified prior declaration review:

- Reuse SHA-256: `f0aec375fcc6a9b3f6279c09f0cca0d6d8d2a36ad83e597c57003ebf5bebe8db`
- Reviewed interpretation: The product topology is constructed from the induced topologies of coordinate evaluations.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D055: `PseudoMetricSpace.toUniformSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a6831039b3ad5e37bd0e7692fd995a699d8bef791976e20262da929990521799`

Hash-verified prior declaration review:

- Reuse SHA-256: `876bc274578501dcc2e04ad2a291290a2b91d351ca27b6523da50b636e7e8334`
- Reviewed interpretation: Projects the uniform space associated with the pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D056: `RCLike.toInnerProductSpaceReal`

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

### D057: `Real`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `38529f0578472feffc4c79d5d0755fa10fc3edafb232ab5e442336d13630ee90`

Hash-verified prior declaration review:

- Reuse SHA-256: `03695349855ae0109fcdb512849bf629ec0358d536e1d9cabc096272790253fd`
- Reviewed interpretation: The standard library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D058: `Real.instLT`

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

### D059: `Real.instRCLike`

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

### D060: `Real.instZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `860eaaa75b06ac6fccbf4f27e9e162807e8851d04bb42d2411332c6368b14882`

Hash-verified prior declaration review:

- Reuse SHA-256: `003266a7dd8bfdd2a52b06268f09bbda63db7580232b94dab8dad6a7649b6703`
- Reviewed interpretation: Selects Real.zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D061: `Real.measureSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Haar.OfBasis`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D062: `Real.normedAddCommGroup`

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

### D063: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Hash-verified prior declaration review:

- Reuse SHA-256: `002b8d2ea679fa3f799683ea22dbe3acad2c91d35ff032045428575649ea4532`
- Reviewed interpretation: Combines the real normed additive group and real commutative ring, retaining their operations and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D064: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Hash-verified prior declaration review:

- Reuse SHA-256: `ee2d20d6bcd993145f7a88e95584a4ace99c3b3fda0d037c5c9d67f666be2021`
- Reviewed interpretation: Combines the real field with its normed additive group and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D065: `Real.pseudoMetricSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.MetricSpace.Pseudo.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9c0d1d56a04dd3ae3fce36b5fb3c2f4fe632c2bdaed84b5667c1a60a03491a3e`

Hash-verified prior declaration review:

- Reuse SHA-256: `1e301a0a369babcf41cc44bcb4ed4d401f6b55b359e5160be69b6ae2b624218b`
- Reviewed interpretation: The distance between x and y is abs(x - y).

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D066: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a29f0377c9baf2265c34aaf85b852e7c4260b34d2dc04574484c335ebc09a6e9`

Hash-verified prior declaration review:

- Reuse SHA-256: `ecd302ae596a797ddc33a2e8990cbb5bc323c371d934ea5a7a62c18b60075604`
- Reviewed interpretation: Retains norm, pseudometric, and ring operations while omitting unit structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D067: `UniformSpace.toTopologicalSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.UniformSpace.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4d18df801a98905221e0935ec2ddacda684a1430b8d198ebc23fad0643bce2a8`

Hash-verified prior declaration review:

- Reuse SHA-256: `ec2c2336f795e4360f1cb33d2d45ce11de744bc02304ba976bab52f567ff9ee4`
- Reviewed interpretation: Projects the underlying topology of a uniform space.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D068: `Zero.toOfNat0`

- Role: `external-frontier`
- Owner module: `Init.Data.Zero`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f7ebe8a983de002c1ee751fd3c144a7c1933b3bb95c87c5001a3cabf5709031a`

Hash-verified prior declaration review:

- Reuse SHA-256: `2208d5f3844f65316472ba98805ba1be70f413188f9490f5812707334353224a`
- Reviewed interpretation: Interprets the literal 0 as the supplied zero element.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D069: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D070: `instLTNat`

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

### D071: `instOfNat`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D072: `instOfNatNat`

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

### D073: `AddGroup.toSubNegMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D074: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D075: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D076: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D078: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Hash-verified prior declaration review:

- Reuse SHA-256: `5ec071004dfbd8e8da208f47ac76bc71d3d1a8fc233247bd9b81588dec1c94c9`
- Reviewed interpretation: A finite enumeration structure on an index type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D079: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D080: `HAdd.hAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `e0bf2a92addd6ea713343e4ef69f67e4e1155781d08f46957b9f71412d865f59`

Hash-verified prior declaration review:

- Reuse SHA-256: `8281c2e5267f73aab7ec3afddb799d045ad2c371bfb7f0b2986dca6516fe150a`
- Reviewed interpretation: Extracts the addition operation from the supplied HAdd instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

### D082: `HSMul.hSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D083: `Int.instAdd`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D084: `NormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `7289fc1f1aac42f488a1fe69c897c4d418a0fa8699118dd0f273085d7d95b741`

Type:

```lean
Type u_8 → Type u_8
```

Fully explicit type:

```lean
(E : Type u_8) → Type u_8
```

### D085: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D086: `NormedAddGroup.toAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D087: `NormedSpace`

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

### D088: `Pi.instSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Notation.Pi.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D089: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D091: `Real.instSub`

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

### D092: `SeminormedAddCommGroup.toPseudoMetricSpace`

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

### D093: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D094: `instHAdd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `38066efd17aeeca52ec2890d9aafca2fa3cce8fda7f5843c1b8e5da130d93981`

Hash-verified prior declaration review:

- Reuse SHA-256: `ed89960c97f5d9dcdd20cbd2a964083cc918e96c5cc580b3955ff33f0abbf075`
- Reviewed interpretation: Uses the supplied homogeneous addition as heterogeneous addition with all types equal.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D095: `instHDiv`

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

### D096: `instHSMul`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D097: `intervalIntegral`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D098: `AddMonoid.toAddZeroClass`

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

### D099: `AddZero.toZero`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D100: `AddZeroClass.toAddZero`

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

### D101: `ContinuousLinearMap`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `inductive`
- Distance from target type: `3`
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

### D102: `ContinuousLinearMap.funLike`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Algebra.Module.LinearMap`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `323d1f39018754b45ba5ba40d3379411a46e1a73045c0b02095e694919f7e9a7`

Type:

```lean
{R₁ : Type u_1} →
  {R₂ : Type u_2} →
    [inst : Semiring R₁] →
      [inst_1 : Semiring R₂] →
        {σ₁₂ : RingHom R₁ R₂} →
          {M₁ : Type u_4} →
            [inst_2 : TopologicalSpace M₁] →
              [inst_3 : AddCommMonoid M₁] →
                {M₂ : Type u_6} →
                  [inst_4 : TopologicalSpace M₂] →
                    [inst_5 : AddCommMonoid M₂] →
                      [inst_6 : Module R₁ M₁] → [inst_7 : Module R₂ M₂] → FunLike (ContinuousLinearMap σ₁₂ M₁ M₂) M₁ M₂
```

Fully explicit type:

```lean
{R₁ : Type u_1} →
  {R₂ : Type u_2} →
    [inst : Semiring.{u_1} R₁] →
      [inst_1 : Semiring.{u_2} R₂] →
        {σ₁₂ :
            @RingHom.{u_1, u_2} R₁ R₂ (@Semiring.toNonAssocSemiring.{u_1} R₁ inst)
              (@Semiring.toNonAssocSemiring.{u_2} R₂ inst_1)} →
          {M₁ : Type u_4} →
            [inst_2 : TopologicalSpace.{u_4} M₁] →
              [inst_3 : AddCommMonoid.{u_4} M₁] →
                {M₂ : Type u_6} →
                  [inst_4 : TopologicalSpace.{u_6} M₂] →
                    [inst_5 : AddCommMonoid.{u_6} M₂] →
                      [inst_6 : @Module.{u_1, u_4} R₁ M₁ inst inst_3] →
                        [inst_7 : @Module.{u_2, u_6} R₂ M₂ inst_1 inst_5] →
                          FunLike.{max (u_6 + 1) (u_4 + 1), u_4 + 1, u_6 + 1}
                            (@ContinuousLinearMap.{u_1, u_2, u_4, u_6} R₁ R₂ inst inst_1 σ₁₂ M₁ inst_2 inst_3 M₂ inst_4
                              inst_5 inst_6 inst_7)
                            M₁ M₂
```

Definition body (one-level semantic boundary):

```lean
fun {R₁} {R₂} [Semiring R₁] [Semiring R₂] {σ₁₂} {M₁} [TopologicalSpace M₁] [AddCommMonoid M₁] {M₂} [TopologicalSpace M₂]
    [AddCommMonoid M₂] [Module R₁ M₁] [Module R₂ M₂] =>
  { coe := fun f => LinearMap.instFunLike.coe f.toLinearMap, coe_injective' := ⋯ }
```

### D103: `DFunLike.coe`

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

### D104: `DenselyNormedField.toNontriviallyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `22b7c7d8fc79e8fdde53f4c5f0f7e47a5b48886ac404b11b983a20e9fe547215`

Hash-verified prior declaration review:

- Reuse SHA-256: `4b1e8606c772bb09fccb1d1908f1a0d5a64b7d1c4491bb72d2cb5c5c500ce53c`
- Reviewed interpretation: Retains the supplied normed field and establishes its nontrivial norm.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D105: `DistribMulAction.toDistribSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D106: `DistribSMul.toSMulZeroClass`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D107: `ENormedAddCommMonoid.toESeminormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D108: `ESeminormedAddCommMonoid.toAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D109: `ESeminormedAddCommMonoid.toESeminormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D110: `ESeminormedAddMonoid.toAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D111: `HasFDerivAt`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.FDeriv.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D112: `Inv.inv`

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

### D113: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `e552ffc8c85b917dca38e5965ad91773fdb989246623a528d91526b75d68c2f1`

Hash-verified prior declaration review:

- Reuse SHA-256: `8f22552378de8f424532f8111f641349763934fd16ddf331ec0f56682af00bec`
- Reviewed interpretation: A matrix is a function from row indices to column indices to entries.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D114: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `715de3f0bd9e7bcf034726e1efbf1b4dad42a16e2ce790d4403774d16ed5b549`

Hash-verified prior declaration review:

- Reuse SHA-256: `3b61ae8c768be857d98f0738ab2e9bc72cf631d7149ab43ec2d5d04119ac5122`
- Reviewed interpretation: At row i, takes the dot product of row M i with the input vector.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D115: `Module.toDistribMulAction`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `88cb31241158a61c2eaae8459f700e8db39d9fca998e95d4fa73b87b68be8c60`

Hash-verified prior declaration review:

- Reuse SHA-256: `001eb129b0f9b9d36eccd859708b6aa95eb9bbdf305a1c6198c1bd7f1b5eca4d`
- Reviewed interpretation: Projects the distributive scalar action from a module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D116: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `3bd70454a5180abed6221bb3f73922ebc30c10136298d23eb30d358cdd2fdb82`

Hash-verified prior declaration review:

- Reuse SHA-256: `c28706255fc93791245a394681cd0c06ca927c4c23e80aff273aa907b5dd38bf`
- Reviewed interpretation: Retains the underlying ring operations while forgetting associativity structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D117: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Hash-verified prior declaration review:

- Reuse SHA-256: `9faf6b31fd0d1e8e168c84cafba10451b3a5e3bbfe966779c5185612a86dfaa3`
- Reviewed interpretation: Projects the underlying nonassociative ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D118: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `203cd405009eafaf7685d65e53998c150f5b43f558b14158fc8c95ddf426d104`
- Reviewed interpretation: Builds a semiring structure with the original addition and multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D119: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Hash-verified prior declaration review:

- Reuse SHA-256: `58cf1cf5d482b7641c096b5a8487b30deb88984aa54721300c72a9b8f8b0680a`
- Reviewed interpretation: Retains ring operations and commutativity while dropping norm structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D120: `NormedAddCommGroup.toENormedAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D121: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Hash-verified prior declaration review:

- Reuse SHA-256: `41b00e2dcf40f034dd6567922608bc721a8ab7fd7583f194e0759cac35a08b5f`
- Reviewed interpretation: Copies the norm, metric, and ring operations into the structure without a unit requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D122: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `3`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Hash-verified prior declaration review:

- Reuse SHA-256: `4fddb773ba19ad0ce10884f238abb0e94d131ea74e9031ca0f3a908bb5b7660f`
- Reviewed interpretation: Projects the underlying module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D123: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `921742a1effe7c5d653ed6512c1187064090ee805009644177b1646ce2ee15b1`

Hash-verified prior declaration review:

- Reuse SHA-256: `703fc11e24b156f6d19271ceddc9f15365e5fe6c9175fce541f736253a9faf76`
- Reviewed interpretation: Uses the product module on functions with fixed codomain.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D124: `Pi.addCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `1ff5ab7097969c98627adc1250432bd9fa32995632035a4346ce1d770c552153`

Hash-verified prior declaration review:

- Reuse SHA-256: `799d4a8feaa33213a0efbcdb438ead2f641e5688c30960ceb0bb95ed4e775e82`
- Reviewed interpretation: Builds the additive commutative group of functions from coordinate additive groups.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D125: `Pi.addCommMonoid`

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

### D126: `Real.denselyNormedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `4e05f43f0aeaac135f86bed438060268b7a1c7e5a288939a5075d7a9f7b2e105`

Hash-verified prior declaration review:

- Reuse SHA-256: `d0102e18c23b55bfe79ef7f9443c92189e0cc4d305f5362251ea95e55c5747c2`
- Reviewed interpretation: Equips Real with its normed field and the dense-norm property.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D127: `Real.instAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
- Semantic SHA-256: `b34bb82f0825ba57903ab69349a17976c5b261082b1e5dd3b28e8c2a96ee46cc`

Hash-verified prior declaration review:

- Reuse SHA-256: `8822a20c671bf6dbd2bce45cb2dee31ba72bc0db525fbce105d953b89fcfc623`
- Reviewed interpretation: Supplies the standard inferred additive commutative group of Real.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D128: `Real.instAddCommMonoid`

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

### D129: `Real.instInv`

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

### D130: `Real.instMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D131: `Real.semiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D132: `RingHom.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Hom.Defs`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D133: `SMulZeroClass.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.GroupWithZero.Action.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D134: `Semiring.toNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `3`
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

### D135: `CommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D136: `Module.Basis`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `inductive`
- Distance from target type: `4`
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

### D137: `Module.Basis.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D138: `Real.commRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `4`
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

### D139: `Semiring.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `def`
- Distance from target type: `4`
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
