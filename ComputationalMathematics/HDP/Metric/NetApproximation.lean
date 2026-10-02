import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Computing operator norms on finite sphere nets

This module contains the deterministic approximation argument that replaces a
supremum over a unit sphere by a maximum over a finite `ε`-net.
-/

noncomputable section

open Set

namespace NumStability.HDP.Metric

/-- `N` is a finite internal `ε`-net of the unit sphere of `E`. -/
def IsFiniteUnitSphereNet {E : Type*} [NormedAddCommGroup E]
    (ε : ℝ) (N : Finset E) : Prop :=
  (∀ y ∈ N, ‖y‖ = 1) ∧
    ∀ x : E, ‖x‖ = 1 → ∃ y ∈ N, ‖x - y‖ ≤ ε

/-- `N` is an arbitrary internal `ε`-net of the unit sphere of `E`.
Unlike `IsFiniteUnitSphereNet`, this is the literal set-level notion used by
the source statement of Exercise 4.4.4. -/
def IsUnitSphereNet {E : Type*} [NormedAddCommGroup E]
    (ε : ℝ) (N : Set E) : Prop :=
  (∀ y ∈ N, ‖y‖ = 1) ∧
    ∀ x : E, ‖x‖ = 1 → ∃ y ∈ N, ‖x - y‖ ≤ ε

/-- A continuous linear map is controlled by its largest value on a finite
`ε`-net of the unit sphere, with the sharp deterministic factor
`(1 - ε)⁻¹`. -/
theorem exists_net_action_max_bounds
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup F] [NormedSpace ℝ F]
    (T : E →L[ℝ] F) (ε : ℝ) (N : Finset E)
    (hε0 : 0 ≤ ε) (hε1 : ε < 1) (hN : IsFiniteUnitSphereNet ε N)
    (hNnonempty : N.Nonempty) :
    ∃ y ∈ N,
      (∀ z ∈ N, ‖T z‖ ≤ ‖T y‖) ∧
      ‖T y‖ ≤ ‖T‖ ∧
      ‖T‖ ≤ (1 - ε)⁻¹ * ‖T y‖ := by
  obtain ⟨y, hyN, hymax⟩ := Finset.exists_max_image N (fun z ↦ ‖T z‖) hNnonempty
  refine ⟨y, hyN, hymax, ?_, ?_⟩
  · simpa [hN.1 y hyN] using ContinuousLinearMap.le_opNorm T y
  · have hM : 0 ≤ ‖T y‖ := norm_nonneg _
    have hcoarse : ‖T‖ ≤ ‖T y‖ + ‖T‖ * ε := by
      apply ContinuousLinearMap.opNorm_le_bound T
      · positivity
      · intro x
        by_cases hx : x = 0
        · simp [hx]
        · let u : E := ‖x‖⁻¹ • x
          have hxnorm : ‖x‖ ≠ 0 := norm_ne_zero_iff.mpr hx
          have hu : ‖u‖ = 1 := by
            simp [u, norm_smul, hxnorm]
          obtain ⟨z, hzN, huz⟩ := hN.2 u hu
          have hTu : ‖T u‖ ≤ ‖T y‖ + ‖T‖ * ε := by
            calc
              ‖T u‖ = ‖T z + T (u - z)‖ := by
                congr 1
                rw [map_sub]
                abel
              _ ≤ ‖T z‖ + ‖T (u - z)‖ := norm_add_le _ _
              _ ≤ ‖T y‖ + ‖T‖ * ‖u - z‖ := by
                gcongr
                · exact hymax z hzN
                · exact ContinuousLinearMap.le_opNorm T (u - z)
              _ ≤ ‖T y‖ + ‖T‖ * ε := by
                gcongr
          have hxrepr : x = ‖x‖ • u := by
            simp [u, hxnorm]
          calc
            ‖T x‖ = ‖T (‖x‖ • u)‖ :=
              congrArg (fun q : E ↦ ‖T q‖) hxrepr
            _ = ‖x‖ * ‖T u‖ := by
              rw [map_smul, norm_smul]
              simp
            _ ≤ ‖x‖ * (‖T y‖ + ‖T‖ * ε) :=
              mul_le_mul_of_nonneg_left hTu (norm_nonneg x)
            _ = (‖T y‖ + ‖T‖ * ε) * ‖x‖ := by ring
    have hden : 0 < 1 - ε := sub_pos.mpr hε1
    rw [inv_mul_eq_div]
    exact (le_div_iff₀ hden).2 (by nlinarith)

