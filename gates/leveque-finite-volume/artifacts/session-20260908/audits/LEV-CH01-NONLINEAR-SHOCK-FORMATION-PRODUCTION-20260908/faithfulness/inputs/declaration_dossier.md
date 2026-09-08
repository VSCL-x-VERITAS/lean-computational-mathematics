# Declaration dossier for LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908

This dossier describes the theorem statement only. Its proof is excluded.
Interpret every dependency from its supplied declaration; names are not definitions.

## Proof-free source declaration

```lean
theorem leveque01_nonlinear_shock_formation :
    ∃ (flux : ℝ → ℝ) (q : ℝ → ℝ → ℝ) (T ξ qL qR : ℝ),
      ContDiff ℝ 1 flux ∧
      (¬ ∃ a b : ℝ, ∀ u, flux u = a * u + b) ∧
      IsRectangleConservationLawSolution q flux ∧
      ContDiff ℝ ⊤ (fun x => q x 0) ∧
      0 < T ∧
      (∀ t, 0 ≤ t → t < T → Continuous (fun x => q x t)) ∧
      Tendsto (fun x => q x T) (𝓝[<] ξ) (𝓝 qL) ∧
      Tendsto (fun x => q x T) (𝓝[>] ξ) (𝓝 qR) ∧ qR < qL
```

## Elaborated target type

```lean
Exists fun flux =>
  Exists fun q =>
    Exists fun T =>
      Exists fun ξ =>
        Exists fun qL =>
          Exists fun qR =>
            And (ContDiff Real 1 flux)
              (And
                (Not (Exists fun a => Exists fun b => ∀ (u : Real), Eq (flux u) (instHAdd.hAdd (instHMul.hMul a u) b)))
                (And (NumStability.IsRectangleConservationLawSolution q flux)
                  (And (ContDiff Real WithTop.top.top fun x => q x 0)
                    (And (Real.instLT.lt 0 T)
                      (And (∀ (t : Real), Real.instLE.le 0 t → Real.instLT.lt t T → Continuous fun x => q x t)
                        (And (Filter.Tendsto (fun x => q x T) (nhdsWithin ξ (Set.Iio ξ)) (nhds qL))
                          (And (Filter.Tendsto (fun x => q x T) (nhdsWithin ξ (Set.Ioi ξ)) (nhds qR))
                            (Real.instLT.lt qR qL))))))))
```

## Fully explicit elaborated target type

```lean
@Exists.{1} (Real → Real) fun (flux : Real → Real) =>
  @Exists.{1} (Real → Real → Real) fun (q : Real → Real → Real) =>
    @Exists.{1} Real fun (T : Real) =>
      @Exists.{1} Real fun (ξ : Real) =>
        @Exists.{1} Real fun (qL : Real) =>
          @Exists.{1} Real fun (qR : Real) =>
            And
              (@ContDiff.{0, 0, 0} Real (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField)
                Real Real.normedAddCommGroup
                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                Real Real.normedAddCommGroup
                (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                  (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                  (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                (@OfNat.ofNat.{0} (WithTop.{0} ENat) (nat_lit 1)
                  (@One.toOfNat1.{0} (WithTop.{0} ENat)
                    (@WithTop.one.{0} ENat
                      (@AddMonoidWithOne.toOne.{0} ENat
                        (@AddCommMonoidWithOne.toAddMonoidWithOne.{0} ENat
                          (@NonAssocSemiring.toAddCommMonoidWithOne.{0} ENat
                            (@Semiring.toNonAssocSemiring.{0} ENat
                              (@CommSemiring.toSemiring.{0} ENat instCommSemiringENat))))))))
                flux)
              (And
                (Not
                  (@Exists.{1} Real fun (a : Real) =>
                    @Exists.{1} Real fun (b : Real) =>
                      ∀ (u : Real),
                        @Eq.{1} Real (flux u)
                          (@HAdd.hAdd.{0, 0, 0} Real Real Real (@instHAdd.{0} Real Real.instAdd)
                            (@HMul.hMul.{0, 0, 0} Real Real Real (@instHMul.{0} Real Real.instMul) a u) b)))
                (And
                  (@NumStability.IsRectangleConservationLawSolution.{0} Real Real.normedAddCommGroup
                    (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                      (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                      (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                    q flux)
                  (And
                    (@ContDiff.{0, 0, 0} Real
                      (@DenselyNormedField.toNontriviallyNormedField.{0} Real Real.denselyNormedField) Real
                      Real.normedAddCommGroup
                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                      Real Real.normedAddCommGroup
                      (@InnerProductSpace.toNormedSpace.{0, 0} Real Real Real.instRCLike
                        (@NormedAddCommGroup.toSeminormedAddCommGroup.{0} Real Real.normedAddCommGroup)
                        (@RCLike.toInnerProductSpaceReal.{0} Real Real.instRCLike))
                      (@Top.top.{0} (WithTop.{0} ENat) (@WithTop.top.{0} ENat)) fun (x : Real) =>
                      q x (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)))
                    (And
                      (@LT.lt.{0} Real Real.instLT
                        (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) T)
                      (And
                        (∀ (t : Real),
                          @LE.le.{0} Real Real.instLE
                              (@OfNat.ofNat.{0} Real (nat_lit 0) (@Zero.toOfNat0.{0} Real Real.instZero)) t →
                            @LT.lt.{0} Real Real.instLT t T →
                              @Continuous.{0, 0} Real Real
                                (@UniformSpace.toTopologicalSpace.{0} Real
                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                (@UniformSpace.toTopologicalSpace.{0} Real
                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                fun (x : Real) => q x t)
                        (And
                          (@Filter.Tendsto.{0, 0} Real Real (fun (x : Real) => q x T)
                            (@nhdsWithin.{0} Real
                              (@UniformSpace.toTopologicalSpace.{0} Real
                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              ξ (@Set.Iio.{0} Real Real.instPreorder ξ))
                            (@nhds.{0} Real
                              (@UniformSpace.toTopologicalSpace.{0} Real
                                (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                              qL))
                          (And
                            (@Filter.Tendsto.{0, 0} Real Real (fun (x : Real) => q x T)
                              (@nhdsWithin.{0} Real
                                (@UniformSpace.toTopologicalSpace.{0} Real
                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                ξ (@Set.Ioi.{0} Real Real.instPreorder ξ))
                              (@nhds.{0} Real
                                (@UniformSpace.toTopologicalSpace.{0} Real
                                  (@PseudoMetricSpace.toUniformSpace.{0} Real Real.pseudoMetricSpace))
                                qR))
                            (@LT.lt.{0} Real Real.instLT qR qL))))))))
```

## Local import graph

