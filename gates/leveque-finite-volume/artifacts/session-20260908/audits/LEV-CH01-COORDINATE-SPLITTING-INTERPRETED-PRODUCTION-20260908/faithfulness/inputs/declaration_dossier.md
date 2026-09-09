# Declaration dossier for LEV-CH01-COORDINATE-SPLITTING-INTERPRETED-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_coordinateSplittingBalance_sourceContract
    {D E : Type*} [DecidableEq D] [AddCommGroup E] [Module ℝ E]
    (cellVolume : (D → ℤ) → ℝ) (hvolume : ∀ cell, 0 < cellVolume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (stages : List (D × ℝ)) (hnonempty : stages ≠ [])
    (hcover : ∀ d, ∃ dt, (d, dt) ∈ stages)
    (hduration : ∀ stage ∈ stages, 0 < stage.2) (state : (D → ℤ) → E) :
    stages ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ stages) ∧
    (∀ stage ∈ stages, 0 < stage.2) ∧
    ∀ before d dt after, stages = before ++ (d, dt) :: after →
      let current
```

## Elaborated target type

```lean
∀ {D : Type u_1} {E : Type u_2} [inst : DecidableEq D] [inst_1 : AddCommGroup E] [inst_2 : Module Real E]
  (cellVolume : (D → Int) → Real),
  (∀ (cell : D → Int), Real.instLT.lt 0 (cellVolume cell)) →
    ∀ (rule : D → (D → Int) → Real → (Int → E) → E) (stages : List (Prod D Real)),
      Ne stages List.nil →
        (∀ (d : D), Exists fun dt => List.instMembership.mem stages { fst := d, snd := dt }) →
          (∀ (stage : Prod D Real), List.instMembership.mem stages stage → Real.instLT.lt 0 stage.snd) →
            ∀ (state : (D → Int) → E),
              And (Ne stages List.nil)
                (And (∀ (d : D), Exists fun dt => List.instMembership.mem stages { fst := d, snd := dt })
                  (And (∀ (stage : Prod D Real), List.instMembership.mem stages stage → Real.instLT.lt 0 stage.snd)
                    (∀ (before : List (Prod D Real)) (d : D) (dt : Real) (after : List (Prod D Real)),
                      Eq stages (instHAppendOfAppend.hAppend before (List.cons { fst := d, snd := dt } after)) →
                        have current := NumStability.CoordinateLineBalance.sweep cellVolume rule before state;
                        And
                          (Eq (NumStability.CoordinateLineBalance.sweep cellVolume rule stages state)
                            (NumStability.CoordinateLineBalance.sweep cellVolume rule after
                              (NumStability.CoordinateLineBalance.advance cellVolume rule d dt current)))
                          (And
                            (∀ (cell : D → Int),
                              Eq
                                (instHSMul.hSMul (cellVolume cell)
                                  (NumStability.CoordinateLineBalance.advance cellVolume rule d dt current cell))
                                (instHSub.hSub (instHSMul.hSMul (cellVolume cell) (current cell))
                                  (instHSMul.hSMul dt
                                    (NumStability.CoordinateLineBalance.netOutwardFlux rule d dt current cell))))
                            (And
                              (∀ (base : D → Int) (start : Int) (count : Nat),
                                Eq
                                  ((Finset.range count).sum fun k =>
                                    instHSMul.hSMul (cellVolume (Function.update base d (instHAdd.hAdd start k.cast)))
                                      (NumStability.CoordinateLineBalance.advance cellVolume rule d dt current
                                        (Function.update base d (instHAdd.hAdd start k.cast))))
                                  (instHSub.hSub
                                    ((Finset.range count).sum fun k =>
                                      instHSMul.hSMul (cellVolume (Function.update base d (instHAdd.hAdd start k.cast)))
                                        (current (Function.update base d (instHAdd.hAdd start k.cast))))
                                    (instHSMul.hSMul dt
                                      (instHSub.hSub
                                        (NumStability.CoordinateLineBalance.normalFaceFlux rule d dt current
                                          (Function.update base d (instHAdd.hAdd start count.cast)))
                                        (NumStability.CoordinateLineBalance.normalFaceFlux rule d dt current
                                          (Function.update base d start))))))
                              (∀ (other : (D → Int) → E) (base : D → Int),
                                (∀ (j : Int),
                                    Eq (current (Function.update base d j)) (other (Function.update base d j))) →
                                  ∀ (j : Int),
                                    Eq
                                      (NumStability.CoordinateLineBalance.advance cellVolume rule d dt current
                                        (Function.update base d j))
                                      (NumStability.CoordinateLineBalance.advance cellVolume rule d dt other
                                        (Function.update base d j))))))))
```

## Fully explicit elaborated target type

```lean
∀ {D : Type u_1} {E : Type u_2} [inst : DecidableEq.{u_1 + 1} D] [inst_1 : AddCommGroup.{u_2} E]
  [inst_2 : @Module.{0, u_2} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1)]
  (cellVolume : (D → Int) → Real)
  (hvolume :
    ∀ (cell : D → Int),
      @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
        (cellVolume cell))
  (rule : D → (D → Int) → Real → (Int → E) → E) (stages : List.{u_1} (Prod.{u_1, 0} D Real))
  (hnonempty : @Ne.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages (@List.nil.{u_1} (Prod.{u_1, 0} D Real)))
  (hcover :
    ∀ (d : D),
      @Exists.{1} Real fun (dt : Real) =>
        @Membership.mem.{u_1, u_1} (Prod.{u_1, 0} D Real) (List.{u_1} (Prod.{u_1, 0} D Real))
          (@List.instMembership.{u_1} (Prod.{u_1, 0} D Real)) stages (@Prod.mk.{u_1, 0} D Real d dt))
  (hduration :
    ∀ (stage : Prod.{u_1, 0} D Real),
      @Membership.mem.{u_1, u_1} (Prod.{u_1, 0} D Real) (List.{u_1} (Prod.{u_1, 0} D Real))
          (@List.instMembership.{u_1} (Prod.{u_1, 0} D Real)) stages stage →
        @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
          (@Prod.snd.{u_1, 0} D Real stage))
  (state : (D → Int) → E),
  And (@Ne.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages (@List.nil.{u_1} (Prod.{u_1, 0} D Real)))
    (And
      (∀ (d : D),
        @Exists.{1} Real fun (dt : Real) =>
          @Membership.mem.{u_1, u_1} (Prod.{u_1, 0} D Real) (List.{u_1} (Prod.{u_1, 0} D Real))
            (@List.instMembership.{u_1} (Prod.{u_1, 0} D Real)) stages (@Prod.mk.{u_1, 0} D Real d dt))
      (And
        (∀ (stage : Prod.{u_1, 0} D Real),
          @Membership.mem.{u_1, u_1} (Prod.{u_1, 0} D Real) (List.{u_1} (Prod.{u_1, 0} D Real))
              (@List.instMembership.{u_1} (Prod.{u_1, 0} D Real)) stages stage →
            @LT.lt.{0} Real Real.instLT (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero))
              (@Prod.snd.{u_1, 0} D Real stage))
        (∀ (before : List.{u_1} (Prod.{u_1, 0} D Real)) (d : D) (dt : Real) (after : List.{u_1} (Prod.{u_1, 0} D Real)),
          @Eq.{u_1 + 1} (List.{u_1} (Prod.{u_1, 0} D Real)) stages
              (@HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} (Prod.{u_1, 0} D Real)) (List.{u_1} (Prod.{u_1, 0} D Real))
                (List.{u_1} (Prod.{u_1, 0} D Real))
                (@instHAppendOfAppend.{u_1} (List.{u_1} (Prod.{u_1, 0} D Real))
                  (@List.instAppend.{u_1} (Prod.{u_1, 0} D Real)))
                before (@List.cons.{u_1} (Prod.{u_1, 0} D Real) (@Prod.mk.{u_1, 0} D Real d dt) after)) →
            have current : (D → Int) → E :=
              @NumStability.CoordinateLineBalance.sweep.{u_1, u_2} D E inst inst_1 inst_2 cellVolume rule before state;
            And
              (@Eq.{max (u_1 + 1) (u_2 + 1)} ((D → Int) → E)
                (@NumStability.CoordinateLineBalance.sweep.{u_1, u_2} D E inst inst_1 inst_2 cellVolume rule stages
                  state)
                (@NumStability.CoordinateLineBalance.sweep.{u_1, u_2} D E inst inst_1 inst_2 cellVolume rule after
                  (@NumStability.CoordinateLineBalance.advance.{u_1, u_2} D E inst inst_1 inst_2 cellVolume rule d dt
                    current)))
              (And
                (∀ (cell : D → Int),
                  @Eq.{u_2 + 1} E
                    (@HSMul.hSMul.{0, u_2, u_2} Real E E
                      (@instHSMul.{0, u_2} Real E
                        (@SMulZeroClass.toSMul.{0, u_2} Real E
                          (@AddZero.toZero.{u_2} E
                            (@AddZeroClass.toAddZero.{u_2} E
                              (@AddMonoid.toAddZeroClass.{u_2} E
                                (@SubNegMonoid.toAddMonoid.{u_2} E
                                  (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))))
                          (@DistribSMul.toSMulZeroClass.{0, u_2} Real E
                            (@AddMonoid.toAddZeroClass.{u_2} E
                              (@SubNegMonoid.toAddMonoid.{u_2} E
                                (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))
                            (@DistribMulAction.toDistribSMul.{0, u_2} Real E Real.instMonoid
                              (@SubNegMonoid.toAddMonoid.{u_2} E
                                (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1)))
                              (@Module.toDistribMulAction.{0, u_2} Real E Real.semiring
                                (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) inst_2)))))
                      (cellVolume cell)
                      (@NumStability.CoordinateLineBalance.advance.{u_1, u_2} D E inst inst_1 inst_2 cellVolume rule d
                        dt current cell))
                    (@HSub.hSub.{u_2, u_2, u_2} E E E
                      (@instHSub.{u_2} E
                        (@SubNegMonoid.toSub.{u_2} E
                          (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))
                      (@HSMul.hSMul.{0, u_2, u_2} Real E E
                        (@instHSMul.{0, u_2} Real E
                          (@SMulZeroClass.toSMul.{0, u_2} Real E
                            (@AddZero.toZero.{u_2} E
                              (@AddZeroClass.toAddZero.{u_2} E
                                (@AddMonoid.toAddZeroClass.{u_2} E
                                  (@SubNegMonoid.toAddMonoid.{u_2} E
                                    (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))))
                            (@DistribSMul.toSMulZeroClass.{0, u_2} Real E
                              (@AddMonoid.toAddZeroClass.{u_2} E
                                (@SubNegMonoid.toAddMonoid.{u_2} E
                                  (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))
                              (@DistribMulAction.toDistribSMul.{0, u_2} Real E Real.instMonoid
                                (@SubNegMonoid.toAddMonoid.{u_2} E
                                  (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1)))
                                (@Module.toDistribMulAction.{0, u_2} Real E Real.semiring
                                  (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) inst_2)))))
                        (cellVolume cell) (current cell))
                      (@HSMul.hSMul.{0, u_2, u_2} Real E E
                        (@instHSMul.{0, u_2} Real E
                          (@SMulZeroClass.toSMul.{0, u_2} Real E
                            (@AddZero.toZero.{u_2} E
                              (@AddZeroClass.toAddZero.{u_2} E
                                (@AddMonoid.toAddZeroClass.{u_2} E
                                  (@SubNegMonoid.toAddMonoid.{u_2} E
                                    (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))))
                            (@DistribSMul.toSMulZeroClass.{0, u_2} Real E
                              (@AddMonoid.toAddZeroClass.{u_2} E
                                (@SubNegMonoid.toAddMonoid.{u_2} E
                                  (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))
                              (@DistribMulAction.toDistribSMul.{0, u_2} Real E Real.instMonoid
                                (@SubNegMonoid.toAddMonoid.{u_2} E
                                  (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1)))
                                (@Module.toDistribMulAction.{0, u_2} Real E Real.semiring
                                  (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) inst_2)))))
                        dt
                        (@NumStability.CoordinateLineBalance.netOutwardFlux.{u_1, u_2} D E inst inst_1 rule d dt current
                          cell))))
                (And
                  (∀ (base : (a : D) → Int) (start : Int) (count : Nat),
                    @Eq.{u_2 + 1} E
                      (@Finset.sum.{0, u_2} Nat E (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) (Finset.range count)
                        fun (k : Nat) =>
                        @HSMul.hSMul.{0, u_2, u_2} Real E E
                          (@instHSMul.{0, u_2} Real E
                            (@SMulZeroClass.toSMul.{0, u_2} Real E
                              (@AddZero.toZero.{u_2} E
                                (@AddZeroClass.toAddZero.{u_2} E
                                  (@AddMonoid.toAddZeroClass.{u_2} E
                                    (@SubNegMonoid.toAddMonoid.{u_2} E
                                      (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))))
                              (@DistribSMul.toSMulZeroClass.{0, u_2} Real E
                                (@AddMonoid.toAddZeroClass.{u_2} E
                                  (@SubNegMonoid.toAddMonoid.{u_2} E
                                    (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))
                                (@DistribMulAction.toDistribSMul.{0, u_2} Real E Real.instMonoid
                                  (@SubNegMonoid.toAddMonoid.{u_2} E
                                    (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1)))
                                  (@Module.toDistribMulAction.{0, u_2} Real E Real.semiring
                                    (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) inst_2)))))
                          (cellVolume
                            (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                              (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) start
                                (@Nat.cast.{0} Int instNatCastInt k))))
                          (@NumStability.CoordinateLineBalance.advance.{u_1, u_2} D E inst inst_1 inst_2 cellVolume rule
                            d dt current
                            (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                              (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) start
                                (@Nat.cast.{0} Int instNatCastInt k)))))
                      (@HSub.hSub.{u_2, u_2, u_2} E E E
                        (@instHSub.{u_2} E
                          (@SubNegMonoid.toSub.{u_2} E
                            (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))
                        (@Finset.sum.{0, u_2} Nat E (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) (Finset.range count)
                          fun (k : Nat) =>
                          @HSMul.hSMul.{0, u_2, u_2} Real E E
                            (@instHSMul.{0, u_2} Real E
                              (@SMulZeroClass.toSMul.{0, u_2} Real E
                                (@AddZero.toZero.{u_2} E
                                  (@AddZeroClass.toAddZero.{u_2} E
                                    (@AddMonoid.toAddZeroClass.{u_2} E
                                      (@SubNegMonoid.toAddMonoid.{u_2} E
                                        (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))))
                                (@DistribSMul.toSMulZeroClass.{0, u_2} Real E
                                  (@AddMonoid.toAddZeroClass.{u_2} E
                                    (@SubNegMonoid.toAddMonoid.{u_2} E
                                      (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))
                                  (@DistribMulAction.toDistribSMul.{0, u_2} Real E Real.instMonoid
                                    (@SubNegMonoid.toAddMonoid.{u_2} E
                                      (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1)))
                                    (@Module.toDistribMulAction.{0, u_2} Real E Real.semiring
                                      (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) inst_2)))))
                            (cellVolume
                              (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                                (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) start
                                  (@Nat.cast.{0} Int instNatCastInt k))))
                            (current
                              (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                                (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) start
                                  (@Nat.cast.{0} Int instNatCastInt k)))))
                        (@HSMul.hSMul.{0, u_2, u_2} Real E E
                          (@instHSMul.{0, u_2} Real E
                            (@SMulZeroClass.toSMul.{0, u_2} Real E
                              (@AddZero.toZero.{u_2} E
                                (@AddZeroClass.toAddZero.{u_2} E
                                  (@AddMonoid.toAddZeroClass.{u_2} E
                                    (@SubNegMonoid.toAddMonoid.{u_2} E
                                      (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))))
                              (@DistribSMul.toSMulZeroClass.{0, u_2} Real E
                                (@AddMonoid.toAddZeroClass.{u_2} E
                                  (@SubNegMonoid.toAddMonoid.{u_2} E
                                    (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))
                                (@DistribMulAction.toDistribSMul.{0, u_2} Real E Real.instMonoid
                                  (@SubNegMonoid.toAddMonoid.{u_2} E
                                    (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1)))
                                  (@Module.toDistribMulAction.{0, u_2} Real E Real.semiring
                                    (@AddCommGroup.toAddCommMonoid.{u_2} E inst_1) inst_2)))))
                          dt
                          (@HSub.hSub.{u_2, u_2, u_2} E E E
                            (@instHSub.{u_2} E
                              (@SubNegMonoid.toSub.{u_2} E
                                (@AddGroup.toSubNegMonoid.{u_2} E (@AddCommGroup.toAddGroup.{u_2} E inst_1))))
                            (@NumStability.CoordinateLineBalance.normalFaceFlux.{u_1, u_2} D E inst rule d dt current
                              (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d
                                (@HAdd.hAdd.{0, 0, 0} Int Int Int (@instHAdd.{0} Int Int.instAdd) start
                                  (@Nat.cast.{0} Int instNatCastInt count))))
                            (@NumStability.CoordinateLineBalance.normalFaceFlux.{u_1, u_2} D E inst rule d dt current
                              (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d start))))))
                  (∀ (other : (D → Int) → E) (base : (a : D) → Int),
                    (∀ (j : Int),
                        @Eq.{u_2 + 1} E (current (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j))
                          (other (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j))) →
                      ∀ (j : Int),
                        @Eq.{u_2 + 1} E
                          (@NumStability.CoordinateLineBalance.advance.{u_1, u_2} D E inst inst_1 inst_2 cellVolume rule
                            d dt current (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j))
                          (@NumStability.CoordinateLineBalance.advance.{u_1, u_2} D E inst inst_1 inst_2 cellVolume rule
                            d dt other (@Function.update.{u_1 + 1, 1} D (fun (a : D) => Int) inst base d j))))))))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateSweep`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`, `Mathlib.MeasureTheory.Integral.Bochner.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Tactic.Module`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference` imports: `Mathlib.Algebra.BigOperators.Module`, `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.Module`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting` imports: `Mathlib.Data.List.Basic`, `Mathlib.Data.Real.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity` imports: `Mathlib.Data.Matrix.Basic`, `Mathlib.Data.Real.Basic`, `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem` imports: `Mathlib.Analysis.Calculus.Deriv.Prod`, `Mathlib.Data.Matrix.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Mul`, `Mathlib.Analysis.Calculus.Deriv.Pi`, `Mathlib.Data.Matrix.Basic`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData` imports: `Mathlib.Data.Real.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateSweep` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`, `Mathlib.MeasureTheory.Measure.Lebesgue.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.CoordinateLineBalance.advance`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `e5ac63ef525014ab724c9fc67f684f045866fe2c9ac6a23f6843939e17ab7e45`

Type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq D] →
      [inst : AddCommGroup E] →
        [Module Real E] →
          ((D → Int) → Real) → (D → (D → Int) → Real → (Int → E) → E) → D → Real → ((D → Int) → E) → (D → Int) → E
