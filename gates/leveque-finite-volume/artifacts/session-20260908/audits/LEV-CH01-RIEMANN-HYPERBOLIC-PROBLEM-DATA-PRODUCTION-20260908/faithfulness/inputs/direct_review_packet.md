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

Hash-verified prior declaration review:

- Reuse SHA-256: `715bdb20d9ed3b261884b5765248170346e5201eec49052716f75a62e2897e60`
- Reviewed interpretation: Logical conjunction.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `be9de746e028538ebedcfd2182877ed0b45f7be5eacb1d469771d29509b5ab5a`
- Reviewed interpretation: Equality of two objects of the same type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D021: `Exists`

- Role: `external-frontier`
- Owner module: `Init.Core`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `a24a6eb72dcf5b3765659a28bb9d3814ed7ebd3e3fa1fd11e8f3c7acc80e0dde`

Hash-verified prior declaration review:

- Reuse SHA-256: `8bab2695915d99fa6c1e48f3431d3f1ce1ac5b95f365f9e974372604d04c1f72`
- Reviewed interpretation: Existential quantification over a specified type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D022: `Fin`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `59788903be5da78a88e4dc3844df38effdaabdfa82bb364602790d2271da7fda`

Hash-verified prior declaration review:

- Reuse SHA-256: `82dc7e06a3165d139b5a91af9436a7640838cf6d082cec9e6f30cd84ba225006`
- Reviewed interpretation: The standard finite index type of natural numbers below its parameter.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D023: `Fin.fintype`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Fintype.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e7038d0981813ab904ddadd5c858e1d87d6d42413a72872c71b6e0413db6bb44`

Hash-verified prior declaration review:

- Reuse SHA-256: `24f8e2f150e9a7d4126eba3a05301bacc4c4f4a17cf79a9f0c6763268ae68086`
- Reviewed interpretation: Enumerates Fin n using List.finRange n, with completeness and absence of duplicates.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `6e36ba2f4b3ccef66826e685b248aeefae4968a5ff8088ff27552e05635ffdaf`
- Reviewed interpretation: Logical equivalence.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `3734640183a6881716216c5316b16eb14d3cecc6f930adc481e3d90dcef44d19`
- Reviewed interpretation: At row i, takes the dot product of row M i with the input vector.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `81c4d603b5b1d8ad05553af2fd51efbadf3af40d499ad10dd7fc4625ae6ad3dc`
- Reviewed interpretation: Natural numbers, including zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `65789be65f26e242a9507612922bd1335678c450c546ef730652e13775f65ad4`
- Reviewed interpretation: Retains the underlying ring operations while forgetting associativity structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D035: `NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `1082112ee2b1424cb7e1eff69df85640d23793811157d8a4401f364710bc21d2`

Hash-verified prior declaration review:

- Reuse SHA-256: `e4b4bc94fea5b19a7c740b8da5c77014c4442dfedf0915a077890fb1722ccbd5`
- Reviewed interpretation: Projects the underlying nonassociative ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D036: `NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `ffc3b0b49d777bb976662d9282026e03ef869205e45f90008bd1659a4e78f2d7`

Hash-verified prior declaration review:

- Reuse SHA-256: `f0f0d8e4a99d1594fe0821929e9408b8fe1c9698135936edb0c0c1faf49aa401`
- Reviewed interpretation: Builds a semiring structure with the original addition and multiplication.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D037: `NonUnitalNormedCommRing.toNonUnitalCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `4a44c0a0630b1766c12bb0c5456f4f914c813b6dcb179e8b3d87084d495efd1f`

Hash-verified prior declaration review:

- Reuse SHA-256: `2c8b01033e288eb5041eef516f091df15c0cb773e16aa9f754cf171c24e41d0a`
- Reviewed interpretation: Retains ring operations and commutativity while dropping norm structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D038: `NonUnitalSeminormedCommRing.toNonUnitalSeminormedRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `c697ff5e735ebe18733e51950717037e73ba73e94ac2e99953bfb521708cabd2`

Hash-verified prior declaration review:

- Reuse SHA-256: `d632fb4b88e931d5eba91d1cf779a392576a0acd72805c0a215e86f255675fd7`
- Reviewed interpretation: Projects the underlying seminormed ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D039: `NonUnitalSeminormedRing.toSeminormedAddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `db7996fa414ad67340b9d6991cd145ac2a5d251a870097d20f2f63e371fb101d`

Hash-verified prior declaration review:

- Reuse SHA-256: `fcdc3e3d69cbcbee47b9dfc925cb5c70f96c84af11948ff5f7e5be6a2f5dcf4f`
- Reviewed interpretation: Retains the norm, additive group, and pseudometric of the supplied ring.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D040: `NormedCommRing.toNonUnitalNormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ce5ba4f454145f64923f4d555eb95891cb66dc2df21d2ef730bfa600ea6a22e5`

