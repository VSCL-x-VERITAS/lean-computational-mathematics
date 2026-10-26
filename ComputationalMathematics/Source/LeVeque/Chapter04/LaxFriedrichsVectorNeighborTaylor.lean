/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageNeighborTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import Mathlib.Tactic.Module

/-!
# Vector neighbor-average Taylor bound for Lax–Friedrichs

The two exact neighboring spatial samples have opposite linear terms,
so their centered mean differs from the center state only quadratically.
This bound is dimension-independent in the finite-vector supremum norm.
-/

namespace NumStability

open MeasureTheory

/-- The centered exact vector cell average has the face-state secant
as its spatial derivative. -/
theorem leveque04_laxFriedrichs_vectorExactCellAverage_hasDerivAt_center
    {m : ℕ} (profile : ℝ → Fin m → ℝ)
    (center width : ℝ) (hprofile : Continuous profile)
    (hwidth : 0 < width) :
    HasDerivAt
      (fun c => oneDimensionalCellAverage profile
        (c - width / 2) (c + width / 2))
      (width⁻¹ •
        (profile (center + width / 2) -
          profile (center - width / 2))) center := by
  apply hasDerivAt_pi.mpr
  intro p
  have heq :
      (fun c => oneDimensionalCellAverage profile
        (c - width / 2) (c + width / 2) p) =
      (fun c => oneDimensionalCellAverage (fun x => profile x p)
        (c - width / 2) (c + width / 2)) := by
    funext c
    exact oneDimensionalCellAverage_apply profile _ _
      (hprofile.intervalIntegrable (μ := volume) _ _) p
  change HasDerivAt
    (fun c => oneDimensionalCellAverage profile
      (c - width / 2) (c + width / 2) p)
    ((width⁻¹ •
      (profile (center + width / 2) -
        profile (center - width / 2))) p) center
  rw [heq]
  simpa only [Pi.smul_apply, Pi.sub_apply, smul_eq_mul,
    div_eq_mul_inv, mul_comm] using
    (oneDimensionalCellAverage_hasDerivAt_center
      (fun x => profile x p) width center
      ((continuous_apply p).comp hprofile) hwidth)

