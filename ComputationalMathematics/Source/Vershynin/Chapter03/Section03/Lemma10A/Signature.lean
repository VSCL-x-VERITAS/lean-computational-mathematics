import ComputationalMathematics.HDP.Vector.FrameIsotropy

/-! Frozen signature for Lemma 3.3.10(a), tight frames give isotropic laws. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_lem_3_3_10a__contract_type : Prop :=
  ∀ {N n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      (μ : Measure Ω) (X : Fin (n + 1) → Ω → ℝ)
      (u : Fin (N + 1) → Fin (n + 1) → ℝ) (A : ℝ),
    NumStability.HDP.Vector.Frame.IsTightFrame u A →
      NumStability.HDP.Vector.FrameIsotropy.HasUniformFrameLaw μ X u →
        NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω ↦ Real.sqrt (((N + 1 : ℕ) : ℝ) / A) * X j ω)

end NumStability.HDP.Contract