- `AuditTarget` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Conservation`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Jump`
- `ComputationalMathematics.Analysis.SpecialFunctions.Huber` imports: `Mathlib.Analysis.Convex.Deriv`, `Mathlib.Analysis.SpecialFunctions.Integrals.Basic`, `Mathlib.Analysis.Calculus.ContDiff.Deriv`, `Mathlib.Tactic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Basic` imports: `ComputationalMathematics.Analysis.SpecialFunctions.Huber`
- `ComputationalMathematics.Analysis.Calculus.Piecewise` imports: `Mathlib.Analysis.Calculus.Deriv.Basic`, `Mathlib.Topology.Order.OrderClosed`, `Mathlib.Tactic`
- `ComputationalMathematics.Analysis.Calculus.Deriv.Abs` imports: `Mathlib.Analysis.Calculus.Deriv.Abs`, `Mathlib.Tactic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Potential` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Basic`, `ComputationalMathematics.Analysis.Calculus.Piecewise`, `ComputationalMathematics.Analysis.Calculus.Deriv.Abs`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Regularity` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Potential`
- `ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.Piecewise` imports: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection` imports: `Mathlib.Analysis.Calculus.Deriv.Add`, `Mathlib.Analysis.Calculus.Deriv.Comp`, `Mathlib.Analysis.Calculus.Deriv.Mul`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`, `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Conservation` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Regularity`, `ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.Piecewise`, `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`
- `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Jump` imports: `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Basic`, `Mathlib.Analysis.Convex.Jensen`

## Semantic dependency inventory

`local` declarations are followed recursively through types and bodies. `external-frontier` declarations mark the one-level library trust boundary.

### D001: `NumStability.IsRectangleConservationLawSolution`

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

### D002: `AddCommMonoidWithOne.toAddMonoidWithOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D003: `AddMonoidWithOne.toOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Nat.Cast.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
- Semantic SHA-256: `2ee638fd7292dbcf1e4adb85b14bbd0f304e8a260316e61621bf8eac03f03f6d`

Type:

```lean
{R : Type u_2} → [self : AddMonoidWithOne R] → One R
```

Fully explicit type:

```lean
{R : Type u_2} → [self : AddMonoidWithOne.{u_2} R] → One.{u_2} R
```

Definition body (one-level semantic boundary):

```lean
fun R [self : AddMonoidWithOne R] => self.3
```

### D004: `And`

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

### D005: `CommSemiring.toSemiring`

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

### D006: `ContDiff`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Calculus.ContDiff.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `30cffd46a638eef4d39e5204e6d6f12fc0204b761530f67df9e3e646eb03218a`

Type:

```lean
(𝕜 : Type u) →
  [inst : NontriviallyNormedField 𝕜] →
    {E : Type uE} →
      [inst_1 : NormedAddCommGroup E] →
        [NormedSpace 𝕜 E] →
          {F : Type uF} → [inst_3 : NormedAddCommGroup F] → [NormedSpace 𝕜 F] → WithTop ENat → (E → F) → Prop
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
                (n : WithTop.{0} ENat) → (f : E → F) → Prop
```

Definition body (one-level semantic boundary):

```lean
fun 𝕜 [NontriviallyNormedField 𝕜] {E} [NormedAddCommGroup E] [NormedSpace 𝕜 E] {F} [NormedAddCommGroup F]
    [NormedSpace 𝕜 F] n f =>
  ContDiffWithinAt.match_1 (fun n => Prop) n
    (fun _ =>
      Exists fun p =>
        And (HasFTaylorSeriesUpTo WithTop.top.top f p) (∀ (i : Nat), AnalyticOnNhd 𝕜 (fun x => p x i) Set.univ))
    fun n => Exists fun p => HasFTaylorSeriesUpTo (WithTop.some n) f p
```

### D007: `Continuous`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Basic`
- Declaration kind: `inductive`
- Distance from target type: `1`
- Semantic SHA-256: `41e87101d1e3ab731e44670f7054a7766128457a09c3102d86948d5fe60c8a01`

Type:

```lean
{X : Type u} → {Y : Type v} → [TopologicalSpace X] → [TopologicalSpace Y] → (X → Y) → Prop
```

Fully explicit type:

```lean
{X : Type u} → {Y : Type v} → [TopologicalSpace.{u} X] → [TopologicalSpace.{v} Y] → (f : X → Y) → Prop
```

### D008: `DenselyNormedField.toNontriviallyNormedField`

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

### D009: `ENat`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENat.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D010: `Eq`

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

### D011: `Exists`

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

### D012: `Filter.Tendsto`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Filter.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D013: `HAdd.hAdd`

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

### D015: `InnerProductSpace.toNormedSpace`

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

### D016: `LE.le`

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

### D017: `LT.lt`

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

### D018: `NonAssocSemiring.toAddCommMonoidWithOne`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D019: `NormedAddCommGroup.toSeminormedAddCommGroup`

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

### D020: `Not`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D021: `OfNat.ofNat`

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

### D022: `One.toOfNat1`

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

### D023: `PseudoMetricSpace.toUniformSpace`

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

### D024: `RCLike.toInnerProductSpaceReal`

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

### D025: `Real`

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

### D026: `Real.denselyNormedField`

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

### D027: `Real.instAdd`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D028: `Real.instLE`

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

### D029: `Real.instLT`

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

### D030: `Real.instMul`

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

### D031: `Real.instPreorder`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.Real.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D032: `Real.instRCLike`

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

### D033: `Real.instZero`

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

### D034: `Real.normedAddCommGroup`

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

### D035: `Real.pseudoMetricSpace`

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

### D036: `Semiring.toNonAssocSemiring`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Ring.Defs`
- Declaration kind: `abbrev`
- Distance from target type: `1`
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

### D037: `Set.Iio`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `7d2fb1f1a25e32137e405a3246c71735490bca2e04477240797df205bd739c7e`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Preorder.{u_1} α] → (b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] b => setOf fun x => inst.lt x b
```

### D038: `Set.Ioi`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.Interval.Set.Defs`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ad556a749b4ff2a341c66bd35e0369f79888567fa7730aab8ee2fdd700fbfd52`

Type:

```lean
{α : Type u_1} → [Preorder α] → α → Set α
```

Fully explicit type:

```lean
{α : Type u_1} → [Preorder.{u_1} α] → (b : α) → Set.{u_1} α
```

Definition body (one-level semantic boundary):

```lean
fun {α} [inst : Preorder α] b => setOf fun x => inst.lt b x
```

### D039: `Top.top`

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

### D040: `UniformSpace.toTopologicalSpace`

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

### D041: `WithTop`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.TypeTags`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D042: `WithTop.one`

- Role: `external-frontier`
- Owner module: `Mathlib.Algebra.Order.Monoid.Unbundled.WithTop`
- Declaration kind: `def`
- Distance from target type: `1`
- Semantic SHA-256: `ae5eb67fceb86820fa68e00e19324ed424232ea111356e7cb073439d2a8799fc`

Type:

```lean
{α : Type u} → [One α] → One (WithTop α)
```

Fully explicit type:

```lean
{α : Type u} → [One.{u} α] → One.{u} (WithTop.{u} α)
```

