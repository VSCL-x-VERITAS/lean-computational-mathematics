# Declaration dossier for LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_riemannProblem_iff_hyperbolicInitialData
    {m : ℕ} (problem : FirstOrderInitialValueProblem (Fin m)) :
    (problem.IsRiemann ↔
      ∃ leftState rightState,
        (∀ x t state, state ∈ problem.governing.admissibleStates →
          ∃ (eigenvalues : Fin m → ℝ)
              (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
            ∀ p, (problem.governing.principal x t state).mulVec (eigenbasis p) =
              eigenvalues p • eigenbasis p) ∧
        leftState ∈ problem.governing.admissibleStates ∧
        rightState ∈ problem.governing.admissibleStates ∧
        (∀ x, x < 0 → problem.initialState x = leftState) ∧
        (∀ x, 0 < x → problem.initialState x = rightState)) ∧
    (problem.IsJumpRiemann ↔
      ∃ leftState rightState,
        problem.IsRiemannWithStates leftState rightState ∧ leftState ≠ rightState)
```

## Elaborated target type

```lean
∀ {m : Nat} (problem : NumStability.FirstOrderInitialValueProblem (Fin m)),
  And
    (Iff problem.IsRiemann
      (Exists fun leftState =>
        Exists fun rightState =>
          And
            (∀ (x t : Real) (state : Fin m → Real),
              Set.instMembership.mem problem.governing.admissibleStates state →
                Exists fun eigenvalues =>
                  Exists fun eigenbasis =>
                    ∀ (p : Fin m),
                      Eq ((problem.governing.principal x t state).mulVec (Module.Basis.instFunLike.coe eigenbasis p))
                        (instHSMul.hSMul (eigenvalues p) (Module.Basis.instFunLike.coe eigenbasis p)))
            (And (Set.instMembership.mem problem.governing.admissibleStates leftState)
              (And (Set.instMembership.mem problem.governing.admissibleStates rightState)
                (And (∀ (x : Real), Real.instLT.lt x 0 → Eq (problem.initialState x) leftState)
                  (∀ (x : Real), Real.instLT.lt 0 x → Eq (problem.initialState x) rightState))))))
    (Iff problem.IsJumpRiemann
      (Exists fun leftState =>
        Exists fun rightState => And (problem.IsRiemannWithStates leftState rightState) (Ne leftState rightState)))
```

## Fully explicit elaborated target type

```lean
∀ {m : Nat} (problem : @NumStability.FirstOrderInitialValueProblem.{0} (Fin m) (Fin.fintype m)),
  And
    (Iff (@NumStability.FirstOrderInitialValueProblem.IsRiemann.{0} (Fin m) (Fin.fintype m) problem)
      (@Exists.{1} (Fin m → Real) fun (leftState : Fin m → Real) =>
        @Exists.{1} (Fin m → Real) fun (rightState : Fin m → Real) =>
          And
            (∀ (x t : Real) (state : Fin m → Real),
              @Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
                  (@NumStability.FirstOrderEquation.admissibleStates.{0} (Fin m) (Fin.fintype m)
                    (@NumStability.FirstOrderInitialValueProblem.governing.{0} (Fin m) (Fin.fintype m) problem))
                  state →
                @Exists.{1} (Fin m → Real) fun (eigenvalues : Fin m → Real) =>
                  @Exists.{1}
                    (@Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                      (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                        Real.instAddCommMonoid)
                      (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                        (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                          (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                            (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                              (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                          (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                    fun
                      (eigenbasis :
                        @Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                          (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                            Real.instAddCommMonoid)
                          (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                            (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                              (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                  (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                    (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                              (@NormedField.toNormedSpace.{0} Real Real.normedField)))) =>
                    ∀ (p : Fin m),
                      @Eq.{1} (Fin m → Real)
                        (@Matrix.mulVec.{0, 0, 0} (Fin m) (Fin m) Real
                          (@NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} Real
                            (@NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} Real
                              (@NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} Real
                                (@NonUnitalNormedCommRing.toNonUnitalCommRing.{0} Real
                                  (@NormedCommRing.toNonUnitalNormedCommRing.{0} Real Real.normedCommRing)))))
                          (Fin.fintype m)
                          (@NumStability.FirstOrderEquation.principal.{0} (Fin m) (Fin.fintype m)
                            (@NumStability.FirstOrderInitialValueProblem.governing.{0} (Fin m) (Fin.fintype m) problem)
                            x t state)
                          (@DFunLike.coe.{1, 1, 1}
                            (@Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                              (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                Real.instAddCommMonoid)
                              (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                                (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                  (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                            (Fin m) (fun (x : Fin m) => Fin m → Real)
                            (@Module.Basis.instFunLike.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                              (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                Real.instAddCommMonoid)
                              (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                                (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                  (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                            eigenbasis p))
                        (@HSMul.hSMul.{0, 0, 0} Real (Fin m → Real) (Fin m → Real)
                          (@instHSMul.{0, 0} Real (Fin m → Real)
                            (@Function.hasSMul.{0, 0, 0} (Fin m) Real Real
                              (@Algebra.toSMul.{0, 0} Real Real Real.instCommSemiring
                                (@CommSemiring.toSemiring.{0} Real Real.instCommSemiring)
                                (@Algebra.id.{0} Real Real.instCommSemiring))))
                          (eigenvalues p)
                          (@DFunLike.coe.{1, 1, 1}
                            (@Module.Basis.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                              (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                Real.instAddCommMonoid)
                              (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                                (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                  (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                            (Fin m) (fun (x : Fin m) => Fin m → Real)
                            (@Module.Basis.instFunLike.{0, 0, 0} (Fin m) Real (Fin m → Real) Real.semiring
                              (@Pi.addCommMonoid.{0, 0} (Fin m) (fun (a : Fin m) => Real) fun (i : Fin m) =>
                                Real.instAddCommMonoid)
                              (@Pi.Function.module.{0, 0, 0} (Fin m) Real Real Real.semiring Real.instAddCommMonoid
                                (@NormedSpace.toModule.{0, 0} Real Real Real.normedField
                                  (@NonUnitalSeminormedRing.toSeminormedAddCommGroup.{0} Real
                                    (@NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing.{0} Real
                                      (@SeminormedCommRing.toNonUnitalSeminormedCommRing.{0} Real
                                        (@NormedCommRing.toSeminormedCommRing.{0} Real Real.normedCommRing))))
                                  (@NormedField.toNormedSpace.{0} Real Real.normedField))))
                            eigenbasis p)))
            (And
              (@Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
                (@NumStability.FirstOrderEquation.admissibleStates.{0} (Fin m) (Fin.fintype m)
                  (@NumStability.FirstOrderInitialValueProblem.governing.{0} (Fin m) (Fin.fintype m) problem))
                leftState)
              (And
                (@Membership.mem.{0, 0} (Fin m → Real) (Set.{0} (Fin m → Real)) (@Set.instMembership.{0} (Fin m → Real))
                  (@NumStability.FirstOrderEquation.admissibleStates.{0} (Fin m) (Fin.fintype m)
                    (@NumStability.FirstOrderInitialValueProblem.governing.{0} (Fin m) (Fin.fintype m) problem))
                  rightState)
                (And
                  (∀ (x : Real),
                    @LT.lt.{0} Real Real.instLT x
                        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) →
                      @Eq.{1} (Fin m → Real)
                        (@NumStability.FirstOrderInitialValueProblem.initialState.{0} (Fin m) (Fin.fintype m) problem x)
                        leftState)
                  (∀ (x : Real),
                    @LT.lt.{0} Real Real.instLT
                        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) x →
                      @Eq.{1} (Fin m → Real)
                        (@NumStability.FirstOrderInitialValueProblem.initialState.{0} (Fin m) (Fin.fintype m) problem x)
                        rightState))))))
    (Iff (@NumStability.FirstOrderInitialValueProblem.IsJumpRiemann.{0} (Fin m) (Fin.fintype m) problem)
      (@Exists.{1} (Fin m → Real) fun (leftState : Fin m → Real) =>
        @Exists.{1} (Fin m → Real) fun (rightState : Fin m → Real) =>
          And
            (@NumStability.FirstOrderInitialValueProblem.IsRiemannWithStates.{0} (Fin m) (Fin.fintype m) problem
              leftState rightState)
            (@Ne.{1} (Fin m → Real) leftState rightState)))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.FirstOrderEquation.admissibleStates`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0365333ee493335ae9a2ccae3dd1fee52eb71d70eeb49696d65f3a91fda28ef8`

Type:

```lean
{ι : Type u_2} → [inst : Fintype ι] → NumStability.FirstOrderEquation ι → Set (ι → Real)
```

Fully explicit type:

```lean
{ι : Type u_2} →
  [inst : Fintype.{u_2} ι] → (self : @NumStability.FirstOrderEquation.{u_2} ι inst) → Set.{u_2} (ι → Real)
```

Definition body (one-level semantic boundary):

```lean
fun ι [Fintype ι] self => self.1
```

### D002: `NumStability.FirstOrderEquation.principal`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `0192967be0d18221f6de85a5324dfc973619ab05c0878ba4ef341c33df74d56b`

Type:

```lean
{ι : Type u_2} → [inst : Fintype ι] → NumStability.FirstOrderEquation ι → Real → Real → (ι → Real) → Matrix ι ι Real
```

Fully explicit type:

```lean
{ι : Type u_2} →
  [inst : Fintype.{u_2} ι] →
    (self : @NumStability.FirstOrderEquation.{u_2} ι inst) → Real → Real → (ι → Real) → Matrix.{u_2, u_2, 0} ι ι Real
```

Definition body (one-level semantic boundary):

```lean
fun ι [Fintype ι] self => self.2
```

### D003: `NumStability.FirstOrderInitialValueProblem`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `c87344daa8a14087c412598a74c475c1744e5c0ec0fc736cd92a83df1b121418`

Type:

```lean
(ι : Type u_2) → [Fintype ι] → Type u_2
```

Fully explicit type:

```lean
(ι : Type u_2) → [Fintype.{u_2} ι] → Type u_2
```

### D004: `NumStability.FirstOrderInitialValueProblem.IsJumpRiemann`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `d12ca5719af28395f6393f082ba19a71977e5188446bc0d31a72a4d453b2af20`

Type:

```lean
{ι : Type u_1} → [inst : Fintype ι] → NumStability.FirstOrderInitialValueProblem ι → Prop
```

Fully explicit type:

```lean
{ι : Type u_1} → [inst : Fintype.{u_1} ι] → (problem : @NumStability.FirstOrderInitialValueProblem.{u_1} ι inst) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] problem =>
  Exists fun leftState =>
    Exists fun rightState => And (problem.IsRiemannWithStates leftState rightState) (Ne leftState rightState)
```

### D005: `NumStability.FirstOrderInitialValueProblem.IsRiemann`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `8cb8f9e2a4394958fd5720c9b386efb8516f3b06bf4ed1ba0b066797e43edeb6`

Type:

```lean
{ι : Type u_1} → [inst : Fintype ι] → NumStability.FirstOrderInitialValueProblem ι → Prop
```

Fully explicit type:

```lean
{ι : Type u_1} → [inst : Fintype.{u_1} ι] → (problem : @NumStability.FirstOrderInitialValueProblem.{u_1} ι inst) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] problem =>
  Exists fun leftState => Exists fun rightState => problem.IsRiemannWithStates leftState rightState
```

### D006: `NumStability.FirstOrderInitialValueProblem.IsRiemannWithStates`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `27da6558b7a163298647227c24b6e334f62bccba6499189d799d017a263b9611`

Type:

```lean
{ι : Type u_1} → [inst : Fintype ι] → NumStability.FirstOrderInitialValueProblem ι → (ι → Real) → (ι → Real) → Prop
```

Fully explicit type:

```lean
{ι : Type u_1} →
  [inst : Fintype.{u_1} ι] →
    (problem : @NumStability.FirstOrderInitialValueProblem.{u_1} ι inst) → (leftState rightState : ι → Real) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] problem leftState rightState =>
  And problem.governing.IsHyperbolic
    (And (Set.instMembership.mem problem.governing.admissibleStates leftState)
      (And (Set.instMembership.mem problem.governing.admissibleStates rightState)
        (NumStability.IsRiemannData problem.initialState leftState rightState)))
```

### D007: `NumStability.FirstOrderInitialValueProblem.governing`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `b8a4f3e1cf7721ae62ce8c1be62cf36ef9a96850e1201998259dc6e156ed22e7`

Type:

```lean
{ι : Type u_2} → [inst : Fintype ι] → NumStability.FirstOrderInitialValueProblem ι → NumStability.FirstOrderEquation ι
```

Fully explicit type:

```lean
{ι : Type u_2} →
  [inst : Fintype.{u_2} ι] →
    (self : @NumStability.FirstOrderInitialValueProblem.{u_2} ι inst) → @NumStability.FirstOrderEquation.{u_2} ι inst
```

Definition body (one-level semantic boundary):

```lean
fun ι [Fintype ι] self => self.1
```

### D008: `NumStability.FirstOrderInitialValueProblem.initialState`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6e925ab8e9e105a647ccfca8892ffb24cfa42c1f2f7790de75d622ab4de1eb0a`

Type:

```lean
{ι : Type u_2} → [inst : Fintype ι] → NumStability.FirstOrderInitialValueProblem ι → Real → ι → Real
```

Fully explicit type:

```lean
{ι : Type u_2} →
  [inst : Fintype.{u_2} ι] → (self : @NumStability.FirstOrderInitialValueProblem.{u_2} ι inst) → Real → ι → Real
```

Definition body (one-level semantic boundary):

```lean
fun ι [Fintype ι] self => self.2
```

### D009: `NumStability.FirstOrderEquation`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `2f94110f39ae8297c63bf6e893e4cebff724a0f71a9358481ab6e31a15bb99df`

Type:

```lean
(ι : Type u_2) → [Fintype ι] → Type u_2
```

Fully explicit type:

```lean
(ι : Type u_2) → [Fintype.{u_2} ι] → Type u_2
```

### D010: `NumStability.FirstOrderEquation.IsHyperbolic`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `eb946e70ccbc99ede0eb6388f7b23d26dfac0b9389c07a929277f51a6badf9b5`

Type:

```lean
{ι : Type u_1} → [inst : Fintype ι] → NumStability.FirstOrderEquation ι → Prop
```

Fully explicit type:

```lean
{ι : Type u_1} → [inst : Fintype.{u_1} ι] → (equation : @NumStability.FirstOrderEquation.{u_1} ι inst) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun {ι} [Fintype ι] equation =>
  ∀ (x t : Real) (state : ι → Real),
    Set.instMembership.mem equation.admissibleStates state →
      NumStability.IsRealHyperbolicMatrix (equation.principal x t state)
```

### D011: `NumStability.FirstOrderInitialValueProblem.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann`
- Declaration kind: `constructor`
- Distance from target type: `2`
- Semantic SHA-256: `11d02cb3d7f39f6fa506c249642c0d9484d936caaa9f6ab3c6894924de727218`

Type:

```lean
{ι : Type u_2} →
  [inst : Fintype ι] →
    NumStability.FirstOrderEquation ι → (Real → ι → Real) → NumStability.FirstOrderInitialValueProblem ι
```

Fully explicit type:

```lean
{ι : Type u_2} →
  [inst : Fintype.{u_2} ι] →
    (governing : @NumStability.FirstOrderEquation.{u_2} ι inst) →
      (initialState : Real → ι → Real) → @NumStability.FirstOrderInitialValueProblem.{u_2} ι inst
```

### D012: `NumStability.IsRiemannData`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D013: `NumStability.FirstOrderEquation.mk`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation`
- Declaration kind: `constructor`
- Distance from target type: `3`
- Semantic SHA-256: `cc353d82d4232d3a47440e5dd9536e52ac34cbfc662d6f0d8a687241e0db06d5`

Type:

```lean
{ι : Type u_2} →
  [inst : Fintype ι] →
    Set (ι → Real) →
      (Real → Real → (ι → Real) → Matrix ι ι Real) →
        (Real → Real → (ι → Real) → ι → Real) → NumStability.FirstOrderEquation ι
```

Fully explicit type:

```lean
{ι : Type u_2} →
  [inst : Fintype.{u_2} ι] →
    (admissibleStates : Set.{u_2} (ι → Real)) →
      (principal : Real → Real → (ι → Real) → Matrix.{u_2, u_2, 0} ι ι Real) →
        (forcing : Real → Real → (ι → Real) → ι → Real) → @NumStability.FirstOrderEquation.{u_2} ι inst
```

### D014: `NumStability.IsRealHyperbolicMatrix`

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

### D015: `Algebra.id`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D016: `Algebra.toSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Algebra.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D017: `And`

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

### D018: `CommSemiring.toSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D019: `DFunLike.coe`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.FunLike.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D020: `Eq`

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

### D021: `Exists`

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

### D022: `Fin`

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

### D023: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D024: `Function.hasSMul`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Action.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D025: `HSMul.hSMul`

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

### D026: `Iff`

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

### D027: `LT.lt`

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

### D028: `Matrix.mulVec`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Matrix.Mul`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D029: `Membership.mem`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D030: `Module.Basis`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
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

### D031: `Module.Basis.instFunLike`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Basis.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D032: `Nat`

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

### D033: `Ne`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D034: `NonUnitalCommRing.toNonUnitalNonAssocCommRing`

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

### D035: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

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

### D036: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

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

### D037: `NonUnitalNormedCommRing.toNonUnitalCommRing`

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

### D038: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

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

### D039: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

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

### D040: `NormedCommRing.toNonUnitalNormedCommRing`

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

### D041: `NormedCommRing.toSeminormedCommRing`

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

### D042: `NormedField.toNormedSpace`

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

### D043: `NormedSpace.toModule`

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

### D045: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D046: `Pi.addCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Pi.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D047: `Real`

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

### D048: `Real.instAddCommMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D049: `Real.instCommSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D050: `Real.instLT`

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

### D051: `Real.instZero`

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

### D052: `Real.normedCommRing`

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

### D053: `Real.normedField`

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

### D054: `Real.semiring`

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

### D055: `SeminormedCommRing.toNonUnitalSeminormedCommRing`

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

### D056: `Set`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D057: `Set.instMembership`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D058: `Zero.toOfNat0`

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

### D059: `instHSMul`

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

### D060: `Fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Defs`
- Declaration kind: `inductive`
- Distance from target type: `2`
- Semantic SHA-256: `ff39697629d53c72a76ae41500ef08888ff834898920af48012f83225b729e55`

Type:

```lean
Type u_4 → Type u_4
```

Fully explicit type:

```lean
(α : Type u_4) → Type u_4
```

### D061: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D062: `CommRing.toNonUnitalCommRing`

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

### D063: `Real.commRing`

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

### D064: `Semiring.toModule`

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

## Complete local imported sources

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConstantCoefficientLinearSystem.lean`
SHA-256: `626e45fe5554994975bbe19775b9bdcb6cbcd62a713dfef1568986958459a4ef`

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
  /-- The component-valued state as a function of space and time. -/
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

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaw.lean`
SHA-256: `933db56e0899e4a226cd14ce0be8cdc20646a2a0b33dc66fb501704f6f01a8f0`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Pi
import Mathlib.Data.Matrix.Basic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem

/-!
# One-dimensional conservation laws

Source-independent pointwise predicates for classical one-dimensional
conservation laws, their quasilinear form, and constant linear fluxes.
-/

namespace NumStability

/-- A state satisfies the classical conservation-law residual
`q_t + (flux(q))_x = 0` at `(x,t)`. -/
def IsConservationLawSolutionAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ)) (x t : ℝ) : Prop :=
  ∃ qt fluxx : ι → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => flux (q ξ t)) fluxx x ∧
        qt + fluxx = 0

/-- A state satisfies the quasilinear equation
`q_t + Dflux(q) q_x = 0` at `(x,t)`. -/
def IsQuasilinearConservationLawSolutionAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (fluxDerivative :
      (ι → ℝ) → ((ι → ℝ) →L[ℝ] (ι → ℝ)))
    (x t : ℝ) : Prop :=
  ∃ qt qx : ι → ℝ,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
        qt + fluxDerivative (q x t) qx = 0

/-- Under the explicit differentiability hypotheses needed for the chain
rule, the conservation residual and its quasilinear form are equivalent. -/
theorem conservationLaw_iff_quasilinearAt
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ))
    (fluxDerivative :
      (ι → ℝ) → ((ι → ℝ) →L[ℝ] (ι → ℝ)))
    (x t : ℝ) (qx : ι → ℝ)
    (hqx : HasDerivAt (fun ξ => q ξ t) qx x)
    (hflux : HasFDerivAt flux (fluxDerivative (q x t)) (q x t)) :
    IsConservationLawSolutionAt q flux x t ↔
      IsQuasilinearConservationLawSolutionAt q fluxDerivative x t := by
  have hchain :
      HasDerivAt (fun ξ => flux (q ξ t))
        (fluxDerivative (q x t) qx) x := by
    simpa only [Function.comp_apply, ContinuousLinearMap.comp_apply,
      ContinuousLinearMap.toSpanSingleton_apply, one_smul] using
      (hflux.comp x hqx.hasFDerivAt).hasDerivAt
  constructor
  · rintro ⟨qt, fluxx, hqt, hfluxx, hresidual⟩
    have hfluxx_unique : fluxx = fluxDerivative (q x t) qx :=
      hfluxx.unique hchain
    subst fluxx
    exact ⟨qt, qx, hqt, hqx, hresidual⟩
  · rintro ⟨qt, qx', hqt, hqx', hresidual⟩
    have hchain' :
        HasDerivAt (fun ξ => flux (q ξ t))
          (fluxDerivative (q x t) qx') x := by
      simpa only [Function.comp_apply, ContinuousLinearMap.comp_apply,
        ContinuousLinearMap.toSpanSingleton_apply, one_smul] using
        (hflux.comp x hqx'.hasFDerivAt).hasDerivAt
    exact ⟨qt, fluxDerivative (q x t) qx', hqt, hchain', hresidual⟩

/-- The constant linear flux `state ↦ A state`. -/
def constantLinearFlux
    {ι : Type*} [Fintype ι]
    (coefficient : Matrix ι ι ℝ) (state : ι → ℝ) : ι → ℝ :=
  coefficient.mulVec state

/-- Along a differentiable state curve, the derivative of a constant linear
flux is the same matrix applied to the state derivative. -/
theorem hasDerivAt_constantLinearFlux_comp
    {ι : Type*} [Fintype ι]
    (coefficient : Matrix ι ι ℝ)
    (state : ℝ → (ι → ℝ)) (stateDerivative : ι → ℝ) (x : ℝ)
    (hstate : HasDerivAt state stateDerivative x) :
    HasDerivAt (fun ξ => constantLinearFlux coefficient (state ξ))
      (coefficient.mulVec stateDerivative) x := by
  rw [hasDerivAt_pi] at hstate ⊢
  intro i
  simp only [constantLinearFlux, Matrix.mulVec, dotProduct]
  exact HasDerivAt.fun_sum fun j _ => (hstate j).const_mul (coefficient i j)

/-- A conservation law with constant linear flux `f(q) = A q` is exactly the
constant-coefficient first-order system `q_t + A q_x = 0`. -/
theorem conservationLaw_constantLinearFlux_iff
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ)) (coefficient : Matrix ι ι ℝ)
    (x t : ℝ) (qx : ι → ℝ)
    (hqx : HasDerivAt (fun ξ => q ξ t) qx x) :
    IsConservationLawSolutionAt q (constantLinearFlux coefficient) x t ↔
      IsConstantCoefficientLinearSystemSolutionAt q coefficient x t := by
  constructor
  · rintro ⟨qt, fluxx, hqt, hfluxx, hresidual⟩
    have hlinear := hasDerivAt_constantLinearFlux_comp
      coefficient (fun ξ => q ξ t) qx x hqx
    have hfluxx_unique : fluxx = coefficient.mulVec qx :=
      hfluxx.unique hlinear
    subst fluxx
    exact ⟨qt, qx, hqt, hqx, hresidual⟩
  · rintro ⟨qt, qx', hqt, hqx', hresidual⟩
    refine ⟨qt, coefficient.mulVec qx', hqt, ?_, hresidual⟩
    exact hasDerivAt_constantLinearFlux_comp
      coefficient (fun ξ => q ξ t) qx' x hqx'

/-- Every solution of a constant-coefficient system is a conservation-law
solution for the corresponding linear flux. -/
theorem constantCoefficientLinearSystem_isConservationLaw
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ)) (coefficient : Matrix ι ι ℝ)
    (x t : ℝ)
    (hsystem : IsConstantCoefficientLinearSystemSolutionAt
      q coefficient x t) :
    IsConservationLawSolutionAt q (constantLinearFlux coefficient) x t := by
  rcases hsystem with ⟨qt, qx, hqt, hqx, hresidual⟩
  refine ⟨qt, coefficient.mulVec qx, hqt, ?_, hresidual⟩
  exact hasDerivAt_constantLinearFlux_comp
    coefficient (fun ξ => q ξ t) qx x hqx

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/Hyperbolicity.lean`
SHA-256: `f5ca138c081a318a3a5186927d0f2ae2af35d3ed9171f685b7f8bf450e6ae33e`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# Real hyperbolicity of constant coefficient matrices

Source-independent finite-dimensional hyperbolicity for a real square matrix.
The defining data are real eigenvalues and a basis of corresponding right
eigenvectors.  This is equivalent to having a full linearly independent family
of real eigenvectors, and the basis supplies unique characteristic
coordinates for every state.
-/

open scoped BigOperators

namespace NumStability

/-- A real square matrix is hyperbolic when it has a basis of real right
eigenvectors with real eigenvalues. -/
def IsRealHyperbolicMatrix {ι : Type*} [Fintype ι]
    (coefficient : Matrix ι ι ℝ) : Prop :=
  ∃ (eigenvalues : ι → ℝ)
      (eigenbasis : Module.Basis ι ℝ (ι → ℝ)),
    ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p

/-- In a square real coordinate space, the eigenbasis definition of
hyperbolicity is equivalent to a full linearly independent family of real
eigenvectors. -/
theorem isRealHyperbolicMatrix_iff_independent_real_eigenvectors
    {ι : Type*} [Fintype ι] (coefficient : Matrix ι ι ℝ) :
    IsRealHyperbolicMatrix coefficient ↔
      ∃ (eigenvalues : ι → ℝ) (eigenvectors : ι → (ι → ℝ)),
        LinearIndependent ℝ eigenvectors ∧
          ∀ p, coefficient.mulVec (eigenvectors p) =
            eigenvalues p • eigenvectors p := by
  constructor
  · rintro ⟨eigenvalues, eigenbasis, heigen⟩
    exact ⟨eigenvalues, eigenbasis, eigenbasis.linearIndependent, heigen⟩
  · rintro ⟨eigenvalues, eigenvectors, hindependent, heigen⟩
    letI : Decidable (Nonempty ι) := Classical.dec (Nonempty ι)
    let eigenbasis := basisOfPiSpaceOfLinearIndependent hindependent
    refine ⟨eigenvalues, eigenbasis, ?_⟩
    intro p
    change coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p
    rw [show (eigenbasis : ι → (ι → ℝ)) = eigenvectors by
      exact coe_basisOfPiSpaceOfLinearIndependent hindependent]
    exact heigen p

/-- Hyperbolic eigendata give every state a unique expansion in the real
eigenbasis. -/
theorem IsRealHyperbolicMatrix.exists_unique_eigenbasis_decomposition
    {ι : Type*} [Fintype ι] {coefficient : Matrix ι ι ℝ}
    (hcoefficient : IsRealHyperbolicMatrix coefficient) :
    ∃ (eigenvalues : ι → ℝ)
        (eigenbasis : Module.Basis ι ℝ (ι → ℝ)),
      (∀ p, coefficient.mulVec (eigenbasis p) =
        eigenvalues p • eigenbasis p) ∧
      ∀ q : ι → ℝ,
        ∃! amplitudes : ι → ℝ,
          ∑ p, amplitudes p • eigenbasis p = q := by
  rcases hcoefficient with ⟨eigenvalues, eigenbasis, heigen⟩
  refine ⟨eigenvalues, eigenbasis, heigen, fun q => ?_⟩
  refine ⟨eigenbasis.equivFun q, ?_, ?_⟩
  · change ∑ p, (eigenbasis.equivFun q) p • eigenbasis p = q
    rw [← eigenbasis.equivFun_symm_apply]
    exact eigenbasis.equivFun.symm_apply_apply q
  · intro amplitudes hamplitudes
    apply eigenbasis.equivFun.symm.injective
    rw [eigenbasis.equivFun.symm_apply_apply]
    rw [eigenbasis.equivFun_symm_apply]
    exact hamplitudes

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FirstOrderEquation.lean`
SHA-256: `05833771ccf239e9312ca61d019ae12b6bcdefebedf1f5da294a01ae32e9080b`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity

/-!
# First-order quasilinear equations

An equation stores its admissible states, principal matrix and forcing.
Its residual expresses `q_t + A(x,t,q) q_x = b(x,t,q)`. Spectral hyperbolicity
uses that same matrix. The optional classical relation uses actual derivatives;
constant and spatially varying linear equations embed as special cases.
-/

namespace NumStability

variable {ι : Type*} [Fintype ι]

/-- A concrete first-order quasilinear equation, with a declared state domain. -/
structure FirstOrderEquation (ι : Type*) [Fintype ι] where
  admissibleStates : Set (ι → ℝ)
  principal : ℝ → ℝ → (ι → ℝ) → Matrix ι ι ℝ
  forcing : ℝ → ℝ → (ι → ℝ) → (ι → ℝ)

namespace FirstOrderEquation

/-- The actual equation expression evaluated on state, time and space derivatives. -/
def residual (equation : FirstOrderEquation ι) (x t : ℝ)
    (state timeDerivative spaceDerivative : ι → ℝ) : ι → ℝ :=
  timeDerivative + (equation.principal x t state).mulVec spaceDerivative -
    equation.forcing x t state

theorem residual_eq_zero_iff (equation : FirstOrderEquation ι) (x t : ℝ)
    (state timeDerivative spaceDerivative : ι → ℝ) :
    equation.residual x t state timeDerivative spaceDerivative = 0 ↔
      timeDerivative + (equation.principal x t state).mulVec spaceDerivative =
        equation.forcing x t state := sub_eq_zero

/-- A real eigenbasis for the actual principal matrix at each admissible state. -/
def IsHyperbolic (equation : FirstOrderEquation ι) : Prop :=
  ∀ x t state, state ∈ equation.admissibleStates →
    IsRealHyperbolicMatrix (equation.principal x t state)

/-- An optional classical relation, using actual derivatives of the supplied field. -/
def IsClassicalSolutionAt (equation : FirstOrderEquation ι)
    (q : ℝ → ℝ → (ι → ℝ)) (x t : ℝ) : Prop :=
  q x t ∈ equation.admissibleStates ∧
    ∃ qt qx : ι → ℝ,
      HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
      equation.residual x t (q x t) qt qx = 0

/-- A constant linear system is a special case of the concrete equation object. -/
def constantLinear (coefficient : Matrix ι ι ℝ) : FirstOrderEquation ι where
  admissibleStates := Set.univ
  principal := fun _ _ _ => coefficient
  forcing := fun _ _ _ => 0

theorem constantLinear_isHyperbolic (coefficient : Matrix ι ι ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient) :
    (constantLinear coefficient).IsHyperbolic := fun _ _ _ _ => hcoefficient

theorem constantLinear_classical_iff (coefficient : Matrix ι ι ℝ)
    (q : ℝ → ℝ → (ι → ℝ)) (x t : ℝ) :
    (constantLinear coefficient).IsClassicalSolutionAt q x t ↔
      IsConstantCoefficientLinearSystemSolutionAt q coefficient x t := by
  simp only [IsClassicalSolutionAt, constantLinear, Set.mem_univ, true_and,
    residual, sub_zero, IsConstantCoefficientLinearSystemSolutionAt]

/-- The representation includes spatially varying matrices without requiring a flux. -/
def variableLinear (coefficient : ℝ → Matrix ι ι ℝ) : FirstOrderEquation ι where
  admissibleStates := Set.univ
  principal := fun x _ _ => coefficient x
  forcing := fun _ _ _ => 0

theorem variableLinear_isHyperbolic (coefficient : ℝ → Matrix ι ι ℝ)
    (hcoefficient : ∀ x, IsRealHyperbolicMatrix (coefficient x)) :
    (variableLinear coefficient).IsHyperbolic := fun x _ _ _ => hcoefficient x

end FirstOrderEquation

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData.lean`
SHA-256: `35ab3a9c610ddbc90dec920888d39ff4bd36c54e7fe093e1bc4ace131950c3da`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# One-dimensional Riemann data

Source-independent definitions for piecewise constant initial data with one
jump at the origin.  The predicate intentionally imposes no condition at the
origin, and `riemannData` exposes that free value as an explicit parameter.
-/

namespace NumStability

/-- A field has left state `leftState` on `x < 0` and right state `rightState`
on `x > 0`.  Its value at `x = 0` is deliberately unspecified. -/
def IsRiemannData
    {State : Type*} (data : ℝ → State)
    (leftState rightState : State) : Prop :=
  (∀ x : ℝ, x < 0 → data x = leftState) ∧
    (∀ x : ℝ, 0 < x → data x = rightState)

/-- Riemann data with an explicit, freely chosen value at the jump point. -/
noncomputable def riemannData
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    ℝ → State :=
  fun x =>
    if x < 0 then leftState
    else if 0 < x then rightState
    else valueAtOrigin

/-- The parameterized construction satisfies the Riemann-data predicate. -/
theorem riemannData_isRiemannData
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    IsRiemannData
      (riemannData leftState valueAtOrigin rightState)
      leftState rightState := by
  constructor
  · intro x hx
    simp [riemannData, hx]
  · intro x hx
    have hnotLeft : ¬ x < 0 := not_lt_of_ge (le_of_lt hx)
    simp [riemannData, hx, hnotLeft]

/-- The value of `riemannData` at the jump is exactly its free parameter. -/
@[simp]
theorem riemannData_zero
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    riemannData leftState valueAtOrigin rightState 0 = valueAtOrigin := by
  simp [riemannData]

/-- The Riemann-data predicate characterizes exactly the functions obtained by
choosing an arbitrary value at the origin. -/
theorem isRiemannData_iff_exists_valueAtOrigin
    {State : Type*} (data : ℝ → State)
    (leftState rightState : State) :
    IsRiemannData data leftState rightState ↔
      ∃ valueAtOrigin,
        data = riemannData leftState valueAtOrigin rightState := by
  constructor
  · rintro ⟨hleft, hright⟩
    refine ⟨data 0, funext ?_⟩
    intro x
    rcases lt_trichotomy x 0 with hx | hx | hx
    · simpa [riemannData, hx] using hleft x hx
    · subst x
      simp
    · have hnotLeft : ¬ x < 0 := not_lt_of_ge (le_of_lt hx)
      simpa [riemannData, hx, hnotLeft] using hright x hx
  · rintro ⟨valueAtOrigin, rfl⟩
    exact riemannData_isRiemannData leftState valueAtOrigin rightState

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/Riemann.lean`
SHA-256: `9d07fe686b4dce6970394fe557a0dc492c51ac84ac0e52683f150019d23130fb`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData

/-!
# Riemann initial configurations

Two-state initial data is conjoined with an independently supplied evolution equation.
Product data describes a common material/state interface and leaves the origin value free.
-/

namespace NumStability

/-- Add Riemann initial data to an independently supplied evolution equation.
The equation predicate is retained unchanged; this definition introduces no
particular classical/weak solution convention or existence assertion. -/
def IsRiemannInitialValueSolution {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) : Prop :=
  evolutionEquation q ∧ IsRiemannData (fun x => q x 0) leftState rightState

/-- Equation plus two-state initial data, with no condition at the origin. -/
theorem isRiemannInitialValueSolution_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) :
    IsRiemannInitialValueSolution evolutionEquation leftState rightState q ↔
      evolutionEquation q ∧
        (∀ x, x < 0 → q x 0 = leftState) ∧
        (∀ x, 0 < x → q x 0 = rightState) := Iff.rfl

/-- Equivalently, the free origin parameter supplies the complete initial
field; the independently supplied equation remains a separate requirement. -/
theorem isRiemannInitialValueSolution_iff_exists_origin {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) :
    IsRiemannInitialValueSolution evolutionEquation leftState rightState q ↔
      evolutionEquation q ∧ ∃ origin,
        (fun x => q x 0) = riemannData leftState origin rightState := by
  exact and_congr_right' (isRiemannData_iff_exists_valueAtOrigin _ _ _)

/-- A simultaneous material/state jump means the two component fields have
their corresponding left and right data at the same spatial interface. -/
theorem isRiemannData_prod_iff {Material State : Type*}
    (medium : ℝ → Material) (initialState : ℝ → State)
    (leftMaterial rightMaterial : Material) (leftState rightState : State) :
    IsRiemannData (fun x => (medium x, initialState x))
        (leftMaterial, leftState) (rightMaterial, rightState) ↔
      IsRiemannData medium leftMaterial rightMaterial ∧
        IsRiemannData initialState leftState rightState := by
  constructor
  · rintro ⟨hleft, hright⟩
    exact ⟨⟨fun x hx => congrArg Prod.fst (hleft x hx),
      fun x hx => congrArg Prod.fst (hright x hx)⟩,
      ⟨fun x hx => congrArg Prod.snd (hleft x hx),
      fun x hx => congrArg Prod.snd (hright x hx)⟩⟩
  · rintro ⟨⟨hml, hmr⟩, ⟨hql, hqr⟩⟩
    exact ⟨fun x hx => Prod.ext (hml x hx) (hql x hx),
      fun x hx => Prod.ext (hmr x hx) (hqr x hx)⟩

/-- Pairing two Riemann profiles gives exactly the joint profile, preserving
both freely selected origin values. -/
theorem riemannData_prod {Material State : Type*}
    (leftMaterial originMaterial rightMaterial : Material)
    (leftState originState rightState : State) :
    (fun x => (riemannData leftMaterial originMaterial rightMaterial x,
      riemannData leftState originState rightState x)) =
      riemannData (leftMaterial, leftState) (originMaterial, originState)
        (rightMaterial, rightState) := by
  funext x
  unfold riemannData
  split_ifs <;> rfl


end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/FirstOrderRiemann.lean`
SHA-256: `17ebe712a403c2316e2097a00ee3119589b852ca8affd71ada8bbb19462e8b23`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann

/-!
# Riemann initial data for a first-order equation

A problem consists of its governing equation and initial field. The Riemann
data predicates require spectral hyperbolicity of the actual principal matrix
and admissible constant states on strict half-lines. The origin is free.
The broad two-state family and the distinct-jump family are separate predicates.
Problem classification does not assert existence or select a solution theory.
-/

namespace NumStability

variable {ι : Type*} [Fintype ι]

/-- An initial-value problem consists of an actual governing equation and its initial field. -/
structure FirstOrderInitialValueProblem (ι : Type*) [Fintype ι] where
  governing : FirstOrderEquation ι
  initialState : ℝ → (ι → ℝ)

namespace FirstOrderInitialValueProblem

/-- The broad two-state family. No inequality between the side states is hidden. -/
def IsRiemannWithStates (problem : FirstOrderInitialValueProblem ι)
    (leftState rightState : ι → ℝ) : Prop :=
  problem.governing.IsHyperbolic ∧
  leftState ∈ problem.governing.admissibleStates ∧
  rightState ∈ problem.governing.admissibleStates ∧
  IsRiemannData problem.initialState leftState rightState

def IsRiemann (problem : FirstOrderInitialValueProblem ι) : Prop :=
  ∃ leftState rightState, problem.IsRiemannWithStates leftState rightState

/-- The nondegenerate jump family is explicit rather than silently selected. -/
def IsJumpRiemann (problem : FirstOrderInitialValueProblem ι) : Prop :=
  ∃ leftState rightState,
    problem.IsRiemannWithStates leftState rightState ∧ leftState ≠ rightState

/-- Exact problem-data characterization: real spectral hyperbolicity and strict half-lines. -/
theorem isRiemann_iff (problem : FirstOrderInitialValueProblem ι) :
    problem.IsRiemann ↔
      ∃ leftState rightState,
        (∀ x t state, state ∈ problem.governing.admissibleStates →
          ∃ (eigenvalues : ι → ℝ) (eigenbasis : Module.Basis ι ℝ (ι → ℝ)),
            ∀ p, (problem.governing.principal x t state).mulVec (eigenbasis p) =
              eigenvalues p • eigenbasis p) ∧
        leftState ∈ problem.governing.admissibleStates ∧
        rightState ∈ problem.governing.admissibleStates ∧
        (∀ x, x < 0 → problem.initialState x = leftState) ∧
        (∀ x, 0 < x → problem.initialState x = rightState) := Iff.rfl

/-- The governing coefficient is the one in the equation expression, not an independent tag. -/
theorem isRiemann_characterization (problem : FirstOrderInitialValueProblem ι) :
    problem.IsRiemann ↔
      (∃ leftState rightState,
        problem.governing.IsHyperbolic ∧
        leftState ∈ problem.governing.admissibleStates ∧
        rightState ∈ problem.governing.admissibleStates ∧
        (∀ x, x < 0 → problem.initialState x = leftState) ∧
        (∀ x, 0 < x → problem.initialState x = rightState)) ∧
      (∀ x t state qt qx,
        problem.governing.residual x t state qt qx = 0 ↔
          qt + (problem.governing.principal x t state).mulVec qx =
            problem.governing.forcing x t state) := by
  constructor
  · intro h
    exact ⟨h, problem.governing.residual_eq_zero_iff⟩
  · exact fun h => h.1

/-- The origin remains a free parameter even when the governing equation is fixed. -/
theorem isRiemannWithStates_iff_origin (problem : FirstOrderInitialValueProblem ι)
    (leftState rightState : ι → ℝ) :
    problem.IsRiemannWithStates leftState rightState ↔
      problem.governing.IsHyperbolic ∧
      leftState ∈ problem.governing.admissibleStates ∧
      rightState ∈ problem.governing.admissibleStates ∧
      ∃ origin, problem.initialState = riemannData leftState origin rightState := by
  exact and_congr_right' (and_congr_right' (and_congr_right'
    (isRiemannData_iff_exists_valueAtOrigin problem.initialState leftState rightState)))

theorem jump_implies_riemann (problem : FirstOrderInitialValueProblem ι)
    (h : problem.IsJumpRiemann) : problem.IsRiemann := by
  obtain ⟨left, right, hproblem, _⟩ := h
  exact ⟨left, right, hproblem⟩

/-- Data can be prescribed without asserting that any PDE solution exists. -/
noncomputable def fromStates (equation : FirstOrderEquation ι)
    (leftState origin rightState : ι → ℝ) : FirstOrderInitialValueProblem ι where
  governing := equation
  initialState := riemannData leftState origin rightState

theorem fromStates_isRiemannWithStates (equation : FirstOrderEquation ι)
    (hhyperbolic : equation.IsHyperbolic)
    (leftState origin rightState : ι → ℝ)
    (hleft : leftState ∈ equation.admissibleStates)
    (hright : rightState ∈ equation.admissibleStates) :
    (fromStates equation leftState origin rightState).IsRiemannWithStates
      leftState rightState :=
  ⟨hhyperbolic, hleft, hright, riemannData_isRiemannData leftState origin rightState⟩

theorem fromStates_isJumpRiemann (equation : FirstOrderEquation ι)
    (hhyperbolic : equation.IsHyperbolic)
    (leftState origin rightState : ι → ℝ)
    (hleft : leftState ∈ equation.admissibleStates)
    (hright : rightState ∈ equation.admissibleStates) (hdistinct : leftState ≠ rightState) :
    (fromStates equation leftState origin rightState).IsJumpRiemann :=
  ⟨leftState, rightState,
    fromStates_isRiemannWithStates equation hhyperbolic leftState origin rightState hleft hright,
    hdistinct⟩

/-- Equal sides belong to the broad family, with the origin still free. -/
theorem fromEqualStates_isRiemann (equation : FirstOrderEquation ι)
    (hhyperbolic : equation.IsHyperbolic) (state origin : ι → ℝ)
    (hstate : state ∈ equation.admissibleStates) :
    (fromStates equation state origin state).IsRiemann :=
  ⟨state, state,
    fromStates_isRiemannWithStates equation hhyperbolic state origin state hstate hstate⟩

/-- Equal-side data cannot be relabeled as a distinct-side jump problem. -/
theorem fromEqualStates_not_isJumpRiemann (equation : FirstOrderEquation ι)
    (state origin : ι → ℝ) :
    ¬ (fromStates equation state origin state).IsJumpRiemann := by
  rintro ⟨left, right, hproblem, hdistinct⟩
  have hleft : state = left := by
    simpa [fromStates, riemannData] using hproblem.2.2.2.1 (-1) neg_one_lt_zero
  have hright : state = right := by
    simpa [fromStates, riemannData] using hproblem.2.2.2.2 1 zero_lt_one
  exact hdistinct (hleft.symm.trans hright)

/-- This is an optional explicitly classical relation, not part of problem classification. -/
def IsClassicalSolutionOn (problem : FirstOrderInitialValueProblem ι) (times : Set ℝ)
    (q : ℝ → ℝ → (ι → ℝ)) : Prop :=
  (∀ x, q x 0 = problem.initialState x) ∧
  ∀ x t, t ∈ times → problem.governing.IsClassicalSolutionAt q x t

/-- The separately chosen classical relation uses the very same governing PDE. -/
theorem classical_solution_has_strict_initial_data
    (problem : FirstOrderInitialValueProblem ι) (times : Set ℝ)
    (q : ℝ → ℝ → (ι → ℝ)) (leftState rightState : ι → ℝ)
    (hproblem : problem.IsRiemannWithStates leftState rightState)
    (hsolution : problem.IsClassicalSolutionOn times q) :
    (∀ x, x < 0 → q x 0 = leftState) ∧
    (∀ x, 0 < x → q x 0 = rightState) ∧
    ∀ x t, t ∈ times → problem.governing.IsClassicalSolutionAt q x t := by
  exact ⟨fun x hx => (hsolution.1 x).trans (hproblem.2.2.2.1 x hx),
    fun x hx => (hsolution.1 x).trans (hproblem.2.2.2.2 x hx), hsolution.2⟩

end FirstOrderInitialValueProblem

end NumStability
```
