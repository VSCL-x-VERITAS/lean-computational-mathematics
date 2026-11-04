/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ThreeWaveEvolution
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearUniformWaveTraces
import ComputationalMathematics.Topology.Order.LocallyConstantJump
import Mathlib.Tactic.FinCases

/-!
# Actual traces of the three-wave field before and at contact

Separated fronts have their two adjacent constant states as traces, even when
the corresponding wave vanishes. At contact the two distinct basis modes add
without cancellation. All point values use the actual left trace of the
ceiling reconstruction.
-/

open Filter Set
open scoped Topology

namespace NumStability

private theorem threeWave_cfl_of_spread_le
    (speeds : Fin 3 → ℝ) (width time : ℝ)
    (_hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hspread : (speeds 2 - speeds 0) * time ≤ width) :
    ∀ p, |speeds p * time| ≤ width := by
  have hpositive : 0 < speeds 1 * time := mul_pos hs1 htime
  have hordered : speeds 1 * time < speeds 2 * time :=
    mul_lt_mul_of_pos_right hs12 htime
  have hnegative : speeds 0 * time < 0 := mul_neg_of_neg_of_pos hs0 htime
  intro p
  fin_cases p
  · change |speeds 0 * time| ≤ width
    apply abs_le.mpr
    constructor <;> nlinarith
  · change |speeds 1 * time| ≤ width
    apply abs_le.mpr
    constructor <;> nlinarith
  · change |speeds 2 * time| ≤ width
    apply abs_le.mpr
    constructor <;> nlinarith

private theorem hasJumpAt_iff_trace_difference_ne_zero
    {E : Type*} [AddCommGroup E] [TopologicalSpace E]
    {f : ℝ → E} {z : ℝ} {left right : E}
    (hl : Tendsto f (𝓝[<] z) (𝓝 left))
    (hr : Tendsto f (𝓝[>] z) (𝓝 right)) :
    HasJumpAt f z left right ↔ right - left ≠ 0 := by
  constructor
  · intro h hz
    exact h.2.2 (sub_eq_zero.mp hz).symm
  · intro h
    exact ⟨hl, hr, fun heq => h (sub_eq_zero.mpr heq.symm)⟩

/-- The three strictly separated fronts have the actual adjacent state traces
and take their left traces as point values, including zero wave amplitudes. -/
theorem leveque04_threeWaveEvolution_strict_traces
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hsep : (speeds 2 - speeds 0) * time < width)
    (old : ℤ → Fin 3 → ℝ) (i : ℤ) :
    let U := fun x => linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time
    let WL := leveque03_riemannWave basis (old (i - 1)) (old i)
    let WR := leveque03_riemannWave basis (old i) (old (i + 1))
    let a := leveque04_uniformInterface origin width (i - 1)
    let b := leveque04_uniformInterface origin width i
    let c1 := a + speeds 1 * time
    let c2 := a + speeds 2 * time
    let d0 := b + speeds 0 * time
    (Tendsto U (𝓝[<] c1) (𝓝 (old i - WL 1 - WL 2)) ∧
      Tendsto U (𝓝[>] c1) (𝓝 (old i - WL 2)) ∧
      U c1 = old i - WL 1 - WL 2) ∧
    (Tendsto U (𝓝[<] c2) (𝓝 (old i - WL 2)) ∧
      Tendsto U (𝓝[>] c2) (𝓝 (old i)) ∧ U c2 = old i - WL 2) ∧
    (Tendsto U (𝓝[<] d0) (𝓝 (old i)) ∧
      Tendsto U (𝓝[>] d0) (𝓝 (old i + WR 0)) ∧ U d0 = old i) := by
  dsimp only
  have geometry := (leveque04_threeWaveEvolution_strict_separation_iff
    speeds origin width time htime hs0 hs1 hs12 i).2 hsep
  rcases geometry with ⟨ha1, h12, h20, h0b⟩
  have hcfl := threeWave_cfl_of_spread_le speeds width time hwidth htime
    hs0 hs1 hs12 hsep.le
  have regions := leveque04_threeWaveEvolution_open_regions basis speeds
    origin width time hwidth htime hs0 hs1 hs12 hcfl hsep old i
  rcases regions with ⟨r1, r2, r3, r4⟩
  have hl1 := tendsto_nhdsLT_of_eqOn_Ioo ha1 (fun x hx => r1 x hx)
  have hr1 := tendsto_nhdsGT_of_eqOn_Ioo h12 (fun x hx => r2 x hx)
  have hl2 := tendsto_nhdsLT_of_eqOn_Ioo h12 (fun x hx => r2 x hx)
  have hr2 := tendsto_nhdsGT_of_eqOn_Ioo h20 (fun x hx => r3 x hx)
  have hl0 := tendsto_nhdsLT_of_eqOn_Ioo h20 (fun x hx => r3 x hx)
  have hr0 := tendsto_nhdsGT_of_eqOn_Ioo h0b (fun x hx => r4 x hx)
  exact ⟨⟨hl1, hr1, tendsto_nhds_unique
      (leveque04_linearUniformEvolution_tendsto_left_at basis speeds origin width
        hwidth old time _) hl1⟩,
    ⟨hl2, hr2, tendsto_nhds_unique
      (leveque04_linearUniformEvolution_tendsto_left_at basis speeds origin width
        hwidth old time _) hl2⟩,
    ⟨hl0, hr0, tendsto_nhds_unique
      (leveque04_linearUniformEvolution_tendsto_left_at basis speeds origin width
        hwidth old time _) hl0⟩⟩