Definition body (one-level semantic boundary):

```lean
fun {α} [One α] => { one := WithTop.some 1 }
```

### D043: `WithTop.top`

- Role: `external-frontier`
- Owner module: `Mathlib.Order.TypeTags`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D044: `Zero.toOfNat0`

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

### D045: `instCommSemiringENat`

- Role: `external-frontier`
- Owner module: `Mathlib.Data.ENat.Basic`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D046: `instHAdd`

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

### D047: `instHMul`

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

### D048: `nhds`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D049: `nhdsWithin`

- Role: `external-frontier`
- Owner module: `Mathlib.Topology.Defs.Filter`
- Declaration kind: `def`
- Distance from target type: `1`
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

### D050: `AddGroup.toSubNegMonoid`

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

### D051: `HSub.hSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D052: `IntervalIntegrable`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D053: `MeasureTheory.MeasureSpace.volume`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.MeasureSpaceDef`
- Declaration kind: `abbrev`
- Distance from target type: `2`
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

### D054: `NormedAddCommGroup`

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

### D055: `NormedAddCommGroup.toNormedAddGroup`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Defs`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D056: `NormedAddGroup.toAddGroup`

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

### D057: `NormedAddGroup.toENormedAddMonoid`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Group.Continuity`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D058: `NormedSpace`

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

### D059: `Real.measureSpace`

- Role: `external-frontier`
- Owner module: `Mathlib.MeasureTheory.Measure.Haar.OfBasis`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D060: `Real.normedField`

- Role: `external-frontier`
- Owner module: `Mathlib.Analysis.Normed.Field.Basic`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D061: `SeminormedAddCommGroup.toPseudoMetricSpace`

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

### D062: `SubNegMonoid.toSub`

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

### D063: `instHSub`

- Role: `external-frontier`
- Owner module: `Init.Prelude`
- Declaration kind: `def`
- Distance from target type: `2`
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

### D064: `intervalIntegral`

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

## Complete local imported sources

### `ComputationalMathematics.Analysis.SpecialFunctions.Huber`

Path: `ComputationalMathematics/Analysis/SpecialFunctions/Huber.lean`
SHA-256: `920b0018fa25a6a703c175b1fd68c1c4a8e1d3107eb833b04eb7c589789b0801`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Convex.Deriv
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.Calculus.ContDiff.Deriv
import Mathlib.Tactic

/-!
# The normalized Huber function and its derivative

The primitive of the clipped identity is convex and C1, with a quadratic core
and affine outer branches. Both clipping points have the asserted derivative.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

noncomputable section

/-- The clipped characteristic speed. -/
def huberSlope (q : ℝ) : ℝ := min 1 (max (-1) q)

/-- Defining the flux as the primitive of the continuous slope gives its C1 regularity
without assuming a derivative at either clipping point. Explicit formulas are proved below. -/
def huberFlux (q : ℝ) : ℝ := ∫ z in (0 : ℝ)..q, huberSlope z

theorem huberSlope_continuous : Continuous huberSlope :=
  continuous_const.min (continuous_const.max continuous_id)

theorem huberSlope_of_abs_le {q : ℝ} (hq : |q| ≤ 1) : huberSlope q = q := by
  rw [huberSlope, max_eq_right (abs_le.mp hq).1, min_eq_right (abs_le.mp hq).2]

theorem huberSlope_of_ge {q : ℝ} (hq : 1 ≤ q) : huberSlope q = 1 := by
  simp only [huberSlope, min_eq_left (le_trans hq (le_max_right _ _))]

theorem huberSlope_of_le {q : ℝ} (hq : q ≤ -1) : huberSlope q = -1 := by
  simp only [huberSlope, max_eq_left hq]
  norm_num

theorem hasDerivAt_huberFlux (q : ℝ) : HasDerivAt huberFlux (huberSlope q) q :=
  intervalIntegral.integral_hasDerivAt_right
    (huberSlope_continuous.intervalIntegrable _ _)
    huberSlope_continuous.aestronglyMeasurable.stronglyMeasurableAtFilter
    huberSlope_continuous.continuousAt

theorem huberFlux_contDiff_one : ContDiff ℝ 1 huberFlux := by
  rw [contDiff_one_iff_deriv]
  refine ⟨fun q => (hasDerivAt_huberFlux q).differentiableAt, ?_⟩
  have heq : deriv huberFlux = huberSlope := funext fun q => (hasDerivAt_huberFlux q).deriv
  rw [heq]
  exact huberSlope_continuous

theorem huberFlux_of_abs_le {q : ℝ} (hq : |q| ≤ 1) : huberFlux q = q ^ 2 / 2 := by
  have heq : (∫ z in (0 : ℝ)..q, huberSlope z) = ∫ z in (0 : ℝ)..q, z := by
    apply intervalIntegral.integral_congr_ae
    filter_upwards [] with z hz
    apply huberSlope_of_abs_le
    have hb : z ∈ Ioc (min 0 q) (max 0 q) := hz
    have hlo : -1 ≤ min 0 q := le_min (by norm_num) (abs_le.mp hq).1
    have hhi : max 0 q ≤ 1 := max_le (by norm_num) (abs_le.mp hq).2
    exact abs_le.mpr ⟨by linarith [hb.1], by linarith [hb.2]⟩
  simpa only [huberFlux, integral_id, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true,
    zero_pow, sub_zero] using heq

theorem huberFlux_of_ge {q : ℝ} (hq : 1 ≤ q) : huberFlux q = q - 1 / 2 := by
  have heq : (∫ z in (1 : ℝ)..q, huberSlope z) = q - 1 := by
    calc
      _ = ∫ _ in (1 : ℝ)..q, (1 : ℝ) := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [] with z hz
        have hz' : z ∈ Ioc (1 : ℝ) q := by simpa only [uIoc_of_le hq] using hz
        exact huberSlope_of_ge hz'.1.le
      _ = q - 1 := by simp
  have hadd := intervalIntegral.integral_add_adjacent_intervals (μ := volume)
    (huberSlope_continuous.intervalIntegrable 0 1)
    (huberSlope_continuous.intervalIntegrable 1 q)
  have hbase : huberFlux 1 = 1 / 2 := by
    simpa using huberFlux_of_abs_le (q := 1) (by norm_num)
  change huberFlux 1 + (∫ z in (1 : ℝ)..q, huberSlope z) = huberFlux q at hadd
  rw [hbase, heq] at hadd
  linarith

