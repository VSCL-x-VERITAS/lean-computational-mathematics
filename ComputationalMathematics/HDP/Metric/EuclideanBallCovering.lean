import ComputationalMathematics.HDP.Metric.Euclidean
import Mathlib.Data.ENNReal.Inv
import Mathlib.MeasureTheory.Covering.BesicovitchVectorSpace

/-!
# Volumetric covering bounds for Euclidean balls and spheres

This module proves the exact finite-dimensional estimates obtained by comparing
the volumes of a Euclidean ball, a finite internal cover, and a maximal
separated set.  Cardinalities are exposed through the finite value of
Mathlib's internal `Metric.coveringNumber`.
-/

noncomputable section

open Metric Set Module MeasureTheory Filter
open scoped ENNReal NNReal Pointwise Topology Function

namespace NumStability.HDP.Metric

/-- The additive Haar volume of a finite-dimensional real normed space,
evaluated using its canonical Borel measurable structure. -/
noncomputable def borelAddHaarVolume
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E] (s : Set E) : ℝ≥0∞ := by
  letI : MeasurableSpace E := borel E
  letI : BorelSpace E := ⟨rfl⟩
  exact Measure.addHaar s

theorem measure_le_card_mul_measure_closedBall_of_finset_cover
    {E : Type*} [NormedAddCommGroup E] [MeasurableSpace E] [BorelSpace E]
    (mu : Measure E) [Measure.IsAddHaarMeasure mu]
    (K : Set E) (C : Finset E) (r : ℝ)
    (hcover : ∀ x ∈ K, ∃ y ∈ C, dist x y ≤ r) :
    mu K ≤ (C.card : ℝ≥0∞) * mu (closedBall (0 : E) r) := by
  let U : Set E := ⋃ y ∈ C, closedBall y r
  have hsubset : K ⊆ U := by
    intro x hx
    obtain ⟨y, hy, hxy⟩ := hcover x hx
    simp only [U, mem_iUnion]
    exact ⟨y, ⟨hy, hxy⟩⟩
  calc
    mu K ≤ mu U := measure_mono hsubset
    _ ≤ ∑ y ∈ C, mu (closedBall y r) := measure_biUnion_finset_le C _
    _ = (C.card : ℝ≥0∞) * mu (closedBall (0 : E) r) := by
      simp only [mu.addHaar_closedBall_center, Finset.sum_const, nsmul_eq_mul]

theorem card_mul_measure_ball_le_measure_add_closedBall_of_finset_separated
    {E : Type*} [NormedAddCommGroup E] [MeasurableSpace E] [BorelSpace E]
    (mu : Measure E) [Measure.IsAddHaarMeasure mu]
    (K : Set E) (C : Finset E) {r : ℝ} (hr : 0 < r)
    (hC : ∀ x ∈ C, x ∈ K)
    (hsep : ∀ x ∈ C, ∀ y ∈ C, x ≠ y → r < ‖x - y‖) :
    (C.card : ℝ≥0∞) * mu (ball (0 : E) (r / 2)) ≤
      mu (K + closedBall (0 : E) (r / 2)) := by
  let delta : ℝ := r / 2
  have hdelta : 0 < delta := by
    dsimp [delta]
    positivity
  let U : Set E := ⋃ x ∈ C, ball (x : E) delta
  have hdisjoint : Set.Pairwise (C : Set E)
      (Disjoint on fun x ↦ ball (x : E) delta) := by
    rintro x hx y hy hxy
    apply ball_disjoint_ball
    rw [dist_eq_norm]
    have h := hsep x hx y hy hxy
    dsimp [delta]
    linarith
  have hsubset : U ⊆ K + closedBall (0 : E) delta := by
    refine iUnion₂_subset fun x hx ↦ ?_
    intro z hz
    refine Set.mem_add.2 ⟨x, hC x hx, z - x, ?_, by abel⟩
    rw [mem_closedBall, dist_zero_right]
    exact le_of_lt (by simpa [dist_eq_norm] using hz)
  calc
    (C.card : ℝ≥0∞) * mu (ball (0 : E) (r / 2)) = mu U := by
      change (C.card : ℝ≥0∞) * mu (ball (0 : E) delta) =
        mu (⋃ x ∈ C, ball (x : E) delta)
      rw [measure_biUnion_finset hdisjoint fun _ _ ↦ measurableSet_ball]
      simp only [mu.addHaar_ball_center, Finset.sum_const, nsmul_eq_mul]
    _ ≤ mu (K + closedBall (0 : E) delta) := measure_mono hsubset
    _ = mu (K + closedBall (0 : E) (r / 2)) := rfl

