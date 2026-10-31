import ComputationalMathematics.Source.Vershynin.Chapter04.SBMSignDisagreementBound.FullBodyTarget
import ComputationalMathematics.Source.Vershynin.Chapter04.SBMEigenvectorSignCorrection.FullBodyProof

/-! # Sign disagreements on the common stochastic-block-model success event -/

noncomputable section

open MeasureTheory ProbabilityTheory
open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

namespace NumStability.HDP.Contract

/-- The common-event sign-disagreement bound, with global label matching. -/
theorem sbm_sign_disagreement_full_body_proved : HDP04SBMSignDisagreementFullBodyTarget := by
  obtain ⟨C, hC, hmain⟩ := sbm_eigenvector_sign_correction_full_body_proved
  refine ⟨C, hC, ?_⟩
  intro k hn θ community hbalanced hq hpq
  obtain ⟨hμgap, hμfinal, hcompare1, hcompare2, hmean,
      u, hu, hsignal, hprob⟩ :=
    hmain k hn θ community hbalanced hq hpq
  let n : ℕ := 2 * k
  let P := FinStochasticBlock.measure community θ
  let μgap : ℝ := min (((θ.p : ℝ) - θ.q) / 2) θ.q
  let μfinal : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - θ.q)
  let signal : Fin n → ℝ := fun i => if community i = 0 then 1 else -1
  refine ⟨hμgap, hμfinal, hcompare1, hcompare2, hmean,
    u, hu, hsignal, ?_⟩
  apply hprob.trans
  apply measureReal_mono
  · intro ω hω v hv
    obtain ⟨s, hs, _, hsum, hsign, swapped, hswapped, hclass1, hclass2⟩ :=
      hω v hv
    exact ⟨s, hs, hsum, hsign, swapped, hswapped, hclass1, hclass2⟩
  · exact measure_ne_top P _

end NumStability.HDP.Contract