```

Fully explicit type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq.{u_1 + 1} D] →
      [inst : AddCommGroup.{u_2} E] →
        [@Module.{0, u_2} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_2} E inst)] →
          (volume : (D → Int) → Real) →
            (rule : D → (D → Int) → Real → (Int → E) → E) →
              (d : D) → (dt : Real) → (state : (D → Int) → E) → (cell : D → Int) → E
```

Definition body (one-level semantic boundary):

```lean
fun {D} {E} [DecidableEq D] [AddCommGroup E] [Module Real E] volume rule d dt state cell =>
  NumStability.finiteVolumeCellAverageUpdate dt (volume cell) (state cell)
    (NumStability.CoordinateLineBalance.netOutwardFlux rule d dt state cell)
```

### D002: `NumStability.CoordinateLineBalance.netOutwardFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `b85f363c52c36c38bf3473335002e31129e7717dad0159b1b3d2323f49375eb5`

Type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq D] →
      [AddCommGroup E] → (D → (D → Int) → Real → (Int → E) → E) → D → Real → ((D → Int) → E) → (D → Int) → E
```

Fully explicit type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq.{u_1 + 1} D] →
      [AddCommGroup.{u_2} E] →
        (rule : D → (D → Int) → Real → (Int → E) → E) →
          (d : D) → (dt : Real) → (state : (D → Int) → E) → (cell : D → Int) → E
```

Definition body (one-level semantic boundary):

```lean
fun {D} {E} [DecidableEq D] [AddCommGroup E] rule d dt state cell =>
  instHSub.hSub
    (NumStability.CoordinateLineBalance.normalFaceFlux rule d dt state
      (Function.update cell d (instHAdd.hAdd (cell d) 1)))
    (NumStability.CoordinateLineBalance.normalFaceFlux rule d dt state cell)
```

### D003: `NumStability.CoordinateLineBalance.normalFaceFlux`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `f74d0e36ad31edcaa449f83fcffde8ed8effa8ecd95db2f216c669d6d530e3da`

Type:

```lean
{D : Type u_1} →
  {E : Type u_2} → [DecidableEq D] → (D → (D → Int) → Real → (Int → E) → E) → D → Real → ((D → Int) → E) → (D → Int) → E
```

Fully explicit type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq.{u_1 + 1} D] →
      (rule : D → (D → Int) → Real → (Int → E) → E) →
        (d : D) → (dt : Real) → (state : (D → Int) → E) → (rightCell : D → Int) → E
```

Definition body (one-level semantic boundary):

```lean
fun {D} {E} [DecidableEq D] rule d dt state rightCell =>
  rule d rightCell dt fun j => state (Function.update rightCell d j)
```

### D004: `NumStability.CoordinateLineBalance.sweep`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `97b808f2bde942c4834c3d212d64538572a0718c98e45345f8c71041b30e0042`

Type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq D] →
      [inst : AddCommGroup E] →
        [Module Real E] →
          ((D → Int) → Real) →
            (D → (D → Int) → Real → (Int → E) → E) → List (Prod D Real) → ((D → Int) → E) → (D → Int) → E
```

Fully explicit type:

```lean
{D : Type u_1} →
  {E : Type u_2} →
    [DecidableEq.{u_1 + 1} D] →
      [inst : AddCommGroup.{u_2} E] →
        [@Module.{0, u_2} Real E Real.semiring (@AddCommGroup.toAddCommMonoid.{u_2} E inst)] →
          (volume : (D → Int) → Real) →
            (rule : D → (D → Int) → Real → (Int → E) → E) →
              (stages : List.{u_1} (Prod.{u_1, 0} D Real)) → (state : (D → Int) → E) → (D → Int) → E
```

Definition body (one-level semantic boundary):

```lean
fun {D} {E} [DecidableEq D] [AddCommGroup E] [Module Real E] volume rule stages state =>
  NumStability.orderedOperatorSweep
    (List.map (fun stage => NumStability.CoordinateLineBalance.advance volume rule stage.fst stage.snd) stages) state
```

### D005: `NumStability.finiteVolumeCellAverageUpdate`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D006: `NumStability.orderedOperatorSweep`

- Role: `local`
- Owner module: `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D007: `AddCommGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `087ff419a44ee7e835bedcf1beda5a1fee5971b4ef4f17124a5a63cd2b0beb30`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(G : Type u) → Type u
```

### D008: `AddCommGroup.toAddCommMonoid`

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

### D009: `AddCommGroup.toAddGroup`

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

### D010: `AddGroup.toSubNegMonoid`

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

### D011: `AddMonoid.toAddZeroClass`

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

### D012: `AddZero.toZero`

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

### D013: `AddZeroClass.toAddZero`

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

### D014: `And`

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

### D015: `DecidableEq`

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

### D016: `DistribMulAction.toDistribSMul`

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

### D017: `DistribSMul.toSMulZeroClass`

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

### D018: `Eq`

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

### D019: `Exists`

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

### D020: `Finset.range`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Finset.Range`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `0d8947d3b91a57604f7b7be615f2ff236f2058a47281af31ea2498635666e9e7`

Type:

```lean
Nat → Finset Nat
```

Fully explicit type:

```lean
(n : Nat) → Finset.{0} Nat
```

Definition body (one-level semantic boundary):

```lean
fun n => { val := Multiset.range n, nodup := ⋯ }
```

### D021: `Finset.sum`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.BigOperators.Group.Finset.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D022: `Function.update`

- Role: `external-frontier`
- Owner module: `Mathlib.Logic.Function.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D023: `HAdd.hAdd`

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

### D024: `HAppend.hAppend`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `f19ccdee2b2776c250a9c50188f1cf355ac1a7621d69c0ce7d1335bd5521b354`

Type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam (Type w)} → [self : HAppend α β γ] → α → β → γ
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → {γ : outParam.{w + 2} (Type w)} → [self : HAppend.{u, v, w} α β γ] → α → β → γ
```

Definition body (one-level semantic boundary):

```lean
fun α β {γ} [self : HAppend α β γ] => self.1
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

### D026: `HSub.hSub`

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

### D027: `Int`

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

### D028: `Int.instAdd`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D029: `LT.lt`

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

### D030: `List`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `ec06a72bb009eecaedd9dbf6a3349bbea0bbc480e0a21179f4e21b3e219b952d`

Type:

```lean
Type u → Type u
```

Fully explicit type:

```lean
(α : Type u) → Type u
```

### D031: `List.cons`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `d4f0bc0954b11abbe9f8e60dd8762e7797f488b1975b155440101828c4c1ea14`

Type:

```lean
{α : Type u} → α → List α → List α
```

Fully explicit type:

```lean
{α : Type u} → (head : α) → (tail : List.{u} α) → List.{u} α
```

### D032: `List.instAppend`

- Role: `external-frontier`
- Owner module: `Init.Data.List.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `a4e7aef57b0deffb52c21cc741e84fb942ab6344c5d119da717f5dc1d5ab086d`

