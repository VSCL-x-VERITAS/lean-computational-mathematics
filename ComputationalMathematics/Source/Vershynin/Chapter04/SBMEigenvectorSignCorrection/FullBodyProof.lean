import ComputationalMathematics.Source.Vershynin.Chapter04.SBMEigenvectorSignCorrection.FullBodyTarget
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBMAllUnitClassification
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SpectralGapCorrectionProof
import ComputationalMathematics.HDP.Graph.BalancedCommunityEquivalence
import ComputationalMathematics.HDP.Graph.FinStochasticBlockRelabeling
import ComputationalMathematics.HDP.Graph.SpectralClusteringRelabeling
import ComputationalMathematics.HDP.Matrix.TwoUnitEigenvectorAlignment
import ComputationalMathematics.HDP.Vector.BinarySignBound

/-!
# Coupled sign recovery for the loopless stochastic block model

The same noise event works for every second ordered unit eigenvector.
-/

noncomputable section

set_option maxHeartbeats 0
set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory
open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

namespace NumStability.HDP.Contract

private theorem population_signal
    {k : ℕ} (hn : 1 < 2 * k) (θ : StochasticBlock.Parameters)
    (community : Fin (2 * k) → Fin 2)
    (hbalanced : ∀ b : Fin 2, Fintype.card {i : Fin (2 * k) // community i = b} = k)
    (hq : 0 < θ.q) (hpq : θ.q < θ.p) :
    ∃ u : EuclideanSpace ℝ (Fin (2 * k)),
      SpectralClustering.IsSecondOrderedEigenvector
        (FinStochasticBlock.expectedAdjacency community θ.p θ.q) hn u ∧
      ∀ i : Fin (2 * k),
        (Real.sqrt (2 * k : ℕ) • u) i = if community i = 0 then 1 else -1 := by
  have hk : 0 < k := by omega
  obtain ⟨e, he⟩ := exists_balancedCommunityIndexEquiv hbalanced
  let canonical := BalancedFinSBM.community k
  let D := BalancedFinSBM.population k θ.p θ.q
  let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
  let b := NumStability.hermitianOrderedEigenbasis hD ⟨1, hn⟩
  have hb : SpectralClustering.IsSecondOrderedEigenvector D hn b :=
    SpectralClustering.secondEigenvector_completeOrderedCertificate D hD hn
  obtain ⟨ρ, hρ, hscale⟩ :=
    BalancedFinSBM.exists_population_second_eigenbasis_sign hk θ hq hpq
  have hcanonical : ∃ u₀ : EuclideanSpace ℝ (Fin (2 * k)),
      SpectralClustering.IsSecondOrderedEigenvector D hn u₀ ∧
      ∀ i, (Real.sqrt (2 * k : ℕ) • u₀) i =
        if canonical i = 0 then 1 else -1 := by
    rcases hρ with rfl | rfl
    · refine ⟨-b, hb.neg, ?_⟩
      intro i
      have hi := congrFun hscale i
      change Real.sqrt ((2 * k : ℕ) : ℝ) * b i =
        -1 * BalancedFinSBM.communitySign k i at hi
      change Real.sqrt ((2 * k : ℕ) : ℝ) * (-b i) =
        if canonical i = 0 then 1 else -1
      have hs : BalancedFinSBM.communitySign k i =
          if canonical i = 0 then 1 else -1 := rfl
      rw [hs] at hi
      linarith
    · refine ⟨b, hb, ?_⟩
      intro i
      have hi := congrFun hscale i
      change Real.sqrt ((2 * k : ℕ) : ℝ) * b i =
        1 * BalancedFinSBM.communitySign k i at hi
      simpa only [one_mul] using hi
  obtain ⟨u₀, hu₀, hsignal₀⟩ := hcanonical
  let L := LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e.symm
  let u := L u₀
  have hmatrix : FinStochasticBlock.expectedAdjacency community θ.p θ.q =
      Matrix.reindex e.symm e.symm D := by
    have hrev : ∀ i, community (e.symm i) = canonical i := by
      intro i
      have hi := he (e.symm i)
      simpa only [Equiv.apply_symm_apply] using hi.symm
    simpa only [D, ← BalancedFinSBM.expectedAdjacency_eq_population] using
      (FinStochasticBlock.expectedAdjacency_reindex canonical community
        e.symm hrev θ.p θ.q).symm
  refine ⟨u, ?_, ?_⟩
  · rw [hmatrix]
    exact (SpectralClustering.isSecondOrderedEigenvector_reindex_iff
      hn e.symm D u₀).mp hu₀
  · intro i
    have hi := hsignal₀ (e i)
    change Real.sqrt ((2 * k : ℕ) : ℝ) * u₀ (e i) =
      if canonical (e i) = 0 then 1 else -1 at hi
    change Real.sqrt ((2 * k : ℕ) : ℝ) * u₀ (e i) =
      if community i = 0 then 1 else -1
    have hlabel : canonical (e i) = community i := he i
    simpa only [hlabel] using hi

private theorem population_gap
    {k : ℕ} (hn : 1 < 2 * k) (θ : StochasticBlock.Parameters)
    (community : Fin (2 * k) → Fin 2)
    (hbalanced : ∀ b : Fin 2, Fintype.card {i : Fin (2 * k) // community i = b} = k)
    (hpq : θ.q < θ.p) :
    let hM := DiscrepancyChildren.BalancedMean.mean_hermitian
      community (θ.p : ℝ) (θ.q : ℝ)
    let μgap : ℝ := min (((θ.p : ℝ) - θ.q) / 2) θ.q
    ∀ j : Fin (2 * k), j ≠ ⟨1, hn⟩ →
      μgap * ((2 * k : ℕ) : ℝ) ≤
        |NumStability.hermitianOrderedEigenvalue hM ⟨1, hn⟩ -
          NumStability.hermitianOrderedEigenvalue hM j| := by
  have hk : 0 < k := by omega
  obtain ⟨_, _, _, _, _, _, _, hgap, _⟩ :=
    DiscrepancyChildren.spectral_gap_correction_child_proved
      k hk θ community hbalanced hpq
  simpa only using hgap

private theorem coupled_bounds_of_norm
    {n : ℕ} (hn : 0 < n) (community : Fin n → Fin 2)
    (u v : EuclideanSpace ℝ (Fin n))
    (hsignal : ∀ i : Fin n,
      (Real.sqrt (n : ℝ) • u) i = if community i = 0 then 1 else -1)
    (s B μgap μfinal : ℝ) (hs : s = -1 ∨ s = 1)
    (hB : 0 ≤ B) (hμgap : 0 < μgap) (hμfinal : 0 < μfinal)
    (hcompare : μfinal ≤ 2 * μgap)
    (hunit : ‖u - s • v‖ ≤ B / (μgap * Real.sqrt (n : ℝ))) :
    ‖u - s • v‖ ≤ Real.sqrt (B ^ 2) / (μgap * Real.sqrt (n : ℝ)) ∧
    (∑ i : Fin n,
      ((if community i = 0 then (1 : ℝ) else -1) -
        (s • (Real.sqrt (n : ℝ) • v)) i) ^ 2) ≤ B ^ 2 / μgap ^ 2 ∧
    (((signDisagreements (fun i : Fin n =>
      if community i = 0 then (1 : ℝ) else -1)
      (s • (Real.sqrt (n : ℝ) • v))).card : ℝ) ≤ B ^ 2 / μgap ^ 2) ∧
    ∃ swapped : Bool,
      s = (if swapped then -1 else 1) ∧
      (((binaryThresholdMisclassifications
        (if swapped then swapBinaryCommunity community else community)
        (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤ B ^ 2 / μgap ^ 2) ∧
      (((binaryThresholdMisclassifications
        (if swapped then swapBinaryCommunity community else community)
        (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤ 4 * (B ^ 2) / μfinal ^ 2) := by
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hsqrt : 0 < Real.sqrt (n : ℝ) := Real.sqrt_pos.2 hnR
  have hscaled :
      ‖Real.sqrt (n : ℝ) • u - s • (Real.sqrt (n : ℝ) • v)‖ ≤ B / μgap := by
    calc
      _ = Real.sqrt (n : ℝ) * ‖u - s • v‖ := by
        rw [show Real.sqrt (n : ℝ) • u - s • (Real.sqrt (n : ℝ) • v) =
          Real.sqrt (n : ℝ) • (u - s • v) by
            simp [smul_sub, smul_smul, mul_comm]]
        rw [norm_smul, Real.norm_eq_abs, abs_of_pos hsqrt]
      _ ≤ Real.sqrt (n : ℝ) * (B / (μgap * Real.sqrt (n : ℝ))) :=
        mul_le_mul_of_nonneg_left hunit hsqrt.le
      _ = B / μgap := by field_simp [hμgap.ne', hsqrt.ne']
  let signal : Fin n → ℝ := fun i => if community i = 0 then 1 else -1
  have hsignal' : Real.sqrt (n : ℝ) • u = signal := by
    ext i
    exact hsignal i
  have hsum_eq : (∑ i : Fin n,
      (signal i - (s • (Real.sqrt (n : ℝ) • v)) i) ^ 2) =
      ‖Real.sqrt (n : ℝ) • u - s • (Real.sqrt (n : ℝ) • v)‖ ^ 2 := by
    rw [EuclideanSpace.norm_sq_eq]
    apply Finset.sum_congr rfl
    intro i _
    simp only [PiLp.sub_apply, Real.norm_eq_abs, sq_abs]
    rw [hsignal i]
  have hsq :
      (∑ i : Fin n, (signal i - (s • (Real.sqrt (n : ℝ) • v)) i) ^ 2) ≤
        B ^ 2 / μgap ^ 2 := by
    rw [hsum_eq]
    calc
      _ ≤ (B / μgap) ^ 2 :=
        (sq_le_sq₀ (norm_nonneg _) (div_nonneg hB hμgap.le)).2 hscaled
      _ = B ^ 2 / μgap ^ 2 := div_pow B μgap 2
  have habs : ∀ i : Fin n, |signal i| = 1 := by
    intro i
    dsimp [signal]
    split <;> simp
  have hsign : ((signDisagreements signal
      (s • (Real.sqrt (n : ℝ) • v))).card : ℝ) ≤ B ^ 2 / μgap ^ 2 :=
    (card_signDisagreements_le_sum_sq _ _ habs).trans hsq
  have hclass (swapped : Bool) (hswap : s = if swapped then -1 else 1) :
      (((binaryThresholdMisclassifications
        (if swapped then swapBinaryCommunity community else community)
        (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤ B ^ 2 / μgap ^ 2) := by
    subst s
    cases swapped
    · change ((binaryThresholdMisclassifications community
          (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤ B ^ 2 / μgap ^ 2
      have hsub := binaryThresholdMisclassifications_subset_signDisagreements
        community signal (Real.sqrt (n : ℝ) • v) (fun i => rfl)
      have hc : ((binaryThresholdMisclassifications community
          (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤
          ((signDisagreements signal (Real.sqrt (n : ℝ) • v)).card : ℝ) := by
        exact_mod_cast Finset.card_le_card hsub
      exact hc.trans (by simpa using hsign)
    · change ((binaryThresholdMisclassifications (swapBinaryCommunity community)
          (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤ B ^ 2 / μgap ^ 2
      have hsub := binaryThresholdMisclassifications_swap_subset_signDisagreements
        community signal (Real.sqrt (n : ℝ) • v) (fun i => rfl)
      have hc : ((binaryThresholdMisclassifications (swapBinaryCommunity community)
          (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤
          ((signDisagreements signal (-(Real.sqrt (n : ℝ) • v))).card : ℝ) := by
        exact_mod_cast Finset.card_le_card hsub
      exact hc.trans (by simpa using hsign)
  have hden : μfinal ^ 2 ≤ 4 * μgap ^ 2 := by
    have hprod : 0 ≤ (2 * μgap - μfinal) * (2 * μgap + μfinal) :=
      mul_nonneg (sub_nonneg.mpr hcompare)
        (add_nonneg (mul_nonneg (by norm_num) hμgap.le) hμfinal.le)
    nlinarith
  have hthreshold : B ^ 2 / μgap ^ 2 ≤ 4 * (B ^ 2) / μfinal ^ 2 := by
    rw [div_le_div_iff₀ (sq_pos_of_pos hμgap) (sq_pos_of_pos hμfinal)]
    nlinarith [mul_le_mul_of_nonneg_left hden (sq_nonneg B)]
  refine ⟨?_, hsq, hsign, ?_⟩
  · simpa only [Real.sqrt_sq_eq_abs, abs_of_nonneg hB] using hunit
  · rcases hs with rfl | rfl
    · exact ⟨true, rfl, hclass true rfl, (hclass true rfl).trans hthreshold⟩
    · exact ⟨false, rfl, hclass false rfl, (hclass false rfl).trans hthreshold⟩

/-- One event supplies the coupled unit-vector, scaled-error and classifier bounds. -/
theorem sbm_eigenvector_sign_correction_full_body_proved : HDP04SBMEigenvectorSignCorrectionFullBodyTarget := by
  obtain ⟨C₀, hC₀, htail⟩ := FinStochasticBlock.exists_operatorNorm_noise_sqrt_tail
  let B : ℝ := 2 * Real.sqrt 2 * C₀
  let C : ℝ := B ^ 2
  have hB : 0 < B := by dsimp [B]; positivity
  refine ⟨C, sq_pos_of_pos hB, ?_⟩
  intro k hn θ community hbalanced hq hpq
  dsimp only
  let n : ℕ := 2 * k
  let P := FinStochasticBlock.measure community θ
  let M := FinStochasticBlock.expectedAdjacency community θ.p θ.q
  let μgap : ℝ := min (((θ.p : ℝ) - θ.q) / 2) θ.q
  let μfinal : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - θ.q)
  let signal : Fin n → ℝ := fun i => if community i = 0 then 1 else -1
  have hn0 : 0 < n := by dsimp [n]; omega
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn0
  have hsqrt : 0 < Real.sqrt (n : ℝ) := Real.sqrt_pos.2 hnR
  have hqR : (0 : ℝ) < θ.q := by exact_mod_cast hq
  have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
  have hμgap : 0 < μgap := by
    dsimp [μgap]
    exact lt_min (half_pos (sub_pos.mpr hpqR)) hqR
  have hμfinal : 0 < μfinal := by
    dsimp [μfinal]
    exact lt_min hqR (sub_pos.mpr hpqR)
  have hcompare1 : μgap ≤ μfinal := by
    dsimp [μgap, μfinal]
    simp only [min_def]
    split <;> split <;> linarith
  have hcompare2 : μfinal ≤ 2 * μgap := by
    dsimp [μgap, μfinal]
    simp only [min_def]
    split <;> split <;> linarith
  have hmean : ∀ i j : Fin n,
      ∫ ω, (FinStochasticBlock.adjacency ω) i j ∂P = M i j := by
    intro i j
    exact FinStochasticBlock.adjacency_expectation community θ i j
  obtain ⟨u, hu, hsignal⟩ := population_signal hn θ community hbalanced hq hpq
  have hM : M.IsHermitian :=
    DiscrepancyChildren.BalancedMean.mean_hermitian community θ.p θ.q
  have hgap : ∀ j : Fin n, j ≠ ⟨1, hn⟩ →
      μgap * (n : ℝ) ≤
        |NumStability.hermitianOrderedEigenvalue hM ⟨1, hn⟩ -
          NumStability.hermitianOrderedEigenvalue hM j| :=
    population_gap hn θ community hbalanced hpq
  refine ⟨hμgap, hμfinal, hcompare1, hcompare2, hmean, u, hu, hsignal, ?_⟩
  let bad : Set (FinStochasticBlock.UpperPair n → Bool) :=
    {ω | C₀ * Real.sqrt (n : ℝ) <
      NumStability.realMatrixOperatorNorm (M - FinStochasticBlock.adjacency ω)}
  have hbad : P.real bad ≤ 4 * Real.exp (-(n : ℝ)) := htail hn0 community θ
  have hgood : 1 - 4 * Real.exp (-(n : ℝ)) ≤ P.real badᶜ := by
    rw [probReal_compl_eq_one_sub (Set.toFinite bad).measurableSet]
    linarith
  have hsub : badᶜ ⊆ {ω |
      ∀ v : EuclideanSpace ℝ (Fin n),
        SpectralClustering.IsSecondOrderedEigenvector
          (FinStochasticBlock.adjacency ω) hn v →
        ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
          ‖u - s • v‖ ≤ Real.sqrt C / (μgap * Real.sqrt (n : ℝ)) ∧
          (∑ i : Fin n,
            (signal i - (s • (Real.sqrt (n : ℝ) • v)) i) ^ 2) ≤
              C / μgap ^ 2 ∧
          (((signDisagreements signal
            (s • (Real.sqrt (n : ℝ) • v))).card : ℝ) ≤
              C / μgap ^ 2) ∧
          ∃ swapped : Bool,
            s = (if swapped then -1 else 1) ∧
            (((binaryThresholdMisclassifications
              (if swapped then swapBinaryCommunity community else community)
              (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤ C / μgap ^ 2) ∧
            (((binaryThresholdMisclassifications
              (if swapped then swapBinaryCommunity community else community)
              (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤ 4 * C / μfinal ^ 2)} := by
    intro ω hω v hv
    have hnoise : NumStability.realMatrixOperatorNorm
        (M - FinStochasticBlock.adjacency ω) ≤ C₀ * Real.sqrt (n : ℝ) :=
      le_of_not_gt hω
    let A := FinStochasticBlock.adjacency ω
    have hA : A.IsHermitian := FinStochasticBlock.adjacency_hermitian ω
    obtain ⟨hunorm, hMu⟩ := hu.spec hM
    obtain ⟨hvnorm, hAv⟩ := hv.spec hA
    obtain ⟨s, hs, hunit0⟩ :=
      NumStability.HDP.Matrix.exists_sign_unit_eigenvectors_norm_sub_le
        M A hM hA ⟨1, hn⟩ (μgap * (n : ℝ))
        (mul_pos hμgap hnR) hgap u v hunorm hvnorm hMu hAv
    have hunit : ‖u - s • v‖ ≤ B / (μgap * Real.sqrt (n : ℝ)) := by
      calc
        _ ≤ 2 * Real.sqrt 2 *
              NumStability.realMatrixOperatorNorm (M - A) /
                (μgap * (n : ℝ)) := hunit0
        _ ≤ 2 * Real.sqrt 2 * (C₀ * Real.sqrt (n : ℝ)) /
                (μgap * (n : ℝ)) := by gcongr
        _ = B / (μgap * Real.sqrt (n : ℝ)) := by
          have hsquare : Real.sqrt (n : ℝ) ^ 2 = (n : ℝ) := Real.sq_sqrt hnR.le
          dsimp [B]
          field_simp [hμgap.ne', hsqrt.ne']
          nlinarith
    obtain ⟨hnorm, hsum, hsign, swapped, hswapped, hclass1, hclass2⟩ :=
      coupled_bounds_of_norm hn0 community u v hsignal s B μgap μfinal
        hs hB.le hμgap hμfinal hcompare2 hunit
    exact ⟨s, hs, hnorm, hsum, hsign, swapped, hswapped, hclass1, hclass2⟩
  exact hgood.trans (measureReal_mono hsub (measure_ne_top P _))

end NumStability.HDP.Contract
