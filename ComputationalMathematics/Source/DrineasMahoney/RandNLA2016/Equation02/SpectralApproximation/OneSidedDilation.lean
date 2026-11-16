import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation02.SpectralApproximation.ElementwiseSpectral

/-!
# One-sided dilation concentration for truncated element sampling

A dilation's upper Loewner bound already controls the rectangular operator
norm. Applying the proved trace-MGF upper-tail theorem once therefore gives
the dimension factor `2n`, without a second eigenvalue-tail union bound.
The sampling law remains the truncated Drineas–Zouzias law.
-/

namespace NumStability

open scoped BigOperators ComplexOrder

/-- One upper trace tail suffices for the dilation norm. -/
theorem sqMagTraceProbability_eventProb_algorithm1ExactSpectralEvent_truncatedTraceResidual_ge_one_sub_delta_scaled_radius_one_tail
    {n s : ℕ} {tau theta δ : ℝ} (htau : 0 < tau) (hs : 0 < (s : ℝ))
    (A : Fin n → Fin n → ℝ)
    (hden : 0 < sqMagProbDen (elementwiseTruncate tau A))
    (htheta : 0 < theta)
    (hdim : 0 < (n : ℝ) + (n : ℝ)) (hδ : 0 < δ) (hδ_le_one : δ ≤ 1) :
    let Ahat : Fin n → Fin n → ℝ := elementwiseTruncate tau A
    let L : ℝ :=
      (1 / (s : ℝ)) * frobNormRect Ahat +
        frobNormSqRect Ahat / ((s : ℝ) * tau)
    let beta : ℝ := (Real.exp (theta * L) - theta * L - 1) / L ^ 2
    let V : ℝ := (n : ℝ) * (frobNormSqRect Ahat / (s : ℝ) ^ 2)
    let B : ℝ := ((n : ℝ) + (n : ℝ)) * Real.exp ((s : ℝ) * (beta * V))
    1 - δ ≤
      (sqMagTraceProbability (steps := s) Ahat hden).eventProb
        (algorithm1ExactSpectralEvent s Ahat
          (fun samples : ElementwiseTrace n n s => samples)
          (Real.log (B / δ) / theta)) := by
  classical
  intro Ahat L beta V B
  let P := sqMagTraceProbability (steps := s) Ahat hden
  let T : ℝ := Real.log (B / δ)
  let M : ElementwiseTrace n n s → Fin n ⊕ Fin n → Fin n ⊕ Fin n → ℝ :=
    fun samples b c => theta *
      rectSelfAdjointDilation (elementwiseTraceResidual s Ahat samples) b c
  have hM : ∀ samples, IsSymmetricFiniteMatrix (M samples) := by
    intro samples b c
    exact congrArg (fun x => theta * x)
      (rectSelfAdjointDilation_symmetric (elementwiseTraceResidual s Ahat samples) b c)
  have hTrace : P.expectationReal (fun samples => finiteTrace (finiteMatrixExp (M samples))) ≤ B := by
    exact (sqMagTraceProbability_expectationReal_finiteTrace_finiteMatrixExp_rectSelfAdjointDilation_elementwiseTraceResidual_le
      Ahat hden hs.ne' theta).trans (by
        simpa [Ahat, L, beta, V, B] using
          sqMagTraceProbabilityFiniteRealTraceMGFLogBound_rectSelfAdjointDilation_truncated_sampleResidualIncrement_le_sharp_square
            (n := n) (s := s) (tau := tau) (theta := theta)
            htau hs A hden htheta.le)
  have hB_pos : 0 < B := mul_pos hdim (Real.exp_pos _)
  have hfailure : Real.exp (-T) * B = δ := by
    dsimp [T]
    rw [Real.exp_neg, Real.exp_log (div_pos hB_pos hδ)]
    field_simp [hB_pos.ne', hδ.ne']
  have htail : 1 - δ ≤ P.eventProb
      {samples | ∀ a, finiteHermitianEigenvalues (M samples) (hM samples) a < T} := by
    simpa [hfailure] using
      P.eventProb_forall_finiteHermitianEigenvalue_lt_ge_one_sub_exp_neg_mul_trace_bound
        M hM T B hTrace
  have hTtheta : 0 ≤ T / theta := by
    have hnn : (1 : ℝ) ≤ (n : ℝ) + (n : ℝ) := by
      have hnat : 0 < n + n := by exact_mod_cast hdim
      exact_mod_cast Nat.succ_le_of_lt hnat
    have hbeta : 0 ≤ beta := div_nonneg
      (real_exp_sub_self_sub_one_nonneg (theta * L)) (sq_nonneg L)
    have hV : 0 ≤ V := by dsimp [V]; positivity
    have hexp : 1 ≤ Real.exp ((s : ℝ) * (beta * V)) :=
      Real.one_le_exp_iff.mpr (by positivity)
    have hB : 1 ≤ B := by dsimp [B]; nlinarith
    exact div_nonneg (Real.log_nonneg ((le_div_iff₀ hδ).mpr (by nlinarith))) htheta.le
  apply htail.trans
  apply P.eventProb_mono
  intro samples heig
  have hscaled : finiteLoewnerLe (M samples) (fun a b => T * finiteIdMatrix a b) :=
    finiteLoewnerLe_smul_id_of_finiteHermitianEigenvalues_le (M samples) (hM samples)
      (fun a => (heig a).le)
  have hupper : finiteLoewnerLe
      (rectSelfAdjointDilation (elementwiseTraceResidual s Ahat samples))
      (fun a b => (T / theta) * finiteIdMatrix a b) :=
    finiteLoewnerLe_of_smul_left_le_smul_id _ htheta hscaled
  exact rectOpNorm2Le_of_selfAdjointDilation_loewnerLe_scalar_id
    (elementwiseTraceResidual s Ahat samples) hTtheta hupper