/-- A vector norm is controlled by its largest inner product against a finite
`ε`-net of the unit sphere, with the same factor `(1 - ε)⁻¹`. -/
theorem exists_net_inner_max_bounds
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (x : E) (ε : ℝ) (N : Finset E)
    (hε0 : 0 ≤ ε) (hε1 : ε < 1) (hN : IsFiniteUnitSphereNet ε N)
    (hNnonempty : N.Nonempty) :
    ∃ y ∈ N,
      (∀ z ∈ N, inner ℝ x z ≤ inner ℝ x y) ∧
      inner ℝ x y ≤ ‖x‖ ∧
      ‖x‖ ≤ (1 - ε)⁻¹ * inner ℝ x y := by
  obtain ⟨y, hyN, hymax⟩ :=
    Finset.exists_max_image N (fun z ↦ inner ℝ x z) hNnonempty
  refine ⟨y, hyN, hymax, ?_, ?_⟩
  · calc
      inner ℝ x y ≤ |inner ℝ x y| := le_abs_self _
      _ ≤ ‖x‖ * ‖y‖ := abs_real_inner_le_norm x y
      _ = ‖x‖ := by rw [hN.1 y hyN, mul_one]
  · by_cases hx : x = 0
    · simp [hx]
    · let u : E := ‖x‖⁻¹ • x
      have hxnorm : ‖x‖ ≠ 0 := norm_ne_zero_iff.mpr hx
      have hu : ‖u‖ = 1 := by
        simp [u, norm_smul, hxnorm]
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
      have hcoarse : ‖x‖ ≤ inner ℝ x y + ‖x‖ * ε := by
        have hdiff : inner ℝ x u - inner ℝ x z ≤ ‖x‖ * ε :=
          (le_abs_self (inner ℝ x u - inner ℝ x z)).trans herror
        have hzle := hymax z hzN
        rw [hinner_u] at hdiff
        linarith
      have hden : 0 < 1 - ε := sub_pos.mpr hε1
      rw [inv_mul_eq_div]
      exact (le_div_iff₀ hden).2 (by nlinarith)

