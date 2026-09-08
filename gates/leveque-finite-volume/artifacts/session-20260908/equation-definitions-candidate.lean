import ComputationalMathematics.Source.LeVeque.Chapter01.Equation05
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation10

open MeasureTheory

namespace NumStability.Chapter01Scratch

/-- Classical equation-form correspondence for the two acoustic equations,
on independently supplied fields and a nonzero density. -/
theorem leveque01_equation05_linearAcousticsAt_iff
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) (_hdensity : density ≠ 0) :
    leveque01_equation05_linearAcousticsAt pressure velocity bulkModulus density x t ↔
      ∃ pt px ut ux : ℝ,
        HasDerivAt (fun τ => pressure x τ) pt t ∧
          HasDerivAt (fun ξ => pressure ξ t) px x ∧
            HasDerivAt (fun τ => velocity x τ) ut t ∧
              HasDerivAt (fun ξ => velocity ξ t) ux x ∧
                pt + bulkModulus * ux = 0 ∧ ut + density⁻¹ * px = 0 :=
  Iff.rfl

/-- The classical rate formulation of (1.10), including every oriented
interval and explicit Bochner integrability. This is a correspondence theorem,
not a claim that discontinuous fields have a classical rate at every time. -/
theorem leveque01_equation10_integralConservation_iff
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) :
    leveque01Equation10IntegralConservation q flux ↔
      ∀ x₁ x₂ t,
        IntervalIntegrable (fun x => q x t) volume x₁ x₂ ∧
          HasDerivAt (fun τ => ∫ x in x₁..x₂, q x τ)
            (flux (q x₁ t) - flux (q x₂ t)) t :=
  Iff.rfl

#print axioms leveque01_equation05_linearAcousticsAt_iff
#print axioms leveque01_equation10_integralConservation_iff

end NumStability.Chapter01Scratch
