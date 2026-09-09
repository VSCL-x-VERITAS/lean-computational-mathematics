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
