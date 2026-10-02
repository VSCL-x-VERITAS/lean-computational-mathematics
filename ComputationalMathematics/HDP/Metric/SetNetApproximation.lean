import ComputationalMathematics.HDP.Metric.NetApproximation

/-!
# Supremum bounds on arbitrary sphere nets

Set-valued counterparts of the finite-net maximum lemmas.  Keeping these
extensions in a separate module preserves the dependency closure of the
earlier finite-net API.
-/

noncomputable section

open Set

namespace NumStability.HDP.Metric

/-- An arbitrary set-valued `ε`-net controls the operator norm by the
supremum of the sampled action norms. -/
theorem sSup_action_norm_bounds_of_isUnitSphereNet
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup F] [NormedSpace ℝ F]
    (T : E →L[ℝ] F) (ε : ℝ) (N : Set E)
    (hε0 : 0 ≤ ε) (hε1 : ε < 1) (hN : IsUnitSphereNet ε N)
    (hNnonempty : N.Nonempty) :
    sSup {a : ℝ | ∃ y ∈ N, a = ‖T y‖} ≤ ‖T‖ ∧
      ‖T‖ ≤ (1 - ε)⁻¹ * sSup {a : ℝ | ∃ y ∈ N, a = ‖T y‖} := by
  let Q : Set ℝ := {a : ℝ | ∃ y ∈ N, a = ‖T y‖}
  have hQnonempty : Q.Nonempty := by
    obtain ⟨y, hyN⟩ := hNnonempty
    exact ⟨‖T y‖, y, hyN, rfl⟩
  have hQbdd : BddAbove Q := by
    refine ⟨‖T‖, ?_⟩
    rintro a ⟨y, hyN, rfl⟩
    calc
      ‖T y‖ ≤ ‖T‖ * ‖y‖ := ContinuousLinearMap.le_opNorm T y
      _ = ‖T‖ := by rw [hN.1 y hyN, mul_one]
  have hsample (y : E) (hyN : y ∈ N) : ‖T y‖ ≤ sSup Q :=
    le_csSup hQbdd ⟨y, hyN, rfl⟩
  have hM0 : 0 ≤ sSup Q := by
    obtain ⟨y, hyN⟩ := hNnonempty
    exact (norm_nonneg (T y)).trans (hsample y hyN)
  constructor
  · apply csSup_le hQnonempty
    rintro a ⟨y, hyN, rfl⟩
    calc
      ‖T y‖ ≤ ‖T‖ * ‖y‖ := ContinuousLinearMap.le_opNorm T y
      _ = ‖T‖ := by rw [hN.1 y hyN, mul_one]
  · have hcoarse : ‖T‖ ≤ sSup Q + ‖T‖ * ε := by
      apply ContinuousLinearMap.opNorm_le_bound T
      · positivity
      · intro x
        by_cases hx : x = 0
        · simp [hx]
        · let u : E := ‖x‖⁻¹ • x
          have hxnorm : ‖x‖ ≠ 0 := norm_ne_zero_iff.mpr hx
          have hu : ‖u‖ = 1 := by simp [u, norm_smul, hxnorm]
          obtain ⟨z, hzN, huz⟩ := hN.2 u hu
          have hTu : ‖T u‖ ≤ sSup Q + ‖T‖ * ε := by
            calc
              ‖T u‖ = ‖T z + T (u - z)‖ := by
                congr 1
                rw [map_sub]
                abel
              _ ≤ ‖T z‖ + ‖T (u - z)‖ := norm_add_le _ _
              _ ≤ sSup Q + ‖T‖ * ‖u - z‖ := by
                gcongr
                · exact hsample z hzN
                · exact ContinuousLinearMap.le_opNorm T (u - z)
              _ ≤ sSup Q + ‖T‖ * ε := by gcongr
          have hxrepr : x = ‖x‖ • u := by simp [u, hxnorm]
          calc
            ‖T x‖ = ‖T (‖x‖ • u)‖ :=
              congrArg (fun q : E ↦ ‖T q‖) hxrepr
            _ = ‖x‖ * ‖T u‖ := by
              rw [map_smul, norm_smul]
              simp
            _ ≤ ‖x‖ * (sSup Q + ‖T‖ * ε) :=
              mul_le_mul_of_nonneg_left hTu (norm_nonneg x)
            _ = (sSup Q + ‖T‖ * ε) * ‖x‖ := by ring
    have hden : 0 < 1 - ε := sub_pos.mpr hε1
    change ‖T‖ ≤ (1 - ε)⁻¹ * sSup Q
    rw [inv_mul_eq_div]
    exact (le_div_iff₀ hden).2 (by nlinarith)

