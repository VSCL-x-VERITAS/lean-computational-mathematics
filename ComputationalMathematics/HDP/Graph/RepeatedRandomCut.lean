import ComputationalMathematics.HDP.Graph.RandomCut
import Mathlib.Analysis.SpecificLimits.Normed

/-!
# Repeated uniform random cuts

This module supplies the probability and geometric-series foundations for the
Las Vegas repetition argument in HDP Exercise 3.6.4.  It proves a quantitative
one-shot success bound from the half-optimum expectation and evaluates the
expected number of independent retries.
-/

namespace NumStability.HDP.Graph

open scoped BigOperators

variable {Ω : Type*} [Fintype Ω]

/-- Probability of a predicate under the uniform distribution on a finite
sample type. -/
noncomputable def uniformSuccessProbability (p : Ω → Prop) [DecidablePred p] : ℝ :=
  ((Finset.univ.filter p).card : ℝ) / Fintype.card Ω

theorem uniformSuccessProbability_eq_expect_indicator (p : Ω → Prop) [DecidablePred p] :
    uniformSuccessProbability p = 𝔼 ω : Ω, if p ω then (1 : ℝ) else 0 := by
  rw [Fintype.expect_eq_sum_div_card]
  simp [uniformSuccessProbability]

variable [Nonempty Ω]

theorem uniformSuccessProbability_le_one (p : Ω → Prop) [DecidablePred p] :
    uniformSuccessProbability p ≤ 1 := by
  rw [uniformSuccessProbability, div_le_one]
  · exact_mod_cast Finset.card_filter_le (s := Finset.univ) (p := p)
  · exact_mod_cast Fintype.card_pos

/-- If a uniformly sampled score is bounded by `M` and has expectation at
least `M / 2`, then it reaches `(1/2 - ε) M` with probability at least
`2 ε / (1 + 2 ε)`. -/
theorem uniformSuccessProbability_lower_bound_of_expectation
    (X : Ω → ℝ) (M ε : ℝ) (hM : 0 < M) (hε : 0 < ε)
    (hXupper : ∀ ω, X ω ≤ M)
    (hmean : M / 2 ≤ 𝔼 ω : Ω, X ω) :
    2 * ε / (1 + 2 * ε) ≤
      uniformSuccessProbability (fun ω ↦ (1 / 2 - ε) * M ≤ X ω) := by
  classical
  let t : ℝ := (1 / 2 - ε) * M
  let S : Finset Ω := Finset.univ.filter fun ω ↦ t ≤ X ω
  let N : ℝ := Fintype.card Ω
  let s : ℝ := S.card
  have hN : 0 < N := by
    have hNnat : 0 < Fintype.card Ω := Fintype.card_pos
    dsimp [N]
    exact_mod_cast hNnat
  have hpoint (ω : Ω) : X ω ≤ if ω ∈ S then M else t := by
    by_cases hω : ω ∈ S
    · simpa [hω] using hXupper ω
    · simp only [S, Finset.mem_filter, Finset.mem_univ, true_and] at hω
      rw [if_neg]
      · exact le_of_not_ge hω
      · simpa [S] using hω
  have hsum : (∑ ω : Ω, X ω) ≤ S.card * M + (Fintype.card Ω - S.card) * t := by
    calc
      (∑ ω : Ω, X ω) ≤ ∑ ω : Ω, if ω ∈ S then M else t :=
        Finset.sum_le_sum fun ω _ ↦ hpoint ω
      _ = S.card * M + (Fintype.card Ω - S.card) * t := by
        rw [Finset.sum_ite]
        simp only [Finset.sum_const, nsmul_eq_mul]
        simp only [Finset.filter_mem_eq_inter, Finset.univ_inter]
        have hparts := Finset.card_filter_add_card_filter_not
          (s := Finset.univ) (p := fun ω : Ω ↦ ω ∈ S)
        have hcomp : (Finset.univ.filter fun ω : Ω ↦ ω ∉ S).card =
            Fintype.card Ω - S.card := by
          simp only [Finset.filter_mem_eq_inter, Finset.univ_inter,
            Finset.card_univ] at hparts
          omega
        rw [hcomp]
        have hScard : S.card ≤ Fintype.card Ω := by
          simpa [S] using Finset.card_le_card (Finset.filter_subset _ _)
        rw [Nat.cast_sub hScard]
  have hmean' : N * (M / 2) ≤ ∑ ω : Ω, X ω := by
    rw [← Fintype.card_mul_expect]
    exact mul_le_mul_of_nonneg_left hmean hN.le
  have hbound : N * (M / 2) ≤ s * M + (N - s) * t := by
    exact hmean'.trans (by simpa [N, s] using hsum)
  have hden : 0 < 1 + 2 * ε := by positivity
  have hNM : 0 < N * M := mul_pos hN hM
  dsimp [uniformSuccessProbability]
  change 2 * ε / (1 + 2 * ε) ≤ s / N
  dsimp [t] at hbound
  field_simp
  nlinarith