theorem huberFlux_of_le {q : ℝ} (hq : q ≤ -1) : huberFlux q = -q - 1 / 2 := by
  have heq : (∫ z in (-1 : ℝ)..q, huberSlope z) = -(q + 1) := by
    calc
      _ = ∫ _ in (-1 : ℝ)..q, (-1 : ℝ) := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [] with z hz
        have hz' : z ∈ Ioc q (-1 : ℝ) := by simpa only [uIoc_of_ge hq] using hz
        exact huberSlope_of_le hz'.2
      _ = -(q + 1) := by simp
  have hadd := intervalIntegral.integral_add_adjacent_intervals (μ := volume)
    (huberSlope_continuous.intervalIntegrable 0 (-1))
    (huberSlope_continuous.intervalIntegrable (-1) q)
  have hbase : huberFlux (-1) = 1 / 2 := by
    simpa using huberFlux_of_abs_le (q := -1) (by norm_num)
  change huberFlux (-1) + (∫ z in (-1 : ℝ)..q, huberSlope z) = huberFlux q at hadd
  rw [hbase, heq] at hadd
  linarith

theorem huberFlux_formula (q : ℝ) :
    huberFlux q = if |q| ≤ 1 then q ^ 2 / 2 else |q| - 1 / 2 := by
  split_ifs with hq
  · exact huberFlux_of_abs_le hq
  · rcases lt_or_gt_of_ne (show q ≠ 0 by intro h; simp [h] at hq) with hneg | hpos
    · rw [abs_of_neg hneg] at hq ⊢
      exact huberFlux_of_le (by linarith)
    · rw [abs_of_pos hpos] at hq ⊢
      exact huberFlux_of_ge (by linarith)

theorem huberFlux_not_linear : ¬ ∃ c : ℝ, ∀ q, huberFlux q = c * q := by
  rintro ⟨c, hc⟩
  have h₁ := hc 1
  have h₂ := hc 2
  rw [huberFlux_of_ge (by norm_num : (1 : ℝ) ≤ 1)] at h₁
  rw [huberFlux_of_ge (by norm_num : (1 : ℝ) ≤ 2)] at h₂
  norm_num at h₁ h₂
  linarith

theorem huberFlux_convex : ConvexOn ℝ univ huberFlux := by
  apply Monotone.convexOn_univ_of_deriv (fun x => (hasDerivAt_huberFlux x).differentiableAt)
  have hm : Monotone huberSlope := monotone_const.min (monotone_const.max monotone_id)
  simpa only [funext (fun x => (hasDerivAt_huberFlux x).deriv)] using hm

/-- The Huber function is not affine, so its conservation law is nonlinear. -/
theorem huberFlux_not_affine : ¬ ∃ a b : ℝ, ∀ q, huberFlux q = a * q + b := by
  rintro ⟨a, b, h⟩
  have hb : b = 0 := by simpa [huberFlux] using (h 0).symm
  apply huberFlux_not_linear
  exact ⟨a, fun q => by simpa [hb] using h q⟩

end

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Basic`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Examples/HuberShock/Basic.lean`
SHA-256: `e890ac48550136265dce2d84ae9e8e07cceca04bbdf2268739e340389514df16`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.SpecialFunctions.Huber

/-!
# A scalar shock profile for the Huber flux

The central region contracts to the origin at time one. The initial field is
the smooth, unbounded function −x. The right trace is selected at the later shock.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.HuberShock

noncomputable section

/-- The central primitive, with division interpreted in the ambient real field. -/
def centralPotential (x t : ℝ) : ℝ := (-x ^ 2 / 2) / (1 - t)

/-- The outer primitive, also used after the central interval collapses. -/
def outerPotential (x t : ℝ) : ℝ := -x ^ 2 / 2 - t * |x| + t / 2 - t ^ 2 / 2

/-- Right trace is selected at the stationary interface. -/
def outerState (x t : ℝ) : ℝ := if x < 0 then t - x else -t - x

def shockPotential (x t : ℝ) : ℝ :=
  if t < 1 - |x| then centralPotential x t else outerPotential x t

def shockState (x t : ℝ) : ℝ :=
  if t < 1 - |x| then -x / (1 - t) else outerState x t

theorem shockState_initial (x : ℝ) : shockState x 0 = -x := by
  simp only [shockState, outerState]
  split_ifs <;> simp

theorem shockState_initial_smooth : ContDiff ℝ ⊤ (fun x => shockState x 0) := by
  simp only [shockState_initial]
  exact contDiff_id.neg

theorem shockState_after {t : ℝ} (ht : 1 ≤ t) (x : ℝ) :
    shockState x t = outerState x t := by
  simp only [shockState, if_neg (show ¬ t < 1 - |x| by linarith [abs_nonneg x])]

theorem central_flux {x t : ℝ} (h : t < 1 - |x|) :
    huberFlux (-x / (1 - t)) = (-x / (1 - t)) ^ 2 / 2 := by
  apply huberFlux_of_abs_le
  have hr : 0 < 1 - t := by linarith [abs_nonneg x]
  rw [abs_div, abs_neg, abs_of_pos hr]
  exact (div_le_one hr).mpr (by linarith)

theorem outer_flux {x t : ℝ} (h : 1 - |x| ≤ t) :
    huberFlux (outerState x t) = t + |x| - 1 / 2 := by
  by_cases hx : x < 0
  · rw [outerState, if_pos hx, abs_of_neg hx] at *
    rw [huberFlux_of_ge (by linarith : 1 ≤ t - x)]
    ring
  · rw [outerState, if_neg hx, abs_of_nonneg (le_of_not_gt hx)] at *
    rw [huberFlux_of_le (by linarith : -t - x ≤ -1)]
    ring

/-- The primitive values match on the boundary of the central region. -/
theorem potential_match {x t : ℝ} (h : t = 1 - |x|) :
    centralPotential x t = outerPotential x t := by
  by_cases hx : x = 0
  · subst x
    simp only [abs_zero, sub_zero] at h
    subst t
    norm_num [centralPotential, outerPotential]
    rfl
  have ha : 0 < |x| := abs_pos.mpr hx
  have hr : 1 - t ≠ 0 := by linarith
  have hsq : |x| ^ 2 = x ^ 2 := sq_abs x
  dsimp [centralPotential, outerPotential]
  field_simp
  nlinarith [sq_nonneg (|x| - (1 - t))]

theorem central_outer_state_match {x t : ℝ} (ht : t < 1) (h : t = 1 - |x|) :
    -x / (1 - t) = outerState x t := by
  have hr : 1 - t ≠ 0 := by linarith
  by_cases hx : x < 0
  · have hrel : t = 1 + x := by simpa only [abs_of_neg hx, sub_neg_eq_add] using h
    have hc : -x / (1 - t) = 1 := (div_eq_one_iff_eq hr).mpr (by linarith)
    rw [hc, outerState, if_pos hx]
    linarith
  · have hrel : t = 1 - x := by simpa only [abs_of_nonneg (le_of_not_gt hx)] using h
    have hc : -x / (1 - t) = -1 := (div_eq_iff hr).mpr (by linarith)
    rw [hc, outerState, if_neg hx]
    linarith


end

