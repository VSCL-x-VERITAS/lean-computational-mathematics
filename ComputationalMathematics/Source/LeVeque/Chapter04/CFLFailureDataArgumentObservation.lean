/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CFLFailureDataArgumentObservationTarget

/-!
# The fixed-observation initial-data obstruction

The fixed cutoff supplied by the missed-cone construction works for either
speed sign. Locality compares two actual evolutions, without requiring the
arbitrary three-state update to preserve zero. Their transported cell means
are eventually distinct constants, so their actual errors cannot both vanish.
-/

namespace NumStability
open Set Filter
open scoped Topology

private theorem cflObservation_approximation_eq_of_eqOn
    (F : ℕ → ℕ → ℤ → (Fin 1 → ℝ) → (Fin 1 → ℝ) → (Fin 1 → ℝ) → Fin 1 → ℝ)
    (X T ratio : ℝ) (f g : ℝ → ℝ) (n : ℕ)
    (hw : 0 < fixedRatioRefinementCellWidth T ratio n)
    (hagree : EqOn f g
      (Icc (X - ((n + 1 : ℕ) : ℝ) * fixedRatioRefinementCellWidth T ratio n)
        (X + fixedRatioRefinementCellWidth T ratio n +
          ((n + 1 : ℕ) : ℝ) * fixedRatioRefinementCellWidth T ratio n))) :
    leveque04_cflPhysicalApproximation F X T ratio f n 0 =
      leveque04_cflPhysicalApproximation F X T ratio g n 0 := by
  unfold leveque04_cflPhysicalApproximation
  apply centeredStencilEvolution_threePoint_locality (F n)
  intro j hj
  simp only [zero_sub, zero_add] at hj
  have hlo : -((n + 1 : ℕ) : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj.1
  have hhi : (j : ℝ) ≤ ((n + 1 : ℕ) : ℝ) := by exact_mod_cast hj.2
  have hml := mul_le_mul_of_nonneg_right hlo hw.le
  have hmr := mul_le_mul_of_nonneg_right hhi hw.le
  unfold oneDimensionalCellAverage
  congr 1
  apply intervalIntegral.integral_congr
  intro x hx
  rw [uIcc_of_le (by nlinarith :
    X + (j : ℝ) * fixedRatioRefinementCellWidth T ratio n ≤
      X + ((j : ℝ) + 1) * fixedRatioRefinementCellWidth T ratio n)] at hx
  funext p
  apply hagree
  constructor <;> nlinarith [hx.1, hx.2, hml, hmr]

/-- The exact reviewed fixed-observation form of the printed data-change argument. -/
theorem leveque04_cflFailureDataArgumentObservation :
    Leveque04CFLFailureDataArgumentObservationTarget := by
  intro F speed X T ratio hT hratio hmiss
  dsimp only
  let width := fixedRatioRefinementCellWidth T ratio
  let dt := fun n : ℕ => T / ((n + 1 : ℕ) : ℝ)
  let approximation := fun (profile : ℝ → ℝ) (n : ℕ) =>
    leveque04_cflPhysicalApproximation F X T ratio profile n 0
  let reference := fun (profile : ℝ → ℝ) (n : ℕ) =>
    leveque04_cflPhysicalReference speed X T ratio profile n 0
  let error := fun (profile : ℝ → ℝ) (n : ℕ) =>
    leveque04_cflPhysicalError F speed X T ratio profile n 0
  have hmesh (n : ℕ) :
      0 < width n ∧ 0 < dt n ∧ ((n + 1 : ℕ) : ℝ) * dt n = T ∧
        dt n / width n = ratio := by
    have hn : 0 < ((n + 1 : ℕ) : ℝ) := by positivity
    refine ⟨div_pos hT (mul_pos hratio hn), div_pos hT hn, ?_, ?_⟩
    · dsimp [dt]
      field_simp
    · dsimp [dt, width, fixedRatioRefinementCellWidth]
      field_simp [hT.ne', hratio.ne', hn.ne']
  have hwlim : Tendsto width atTop (𝓝 0) := by
    have hhalf : Tendsto (fun n : ℕ => width n / 2) atTop (𝓝 0) := by
      simpa only [width, fixedRatioRefinementCellWidth, Nat.cast_zero,
        mul_zero, zero_mul, zero_add, zero_div] using
        fixedRatioRefinement_cellConeRadius_tendsto T ratio 0 hratio
    simpa only [div_mul_cancel₀ _ (by norm_num : (2 : ℝ) ≠ 0), zero_mul]
      using hhalf.mul_const 2
  have hdtlim : Tendsto dt atTop (𝓝 0) := by
    simpa only [dt, Nat.cast_add, Nat.cast_one, div_eq_mul_inv, one_mul, mul_zero]
      using (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ)).const_mul T
  obtain ⟨cutoff, hrIn, _hrOut, hsmall, hwindow⟩ :=
    exists_advection_missedCone_cellAverage_window speed X T ratio 1 hT hratio
      (by simpa using hmiss)
  simp only [Nat.cast_one, one_mul, mul_one] at hrIn hsmall hwindow
  let gap : ℝ := |speed| * T - T / ratio
  have hgap : 0 < gap := by
    have h := cutoff.rIn_pos
    rw [hrIn] at h
    change 0 < gap / 4 at h
    linarith
  have hone : cutoff (X - speed * T) = 1 := by
    apply cutoff.one_of_mem_closedBall
    rw [Metric.mem_closedBall, dist_self]
    exact cutoff.rIn_pos.le
  let zero : ℝ → ℝ := fun _ => 0
  have hc : Continuous (cutoff : ℝ → ℝ) :=
    (cutoff.contDiff : ContDiff ℝ 1 (cutoff : ℝ → ℝ)).continuous
  have hcont0 : Continuous (fun x (_ : Fin 1) => travelingWave zero speed x T) := by
    simpa only [travelingWave, zero] using
      (continuous_const : Continuous (fun _ : ℝ => (0 : Fin 1 → ℝ)))
  have hcont1 : Continuous (fun x (_ : Fin 1) =>
      travelingWave (cutoff : ℝ → ℝ) speed x T) := by
    apply continuous_pi
    intro p
    exact hc.comp (continuous_id.sub continuous_const)
  have hdata : ∀ᶠ n : ℕ in atTop,
      EqOn zero (cutoff : ℝ → ℝ)
        (Icc (X - ((n + 1 : ℕ) : ℝ) * width n)
          (X + width n + ((n + 1 : ℕ) : ℝ) * width n)) ∧
      approximation zero n = approximation cutoff n ∧
      reference zero n = (fun _ : Fin 1 => (0 : ℝ)) ∧
      reference cutoff n = (fun _ : Fin 1 => (1 : ℝ)) := by
    filter_upwards [hsmall] with n hn
    have hmem : (0 : ℤ) ∈ translatedMeshWindow
        (X - gap / 16) (X + gap / 16) X (width n) := by
      apply (mem_translatedMeshWindow_iff _ _ _ _ (hmesh n).1 0).mpr
      simp only [Int.cast_zero, zero_mul, add_zero]
      constructor <;> linarith
    obtain ⟨hcone, hmean0, hmean1⟩ := hwindow n hn 0 hmem
    simp only [Int.cast_zero, zero_mul, add_zero, zero_add, one_mul] at hcone hmean0 hmean1
    refine ⟨hcone, cflObservation_approximation_eq_of_eqOn F X T ratio
      zero cutoff n (hmesh n).1 hcone, ?_, ?_⟩
    · funext p
      dsimp [reference, leveque04_cflPhysicalReference]
      rw [oneDimensionalCellAverage_apply
        (fun x (_ : Fin 1) => travelingWave zero speed x T) _ _
        (hcont0.intervalIntegrable _ _) p]
      simpa only [zero, travelingWave, Int.cast_zero, zero_mul, add_zero,
        zero_add, one_mul] using hmean0
    · funext p
      dsimp [reference, leveque04_cflPhysicalReference]
      rw [oneDimensionalCellAverage_apply
        (fun x (_ : Fin 1) => travelingWave (cutoff : ℝ → ℝ) speed x T) _ _
        (hcont1.intervalIntegrable _ _) p]
      simpa only [travelingWave, Int.cast_zero, zero_mul, add_zero,
        zero_add, one_mul] using hmean1
  have hr0 : Tendsto (reference zero) atTop (𝓝 (0 : Fin 1 → ℝ)) :=
    tendsto_const_nhds.congr' (hdata.mono fun _ hn => hn.2.2.1.symm)
  have hr1 : Tendsto (reference cutoff) atTop (𝓝 (fun _ : Fin 1 => (1 : ℝ))) :=
    tendsto_const_nhds.congr' (hdata.mono fun _ hn => hn.2.2.2.symm)
  have hbad : ¬ (Tendsto (error zero) atTop (𝓝 0) ∧
      Tendsto (error cutoff) atTop (𝓝 0)) := by
    rintro ⟨he0, he1⟩
    have hd0 : Tendsto (fun n => error zero n - error cutoff n) atTop (𝓝 0) := by
      simpa only [sub_zero] using he0.sub he1
    have hd1 : Tendsto (fun n => error zero n - error cutoff n) atTop
        (𝓝 (fun _ : Fin 1 => (1 : ℝ))) := by
      apply tendsto_const_nhds.congr'
      filter_upwards [hdata] with n hn
      change (fun _ : Fin 1 => (1 : ℝ)) =
        (approximation zero n - reference zero n) -
          (approximation cutoff n - reference cutoff n)
      rw [hn.2.2.1, hn.2.2.2, hn.2.1]
      funext p
      simp only [Pi.sub_apply]
      ring
    have h := congrFun (tendsto_nhds_unique hd0 hd1) (0 : Fin 1)
    norm_num at h
  refine ⟨hmesh, hwlim, hdtlim, ?_, ?_⟩
  · refine ⟨zero, cutoff, continuous_const, hc, ?_,
      hdata.mono (fun _ hn => ⟨hn.1, hn.2.1⟩), ?_, ?_, hbad⟩
    · simpa only [zero, hone] using (zero_ne_one : (0 : ℝ) ≠ 1)
    · exact hr0
    · simpa only [hone] using hr1
  · intro hall
    exact hbad ⟨hall zero continuous_const, hall cutoff hc⟩

end NumStability
