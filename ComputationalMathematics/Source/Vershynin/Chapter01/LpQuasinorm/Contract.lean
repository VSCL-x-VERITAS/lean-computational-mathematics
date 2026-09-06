import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-!
Cross-split stable API for `HDP-01-CLAIM-LP-QUASINORM`.

The source asserts failure of the triangle inequality for every exponent
`0 < p < 1`.  The two-point probability space supplies one uniform witness
family for the whole range.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- The original fixed-exponent Chapter 1 counterexample alias. -/
theorem hdp_01_hthm_hlp_hbanach_hquasinorm_counterexample :
    ∃ (μ : Measure (Fin 2)) (f g : Fin 2 → ℝ),
      IsProbabilityMeasure μ ∧
        ¬ eLpNorm (f + g) (1 / 2 : ENNReal) μ ≤
          eLpNorm f (1 / 2 : ENNReal) μ + eLpNorm g (1 / 2 : ENNReal) μ :=
  NumStability.HDP.Scalar.Preliminaries.twoPointLpTriangleFailure

/-- For every `0 < p < 1`, two disjoint singleton indicators on the uniform
two-point probability space violate the `L^p` triangle inequality. -/
theorem hdp_01_hclaim_hlp_hquasinorm_spec
    (p : ENNReal) (hp0 : 0 < p) (hp1 : p < 1) :
    ∃ (μ : Measure (Fin 2)) (f g : Fin 2 → ℝ),
      IsProbabilityMeasure μ ∧
        ¬ eLpNorm (f + g) p μ ≤ eLpNorm f p μ + eLpNorm g p μ := by
  let μ : Measure (Fin 2) := ProbabilityTheory.uniformOn Set.univ
  let f : Fin 2 → ℝ := Set.indicator ({0} : Set (Fin 2)) (fun _ => 1)
  let g : Fin 2 → ℝ := Set.indicator ({1} : Set (Fin 2)) (fun _ => 1)
  have hμ : IsProbabilityMeasure μ := by
    dsimp [μ]
    infer_instance
  have hμ0 : μ ({0} : Set (Fin 2)) = (1 / 2 : ENNReal) := by
    dsimp [μ]
    rw [ProbabilityTheory.uniformOn_univ]
    simp [Measure.count_apply]
  have hμ1 : μ ({1} : Set (Fin 2)) = (1 / 2 : ENNReal) := by
    dsimp [μ]
    rw [ProbabilityTheory.uniformOn_univ]
    simp [Measure.count_apply]
  have hp_ne_zero : p ≠ 0 := ne_of_gt hp0
  have hp_ne_top : p ≠ ⊤ := ne_of_lt (lt_of_lt_of_le hp1 le_top)
  have hp_toReal_pos : 0 < p.toReal := ENNReal.toReal_pos hp_ne_zero hp_ne_top
  have hp_toReal_lt_one : p.toReal < 1 := by
    simpa using (ENNReal.toReal_lt_toReal hp_ne_top ENNReal.one_ne_top).2 hp1
  have hexponent : 1 < 1 / p.toReal := one_lt_one_div hp_toReal_pos hp_toReal_lt_one
  refine ⟨μ, f, g, hμ, ?_⟩
  have hf : eLpNorm f p μ = (2 : ENNReal)⁻¹ ^ (1 / p.toReal) := by
    dsimp [f]
    rw [eLpNorm_indicator_const (s := ({0} : Set (Fin 2)))
      (c := (1 : ℝ)) (measurableSet_singleton (0 : Fin 2)) hp_ne_zero hp_ne_top]
    rw [hμ0]
    norm_num
  have hg : eLpNorm g p μ = (2 : ENNReal)⁻¹ ^ (1 / p.toReal) := by
    dsimp [g]
    rw [eLpNorm_indicator_const (s := ({1} : Set (Fin 2)))
      (c := (1 : ℝ)) (measurableSet_singleton (1 : Fin 2)) hp_ne_zero hp_ne_top]
    rw [hμ1]
    norm_num
  have hsum : f + g = (fun _ : Fin 2 => (1 : ℝ)) := by
    funext x
    fin_cases x <;> simp [f, g]
  rw [hsum, eLpNorm_const _ hp_ne_zero (by simp [μ]), hf, hg]
  simp [hμ.measure_univ]
  have hhalf : (2 : ENNReal)⁻¹ ^ (1 / p.toReal) < (2 : ENNReal)⁻¹ := by
    have := ENNReal.rpow_lt_rpow_of_exponent_gt
      (x := (2 : ENNReal)⁻¹) (y := 1 / p.toReal) (z := 1)
      (by norm_num) ENNReal.one_half_lt_one hexponent
    simpa using this
  calc
    (2 : ENNReal)⁻¹ ^ p.toReal⁻¹ + 2⁻¹ ^ p.toReal⁻¹ < 2⁻¹ + 2⁻¹ :=
      ENNReal.add_lt_add (by simpa [one_div] using hhalf) (by simpa [one_div] using hhalf)
    _ = 1 := ENNReal.inv_two_add_inv_two

end NumStability.HDP.Contract