Type:

```lean
{α : Type u} → Append (List α)
```

Fully explicit type:

```lean
{α : Type u} → Append.{u} (List.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { append := List.append }
```

### D033: `List.instMembership`

- Role: `external-frontier`
- Owner module: `Init.Data.List.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `51cf805fcbf00d4a64b4e72cb246d510950ce4cda54bc6c8a74110b6dc8a6a95`

Type:

```lean
{α : Type u} → Membership α (List α)
```

Fully explicit type:

```lean
{α : Type u} → Membership.{u, u} α (List.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} => { mem := fun l a => List.Mem a l }
```

### D034: `List.nil`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `6fc023f8c03f1dc78130598a9c55a666564e22fa908127753ee95d45e602196f`

Type:

```lean
{α : Type u} → List α
```

Fully explicit type:

```lean
{α : Type u} → List.{u} α
```

### D035: `Membership.mem`

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

### D036: `Module`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Module.Defs`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `132ed119db2ae117b4c85e91594e4fcde0e02a8fde0fb2ee5c57a7a9263c219c`

Type:

```lean
(R : Type u) → (M : Type v) → [Semiring R] → [AddCommMonoid M] → Type (max u v)
```

Fully explicit type:

```lean
(R : Type u) → (M : Type v) → [Semiring.{u} R] → [AddCommMonoid.{v} M] → Type (max u v)
```

### D037: `Module.toDistribMulAction`

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

### D038: `Nat`

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

### D039: `Nat.cast`

- Role: `external-frontier`
- Owner module: `Init.Data.Cast`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D040: `Ne`

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

### D041: `OfNat.ofNat`

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

### D042: `Prod`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `3df3b0cff45fb04022db70edff8e5747def6cae602cd8c33e673abac1bb4e347`

Type:

```lean
Type u → Type v → Type (max u v)
```

Fully explicit type:

```lean
(α : Type u) → (β : Type v) → Type (max u v)
```

### D043: `Prod.mk`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `constructor`
- Distance from target type: `1`
- Semantic SHA-256: `e42ba07a23655c2aae0502df1e03897313eaf034a0e84cfef98e91f6b4920097`

Type:

```lean
{α : Type u} → {β : Type v} → α → β → Prod α β
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (fst : α) → (snd : β) → Prod.{u, v} α β
```

### D044: `Prod.snd`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `a70aebf9da319c4b02023421b33923182c4d5164c2087035016589b80ed1191a`

Type:

```lean
{α : Type u} → {β : Type v} → Prod α β → β
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (self : Prod.{u, v} α β) → β
```

Definition body (one-level semantic boundary):

```lean
fun α β self => self.2
```

### D045: `Real`

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

### D046: `Real.instLT`

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

### D048: `Real.instZero`

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

### D049: `Real.semiring`

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

### D050: `SMulZeroClass.toSMul`

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

### D051: `SubNegMonoid.toAddMonoid`

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

### D052: `SubNegMonoid.toSub`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Group.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D053: `Zero.toOfNat0`

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

### D054: `instHAdd`

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

### D055: `instHAppendOfAppend`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `3c8b128f1a53b3c06845db74f34230cce2f5f789c5291dec5a81a12696c383f9`

Type:

```lean
{α : Type u_1} → [Append α] → HAppend α α α
```

Fully explicit type:

```lean
{α : Type u_1} → [Append.{u_1} α] → HAppend.{u_1, u_1, u_1} α α α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Append α] => { hAppend := fun a b => inst.append a b }
```

### D056: `instHSMul`

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

### D057: `instHSub`

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

### D058: `instNatCastInt`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7fb46bceee4f1142c75008c8ac4be64c11c4bdbc7972ff89c0a5335ad80a2033`

Type:

```lean
NatCast Int
```

Fully explicit type:

```lean
NatCast.{0} Int
```

Definition body (one-level semantic boundary):

```lean
{ natCast := fun n => Int.ofNat n }
```

### D059: `List.map`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D060: `Prod.fst`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
- Semantic SHA-256: `31dfcc70f250d68311839281cfb552859ef6a5cdd31e725091d6a2a2f7fb2165`

Type:

```lean
{α : Type u} → {β : Type v} → Prod α β → α
```

Fully explicit type:

```lean
{α : Type u} → {β : Type v} → (self : Prod.{u, v} α β) → α
```

Definition body (one-level semantic boundary):

```lean
fun α β self => self.1
```

### D061: `instOfNat`

- Role: `external-frontier`
- Owner module: `Init.Data.Int.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D062: `DivInvMonoid.toDiv`

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

### D063: `HDiv.hDiv`

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

### D064: `List.foldl`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `3`
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

### D065: `Real.instDivInvMonoid`

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

### D066: `instHDiv`

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

## Complete local imported sources

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean`
SHA-256: `eec0a71127f26258c319639629e9d6fe274b706c4f77ae09fb877a14e2c367ff`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-!
# One-dimensional finite-volume cell averages

Source-independent definitions for the average of a Banach-space-valued field
over an ordered, nondegenerate one-dimensional cell.  The accompanying
predicate records both nondegeneracy and interval integrability explicitly.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- A finite-volume grid represented by a nonempty measurable partition of a
chosen spatial domain.  Geometry-specific shape conditions are intentionally
left to downstream grid structures. -/
structure FiniteVolumeCellPartition (Cell Point : Type*)
    [MeasurableSpace Point] where
  /-- The spatial region covered by the modeled partition. -/
  domain : Set Point
  /-- The measurable spatial region assigned to each cell. -/
  cellRegion : Cell → Set Point
  cells_nonempty : Nonempty Cell
  measurable_cell : ∀ cell, MeasurableSet (cellRegion cell)
  disjoint_cells : ∀ {cell₁ cell₂}, cell₁ ≠ cell₂ →
    Disjoint (cellRegion cell₁) (cellRegion cell₂)
  covers_domain : ∀ point,
    point ∈ domain ↔ ∃ cell, point ∈ cellRegion cell

/-- A cellwise material property represented by the material-parameter value
obtained after averaging over that cell.  The wrapper keeps the role of an
assigned effective property distinct from the underlying spatial parameter
field without postulating an unconstrained conversion or suitability
predicate. -/
structure CellAveragedMaterialProperty (Parameter : Type*) where
  /-- The effective material parameter assigned after cell averaging. -/
  averagedParameter : Parameter

/-- A model-indexed rule for averaging material parameters over finite-volume
cells.  The rule is deliberately not fixed to an arithmetic, harmonic, or
tensor mean.  Its two laws capture the source-independent content of being a
cell average: changing a field outside the cell has no effect, and constant
fields are reproduced on positive finite-volume cells. -/
structure CellMaterialAveragingRule
    (Model Cell Point Parameter : Type*) [MeasurableSpace Point]
    (cellRegion : Cell → Set Point) where
  /-- Compute an effective parameter from a model, measure, cell, and
  spatially varying parameter field. -/
  averageParameter :
    Model → Measure Point → Cell → (Point → Parameter) → Parameter
  local_congr : ∀ model volumeMeasure cell field₁ field₂,
    Set.EqOn field₁ field₂ (cellRegion cell) →
      averageParameter model volumeMeasure cell field₁ =
        averageParameter model volumeMeasure cell field₂
  preserves_constants : ∀ model volumeMeasure cell parameter,
    volumeMeasure (cellRegion cell) ≠ 0 →
      volumeMeasure (cellRegion cell) ≠ ⊤ →
        averageParameter model volumeMeasure cell (fun _ => parameter) =
          parameter

/-- The normalized Bochner integral of a field over a measurable cell region.
The associated predicate below records the hypotheses under which this is a
genuine finite, positive-volume average. -/
noncomputable def cellVolumeAverage
    {Point E : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Measure Point) (region : Set Point) (field : Point → E) : E :=
  (μ region).toReal⁻¹ • ∫ point in region, field point ∂μ

/-- `average` is the normalized volume average of `field` on `region`.
Positivity, finiteness, and integrability rule out the degenerate conventions
of `ENNReal.toReal` and the Bochner integral. -/
def IsCellVolumeAverage
    {Point E : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Measure Point) (region : Set Point) (field : Point → E)
    (average : E) : Prop :=
  μ region ≠ 0 ∧
    μ region ≠ ⊤ ∧
    IntegrableOn field region μ ∧
    average = cellVolumeAverage μ region field

/-- The canonical normalized integral satisfies the volume-average predicate
on every finite, positive-volume cell where the field is integrable. -/
theorem cellVolumeAverage_isCellVolumeAverage
    {Point E : Type*} [MeasurableSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Measure Point) (region : Set Point) (field : Point → E)
    (hpositive : μ region ≠ 0) (hfinite : μ region ≠ ⊤)
    (hintegrable : IntegrableOn field region μ) :
    IsCellVolumeAverage μ region field
      (cellVolumeAverage μ region field) :=
  ⟨hpositive, hfinite, hintegrable, rfl⟩

/-- The average of a field over the one-dimensional interval from `left` to
`right`: its Bochner integral divided by the cell width.

Use `IsOneDimensionalCellAverage` when the mathematical assertion must also
record that the interval is nondegenerate and the field is integrable there.
-/
noncomputable def oneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right : ℝ) : E :=
  (right - left)⁻¹ • ∫ x in left..right, field x

/-- `average` is the finite-volume average of `field` on an ordered,
nondegenerate cell, with interval integrability stated explicitly. -/
def IsOneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) (left right : ℝ) (average : E) : Prop :=
  left < right ∧
    IntervalIntegrable field volume left right ∧
      average = oneDimensionalCellAverage field left right

/-- The canonical average satisfies the cell-average predicate whenever the
cell is ordered and the field is interval integrable. -/
theorem oneDimensionalCellAverage_isCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) {left right : ℝ}
    (hcell : left < right)
    (hfield : IntervalIntegrable field volume left right) :
    IsOneDimensionalCellAverage field left right
      (oneDimensionalCellAverage field left right) :=
  ⟨hcell, hfield, rfl⟩