Hash-verified prior declaration review:

- Reuse SHA-256: `65c2ab3c6b9c0096f2643265dedbe27a330baed90e8c8d34bb684f2bd84a6438`
- Reviewed interpretation: Copies the norm, metric, and ring operations into the structure without a unit requirement.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D041: `NormedCommRing.toSeminormedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad504b2606febc5a066d58ac540c9826bd1b7fce734d59a7fef63c7c27112fe3`

Hash-verified prior declaration review:

- Reuse SHA-256: `8e1c1188ebf3dbe7d12bb2adfde11dbfe531b17095b987d7f174555284b014bf`
- Reviewed interpretation: Retains the norm, ring, and induced pseudometric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D042: `NormedField.toNormedSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `9e0629e665c648aac86a6d587dab809d81c8bb691b9b016c7808244edbccdc92`

Hash-verified prior declaration review:

- Reuse SHA-256: `8c51d81ed849c04dcfa09c70328e3c929c0ae1608791cc6bf592430020c19668`
- Reviewed interpretation: A normed field acts on itself through its semiring module structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D043: `NormedSpace.toModule`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Module.Basic`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `5ced27e2d9cc2259d662cced299ca3071b9598822fc551dad5a5d6dd0f3a9df4`

Hash-verified prior declaration review:

- Reuse SHA-256: `81d6a0d1145f24f8b87c56d7a0055efd75295ffc97b82eacac1f9ed52dba1049`
- Reviewed interpretation: Projects the underlying module.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D044: `OfNat.ofNat`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `6a6a0720d091cfeb582747fe67b977e948f09706c0beae1f2f21830aa5821ead`

Hash-verified prior declaration review:

- Reuse SHA-256: `c6451ee1f9cbc3a1ad9554e8f44abd9612a243584065627f46ab521105894ac3`
- Reviewed interpretation: Extracts the value assigned to a natural-number literal by its instance.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D045: `Pi.Function.module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Pi`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `921742a1effe7c5d653ed6512c1187064090ee805009644177b1646ce2ee15b1`

Hash-verified prior declaration review:

- Reuse SHA-256: `666364aff0c119e93e5373a4459996a29fc6276d4657ff09d0b229ad71ed66e9`
- Reviewed interpretation: Uses the product module on functions with fixed codomain.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `5660149684082f3c5e3f12a082ff62c11e6764c45e070680536ca7833fadee9b`
- Reviewed interpretation: The standard library real-number type at the external semantic frontier.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `d4c2bc7b8185ecb222bd4b1270c268fbedaaf901bf4fb1980d66156b798c71ba`
- Reviewed interpretation: Selects Real.zero.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D052: `Real.normedCommRing`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Ring.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `69cccc1e864661e103785f4a2712b9ad164d845c03b7737801c37e5ac852bad7`

Hash-verified prior declaration review:

- Reuse SHA-256: `f96fa2f5180c5c73616af838d250e773438953c85e7466ce1a6195b879a08eec`
- Reviewed interpretation: Combines the real normed additive group and real commutative ring, retaining their operations and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D053: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3249555a2824aa1e4e9c966b630ef876ae52df63ed09d0838da173aa28c0f77b`

Hash-verified prior declaration review:

- Reuse SHA-256: `64b34c09cfb6681e210a64bc42a1f7c440f7c4e515dea0941ae1ca918d5cafe7`
- Reviewed interpretation: Combines the real field with its normed additive group and metric.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `a7173f75e0cedc5b11b5f139a03cee8b5ec6dfd549061b14e596b6370c1f2dac`
- Reviewed interpretation: Retains norm, pseudometric, and ring operations while omitting unit structure.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `0d68f5d59dbfd7a5f9acd9dbfaf64b6168babcf8470a3abc4e8f19ae6f291d1a`
- Reviewed interpretation: Interprets the literal 0 as the supplied zero element.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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

Hash-verified prior declaration review:

- Reuse SHA-256: `deb22013c87625cec3aad2ab271d87871ec72c516e77b38984a8b73eb0dc0644`
- Reviewed interpretation: A finite enumeration structure on an index type.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

### D061: `Matrix`

- Role: `external-frontier`
- Owner module: `Mathlib.LinearAlgebra.Matrix.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
- Semantic SHA-256: `e552ffc8c85b917dca38e5965ad91773fdb989246623a528d91526b75d68c2f1`

Hash-verified prior declaration review:

- Reuse SHA-256: `4498b51978060a72423f418c40cec98ab157f96ca14dbe2ba10d76a1a7d45d2c`
- Reviewed interpretation: A matrix is a function from row indices to column indices to entries.

Independently determine this declaration's effect on the current target and whether that effect matches the selected source result.

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