/-- On quarter-nets of the domain and codomain unit spheres, a real
continuous linear map is bounded by twice its largest sampled bilinear form. -/
theorem exists_quarter_net_bilinear_max_bound
    {E F : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    [NormedAddCommGroup F] [InnerProductSpace ℝ F]
    (T : E →L[ℝ] F) (N : Finset E) (M : Finset F)
    (hN : IsFiniteUnitSphereNet (1 / 4 : ℝ) N)
    (hM : IsFiniteUnitSphereNet (1 / 4 : ℝ) M)
    (hNnonempty : N.Nonempty) (hMnonempty : M.Nonempty) :
    ∃ x ∈ N, ∃ y ∈ M,
      (∀ u ∈ N, ∀ v ∈ M, inner ℝ (T u) v ≤ inner ℝ (T x) y) ∧
      ‖T‖ ≤ 2 * inner ℝ (T x) y := by
  have hprod : (N.product M).Nonempty := hNnonempty.product hMnonempty
  obtain ⟨p, hp, hpmax⟩ :=
    Finset.exists_max_image (N.product M)
      (fun p ↦ inner ℝ (T p.1) p.2) hprod
  have hpx : p.1 ∈ N := (Finset.mem_product.mp hp).1
  have hpy : p.2 ∈ M := (Finset.mem_product.mp hp).2
  refine ⟨p.1, hpx, p.2, hpy, ?_, ?_⟩
  · intro u hu v hv
    exact hpmax (u, v) (Finset.mem_product.mpr ⟨hu, hv⟩)
  · obtain ⟨x₀, hx₀N, _hx₀max, _hx₀lower, hx₀upper⟩ :=
      exists_net_action_max_bounds T (1 / 4 : ℝ) N (by norm_num) (by norm_num)
        hN hNnonempty
    obtain ⟨y₀, hy₀M, _hy₀max, _hy₀lower, hy₀upper⟩ :=
      exists_net_inner_max_bounds (T x₀) (1 / 4 : ℝ) M (by norm_num) (by norm_num)
        hM hMnonempty
    have hsample : inner ℝ (T x₀) y₀ ≤ inner ℝ (T p.1) p.2 :=
      hpmax (x₀, y₀) (Finset.mem_product.mpr ⟨hx₀N, hy₀M⟩)
    norm_num at hx₀upper hy₀upper
    have hsample_nonneg : 0 ≤ inner ℝ (T x₀) y₀ := by
      nlinarith [norm_nonneg (T x₀)]
    nlinarith

/-- Two finite `ε`-nets of the unit spheres control the operator norm by the
largest sampled bilinear form, with the direct two-net factor
`(1 - 2 * ε)⁻¹`. -/
theorem exists_net_bilinear_max_bounds
    {E F : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    [NormedAddCommGroup F] [InnerProductSpace ℝ F]
    (T : E →L[ℝ] F) (ε : ℝ) (N : Finset E) (M : Finset F)
    (hε0 : 0 ≤ ε) (hεhalf : ε < 1 / 2)
    (hN : IsFiniteUnitSphereNet ε N) (hM : IsFiniteUnitSphereNet ε M)
    (hNnonempty : N.Nonempty) (hMnonempty : M.Nonempty) :
    ∃ x ∈ N, ∃ y ∈ M,
      (∀ u ∈ N, ∀ v ∈ M, inner ℝ (T u) v ≤ inner ℝ (T x) y) ∧
      inner ℝ (T x) y ≤ ‖T‖ ∧
      ‖T‖ ≤ (1 - 2 * ε)⁻¹ * inner ℝ (T x) y := by
  have hprod : (N.product M).Nonempty := hNnonempty.product hMnonempty
  obtain ⟨p, hp, hpmax⟩ :=
    Finset.exists_max_image (N.product M)
      (fun q ↦ inner ℝ (T q.1) q.2) hprod
  have hpx : p.1 ∈ N := (Finset.mem_product.mp hp).1
  have hpy : p.2 ∈ M := (Finset.mem_product.mp hp).2
  have hlower : inner ℝ (T p.1) p.2 ≤ ‖T‖ := by
    calc
      inner ℝ (T p.1) p.2 ≤ |inner ℝ (T p.1) p.2| := le_abs_self _
      _ ≤ ‖T p.1‖ * ‖p.2‖ := abs_real_inner_le_norm _ _
      _ = ‖T p.1‖ := by rw [hM.1 p.2 hpy, mul_one]
      _ ≤ ‖T‖ * ‖p.1‖ := ContinuousLinearMap.le_opNorm T p.1
      _ = ‖T‖ := by rw [hN.1 p.1 hpx, mul_one]
  have hε1 : ε < 1 := hεhalf.trans (by norm_num)
  obtain ⟨x₀, hx₀N⟩ := hNnonempty
  obtain ⟨y₀, hy₀M, _hy₀max, _hy₀lower, hy₀upper⟩ :=
    exists_net_inner_max_bounds (T x₀) ε M hε0 hε1 hM hMnonempty
  have hinvpos : 0 < (1 - ε)⁻¹ := inv_pos.mpr (sub_pos.mpr hε1)
  have hy₀prodnonneg : 0 ≤ (1 - ε)⁻¹ * inner ℝ (T x₀) y₀ :=
    (norm_nonneg (T x₀)).trans hy₀upper
  have hy₀nonneg : 0 ≤ inner ℝ (T x₀) y₀ := by
    nlinarith
  have hpnonneg : 0 ≤ inner ℝ (T p.1) p.2 :=
    hy₀nonneg.trans (hpmax (x₀, y₀) (Finset.mem_product.mpr ⟨hx₀N, hy₀M⟩))
  have hden : 0 < 1 - 2 * ε := by linarith
  have hcoarse :
      ‖T‖ ≤ inner ℝ (T p.1) p.2 + 2 * ‖T‖ * ε := by
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
              _ ≤ ‖T u‖ * ε := mul_le_mul_of_nonneg_left hvy (norm_nonneg _)
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
          have hsample : inner ℝ (T x) y ≤ inner ℝ (T p.1) p.2 :=
            hpmax (x, y) (Finset.mem_product.mpr ⟨hxN, hyM⟩)
          have hunit : ‖T u‖ ≤ inner ℝ (T p.1) p.2 + 2 * ‖T‖ * ε := by
            rw [← hinner]
            nlinarith
          have hzrepr : z = ‖z‖ • u := by simp [u, hznorm]
          calc
            ‖T z‖ = ‖T (‖z‖ • u)‖ := congrArg (fun q : E ↦ ‖T q‖) hzrepr
            _ = ‖z‖ * ‖T u‖ := by
              rw [map_smul, norm_smul, Real.norm_eq_abs,
                abs_of_nonneg (norm_nonneg z)]
            _ ≤ ‖z‖ * (inner ℝ (T p.1) p.2 + 2 * ‖T‖ * ε) :=
              mul_le_mul_of_nonneg_left hunit (norm_nonneg z)
            _ = (inner ℝ (T p.1) p.2 + 2 * ‖T‖ * ε) * ‖z‖ := by ring
  have hupper : ‖T‖ ≤ (1 - 2 * ε)⁻¹ * inner ℝ (T p.1) p.2 := by
    rw [inv_mul_eq_div]
    exact (le_div_iff₀ hden).2 (by nlinarith)
  exact ⟨p.1, hpx, p.2, hpy, (fun u hu v hv ↦
    hpmax (u, v) (Finset.mem_product.mpr ⟨hu, hv⟩)), hlower, hupper⟩

/-- If a real operator attains its norm as an absolute quadratic-form value,
then a finite `ε`-net controls that norm with factor `(1 - 2 * ε)⁻¹`. -/
theorem exists_net_quadratic_abs_max_bounds
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (T : E →L[ℝ] E) (ε : ℝ) (N : Finset E)
    (hε0 : 0 ≤ ε) (hεhalf : ε < 1 / 2)
    (hN : IsFiniteUnitSphereNet ε N) (hNnonempty : N.Nonempty)
    (hattain : ∃ u : E, ‖u‖ = 1 ∧ ‖T‖ ≤ |inner ℝ (T u) u|) :
    ∃ x ∈ N,
      (∀ y ∈ N, |inner ℝ (T y) y| ≤ |inner ℝ (T x) x|) ∧
      |inner ℝ (T x) x| ≤ ‖T‖ ∧
      ‖T‖ ≤ (1 - 2 * ε)⁻¹ * |inner ℝ (T x) x| := by
  obtain ⟨x, hxN, hxmax⟩ :=
    Finset.exists_max_image N (fun y ↦ |inner ℝ (T y) y|) hNnonempty
  have hxupper : |inner ℝ (T x) x| ≤ ‖T‖ := by
    calc
      |inner ℝ (T x) x| ≤ ‖T x‖ * ‖x‖ := abs_real_inner_le_norm _ _
      _ = ‖T x‖ := by rw [hN.1 x hxN, mul_one]
      _ ≤ ‖T‖ * ‖x‖ := ContinuousLinearMap.le_opNorm T x
      _ = ‖T‖ := by rw [hN.1 x hxN, mul_one]
  obtain ⟨u, hu, huattain⟩ := hattain
  obtain ⟨y, hyN, huy⟩ := hN.2 u hu
  have hfirst : |inner ℝ (T u) (u - y)| ≤ ‖T‖ * ε := by
    calc
      |inner ℝ (T u) (u - y)| ≤ ‖T u‖ * ‖u - y‖ :=
        abs_real_inner_le_norm _ _
      _ ≤ ‖T u‖ * ε := mul_le_mul_of_nonneg_left huy (norm_nonneg _)
      _ ≤ (‖T‖ * ‖u‖) * ε :=
        mul_le_mul_of_nonneg_right (ContinuousLinearMap.le_opNorm T u) hε0
      _ = ‖T‖ * ε := by rw [hu, mul_one]
  have hsecond : |inner ℝ (T (u - y)) y| ≤ ‖T‖ * ε := by
    calc
      |inner ℝ (T (u - y)) y| ≤ ‖T (u - y)‖ * ‖y‖ :=
        abs_real_inner_le_norm _ _
      _ = ‖T (u - y)‖ := by rw [hN.1 y hyN, mul_one]
      _ ≤ ‖T‖ * ‖u - y‖ := ContinuousLinearMap.le_opNorm T (u - y)
      _ ≤ ‖T‖ * ε := mul_le_mul_of_nonneg_left huy (norm_nonneg _)
  have hdecomp :
      inner ℝ (T u) u - inner ℝ (T y) y =
        inner ℝ (T u) (u - y) + inner ℝ (T (u - y)) y := by
    rw [inner_sub_right, map_sub, inner_sub_left]
    ring
  have habsdiff :
      |inner ℝ (T u) u| - |inner ℝ (T y) y| ≤ 2 * ‖T‖ * ε := by
    calc
      |inner ℝ (T u) u| - |inner ℝ (T y) y| ≤
          |inner ℝ (T u) u - inner ℝ (T y) y| := abs_sub_abs_le_abs_sub _ _
      _ = |inner ℝ (T u) (u - y) + inner ℝ (T (u - y)) y| := by rw [hdecomp]
      _ ≤ |inner ℝ (T u) (u - y)| + |inner ℝ (T (u - y)) y| := abs_add_le _ _
      _ ≤ 2 * ‖T‖ * ε := by nlinarith
  have hcoarse : ‖T‖ ≤ |inner ℝ (T x) x| + 2 * ‖T‖ * ε := by
    have hymax := hxmax y hyN
    linarith
  have hden : 0 < 1 - 2 * ε := by linarith
  have hxbound : ‖T‖ ≤ (1 - 2 * ε)⁻¹ * |inner ℝ (T x) x| := by
    rw [inv_mul_eq_div]
    exact (le_div_iff₀ hden).2 (by nlinarith)
  exact ⟨x, hxN, hxmax, hxupper, hxbound⟩

/-- An arbitrary set-valued `ε`-net controls the operator norm by the real
supremum of the sampled absolute quadratic forms.  This is the non-finite
counterpart of `exists_net_quadratic_abs_max_bounds`. -/
theorem operatorNorm_le_inv_mul_sSup_quadratic_abs_of_isUnitSphereNet
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (T : E →L[ℝ] E) (ε : ℝ) (N : Set E)
    (hε0 : 0 ≤ ε) (hεhalf : ε < 1 / 2)
    (hN : IsUnitSphereNet ε N)
    (hattain : ∃ u : E, ‖u‖ = 1 ∧ ‖T‖ ≤ |inner ℝ (T u) u|) :
    ‖T‖ ≤ (1 - 2 * ε)⁻¹ *
      sSup {a : ℝ | ∃ y ∈ N, a = |inner ℝ (T y) y|} := by
  let Q : Set ℝ := {a : ℝ | ∃ y ∈ N, a = |inner ℝ (T y) y|}
  have hQbdd : BddAbove Q := by
    refine ⟨‖T‖, ?_⟩
    rintro a ⟨y, hyN, rfl⟩
    calc
      |inner ℝ (T y) y| ≤ ‖T y‖ * ‖y‖ := abs_real_inner_le_norm _ _
      _ = ‖T y‖ := by rw [hN.1 y hyN, mul_one]
      _ ≤ ‖T‖ * ‖y‖ := ContinuousLinearMap.le_opNorm T y
      _ = ‖T‖ := by rw [hN.1 y hyN, mul_one]
  obtain ⟨u, hu, huattain⟩ := hattain
  obtain ⟨y, hyN, huy⟩ := hN.2 u hu
  have hyQ : |inner ℝ (T y) y| ∈ Q := ⟨y, hyN, rfl⟩
  have hySup : |inner ℝ (T y) y| ≤ sSup Q := le_csSup hQbdd hyQ
  have hfirst : |inner ℝ (T u) (u - y)| ≤ ‖T‖ * ε := by
    calc
      |inner ℝ (T u) (u - y)| ≤ ‖T u‖ * ‖u - y‖ :=
        abs_real_inner_le_norm _ _
      _ ≤ ‖T u‖ * ε := mul_le_mul_of_nonneg_left huy (norm_nonneg _)
      _ ≤ (‖T‖ * ‖u‖) * ε :=
        mul_le_mul_of_nonneg_right (ContinuousLinearMap.le_opNorm T u) hε0
      _ = ‖T‖ * ε := by rw [hu, mul_one]
  have hsecond : |inner ℝ (T (u - y)) y| ≤ ‖T‖ * ε := by
    calc
      |inner ℝ (T (u - y)) y| ≤ ‖T (u - y)‖ * ‖y‖ :=
        abs_real_inner_le_norm _ _
      _ = ‖T (u - y)‖ := by rw [hN.1 y hyN, mul_one]
      _ ≤ ‖T‖ * ‖u - y‖ := ContinuousLinearMap.le_opNorm T (u - y)
      _ ≤ ‖T‖ * ε := mul_le_mul_of_nonneg_left huy (norm_nonneg _)
  have hdecomp :
      inner ℝ (T u) u - inner ℝ (T y) y =
        inner ℝ (T u) (u - y) + inner ℝ (T (u - y)) y := by
    rw [inner_sub_right, map_sub, inner_sub_left]
    ring
  have habsdiff :
      |inner ℝ (T u) u| - |inner ℝ (T y) y| ≤ 2 * ‖T‖ * ε := by
    calc
      |inner ℝ (T u) u| - |inner ℝ (T y) y| ≤
          |inner ℝ (T u) u - inner ℝ (T y) y| := abs_sub_abs_le_abs_sub _ _
      _ = |inner ℝ (T u) (u - y) + inner ℝ (T (u - y)) y| := by rw [hdecomp]
      _ ≤ |inner ℝ (T u) (u - y)| + |inner ℝ (T (u - y)) y| := abs_add_le _ _
      _ ≤ 2 * ‖T‖ * ε := by nlinarith
  have hcoarse : ‖T‖ ≤ sSup Q + 2 * ‖T‖ * ε := by
    linarith
  have hden : 0 < 1 - 2 * ε := by linarith
  change ‖T‖ ≤ (1 - 2 * ε)⁻¹ * sSup Q
  rw [inv_mul_eq_div]
  exact (le_div_iff₀ hden).2 (by nlinarith)

end NumStability.HDP.Metric