end NumStability.HuberShock
```

### `ComputationalMathematics.Analysis.Calculus.Piecewise`

Path: `ComputationalMathematics/Analysis/Calculus/Piecewise.lean`
SHA-256: `489edbe9c8f4a10c8cceb1d4e440cf1a6b2d43502e0e00f2f95a02949239ce77`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Order.OrderClosed
import Mathlib.Tactic

/-!
# Calculus for real piecewise functions

One-sided derivatives at thresholds and matching derivative germs support
calculus for continuous piecewise formulas.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

noncomputable section

/-- Glue a right derivative at a threshold, choosing the upper branch at the threshold. -/
theorem hasDerivWithinAt_if_lt_right {f g : ℝ → ℝ} {c x df dg : ℝ}
    (hf : x < c → HasDerivWithinAt f df (Ioi x) x)
    (hg : c ≤ x → HasDerivWithinAt g dg (Ioi x) x) :
    HasDerivWithinAt (fun y => if y < c then f y else g y)
      (if x < c then df else dg) (Ioi x) x := by
  by_cases hx : x < c
  · simp only [if_pos hx]
    apply (hf hx).congr_of_eventuallyEq
    · filter_upwards [(eventually_lt_nhds hx).filter_mono inf_le_left] with y hy
      simp only [if_pos hy]
    · simp only [if_pos hx]
  · simp only [if_neg hx]
    apply (hg (le_of_not_gt hx)).congr
    · intro y hy
      have hh : ¬ y < c := by linarith [mem_Ioi.mp hy]
      simp only [if_neg hh]
    · simp only [if_neg hx]

/-- Two differentiable formulas with matching values and derivatives can be glued
over any predicate at the point. -/
theorem hasDerivAt_if_of_eq {f g : ℝ → ℝ} (p : ℝ → Prop) [DecidablePred p]
    {x d : ℝ} (hf : HasDerivAt f d x) (hg : HasDerivAt g d x) (heq : f x = g x) :
    HasDerivAt (fun y => if p y then f y else g y) d x := by
  have h₁ : HasDerivWithinAt (fun y => if p y then f y else g y) d {y | p y} x := by
    apply hf.hasDerivWithinAt.congr
    · intro y hy
      simp only [mem_setOf_eq] at hy
      simp only [if_pos hy]
    · split_ifs <;> simp [heq]
  have h₂ : HasDerivWithinAt (fun y => if p y then f y else g y) d {y | p y}ᶜ x := by
    apply hg.hasDerivWithinAt.congr
    · intro y hy
      simp only [mem_compl_iff, mem_setOf_eq] at hy
      simp only [if_neg hy]
    · split_ifs <;> simp [heq]
  exact hasDerivWithinAt_univ.mp (by simpa only [union_compl_self] using h₁.union h₂)

theorem continuous_if_lt_of_closed {f g : ℝ → ℝ} {c : ℝ}
    (hf : ContinuousOn f (Iic c)) (hg : ContinuousOn g (Ici c)) (heq : f c = g c) :
    Continuous (fun y => if y < c then f y else g y) := by
  have hh : Continuous (fun y => if c ≤ y then g y else f y) :=
    continuous_if_le continuous_const continuous_id hg hf (fun y hy => by simpa [← hy] using heq.symm)
  convert hh using 1
  funext y
  by_cases hy : y < c
  · simp only [if_pos hy, if_neg (not_le.mpr hy)]
  · simp only [if_neg hy, if_pos (le_of_not_gt hy)]


end

end NumStability
```

### `ComputationalMathematics.Analysis.Calculus.Deriv.Abs`

Path: `ComputationalMathematics/Analysis/Calculus/Deriv/Abs.lean`
SHA-256: `c3d9ca9e501be3c2e0611af827342dc72d57379bca100056aab1a05e0f0e7729`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Abs
import Mathlib.Tactic

/-!
# The right derivative of absolute value

The right derivative includes the value +1 at the origin.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

noncomputable section

theorem hasDerivWithinAt_abs_right (x : ℝ) :
    HasDerivWithinAt (abs : ℝ → ℝ) (if x < 0 then -1 else 1) (Ioi x) x := by
  by_cases hx : x < 0
  · simpa only [if_pos hx] using (hasDerivAt_abs_neg hx).hasDerivWithinAt
  by_cases hpos : 0 < x
  · simpa only [if_neg hx] using (hasDerivAt_abs_pos hpos).hasDerivWithinAt
  have hz : x = 0 := by linarith
  subst x
  simp only [lt_self_iff_false, if_false]
  apply (hasDerivAt_id (0 : ℝ)).hasDerivWithinAt.congr
  · intro y hy
    exact abs_of_pos hy
  · exact abs_zero


end

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Potential`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Examples/HuberShock/Potential.lean`
SHA-256: `6fb3173537731e0b35a38d4890713507bed7b29c50afc6fad515db8f68528ed0`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Basic
import ComputationalMathematics.Analysis.Calculus.Piecewise
import ComputationalMathematics.Analysis.Calculus.Deriv.Abs

/-!
# Temporal calculus for the Huber shock potential

The continuous potential has right time derivative equal to minus the actual
composed flux, including collapse and stationary-interface values.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.HuberShock

noncomputable section

theorem centralPotential_space_deriv (x t : ℝ) :
    HasDerivAt (fun y => centralPotential y t) (-x / (1 - t)) x := by
  convert (((hasDerivAt_id x).pow 2).neg.div_const 2).div_const (1 - t) using 1
  norm_num [id_eq]
  ring

theorem centralPotential_time_deriv {x t : ℝ} (ht : t < 1) :
    HasDerivAt (centralPotential x) (-((-x / (1 - t)) ^ 2 / 2)) t := by
  have hr : 1 - t ≠ 0 := by linarith
  convert (hasDerivAt_const t (-x ^ 2 / 2)).div
    ((hasDerivAt_const t (1 : ℝ)).sub (hasDerivAt_id t)) hr using 1
  dsimp
  field_simp
  ring

theorem outerPotential_time_deriv (x t : ℝ) :
    HasDerivAt (outerPotential x) (-|x| + 1 / 2 - t) t := by
  convert ((((hasDerivAt_const t (-x ^ 2 / 2)).sub ((hasDerivAt_id t).mul_const |x|)).add
    ((hasDerivAt_id t).div_const 2)).sub (((hasDerivAt_id t).pow 2).div_const 2)) using 1
  norm_num [id_eq]

theorem outerPotential_space_right_deriv (x t : ℝ) :
    HasDerivWithinAt (fun y => outerPotential y t) (outerState x t) (Ioi x) x := by
  have hh := ((((((hasDerivAt_id x).pow 2).neg.div_const 2).hasDerivWithinAt.sub
    ((hasDerivWithinAt_abs_right x).const_mul t)).add_const (t / 2)).sub_const (t ^ 2 / 2))
  convert hh using 1
  simp only [outerState]
  split_ifs <;> norm_num [id_eq] <;> ring

