/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedSpatialDerivative

/-!
# Partial derivative regularity through physical time endpoints

Joint physical smoothness on an open spatial interval times a closed
time interval gives one lower degree of joint regularity for its
actual spatial slice derivative and its physical within-time
derivative. Mathlib within-derivative regularity and the within
chain rule identify these values. No total time derivative or
nonphysical smooth extension is assumed at the time endpoints.
-/

namespace NumStability
open Set

theorem contDiffOn_closedTimeStrip_spatial_derivative
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (n : ℕ) (q : ℝ → ℝ → E) (L R start finish : ℝ) (htime : start < finish)
    (hq : ContDiffOn ℝ ((n+1 : ℕ) : WithTop ℕ∞) (Function.uncurry q) (Ioo L R ×ˢ Icc start finish)) :
    ContDiffOn ℝ n (fun p : ℝ × ℝ => deriv (fun ξ => q ξ p.2) p.1)
      (Ioo L R ×ˢ Icc start finish) := by
  let strip := Ioo L R ×ˢ Icc start finish
  have hD : ContDiffOn ℝ n (fderivWithin ℝ (Function.uncurry q) strip) strip :=
    hq.fderivWithin (isOpen_Ioo.uniqueDiffOn.prod (uniqueDiffOn_Icc htime)) (by norm_num)
  have hc : ContDiffOn ℝ n
      (fun p => fderivWithin ℝ (Function.uncurry q) strip p (1,0)) strip :=
    hD.clm_apply contDiffOn_const
  apply hc.congr
  intro p hp
  have hone : ContDiffOn ℝ 1 (Function.uncurry q) strip :=
    hq.of_le (by change ((1 : ℕ∞) : WithTop ℕ∞) ≤ ((n+1 : ℕ) : ℕ∞); exact WithTop.coe_le_coe.mpr (ENat.coe_le_coe.mpr (by omega)))
  have hd := hone.differentiableOn_one p hp
  have hcurve : HasDerivWithinAt (fun ξ : ℝ => (ξ,p.2)) (1,0) (Ioo L R) p.1 :=
    ((hasDerivAt_id p.1).prodMk (hasDerivAt_const p.1 p.2)).hasDerivWithinAt
  have hmaps : MapsTo (fun ξ : ℝ => (ξ,p.2)) (Ioo L R) strip := fun ξ hξ => ⟨hξ,hp.2⟩
  exact ((hd.hasFDerivWithinAt.comp_hasDerivWithinAt p.1 hcurve hmaps).hasDerivAt
    (isOpen_Ioo.mem_nhds hp.1)).deriv


theorem contDiffOn_closedTimeStrip_temporal_derivativeWithin
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (n : ℕ) (q : ℝ → ℝ → E) (L R start finish : ℝ) (htime : start < finish)
    (hq : ContDiffOn ℝ ((n+1 : ℕ) : WithTop ℕ∞)
      (Function.uncurry q) (Ioo L R ×ˢ Icc start finish)) :
    ContDiffOn ℝ n (fun p : ℝ × ℝ => derivWithin (q p.1) (Icc start finish) p.2)
      (Ioo L R ×ˢ Icc start finish) := by
  let strip := Ioo L R ×ˢ Icc start finish
  have hD : ContDiffOn ℝ n (fderivWithin ℝ (Function.uncurry q) strip) strip :=
    hq.fderivWithin (isOpen_Ioo.uniqueDiffOn.prod (uniqueDiffOn_Icc htime)) (by norm_num)
  have hc : ContDiffOn ℝ n
      (fun p => fderivWithin ℝ (Function.uncurry q) strip p (0,1)) strip :=
    hD.clm_apply contDiffOn_const
  apply hc.congr
  intro p hp
  have hone : ContDiffOn ℝ 1 (Function.uncurry q) strip :=
    hq.of_le (by
      change ((1 : ℕ∞) : WithTop ℕ∞) ≤ ((n+1 : ℕ) : ℕ∞)
      exact WithTop.coe_le_coe.mpr (ENat.coe_le_coe.mpr (by omega)))
  have hd := hone.differentiableOn_one p hp
  have hcurve : HasDerivWithinAt (fun τ : ℝ => (p.1,τ)) (0,1) (Icc start finish) p.2 :=
    ((hasDerivAt_const p.2 p.1).prodMk (hasDerivAt_id p.2)).hasDerivWithinAt
  have hmaps : MapsTo (fun τ : ℝ => (p.1,τ)) (Icc start finish) strip :=
    fun τ hτ => ⟨hp.1,hτ⟩
  exact (hd.hasFDerivWithinAt.comp_hasDerivWithinAt p.2 hcurve hmaps).derivWithin
    (uniqueDiffOn_Icc htime p.2 hp.2)

end NumStability