/-- A strictly separated front is an active jump precisely when its actual
incoming basis wave is nonzero. No nonzero-wave premise is needed. -/
theorem leveque04_threeWaveEvolution_strict_active_iff
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hsep : (speeds 2 - speeds 0) * time < width)
    (old : ℤ → Fin 3 → ℝ) (i : ℤ) :
    let U := fun x => linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time
    let WL := leveque03_riemannWave basis (old (i - 1)) (old i)
    let WR := leveque03_riemannWave basis (old i) (old (i + 1))
    let c1 := leveque04_uniformInterface origin width (i - 1) + speeds 1 * time
    let c2 := leveque04_uniformInterface origin width (i - 1) + speeds 2 * time
    let d0 := leveque04_uniformInterface origin width i + speeds 0 * time
    (HasJumpAt U c1 (old i - WL 1 - WL 2) (old i - WL 2) ↔ WL 1 ≠ 0) ∧
      (HasJumpAt U c2 (old i - WL 2) (old i) ↔ WL 2 ≠ 0) ∧
      (HasJumpAt U d0 (old i) (old i + WR 0) ↔ WR 0 ≠ 0) := by
  dsimp only
  rcases leveque04_threeWaveEvolution_strict_traces basis speeds origin width time
    hwidth htime hs0 hs1 hs12 hsep old i with
    ⟨⟨hl1, hr1, _⟩, ⟨hl2, hr2, _⟩, ⟨hl0, hr0, _⟩⟩
  have hdiff1 :
      (old i - leveque03_riemannWave basis (old (i - 1)) (old i) 2) -
        (old i - leveque03_riemannWave basis (old (i - 1)) (old i) 1 -
          leveque03_riemannWave basis (old (i - 1)) (old i) 2) =
      leveque03_riemannWave basis (old (i - 1)) (old i) 1 := by abel
  have hdiff2 : old i -
      (old i - leveque03_riemannWave basis (old (i - 1)) (old i) 2) =
      leveque03_riemannWave basis (old (i - 1)) (old i) 2 := by abel
  have hdiff0 :
      (old i + leveque03_riemannWave basis (old i) (old (i + 1)) 0) - old i =
      leveque03_riemannWave basis (old i) (old (i + 1)) 0 := by abel
  exact ⟨by simpa only [hdiff1] using hasJumpAt_iff_trace_difference_ne_zero hl1 hr1,
    by simpa only [hdiff2] using hasJumpAt_iff_trace_difference_ne_zero hl2 hr2,
    by simpa only [hdiff0] using hasJumpAt_iff_trace_difference_ne_zero hl0 hr0⟩

