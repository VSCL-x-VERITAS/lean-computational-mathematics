import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData

namespace NumStability.Chapter01Scratch

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

#print axioms isRiemannInitialValueSolution_iff
#print axioms isRiemannInitialValueSolution_iff_exists_origin
#print axioms isRiemannData_prod_iff
#print axioms riemannData_prod

end NumStability.Chapter01Scratch