/-- Mean of the one-based geometric law with success probability `p`. -/
noncomputable def geometricExpectedAttempts (p : ℝ) : ℝ :=
  p * ∑' n : ℕ, (n + 1 : ℝ) * (1 - p) ^ n

theorem geometricExpectedAttempts_eq_inv {p : ℝ} (hp : 0 < p) (hp1 : p ≤ 1) :
    geometricExpectedAttempts p = p⁻¹ := by
  have hr : ‖(1 - p : ℝ)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.mpr hp1)]
    linarith
  have hseries := tsum_choose_mul_geometric_of_norm_lt_one (𝕜 := ℝ) 1 hr
  have hseries' : (∑' n : ℕ, (n + 1 : ℝ) * (1 - p) ^ n) = 1 / p ^ 2 := by
    convert hseries using 1 <;> norm_num
  rw [geometricExpectedAttempts, hseries']
  field_simp

theorem geometricExpectedAttempts_le_of_probability_lower_bound
    {p q : ℝ} (hq : 0 < q) (hpq : q ≤ p) (hp1 : p ≤ 1) :
    geometricExpectedAttempts p ≤ q⁻¹ := by
  rw [geometricExpectedAttempts_eq_inv (hq.trans_le hpq) hp1]
  exact inv_anti₀ hq hpq

/-- Total mass of the one-based geometric law with success probability `p`.
The summation index `n` counts failures before the successful attempt. -/
noncomputable def geometricTotalProbability (p : ℝ) : ℝ :=
  ∑' n : ℕ, p * (1 - p) ^ n

theorem geometricTotalProbability_eq_one {p : ℝ} (hp : 0 < p) (hp1 : p ≤ 1) :
    geometricTotalProbability p = 1 := by
  have hr : ‖(1 - p : ℝ)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.mpr hp1)]
    linarith
  rw [geometricTotalProbability, tsum_mul_left,
    tsum_geometric_of_norm_lt_one hr]
  field_simp [hp.ne']
  ring

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Success probability of one uniform Boolean cut at approximation threshold
`1/2 - ε`. -/
noncomputable def uniformBoolCutSuccessProbability (G : SimpleGraph V)
    [DecidableRel G.Adj] (ε : ℝ) : ℝ :=
  uniformSuccessProbability fun x : V → Bool ↦
    (1 / 2 - ε) * (maxCut G : ℝ) ≤
      signCutValue G (fun v ↦ boolSign (x v))

theorem uniformBoolCutSuccessProbability_lower_bound (G : SimpleGraph V)
    [DecidableRel G.Adj] {ε : ℝ} (hε : 0 < ε) (hmax : 0 < maxCut G) :
    2 * ε / (1 + 2 * ε) ≤ uniformBoolCutSuccessProbability G ε := by
  apply uniformSuccessProbability_lower_bound_of_expectation
    (X := fun x : V → Bool ↦ signCutValue G (fun v ↦ boolSign (x v)))
    (M := (maxCut G : ℝ)) (ε := ε)
  · exact_mod_cast hmax
  · exact hε
  · intro x
    exact signCutValue_le_maxCut G (fun v ↦ boolSign (x v))
  · exact half_maxCut_le_uniformBoolCutExpectation G

/-- Success probability for the observable stopping rule that accepts a cut
with at least `(1/2 - ε) |E|` crossing edges. -/
noncomputable def uniformBoolEdgeSuccessProbability (G : SimpleGraph V)
    [DecidableRel G.Adj] (ε : ℝ) : ℝ :=
  uniformSuccessProbability fun x : V → Bool ↦
    (1 / 2 - ε) * (G.edgeFinset.card : ℝ) ≤
      signCutValue G (fun v ↦ boolSign (x v))

theorem signCutValue_nonneg (G : SimpleGraph V) [DecidableRel G.Adj]
    (x : V → NumStability.HDP.Optimization.Sign) :
    0 ≤ signCutValue G x := by
  rw [signCutValue_eq_cutSize_positiveVertices]
  positivity

theorem maxCut_le_edgeFinset_card (G : SimpleGraph V) [DecidableRel G.Adj] :
    maxCut G ≤ G.edgeFinset.card := by
  classical
  unfold maxCut cutSize
  exact Finset.sup_le fun S _ ↦ Finset.card_filter_le _ _

/-- The observable edge-count stopping rule always returns a
`(1/2 - ε)`-approximate maximum cut.  When the factor is negative, the claim
follows from nonnegativity of every cut. -/
theorem edgeSuccess_implies_maxCut_approximation (G : SimpleGraph V)
    [DecidableRel G.Adj] {ε : ℝ} (x : V → Bool)
    (hx : (1 / 2 - ε) * (G.edgeFinset.card : ℝ) ≤
      signCutValue G (fun v ↦ boolSign (x v))) :
    (1 / 2 - ε) * (maxCut G : ℝ) ≤
      signCutValue G (fun v ↦ boolSign (x v)) := by
  by_cases hε : ε ≤ 1 / 2
  · exact (mul_le_mul_of_nonneg_left
      (by exact_mod_cast maxCut_le_edgeFinset_card G)
      (sub_nonneg.mpr hε)).trans hx
  · have hfactor : 1 / 2 - ε ≤ 0 := by linarith
    exact (mul_nonpos_of_nonpos_of_nonneg hfactor (by positivity)).trans
      (signCutValue_nonneg G _)

theorem uniformBoolEdgeSuccessProbability_lower_bound (G : SimpleGraph V)
    [DecidableRel G.Adj] {ε : ℝ} (hε : 0 < ε)
    (hedges : 0 < G.edgeFinset.card) :
    2 * ε / (1 + 2 * ε) ≤ uniformBoolEdgeSuccessProbability G ε := by
  apply uniformSuccessProbability_lower_bound_of_expectation
    (X := fun x : V → Bool ↦ signCutValue G (fun v ↦ boolSign (x v)))
    (M := (G.edgeFinset.card : ℝ)) (ε := ε)
  · exact_mod_cast hedges
  · exact hε
  · intro x
    exact (signCutValue_le_maxCut G _).trans (by
      exact_mod_cast maxCut_le_edgeFinset_card G)
  · rw [← uniformBoolCutExpectation_eq_half_edges G]
    exact le_rfl

theorem uniformBoolEdgeSuccessProbability_eq_one_of_no_edges (G : SimpleGraph V)
    [DecidableRel G.Adj] (ε : ℝ) (hedges : G.edgeFinset.card = 0) :
    uniformBoolEdgeSuccessProbability G ε = 1 := by
  classical
  rw [uniformBoolEdgeSuccessProbability, uniformSuccessProbability]
  have hall : Finset.univ.filter (fun x : V → Bool ↦
      (1 / 2 - ε) * (G.edgeFinset.card : ℝ) ≤
        signCutValue G (fun v ↦ boolSign (x v))) = Finset.univ := by
    apply Finset.filter_eq_self.mpr
    intro x _
    simpa [hedges] using signCutValue_nonneg G (fun v ↦ boolSign (x v))
  rw [hall, Finset.card_univ]
  apply div_self
  exact_mod_cast (Fintype.card_ne_zero : Fintype.card (V → Bool) ≠ 0)

theorem uniformBoolEdgeSuccessProbability_pos (G : SimpleGraph V)
    [DecidableRel G.Adj] {ε : ℝ} (hε : 0 < ε) :
    0 < uniformBoolEdgeSuccessProbability G ε := by
  by_cases hedges : G.edgeFinset.card = 0
  · rw [uniformBoolEdgeSuccessProbability_eq_one_of_no_edges G ε hedges]
    norm_num
  · have hcard : 0 < G.edgeFinset.card := Nat.pos_of_ne_zero hedges
    exact (by positivity : 0 < 2 * ε / (1 + 2 * ε)).trans_le
      (uniformBoolEdgeSuccessProbability_lower_bound G hε hcard)

theorem geometricExpectedAttempts_uniformBoolEdge_le (G : SimpleGraph V)
    [DecidableRel G.Adj] {ε : ℝ} (hε : 0 < ε) :
    geometricExpectedAttempts (uniformBoolEdgeSuccessProbability G ε) ≤
      (1 + 2 * ε) / (2 * ε) := by
  have hq : 0 < 2 * ε / (1 + 2 * ε) := by positivity
  have hpone : uniformBoolEdgeSuccessProbability G ε ≤ 1 :=
    uniformSuccessProbability_le_one _
  by_cases hedges : G.edgeFinset.card = 0
  · rw [uniformBoolEdgeSuccessProbability_eq_one_of_no_edges G ε hedges,
      geometricExpectedAttempts_eq_inv (by norm_num) (by norm_num)]
    rw [inv_one]
    rw [le_div_iff₀ (by positivity : 0 < 2 * ε)]
    linarith
  · have hlower := uniformBoolEdgeSuccessProbability_lower_bound G hε
      (Nat.pos_of_ne_zero hedges)
    calc
      geometricExpectedAttempts (uniformBoolEdgeSuccessProbability G ε) ≤
          (2 * ε / (1 + 2 * ε))⁻¹ :=
        geometricExpectedAttempts_le_of_probability_lower_bound hq hlower hpone
      _ = (1 + 2 * ε) / (2 * ε) := by field_simp

theorem geometricTotalProbability_uniformBoolEdge_eq_one (G : SimpleGraph V)
    [DecidableRel G.Adj] {ε : ℝ} (hε : 0 < ε) :
    geometricTotalProbability (uniformBoolEdgeSuccessProbability G ε) = 1 :=
  geometricTotalProbability_eq_one
    (uniformBoolEdgeSuccessProbability_pos G hε)
    (uniformSuccessProbability_le_one _)

/-- Joint probability mass of the first successful independent uniform cut.
The index `n` counts failed experiments before termination and `x` is the cut
returned by the successful experiment.  Thus the factor `(1 - p)^n` records
the preceding failures and division by the finite sample-space cardinality is
the probability of drawing the returned Boolean labeling. -/
noncomputable def repeatedUniformCutOutputPMF (G : SimpleGraph V)
    [DecidableRel G.Adj] (ε : ℝ) (n : ℕ) (x : V → Bool) : ℝ :=
  if (1 / 2 - ε) * (G.edgeFinset.card : ℝ) ≤
      signCutValue G (fun v ↦ boolSign (x v)) then
    (1 - uniformBoolEdgeSuccessProbability G ε) ^ n /
      Fintype.card (V → Bool)
  else 0

theorem repeatedUniformCutOutputPMF_nonneg (G : SimpleGraph V)
    [DecidableRel G.Adj] (ε : ℝ) (n : ℕ) (x : V → Bool) :
    0 ≤ repeatedUniformCutOutputPMF G ε n x := by
  classical
  unfold repeatedUniformCutOutputPMF
  split
  · have hp : uniformBoolEdgeSuccessProbability G ε ≤ 1 :=
      uniformSuccessProbability_le_one _
    have hcard : 0 < (Fintype.card (V → Bool) : ℝ) := by
      exact_mod_cast (Fintype.card_pos : 0 < Fintype.card (V → Bool))
    exact div_nonneg (pow_nonneg (sub_nonneg.mpr hp) _) hcard.le
  · exact le_rfl

theorem sum_repeatedUniformCutOutputPMF (G : SimpleGraph V)
    [DecidableRel G.Adj] (ε : ℝ) (n : ℕ) :
    ∑ x : V → Bool, repeatedUniformCutOutputPMF G ε n x =
      uniformBoolEdgeSuccessProbability G ε *
        (1 - uniformBoolEdgeSuccessProbability G ε) ^ n := by
  classical
  let p : (V → Bool) → Prop := fun x ↦
    (1 / 2 - ε) * (G.edgeFinset.card : ℝ) ≤
      signCutValue G (fun v ↦ boolSign (x v))
  let a : ℝ := (1 - uniformBoolEdgeSuccessProbability G ε) ^ n
  have hcard : (Fintype.card (V → Bool) : ℝ) ≠ 0 := by
    exact_mod_cast (Fintype.card_ne_zero : Fintype.card (V → Bool) ≠ 0)
  rw [uniformBoolEdgeSuccessProbability, uniformSuccessProbability]
  change ∑ x : V → Bool, (if p x then a / Fintype.card (V → Bool) else 0) =
    ((Finset.univ.filter p).card : ℝ) / Fintype.card (V → Bool) * a
  rw [← Finset.sum_filter]
  simp only [Finset.sum_const, nsmul_eq_mul]
  field_simp

theorem tsum_sum_repeatedUniformCutOutputPMF (G : SimpleGraph V)
    [DecidableRel G.Adj] (ε : ℝ) :
    ∑' n : ℕ, ∑ x : V → Bool, repeatedUniformCutOutputPMF G ε n x =
      geometricTotalProbability (uniformBoolEdgeSuccessProbability G ε) := by
  simp_rw [sum_repeatedUniformCutOutputPMF]
  rfl

theorem tsum_weighted_repeatedUniformCutOutputPMF (G : SimpleGraph V)
    [DecidableRel G.Adj] (ε : ℝ) :
    ∑' n : ℕ, ∑ x : V → Bool,
        (n + 1 : ℝ) * repeatedUniformCutOutputPMF G ε n x =
      geometricExpectedAttempts (uniformBoolEdgeSuccessProbability G ε) := by
  rw [geometricExpectedAttempts, ← tsum_mul_left]
  apply tsum_congr
  intro n
  rw [← Finset.mul_sum, sum_repeatedUniformCutOutputPMF]
  ring

/-- Every cut in the support of the repeated algorithm's joint law satisfies
the requested maximum-cut approximation.  This is the zero-error property of
the returned output, rather than merely a statement about one-shot success. -/
theorem repeatedUniformCutOutputPMF_ne_zero_implies_approximation
    (G : SimpleGraph V) [DecidableRel G.Adj] (ε : ℝ) (n : ℕ) (x : V → Bool)
    (hx : repeatedUniformCutOutputPMF G ε n x ≠ 0) :
    (1 / 2 - ε) * (maxCut G : ℝ) ≤
      signCutValue G (fun v ↦ boolSign (x v)) := by
  classical
  apply edgeSuccess_implies_maxCut_approximation G x
  by_contra h
  unfold repeatedUniformCutOutputPMF at hx
  split at hx
  · exact (h ‹(1 / 2 - ε) * (G.edgeFinset.card : ℝ) ≤
      signCutValue G (fun v ↦ boolSign (x v))›).elim
  · exact hx rfl

/-- Expected independent retry count for the uniform-cut success event. -/
theorem geometricExpectedAttempts_uniformBoolCut_le (G : SimpleGraph V)
    [DecidableRel G.Adj] {ε : ℝ} (hε : 0 < ε) (hmax : 0 < maxCut G) :
    geometricExpectedAttempts (uniformBoolCutSuccessProbability G ε) ≤
      (1 + 2 * ε) / (2 * ε) := by
  have hq : 0 < 2 * ε / (1 + 2 * ε) := by positivity
  have hlower := uniformBoolCutSuccessProbability_lower_bound G hε hmax
  have hpone : uniformBoolCutSuccessProbability G ε ≤ 1 :=
    uniformSuccessProbability_le_one _
  calc
    geometricExpectedAttempts (uniformBoolCutSuccessProbability G ε) ≤
        (2 * ε / (1 + 2 * ε))⁻¹ :=
      geometricExpectedAttempts_le_of_probability_lower_bound hq hlower hpone
    _ = (1 + 2 * ε) / (2 * ε) := by
      field_simp

end NumStability.HDP.Graph