theorem outerPotential_space_deriv {x : ℝ} (hx : x ≠ 0) (t : ℝ) :
    HasDerivAt (fun y => outerPotential y t) (outerState x t) x := by
  rcases lt_or_gt_of_ne hx with hneg | hpos
  · have hh := ((((((hasDerivAt_id x).pow 2).neg.div_const 2).sub
      ((hasDerivAt_abs_neg hneg).const_mul t)).add_const (t / 2)).sub_const (t ^ 2 / 2))
    convert hh using 1
    norm_num [outerState, hneg, id_eq]
    ring
  · have hh := ((((((hasDerivAt_id x).pow 2).neg.div_const 2).sub
      ((hasDerivAt_abs_pos hpos).const_mul t)).add_const (t / 2)).sub_const (t ^ 2 / 2))
    convert hh using 1
    norm_num [outerState, not_lt.mpr hpos.le, id_eq]
    ring

theorem centralPotential_time_continuousOn (x : ℝ) :
    ContinuousOn (centralPotential x) (Iic (1 - |x|)) := by
  by_cases hx : x = 0
  · subst x
    unfold centralPotential
    simpa [centralPotential] using
      (continuousOn_const : ContinuousOn (fun _ : ℝ => (0 : ℝ)) (Iic (1 - |(0 : ℝ)|)))
  apply ContinuousOn.div continuousOn_const (continuous_const.sub continuous_id).continuousOn
  intro t ht
  have ha : 0 < |x| := abs_pos.mpr hx
  change t ≤ 1 - |x| at ht
  change 1 - t ≠ 0
  linarith

theorem shockPotential_time_continuous (x : ℝ) : Continuous (shockPotential x) := by
  apply continuous_if_lt_of_closed (centralPotential_time_continuousOn x)
  · exact (by unfold outerPotential; fun_prop : Continuous (outerPotential x)).continuousOn
  · exact potential_match rfl

theorem shockPotential_time_right_deriv (x t : ℝ) :
    HasDerivWithinAt (shockPotential x) (-huberFlux (shockState x t)) (Ioi t) t := by
  have hh : HasDerivWithinAt (shockPotential x)
      (if t < 1 - |x| then -((-x / (1 - t)) ^ 2 / 2) else -|x| + 1 / 2 - t) (Ioi t) t := by
    apply hasDerivWithinAt_if_lt_right
    · intro ht
      exact (centralPotential_time_deriv (by linarith [abs_nonneg x])).hasDerivWithinAt
    · intro _
      exact (outerPotential_time_deriv x t).hasDerivWithinAt
  apply hh.congr_deriv
  by_cases ht : t < 1 - |x|
  · simp only [if_pos ht, shockState, central_flux ht]
  · simp only [if_neg ht, shockState, outer_flux (le_of_not_gt ht)]
    ring


end

end NumStability.HuberShock
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Regularity`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Examples/HuberShock/Regularity.lean`
SHA-256: `6984617c2d4bf4c13eb2d2a522afd8be544707b423ee67858972b8a7f2ca9934`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Potential

/-!
# Spatial regularity of the Huber shock

The state is continuous before collapse. The continuous potential has the
state as its right spatial derivative at every point and time.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.HuberShock

noncomputable section

theorem shockPotential_space_continuous (t : ℝ) :
    Continuous (fun x => shockPotential x t) := by
  apply Continuous.if
  · intro x hx
    exact potential_match (frontier_lt_subset_eq continuous_const
      (continuous_const.sub continuous_abs) hx)
  · unfold centralPotential
    fun_prop
  · unfold outerPotential
    fun_prop

theorem outerState_space_continuousAt {x : ℝ} (hx : x ≠ 0) (t : ℝ) :
    ContinuousAt (fun y => outerState y t) x := by
  rcases lt_or_gt_of_ne hx with hneg | hpos
  · have hh : Continuous (fun y : ℝ => t - y) := continuous_const.sub continuous_id
    apply hh.continuousAt.congr_of_eventuallyEq
    filter_upwards [eventually_lt_nhds hneg] with y hy
    simp only [outerState, if_pos hy]
  · have hh : Continuous (fun y : ℝ => -t - y) := continuous_const.sub continuous_id
    apply hh.continuousAt.congr_of_eventuallyEq
    filter_upwards [eventually_gt_nhds hpos] with y hy
    simp only [outerState, if_neg (not_lt.mpr hy.le)]

theorem shockState_continuous_before {t : ℝ} (ht : t < 1) :
    Continuous (fun x => shockState x t) := by
  apply continuous_if
  · intro x hx
    exact central_outer_state_match ht (frontier_lt_subset_eq continuous_const
      (continuous_const.sub continuous_abs) hx)
  · exact (by fun_prop : Continuous (fun x : ℝ => -x / (1 - t))).continuousOn
  · intro x hx
    have hclosed : IsClosed {y : ℝ | ¬t < 1 - |y|} := by
      simp only [not_lt]
      exact isClosed_le (continuous_const.sub continuous_abs) continuous_const
    have hout : ¬t < 1 - |x| := by simpa only [hclosed.closure_eq] using hx
    have hxne : x ≠ 0 := by intro hz; simp only [hz, abs_zero, sub_zero] at hout; linarith
    exact (outerState_space_continuousAt hxne t).continuousWithinAt

theorem shockPotential_space_right_deriv (x t : ℝ) :
    HasDerivWithinAt (fun y => shockPotential y t) (shockState x t) (Ioi x) x := by
  by_cases ht : 1 ≤ t
  · have hpot : (fun y => shockPotential y t) = fun y => outerPotential y t := by
      funext y
      simp only [shockPotential, if_neg (show ¬t < 1 - |y| by linarith [abs_nonneg y])]
    rw [hpot, shockState_after ht]
    exact outerPotential_space_right_deriv x t
  have ht' : t < 1 := lt_of_not_ge ht
  by_cases hc : t < 1 - |x|
  · simp only [shockState, if_pos hc]
    apply (centralPotential_space_deriv x t).hasDerivWithinAt.congr_of_eventuallyEq
    · have hopen : IsOpen {y : ℝ | t < 1 - |y|} :=
        isOpen_lt continuous_const (continuous_const.sub continuous_abs)
      have hev : ∀ᶠ y in 𝓝 x, t < 1 - |y| := hopen.mem_nhds hc
      filter_upwards [hev.filter_mono inf_le_left] with y hy
      simp only [shockPotential, if_pos hy]
    · simp only [shockPotential, if_pos hc]
  by_cases heq : t = 1 - |x|
  · have hx : x ≠ 0 := by intro hz; simp only [hz, abs_zero, sub_zero] at heq; linarith
    have hmatch := central_outer_state_match ht' heq
    have hg : HasDerivAt (fun y => outerPotential y t) (-x / (1 - t)) x :=
      (outerPotential_space_deriv hx t).congr_deriv hmatch.symm
    have hh := hasDerivAt_if_of_eq (fun y => t < 1 - |y|)
      (centralPotential_space_deriv x t) hg (potential_match heq)
    simp only [shockState, if_neg hc]
    exact hh.hasDerivWithinAt.congr_deriv hmatch
  · have hstrict : 1 - |x| < t := lt_of_le_of_ne (le_of_not_gt hc) (Ne.symm heq)
    simp only [shockState, if_neg hc]
    apply (outerPotential_space_right_deriv x t).congr_of_eventuallyEq
    · have hopen : IsOpen {y : ℝ | 1 - |y| < t} :=
        isOpen_lt (continuous_const.sub continuous_abs) continuous_const
      have hev : ∀ᶠ y in 𝓝 x, 1 - |y| < t := hopen.mem_nhds hstrict
      filter_upwards [hev.filter_mono inf_le_left] with y hy
      simp only [shockPotential, if_neg (not_lt.mpr (le_of_lt hy))]
    · simp only [shockPotential, if_neg hc]