theorem measure_le_coveringNumber_mul_measure_closedBall
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E]
    (K : Set E) {r : ℝ≥0} (hr : 0 < r) :
    borelAddHaarVolume K ≤
      (Metric.coveringNumber r K : ℝ≥0∞) *
        borelAddHaarVolume (closedBall (0 : E) (r : ℝ)) := by
  borelize E
  change Measure.addHaar K ≤
    (Metric.coveringNumber r K : ℝ≥0∞) *
      Measure.addHaar (closedBall (0 : E) (r : ℝ))
  let mu : Measure E := Measure.addHaar
  by_cases hfinite : Metric.coveringNumber r K ≠ ⊤
  · let P : Set E := Metric.minimalCover r K
    have hPfinite : P.Finite := Metric.finite_minimalCover
    let C : Finset E := hPfinite.toFinset
    have hCcover : ∀ x ∈ K, ∃ y ∈ C, dist x y ≤ (r : ℝ) := by
      intro x hx
      obtain ⟨y, hyP, hxy⟩ := Metric.isCover_minimalCover hfinite hx
      refine ⟨y, by simpa [C] using hyP, ?_⟩
      exact_mod_cast (show nndist x y ≤ r from edist_le_coe.mp hxy)
    have hcard : (C.card : ℕ∞) = Metric.coveringNumber r K := by
      calc
        (C.card : ℕ∞) = P.encard := by
          rw [← hPfinite.cast_ncard_eq]
          change (hPfinite.toFinset.card : ℕ∞) = (P.ncard : ℕ∞)
          exact congrArg (fun n : ℕ ↦ (n : ℕ∞))
            (Set.ncard_eq_toFinset_card P hPfinite).symm
        _ = Metric.coveringNumber r K := Metric.encard_minimalCover hfinite
    have hcard' : (C.card : ℝ≥0∞) =
        (Metric.coveringNumber r K : ℝ≥0∞) := by
      exact_mod_cast hcard
    have hbound := measure_le_card_mul_measure_closedBall_of_finset_cover
      mu K C (r : ℝ) hCcover
    simpa [mu, hcard'] using hbound
  · have htop : Metric.coveringNumber r K = ⊤ := not_ne_iff.mp hfinite
    have hballPos : 0 < Measure.addHaar (closedBall (0 : E) (r : ℝ)) :=
      (measure_ball_pos Measure.addHaar (0 : E)
        (show 0 < (r : ℝ) by exact_mod_cast hr)).trans_le
          (measure_mono ball_subset_closedBall)
    simp [htop, hballPos.ne']

theorem packingNumber_mul_measure_ball_le_measure_add_closedBall
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E]
    (K : Set E) {r : ℝ≥0} (hr : 0 < r) :
    (Metric.packingNumber r K : ℝ≥0∞) *
        borelAddHaarVolume (ball (0 : E) ((r : ℝ) / 2)) ≤
      borelAddHaarVolume (K + closedBall (0 : E) ((r : ℝ) / 2)) := by
  borelize E
  change (Metric.packingNumber r K : ℝ≥0∞) *
      Measure.addHaar (ball (0 : E) ((r : ℝ) / 2)) ≤
    Measure.addHaar (K + closedBall (0 : E) ((r : ℝ) / 2))
  let mu : Measure E := Measure.addHaar
  let delta : ℝ := (r : ℝ) / 2
  have hdelta : 0 < delta := by
    dsimp [delta]
    positivity
  by_cases hfinite : Metric.packingNumber r K ≠ ⊤
  · let P : Set E := Metric.maximalSeparatedSet r K
    have hPfinite : P.Finite := by
      apply Set.encard_lt_top_iff.mp
      rw [Metric.encard_maximalSeparatedSet hfinite]
      exact hfinite.lt_top
    let C : Finset E := hPfinite.toFinset
    have hC : ∀ x ∈ C, x ∈ K := by
      intro x hx
      exact Metric.maximalSeparatedSet_subset (by simpa [C] using hx)
    have hsep : ∀ x ∈ C, ∀ y ∈ C, x ≠ y → (r : ℝ) < ‖x - y‖ := by
      intro x hx y hy hxy
      have hxP : x ∈ P := by simpa [C] using hx
      have hyP : y ∈ P := by simpa [C] using hy
      have h := Metric.isSeparated_maximalSeparatedSet hxP hyP hxy
      change ((r : ℝ≥0) : ℝ≥0∞) < edist x y at h
      rw [edist_dist] at h
      have hreal : (r : ℝ) < dist x y := by
        simpa using ENNReal.coe_lt_ofReal.mp h
      simpa [dist_eq_norm] using hreal
    have hcard : (C.card : ℕ∞) = Metric.packingNumber r K := by
      calc
        (C.card : ℕ∞) = P.encard := by
          rw [← hPfinite.cast_ncard_eq]
          change (hPfinite.toFinset.card : ℕ∞) = (P.ncard : ℕ∞)
          exact congrArg (fun n : ℕ ↦ (n : ℕ∞))
            (Set.ncard_eq_toFinset_card P hPfinite).symm
        _ = Metric.packingNumber r K := Metric.encard_maximalSeparatedSet hfinite
    have hcard' : (C.card : ℝ≥0∞) =
        (Metric.packingNumber r K : ℝ≥0∞) := by
      exact_mod_cast hcard
    have hbound := card_mul_measure_ball_le_measure_add_closedBall_of_finset_separated
      mu K C (show 0 < (r : ℝ) by exact_mod_cast hr) hC hsep
    simpa [mu, hcard'] using hbound
  · have htop : Metric.packingNumber r K = ⊤ := not_ne_iff.mp hfinite
    have hballPos : 0 < mu (ball (0 : E) delta) :=
      measure_ball_pos mu (0 : E) hdelta
    have hnat : ∀ n : ℕ,
        (n : ℝ≥0∞) * mu (ball (0 : E) delta) ≤
          mu (K + closedBall (0 : E) delta) := by
      intro n
      have hnlt : (n : ℕ∞) < Metric.packingNumber r K := by
        rw [htop]
        exact ENat.coe_lt_top n
      rw [Metric.packingNumber] at hnlt
      obtain ⟨S, hnS⟩ := lt_iSup_iff.mp hnlt
      obtain ⟨hSK, hnS⟩ := lt_iSup_iff.mp hnS
      obtain ⟨hSsep, hnS⟩ := lt_iSup_iff.mp hnS
      obtain ⟨T, hTS, hTcard⟩ := Set.exists_subset_encard_eq hnS.le
      have hTfinite : T.Finite := Set.encard_lt_top_iff.mp (by
        rw [hTcard]
        exact ENat.coe_lt_top n)
      let C : Finset E := hTfinite.toFinset
      have hC : ∀ x ∈ C, x ∈ K := by
        intro x hx
        exact hSK (hTS (by simpa [C] using hx))
      have hsep : ∀ x ∈ C, ∀ y ∈ C, x ≠ y → (r : ℝ) < ‖x - y‖ := by
        intro x hx y hy hxy
        have hxT : x ∈ T := by simpa [C] using hx
        have hyT : y ∈ T := by simpa [C] using hy
        have h := hSsep (hTS hxT) (hTS hyT) hxy
        change ((r : ℝ≥0) : ℝ≥0∞) < edist x y at h
        rw [edist_dist] at h
        have hreal : (r : ℝ) < dist x y := by
          simpa using ENNReal.coe_lt_ofReal.mp h
        simpa [dist_eq_norm] using hreal
      have hCcard : C.card = n := by
        have hencard : (C.card : ℕ∞) = (n : ℕ∞) := by
          calc
            (C.card : ℕ∞) = T.encard := by
              rw [← hTfinite.cast_ncard_eq]
              change (hTfinite.toFinset.card : ℕ∞) = (T.ncard : ℕ∞)
              exact congrArg (fun k : ℕ ↦ (k : ℕ∞))
                (Set.ncard_eq_toFinset_card T hTfinite).symm
            _ = (n : ℕ∞) := hTcard
        exact ENat.coe_inj.mp hencard
      have hbound := card_mul_measure_ball_le_measure_add_closedBall_of_finset_separated
        mu K C (show 0 < (r : ℝ) by exact_mod_cast hr) hC hsep
      simpa [delta, hCcard] using hbound
    have hmeasureTop : mu (K + closedBall (0 : E) delta) = ⊤ := by
      apply top_unique
      calc
        ⊤ = (⨆ n : ℕ, (n : ℝ≥0∞)) * mu (ball (0 : E) delta) := by
          rw [ENNReal.iSup_natCast]
          simp [hballPos.ne']
        _ = ⨆ n : ℕ, (n : ℝ≥0∞) * mu (ball (0 : E) delta) :=
          ENNReal.iSup_mul _ _
        _ ≤ mu (K + closedBall (0 : E) delta) := iSup_le hnat
    simp [mu, delta, htop, hmeasureTop, hballPos.ne']

theorem finite_internal_cover_card_mul_radius_pow_ge_one
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E]
    (s : Finset E) {r : ℝ} (hr : 0 < r)
    (hs : ∀ x : E, ‖x‖ ≤ 1 → ∃ y ∈ s, ‖x - y‖ ≤ r) :
    1 ≤ (s.card : ℝ) * r ^ finrank ℝ E := by
  borelize E
  let μ : Measure E := Measure.addHaar
  let B : Set E := closedBall 0 1
  let U : Set E := ⋃ y ∈ s, closedBall y r
  have hsubset : B ⊆ U := by
    intro x hx
    obtain ⟨y, hy, hxy⟩ := hs x (by simpa [B, mem_closedBall, dist_zero_right] using hx)
    simp only [U, mem_iUnion]
    exact ⟨y, ⟨hy, by simpa [mem_closedBall, dist_eq_norm] using hxy⟩⟩
  have hmeasure : μ B ≤ (s.card : ℝ≥0∞) *
      ENNReal.ofReal (r ^ finrank ℝ E) * μ (ball 0 1) := by
    calc
      μ B ≤ μ U := measure_mono hsubset
      _ ≤ ∑ y ∈ s, μ (closedBall y r) := measure_biUnion_finset_le s _
      _ = (s.card : ℝ≥0∞) * ENNReal.ofReal (r ^ finrank ℝ E) *
          μ (ball 0 1) := by
        simp only [μ.addHaar_closedBall _ hr.le, Finset.sum_const,
          nsmul_eq_mul, mul_assoc]
  have hscale : μ B = μ (ball 0 1) := by
    simpa [B] using μ.addHaar_unitClosedBall_eq_addHaar_unitBall
  rw [hscale] at hmeasure
  have hcancel : 1 ≤ (s.card : ℝ≥0∞) * ENNReal.ofReal (r ^ finrank ℝ E) := by
    exact (ENNReal.mul_le_mul_iff_left
      (measure_ball_pos μ (0 : E) zero_lt_one).ne'
      measure_ball_lt_top.ne).1 (by simpa [mul_assoc] using hmeasure)
  have htop : (s.card : ℝ≥0∞) * ENNReal.ofReal (r ^ finrank ℝ E) ≠ ∞ :=
    ENNReal.mul_ne_top (ENNReal.natCast_ne_top _) ENNReal.ofReal_ne_top
  have hreal : (1 : ℝ≥0∞).toReal ≤
      ((s.card : ℝ≥0∞) * ENNReal.ofReal (r ^ finrank ℝ E)).toReal :=
    (ENNReal.toReal_le_toReal (by simp) htop).2 hcancel
  simpa [ENNReal.toReal_mul, pow_nonneg hr.le] using hreal

theorem finite_unit_subset_separated_card_mul_halfRadius_pow_le
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E]
    (s : Finset E) {r : ℝ} (hr : 0 < r)
    (hs : ∀ x ∈ s, ‖x‖ ≤ 1)
    (hsep : ∀ x ∈ s, ∀ y ∈ s, x ≠ y → r < ‖x - y‖) :
    (s.card : ℝ) * (r / 2) ^ finrank ℝ E ≤
      (1 + r / 2) ^ finrank ℝ E := by
  borelize E
  let μ : Measure E := Measure.addHaar
  let δ : ℝ := r / 2
  let ρ : ℝ := 1 + r / 2
  have hδ : 0 < δ := by dsimp [δ]; positivity
  have hρ : 0 < ρ := by dsimp [ρ]; positivity
  set A := ⋃ x ∈ s, ball (x : E) δ with hA
  have hdisjoint : Set.Pairwise (s : Set E)
      (Disjoint on fun x ↦ ball (x : E) δ) := by
    rintro x hx y hy hxy
    apply ball_disjoint_ball
    rw [dist_eq_norm]
    have h := hsep x hx y hy hxy
    dsimp [δ]
    linarith
  have hsubset : A ⊆ ball (0 : E) ρ := by
    refine iUnion₂_subset fun x hx ↦ ?_
    apply ball_subset_ball'
    calc
      δ + dist x 0 ≤ δ + 1 := by
        rw [dist_zero_right]
        gcongr
        exact hs x hx
      _ = ρ := by simp [δ, ρ, add_comm]
  have hmeasure :
      (s.card : ℝ≥0∞) * ENNReal.ofReal (δ ^ finrank ℝ E) *
          μ (ball 0 1) ≤
        ENNReal.ofReal (ρ ^ finrank ℝ E) * μ (ball 0 1) := by
    calc
      (s.card : ℝ≥0∞) * ENNReal.ofReal (δ ^ finrank ℝ E) *
          μ (ball 0 1) = μ A := by
        rw [hA, measure_biUnion_finset hdisjoint fun x _ ↦ measurableSet_ball]
        simp only [μ.addHaar_ball_of_pos _ hδ]
        simp only [Finset.sum_const, nsmul_eq_mul, mul_assoc]
      _ ≤ μ (ball (0 : E) ρ) := measure_mono hsubset
      _ = ENNReal.ofReal (ρ ^ finrank ℝ E) * μ (ball 0 1) := by
        simp only [μ.addHaar_ball_of_pos _ hρ]
  have hcancel :
      (s.card : ℝ≥0∞) * ENNReal.ofReal (δ ^ finrank ℝ E) ≤
        ENNReal.ofReal (ρ ^ finrank ℝ E) :=
    (ENNReal.mul_le_mul_iff_left
      (measure_ball_pos μ (0 : E) zero_lt_one).ne'
      measure_ball_lt_top.ne).1 hmeasure
  have hleftTop :
      (s.card : ℝ≥0∞) * ENNReal.ofReal (δ ^ finrank ℝ E) ≠ ∞ :=
    ENNReal.mul_ne_top (ENNReal.natCast_ne_top _) ENNReal.ofReal_ne_top
  have hreal :
      ((s.card : ℝ≥0∞) * ENNReal.ofReal (δ ^ finrank ℝ E)).toReal ≤
        (ENNReal.ofReal (ρ ^ finrank ℝ E)).toReal :=
    (ENNReal.toReal_le_toReal hleftTop ENNReal.ofReal_ne_top).2 hcancel
  simpa [ENNReal.toReal_mul, pow_nonneg hδ.le, pow_nonneg hρ.le, δ, ρ] using hreal

theorem coveringNumber_toNat_mul_halfRadius_pow_le_of_compact_unit_subset
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E]
    (A : Set E) (hAcompact : IsCompact A)
    (hAunit : A ⊆ closedBall (0 : E) 1)
    {r : ℝ≥0} (hr : 0 < r) :
    ((Metric.coveringNumber r A).toNat : ℝ) * ((r : ℝ) / 2) ^ finrank ℝ E ≤
      (1 + (r : ℝ) / 2) ^ finrank ℝ E := by
  obtain ⟨C, _hCA, hCfinite, hCcover⟩ :=
    Metric.exists_finite_isCover_of_isCompact
      (s := A) (ε := r / 2) (by positivity) hAcompact
  have hpackingFinite : Metric.packingNumber r A ≠ ⊤ := by
    apply ne_of_lt
    calc
      Metric.packingNumber r A = Metric.packingNumber (2 * (r / 2)) A := by
        congr 2
        ring
      _ ≤ Metric.externalCoveringNumber (r / 2) A :=
        Metric.packingNumber_two_mul_le_externalCoveringNumber (r / 2) A
      _ ≤ C.encard := hCcover.externalCoveringNumber_le_encard
      _ < ⊤ := Set.encard_lt_top_iff.mpr hCfinite
  let P : Set E := Metric.maximalSeparatedSet r A
  have hPfinite : P.Finite := by
    apply Set.encard_lt_top_iff.mp
    rw [Metric.encard_maximalSeparatedSet hpackingFinite]
    exact hpackingFinite.lt_top
  let s : Finset E := hPfinite.toFinset
  have hsunit : ∀ x ∈ s, ‖x‖ ≤ 1 := by
    intro x hx
    have hxP : x ∈ P := by simpa [s] using hx
    have hxA := Metric.maximalSeparatedSet_subset hxP
    simpa [mem_closedBall, dist_zero_right] using hAunit hxA
  have hsep : ∀ x ∈ s, ∀ y ∈ s, x ≠ y → (r : ℝ) < ‖x - y‖ := by
    intro x hx y hy hxy
    have hxP : x ∈ P := by simpa [s] using hx
    have hyP : y ∈ P := by simpa [s] using hy
    have h := Metric.isSeparated_maximalSeparatedSet hxP hyP hxy
    change ((r : ℝ≥0) : ℝ≥0∞) < edist x y at h
    rw [edist_dist] at h
    have hreal : (r : ℝ) < dist x y := by
      simpa using ENNReal.coe_lt_ofReal.mp h
    simpa [dist_eq_norm] using hreal
  have hsbound := finite_unit_subset_separated_card_mul_halfRadius_pow_le
    s (show 0 < (r : ℝ) by exact_mod_cast hr) hsunit hsep
  have hcard : (Metric.coveringNumber r A).toNat ≤ s.card := by
    have hle : Metric.coveringNumber r A ≤ Metric.packingNumber r A :=
      Metric.coveringNumber_le_packingNumber r A
    have hleNat := ENat.toNat_le_toNat hle hpackingFinite
    have hpackCard : (Metric.packingNumber r A).toNat = s.card := by
      calc
        (Metric.packingNumber r A).toNat = P.encard.toNat :=
          congrArg ENat.toNat (Metric.encard_maximalSeparatedSet hpackingFinite).symm
        _ = P.ncard := rfl
        _ = s.card := Set.ncard_eq_toFinset_card P hPfinite
    simpa [hpackCard] using hleNat
  calc
    ((Metric.coveringNumber r A).toNat : ℝ) * ((r : ℝ) / 2) ^ finrank ℝ E ≤
        (s.card : ℝ) * ((r : ℝ) / 2) ^ finrank ℝ E := by
      gcongr
    _ ≤ (1 + (r : ℝ) / 2) ^ finrank ℝ E := hsbound

theorem coveringNumber_toNat_le_two_div_add_one_pow_of_compact_unit_subset
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E]
    (A : Set E) (hAcompact : IsCompact A)
    (hAunit : A ⊆ closedBall (0 : E) 1)
    {r : ℝ≥0} (hr : 0 < r) :
    ((Metric.coveringNumber r A).toNat : ℝ) ≤
      (2 / (r : ℝ) + 1) ^ finrank ℝ E := by
  have hmul := coveringNumber_toNat_mul_halfRadius_pow_le_of_compact_unit_subset
    A hAcompact hAunit hr
  have hhalf : 0 < (r : ℝ) / 2 := by positivity
  have hhalfPow : 0 < ((r : ℝ) / 2) ^ finrank ℝ E := pow_pos hhalf _
  calc
    ((Metric.coveringNumber r A).toNat : ℝ) ≤
        (1 + (r : ℝ) / 2) ^ finrank ℝ E /
          (((r : ℝ) / 2) ^ finrank ℝ E) :=
      (le_div_iff₀ hhalfPow).2 hmul
    _ = ((1 + (r : ℝ) / 2) / ((r : ℝ) / 2)) ^ finrank ℝ E := by
      conv_rhs => rw [div_pow]
    _ = (2 / (r : ℝ) + 1) ^ finrank ℝ E := by
      congr 1
      field_simp