/-- Contact itself implies full one-cell travel in every mode, and the
second positive front equals the negative front strictly inside the cell. -/
theorem leveque04_threeWaveEvolution_contact_geometry
    (speeds : Fin 3 → ℝ) (origin width time : ℝ)
    (hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hcontact : (speeds 2 - speeds 0) * time = width) (i : ℤ) :
    (∀ p, |speeds p * time| ≤ width) ∧
    (let a := leveque04_uniformInterface origin width (i - 1)
     let b := leveque04_uniformInterface origin width i
     let c1 := a + speeds 1 * time
     let c2 := a + speeds 2 * time
     let d0 := b + speeds 0 * time
     a < c1 ∧ c1 < c2 ∧ c2 = d0 ∧ d0 < b) := by
  have hpositive : 0 < speeds 1 * time := mul_pos hs1 htime
  have hordered : speeds 1 * time < speeds 2 * time :=
    mul_lt_mul_of_pos_right hs12 htime
  have hnegative : speeds 0 * time < 0 := mul_neg_of_neg_of_pos hs0 htime
  have hspan : leveque04_uniformInterface origin width i -
      leveque04_uniformInterface origin width (i - 1) = width := by
    simp only [leveque04_uniformInterface, Int.cast_sub, Int.cast_one]
    ring
  constructor
  · exact threeWave_cfl_of_spread_le speeds width time hwidth htime
      hs0 hs1 hs12 hcontact.le
  · dsimp only
    exact ⟨by linarith, by linarith, by nlinarith, by linarith⟩

/-- The two distinct basis modes reaching the contact point cannot cancel. -/
theorem leveque04_threeWave_contact_wave_sum_eq_zero_iff
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ))
    (left current right : Fin 3 → ℝ) :
    leveque03_riemannWave basis left current 2 +
        leveque03_riemannWave basis current right 0 = 0 ↔
      leveque03_riemannWave basis left current 2 = 0 ∧
        leveque03_riemannWave basis current right 0 = 0 := by
  constructor
  · intro hzero
    have h2 : leveque03_waveStrength basis left current 2 = 0 := by
      have h := congrArg (fun v => basis.equivFun v 2) hzero
      simpa [leveque03_riemannWave] using h
    have h0 : leveque03_waveStrength basis current right 0 = 0 := by
      have h := congrArg (fun v => basis.equivFun v 0) hzero
      simpa [leveque03_riemannWave] using h
    exact ⟨by simp only [leveque03_riemannWave, h2, zero_smul],
      by simp only [leveque03_riemannWave, h0, zero_smul]⟩
  · rintro ⟨hl, hr⟩
    rw [hl, hr, add_zero]

/-- Nonvanishing at contact means that at least one actual incoming mode is
nonzero, without an additional noncancellation hypothesis. -/
theorem leveque04_threeWave_contact_wave_sum_ne_zero_iff
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ))
    (left current right : Fin 3 → ℝ) :
    leveque03_riemannWave basis left current 2 +
        leveque03_riemannWave basis current right 0 ≠ 0 ↔
      leveque03_riemannWave basis left current 2 ≠ 0 ∨
        leveque03_riemannWave basis current right 0 ≠ 0 := by
  simpa only [not_and_or] using not_congr
    (leveque04_threeWave_contact_wave_sum_eq_zero_iff basis left current right)