/-- Both neighboring finite-vector cell averages have the same
quadratic Taylor remainder as their scalar coordinates. -/
theorem leveque04_laxFriedrichs_vectorExactCellAverage_neighborTaylor
    {m : ℕ} (profile profile' : ℝ → Fin m → ℝ)
    (K center width : ℝ) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hLip : ∀ x y, ‖profile' x - profile' y‖ ≤ K * |x - y|) :
    let avg := fun c => oneDimensionalCellAverage profile
      (c - width / 2) (c + width / 2)
    let slope : Fin m → ℝ := fun p =>
      (profile (center + width / 2) p -
        profile (center - width / 2) p) / width
    ‖avg (center - width) - (avg center - width • slope)‖ ≤
        K * width ^ 2 ∧
      ‖avg (center + width) - (avg center + width • slope)‖ ≤
        K * width ^ 2 := by
  have hcont : Continuous profile :=
    continuous_iff_continuousAt.mpr (fun x => (hprofile x).continuousAt)
  have hcoord (c : ℝ) (p : Fin m) :
      oneDimensionalCellAverage profile
          (c - width / 2) (c + width / 2) p =
        oneDimensionalCellAverage (fun x => profile x p)
          (c - width / 2) (c + width / 2) :=
    oneDimensionalCellAverage_apply profile _ _
      (hcont.intervalIntegrable (μ := volume) _ _) p
  have hscalar (p : Fin m) := oneDimensionalCellAverage_neighborTaylor
    (fun x => profile x p) (fun x => profile' x p)
    K center width hK hwidth
    (fun x => (hasDerivAt_pi.mp (hprofile x)) p)
    (by
      intro x y
      have h := norm_le_pi_norm (profile' x - profile' y) p
      simpa only [Pi.sub_apply, Real.norm_eq_abs] using h.trans (hLip x y))
  dsimp only
  constructor
  · apply (pi_norm_le_iff_of_nonneg (mul_nonneg hK (sq_nonneg _))).2
    intro p
    have hp := (hscalar p).1
    simpa only [Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul,
      Real.norm_eq_abs, hcoord] using hp
  · apply (pi_norm_le_iff_of_nonneg (mul_nonneg hK (sq_nonneg _))).2
    intro p
    have hp := (hscalar p).2
    simpa only [Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul,
      Real.norm_eq_abs, hcoord] using hp

/-- The symmetric mean of the actual neighboring vector cell averages
differs from the center cell average only quadratically. -/
theorem leveque04_laxFriedrichs_vectorExactCellAverage_neighborMean
    {m : ℕ} (profile profile' : ℝ → Fin m → ℝ)
    (K center width : ℝ) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hLip : ∀ x y, ‖profile' x - profile' y‖ ≤ K * |x - y|) :
    let avg := fun c => oneDimensionalCellAverage profile
      (c - width / 2) (c + width / 2)
    ‖(1 / 2 : ℝ) • (avg (center - width) + avg (center + width)) -
        avg center‖ ≤ K * width ^ 2 := by
  have hpair := leveque04_laxFriedrichs_vectorExactCellAverage_neighborTaylor
    profile profile' K center width hK hwidth hprofile hLip
  dsimp only at hpair ⊢
  let avg := fun c => oneDimensionalCellAverage profile
    (c - width / 2) (c + width / 2)
  let slope : Fin m → ℝ := fun p =>
    (profile (center + width / 2) p -
      profile (center - width / 2) p) / width
  have hid :
      (1 / 2 : ℝ) • (avg (center - width) + avg (center + width)) -
          avg center =
        (1 / 2 : ℝ) •
          ((avg (center - width) - (avg center - width • slope)) +
            (avg (center + width) - (avg center + width • slope))) := by
    module
  rw [hid, norm_smul, Real.norm_eq_abs]
  have hhalf : |(1 / 2 : ℝ)| = 1 / 2 := by norm_num
  rw [hhalf]
  calc
    _ ≤ (1 / 2 : ℝ) *
      (‖avg (center - width) - (avg center - width • slope)‖ +
        ‖avg (center + width) - (avg center + width • slope)‖) := by
      exact mul_le_mul_of_nonneg_left (norm_add_le _ _) (by norm_num)
    _ ≤ (1 / 2 : ℝ) * (K * width ^ 2 + K * width ^ 2) := by
      exact mul_le_mul_of_nonneg_left (add_le_add hpair.1 hpair.2)
        (by norm_num)
    _ = K * width ^ 2 := by ring

theorem leveque04_laxFriedrichs_vectorNeighborMean_error
    {m : ℕ} (profile profile' : ℝ → Fin m → ℝ)
    (K center width : ℝ) (hK : 0 ≤ K)
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hLip : ∀ x y,
      ‖profile' x - profile' y‖ ≤ K * |x - y|) :
    ‖(1 / 2 : ℝ) •
        (profile (center - width) + profile (center + width)) -
      profile center‖ ≤ K * width ^ 2 := by
  have hleft := vectorFirstOrderTaylorError_le_of_lipschitzDeriv
    profile profile' K center (center - width) hK hprofile hLip
  have hright := vectorFirstOrderTaylorError_le_of_lipschitzDeriv
    profile profile' K center (center + width) hK hprofile hLip
  have hleft' :
      ‖profile (center - width) -
        (profile center + (-width) • profile' center)‖ ≤
          K * width ^ 2 := by
    simpa only [sub_sub_cancel_left, neg_sq] using hleft
  have hright' :
      ‖profile (center + width) -
        (profile center + width • profile' center)‖ ≤
          K * width ^ 2 := by
    simpa only [add_sub_cancel_left] using hright
  have hid :
      (1 / 2 : ℝ) •
          (profile (center - width) + profile (center + width)) -
        profile center =
      (1 / 2 : ℝ) •
        ((profile (center - width) -
            (profile center + (-width) • profile' center)) +
          (profile (center + width) -
            (profile center + width • profile' center))) := by
    module
  rw [hid, norm_smul, Real.norm_eq_abs]
  have hhalf : |(1 / 2 : ℝ)| = 1 / 2 := by norm_num
  rw [hhalf]
  calc
    _ ≤ (1 / 2 : ℝ) *
        (‖profile (center - width) -
            (profile center + (-width) • profile' center)‖ +
          ‖profile (center + width) -
            (profile center + width • profile' center)‖) := by
          exact mul_le_mul_of_nonneg_left (norm_add_le _ _) (by norm_num)
    _ ≤ (1 / 2 : ℝ) * (K * width ^ 2 + K * width ^ 2) := by
          exact mul_le_mul_of_nonneg_left (add_le_add hleft' hright') (by norm_num)
    _ = K * width ^ 2 := by ring

/-- A centered finite-vector flux difference has quadratic error when
the derivative of the flux along the spatial profile is Lipschitz. -/
theorem leveque04_laxFriedrichs_vectorCenteredDifference_error
    {m : ℕ} (g g' : ℝ → Fin m → ℝ)
    (K center width : ℝ) (hK : 0 ≤ K)
    (hg : ∀ x, HasDerivAt g (g' x) x)
    (hLip : ∀ x y, ‖g' x - g' y‖ ≤ K * |x - y|) :
    ‖(g (center + width) - g (center - width)) -
        (2 * width) • g' center‖ ≤ 2 * K * width ^ 2 := by
  have hleft := vectorFirstOrderTaylorError_le_of_lipschitzDeriv
    g g' K center (center - width) hK hg hLip
  have hright := vectorFirstOrderTaylorError_le_of_lipschitzDeriv
    g g' K center (center + width) hK hg hLip
  have hleft' :
      ‖g (center - width) -
        (g center + (-width) • g' center)‖ ≤ K * width ^ 2 := by
    simpa only [sub_sub_cancel_left, neg_sq] using hleft
  have hright' :
      ‖g (center + width) -
        (g center + width • g' center)‖ ≤ K * width ^ 2 := by
    simpa only [add_sub_cancel_left] using hright
  have hid :
      (g (center + width) - g (center - width)) -
          (2 * width) • g' center =
        (g (center + width) - (g center + width • g' center)) -
          (g (center - width) -
            (g center + (-width) • g' center)) := by
    module
  rw [hid]
  calc
    _ ≤ ‖g (center + width) - (g center + width • g' center)‖ +
      ‖g (center - width) -
        (g center + (-width) • g' center)‖ := norm_sub_le _ _
    _ ≤ K * width ^ 2 + K * width ^ 2 :=
      add_le_add hright' hleft'
    _ = 2 * K * width ^ 2 := by ring

end NumStability