end

end NumStability.HuberShock
```

### `ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.Piecewise`

Path: `ComputationalMathematics/MeasureTheory/Integral/IntervalIntegral/Piecewise.lean`
SHA-256: `bd37f14e449820a88f13ebae4a14eb20594fc85081ced6b29b1589d4259aaf0c`

```lean
/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# Interval integrability of piecewise functions

Measurable pasting preserves integrability on every finite oriented interval.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

noncomputable section

theorem intervalIntegrable_piecewise {s : Set ℝ} [DecidablePred (· ∈ s)]
    {f g : ℝ → ℝ} {a b : ℝ} (hs : MeasurableSet s)
    (hf : IntervalIntegrable f volume a b) (hg : IntervalIntegrable g volume a b) :
    IntervalIntegrable (s.piecewise f g) volume a b := by
  rw [intervalIntegrable_iff]
  exact Integrable.piecewise (s := s) (μ := volume.restrict (uIoc a b)) hs
    hf.def'.integrableOn hg.def'.integrableOn


end

end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/LinearAdvection.lean`
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

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean`
SHA-256: `c99c3c0c2440026a290addd1535c41bc73c3832155c20c3e844d7c3af76bb296`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# Conservation on oriented space-time rectangles

Time-integrated conservation records spatial and boundary-flux integrability.
Locally integrable translated profiles satisfy this balance, including discontinuous profiles.
-/