theorem one_div_pow_le_coveringNumber_unitClosedBall_toNat
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E]
    {r : ℝ≥0} (hr : 0 < r) :
    (1 / (r : ℝ)) ^ finrank ℝ E ≤
      ((Metric.coveringNumber r (closedBall (0 : E) 1)).toNat : ℝ) := by
  let B : Set E := closedBall (0 : E) 1
  obtain ⟨C, _hCB, hCfinite, hCcover⟩ :=
    Metric.exists_finite_isCover_of_isCompact
      (s := B) (ε := r) hr.ne' (isCompact_closedBall (0 : E) 1)
  have hcoverFinite : Metric.coveringNumber r B ≠ ⊤ := by
    apply ne_of_lt
    calc
      Metric.coveringNumber r B ≤ C.encard :=
        hCcover.coveringNumber_le_encard _hCB
      _ < ⊤ := Set.encard_lt_top_iff.mpr hCfinite
  let P : Set E := Metric.minimalCover r B
  have hPfinite : P.Finite := Metric.finite_minimalCover
  let s : Finset E := hPfinite.toFinset
  have hPcover : Metric.IsCover r B P := Metric.isCover_minimalCover hcoverFinite
  have hscover : ∀ x : E, ‖x‖ ≤ 1 → ∃ y ∈ s, ‖x - y‖ ≤ (r : ℝ) := by
    intro x hx
    have hxB : x ∈ B := by simpa [B, mem_closedBall, dist_zero_right]
    obtain ⟨y, hyP, hxy⟩ := hPcover hxB
    refine ⟨y, by simpa [s] using hyP, ?_⟩
    have hdist : dist x y ≤ (r : ℝ) := by
      exact_mod_cast (show nndist x y ≤ r from edist_le_coe.mp hxy)
    simpa [dist_eq_norm] using hdist
  have hbasic := finite_internal_cover_card_mul_radius_pow_ge_one
    s (show 0 < (r : ℝ) by exact_mod_cast hr) hscover
  have hcard : s.card = (Metric.coveringNumber r B).toNat := by
    calc
      s.card = P.ncard := (Set.ncard_eq_toFinset_card P hPfinite).symm
      _ = P.encard.toNat := rfl
      _ = (Metric.coveringNumber r B).toNat :=
        congrArg ENat.toNat (Metric.encard_minimalCover hcoverFinite)
  have hrpow : 0 < (r : ℝ) ^ finrank ℝ E := by positivity
  calc
    (1 / (r : ℝ)) ^ finrank ℝ E =
        1 / ((r : ℝ) ^ finrank ℝ E) := by
      simp only [one_div, inv_pow]
    _ ≤ (s.card : ℝ) := (div_le_iff₀ hrpow).2 hbasic
    _ = ((Metric.coveringNumber r B).toNat : ℝ) := by exact_mod_cast hcard

