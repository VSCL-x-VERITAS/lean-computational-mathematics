import ComputationalMathematics.HDP.Metric.NetApproximation
import Mathlib.MeasureTheory.Covering.BesicovitchVectorSpace
import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Small finite nets of Euclidean spheres

The volume argument here supplies the explicit quarter-net cardinality used
in the elementary random-matrix norm proof.
-/

noncomputable section

open Metric Set Module MeasureTheory Filter
open scoped ENNReal NNReal Topology Function

namespace NumStability.HDP.Metric

/-- A quarter-separated finite subset of the unit sphere has at most `9^d`
points in real dimension `d`. -/
theorem card_le_nine_pow_finrank_of_unit_quarterSeparated
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E]
    (s : Finset E) (hs : ∀ c ∈ s, ‖c‖ = 1)
    (hsep : ∀ c ∈ s, ∀ d ∈ s, c ≠ d → (1 / 4 : ℝ) < ‖c - d‖) :
    s.card ≤ 9 ^ finrank ℝ E := by
  borelize E
  let μ : Measure E := Measure.addHaar
  let δ : ℝ := (1 : ℝ) / 8
  let ρ : ℝ := (9 : ℝ) / 8
  have hδ : 0 < δ := by norm_num [δ]
  have hρ : 0 < ρ := by norm_num [ρ]
  set A := ⋃ c ∈ s, ball (c : E) δ with hA
  have hdisjoint : Set.Pairwise (s : Set E)
      (Disjoint on fun c ↦ ball (c : E) δ) := by
    rintro c hc d hd hcd
    apply ball_disjoint_ball
    rw [dist_eq_norm]
    have h := hsep c hc d hd hcd
    dsimp [δ]
    linarith
  have hsubset : A ⊆ ball (0 : E) ρ := by
    refine iUnion₂_subset fun x hx ↦ ?_
    apply ball_subset_ball'
    calc
      δ + dist x 0 ≤ δ + 1 := by
        rw [dist_zero_right, hs x hx]
      _ = ρ := by norm_num [δ, ρ]
  have hmeasure :
      (s.card : ℝ≥0∞) * ENNReal.ofReal (δ ^ finrank ℝ E) *
          μ (ball 0 1) ≤
        ENNReal.ofReal (ρ ^ finrank ℝ E) * μ (ball 0 1) := by
    calc
      (s.card : ℝ≥0∞) * ENNReal.ofReal (δ ^ finrank ℝ E) *
          μ (ball 0 1) = μ A := by
        rw [hA, measure_biUnion_finset hdisjoint fun c _ ↦ measurableSet_ball]
        simp only [μ.addHaar_ball_of_pos _ hδ]
        simp only [Finset.sum_const, nsmul_eq_mul, mul_assoc]
      _ ≤ μ (ball (0 : E) ρ) := measure_mono hsubset
      _ = ENNReal.ofReal (ρ ^ finrank ℝ E) * μ (ball 0 1) := by
        simp only [μ.addHaar_ball_of_pos _ hρ]
  have hcancel :
      (s.card : ℝ≥0∞) * ENNReal.ofReal (δ ^ finrank ℝ E) ≤
        ENNReal.ofReal (ρ ^ finrank ℝ E) :=
    (ENNReal.mul_le_mul_iff_left
      (measure_ball_pos _ _ zero_lt_one).ne' measure_ball_lt_top.ne).1 hmeasure
  have hreal : (s.card : ℝ) ≤ (9 : ℝ) ^ finrank ℝ E := by
    have h := ENNReal.toReal_le_of_le_ofReal
      (pow_nonneg hρ.le _) hcancel
    simpa [ρ, δ, div_eq_mul_inv, mul_pow] using h
  exact_mod_cast hreal

/-- Every nonzero-dimensional Euclidean unit sphere has a quarter-net with
at most `9^n` points. -/
theorem exists_quarterNet_card_le_nine_pow (n : ℕ) (hn : 0 < n) :
    ∃ N : Finset (EuclideanSpace ℝ (Fin n)),
      IsFiniteUnitSphereNet (1 / 4 : ℝ) N ∧ N.Nonempty ∧ N.card ≤ 9 ^ n := by
  let E := EuclideanSpace ℝ (Fin n)
  let S : Set E := Metric.sphere 0 1
  have hcompact : IsCompact S := isCompact_sphere 0 1
  obtain ⟨C, hCS, hCfinite, hCcover⟩ :=
    Metric.exists_finite_isCover_of_isCompact
      (ε := (1 / 8 : ℝ≥0)) (by norm_num) hcompact
  have hpackingFinite : Metric.packingNumber (1 / 4 : ℝ≥0) S ≠ ⊤ := by
    apply ne_of_lt
    calc
      Metric.packingNumber (1 / 4 : ℝ≥0) S ≤
          Metric.externalCoveringNumber (1 / 8 : ℝ≥0) S := by
        convert Metric.packingNumber_two_mul_le_externalCoveringNumber
            (1 / 8 : ℝ≥0) S using 1 ; norm_num [div_eq_mul_inv]
      _ ≤ C.encard := hCcover.externalCoveringNumber_le_encard
      _ < ⊤ := Set.encard_lt_top_iff.mpr hCfinite
  let P : Set E := Metric.maximalSeparatedSet (1 / 4 : ℝ≥0) S
  have hPfinite : P.Finite := by
    apply Set.encard_lt_top_iff.mp
    rw [Metric.encard_maximalSeparatedSet hpackingFinite]
    exact hpackingFinite.lt_top
  let N : Finset E := hPfinite.toFinset
  have hPsubset : P ⊆ S := Metric.maximalSeparatedSet_subset
  have hPsep : Metric.IsSeparated (1 / 4 : ℝ≥0) P :=
    Metric.isSeparated_maximalSeparatedSet
  have hPcover : Metric.IsCover (1 / 4 : ℝ≥0) S P :=
    Metric.isCover_maximalSeparatedSet hpackingFinite
  have hnet : IsFiniteUnitSphereNet (1 / 4 : ℝ) N := by
    constructor
    · intro y hy
      have hyP : y ∈ P := by simpa [N] using hy
      have hyS := hPsubset hyP
      simpa [S, Metric.mem_sphere, dist_zero_right] using hyS
    · intro x hx
      have hxS : x ∈ S := by simpa [S, Metric.mem_sphere, dist_zero_right] using hx
      obtain ⟨y, hyP, hxy⟩ := hPcover hxS
      refine ⟨y, by simpa [N] using hyP, ?_⟩
      have hnn := edist_le_coe.mp hxy
      exact_mod_cast (show nndist x y ≤ (1 / 4 : ℝ≥0) from hnn)
  have hNnonempty : N.Nonempty := by
    let i : Fin n := ⟨0, hn⟩
    let e : E := EuclideanSpace.single i 1
    have he : ‖e‖ = 1 := by
      simp [e, E]
    obtain ⟨y, hy, _⟩ := hnet.2 e he
    exact ⟨y, hy⟩
  have hcard : N.card ≤ 9 ^ n := by
    have hcard' := card_le_nine_pow_finrank_of_unit_quarterSeparated N hnet.1
      (by
        intro c hc d hd hcd
        have hcP : c ∈ P := by simpa [N] using hc
        have hdP : d ∈ P := by simpa [N] using hd
        have h := hPsep hcP hdP hcd
        change (((1 / 4 : ℝ≥0) : ℝ≥0∞) < edist c d) at h
        rw [edist_dist] at h
        have hreal : (1 / 4 : ℝ) < dist c d := by
          simpa using ENNReal.coe_lt_ofReal.mp h
        simpa [dist_eq_norm] using hreal)
    simpa [E] using hcard'
  refine ⟨N, hnet, hNnonempty, ?_⟩
  simpa using hcard

end NumStability.HDP.Metric
