import ComputationalMathematics.HDP.Metric.NetApproximation
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Uniform squared-norm deviation from a sphere net
-/

noncomputable section

namespace NumStability.HDP.Metric

/-- The quadratic form of `AᵀA - μI` is the squared-norm deviation from
`μ ‖x‖²`. -/
theorem realMatrixQuadraticForm_gram_sub_smul_one
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (μ : ℝ)
    (x : EuclideanSpace ℝ (Fin n)) :
    NumStability.realMatrixQuadraticForm
        (A.transpose * A - μ • (1 : Matrix (Fin n) (Fin n) ℝ)) x =
      ‖Matrix.toEuclideanLin A x‖ ^ 2 - μ * ‖x‖ ^ 2 := by
  unfold NumStability.realMatrixQuadraticForm
  rw [map_sub, Matrix.toLpLin_mul_same]
  rw [show Matrix.toEuclideanLin A.transpose =
      (Matrix.toEuclideanLin A).adjoint by
    simpa using Matrix.toEuclideanLin_conjTranspose_eq_adjoint A]
  rw [LinearMap.sub_apply, inner_sub_left, LinearMap.comp_apply,
    LinearMap.adjoint_inner_left,
    real_inner_self_eq_norm_sq]
  congr 1
  change inner ℝ (WithLp.toLp 2 ((μ • (1 : Matrix (Fin n) (Fin n) ℝ)).mulVec x)) x =
    μ * ‖x‖ ^ 2
  have hmul : WithLp.toLp 2
      ((μ • (1 : Matrix (Fin n) (Fin n) ℝ)).mulVec x) = μ • x := by
    classical
    ext i
    simp [Matrix.mulVec, dotProduct, Matrix.one_apply]
  rw [hmul, real_inner_smul_left, real_inner_self_eq_norm_sq]

/-- A finite `ε`-net of the unit sphere controls the uniform deviation of
`‖Ax‖²` from an arbitrary real level `μ`, with factor `(1-2ε)⁻¹`. -/
theorem exists_net_norm_sq_deviation_max_bounds
    {m n : ℕ} (hn : 0 < n) (A : Matrix (Fin m) (Fin n) ℝ)
    (μ ε : ℝ) (N : Finset (EuclideanSpace ℝ (Fin n)))
    (hε0 : 0 ≤ ε) (hεhalf : ε < 1 / 2)
    (hN : IsFiniteUnitSphereNet ε N) (hNnonempty : N.Nonempty) :
    ∃ x ∈ N,
      (∀ y ∈ N,
        |‖Matrix.toEuclideanLin A y‖ ^ 2 - μ| ≤
          |‖Matrix.toEuclideanLin A x‖ ^ 2 - μ|) ∧
      (∀ u : EuclideanSpace ℝ (Fin n), ‖u‖ = 1 →
        |‖Matrix.toEuclideanLin A u‖ ^ 2 - μ| ≤
          (1 - 2 * ε)⁻¹ * |‖Matrix.toEuclideanLin A x‖ ^ 2 - μ|) := by
  let R := A.transpose * A - μ • (1 : Matrix (Fin n) (Fin n) ℝ)
  have hR : R.IsHermitian := by
    have hgram : (A.transpose * A).IsHermitian := by
      simpa using Matrix.isHermitian_conjTranspose_mul_self A
    have hone : (μ • (1 : Matrix (Fin n) (Fin n) ℝ)).IsHermitian := by
      rw [Matrix.IsHermitian]
      ext i j
      simp [Matrix.one_apply, eq_comm]
    exact hgram.sub hone
  obtain ⟨_hop, u, hu, huq, humax⟩ :=
    NumStability.symmetricRealMatrixOperatorNorm_quadratic_characterization
      hn R hR
  have hattain : ∃ u : EuclideanSpace ℝ (Fin n), ‖u‖ = 1 ∧
      ‖NumStability.realMatrixContinuousLinearMap R‖ ≤
        |inner ℝ (NumStability.realMatrixContinuousLinearMap R u) u| := by
    refine ⟨u, hu, ?_⟩
    simpa [NumStability.realMatrixOperatorNorm,
      NumStability.realMatrixQuadraticForm,
      NumStability.realMatrixContinuousLinearMap] using huq.symm.le
  obtain ⟨x, hxN, hxmax, _hxupper, hxbound⟩ :=
    exists_net_quadratic_abs_max_bounds
      (NumStability.realMatrixContinuousLinearMap R) ε N
      hε0 hεhalf hN hNnonempty hattain
  refine ⟨x, hxN, ?_, ?_⟩
  · intro y hyN
    have hmax := hxmax y hyN
    change |NumStability.realMatrixQuadraticForm R y| ≤
      |NumStability.realMatrixQuadraticForm R x| at hmax
    rw [show R = A.transpose * A - μ • (1 : Matrix (Fin n) (Fin n) ℝ) by rfl,
      realMatrixQuadraticForm_gram_sub_smul_one A μ,
      realMatrixQuadraticForm_gram_sub_smul_one A μ,
      hN.1 y hyN, hN.1 x hxN, one_pow, mul_one] at hmax
    exact hmax
  · intro z hz
    have hzq := humax z hz
    calc
      |‖Matrix.toEuclideanLin A z‖ ^ 2 - μ| =
          |NumStability.realMatrixQuadraticForm R z| := by
        rw [realMatrixQuadraticForm_gram_sub_smul_one A μ, hz, one_pow, mul_one]
      _ ≤ NumStability.realMatrixOperatorNorm R := hzq
      _ = ‖NumStability.realMatrixContinuousLinearMap R‖ := rfl
      _ ≤ (1 - 2 * ε)⁻¹ *
          |inner ℝ (NumStability.realMatrixContinuousLinearMap R x) x| := hxbound
      _ = (1 - 2 * ε)⁻¹ * |‖Matrix.toEuclideanLin A x‖ ^ 2 - μ| := by
        rw [show inner ℝ (NumStability.realMatrixContinuousLinearMap R x) x =
            NumStability.realMatrixQuadraticForm R x by rfl,
          realMatrixQuadraticForm_gram_sub_smul_one A μ, hN.1 x hxN,
          one_pow, mul_one]

