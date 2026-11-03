/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ThreeWaveLocationsTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearNoninteractingFan
import ComputationalMathematics.Source.LeVeque.Chapter04.ThreeWaveInteriorLocations
import ComputationalMathematics.Source.LeVeque.Chapter04.UniformWaveFrontLocalFiniteness

/-!
# Three-wave locations for the actual characteristic Cauchy field

This assembles the initial-value, conservation, finite-assembly, global-front,
local-field, separated-front and contact results for the same arbitrary cell
data. The local displacement and separation conditions apply only to their
respective conclusions. Vanishing waves and arbitrarily large elapsed times
remain in the global statement.
-/

open Filter Set
open scoped Topology BigOperators

namespace NumStability

/-- The complete three-family location specification, with the actual Cauchy
field and its physical averages, traces and active discontinuities. -/
theorem leveque04_threeWaveLocations : Leveque04ThreeWaveLocationsTarget := by
  classical
  intro coefficient basis speeds heigen hs0 hs1 hs12 old origin width hwidth
  dsimp only
  have hcauchy := leveque04_linearRiemannChain_exactCauchy
    coefficient basis speeds heigen old origin width 0 hwidth (le_refl 0)
  refine ⟨hcauchy.1, hcauchy.2.1, ?_, ?_, ?_⟩
  · intro i
    exact leveque04_uniformReconstruction_cellAverage origin width hwidth old i
  · intro horizon hhorizon
    refine ⟨?_, ?_⟩
    · intro time htime x
      exact leveque04_linearRiemannChainEvolution_eq_characteristicCauchy
        basis speeds old origin width horizon hwidth hhorizon.le x time htime
    · intro hspread time htime j
      have hs01 : speeds 0 ≤ speeds 1 := le_of_lt (lt_trans hs0 hs1)
      have hspread_time : (speeds 2 - speeds 0) * time ≤ width :=
        (mul_le_mul_of_nonneg_left htime.2 (by linarith)).trans hspread
      exact ⟨fun x hx => leveque04_threeWaveEvolution_fan_eq_riemann
        basis speeds origin width time hwidth htime.1 hs01 hs12.le
        hspread_time old j x hx,
        fun x hx => leveque04_threeWaveEvolution_gap_eq_state
          basis speeds origin width time hwidth htime.1 hs01 hs12.le old j x hx⟩
  · intro time htime
    refine ⟨?_, ?_, ?_⟩
    · intro z
      have hzero := leveque04_uniformModalFrontJump_sum_eq_zero_iff_waves
        basis speeds origin width hwidth old time z
      have hcontinuous := leveque04_linearUniformEvolution_continuousAt_iff
        basis speeds origin width hwidth old time z
      refine ⟨?_, leveque04_uniformWaveFrontPairs_card_le speeds origin width time z,
        ?_, ?_, leveque04_uniformWaveFrontPairs_sum_waves
          basis speeds origin width old time z,
        leveque04_linearUniformEvolution_tendsto_left_at
          basis speeds origin width hwidth old time z,
        leveque04_linearUniformEvolution_tendsto_right_at
          basis speeds origin width hwidth old time z,
        by abel, hzero, ?_, ?_⟩
      · intro p j
        exact leveque04_uniformWaveFrontPairs_mem_iff speeds origin width time z hwidth p j
      · intro p j k hj hk
        have hpairs : (p, j) = (p, k) :=
          leveque04_uniformWaveFrontPairs_fst_injOn speeds origin width time z
            ((leveque04_uniformWaveFrontPairs_mem_iff
              speeds origin width time z hwidth p j).2 hj)
            ((leveque04_uniformWaveFrontPairs_mem_iff
              speeds origin width time z hwidth p k).2 hk) rfl
        exact congrArg Prod.snd hpairs
      · intro p j hj
        exact leveque04_uniformModalFrontJump_eq_wave_of_front
          basis speeds origin width hwidth old time z p j hj
      · simpa using not_congr (hcontinuous.trans hzero.symm)
      · exact leveque04_linearUniformEvolution_not_continuousAt_iff
          basis speeds origin width hwidth old time z
    · intro lower upper
      apply leveque04_uniformWaveFrontSubset_finite_inter_Icc
        speeds origin width time lower upper hwidth
      intro z hz
      obtain ⟨p, j, hj, _⟩ :=
        (leveque04_linearUniformEvolution_not_continuousAt_iff
          basis speeds origin width hwidth old time z).1 hz
      exact ⟨p, j, hj⟩
    · intro i
      refine ⟨?_, leveque04_threeWaveEvolution_strict_separation_iff
        speeds origin width time htime hs0 hs1 hs12 i, ?_, ?_⟩
      · intro hcfl
        refine ⟨?_, ?_⟩
        · intro x hx
          simpa only [sub_add_cancel] using leveque04_threeWaveEvolution_formula
            basis speeds origin width time hwidth htime hs0 hs1 hs12 hcfl old i x hx
        · intro z
          constructor
          · rintro ⟨hz, hcell⟩
            refine ⟨hcell, ?_⟩
            simpa only [sub_add_cancel] using
              (leveque04_threeWaveEvolution_interior_not_continuousAt_iff
              basis speeds origin width time hwidth htime hs0 hs1 hs12 hcfl
              old i z hcell).1 hz
          · rintro ⟨hcell, hz⟩
            exact ⟨(leveque04_threeWaveEvolution_interior_not_continuousAt_iff
              basis speeds origin width time hwidth htime hs0 hs1 hs12 hcfl
              old i z hcell).2 (by simpa only [sub_add_cancel] using hz), hcell⟩
      · intro hsep
        have hcfl := leveque04_threeWaveEvolution_cfl_of_spread_le
          speeds width time htime hs0 hs1 hs12 hsep.le
        obtain ⟨r1, r2, r3, r4⟩ := leveque04_threeWaveEvolution_open_regions
          basis speeds origin width time hwidth htime hs0 hs1 hs12 hcfl hsep old i
        obtain ⟨⟨hl1, hr1, hp1⟩, ⟨hl2, hr2, hp2⟩, ⟨hl0, hr0, hp0⟩⟩ :=
          leveque04_threeWaveEvolution_strict_traces
            basis speeds origin width time hwidth htime hs0 hs1 hs12 hsep old i
        obtain ⟨ha1, ha2, ha0⟩ := leveque04_threeWaveEvolution_strict_active_iff
          basis speeds origin width time hwidth htime hs0 hs1 hs12 hsep old i
        simpa only [sub_add_cancel] using
          ⟨r1, r2, r3, r4, hl1, hr1, hp1, hl2, hr2, hp2, hl0, hr0, hp0,
            ha1, ha2, ha0, leveque04_threeWaveEvolution_strict_interior_ncard_eq_three_iff
              basis speeds origin width time hwidth htime hs0 hs1 hs12 hsep old i⟩
      · intro hcontact
        obtain ⟨hcfl, ha1, h12, h20, h0b⟩ := leveque04_threeWaveEvolution_contact_geometry
          speeds origin width time hwidth htime hs0 hs1 hs12 hcontact i
        obtain ⟨hl, hr, hp, hdiff⟩ := leveque04_threeWaveEvolution_contact_traces
          basis speeds origin width time hwidth htime hs0 hs1 hs12 hcontact old i
        have hfirst := leveque04_threeWaveEvolution_interior_not_continuousAt_iff
          basis speeds origin width time hwidth htime hs0 hs1 hs12 hcfl old i
          (leveque04_uniformInterface origin width (i - 1) + speeds 1 * time)
          ⟨ha1, by linarith⟩
        have hsecond := leveque04_threeWaveEvolution_interior_not_continuousAt_iff
          basis speeds origin width time hwidth htime hs0 hs1 hs12 hcfl old i
          (leveque04_uniformInterface origin width (i - 1) + speeds 2 * time)
          ⟨by linarith, by linarith⟩
        have h10 : leveque04_uniformInterface origin width (i - 1) + speeds 1 * time ≠
            leveque04_uniformInterface origin width i + speeds 0 * time := by
          linarith
        have hfirst_active :
            ¬ ContinuousAt (fun x => linearCharacteristicEvolution basis speeds
              (leveque04_uniformReconstruction origin width old) x time)
              (leveque04_uniformInterface origin width (i - 1) + speeds 1 * time) ↔
            leveque03_riemannWave basis (old (i - 1)) (old i) 1 ≠ 0 := by
          simpa only [h12.ne, h10, false_and, true_and, or_false, eq_self_iff_true]
            using hfirst
        have hsecond_active :
            ¬ ContinuousAt (fun x => linearCharacteristicEvolution basis speeds
              (leveque04_uniformReconstruction origin width old) x time)
              (leveque04_uniformInterface origin width (i - 1) + speeds 2 * time) ↔
            leveque03_riemannWave basis (old (i - 1)) (old i) 2 ≠ 0 ∨
              leveque03_riemannWave basis (old i) (old (i + 1)) 0 ≠ 0 := by
          simpa only [h12.ne', h20, h10.symm, false_and, true_and, false_or, eq_self_iff_true]
            using hsecond
        simpa only [sub_add_cancel] using
          ⟨hcfl, ha1, h12, h20, h0b, by simp only [h20, Ioo_self],
            hl, hr, hp, hdiff,
            leveque04_threeWave_contact_wave_sum_eq_zero_iff basis (old (i - 1)) (old i)
              (old (i + 1)),
            leveque04_threeWave_contact_wave_sum_ne_zero_iff basis (old (i - 1)) (old i)
              (old (i + 1)),
            leveque04_threeWaveEvolution_contact_active_iff
              basis speeds origin width time hwidth htime hs0 hs1 hs12 hcontact old i,
            hfirst_active, hsecond_active,
            leveque04_threeWaveEvolution_contact_interior_ncard_le_two
              basis speeds origin width time hwidth htime hs0 hs1 hs12 hcontact old i⟩

end NumStability
