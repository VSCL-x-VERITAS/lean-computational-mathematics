import ComputationalMathematics.HDP.Kernel.MooreAronszajn

/-! Frozen proof-free signature for the Moore--Aronszajn RKHS construction
and its standard minimal uniqueness statement in Section 3.7.1. -/

noncomputable section

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_7_moore_aronszajn__contract_type : Prop :=
  ∀ {X : Type} (K : X → X → ℝ),
    (NumStability.HDP.Kernel.IsPositiveSemidefinite K ↔
      ∃ (H : Type),
        ∃ (_ : NormedAddCommGroup H),
        ∃ (_ : InnerProductSpace ℝ H),
        ∃ (_ : CompleteSpace H),
        ∃ Φ : X → H,
          NumStability.HDP.Kernel.IsRealReproducingKernelPresentation K Φ) ∧
    ∀ (H₁ H₂ : Type)
      (_ : NormedAddCommGroup H₁) (_ : InnerProductSpace ℝ H₁) (_ : CompleteSpace H₁)
      (_ : NormedAddCommGroup H₂) (_ : InnerProductSpace ℝ H₂) (_ : CompleteSpace H₂)
      (Φ₁ : X → H₁) (Φ₂ : X → H₂),
      NumStability.HDP.Kernel.IsRealReproducingKernelPresentation K Φ₁ →
      NumStability.HDP.Kernel.IsRealReproducingKernelPresentation K Φ₂ →
      ∃ e : H₁ ≃ₗᵢ[ℝ] H₂, ∀ x, e (Φ₁ x) = Φ₂ x

end NumStability.HDP.Contract