/-- At contact the actual left trace and point value are `Q-WL2`, while the
right trace is `Q+WR0`; their difference is the sum of the two modal waves. -/
theorem leveque04_threeWaveEvolution_contact_traces
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hcontact : (speeds 2 - speeds 0) * time = width)
    (old : ℤ → Fin 3 → ℝ) (i : ℤ) :
    let U := fun x => linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time
    let WL := leveque03_riemannWave basis (old (i - 1)) (old i)
    let WR := leveque03_riemannWave basis (old i) (old (i + 1))
    let c := leveque04_uniformInterface origin width (i - 1) + speeds 2 * time
    Tendsto U (𝓝[<] c) (𝓝 (old i - WL 2)) ∧
      Tendsto U (𝓝[>] c) (𝓝 (old i + WR 0)) ∧
      U c = old i - WL 2 ∧
      (old i + WR 0) - (old i - WL 2) = WL 2 + WR 0 := by
  dsimp only
  rcases leveque04_threeWaveEvolution_contact_geometry speeds origin width time
    hwidth htime hs0 hs1 hs12 hcontact i with ⟨hcfl, ha1, h12, h20, h0b⟩
  have hleft : EqOn
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time)
      (fun _ => old i - leveque03_riemannWave basis (old (i - 1)) (old i) 2)
      (Ioo (leveque04_uniformInterface origin width (i - 1) + speeds 1 * time)
        (leveque04_uniformInterface origin width (i - 1) + speeds 2 * time)) := by
    intro x hx
    have hcell : x ∈ leveque04_cell (leveque04_uniformInterface origin width) i :=
      ⟨by linarith [hx.1], by linarith [hx.2]⟩
    have h := leveque04_threeWaveEvolution_formula basis speeds origin width time
      hwidth htime hs0 hs1 hs12 hcfl old i x hcell
    have h1 : ¬ x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 1 * time :=
      not_le.mpr hx.1
    have h2 : x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 2 * time :=
      hx.2.le
    have h0 : ¬ leveque04_uniformInterface origin width i + speeds 0 * time < x :=
      not_lt.mpr (by linarith [hx.2])
    simpa only [if_neg h1, if_pos h2, if_neg h0, sub_zero, add_zero] using h
  have hright : EqOn
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time)
      (fun _ => old i + leveque03_riemannWave basis (old i) (old (i + 1)) 0)
      (Ioo (leveque04_uniformInterface origin width (i - 1) + speeds 2 * time)
        (leveque04_uniformInterface origin width i)) := by
    intro x hx
    have hcell : x ∈ leveque04_cell (leveque04_uniformInterface origin width) i :=
      ⟨by linarith [hx.1], hx.2⟩
    have h := leveque04_threeWaveEvolution_formula basis speeds origin width time
      hwidth htime hs0 hs1 hs12 hcfl old i x hcell
    have h1 : ¬ x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 1 * time :=
      not_le.mpr (by linarith [hx.1])
    have h2 : ¬ x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 2 * time :=
      not_le.mpr hx.1
    have h0 : leveque04_uniformInterface origin width i + speeds 0 * time < x :=
      by linarith [hx.1]
    simpa only [if_neg h1, if_neg h2, if_pos h0, sub_zero] using h
  have hl := tendsto_nhdsLT_of_eqOn_Ioo h12 hleft
  have hr := tendsto_nhdsGT_of_eqOn_Ioo (by linarith :
    leveque04_uniformInterface origin width (i - 1) + speeds 2 * time <
      leveque04_uniformInterface origin width i) hright
  exact ⟨hl, hr, tendsto_nhds_unique
    (leveque04_linearUniformEvolution_tendsto_left_at basis speeds origin width
      hwidth old time _) hl, by abel⟩

/-- The actual contact front is a jump exactly when at least one of its two
incoming distinct basis modes is active. -/
theorem leveque04_threeWaveEvolution_contact_active_iff
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hcontact : (speeds 2 - speeds 0) * time = width)
    (old : ℤ → Fin 3 → ℝ) (i : ℤ) :
    let U := fun x => linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time
    let WL := leveque03_riemannWave basis (old (i - 1)) (old i)
    let WR := leveque03_riemannWave basis (old i) (old (i + 1))
    let c := leveque04_uniformInterface origin width (i - 1) + speeds 2 * time
    HasJumpAt U c (old i - WL 2) (old i + WR 0) ↔ WL 2 ≠ 0 ∨ WR 0 ≠ 0 := by
  dsimp only
  rcases leveque04_threeWaveEvolution_contact_traces basis speeds origin width time
    hwidth htime hs0 hs1 hs12 hcontact old i with ⟨hl, hr, _, hdiff⟩
  rw [hasJumpAt_iff_trace_difference_ne_zero hl hr, hdiff]
  exact leveque04_threeWave_contact_wave_sum_ne_zero_iff basis _ _ _

end NumStability