/-- Multiplying a cell average by its positive width recovers the cell
integral. -/
theorem cellWidth_smul_oneDimensionalCellAverage
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (field : ℝ → E) {left right : ℝ} (hcell : left < right) :
    (right - left) • oneDimensionalCellAverage field left right =
      ∫ x in left..right, field x := by
  have hwidth : right - left ≠ 0 := sub_ne_zero.mpr (ne_of_gt hcell)
  simp [oneDimensionalCellAverage, smul_smul, hwidth]

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalFluxBalance.lean`
SHA-256: `122237fad4f0702f50721b2a425de8e814b73feef02b81025021835545655ae1`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Algebra.BigOperators.Module
import Mathlib.Tactic.Module

/-!
# Local numerical fluxes on finite-volume cell partitions

Source-independent infrastructure for conservative finite-volume updates on an
abstract finite collection of cells and oriented interfaces.  Cell states are
genuine normalized volume averages.  An interface flux is computed only from
the averages in the two cells incident to that interface.  No integer or
half-line indexing convention is built in.

The boundary-flux identity below works for every finite collection of cells.
An interface whose two cells are both inside the collection cancels, while an
interface crossing its boundary contributes with the orientation of that
interface.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability

/-- A finite-volume partition equipped with oriented interfaces between
distinct cells.  `interfacePoint` identifies where the corresponding physical
conservation-law flux is evaluated; it is required to lie in the modeled
domain. -/
structure FiniteVolumeInterfaceMesh
    (Cell Interface Point : Type*) [MeasurableSpace Point]
    [TopologicalSpace Point]
    extends FiniteVolumeCellPartition Cell Point where
  interfaces_nonempty : Nonempty Interface
  /-- The cell designated as the left side of each oriented interface. -/
  leftCell : Interface → Cell
  /-- The cell designated as the right side of each oriented interface. -/
  rightCell : Interface → Cell
  leftCell_ne_rightCell : ∀ interface,
    leftCell interface ≠ rightCell interface
  /-- The physical point at which each interface is located. -/
  interfacePoint : Interface → Point
  interfacePoint_mem_domain : ∀ interface,
    interfacePoint interface ∈ domain
  interfacePoint_mem_leftCellClosure : ∀ interface,
    interfacePoint interface ∈ closure (cellRegion (leftCell interface))
  interfacePoint_mem_rightCellClosure : ∀ interface,
    interfacePoint interface ∈ closure (cellRegion (rightCell interface))

/-- The normalized integral of a conserved field on each cell of a
finite-volume mesh. -/
noncomputable def finiteVolumeCellAverages
    {Cell Interface Point E : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (μ : Measure Point) (conservedField : Point → E) : Cell → E :=
  fun cell => cellVolumeAverage μ (mesh.cellRegion cell) conservedField

/-- A local interface flux uses precisely the approximate averages in the
oriented left and right cells of that interface. -/
def neighboringCellNumericalFlux
    {Cell Interface Point State Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (localNumericalFlux : State → State → Flux)
    (cellAverages : Cell → State) : Interface → Flux :=
  fun interface => localNumericalFlux
    (cellAverages (mesh.leftCell interface))
    (cellAverages (mesh.rightCell interface))

/-- The correct physical interface flux obtained by applying the flux of a
conservation law to the conserved field at the interface point. -/
def conservationLawInterfaceFlux
    {Cell Interface Point State Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (conservedField : Point → State)
    (physicalConservationFlux : State → Flux) : Interface → Flux :=
  fun interface =>
    physicalConservationFlux (conservedField (mesh.interfacePoint interface))

/-- Net outward numerical flux from one cell.  An oriented interface is
outgoing from its left cell and incoming to its right cell. -/
def finiteVolumeNetOutwardFlux
    {Cell Interface Point Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup Flux]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (interfaceFlux : Interface → Flux) (cell : Cell) : Flux :=
  ∑ interface : Interface,
    ((if mesh.leftCell interface = cell then interfaceFlux interface else 0) -
      (if mesh.rightCell interface = cell then interfaceFlux interface else 0))

/-- Oriented flux through the boundary of a finite collection of cells.
Interfaces internal to the collection occur once with each sign and hence
cancel. -/
def finiteVolumeBoundaryFlux
    {Cell Interface Point Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup Flux]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (interfaceFlux : Interface → Flux) (cells : Finset Cell) : Flux :=
  ∑ interface : Interface,
    ((if mesh.leftCell interface ∈ cells then interfaceFlux interface else 0) -
      (if mesh.rightCell interface ∈ cells then interfaceFlux interface else 0))

/-- Summing cellwise net outward flux over any finite cell collection leaves
exactly its oriented boundary flux. -/
theorem sum_finiteVolumeNetOutwardFlux_eq_boundaryFlux
    {Cell Interface Point Flux : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup Flux]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (interfaceFlux : Interface → Flux) (cells : Finset Cell) :
    ∑ cell ∈ cells, finiteVolumeNetOutwardFlux mesh interfaceFlux cell =
      finiteVolumeBoundaryFlux mesh interfaceFlux cells := by
  classical
  simp only [finiteVolumeNetOutwardFlux, finiteVolumeBoundaryFlux,
    Finset.sum_sub_distrib]
  have hleft :
      (∑ cell ∈ cells, ∑ interface : Interface,
          if mesh.leftCell interface = cell then interfaceFlux interface else 0) =
        ∑ interface : Interface,
          if mesh.leftCell interface ∈ cells then interfaceFlux interface else 0 := by
    calc
      _ = ∑ interface : Interface, ∑ cell ∈ cells,
          if mesh.leftCell interface = cell then interfaceFlux interface else 0 :=
        Finset.sum_comm
      _ = _ := by simp [eq_comm]
  have hright :
      (∑ cell ∈ cells, ∑ interface : Interface,
          if mesh.rightCell interface = cell then interfaceFlux interface else 0) =
        ∑ interface : Interface,
          if mesh.rightCell interface ∈ cells then interfaceFlux interface else 0 := by
    calc
      _ = ∑ interface : Interface, ∑ cell ∈ cells,
          if mesh.rightCell interface = cell then interfaceFlux interface else 0 :=
        Finset.sum_comm
      _ = _ := by simp [eq_comm]
  rw [hleft, hright]

/-- Update one cell average over a time interval from its net outward flux.
The cell volume is an explicit argument so geometry-specific volume choices
remain outside this source-independent operation. -/
noncomputable def finiteVolumeCellAverageUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStep cellVolume : ℝ) (oldAverage netOutwardFlux : E) : E :=
  oldAverage - (timeStep / cellVolume) • netOutwardFlux

/-- Multiplying the average update by a nonzero cell volume recovers the
integral conservative balance for the cell total. -/
theorem cellVolume_smul_finiteVolumeCellAverageUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStep cellVolume : ℝ) (oldAverage netOutwardFlux : E)
    (hcellVolume : cellVolume ≠ 0) :
    cellVolume • finiteVolumeCellAverageUpdate
        timeStep cellVolume oldAverage netOutwardFlux =
      cellVolume • oldAverage - timeStep • netOutwardFlux := by
  have hscale : cellVolume * (timeStep / cellVolume) = timeStep := by
    field_simp
  simp [finiteVolumeCellAverageUpdate, smul_sub, smul_smul, hscale]

/-- Cellwise conservative total balances sum to the corresponding boundary
balance on every finite cell collection. -/
theorem sum_finiteVolumeCellTotalBalance
    {Cell Interface Point E : Type*} [MeasurableSpace Point]
    [TopologicalSpace Point]
    [Fintype Interface] [DecidableEq Cell]
    [AddCommGroup E] [Module ℝ E]
    (mesh : FiniteVolumeInterfaceMesh Cell Interface Point)
    (cellVolume : Cell → ℝ) (timeStep : ℝ)
    (oldAverage updatedAverage : Cell → E)
    (interfaceFlux : Interface → E)
    (hbalance : ∀ cell,
      cellVolume cell • updatedAverage cell =
        cellVolume cell • oldAverage cell -
          timeStep • finiteVolumeNetOutwardFlux mesh interfaceFlux cell)
    (cells : Finset Cell) :
    ∑ cell ∈ cells, cellVolume cell • updatedAverage cell =
      (∑ cell ∈ cells, cellVolume cell • oldAverage cell) -
        timeStep • finiteVolumeBoundaryFlux mesh interfaceFlux cells := by
  calc
    ∑ cell ∈ cells, cellVolume cell • updatedAverage cell =
        ∑ cell ∈ cells,
          (cellVolume cell • oldAverage cell -
            timeStep • finiteVolumeNetOutwardFlux mesh interfaceFlux cell) := by
      apply Finset.sum_congr rfl
      intro cell hcell
      exact hbalance cell
    _ = (∑ cell ∈ cells, cellVolume cell • oldAverage cell) -
        timeStep •
          (∑ cell ∈ cells,
            finiteVolumeNetOutwardFlux mesh interfaceFlux cell) := by
      simp [Finset.sum_sub_distrib, Finset.smul_sum]
    _ = (∑ cell ∈ cells, cellVolume cell • oldAverage cell) -
        timeStep • finiteVolumeBoundaryFlux mesh interfaceFlux cells := by
      rw [sum_finiteVolumeNetOutwardFlux_eq_boundaryFlux]

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FluxDifference.lean`
SHA-256: `e44e135d4047068af4fc5498d3842c408607e352f09fa07b35eee0c4e493b190`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.BigOperators.Module
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Module

/-!
# Conservative finite-volume flux differences

Source-independent data for a one-dimensional conservative update.  Interface
flux `edgeFlux i` is the flux through the left edge of cell `i`, so the update
subtracts the right-minus-left flux difference.  The finite-sum theorem makes
the resulting boundary-flux conservation exact.
-/

open scoped BigOperators

namespace NumStability

/-- One conservative flux-difference update of cell `i`.

`timeStepOverCellWidth` is the usual ratio `Δt / Δx`; keeping it abstract
also covers non-dimensionalized updates. -/
def conservativeFluxDifferenceUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℕ → E) (i : ℕ) : E :=
  cellAverages i -
    timeStepOverCellWidth • (edgeFlux (i + 1) - edgeFlux i)

/-- The same conservative edge-flux update on integer-indexed cells. -/
def conservativeFluxDifferenceUpdateInt
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℤ → E) (i : ℤ) : E :=
  cellAverages i -
    timeStepOverCellWidth • (edgeFlux (i + 1) - edgeFlux i)

/-- Summing a conservative flux-difference update over the first `cellCount`
cells cancels every interior interface flux.  Only the two boundary fluxes
remain. -/
theorem sum_conservativeFluxDifferenceUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℕ → E) (cellCount : ℕ) :
    ∑ i ∈ Finset.range cellCount,
        conservativeFluxDifferenceUpdate
          timeStepOverCellWidth cellAverages edgeFlux i =
      (∑ i ∈ Finset.range cellCount, cellAverages i) -
        timeStepOverCellWidth •
          (edgeFlux cellCount - edgeFlux 0) := by
  induction cellCount with
  | zero => simp
  | succ cellCount ih =>
      rw [Finset.sum_range_succ, Finset.sum_range_succ, ih]
      simp only [conservativeFluxDifferenceUpdate]
      module

/-- If the two boundary fluxes agree, a finite block's total cell average is
unchanged by the conservative update. -/
theorem sum_conservativeFluxDifferenceUpdate_of_boundaryFlux_eq
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℕ → E) (cellCount : ℕ)
    (hboundary : edgeFlux cellCount = edgeFlux 0) :
    ∑ i ∈ Finset.range cellCount,
        conservativeFluxDifferenceUpdate
          timeStepOverCellWidth cellAverages edgeFlux i =
      ∑ i ∈ Finset.range cellCount, cellAverages i := by
  rw [sum_conservativeFluxDifferenceUpdate, hboundary, sub_self,
    smul_zero, sub_zero]

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CoordinateLineBalance.lean`
SHA-256: `bd675d6368df0a5a0479b2b1fcb25f521d15ea9a15b957090bb35eef5c1918d9`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference

/-!
# Conservative coordinate lines with supplied cell volumes

Cells have indices `D → ℤ`. A shared face is indexed by its direction and
right cell; its supplied numerical normal flux includes the face-area factor.
The actual update reads one coordinate line and conserves volume-weighted
mass, with the two exterior face terms retained on each finite line.

Volumes are supplied positive data in the balance theorems. This algebra
does not derive a physical chart, measure, normal, area, or constitutive flux
from the indices, and does not assert accuracy or constant-state preservation.
-/

open scoped BigOperators

namespace NumStability.CoordinateLineBalance

variable {D E : Type*} [DecidableEq D] [AddCommGroup E] [Module ℝ E]

/-- The rule reads the actual coordinate line through the indexed shared face.
Its `E`-valued output is the supplied oriented, area-integrated normal flux. -/
def normalFaceFlux
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (rightCell : D → ℤ) : E :=
  rule d rightCell dt (fun j => state (Function.update rightCell d j))

/-- The right face of a cell is the left face of its coordinate successor. -/
def netOutwardFlux (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) : E :=
  normalFaceFlux rule d dt state (Function.update cell d (cell d + 1)) -
    normalFaceFlux rule d dt state cell

/-- One conservative coordinate-direction update with the supplied physical volume. -/
noncomputable def advance (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) : E :=
  finiteVolumeCellAverageUpdate dt (volume cell) (state cell)
    (netOutwardFlux rule d dt state cell)

/-- The cell-total formula is a direct instance of the existing generic theorem. -/
theorem advance_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) :
    volume cell • advance volume rule d dt state cell =
      volume cell • state cell - dt • netOutwardFlux rule d dt state cell :=
  cellVolume_smul_finiteVolumeCellAverageUpdate _ _ _ _ (hvolume cell).ne'

/-- No values outside this coordinate line can affect its updated states. -/
theorem advance_line_local (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state other : (D → ℤ) → E) (base : D → ℤ)
    (hline : ∀ j, state (Function.update base d j) = other (Function.update base d j)) :
    ∀ j, advance volume rule d dt state (Function.update base d j) =
      advance volume rule d dt other (Function.update base d j) := by
  intro j
  simp only [advance, finiteVolumeCellAverageUpdate, netOutwardFlux,
    normalFaceFlux, Function.update_self, Function.update_idem]
  rw [hline j, funext hline]

/-- Every interior shared-face value cancels, with arbitrary nonuniform volumes. -/
theorem finite_line_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E)
    (base : D → ℤ) (start : ℤ) (count : ℕ) :
    (∑ k ∈ Finset.range count,
      volume (Function.update base d (start + k)) •
        advance volume rule d dt state (Function.update base d (start + k))) =
      (∑ k ∈ Finset.range count,
        volume (Function.update base d (start + k)) • state (Function.update base d (start + k))) -
      dt • (normalFaceFlux rule d dt state (Function.update base d (start + count)) -
        normalFaceFlux rule d dt state (Function.update base d start)) := by
  let mass : ℕ → E := fun k =>
    volume (Function.update base d (start + k)) • state (Function.update base d (start + k))
  let faces : ℕ → E := fun k =>
    normalFaceFlux rule d dt state (Function.update base d (start + k))
  calc
    _ = ∑ k ∈ Finset.range count, conservativeFluxDifferenceUpdate dt mass faces k := by
      apply Finset.sum_congr rfl
      intro k hk
      rw [advance_mass_balance volume hvolume]
      simp [conservativeFluxDifferenceUpdate, mass, faces, netOutwardFlux,
        Function.update_idem, add_assoc]
    _ = _ := by
      simpa [mass, faces] using sum_conservativeFluxDifferenceUpdate dt mass faces count

/-- Equal exterior face fluxes preserve the total physical mass on the finite line. -/
theorem finite_line_mass_preserved (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E)
    (base : D → ℤ) (start : ℤ) (count : ℕ)
    (hboundary : normalFaceFlux rule d dt state (Function.update base d (start + count)) =
      normalFaceFlux rule d dt state (Function.update base d start)) :
    (∑ k ∈ Finset.range count,
      volume (Function.update base d (start + k)) •
        advance volume rule d dt state (Function.update base d (start + k))) =
      ∑ k ∈ Finset.range count,
        volume (Function.update base d (start + k)) • state (Function.update base d (start + k)) := by
  rw [finite_line_mass_balance volume hvolume, hboundary, sub_self, smul_zero, sub_zero]

/-- In two adjacent cells the same intermediate normal flux occurs with opposite signs. -/
theorem adjacent_cells_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) :
    volume cell • advance volume rule d dt state cell +
      volume (Function.update cell d (cell d + 1)) •
        advance volume rule d dt state (Function.update cell d (cell d + 1)) =
      volume cell • state cell +
        volume (Function.update cell d (cell d + 1)) • state (Function.update cell d (cell d + 1)) -
      dt • (normalFaceFlux rule d dt state (Function.update cell d (cell d + 2)) -
        normalFaceFlux rule d dt state cell) := by
  rw [advance_mass_balance volume hvolume, advance_mass_balance volume hvolume]
  simp only [netOutwardFlux, Function.update_self, Function.update_idem]
  have hindex : cell d + 1 + 1 = cell d + 2 := by omega
  rw [hindex]
  module

end NumStability.CoordinateLineBalance
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/OperatorSplitting.lean`
SHA-256: `6aea9ae76f594b3e2c3b177421aa9b396054ddef3adc4f04c733a9bde7d97cad`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.List.Basic
import Mathlib.Data.Real.Basic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