/-- An arbitrary `ε`-net of the unit sphere controls the uniform squared-norm
deviation by the supremum of the deviations sampled on that net. -/
theorem norm_sq_deviation_le_sSup_net
    {m n : ℕ} (hn : 0 < n) (A : Matrix (Fin m) (Fin n) ℝ)
    (μ ε : ℝ) (N : Set (EuclideanSpace ℝ (Fin n)))
    (hε0 : 0 ≤ ε) (hεhalf : ε < 1 / 2)
    (hN : IsUnitSphereNet ε N) :
    ∀ u : EuclideanSpace ℝ (Fin n), ‖u‖ = 1 →
      |‖Matrix.toEuclideanLin A u‖ ^ 2 - μ| ≤
        (1 - 2 * ε)⁻¹ *
          sSup {a : ℝ | ∃ x ∈ N, a = |‖Matrix.toEuclideanLin A x‖ ^ 2 - μ|} := by
  let R := A.transpose * A - μ • (1 : Matrix (Fin n) (Fin n) ℝ)
  have hR : R.IsHermitian := by
    have hgram : (A.transpose * A).IsHermitian := by
      simpa using Matrix.isHermitian_conjTranspose_mul_self A
    have hone : (μ • (1 : Matrix (Fin n) (Fin n) ℝ)).IsHermitian := by
      rw [Matrix.IsHermitian]
      ext i j
      simp [Matrix.one_apply, eq_comm]
    exact hgram.sub hone
  obtain ⟨_hop, v, hv, hvq, hvmax⟩ :=
    NumStability.symmetricRealMatrixOperatorNorm_quadratic_characterization
      hn R hR
  have hattain : ∃ v : EuclideanSpace ℝ (Fin n), ‖v‖ = 1 ∧
      ‖NumStability.realMatrixContinuousLinearMap R‖ ≤
        |inner ℝ (NumStability.realMatrixContinuousLinearMap R v) v| := by
    refine ⟨v, hv, ?_⟩
    simpa [NumStability.realMatrixOperatorNorm,
      NumStability.realMatrixQuadraticForm,
      NumStability.realMatrixContinuousLinearMap] using hvq.symm.le
  have hop := operatorNorm_le_inv_mul_sSup_quadratic_abs_of_isUnitSphereNet
    (NumStability.realMatrixContinuousLinearMap R) ε N hε0 hεhalf hN hattain
  have hsets :
      {a : ℝ | ∃ x ∈ N,
        a = |inner ℝ (NumStability.realMatrixContinuousLinearMap R x) x|} =
      {a : ℝ | ∃ x ∈ N, a = |‖Matrix.toEuclideanLin A x‖ ^ 2 - μ|} := by
    ext a
    constructor
    · rintro ⟨x, hxN, rfl⟩
      refine ⟨x, hxN, ?_⟩
      rw [show inner ℝ (NumStability.realMatrixContinuousLinearMap R x) x =
          NumStability.realMatrixQuadraticForm R x by rfl,
        show R = A.transpose * A - μ • (1 : Matrix (Fin n) (Fin n) ℝ) by rfl,
        realMatrixQuadraticForm_gram_sub_smul_one A μ,
        hN.1 x hxN, one_pow, mul_one]
    · rintro ⟨x, hxN, rfl⟩
      refine ⟨x, hxN, ?_⟩
      rw [show inner ℝ (NumStability.realMatrixContinuousLinearMap R x) x =
          NumStability.realMatrixQuadraticForm R x by rfl,
        show R = A.transpose * A - μ • (1 : Matrix (Fin n) (Fin n) ℝ) by rfl,
        realMatrixQuadraticForm_gram_sub_smul_one A μ,
        hN.1 x hxN, one_pow, mul_one]
  intro u hu
  calc
    |‖Matrix.toEuclideanLin A u‖ ^ 2 - μ| =
        |NumStability.realMatrixQuadraticForm R u| := by
      rw [realMatrixQuadraticForm_gram_sub_smul_one A μ, hu, one_pow, mul_one]
    _ ≤ NumStability.realMatrixOperatorNorm R := hvmax u hu
    _ = ‖NumStability.realMatrixContinuousLinearMap R‖ := rfl
    _ ≤ (1 - 2 * ε)⁻¹ *
        sSup {a : ℝ | ∃ x ∈ N,
          a = |inner ℝ (NumStability.realMatrixContinuousLinearMap R x) x|} := hop
    _ = (1 - 2 * ε)⁻¹ *
        sSup {a : ℝ | ∃ x ∈ N,
          a = |‖Matrix.toEuclideanLin A x‖ ^ 2 - μ|} := by rw [hsets]

