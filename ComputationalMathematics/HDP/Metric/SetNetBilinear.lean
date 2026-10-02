import ComputationalMathematics.HDP.Metric.SetNetApproximation

/-!
# Bilinear and quadratic bounds on arbitrary sphere nets
-/

noncomputable section

open Set

namespace NumStability.HDP.Metric

/-- Two arbitrary set-valued `ε`-nets control a real operator norm through
the supremum of sampled bilinear forms. -/
theorem sSup_bilinear_bounds_of_isUnitSphereNet
    {E F : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    [NormedAddCommGroup F] [InnerProductSpace ℝ F]
    (T : E →L[ℝ] F) (ε : ℝ) (N : Set E) (M : Set F)
    (hε0 : 0 ≤ ε) (hεhalf : ε < 1 / 2)
    (hN : IsUnitSphereNet ε N) (hM : IsUnitSphereNet ε M)
    (hNnonempty : N.Nonempty) (hMnonempty : M.Nonempty) :
    sSup {a : ℝ | ∃ x ∈ N, ∃ y ∈ M, a = inner ℝ (T x) y} ≤ ‖T‖ ∧
      ‖T‖ ≤ (1 - 2 * ε)⁻¹ *
        sSup {a : ℝ | ∃ x ∈ N, ∃ y ∈ M, a = inner ℝ (T x) y} := by
  let Q : Set ℝ := {a : ℝ | ∃ x ∈ N, ∃ y ∈ M, a = inner ℝ (T x) y}
  have hQnonempty : Q.Nonempty := by
    obtain ⟨x, hxN⟩ := hNnonempty
    obtain ⟨y, hyM⟩ := hMnonempty
    exact ⟨inner ℝ (T x) y, x, hxN, y, hyM, rfl⟩
  have hQbdd : BddAbove Q := by
    refine ⟨‖T‖, ?_⟩
    rintro a ⟨x, hxN, y, hyM, rfl⟩
    calc
      inner ℝ (T x) y ≤ |inner ℝ (T x) y| := le_abs_self _
      _ ≤ ‖T x‖ * ‖y‖ := abs_real_inner_le_norm _ _
      _ = ‖T x‖ := by rw [hM.1 y hyM, mul_one]
      _ ≤ ‖T‖ * ‖x‖ := ContinuousLinearMap.le_opNorm T x
      _ = ‖T‖ := by rw [hN.1 x hxN, mul_one]
  have hsample (x : E) (hxN : x ∈ N) (y : F) (hyM : y ∈ M) :
      inner ℝ (T x) y ≤ sSup Q :=
    le_csSup hQbdd ⟨x, hxN, y, hyM, rfl⟩
  have hQ0 : 0 ≤ sSup Q := by
    obtain ⟨x, hxN⟩ := hNnonempty
    by_cases hTx : T x = 0
    · obtain ⟨y, hyM⟩ := hMnonempty
      simpa [hTx] using hsample x hxN y hyM
    · let v : F := ‖T x‖⁻¹ • T x
      have hTxnorm : ‖T x‖ ≠ 0 := norm_ne_zero_iff.mpr hTx
      have hv : ‖v‖ = 1 := by simp [v, norm_smul, hTxnorm]
      obtain ⟨y, hyM, hvy⟩ := hM.2 v hv
      have hinner : inner ℝ (T x) v = ‖T x‖ := by
        rw [show v = ‖T x‖⁻¹ • T x by rfl, real_inner_smul_right,
          real_inner_self_eq_norm_sq]
        field_simp
      have herror : inner ℝ (T x) (v - y) ≤ ‖T x‖ * ε := by
        calc
          inner ℝ (T x) (v - y) ≤ |inner ℝ (T x) (v - y)| := le_abs_self _
          _ ≤ ‖T x‖ * ‖v - y‖ := abs_real_inner_le_norm _ _
          _ ≤ ‖T x‖ * ε := mul_le_mul_of_nonneg_left hvy (norm_nonneg _)
      have hdecomp : inner ℝ (T x) v - inner ℝ (T x) y =
          inner ℝ (T x) (v - y) := by rw [inner_sub_right]
      have hy0 : 0 ≤ inner ℝ (T x) y := by
        have hε1 : ε < 1 := hεhalf.trans (by norm_num)
        rw [hinner] at hdecomp
        nlinarith [norm_pos_iff.mpr hTx]
      exact hy0.trans (hsample x hxN y hyM)
  constructor
  · apply csSup_le hQnonempty
    rintro a ⟨x, hxN, y, hyM, rfl⟩
    calc
      inner ℝ (T x) y ≤ |inner ℝ (T x) y| := le_abs_self _
      _ ≤ ‖T x‖ * ‖y‖ := abs_real_inner_le_norm _ _
      _ = ‖T x‖ := by rw [hM.1 y hyM, mul_one]
      _ ≤ ‖T‖ * ‖x‖ := ContinuousLinearMap.le_opNorm T x
      _ = ‖T‖ := by rw [hN.1 x hxN, mul_one]
  · have hcoarse : ‖T‖ ≤ sSup Q + 2 * ‖T‖ * ε := by
      apply ContinuousLinearMap.opNorm_le_bound T
      · positivity
      · intro z
        by_cases hz : z = 0
        · subst z
          simp
        · let u : E := ‖z‖⁻¹ • z
          have hznorm : ‖z‖ ≠ 0 := norm_ne_zero_iff.mpr hz
          have hu : ‖u‖ = 1 := by simp [u, norm_smul, hznorm]
          obtain ⟨x, hxN, hux⟩ := hN.2 u hu
          by_cases hTu : T u = 0
          · have hzrepr : z = ‖z‖ • u := by simp [u, hznorm]
            rw [hzrepr, map_smul, hTu, smul_zero, norm_zero]
            positivity
          · let v : F := ‖T u‖⁻¹ • T u
            have hTunorm : ‖T u‖ ≠ 0 := norm_ne_zero_iff.mpr hTu
            have hv : ‖v‖ = 1 := by simp [v, norm_smul, hTunorm]
            obtain ⟨y, hyM, hvy⟩ := hM.2 v hv
            have hinner : inner ℝ (T u) v = ‖T u‖ := by
              rw [show v = ‖T u‖⁻¹ • T u by rfl, real_inner_smul_right,
                real_inner_self_eq_norm_sq]
              field_simp
            have hfirst : inner ℝ (T u) (v - y) ≤ ‖T‖ * ε := by
              calc
                inner ℝ (T u) (v - y) ≤ |inner ℝ (T u) (v - y)| := le_abs_self _
                _ ≤ ‖T u‖ * ‖v - y‖ := abs_real_inner_le_norm _ _
                _ ≤ ‖T u‖ * ε :=
                  mul_le_mul_of_nonneg_left hvy (norm_nonneg _)
                _ ≤ (‖T‖ * ‖u‖) * ε :=
                  mul_le_mul_of_nonneg_right (ContinuousLinearMap.le_opNorm T u) hε0
                _ = ‖T‖ * ε := by rw [hu, mul_one]
            have hsecond : inner ℝ (T (u - x)) y ≤ ‖T‖ * ε := by
              calc
                inner ℝ (T (u - x)) y ≤ |inner ℝ (T (u - x)) y| := le_abs_self _
                _ ≤ ‖T (u - x)‖ * ‖y‖ := abs_real_inner_le_norm _ _
                _ = ‖T (u - x)‖ := by rw [hM.1 y hyM, mul_one]
                _ ≤ ‖T‖ * ‖u - x‖ := ContinuousLinearMap.le_opNorm T (u - x)
                _ ≤ ‖T‖ * ε := mul_le_mul_of_nonneg_left hux (norm_nonneg _)
            have hdecomp :
                inner ℝ (T u) v - inner ℝ (T x) y =
                  inner ℝ (T u) (v - y) + inner ℝ (T (u - x)) y := by
              rw [inner_sub_right, map_sub, inner_sub_left]
              ring
            have hunit : ‖T u‖ ≤ sSup Q + 2 * ‖T‖ * ε := by
              rw [← hinner]
              nlinarith [hsample x hxN y hyM]
            have hzrepr : z = ‖z‖ • u := by simp [u, hznorm]
            calc
              ‖T z‖ = ‖T (‖z‖ • u)‖ := congrArg (fun q : E ↦ ‖T q‖) hzrepr
              _ = ‖z‖ * ‖T u‖ := by
                rw [map_smul, norm_smul, Real.norm_eq_abs,
                  abs_of_nonneg (norm_nonneg z)]
              _ ≤ ‖z‖ * (sSup Q + 2 * ‖T‖ * ε) :=
                mul_le_mul_of_nonneg_left hunit (norm_nonneg z)
              _ = (sSup Q + 2 * ‖T‖ * ε) * ‖z‖ := by ring
    have hden : 0 < 1 - 2 * ε := by linarith
    change ‖T‖ ≤ (1 - 2 * ε)⁻¹ * sSup Q
    rw [inv_mul_eq_div]
    exact (le_div_iff₀ hden).2 (by nlinarith)

/-- An arbitrary set-valued `ε`-net controls an attained absolute quadratic
operator norm, with the source's `(1 - 2ε)⁻¹` factor. -/
theorem sSup_quadratic_abs_bounds_of_isUnitSphereNet
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (T : E →L[ℝ] E) (ε : ℝ) (N : Set E)
    (hε0 : 0 ≤ ε) (hεhalf : ε < 1 / 2)
    (hN : IsUnitSphereNet ε N) (hNnonempty : N.Nonempty)
    (hattain : ∃ u : E, ‖u‖ = 1 ∧ ‖T‖ ≤ |inner ℝ (T u) u|) :
    sSup {a : ℝ | ∃ x ∈ N, a = |inner ℝ (T x) x|} ≤ ‖T‖ ∧
      ‖T‖ ≤ (1 - 2 * ε)⁻¹ *
        sSup {a : ℝ | ∃ x ∈ N, a = |inner ℝ (T x) x|} := by
  let Q : Set ℝ := {a : ℝ | ∃ x ∈ N, a = |inner ℝ (T x) x|}
  have hQnonempty : Q.Nonempty := by
    obtain ⟨x, hxN⟩ := hNnonempty
    exact ⟨|inner ℝ (T x) x|, x, hxN, rfl⟩
  have hlower : sSup Q ≤ ‖T‖ := by
    apply csSup_le hQnonempty
    rintro a ⟨x, hxN, rfl⟩
    calc
      |inner ℝ (T x) x| ≤ ‖T x‖ * ‖x‖ := abs_real_inner_le_norm _ _
      _ = ‖T x‖ := by rw [hN.1 x hxN, mul_one]
      _ ≤ ‖T‖ * ‖x‖ := ContinuousLinearMap.le_opNorm T x
      _ = ‖T‖ := by rw [hN.1 x hxN, mul_one]
  refine ⟨hlower, ?_⟩
  exact operatorNorm_le_inv_mul_sSup_quadratic_abs_of_isUnitSphereNet
    T ε N hε0 hεhalf hN hattain

end NumStability.HDP.Metric