/-!
# Coordinate-direction finite-volume splitting

This file gives source-independent data for an ordered fractional-step sweep.
The grid carries an actual finite-volume partition whose cells are coordinate
boxes in either physical or logical coordinates. A directional solver acts
on cell averages, and execution records the intermediate state before every
in-turn solve.
-/

namespace NumStability

universe u v

/-- A finite-volume state assigns one cell-average value to every cell. -/
abbrev FiniteVolumeCellState (Cell Value : Type*) := Cell → Value

/-- A finite, nonempty, exhaustive family of coordinate directions together
with a chosen sweep order. The order is data: this structure imposes no
distinguished first direction. -/
structure CoordinateDirectionFamily (Direction : Type*) where
  /-- The exhaustive, duplicate-free coordinate directions in sweep order. -/
  directions : List Direction
  directions_nonempty : directions ≠ []
  directions_nodup : directions.Nodup
  directions_exhaustive : ∀ direction, direction ∈ directions

/-- Coordinate data witnessing the two grid geometries used by dimensional
splitting. In the rectangular case the physical point space itself is the
Cartesian coordinate space. In the logically rectangular case an arbitrary
physical point space is related to that Cartesian space by an invertible
logical-coordinate chart. -/
inductive CoordinateGridGeometry (Point Direction : Type u) where
  | rectangular (physicalPointSpace : Point = (Direction → ℝ))
  | logicallyRectangular (logicalCoordinates : Point ≃ (Direction → ℝ))

/-- The physical or logical coordinate chart carried by a coordinate grid. -/
def CoordinateGridGeometry.coordinates
    {Point Direction : Type u} :
    CoordinateGridGeometry Point Direction → Point ≃ (Direction → ℝ)
  | .rectangular physicalPointSpace => Equiv.cast physicalPointSpace
  | .logicallyRectangular logicalCoordinates => logicalCoordinates

/-- The coordinate box with the supplied lower and upper faces. Half-open
boxes permit adjacent finite-volume cells to be disjoint as sets. -/
def coordinateCellBox
    {Point Direction : Type u}
    (geometry : CoordinateGridGeometry Point Direction)
    (directions : List Direction)
    (lowerFace upperFace : Direction → ℝ) : Set Point :=
  { point | ∀ direction ∈ directions,
      lowerFace direction ≤ geometry.coordinates point direction ∧
        geometry.coordinates point direction < upperFace direction }

/-- A rectangular or logically rectangular finite-volume grid.

Besides a coordinate chart, the structure records a measurable disjoint cell
partition, positive coordinate widths, and the fact that each cell really is
a box in those coordinates. Thus the geometry constructors are not merely
labels. -/
structure CoordinateFiniteVolumeGrid
    (Cell : Type v) (Point Direction : Type u) [MeasurableSpace Point] where
  /-- The measurable finite-volume partition underlying the coordinate grid. -/
  partition : FiniteVolumeCellPartition Cell Point
  /-- The coordinate directions together with their chosen sweep order. -/
  coordinateDirections : CoordinateDirectionFamily Direction
  /-- The rectangular or logically rectangular coordinate chart. -/
  geometry : CoordinateGridGeometry Point Direction
  /-- The lower coordinate face of each cell in each direction. -/
  lowerFace : Cell → Direction → ℝ
  /-- The upper coordinate face of each cell in each direction. -/
  upperFace : Cell → Direction → ℝ
  positive_coordinate_width : ∀ cell direction,
    lowerFace cell direction < upperFace cell direction
  cellRegion_eq_coordinateBox : ∀ cell,
    partition.cellRegion cell =
      coordinateCellBox geometry coordinateDirections.directions
        (lowerFace cell) (upperFace cell)

/-- One one-dimensional high-resolution finite-volume solve, represented by
its action on cell averages at a requested fraction of a full step.

Constant-state preservation is the source-independent consistency law used
here; no flux formula, limiter, adjacency convention, or accuracy order is
chosen. -/
structure OneDimensionalHighResolutionFiniteVolumeSolve
    (Cell Value : Type*) where
  /-- Advance cell averages through the requested fraction of a full step. -/
  advanceCellAverages :
    ℝ → FiniteVolumeCellState Cell Value → FiniteVolumeCellState Cell Value
  preserves_constant_states : ∀ fraction value,
    advanceCellAverages fraction (fun _ => value) = fun _ => value

/-- An admissible fractional solve scheduled in one coordinate direction. -/
structure CoordinateFractionalStep
    (Direction Cell Value : Type*) where
  /-- The coordinate direction advanced by this fractional step. -/
  direction : Direction
  /-- The positive fraction of a full time step to advance. -/
  timeFraction : ℝ
  positive_timeFraction : 0 < timeFraction
  timeFraction_le_one : timeFraction ≤ 1
  /-- The one-dimensional solver applied in the selected direction. -/
  oneDimensionalSolve :
    OneDimensionalHighResolutionFiniteVolumeSolve Cell Value

/-- Apply a fractional step to a finite-volume cell-average state. The
scheduled fraction is an input to the directional solver, rather than inert
metadata. -/
def CoordinateFractionalStep.advance
    {Direction Cell Value : Type*}
    (step : CoordinateFractionalStep Direction Cell Value)
    (state : FiniteVolumeCellState Cell Value) :
    FiniteVolumeCellState Cell Value :=
  step.oneDimensionalSolve.advanceCellAverages step.timeFraction state

/-- A one-dimensional high-resolution finite-volume solver and admissible
fraction chosen for every coordinate direction. -/
structure CoordinateHighResolutionMethod
    (Direction Cell Value : Type*) where
  /-- Select the one-dimensional solver used for each coordinate direction. -/
  solveDirection :
    Direction → OneDimensionalHighResolutionFiniteVolumeSolve Cell Value
  /-- Select the fraction of a full step taken in each direction. -/
  timeFraction : Direction → ℝ
  positive_timeFraction : ∀ direction, 0 < timeFraction direction
  timeFraction_le_one : ∀ direction, timeFraction direction ≤ 1

/-- Package the method data for one direction as a scheduled fractional step. -/
def CoordinateHighResolutionMethod.fractionalStep
    {Direction Cell Value : Type*}
    (method : CoordinateHighResolutionMethod Direction Cell Value)
    (direction : Direction) : CoordinateFractionalStep Direction Cell Value :=
  { direction := direction
    timeFraction := method.timeFraction direction
    positive_timeFraction := method.positive_timeFraction direction
    timeFraction_le_one := method.timeFraction_le_one direction
    oneDimensionalSolve := method.solveDirection direction }

/-- Schedule every coordinate direction once, in the order selected by the
direction family. -/
def coordinateFractionalSchedule
    {Direction Cell Value : Type*}
    (directions : CoordinateDirectionFamily Direction)
    (method : CoordinateHighResolutionMethod Direction Cell Value) :
    List (CoordinateFractionalStep Direction Cell Value) :=
  directions.directions.map method.fractionalStep

/-- Apply update operators from left to right to an initial state. -/
def orderedOperatorSweep {State : Type*}
    (operators : List (State → State)) (state : State) : State :=
  operators.foldl (fun current step => step current) state

/-- Apply coordinate-direction fractional steps sequentially in their listed
order. -/
def coordinateFractionalSweep
    {Direction Cell Value : Type*} :
    List (CoordinateFractionalStep Direction Cell Value) →
      FiniteVolumeCellState Cell Value → FiniteVolumeCellState Cell Value
  | [], state => state
  | step :: steps, state =>
      coordinateFractionalSweep steps (step.advance state)

/-- The state trace produced while applying coordinate-direction fractional
steps in turn. It contains the initial state and one state after each step. -/
def coordinateFractionalTrace
    {Direction Cell Value : Type*} :
    List (CoordinateFractionalStep Direction Cell Value) →
      FiniteVolumeCellState Cell Value →
        List (FiniteVolumeCellState Cell Value)
  | [], state => [state]
  | step :: steps, state =>
      state :: coordinateFractionalTrace steps (step.advance state)

/-- `CoordinateSweepExecution steps initial final trace` states operationally
that the listed steps are executed in turn, with `trace` recording the state
before the first solve and after each solve. -/
inductive CoordinateSweepExecution
    {Direction Cell Value : Type*} :
    List (CoordinateFractionalStep Direction Cell Value) →
      FiniteVolumeCellState Cell Value →
        FiniteVolumeCellState Cell Value →
          List (FiniteVolumeCellState Cell Value) → Prop where
  | nil (state) : CoordinateSweepExecution [] state state [state]
  | cons (step) (steps) (initial final tailTrace)
      (tailExecution : CoordinateSweepExecution steps
        (step.advance initial) final tailTrace) :
      CoordinateSweepExecution (step :: steps) initial final
        (initial :: tailTrace)

/-- The recursive sweep and trace give a certified in-turn execution. -/
theorem coordinateFractionalSweep_executes
    {Direction Cell Value : Type*}
    (steps : List (CoordinateFractionalStep Direction Cell Value))
    (state : FiniteVolumeCellState Cell Value) :
    CoordinateSweepExecution steps state
      (coordinateFractionalSweep steps state)
      (coordinateFractionalTrace steps state) := by
  induction steps generalizing state with
  | nil => exact .nil state
  | cons step steps ih =>
      exact .cons step steps state
        (coordinateFractionalSweep steps (step.advance state))
        (coordinateFractionalTrace steps (step.advance state))
        (ih (state := step.advance state))

/-- An in-turn trace has exactly one more state than scheduled solves. -/
@[simp] theorem coordinateFractionalTrace_length
    {Direction Cell Value : Type*}
    (steps : List (CoordinateFractionalStep Direction Cell Value))
    (state : FiniteVolumeCellState Cell Value) :
    (coordinateFractionalTrace steps state).length = steps.length + 1 := by
  induction steps generalizing state with
  | nil => rfl
  | cons step steps ih =>
      simp only [coordinateFractionalTrace, List.length_cons]
      rw [ih (state := step.advance state)]

@[simp] theorem orderedOperatorSweep_nil {State : Type*} (state : State) :
    orderedOperatorSweep ([] : List (State → State)) state = state :=
  rfl