theorem euclideanUnitBall_coveringNumber_bounds
    (n : ℕ) {r : ℝ≥0} (hr : 0 < r) :
    (1 / (r : ℝ)) ^ n ≤
        ((Metric.coveringNumber r
          (closedBall (0 : EuclideanSpace ℝ (Fin n)) 1)).toNat : ℝ) ∧
      ((Metric.coveringNumber r
          (closedBall (0 : EuclideanSpace ℝ (Fin n)) 1)).toNat : ℝ) ≤
        (2 / (r : ℝ) + 1) ^ n := by
  constructor
  · simpa using
      (one_div_pow_le_coveringNumber_unitClosedBall_toNat
        (E := EuclideanSpace ℝ (Fin n)) hr)
  · simpa using
      (coveringNumber_toNat_le_two_div_add_one_pow_of_compact_unit_subset
        (closedBall (0 : EuclideanSpace ℝ (Fin n)) 1)
        (isCompact_closedBall (0 : EuclideanSpace ℝ (Fin n)) 1) (by rfl) hr)

theorem euclideanUnitSphere_coveringNumber_upper_bound
    (n : ℕ) {r : ℝ≥0} (hr : 0 < r) :
    ((Metric.coveringNumber r
        (sphere (0 : EuclideanSpace ℝ (Fin n)) 1)).toNat : ℝ) ≤
      (2 / (r : ℝ) + 1) ^ n := by
  simpa using
    (coveringNumber_toNat_le_two_div_add_one_pow_of_compact_unit_subset
      (sphere (0 : EuclideanSpace ℝ (Fin n)) 1)
      (isCompact_sphere (0 : EuclideanSpace ℝ (Fin n)) 1)
      sphere_subset_closedBall hr)

end NumStability.HDP.Metric