/-- Optimize the one-sided trace parameter using the exact Bennett transform. -/
theorem sqMagTraceProbability_eventProb_algorithm1ExactSpectralEvent_truncatedTraceResidual_ge_one_sub_delta_bennett_radius_one_tail
    {n s : ℕ} {tau δ r : ℝ} (htau : 0 < tau) (hs : 0 < (s : ℝ))
    (A : Fin n → Fin n → ℝ)
    (hden : 0 < sqMagProbDen (elementwiseTruncate tau A))
    (hdim : 0 < (n : ℝ) + (n : ℝ))
    (hδ : 0 < δ) (hδ_le_one : δ ≤ 1) (hr : 0 < r)
    (hbudget :
      let Ahat : Fin n → Fin n → ℝ := elementwiseTruncate tau A
      let L : ℝ :=
        (1 / (s : ℝ)) * frobNormRect Ahat +
          frobNormSqRect Ahat / ((s : ℝ) * tau)
      let V : ℝ := (n : ℝ) * (frobNormSqRect Ahat / (s : ℝ) ^ 2)
      let W : ℝ := (s : ℝ) * V
      Real.log (((n : ℝ) + (n : ℝ)) / δ) ≤
        (W / L ^ 2) *
          ((1 + (L * r / W)) * Real.log (1 + (L * r / W)) -
            (L * r / W))) :
    let Ahat : Fin n → Fin n → ℝ := elementwiseTruncate tau A
    1 - δ ≤
      (sqMagTraceProbability (steps := s) Ahat hden).eventProb
        (algorithm1ExactSpectralEvent s Ahat
          (fun samples : ElementwiseTrace n n s => samples) r) := by
  classical
  intro Ahat
  let L : ℝ :=
    (1 / (s : ℝ)) * frobNormRect Ahat +
      frobNormSqRect Ahat / ((s : ℝ) * tau)
  let V : ℝ := (n : ℝ) * (frobNormSqRect Ahat / (s : ℝ) ^ 2)
  let W : ℝ := (s : ℝ) * V
  let theta : ℝ := Real.log (1 + L * r / W) / L
  let beta : ℝ := (Real.exp (theta * L) - theta * L - 1) / L ^ 2
  let B : ℝ := ((n : ℝ) + (n : ℝ)) * Real.exp ((s : ℝ) * (beta * V))
  let P := sqMagTraceProbability (steps := s) Ahat hden
  have hbudget' :
      Real.log (((n : ℝ) + (n : ℝ)) / δ) ≤
        (W / L ^ 2) *
          ((1 + (L * r / W)) * Real.log (1 + (L * r / W)) -
            (L * r / W)) := by
    simpa [Ahat, L, V, W] using hbudget
  have hdenA : 0 < frobNormSqRect Ahat := by
    simpa [Ahat, sqMagProbDen] using hden
  have hL_pos : 0 < L := by
    have hfirst : 0 ≤ (1 / (s : ℝ)) * frobNormRect Ahat :=
      mul_nonneg (by positivity) (frobNormRect_nonneg Ahat)
    have hsecond : 0 < frobNormSqRect Ahat / ((s : ℝ) * tau) :=
      div_pos hdenA (mul_pos hs htau)
    have hsum :
        0 <
          (1 / (s : ℝ)) * frobNormRect Ahat +
            frobNormSqRect Ahat / ((s : ℝ) * tau) :=
      add_pos_of_nonneg_of_pos hfirst hsecond
    simpa [L] using hsum
  have hn_pos : 0 < (n : ℝ) := by
    have hn_nonneg : 0 ≤ (n : ℝ) := by positivity
    nlinarith [hdim, hn_nonneg]
  have hV_pos : 0 < V := by
    have hs_sq : 0 < (s : ℝ) ^ 2 := sq_pos_of_pos hs
    have hfrac : 0 < frobNormSqRect Ahat / (s : ℝ) ^ 2 :=
      div_pos hdenA hs_sq
    dsimp [V]
    exact mul_pos hn_pos hfrac
  have hW_pos : 0 < W := by
    dsimp [W]
    exact mul_pos hs hV_pos
  have htheta_pos : 0 < theta := by
    have hquot : 0 < L * r / W := by positivity
    have harg : 1 < 1 + L * r / W := by linarith
    dsimp [theta]
    exact div_pos (Real.log_pos harg) hL_pos
  have hradius_core :
      (Real.log (((n : ℝ) + (n : ℝ)) / δ) + W * beta) /
          theta ≤ r := by
    simpa [theta, beta] using
      real_bernstein_exact_radius_le_of_log_le
        hL_pos hW_pos hr hbudget'
  have hlog_radius :
      Real.log (B / δ) / theta ≤ r := by
    have hq_pos : 0 < ((n : ℝ) + (n : ℝ)) / δ :=
      div_pos hdim hδ
    have hexp_ne : Real.exp ((s : ℝ) * (beta * V)) ≠ 0 :=
      ne_of_gt (Real.exp_pos _)
    have hrewrite :
        B / δ =
          (((n : ℝ) + (n : ℝ)) / δ) *
            Real.exp ((s : ℝ) * (beta * V)) := by
      dsimp [B]
      field_simp [hδ.ne']
    have hlog :
        Real.log (B / δ) =
          Real.log (((n : ℝ) + (n : ℝ)) / δ) +
            W * beta := by
      calc
        Real.log (B / δ)
            = Real.log
                ((((n : ℝ) + (n : ℝ)) / δ) *
                  Real.exp ((s : ℝ) * (beta * V))) := by
                rw [hrewrite]
        _ = Real.log (((n : ℝ) + (n : ℝ)) / δ) +
              Real.log (Real.exp ((s : ℝ) * (beta * V))) := by
                rw [Real.log_mul (ne_of_gt hq_pos) hexp_ne]
        _ = Real.log (((n : ℝ) + (n : ℝ)) / δ) + W * beta := by
                rw [Real.log_exp]
                dsimp [W]
                ring
    simpa [hlog] using hradius_core
  have hbase :
      1 - δ ≤
        P.eventProb
          (algorithm1ExactSpectralEvent s Ahat
            (fun samples : ElementwiseTrace n n s => samples)
            (Real.log (B / δ) / theta)) := by
    simpa [P, Ahat, L, V, B, beta, theta] using
      sqMagTraceProbability_eventProb_algorithm1ExactSpectralEvent_truncatedTraceResidual_ge_one_sub_delta_scaled_radius_one_tail
        (n := n) (s := s) (tau := tau) (theta := theta) (δ := δ)
        htau hs A hden htheta_pos hdim hδ hδ_le_one
  have hsubset :
      algorithm1ExactSpectralEvent s Ahat
          (fun samples : ElementwiseTrace n n s => samples)
          (Real.log (B / δ) / theta) ⊆
        algorithm1ExactSpectralEvent s Ahat
          (fun samples : ElementwiseTrace n n s => samples) r :=
    algorithm1ExactSpectralEvent_mono s Ahat
      (fun samples : ElementwiseTrace n n s => samples) hlog_radius
  exact hbase.trans (P.eventProb_mono hsubset)

/-- Apply the proved scalar Bernstein denominator to the single upper tail. -/
theorem sqMagTraceProbability_eventProb_algorithm1ExactSpectralEvent_truncatedTraceResidual_ge_one_sub_delta_bernstein_denominator_two_thirds_one_tail
    {n s : ℕ} {tau δ r : ℝ} (htau : 0 < tau) (hs : 0 < (s : ℝ))
    (A : Fin n → Fin n → ℝ)
    (hden : 0 < sqMagProbDen (elementwiseTruncate tau A))
    (hdim : 0 < (n : ℝ) + (n : ℝ))
    (hδ : 0 < δ) (hδ_le_one : δ ≤ 1) (hr : 0 < r)
    (hbudget :
      let Ahat : Fin n → Fin n → ℝ := elementwiseTruncate tau A
      let L : ℝ :=
        (1 / (s : ℝ)) * frobNormRect Ahat +
          frobNormSqRect Ahat / ((s : ℝ) * tau)
      let V : ℝ := (n : ℝ) * (frobNormSqRect Ahat / (s : ℝ) ^ 2)
      let W : ℝ := (s : ℝ) * V
      Real.log (((n : ℝ) + (n : ℝ)) / δ) ≤
        r ^ 2 / (2 * W + (2 / 3) * L * r)) :
    let Ahat : Fin n → Fin n → ℝ := elementwiseTruncate tau A
    1 - δ ≤
      (sqMagTraceProbability (steps := s) Ahat hden).eventProb
        (algorithm1ExactSpectralEvent s Ahat
          (fun samples : ElementwiseTrace n n s => samples) r) := by
  classical
  intro Ahat
  let L : ℝ :=
    (1 / (s : ℝ)) * frobNormRect Ahat +
      frobNormSqRect Ahat / ((s : ℝ) * tau)
  let V : ℝ := (n : ℝ) * (frobNormSqRect Ahat / (s : ℝ) ^ 2)
  let W : ℝ := (s : ℝ) * V
  have hbudget' :
      Real.log (((n : ℝ) + (n : ℝ)) / δ) ≤
        r ^ 2 / (2 * W + (2 / 3) * L * r) := by
    simpa [Ahat, L, V, W] using hbudget
  have hdenA : 0 < frobNormSqRect Ahat := by
    simpa [Ahat, sqMagProbDen] using hden
  have hL_pos : 0 < L := by
    have hfirst : 0 ≤ (1 / (s : ℝ)) * frobNormRect Ahat :=
      mul_nonneg (by positivity) (frobNormRect_nonneg Ahat)
    have hsecond : 0 < frobNormSqRect Ahat / ((s : ℝ) * tau) :=
      div_pos hdenA (mul_pos hs htau)
    have hsum :
        0 <
          (1 / (s : ℝ)) * frobNormRect Ahat +
            frobNormSqRect Ahat / ((s : ℝ) * tau) :=
      add_pos_of_nonneg_of_pos hfirst hsecond
    simpa [L] using hsum
  have hn_pos : 0 < (n : ℝ) := by
    have hn_nonneg : 0 ≤ (n : ℝ) := by positivity
    nlinarith [hdim, hn_nonneg]
  have hV_pos : 0 < V := by
    have hs_sq : 0 < (s : ℝ) ^ 2 := sq_pos_of_pos hs
    have hfrac : 0 < frobNormSqRect Ahat / (s : ℝ) ^ 2 :=
      div_pos hdenA hs_sq
    dsimp [V]
    exact mul_pos hn_pos hfrac
  have hW_pos : 0 < W := by
    dsimp [W]
    exact mul_pos hs hV_pos
  have hbennett :
      Real.log (((n : ℝ) + (n : ℝ)) / δ) ≤
        (W / L ^ 2) *
          ((1 + (L * r / W)) * Real.log (1 + (L * r / W)) -
            (L * r / W)) :=
    real_bennett_budget_of_quadratic_denominator_two_add_two_thirds
      hL_pos hW_pos hr hbudget'
  simpa [Ahat] using
    sqMagTraceProbability_eventProb_algorithm1ExactSpectralEvent_truncatedTraceResidual_ge_one_sub_delta_bennett_radius_one_tail
      (n := n) (s := s) (tau := tau) (δ := δ) (r := r)
      htau hs A hden hdim hδ hδ_le_one hr
      (by simpa [Ahat, L, V, W] using hbennett)

/-- The source constant fourteen with the single-tail dimension factor. -/
theorem sqMagTraceProbability_eventProb_algorithm1ExactSpectralEvent_truncatedTraceResidual_ge_one_sub_delta_source_sample_budget_one_tail
    {n s : ℕ} {eps δ : ℝ} (hn : 0 < (n : ℝ)) (hs : 0 < (s : ℝ))
    (A : Fin n → Fin n → ℝ)
    (hden :
      0 < sqMagProbDen
        (elementwiseTruncate (eps / (2 * (n : ℝ))) A))
    (hδ : 0 < δ) (hδ_le_one : δ ≤ 1) (heps : 0 < eps)
    (hsample :
      14 * (n : ℝ) * frobNormSqRect A *
          Real.log (((n : ℝ) + (n : ℝ)) / δ) ≤
        (s : ℝ) * eps ^ 2) :
    let tau : ℝ := eps / (2 * (n : ℝ))
    let Ahat : Fin n → Fin n → ℝ := elementwiseTruncate tau A
    1 - δ ≤
      (sqMagTraceProbability (steps := s) Ahat hden).eventProb
        (algorithm1ExactSpectralEvent s Ahat
          (fun samples : ElementwiseTrace n n s => samples) (eps / 2)) := by
  classical
  let tau : ℝ := eps / (2 * (n : ℝ))
  let Ahat : Fin n → Fin n → ℝ := elementwiseTruncate tau A
  let r : ℝ := eps / 2
  let L : ℝ :=
    (1 / (s : ℝ)) * frobNormRect Ahat +
      frobNormSqRect Ahat / ((s : ℝ) * tau)
  let V : ℝ := (n : ℝ) * (frobNormSqRect Ahat / (s : ℝ) ^ 2)
  let W : ℝ := (s : ℝ) * V
  let q : ℝ := Real.log (((n : ℝ) + (n : ℝ)) / δ)
  intro tau' Ahat'
  have htau_pos : 0 < tau := by
    dsimp [tau]
    positivity
  have hr : 0 < r := by
    dsimp [r]
    positivity
  have hdim : 0 < (n : ℝ) + (n : ℝ) := by nlinarith
  have hFhatSq_pos : 0 < frobNormSqRect Ahat := by
    simpa [Ahat, tau, sqMagProbDen] using hden
  have hFhat_pos : 0 < frobNormRect Ahat := by
    have hne : frobNormRect Ahat ≠ 0 := by
      intro hzero
      have hsq_zero : frobNormSqRect Ahat = 0 := by
        rw [← frobNormRect_sq Ahat, hzero]
        norm_num
      linarith
    exact lt_of_le_of_ne (frobNormRect_nonneg Ahat) (Ne.symm hne)
  have hFsq_pos : 0 < frobNormSqRect A := by
    exact lt_of_lt_of_le hFhatSq_pos
      (by simpa [Ahat, tau] using frobNormSqRect_elementwiseTruncate_le tau A)
  have hFhatSq_le_Fsq : frobNormSqRect Ahat ≤ frobNormSqRect A := by
    simpa [Ahat, tau] using frobNormSqRect_elementwiseTruncate_le tau A
  have htau_le_Fhat : tau ≤ frobNormRect Ahat := by
    simpa [Ahat, tau] using
      elementwiseTruncate_tau_le_frobNormRect_of_sqMagProbDen_pos
        (tau := tau) A (by simpa [Ahat, tau] using hden)
  have heps_le_two_n_Fhat :
      eps ≤ 2 * (n : ℝ) * frobNormRect Ahat := by
    have hmul :=
      mul_le_mul_of_nonneg_left htau_le_Fhat
        (by positivity : 0 ≤ 2 * (n : ℝ))
    dsimp [tau] at hmul
    field_simp [hn.ne'] at hmul
    nlinarith
  have heps_mul_Fhat_le :
      eps * frobNormRect Ahat ≤
        2 * (n : ℝ) * frobNormSqRect Ahat := by
    have hmul :=
      mul_le_mul_of_nonneg_right heps_le_two_n_Fhat
        (le_of_lt hFhat_pos)
    calc
      eps * frobNormRect Ahat
          ≤ 2 * (n : ℝ) * frobNormRect Ahat * frobNormRect Ahat := hmul
      _ = 2 * (n : ℝ) * frobNormSqRect Ahat := by
          rw [← frobNormRect_sq Ahat]
          ring
  have hD_bound :
      2 * W + (2 / 3 : ℝ) * L * r ≤
        ((7 / 2 : ℝ) * (n : ℝ) * frobNormSqRect A) / (s : ℝ) := by
    dsimp [W, V, L, r, tau]
    field_simp [hs.ne', hn.ne', htau_pos.ne']
    nlinarith [heps_mul_Fhat_le, hFhatSq_le_Fsq]
  have hD_pos : 0 < 2 * W + (2 / 3 : ℝ) * L * r := by
    have hL_pos : 0 < L := by
      have hfirst : 0 ≤ (1 / (s : ℝ)) * frobNormRect Ahat :=
        mul_nonneg (by positivity) (frobNormRect_nonneg Ahat)
      have hsecond : 0 < frobNormSqRect Ahat / ((s : ℝ) * tau) :=
        div_pos hFhatSq_pos (mul_pos hs htau_pos)
      exact add_pos_of_nonneg_of_pos hfirst hsecond
    have hV_pos : 0 < V := by
      have hs_sq : 0 < (s : ℝ) ^ 2 := sq_pos_of_pos hs
      have hfrac : 0 < frobNormSqRect Ahat / (s : ℝ) ^ 2 :=
        div_pos hFhatSq_pos hs_sq
      dsimp [V]
      exact mul_pos hn hfrac
    have hW_pos : 0 < W := by
      dsimp [W]
      exact mul_pos hs hV_pos
    positivity
  have hq_le_sample :
      q ≤ ((s : ℝ) * eps ^ 2) /
          (14 * (n : ℝ) * frobNormSqRect A) := by
    have hden_sample : 0 < 14 * (n : ℝ) * frobNormSqRect A := by
      positivity
    exact (le_div_iff₀ hden_sample).mpr (by
      dsimp [q]
      nlinarith [hsample])
  have hsample_factor_nonneg :
      0 ≤ ((s : ℝ) * eps ^ 2) /
          (14 * (n : ℝ) * frobNormSqRect A) := by
    positivity
  have hqD_le : q * (2 * W + (2 / 3 : ℝ) * L * r) ≤ r ^ 2 := by
    have h1 :
        q * (2 * W + (2 / 3 : ℝ) * L * r) ≤
          (((s : ℝ) * eps ^ 2) /
            (14 * (n : ℝ) * frobNormSqRect A)) *
            (2 * W + (2 / 3 : ℝ) * L * r) :=
      mul_le_mul_of_nonneg_right hq_le_sample (le_of_lt hD_pos)
    have h2 :
        (((s : ℝ) * eps ^ 2) /
            (14 * (n : ℝ) * frobNormSqRect A)) *
            (2 * W + (2 / 3 : ℝ) * L * r) ≤
          (((s : ℝ) * eps ^ 2) /
            (14 * (n : ℝ) * frobNormSqRect A)) *
            (((7 / 2 : ℝ) * (n : ℝ) * frobNormSqRect A) / (s : ℝ)) :=
      mul_le_mul_of_nonneg_left hD_bound hsample_factor_nonneg
    have h3 :
        (((s : ℝ) * eps ^ 2) /
            (14 * (n : ℝ) * frobNormSqRect A)) *
            (((7 / 2 : ℝ) * (n : ℝ) * frobNormSqRect A) / (s : ℝ)) =
          r ^ 2 := by
      dsimp [r]
      field_simp [hs.ne', hn.ne', (ne_of_gt hFsq_pos)]
      ring
    exact h1.trans (h2.trans_eq h3)
  have hbudget :
      q ≤ r ^ 2 / (2 * W + (2 / 3 : ℝ) * L * r) :=
    (le_div_iff₀ hD_pos).mpr hqD_le
  simpa [tau, Ahat, r, L, V, W, q] using
    sqMagTraceProbability_eventProb_algorithm1ExactSpectralEvent_truncatedTraceResidual_ge_one_sub_delta_bernstein_denominator_two_thirds_one_tail
      (n := n) (s := s) (tau := tau) (δ := δ) (r := r)
      htau_pos hs A (by simpa [Ahat, tau] using hden) hdim hδ hδ_le_one hr
      (by simpa [Ahat, L, V, W, q] using hbudget)

/-- Corrected source budget after truncation transfer: `14*n*‖A‖²*log(2n/δ)`. -/
theorem sqMagTraceProbability_eventProb_algorithm1ExactTruncatedSpectralEvent_ge_one_sub_delta_source_sample_budget_one_tail
    {n s : ℕ} {eps δ : ℝ} (hn : 0 < (n : ℝ)) (hs : 0 < (s : ℝ))
    (A : Fin n → Fin n → ℝ)
    (hden :
      0 < sqMagProbDen
        (elementwiseTruncate (eps / (2 * (n : ℝ))) A))
    (hδ : 0 < δ) (hδ_le_one : δ ≤ 1) (heps : 0 < eps)
    (hsample :
      14 * (n : ℝ) * frobNormSqRect A *
          Real.log ((2 * (n : ℝ)) / δ) ≤
        (s : ℝ) * eps ^ 2) :
    let tau : ℝ := eps / (2 * (n : ℝ))
    let Ahat : Fin n → Fin n → ℝ := elementwiseTruncate tau A
    1 - δ ≤
      (sqMagTraceProbability (steps := s) Ahat hden).eventProb
        (algorithm1ExactTruncatedSpectralEvent tau s A
          (fun samples : ElementwiseTrace n n s => samples) eps) := by
  classical
  let tau : ℝ := eps / (2 * (n : ℝ))
  let Ahat : Fin n → Fin n → ℝ := elementwiseTruncate tau A
  intro tau' Ahat'
  let P := sqMagTraceProbability (steps := s) Ahat hden
  have hn_nat : 0 < n := by exact_mod_cast hn
  have hProb :
      1 - δ ≤ P.eventProb
        (algorithm1ExactSpectralEvent s Ahat
          (fun samples : ElementwiseTrace n n s => samples) (eps / 2)) := by
    simpa [P, tau, Ahat] using
      sqMagTraceProbability_eventProb_algorithm1ExactSpectralEvent_truncatedTraceResidual_ge_one_sub_delta_source_sample_budget_one_tail
        (n := n) (s := s) (eps := eps) (δ := δ)
        hn hs A hden hδ hδ_le_one heps (by simpa [two_mul] using hsample)
  exact
    probability_algorithm1_exact_truncated_spectral_of_sampled_half
      (s := s) (A := A)
      (X := fun samples : ElementwiseTrace n n s => samples)
      (Pr := P) (ρ := 1 - δ) (eps := eps)
      (le_of_lt heps) hn_nat hProb

end NumStability