set_option maxHeartbeats 1000000 in
/-- The literal unsquared norm-deviation estimate of Exercise 4.4.4 for an
arbitrary set-valued net.  The explicit absolute constant `3` discharges the
source's unspecified constant `C`; the squared estimate above is used only as
the hint suggests. -/
theorem norm_deviation_le_three_mul_inv_mul_sSup_net
    {m n : ℕ} (hn : 0 < n) (A : Matrix (Fin m) (Fin n) ℝ)
    (μ ε : ℝ) (N : Set (EuclideanSpace ℝ (Fin n)))
    (hε0 : 0 ≤ ε) (hεhalf : ε < 1 / 2)
    (hN : IsUnitSphereNet ε N) :
    ∀ z : EuclideanSpace ℝ (Fin n), ‖z‖ = 1 →
      |‖Matrix.toEuclideanLin A z‖ - μ| ≤
        3 * (1 - 2 * ε)⁻¹ *
          sSup {a : ℝ | ∃ x ∈ N, a = |‖Matrix.toEuclideanLin A x‖ - μ|} := by
  let T := NumStability.realMatrixContinuousLinearMap A
  let dev : EuclideanSpace ℝ (Fin n) → ℝ := fun x ↦ |‖T x‖ - μ|
  let S : Set ℝ := {a : ℝ | ∃ x ∈ N, a = dev x}
  let M : ℝ := sSup S
  let L : ℝ := NumStability.realMatrixOperatorNorm A
  let F : ℝ := (1 - 2 * ε)⁻¹
  have hden : 0 < 1 - 2 * ε := by linarith
  have hF : 0 < F := by
    dsimp [F]
    positivity
  let i : Fin n := ⟨0, hn⟩
  let e : EuclideanSpace ℝ (Fin n) := EuclideanSpace.single i 1
  have he : ‖e‖ = 1 := by simp [e]
  have hunit : ({x : EuclideanSpace ℝ (Fin n) | ‖x‖ = 1} : Set _).Nonempty :=
    ⟨e, he⟩
  have hdevContinuous : Continuous dev := by
    dsimp [dev]
    fun_prop
  obtain ⟨u, hu, humax⟩ :=
    isCompact_norm_unit_sphere.exists_isMaxOn hunit hdevContinuous.continuousOn
  change ‖u‖ = 1 at hu
  obtain ⟨hop, ⟨v, hv, hAv, hAbound⟩, _⟩ :=
    NumStability.realMatrixOperatorNorm_characterization hn A
  have hTnorm : ‖T‖ = L := by
    simp [T, L, NumStability.realMatrixOperatorNorm]
  obtain ⟨y₀, hy₀N, _hy₀⟩ := hN.2 e he
  have hSnonempty : S.Nonempty := ⟨dev y₀, y₀, hy₀N, rfl⟩
  have hSbdd : BddAbove S := by
    refine ⟨L + |μ|, ?_⟩
    rintro a ⟨x, hxN, rfl⟩
    calc
      dev x = |‖Matrix.toEuclideanLin A x‖ - μ| := by rfl
      _ ≤ |‖Matrix.toEuclideanLin A x‖| + |μ| := abs_sub _ _
      _ = ‖Matrix.toEuclideanLin A x‖ + |μ| := by
        rw [abs_of_nonneg (norm_nonneg _)]
      _ ≤ L + |μ| := by
        gcongr
        simpa [L] using hAbound x (hN.1 x hxN)
  have hsample (x : EuclideanSpace ℝ (Fin n)) (hxN : x ∈ N) : dev x ≤ M := by
    exact le_csSup hSbdd ⟨x, hxN, rfl⟩
  have hM0 : 0 ≤ M := by
    exact (abs_nonneg (‖T y₀‖ - μ)).trans (hsample y₀ hy₀N)
  have hL0 : 0 ≤ L := by
    dsimp [L]
    exact norm_nonneg _
  have hD0 : 0 ≤ dev u := abs_nonneg _
  have hglobal (z : EuclideanSpace ℝ (Fin n)) (hz : ‖z‖ = 1) :
      dev z ≤ dev u := humax hz
  have hLu : ‖T u‖ ≤ L := by
    simpa [T, L] using hAbound u hu
  have hLv : ‖T v‖ = L := by
    simpa [T, L] using hAv
  have hsq := norm_sq_deviation_le_sSup_net hn A (μ ^ 2) ε N hε0 hεhalf hN
  have hmain : dev u ≤ 3 * F * M := by
    by_cases hμ : 0 ≤ μ
    · let Q : Set ℝ :=
        {q : ℝ | ∃ x ∈ N, q = |‖Matrix.toEuclideanLin A x‖ ^ 2 - μ ^ 2|}
      have hQnonempty : Q.Nonempty := by
        refine ⟨|‖Matrix.toEuclideanLin A y₀‖ ^ 2 - μ ^ 2|, y₀, hy₀N, rfl⟩
      have hQupper : sSup Q ≤ M * (L + μ) := by
        apply csSup_le hQnonempty
        rintro q ⟨x, hxN, rfl⟩
        have hxunit := hN.1 x hxN
        have hxnorm : ‖Matrix.toEuclideanLin A x‖ ≤ L := by
          simpa [L] using hAbound x hxunit
        have hxdev : |‖Matrix.toEuclideanLin A x‖ - μ| ≤ M := by
          simpa [dev, T] using hsample x hxN
        have hfac :
            |‖Matrix.toEuclideanLin A x‖ ^ 2 - μ ^ 2| =
              |‖Matrix.toEuclideanLin A x‖ - μ| *
                (‖Matrix.toEuclideanLin A x‖ + μ) := by
          rw [sq_sub_sq, abs_mul, abs_of_nonneg (add_nonneg (norm_nonneg _) hμ)]
          ring
        rw [hfac]
        apply mul_le_mul hxdev (by linarith)
          (add_nonneg (norm_nonneg _) hμ) hM0
      have hsqU :
          |‖T u‖ ^ 2 - μ ^ 2| ≤ F * (M * (L + μ)) := by
        have hu' := hsq u hu
        change |‖T u‖ ^ 2 - μ ^ 2| ≤ F * sSup Q at hu'
        exact hu'.trans (mul_le_mul_of_nonneg_left hQupper hF.le)
      by_cases hau : μ ≤ ‖T u‖
      · have hLvdev : |‖T v‖ - μ| ≤ dev u := hglobal v hv
        have hDueq : dev u = ‖T u‖ - μ := by
          dsimp [dev]
          rw [abs_of_nonneg (sub_nonneg.mpr hau)]
        have hLe : L ≤ ‖T u‖ := by
          rw [hLv, abs_of_nonneg (sub_nonneg.mpr (hau.trans hLu))] at hLvdev
          linarith
        have hLa : L = ‖T u‖ := le_antisymm hLe hLu
        have hfactor : 0 ≤ ‖T u‖ + μ := add_nonneg (norm_nonneg _) hμ
        have hidentity :
            |‖T u‖ ^ 2 - μ ^ 2| = dev u * (‖T u‖ + μ) := by
          rw [sq_sub_sq, abs_mul,
            abs_of_nonneg (add_nonneg (norm_nonneg _) hμ),
            abs_of_nonneg (sub_nonneg.mpr hau)]
          rw [hDueq]
          ring
        by_cases hzero : ‖T u‖ + μ = 0
        · have : dev u = 0 := by
            dsimp [dev]
            have hu0 : ‖T u‖ = 0 := by nlinarith [norm_nonneg (T u)]
            have hμ0 : μ = 0 := by nlinarith
            simp [hu0, hμ0]
          rw [this]
          positivity
        · rw [hidentity, hLa] at hsqU
          have hfactorPos : 0 < ‖T u‖ + μ := lt_of_le_of_ne hfactor (Ne.symm hzero)
          have : dev u ≤ F * M := by nlinarith
          nlinarith [mul_nonneg hF.le hM0]
      · have hau' : ‖T u‖ < μ := lt_of_not_ge hau
        have hDu : dev u = μ - ‖T u‖ := by
          dsimp [dev]
          rw [abs_of_neg (sub_neg.mpr hau')]
          ring
        have hDmu : dev u ≤ μ := by rw [hDu]; exact sub_le_self μ (norm_nonneg _)
        have hLvdev : |‖T v‖ - μ| ≤ dev u := hglobal v hv
        have hLupper : L ≤ μ + dev u := by
          rw [hLv] at hLvdev
          have := (le_abs_self (L - μ)).trans hLvdev
          linarith
        have hidentity :
            |‖T u‖ ^ 2 - μ ^ 2| = dev u * (μ + ‖T u‖) := by
          rw [sq_sub_sq, abs_mul,
            abs_of_nonneg (add_nonneg (norm_nonneg _) hμ),
            abs_of_neg (sub_neg.mpr hau'), hDu]
          ring
        have hcore :
            dev u * μ ≤ (F * M) * (2 * μ + dev u) := by
          rw [hidentity] at hsqU
          have hleft : dev u * μ ≤ dev u * (μ + ‖T u‖) := by
            nlinarith [norm_nonneg (T u), hD0]
          have hright : F * (M * (L + μ)) ≤ (F * M) * (2 * μ + dev u) := by
            have hFM : 0 ≤ F * M := mul_nonneg hF.le hM0
            nlinarith
          exact hleft.trans (hsqU.trans hright)
        have hFM0 : 0 ≤ F * M := mul_nonneg hF.le hM0
        by_contra hnot
        have hgt₀ : 3 * F * M < dev u := lt_of_not_ge hnot
        have hgt : 3 * (F * M) < dev u := by nlinarith
        have hDpos : 0 < dev u := by nlinarith
        have hμpos : 0 < μ := lt_of_lt_of_le hDpos hDmu
        nlinarith
    · have hμneg : μ < 0 := lt_of_not_ge hμ
      have hLvdev : |‖T v‖ - μ| ≤ dev u := hglobal v hv
      have hLleD : L ≤ dev u := by
        rw [hLv, abs_of_pos (sub_pos.mpr (lt_of_lt_of_le hμneg hL0))] at hLvdev
        linarith
      obtain ⟨y, hyN, huy⟩ := hN.2 u hu
      have haction : ‖T u‖ ≤ ‖T y‖ + L * ε := by
        calc
          ‖T u‖ = ‖T y + T (u - y)‖ := by
            congr 1
            rw [map_sub]
            abel
          _ ≤ ‖T y‖ + ‖T (u - y)‖ := norm_add_le _ _
          _ ≤ ‖T y‖ + ‖T‖ * ‖u - y‖ := by
            gcongr
            exact ContinuousLinearMap.le_opNorm T (u - y)
          _ ≤ ‖T y‖ + L * ε := by rw [hTnorm]; gcongr
      have hydev : dev y ≤ M := hsample y hyN
      have hDueq : dev u = ‖T u‖ - μ := by
        dsimp [dev]
        rw [abs_of_pos (sub_pos.mpr (lt_of_lt_of_le hμneg (norm_nonneg _)))]
      have hcoarse : dev u ≤ M + dev u * ε := by
        dsimp [dev] at hydev
        rw [abs_of_pos (sub_pos.mpr (lt_of_lt_of_le hμneg (norm_nonneg _)))] at hydev
        have hLmul : L * ε ≤ dev u * ε :=
          mul_le_mul_of_nonneg_right hLleD hε0
        rw [hDueq]
        nlinarith
      have hscaled : (1 - 2 * ε) * dev u ≤ 3 * M := by
        nlinarith
      rw [show 3 * F * M = (3 * M) / (1 - 2 * ε) by
        dsimp [F]
        field_simp]
      exact (le_div_iff₀ hden).2 (by nlinarith)
  intro z hz
  change dev z ≤ 3 * F * M
  exact (hglobal z hz).trans hmain

end NumStability.HDP.Metric