/-- A two-direction sweep first applies the first operator and then the
second. -/
@[simp] theorem orderedOperatorSweep_two
    {State : Type*} (first second : State → State) (state : State) :
    orderedOperatorSweep [first, second] state = second (first state) :=
  rfl

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CoordinateLineSweep.lean`
SHA-256: `bdcb7d85f92013d5d6d389f9656ed5c7216f1270aefd60e390df3fb1595df640`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting

/-!
# Successive conservative coordinate-line updates

The existing ordered operator sweep executes the supplied direction-duration
list. Each normal-flux rule reads its actual intermediate numerical state.
The two-stage mass identity retains both directional transfers; it does not
assert commutation, a high-resolution property, or a physical geometry.
-/

open scoped BigOperators

namespace NumStability.CoordinateLineBalance

variable {D E : Type*} [DecidableEq D] [AddCommGroup E] [Module ℝ E]

/-- Execute the conservative directional operators in the supplied order.
Each rule is reevaluated on its actual intermediate state. -/
noncomputable def sweep (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (stages : List (D × ℝ)) (state : (D → ℤ) → E) : (D → ℤ) → E :=
  orderedOperatorSweep (stages.map fun stage => advance volume rule stage.1 stage.2) state

/-- The remaining stages receive the state produced by the first directional update. -/
theorem sweep_cons (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (stages : List (D × ℝ)) (state : (D → ℤ) → E) :
    sweep volume rule ((d, dt) :: stages) state =
      sweep volume rule stages (advance volume rule d dt state) := rfl

/-- The existing ordered sweep really feeds the first update into the second. -/
theorem sweep_two (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d e : D) (dt ds : ℝ) (state : (D → ℤ) → E) :
    sweep volume rule [(d, dt), (e, ds)] state =
      advance volume rule e ds (advance volume rule d dt state) :=
  orderedOperatorSweep_two _ _ _

/-- Successive directional mass changes use their respective current numerical states. -/
theorem sweep_two_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d e : D) (dt ds : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) :
    volume cell • sweep volume rule [(d, dt), (e, ds)] state cell =
      volume cell • state cell - dt • netOutwardFlux rule d dt state cell -
        ds • netOutwardFlux rule e ds (advance volume rule d dt state) cell := by
  rw [sweep_two, advance_mass_balance volume hvolume, advance_mass_balance volume hvolume]

end NumStability.CoordinateLineBalance
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

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/IntegralConservationLaw.lean`
SHA-256: `1f8c29ed60aa56008c79a38acf7ff702b5f701fa60eae02733ebe824a0dd8800`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw

/-!
# Integral and differential forms of one-dimensional conservation laws

The integral formulation records the time derivative of every oriented cell
integral.  A separate theorem derives the classical pointwise residual under
explicit differentiation-under-the-integral and spatial smoothness hypotheses.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- The integral conservation law: the rate of change of the state between
any two endpoints is the incoming flux minus the outgoing flux. -/
def IsIntegralConservationLawSolution
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ)) : Prop :=
  ∀ a b t,
    IntervalIntegrable (fun x => q x t) volume a b ∧
      HasDerivAt (fun τ => ∫ x in a..b, q x τ)
        (flux (q a t) - flux (q b t)) t

/-- A continuous function whose integral on every oriented interval is zero
vanishes pointwise. -/
theorem continuous_eq_zero_of_intervalIntegral_eq_zero
    {ι : Type*} [Fintype ι]
    (g : ℝ → (ι → ℝ)) (hcontinuous : Continuous g)
    (hintegral : ∀ a b, ∫ x in a..b, g x = 0) :
    ∀ x, g x = 0 := by
  intro x
  have hderiv := intervalIntegral.integral_hasDerivAt_right
    (hcontinuous.intervalIntegrable 0 x)
    hcontinuous.aestronglyMeasurable.stronglyMeasurableAtFilter
    hcontinuous.continuousAt
  have hzeroDerivative : HasDerivAt (fun _ : ℝ => 0) (g x) x :=
    hderiv.congr_of_eventuallyEq
      (Filter.Eventually.of_forall fun b => (hintegral 0 b).symm)
  exact hzeroDerivative.unique (hasDerivAt_const x 0)

/-- Under explicit classical smoothness and interchange hypotheses, the
integral balance implies the differential conservation-law residual. -/
theorem integralConservationLaw_implies_pointwise
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ))
    (qt fluxx : ℝ → (ι → ℝ)) (t : ℝ)
    (hintegralLaw : IsIntegralConservationLawSolution q flux)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hfluxx : ∀ x,
      HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x)
    (hqtIntegrable : ∀ a b, IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : ∀ a b, IntervalIntegrable fluxx volume a b)
    (hinterchange : ∀ a b,
      HasDerivAt (fun τ => ∫ x in a..b, q x τ)
        (∫ x in a..b, qt x) t)
    (hresidualContinuous : Continuous fun x => qt x + fluxx x) :
    ∀ x, IsConservationLawSolutionAt q flux x t := by
  have hqtIntegral (a b : ℝ) :
      ∫ x in a..b, qt x = flux (q a t) - flux (q b t) :=
    (hinterchange a b).unique (hintegralLaw a b t).2
  have hfluxxIntegral (a b : ℝ) :
      ∫ x in a..b, fluxx x = flux (q b t) - flux (q a t) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt
      (fun x _ => hfluxx x) (hfluxxIntegrable a b)
  have hresidualIntegral (a b : ℝ) :
      ∫ x in a..b, (qt x + fluxx x) = 0 := by
    rw [intervalIntegral.integral_add
      (hqtIntegrable a b) (hfluxxIntegrable a b),
      hqtIntegral a b, hfluxxIntegral a b]
    abel
  have hpointwise := continuous_eq_zero_of_intervalIntegral_eq_zero
    (fun x => qt x + fluxx x) hresidualContinuous hresidualIntegral
  intro x
  exact ⟨qt x, fluxx x, hqt x, hfluxx x, hpointwise x⟩

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

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInterface.lean`
SHA-256: `1e457fa9277414332e1ca729bca1b989c28b88f5d753225e2dfb89d55b75bbea`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData

/-!
# Certified Riemann solves at finite-volume interfaces

This file supplies source-independent semantics for the local construction
used by one-dimensional finite-volume methods.  Integer-indexed cells are
actual adjacent intervals, their states are normalized interval integrals,
and a solver result carries a proof that its space-time field solves the
hyperbolic Riemann problem.  Numerical-flux information is extracted from
that certified solution before it is used in a conservative time update.

No formula for an approximate Riemann solver or numerical flux is imposed.
Instead, a flux procedure must at least be consistent on constant Riemann
problems; this leaves exact and suitably approximate interface procedures in
scope while excluding functions wholly unrelated to the physical flux.
-/

open MeasureTheory

namespace NumStability

/-- An integer-indexed one-dimensional finite-volume grid.  Cell `i - 1` and
cell `i` are genuinely adjacent: the right endpoint of the former is the left
endpoint of the latter. -/
structure OneDimensionalFiniteVolumeGrid where
  /-- The left endpoint of each integer-indexed cell. -/
  cellLeft : ℤ → ℝ
  /-- The right endpoint of each integer-indexed cell. -/
  cellRight : ℤ → ℝ
  cell_nonempty : ∀ i, cellLeft i < cellRight i
  adjacent : ∀ i, cellRight (i - 1) = cellLeft i

namespace OneDimensionalFiniteVolumeGrid

/-- The positive volume (length) of a one-dimensional finite-volume cell. -/
def cellVolume (grid : OneDimensionalFiniteVolumeGrid) (i : ℤ) : ℝ :=
  grid.cellRight i - grid.cellLeft i

/-- Every cell in a one-dimensional finite-volume grid has positive volume. -/
theorem cellVolume_pos (grid : OneDimensionalFiniteVolumeGrid) (i : ℤ) :
    0 < grid.cellVolume i :=
  sub_pos.mpr (grid.cell_nonempty i)

end OneDimensionalFiniteVolumeGrid

/-- The state stored in cell `i`: the normalized integral of the underlying
state field over the actual interval occupied by that cell. -/
noncomputable def finiteVolumeCellAverageOn
    {State : Type*} [NormedAddCommGroup State] [NormedSpace ℝ State]
    (grid : OneDimensionalFiniteVolumeGrid) (state : ℝ → State)
    (i : ℤ) : State :=
  oneDimensionalCellAverage state (grid.cellLeft i) (grid.cellRight i)

/-- The canonical grid value is a genuine cell integral divided by the
positive volume of its cell. -/
theorem finiteVolumeCellAverageOn_spec
    {State : Type*} [NormedAddCommGroup State] [NormedSpace ℝ State]
    (grid : OneDimensionalFiniteVolumeGrid) (state : ℝ → State)
    (hintegrable : ∀ i, IntervalIntegrable state volume
      (grid.cellLeft i) (grid.cellRight i)) (i : ℤ) :
    IsOneDimensionalCellAverage state (grid.cellLeft i) (grid.cellRight i)
      (finiteVolumeCellAverageOn grid state i) :=
  oneDimensionalCellAverage_isCellAverage state
    (grid.cell_nonempty i) (hintegrable i)

/-- A differentiable one-dimensional conservation law whose flux Jacobian is
hyperbolic at every state.  `fluxDerivative_eq_jacobian_mulVec` ties the
matrix used by the hyperbolicity condition to the actual derivative of the
physical flux. -/
structure OneDimensionalHyperbolicConservationLaw
    (Component : Type*) [Fintype Component] where
  /-- The physical flux as a function of the conserved state. -/
  physicalFlux : (Component → ℝ) → (Component → ℝ)
  /-- The Fréchet derivative of the physical flux at each state. -/
  fluxDerivative :
    (Component → ℝ) → ((Component → ℝ) →L[ℝ] (Component → ℝ))
  /-- The matrix representing the flux derivative in component coordinates. -/
  fluxJacobian : (Component → ℝ) → Matrix Component Component ℝ
  hasFDerivAt_physicalFlux : ∀ state,
    HasFDerivAt physicalFlux (fluxDerivative state) state
  fluxDerivative_eq_jacobian_mulVec : ∀ state direction,
    fluxDerivative state direction = (fluxJacobian state).mulVec direction
  jacobian_hyperbolic : ∀ state, IsRealHyperbolicMatrix (fluxJacobian state)

/-- The local hyperbolic Riemann problem determined by ordered left and right
states.  Its initial data are understood through `IsRiemannData`, so the value
at the jump itself remains immaterial. -/
structure HyperbolicRiemannProblem
    {Component : Type*} [Fintype Component]
    (_law : OneDimensionalHyperbolicConservationLaw Component) where
  /-- The constant initial state to the left of the jump. -/
  leftState : Component → ℝ
  /-- The constant initial state to the right of the jump. -/
  rightState : Component → ℝ

/-- A space-time field solves a hyperbolic Riemann problem when its initial
trace has the prescribed ordered piecewise-constant states and it satisfies
the integral conservation law for the problem's physical flux. -/
def IsHyperbolicRiemannSolution
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (problem : HyperbolicRiemannProblem law)
    (solution : ℝ → ℝ → (Component → ℝ)) : Prop :=
  IsRiemannData (fun x ↦ solution x 0)
      problem.leftState problem.rightState ∧
    IsIntegralConservationLawSolution solution law.physicalFlux

/-- A solver result paired with a mathematical certificate that it solves the
particular Riemann problem from which it was obtained. -/
structure CertifiedHyperbolicRiemannSolution
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (problem : HyperbolicRiemannProblem law) where
  /-- The space-time field proposed as the solution of `problem`. -/
  solution : ℝ → ℝ → (Component → ℝ)
  solves : IsHyperbolicRiemannSolution law problem solution

/-- A Riemann-interface procedure.  It solves each ordered local problem,
extracts method-specific information from the certified solution, and turns
that information into a numerical flux.  Constant-state consistency provides
the minimum physical qualification without prescribing a formula or error
metric for nonconstant exact or approximate fluxes. -/
structure RiemannInterfaceFluxMethod
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (Information : Type*) where
  /-- Solve an ordered Riemann problem and certify the resulting field. -/
  solve : (problem : HyperbolicRiemannProblem law) →
    CertifiedHyperbolicRiemannSolution law problem
  /-- Extract the method-specific information used to form an interface
  flux from a certified Riemann solution. -/
  extractInformation : {problem : HyperbolicRiemannProblem law} →
    CertifiedHyperbolicRiemannSolution law problem → Information
  /-- Convert extracted Riemann information into a numerical flux vector. -/
  numericalFluxFromInformation : Information → (Component → ℝ)
  consistent_on_constant_states : ∀ state,
    numericalFluxFromInformation
        (extractInformation
          (solve ({ leftState := state, rightState := state } :
            HyperbolicRiemannProblem law))) =
      law.physicalFlux state

/-- The Riemann problem at interface `i`, oriented from cell `i - 1` to cell
`i`. -/
def adjacentCellRiemannProblem
    {Component : Type*} [Fintype Component]
    (law : OneDimensionalHyperbolicConservationLaw Component)
    (cellAverages : ℤ → (Component → ℝ)) (i : ℤ) :
    HyperbolicRiemannProblem law :=
  { leftState := cellAverages (i - 1)
    rightState := cellAverages i }

/-- Information extracted from the certified Riemann solution at interface
`i`. -/
def adjacentCellRiemannInformation
    {Component Information : Type*} [Fintype Component]
    {law : OneDimensionalHyperbolicConservationLaw Component}
    (method : RiemannInterfaceFluxMethod law Information)
    (cellAverages : ℤ → (Component → ℝ)) (i : ℤ) : Information :=
  method.extractInformation
    (method.solve (adjacentCellRiemannProblem law cellAverages i))

/-- A numerical interface flux computed from information extracted from the
certified adjacent-cell Riemann solution. -/
def riemannInterfaceFlux
    {Component Information : Type*} [Fintype Component]
    {law : OneDimensionalHyperbolicConservationLaw Component}
    (method : RiemannInterfaceFluxMethod law Information)
    (cellAverages : ℤ → (Component → ℝ)) (i : ℤ) : Component → ℝ :=
  method.numericalFluxFromInformation
    (adjacentCellRiemannInformation method cellAverages i)

/-- One conservative time-step update using the numerical fluxes supplied by
the adjacent-cell Riemann solutions.  The scale is the actual positive cell
volume rather than an unrelated global parameter. -/
noncomputable def riemannFiniteVolumeUpdate
    {Component : Type*}
    (grid : OneDimensionalFiniteVolumeGrid) (timeStep : ℝ)
    (cellAverages edgeFlux : ℤ → (Component → ℝ)) (i : ℤ) :
    Component → ℝ :=
  cellAverages i -
    (timeStep / grid.cellVolume i) • (edgeFlux (i + 1) - edgeFlux i)

/-- Riemann initial data formed from the two cells adjacent to interface `i`.
This elementary constructor is retained for equation-level statements whose
value at the jump is chosen explicitly. -/
noncomputable def adjacentCellRiemannData
    {State : Type*} (cellAverages : ℤ → State)
    (valueAtOrigin : State) (i : ℤ) : ℝ → State :=
  riemannData (cellAverages (i - 1)) valueAtOrigin (cellAverages i)

/-- The adjacent-cell construction has the intended left and right states. -/
theorem adjacentCellRiemannData_isRiemannData
    {State : Type*} (cellAverages : ℤ → State)
    (valueAtOrigin : State) (i : ℤ) :
    IsRiemannData (adjacentCellRiemannData cellAverages valueAtOrigin i)
      (cellAverages (i - 1)) (cellAverages i) :=
  riemannData_isRiemannData _ _ _

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInformationFluxMethod.lean`
SHA-256: `12ed4b1f17aefd9b4d6d21e9730260ded49a46c5533131bc399aacbe76a6e6de`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface

