import ComputationalMathematics.HDP.Vector.FrameIsotropy

/-! Frozen signature for Lemma 3.3.10(b), finite isotropic laws give tight frames. -/

noncomputable section

open MeasureTheory
open scoped BigOperators NNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_lem_3_3_10b__contract_type : Prop :=
  ∀ {N n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      (μ : Measure Ω) (X : Fin (n + 1) → Ω → ℝ)
      (p : Fin (N + 1) → ℝ≥0) (hp : ∑ i, p i = 1)
      (x : Fin (N + 1) → Fin (n + 1) → ℝ),
    (∀ i, 0 < p i) →
      Function.Injective x →
        NumStability.HDP.Vector.Isotropy.IsIsotropic μ X →
          NumStability.HDP.Vector.FrameIsotropy.HasFiniteWeightedVectorLaw μ X p hp x →
            NumStability.HDP.Vector.Frame.IsTightFrame
              (fun i ↦ Real.sqrt (p i : ℝ) • x i) 1

end NumStability.HDP.Contract