/-- An arbitrary set-valued `ε`-net controls a vector norm by the supremum
of its sampled inner products. -/
theorem sSup_inner_bounds_of_isUnitSphereNet
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (x : E) (ε : ℝ) (N : Set E)
    (_hε0 : 0 ≤ ε) (hε1 : ε < 1) (hN : IsUnitSphereNet ε N)
    (hNnonempty : N.Nonempty) :
    sSup {a : ℝ | ∃ y ∈ N, a = inner ℝ x y} ≤ ‖x‖ ∧
      ‖x‖ ≤ (1 - ε)⁻¹ * sSup {a : ℝ | ∃ y ∈ N, a = inner ℝ x y} := by
  let Q : Set ℝ := {a : ℝ | ∃ y ∈ N, a = inner ℝ x y}
  have hQnonempty : Q.Nonempty := by
    obtain ⟨y, hyN⟩ := hNnonempty
    exact ⟨inner ℝ x y, y, hyN, rfl⟩
  have hQbdd : BddAbove Q := by
    refine ⟨‖x‖, ?_⟩
    rintro a ⟨y, hyN, rfl⟩
    calc
      inner ℝ x y ≤ |inner ℝ x y| := le_abs_self _
      _ ≤ ‖x‖ * ‖y‖ := abs_real_inner_le_norm x y
      _ = ‖x‖ := by rw [hN.1 y hyN, mul_one]
  have hsample (y : E) (hyN : y ∈ N) : inner ℝ x y ≤ sSup Q :=
    le_csSup hQbdd ⟨y, hyN, rfl⟩
  constructor
  · apply csSup_le hQnonempty
    rintro a ⟨y, hyN, rfl⟩
    calc
      inner ℝ x y ≤ |inner ℝ x y| := le_abs_self _
      _ ≤ ‖x‖ * ‖y‖ := abs_real_inner_le_norm x y
      _ = ‖x‖ := by rw [hN.1 y hyN, mul_one]
  · by_cases hx : x = 0
    · obtain ⟨y, hyN⟩ := hNnonempty
      have hzero : (0 : ℝ) ≤ sSup Q := by
        simpa [hx] using hsample y hyN
      have hprod :=
        mul_nonneg (le_of_lt (inv_pos.mpr (sub_pos.mpr hε1))) hzero
      simpa only [hx, norm_zero, Q] using hprod
    · let u : E := ‖x‖⁻¹ • x
      have hxnorm : ‖x‖ ≠ 0 := norm_ne_zero_iff.mpr hx
      have hu : ‖u‖ = 1 := by simp [u, norm_smul, hxnorm]
      obtain ⟨z, hzN, huz⟩ := hN.2 u hu
      have hinner_u : inner ℝ x u = ‖x‖ := by
        rw [show u = ‖x‖⁻¹ • x by rfl, real_inner_smul_right,
          real_inner_self_eq_norm_sq]
        field_simp
      have herror : |inner ℝ x u - inner ℝ x z| ≤ ‖x‖ * ε := by
        calc
          |inner ℝ x u - inner ℝ x z| = |inner ℝ x (u - z)| := by
            rw [inner_sub_right]
          _ ≤ ‖x‖ * ‖u - z‖ := abs_real_inner_le_norm x (u - z)
          _ ≤ ‖x‖ * ε := mul_le_mul_of_nonneg_left huz (norm_nonneg x)
      have hcoarse : ‖x‖ ≤ sSup Q + ‖x‖ * ε := by
        have hdiff : inner ℝ x u - inner ℝ x z ≤ ‖x‖ * ε :=
          (le_abs_self (inner ℝ x u - inner ℝ x z)).trans herror
        rw [hinner_u] at hdiff
        linarith [hsample z hzN]
      have hden : 0 < 1 - ε := sub_pos.mpr hε1
      change ‖x‖ ≤ (1 - ε)⁻¹ * sSup Q
      rw [inv_mul_eq_div]
      exact (le_div_iff₀ hden).2 (by nlinarith)

end NumStability.HDP.Metric