/-!
# Riemann routines returning information

A routine on an explicit problem domain returns a dependent result, extracts
information and computes a constant-consistent flux. No returned field or PDE
certificate is required. Consistency alone does not assert physical accuracy.
-/

namespace NumStability

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}

structure RiemannInformationFluxMethod (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (Result : HyperbolicRiemannProblem law → Type*) (Information : Type*) where
  domain : HyperbolicRiemannProblem law → Prop
  solve : (problem : HyperbolicRiemannProblem law) → domain problem → Result problem
  extract : {problem : HyperbolicRiemannProblem law} → Result problem → Information
  numericalFlux : Information → (Fin m → ℝ)
  constants_in_domain : ∀ state,
    domain ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
  consistent : ∀ state, numericalFlux (extract (solve
    ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
    (constants_in_domain state))) = law.physicalFlux state

namespace RiemannInformationFluxMethod

variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

def selectedResult (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    Result (adjacentCellRiemannProblem law old j) :=
  method.solve (adjacentCellRiemannProblem law old j) (hdomain j)

def interfaceFlux (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    Fin m → ℝ :=
  method.numericalFlux (method.extract (selectedResult method old hdomain j))

/-- The ordered input and information belong to this selected result. No
physical solution, returned field or accuracy property is concluded. -/
theorem interface_execution (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    let problem := adjacentCellRiemannProblem law old j
    let result := method.solve problem (hdomain j)
    problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
    selectedResult method old hdomain j = result ∧
    interfaceFlux method old hdomain j = method.numericalFlux (method.extract result) :=
  ⟨rfl, rfl, rfl, rfl⟩

theorem interfaceFlux_constant (method : RiemannInformationFluxMethod law Result Information) (state : Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law (fun _ => state) j)) (j : ℤ) :
    interfaceFlux method (fun _ => state) hdomain j = law.physicalFlux state := by
  exact method.consistent state

end RiemannInformationFluxMethod
end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInformationCoordinateUpdate.lean`
SHA-256: `fba7866a6429066767780875bcf467d1ad31c771abf4f3354e8f09eb6ce09d35`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod

/-!
# Admitted information routines in coordinate-line updates

An actual adjacent problem supplies the selected result and extracted face flux.
The off-domain extension has no solver meaning; admitted updates are independent
of it. Cell and finite-line balances reuse the canonical shared-face executor.
No returned field, trace, accuracy assertion or total-routine assumption is added.
-/

namespace NumStability.RiemannInformationCoordinate

open scoped BigOperators

variable {D : Type*} [DecidableEq D] {m : ℕ}
variable {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
variable {Information : D → Type*}
variable (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))


def FaceAdmitted (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ) : Prop :=
  (methods d dt).domain (adjacentCellRiemannProblem (laws d)
    (fun j => state (Function.update cell d j)) (cell d))

def StageAdmitted (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) : Prop :=
  ∀ cell, FaceAdmitted methods d dt state cell

def selectedFaceFlux (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) : Fin m → ℝ :=
  (methods d dt).numericalFlux ((methods d dt).extract ((methods d dt).solve
    (adjacentCellRiemannProblem (laws d) (fun j => state (Function.update cell d j)) (cell d)) h))

noncomputable def guardedRule (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (cell : D → ℤ) (dt : ℝ) (line : ℤ → Fin m → ℝ) : Fin m → ℝ := by
  classical
  exact if h : (methods d dt).domain (adjacentCellRiemannProblem (laws d) line (cell d)) then
    area d cell • (methods d dt).numericalFlux ((methods d dt).extract
      ((methods d dt).solve (adjacentCellRiemannProblem (laws d) line (cell d)) h))
  else fallback d cell dt line

theorem normalFaceFlux_of_admitted (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) :
    CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt state cell =
      area d cell • selectedFaceFlux methods d dt state cell h := by
  unfold FaceAdmitted at h
  simp only [CoordinateLineBalance.normalFaceFlux, guardedRule, dif_pos h, selectedFaceFlux]

theorem admitted_face_observation (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) :
    let problem := adjacentCellRiemannProblem (laws d)
      (fun j => state (Function.update cell d j)) (cell d)
    let result := (methods d dt).solve problem h
    problem.leftState = state (Function.update cell d (cell d - 1)) ∧
      problem.rightState = state cell ∧
      CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt state cell =
        area d cell • (methods d dt).numericalFlux ((methods d dt).extract result) := by
  refine ⟨rfl, ?_, normalFaceFlux_of_admitted methods area fallback d dt state cell h⟩
  simp [adjacentCellRiemannProblem]

theorem normalFaceFlux_fallback_independent (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) :
    CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt state cell =
      CoordinateLineBalance.normalFaceFlux (guardedRule methods area other) d dt state cell := by
  rw [normalFaceFlux_of_admitted methods area fallback d dt state cell h,
    normalFaceFlux_of_admitted methods area other d dt state cell h]

theorem advance_fallback_independent (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) :
    CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state =
      CoordinateLineBalance.advance volume (guardedRule methods area other) d dt state := by
  funext cell
  unfold CoordinateLineBalance.advance CoordinateLineBalance.netOutwardFlux
  rw [normalFaceFlux_fallback_independent methods area fallback other d dt state _ (h _),
    normalFaceFlux_fallback_independent methods area fallback other d dt state cell (h cell)]

theorem admitted_cell_mass_balance (volume : (D → ℤ) → ℝ) (hvolume : ∀ cell, 0 < volume cell)
    (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (cell : D → ℤ) :
    volume cell • CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state cell =
      volume cell • state cell - dt •
        (area d (Function.update cell d (cell d + 1)) •
            selectedFaceFlux methods d dt state (Function.update cell d (cell d + 1)) (h _) -
          area d cell • selectedFaceFlux methods d dt state cell (h cell)) := by
  rw [CoordinateLineBalance.advance_mass_balance volume hvolume, CoordinateLineBalance.netOutwardFlux,
    normalFaceFlux_of_admitted methods area fallback d dt state _ (h _),
    normalFaceFlux_of_admitted methods area fallback d dt state cell (h cell)]

theorem admitted_finite_line_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : D → ℤ) (start : ℤ) (count : ℕ) :
    (∑ k ∈ Finset.range count, volume (Function.update base d (start + k)) •
      CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state
        (Function.update base d (start + k))) =
      (∑ k ∈ Finset.range count, volume (Function.update base d (start + k)) •
        state (Function.update base d (start + k))) - dt •
      (area d (Function.update base d (start + count)) •
          selectedFaceFlux methods d dt state (Function.update base d (start + count)) (h _) -
        area d (Function.update base d start) •
          selectedFaceFlux methods d dt state (Function.update base d start) (h _)) := by
  rw [CoordinateLineBalance.finite_line_mass_balance volume hvolume,
    normalFaceFlux_of_admitted methods area fallback d dt state _ (h _),
    normalFaceFlux_of_admitted methods area fallback d dt state _ (h _)]

end NumStability.RiemannInformationCoordinate
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateSweep`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInformationCoordinateSweep.lean`
SHA-256: `4942c7774b6e2a70e2534936fa1d6b0430f45dbafa6d9f9e15fcbc8c0317b00b`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate

/-!
# Admitted successive coordinate-line updates

Every stage is admitted on its actual preceding output. The canonical ordered
sweep is unchanged, and all operational results are independent of the arbitrary
off-domain extension. Initial admission does not imply later admission.
-/

namespace NumStability.RiemannInformationCoordinate

variable {D : Type*} [DecidableEq D] {m : ℕ}
variable {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
variable {Information : D → Type*}
variable (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))


def SweepAdmitted (volume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ) :
    List (D × ℝ) → ((D → ℤ) → Fin m → ℝ) → Prop
  | [], _ => True
  | (d, dt) :: stages, state => StageAdmitted methods d dt state ∧
      SweepAdmitted volume area fallback stages
        (CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state)

theorem sweepAdmitted_fallback_independent (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback stages state) :
    SweepAdmitted methods volume area other stages state := by
  induction stages generalizing state with
  | nil => trivial
  | cons step stages ih =>
    rcases step with ⟨d, dt⟩
    refine ⟨h.1, ?_⟩
    rw [← advance_fallback_independent methods volume area fallback other d dt state h.1]
    exact ih _ h.2

theorem sweep_fallback_independent (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback stages state) :
    CoordinateLineBalance.sweep volume (guardedRule methods area fallback) stages state =
      CoordinateLineBalance.sweep volume (guardedRule methods area other) stages state := by
  induction stages generalizing state with
  | nil => rfl
  | cons step stages ih =>
    rcases step with ⟨d, dt⟩
    rw [CoordinateLineBalance.sweep_cons, CoordinateLineBalance.sweep_cons,
      ← advance_fallback_independent methods volume area fallback other d dt state h.1]
    exact ih _ h.2

theorem admission_at_prefix (volume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (before : List (D × ℝ)) (d : D) (dt : ℝ) (after : List (D × ℝ))
    (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback (before ++ (d, dt) :: after) state) :
    StageAdmitted methods d dt
      (CoordinateLineBalance.sweep volume (guardedRule methods area fallback) before state) := by
  induction before generalizing state with
  | nil => exact h.1
  | cons step before ih =>
    rcases step with ⟨e, ds⟩
    rw [CoordinateLineBalance.sweep_cons]
    exact ih _ h.2

theorem executed_face_uses_selected_solve (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (before : List (D × ℝ)) (d : D) (dt : ℝ) (after : List (D × ℝ))
    (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback (before ++ (d, dt) :: after) state)
    (cell : D → ℤ) :
    let current := CoordinateLineBalance.sweep volume (guardedRule methods area fallback) before state
    ∃ admitted : FaceAdmitted methods d dt current cell,
      CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt current cell =
        area d cell • selectedFaceFlux methods d dt current cell admitted := by
  exact ⟨admission_at_prefix methods volume area fallback before d dt after state h cell,
    normalFaceFlux_of_admitted methods area fallback d dt _ cell _⟩

theorem admitted_two_stage_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d e : D) (dt ds : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback [(d, dt), (e, ds)] state) (cell : D → ℤ) :
    let first := CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state
    volume cell • CoordinateLineBalance.sweep volume (guardedRule methods area fallback)
        [(d, dt), (e, ds)] state cell = volume cell • state cell -
      dt • (area d (Function.update cell d (cell d + 1)) • selectedFaceFlux methods d dt state
          (Function.update cell d (cell d + 1)) (h.1 _) -
        area d cell • selectedFaceFlux methods d dt state cell (h.1 cell)) -
      ds • (area e (Function.update cell e (cell e + 1)) • selectedFaceFlux methods e ds first
          (Function.update cell e (cell e + 1)) (h.2.1 _) -
        area e cell • selectedFaceFlux methods e ds first cell (h.2.1 cell)) := by
  rw [CoordinateLineBalance.sweep_two]
  rw [admitted_cell_mass_balance methods volume hvolume area fallback e ds _ h.2.1,
    admitted_cell_mass_balance methods volume hvolume area fallback d dt state h.1]

end NumStability.RiemannInformationCoordinate
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CartesianGridGeometry.lean`
SHA-256: `fea0491e098c6aae71eb0ab4055094c5530241e311e5d70ac5d13504530d9b72`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/-!
# Measured Cartesian finite-volume geometry

The data are an axis family of existing one-dimensional grids. Cell volume is
the product of widths; face area is the measure in transverse coordinates.
No nominal tensor-grid wrapper, logical chart, or PDE solver is introduced.
-/

namespace NumStability.CartesianGrid

open MeasureTheory
open scoped BigOperators

variable {D : Type*} [Fintype D] [DecidableEq D]

def cellBox (axes : D → OneDimensionalFiniteVolumeGrid) (cell : (D → ℤ)) : Set (D → ℝ) :=
  Set.pi Set.univ (fun d => Set.Ico ((axes d).cellLeft (cell d))
    ((axes d).cellRight (cell d)))

def cellVolume (axes : D → OneDimensionalFiniteVolumeGrid) (cell : (D → ℤ)) : ℝ :=
  ∏ d, (axes d).cellVolume (cell d)

def faceArea (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) : ℝ :=
  ∏ e ∈ Finset.univ.erase d, (axes e).cellVolume (cell e)

omit [DecidableEq D] in
theorem cellVolume_pos (axes : D → OneDimensionalFiniteVolumeGrid) (cell : (D → ℤ)) :
    0 < CartesianGrid.cellVolume axes cell :=
  Finset.prod_pos (fun d _ => (axes d).cellVolume_pos (cell d))

theorem cellVolume_eq_width_mul_area (axes : D → OneDimensionalFiniteVolumeGrid) (d : D)
    (cell : (D → ℤ)) :
    CartesianGrid.cellVolume axes cell = (axes d).cellVolume (cell d) * CartesianGrid.faceArea axes d cell := by
  exact (Finset.mul_prod_erase _ _ (Finset.mem_univ d)).symm

omit [DecidableEq D] in
theorem cellBox_volume (axes : D → OneDimensionalFiniteVolumeGrid) (cell : (D → ℤ)) :
    (volume (CartesianGrid.cellBox axes cell)).toReal = CartesianGrid.cellVolume axes cell := by
  exact Real.volume_pi_Ico_toReal (fun d => (axes d).cell_nonempty (cell d) |>.le)

theorem faceArea_update (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) (j : ℤ) :
    CartesianGrid.faceArea axes d (Function.update cell d j) = CartesianGrid.faceArea axes d cell := by
  unfold CartesianGrid.faceArea
  apply Finset.prod_congr rfl
  intro e he
  rw [Function.update_of_ne (Finset.mem_erase.mp he).1]

def tangentialFaceBox (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) :
    Set ({e : D // e ≠ d} → ℝ) :=
  Set.pi Set.univ (fun e => Set.Ico ((axes e.1).cellLeft (cell e.1))
    ((axes e.1).cellRight (cell e.1)))

theorem tangentialFaceBox_volume (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) :
    (volume (tangentialFaceBox axes d cell)).toReal = CartesianGrid.faceArea axes d cell := by
  rw [tangentialFaceBox, Real.volume_pi_Ico_toReal
    (fun e : {e : D // e ≠ d} => (axes e.1).cell_nonempty (cell e.1) |>.le)]
  exact (Finset.prod_subtype (Finset.univ.erase d) (by simp)
    (fun e => (axes e).cellVolume (cell e))).symm

omit [Fintype D] in
theorem tangentialFaceBox_update (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) (j : ℤ) :
    tangentialFaceBox axes d (Function.update cell d j) = tangentialFaceBox axes d cell := by
  unfold tangentialFaceBox
  congr 1
  funext e
  rw [Function.update_of_ne e.property]

def facePoint (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ))
    (point : {e : D // e ≠ d} → ℝ) : D → ℝ :=
  fun e => if h : e = d then (axes d).cellLeft (cell d) else point ⟨e, h⟩

omit [Fintype D] in
theorem facePoint_normal (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ))
    (point : {e : D // e ≠ d} → ℝ) :
    facePoint axes d cell point d = (axes d).cellLeft (cell d) := by
  simp [facePoint]

omit [Fintype D] in
theorem facePoint_transverse (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ))
    (point : {e : D // e ≠ d} → ℝ) (e : D) (h : e ≠ d) :
    facePoint axes d cell point e = point ⟨e, h⟩ := by
  simp [facePoint, h]

omit [Fintype D] in
theorem shared_face_position (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) :
    (axes d).cellRight (cell d) =
      (axes d).cellLeft ((Function.update cell d (cell d + 1)) d) := by
  simpa using (axes d).adjacent (cell d + 1)

end NumStability.CartesianGrid
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CartesianCoordinateUpdate.lean`
SHA-256: `f46fa394ba8fb76c6d50894fc31ea304ed9ffc2bb9daa2488ffedfb1e30d56d3`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate

/-!
# Cartesian consumers of full-line numerical flux rules

Area weighting gives the actual one-dimensional finite-volume line restriction
for an arbitrary full-line flux rule. Admitted information routines specialize
that correspondence. Consistency or accuracy is not inferred for arbitrary rules.
The local line notation expands to a lambda and introduces no public alias.
-/

namespace NumStability.CartesianCoordinateUpdate

variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
variable {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
variable {Information : D → Type*}
variable (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))

open MeasureTheory RiemannInformationCoordinate

local notation "line" => (fun (d : D) (base : D → ℤ)
  (state : (D → ℤ) → Fin m → ℝ) (j : ℤ) => state (Function.update base d j))


def areaWeightedRule (axes : D → OneDimensionalFiniteVolumeGrid)
    (rule : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (cell : (D → ℤ)) (dt : ℝ) (old : ℤ → Fin m → ℝ) : Fin m → ℝ :=
  (CartesianGrid.faceArea axes) d cell • rule d cell dt old

theorem cartesian_full_line_update (axes : D → OneDimensionalFiniteVolumeGrid)
    (rule : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (base : (D → ℤ)) :
    line d base (CoordinateLineBalance.advance (CartesianGrid.cellVolume axes)
      (areaWeightedRule axes rule) d dt state) =
      riemannFiniteVolumeUpdate (axes d) dt (line d base state)
        (fun j => rule d (Function.update base d j) dt (line d base state)) := by
  funext j
  let flux := fun k => rule d (Function.update base d k) dt (line d base state)
  have hline : (axes d).cellVolume j •
      riemannFiniteVolumeUpdate (axes d) dt (line d base state) flux j =
      (axes d).cellVolume j • line d base state j - dt • (flux (j + 1) - flux j) :=
    cellVolume_smul_finiteVolumeCellAverageUpdate dt ((axes d).cellVolume j)
      (line d base state j) (flux (j + 1) - flux j) ((axes d).cellVolume_pos j).ne'
  have harea := congrArg (fun value => (CartesianGrid.faceArea axes) d base • value) hline
  have hreference : (CartesianGrid.cellVolume axes) (Function.update base d j) •
      riemannFiniteVolumeUpdate (axes d) dt (line d base state) flux j =
      (CartesianGrid.cellVolume axes) (Function.update base d j) • state (Function.update base d j) -
        dt • ((CartesianGrid.faceArea axes) d base • flux (j + 1) - (CartesianGrid.faceArea axes) d base • flux j) := by
    rw [(CartesianGrid.cellVolume_eq_width_mul_area axes) d (Function.update base d j)]
    simp only [Function.update_self, CartesianGrid.faceArea_update]
    simpa only [smul_sub, smul_smul, mul_comm] using harea
  have hactual := CoordinateLineBalance.advance_mass_balance (CartesianGrid.cellVolume axes) (CartesianGrid.cellVolume_pos axes)
    (areaWeightedRule axes rule) d dt state (Function.update base d j)
  simp only [CoordinateLineBalance.netOutwardFlux, CoordinateLineBalance.normalFaceFlux,
    areaWeightedRule, Function.update_self, Function.update_idem,
    CartesianGrid.faceArea_update] at hactual
  have hmass : (CartesianGrid.cellVolume axes) (Function.update base d j) •
      line d base (CoordinateLineBalance.advance (CartesianGrid.cellVolume axes)
        (areaWeightedRule axes rule) d dt state) j =
      (CartesianGrid.cellVolume axes) (Function.update base d j) •
        riemannFiniteVolumeUpdate (axes d) dt (line d base state) flux j := by
    simpa only [flux] using hactual.trans hreference.symm
  have hc := congrArg (fun value => ((CartesianGrid.cellVolume axes) (Function.update base d j))⁻¹ • value) hmass
  simpa only [smul_smul, inv_mul_cancel₀ ((CartesianGrid.cellVolume_pos axes) _).ne', one_smul] using hc

omit [Fintype D] in
theorem line_admission (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : (D → ℤ)) (j : ℤ) :
    (methods d dt).domain (adjacentCellRiemannProblem (laws d) (line d base state) j) := by
  simpa only [FaceAdmitted, Function.update_self, Function.update_idem] using
    h (Function.update base d j)

omit [Fintype D] in
theorem selectedFaceFlux_on_line (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : (D → ℤ)) (j : ℤ) :
    selectedFaceFlux methods d dt state (Function.update base d j) (h _) =
      (methods d dt).interfaceFlux (line d base state)
        (line_admission methods d dt state h base) j := by
  have hcongr (p q : HyperbolicRiemannProblem (laws d))
      (hp : (methods d dt).domain p) (hq : (methods d dt).domain q) (heq : p = q) :
      (methods d dt).numericalFlux ((methods d dt).extract ((methods d dt).solve p hp)) =
        (methods d dt).numericalFlux ((methods d dt).extract ((methods d dt).solve q hq)) := by
    cases heq
    rfl
  unfold selectedFaceFlux RiemannInformationFluxMethod.interfaceFlux
  apply hcongr
  simp only [Function.update_self, Function.update_idem]

theorem guardedRule_eq_areaWeightedRule (axes : D → OneDimensionalFiniteVolumeGrid)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ) :
    guardedRule methods (CartesianGrid.faceArea axes) fallback =
      areaWeightedRule axes (guardedRule methods (fun _ _ => 1)
        (fun d cell dt old => ((CartesianGrid.faceArea axes) d cell)⁻¹ • fallback d cell dt old)) := by
  classical
  funext d cell dt old
  have harea : (CartesianGrid.faceArea axes) d cell ≠ 0 := by
    exact ne_of_gt (Finset.prod_pos (fun e _ => (axes e).cellVolume_pos (cell e)))
  unfold areaWeightedRule guardedRule
  split <;> simp_all [smul_smul]

theorem cartesian_line_update (axes : D → OneDimensionalFiniteVolumeGrid)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : (D → ℤ)) :
    line d base (CoordinateLineBalance.advance (CartesianGrid.cellVolume axes)
        (guardedRule methods (CartesianGrid.faceArea axes) fallback) d dt state) =
      riemannFiniteVolumeUpdate (axes d) dt (line d base state)
        ((methods d dt).interfaceFlux (line d base state) (line_admission methods d dt state h base)) := by
  rw [guardedRule_eq_areaWeightedRule, cartesian_full_line_update]
  apply congrArg (riemannFiniteVolumeUpdate (axes d) dt (line d base state))
  funext j
  have hguard := line_admission methods d dt state h base ((Function.update base d j) d)
  unfold guardedRule
  rw [dif_pos hguard, one_smul]
  change (methods d dt).interfaceFlux (line d base state)
      (line_admission methods d dt state h base) ((Function.update base d j) d) = _
  rw [Function.update_self]

theorem cartesian_measured_balance (axes : D → OneDimensionalFiniteVolumeGrid)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (cell : (D → ℤ)) :
    (volume ((CartesianGrid.cellBox axes) cell)).toReal • CoordinateLineBalance.advance (CartesianGrid.cellVolume axes)
      (guardedRule methods (CartesianGrid.faceArea axes) fallback) d dt state cell =
      (volume ((CartesianGrid.cellBox axes) cell)).toReal • state cell - dt •
        ((volume ((CartesianGrid.tangentialFaceBox axes) d
            (Function.update cell d (cell d + 1)))).toReal •
          selectedFaceFlux methods d dt state (Function.update cell d (cell d + 1)) (h _) -
        (volume ((CartesianGrid.tangentialFaceBox axes) d cell)).toReal •
          selectedFaceFlux methods d dt state cell (h cell)) := by
  rw [(CartesianGrid.cellBox_volume axes), CartesianGrid.tangentialFaceBox_volume,
    CartesianGrid.tangentialFaceBox_volume]
  exact admitted_cell_mass_balance methods (CartesianGrid.cellVolume axes) (CartesianGrid.cellVolume_pos axes)
    (CartesianGrid.faceArea axes) fallback d dt state h cell

end NumStability.CartesianCoordinateUpdate
```