open MeasureTheory

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Time-integrated balance over every oriented space-time rectangle. -/
def IsRectangleConservationLawSolution
    (q : ℝ → ℝ → E) (flux : E → E) : Prop :=
  (∀ a b t, IntervalIntegrable (fun x => q x t) volume a b) ∧
  (∀ x s t, IntervalIntegrable (fun τ => flux (q x τ)) volume s t) ∧
  ∀ a b s t,
    (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      ∫ τ in s..t, (flux (q a τ) - flux (q b τ))

/-- Change of variables and interval additivity give transport balance even
for discontinuous locally integrable profiles. -/
theorem travelingWave_intervalBalance (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed a b s t : ℝ) :
    (∫ x in a..b, travelingWave profile speed x t) -
        (∫ x in a..b, travelingWave profile speed x s) =
      speed • (∫ τ in s..t, travelingWave profile speed a τ) -
        speed • (∫ τ in s..t, travelingWave profile speed b τ) := by
  simp only [travelingWave, intervalIntegral.integral_comp_sub_right,
    intervalIntegral.smul_integral_comp_sub_mul]
  exact intervalIntegral.integral_interval_sub_interval_comm
    (hprofile _ _) (hprofile _ _) (hprofile _ _)

omit [NormedSpace ℝ E] in
theorem travelingWave_intervalIntegrable_space (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed a b t : ℝ) :
    IntervalIntegrable (fun x => travelingWave profile speed x t) volume a b := by
  simpa only [travelingWave, sub_add_cancel] using
    (hprofile (a - speed * t) (b - speed * t)).comp_sub_right (speed * t)

omit [NormedSpace ℝ E] in
theorem travelingWave_intervalIntegrable_time (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b)
    (speed x s t : ℝ) :
    IntervalIntegrable (fun τ => travelingWave profile speed x τ) volume s t := by
  by_cases hc : speed = 0
  · simp only [travelingWave, hc, zero_mul, sub_zero]
    exact intervalIntegrable_const
  have hsub := (hprofile (x - speed * s) (x - speed * t)).comp_sub_left x
  have hmul := hsub.comp_mul_left (c := speed)
  simpa only [travelingWave, sub_sub_cancel, mul_div_cancel_left₀ _ hc] using hmul

theorem travelingWave_isRectangleConservationLawSolution (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b) (speed : ℝ) :
    IsRectangleConservationLawSolution (travelingWave profile speed)
      (fun state => speed • state) := by
  refine ⟨travelingWave_intervalIntegrable_space profile hprofile speed, ?_, ?_⟩
  · intro x s t
    exact (travelingWave_intervalIntegrable_time profile hprofile speed x s t).smul speed
  · intro a b s t
    calc
      _ = speed • (∫ τ in s..t, travelingWave profile speed a τ) -
          speed • (∫ τ in s..t, travelingWave profile speed b τ) :=
        travelingWave_intervalBalance profile hprofile speed a b s t
      _ = _ := by
        simpa only [Pi.smul_apply, intervalIntegral.integral_smul] using
          (intervalIntegral.integral_sub
            ((travelingWave_intervalIntegrable_time profile hprofile speed a s t).smul speed)
            ((travelingWave_intervalIntegrable_time profile hprofile speed b s t).smul speed)).symm


end NumStability
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Conservation`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Examples/HuberShock/Conservation.lean`
SHA-256: `f4843ffd1005ed0c5753fdd818c76d7b4fa16994f5a1162fc04df16d2f97f157`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Regularity
import ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.Piecewise
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

/-!
# Rectangle conservation for the Huber shock

Spatial and temporal integrability are proved independently. Applying FTC
to the displayed potential then gives balance on every oriented rectangle.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.HuberShock

noncomputable section

theorem shockState_space_intervalIntegrable (a b t : ℝ) :
    IntervalIntegrable (fun x => shockState x t) volume a b := by
  have hout : IntervalIntegrable (fun x => outerState x t) volume a b := by
    apply intervalIntegrable_piecewise measurableSet_Iio
    · exact (by fun_prop : Continuous (fun x : ℝ => t - x)).intervalIntegrable a b
    · exact (by fun_prop : Continuous (fun x : ℝ => -t - x)).intervalIntegrable a b
  apply intervalIntegrable_piecewise
    (isOpen_lt continuous_const (continuous_const.sub continuous_abs)).measurableSet
  · exact (by fun_prop : Continuous (fun x : ℝ => -x / (1 - t))).intervalIntegrable a b
  · exact hout

theorem clippedCentralState_continuous (x : ℝ) :
    Continuous (fun t : ℝ => -x / max (1 - t) |x|) := by
  by_cases hx : x = 0
  · subst x
    simpa only [neg_zero, zero_div] using (continuous_const : Continuous (fun _ : ℝ => (0 : ℝ)))
  apply continuous_const.div ((continuous_const.sub continuous_id).max continuous_const)
  intro t
  exact ne_of_gt ((abs_pos.mpr hx).trans_le (le_max_right (1 - t) |x|))

theorem shockState_flux_time_intervalIntegrable (x a b : ℝ) :
    IntervalIntegrable (fun t => huberFlux (shockState x t)) volume a b := by
  have hrepr : (fun t => huberFlux (shockState x t)) =
      fun t => if t < 1 - |x| then huberFlux (-x / max (1 - t) |x|)
        else huberFlux (outerState x t) := by
    funext t
    by_cases ht : t < 1 - |x|
    · simp only [shockState, if_pos ht, max_eq_left (show |x| ≤ 1 - t by linarith)]
    · simp only [shockState, if_neg ht]
  rw [hrepr]
  apply intervalIntegrable_piecewise measurableSet_Iio
  · exact (huberFlux_contDiff_one.continuous.comp (clippedCentralState_continuous x)).intervalIntegrable a b
  · have hout : Continuous (outerState x) := by
      unfold outerState
      split_ifs <;> fun_prop
    exact (huberFlux_contDiff_one.continuous.comp hout).intervalIntegrable a b

theorem shockState_mass_potential (a b t : ℝ) :
    (∫ x in a..b, shockState x t) = shockPotential b t - shockPotential a t := by
  exact intervalIntegral.integral_eq_sub_of_hasDeriv_right
    (shockPotential_space_continuous t).continuousOn
    (fun x _ => shockPotential_space_right_deriv x t)
    (shockState_space_intervalIntegrable a b t)

theorem shockState_flux_potential (x a b : ℝ) :
    (∫ t in a..b, huberFlux (shockState x t)) = shockPotential x a - shockPotential x b := by
  have hh := intervalIntegral.integral_eq_sub_of_hasDeriv_right
    (shockPotential_time_continuous x).continuousOn
    (fun t _ => shockPotential_time_right_deriv x t)
    (shockState_flux_time_intervalIntegrable x a b).neg
  rw [intervalIntegral.integral_neg] at hh
  linarith

/-- Complete oriented rectangle balance for the constructed field, proved from its
primitive and right-derivative FTC; no conservation-law certificate is an input. -/
theorem shockState_rectangle_balance (a b s t : ℝ) :
    (∫ x in a..b, shockState x t) - (∫ x in a..b, shockState x s) =
      ∫ τ in s..t, (huberFlux (shockState a τ) - huberFlux (shockState b τ)) := by
  rw [shockState_mass_potential, shockState_mass_potential,
    intervalIntegral.integral_sub (shockState_flux_time_intervalIntegrable a s t)
      (shockState_flux_time_intervalIntegrable b s t),
    shockState_flux_potential, shockState_flux_potential]
  ring

/-- The explicit field satisfies the shared conservation predicate. -/
theorem shockState_isRectangleConservationLawSolution :
    IsRectangleConservationLawSolution shockState huberFlux :=
  ⟨shockState_space_intervalIntegrable, shockState_flux_time_intervalIntegrable,
    shockState_rectangle_balance⟩

end

end NumStability.HuberShock
```

### `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Jump`

Path: `ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Examples/HuberShock/Jump.lean`
SHA-256: `7a046f02044341614eea72c91b55742d6410e8285fdf2044d77ee96bef9dbc2e`

```lean
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Basic
import Mathlib.Analysis.Convex.Jensen

/-!
# Jump traces and local admissibility of the Huber shock

Distinct one-sided limits give a genuine jump. Equal fluxes, inward speeds,
and the Oleinik chord inequality are local facts; no full spacetime entropy
inequality or entropy uniqueness theorem is asserted here.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.HuberShock

noncomputable section

theorem stationary_shock_flux_and_speeds {t : ℝ} (ht : 1 ≤ t) :
    huberFlux t = huberFlux (-t) ∧ huberSlope t = 1 ∧ huberSlope (-t) = -1 := by
  refine ⟨?_, huberSlope_of_ge ht, huberSlope_of_le (by linarith)⟩
  rw [huberFlux_of_ge ht, huberFlux_of_le (by linarith : -t ≤ -1)]
  ring

/-- Distinct one-sided limits certify an actual jump, independently of the value at zero. -/
theorem shockState_jump_traces {t : ℝ} (ht : 1 ≤ t) :
    Tendsto (fun x => shockState x t) (𝓝[<] 0) (𝓝 t) ∧
    Tendsto (fun x => shockState x t) (𝓝[>] 0) (𝓝 (-t)) ∧ -t < t := by
  refine ⟨?_, ?_, by linarith⟩
  ·
    have hh : Tendsto (fun x : ℝ => t - x) (𝓝[<] 0) (𝓝 t) := by
      have hlinear : Continuous (fun y : ℝ => t - y) := continuous_const.sub continuous_id
      simpa only [sub_zero] using
        (hlinear.continuousAt (x := (0 : ℝ))).tendsto.mono_left
          (show 𝓝[<] (0 : ℝ) ≤ 𝓝 0 from inf_le_left)
    apply hh.congr'
    filter_upwards [self_mem_nhdsWithin] with x hx
    simp only [shockState_after ht, outerState, mem_Iio.mp hx, if_pos]
  · have hh : Tendsto (fun x : ℝ => -t - x) (𝓝[>] 0) (𝓝 (-t)) := by
      have hlinear : Continuous (fun y : ℝ => -t - y) := continuous_const.sub continuous_id
      simpa only [sub_zero] using
        (hlinear.continuousAt (x := (0 : ℝ))).tendsto.mono_left
          (show 𝓝[>] (0 : ℝ) ≤ 𝓝 0 from inf_le_left)
    apply hh.congr'
    filter_upwards [self_mem_nhdsWithin] with x hx
    simp only [shockState_after ht, outerState, if_neg (not_lt.mpr (le_of_lt (mem_Ioi.mp hx)))]

/-- A genuine discontinuity is present at every time at or after collapse. -/
theorem shockState_not_continuous_after {t : ℝ} (ht : 1 ≤ t) :
    ¬ ContinuousAt (fun x => shockState x t) 0 := by
  intro hc
  have hleft := (shockState_jump_traces ht).1
  have hboth := tendsto_nhds_unique hleft hc.continuousWithinAt.tendsto
  simp only [shockState_after ht, outerState, lt_self_iff_false, if_false, sub_zero] at hboth
  linarith

/-- The flux graph lies below the stationary shock chord between its two traces. -/
theorem stationary_shock_oleinik {t k : ℝ} (ht : 1 ≤ t) (hk : k ∈ Icc (-t) t) :
    huberFlux k ≤ huberFlux t := by
  have hh := huberFlux_convex.le_max_of_mem_Icc (mem_univ (-t)) (mem_univ t) hk
  simpa only [← (stationary_shock_flux_and_speeds ht).1, max_self] using hh


end

end NumStability.HuberShock
```
