import ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein.Basic

/-!
# Vershynin Chapter 2 Bernstein source aliases

Source-correspondence declarations extracted from the reusable scalar producer.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Bernstein

/-! ## Stable Chapter 2 source-facing aliases for Section 2.8

Theorems 2.8.1--2.8.3 are printed with an unquantified absolute constant `c`,
so the faithful Lean shape puts `∃ c > 0` *outside* the family of random
variables: a declaration that pinned `c = 1/4` would be an explicit instance of
the printed claim, not the printed claim itself.  The explicit-constant results
are the reusable `bernsteinTail`, `bernsteinWeightedTail` and
`bernsteinAverageTail`; the aliases below are the printed existential forms and
are what the corresponding gate rows close on.

Theorem 2.8.4 carries no implicit constant, so its alias is a direct forwarding
declaration. -/

/-- **Theorem 2.8.1** (printed page 36), in its printed form: the existential
absolute constant `c` stands outside the family, and the linear branch of the
minimum carries the *maximum* `max_i K i` exactly as printed, not merely some
uniform upper bound.  The positive-energy hypothesis forces `ι` to be nonempty,
so the maximum exists. -/
theorem hdp_02_hthm_h2_d8_d1 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} {K : ι → ℝ}
        (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, SubExponentialLinearMGF μ (X i) (K i)) →
        ProbabilityTheory.iIndepFun X μ →
        0 < ∑ i, K i ^ 2 →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, X i ω| ≥ t} ≤
            2 * Real.exp (-(c * min (t ^ 2 / ∑ i, K i ^ 2)
              (t / Finset.univ.sup' hne K))) := by
  refine ⟨1 / 4, by norm_num, ?_⟩
  intro ι Ω _ _ μ _ X K hne hX hIndep hEnergy t ht
  set M : ℝ := Finset.univ.sup' hne K with hMdef
  have hmax : ∀ i, K i ≤ M := fun i =>
    Finset.le_sup' (f := K) (Finset.mem_univ i)
  have hM : 0 < M := lt_of_lt_of_le (hX hne.choose).2.1 (hmax hne.choose)
  refine (bernsteinTail hX hIndep hM hmax hEnergy ht).trans ?_
  have hE : 0 < ∑ i, K i ^ 2 := hEnergy
  refine mul_le_mul_of_nonneg_left (Real.exp_le_exp.2 ?_) (by norm_num)
  -- `min (a/4) (b/2) ≥ (1/4) * min a b`, so the pinned bound implies the
  -- printed one with `c = 1/4`.
  have hkey : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, K i ^ 2) (t / M)
      ≤ min (t ^ 2 / (4 * ∑ i, K i ^ 2)) (t / (2 * M)) := by
    have h1 : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, K i ^ 2) (t / M)
        ≤ t ^ 2 / (4 * ∑ i, K i ^ 2) := by
      have := min_le_left (t ^ 2 / ∑ i, K i ^ 2) (t / M)
      have heq : t ^ 2 / (4 * ∑ i, K i ^ 2)
          = (1 / 4 : ℝ) * (t ^ 2 / ∑ i, K i ^ 2) := by
        field_simp
      rw [heq]
      exact mul_le_mul_of_nonneg_left this (by norm_num)
    have h2 : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, K i ^ 2) (t / M)
        ≤ t / (2 * M) := by
      have hmin := min_le_right (t ^ 2 / ∑ i, K i ^ 2) (t / M)
      have hnn : 0 ≤ t / M := by positivity
      have heq : t / (2 * M) = (1 / 2 : ℝ) * (t / M) := by field_simp
      rw [heq]
      have : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, K i ^ 2) (t / M)
          ≤ (1 / 4 : ℝ) * (t / M) :=
        mul_le_mul_of_nonneg_left hmin (by norm_num)
      nlinarith [this, hnn]
    exact le_min h1 h2
  linarith [hkey]

/-- **Theorem 2.8.2** (printed page 37), in its printed existential-constant
form.  `M` plays the role of the printed `K ‖a‖_∞`. -/
theorem hdp_02_hthm_h2_d8_d2 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} {K : ι → ℝ} {a : ι → ℝ}
        (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, SubExponentialLinearMGF μ (X i) (K i)) →
        ProbabilityTheory.iIndepFun X μ →
        0 < ∑ i, (a i * K i) ^ 2 →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp (-(c * min (t ^ 2 / ∑ i, (a i * K i) ^ 2)
              (t / Finset.univ.sup' hne (fun i => |a i| * K i)))) := by
  refine ⟨1 / 4, by norm_num, ?_⟩
  intro ι Ω _ _ μ _ X K a hne hX hIndep hEnergy t ht
  set M : ℝ := Finset.univ.sup' hne (fun i => |a i| * K i) with hMdef
  have hwindow : ∀ i, |a i| * K i ≤ M := fun i =>
    Finset.le_sup' (f := fun i => |a i| * K i) (Finset.mem_univ i)
  have hM : 0 < M := by
    by_contra hcon
    push_neg at hcon
    have hall : ∀ i, (a i * K i) ^ 2 = 0 := by
      intro i
      have h1 : |a i| * K i ≤ 0 := le_trans (hwindow i) hcon
      have h2 : 0 ≤ |a i| * K i :=
        mul_nonneg (abs_nonneg _) (hX i).2.1.le
      have h3 : |a i| * K i = 0 := le_antisymm h1 h2
      have h4 : |a i| = 0 := by
        rcases mul_eq_zero.mp h3 with h | h
        · exact h
        · exact absurd h (ne_of_gt (hX i).2.1)
      have h5 : a i = 0 := abs_eq_zero.mp h4
      rw [h5]; ring
    have : (∑ i, (a i * K i) ^ 2) = 0 := Finset.sum_eq_zero (fun i _ => hall i)
    rw [this] at hEnergy
    exact absurd hEnergy (lt_irrefl 0)
  refine (bernsteinWeightedTail hX hIndep hM hwindow hEnergy ht).trans ?_
  refine mul_le_mul_of_nonneg_left (Real.exp_le_exp.2 ?_) (by norm_num)
  have hkey : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
      ≤ min (t ^ 2 / (4 * ∑ i, (a i * K i) ^ 2)) (t / (2 * M)) := by
    have h1 : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
        ≤ t ^ 2 / (4 * ∑ i, (a i * K i) ^ 2) := by
      have hmin := min_le_left (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
      have heq : t ^ 2 / (4 * ∑ i, (a i * K i) ^ 2)
          = (1 / 4 : ℝ) * (t ^ 2 / ∑ i, (a i * K i) ^ 2) := by field_simp
      rw [heq]
      exact mul_le_mul_of_nonneg_left hmin (by norm_num)
    have h2 : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
        ≤ t / (2 * M) := by
      have hmin := min_le_right (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
      have hnn : 0 ≤ t / M := by positivity
      have heq : t / (2 * M) = (1 / 2 : ℝ) * (t / M) := by field_simp
      rw [heq]
      have : (1 / 4 : ℝ) * min (t ^ 2 / ∑ i, (a i * K i) ^ 2) (t / M)
          ≤ (1 / 4 : ℝ) * (t / M) :=
        mul_le_mul_of_nonneg_left hmin (by norm_num)
      nlinarith [this, hnn]
    exact le_min h1 h2
  linarith [hkey]

/-- **Corollary 2.8.3** (printed page 37): Bernstein's inequality for averages,
with the `1 / N` weights left visible. -/
theorem hdp_02_hcor_h2_d8_d3
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ}
    (hK : 0 < K)
    (hX : ∀ i, SubExponentialLinearMGF μ (X i) K)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hcard : 0 < Fintype.card ι)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤
      2 * Real.exp (-min
        (t ^ 2 / (4 * ∑ _i : ι, ((Fintype.card ι : ℝ)⁻¹ * K) ^ 2))
        (t / (2 * ((Fintype.card ι : ℝ)⁻¹ * K)))) :=
  bernsteinAverageTail hK hX hIndep hcard ht

/-- **Theorem 2.8.4** (printed page 38): the variance-sensitive Bernstein
inequality for bounded summands.  The printed constants are exact. -/
theorem hdp_02_hthm_h2_d8_d4
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-((t ^ 2 / 2) /
        ((∑ i, ∫ ω, X i ω ^ 2 ∂μ) + K * t / 3))) :=
  bernsteinBoundedTail hK hX hCenter hBound hIndep ht

/-- **Exercise 2.8.5** (printed page 38): the MGF bound for a centered bounded
variable, with the printed `g (λ) = (λ²/2) / (1 - |λ| K / 3)`. -/
theorem hdp_02_hex_h2_d8_d5
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K) (hX : Measurable X)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ K)
    {lam : ℝ} (hlam : |lam| * K < 3) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp (((lam ^ 2 / 2) / (1 - |lam| * K / 3)) * (∫ ω, X ω ^ 2 ∂μ)) :=
  boundedCenteredMGFBound hK hX hCenter hBound hlam

/-- **Exercise 2.8.6** (printed page 38): "Deduce Theorem 2.8.4 from the bound
in Exercise 2.8.5."  The bound of Exercise 2.8.5 is the hypothesis `hEx`, so
this declaration records the *deduction* the exercise asks for rather than
restating Theorem 2.8.4; the printed proof needs the bound for both `X i` and
`-X i`, which is why `hEx` quantifies over admissible variables. -/
theorem hdp_02_hex_h2_d8_d6
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hEx : BoundedCenteredMGFHypothesis μ K)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-((t ^ 2 / 2) /
        ((∑ i, ∫ ω, X i ω ^ 2 ∂μ) + K * t / 3))) :=
  bernsteinBoundedTailOfMGFBound hK hX hCenter hBound hIndep hEx ht

/-- **Proposition 2.7.1, property (e)** (printed page 32), exposed as the
window MGF bound that Section 2.8 consumes, together with the printed
`b ⇒ e` implication. -/
theorem hdp_02_hprop_h2_d7_d1_he
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hLp : NumStability.HDP.Scalar.SubExponential.LpMomentGrowth μ X K) :
    SubExponentialLinearMGF μ X (4 * Real.exp 1 * K) :=
  momentToLinearMGF hX hK hCenter hLp

/-! ### The printed `ψ₁` renderings of Section 2.8

The three aliases above state Theorems 2.8.1, 2.8.2 and Corollary 2.8.3 in the
window/MGF scale the proof works in, which quantifies over per-index parameters
rather than naming the printed objects.  The three aliases below are the printed
statements themselves, over the sub-exponential norm `‖·‖_{ψ₁}` of Definition
2.7.5: the exact per-index gauges and their exact maximum, with the printed
denominators.  Both families are kept, separately named, because they are
different propositions: the window forms are strictly sharper (their
denominators are pointwise no larger), while these are what the book prints. -/

/-- **Theorem 2.8.1** (printed page 36) in the printed sub-exponential norm.
The absolute constant is quantified before the finite family and its ambient
probability space. -/
theorem hdp_02_hthm_h2_d8_d1_hpsi1 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (X i) < ∞) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, X i ω| ≥ t} ≤
            2 * Real.exp (-(c *
              min (t ^ 2 / ∑ i,
                    ((NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                      μ (X i)).toReal) ^ 2)
                  (t / Finset.univ.sup' hne
                    (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                      μ (X i)).toReal)))) :=
  bernsteinTailPsiOne

/-- **Theorem 2.8.2** (printed page 37) in the printed sub-exponential norm,
with the printed denominators `K² ‖a‖₂²` and `K ‖a‖_∞`.  The absolute
constant is quantified before the ambient probability space, and arbitrary
weights include the source's degenerate zero vector. -/
theorem hdp_02_hthm_h2_d8_d2_hpsi1 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} {a : ι → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (X i) < ∞) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp (-(c *
              min (t ^ 2 /
                    ((Finset.univ.sup' hne
                        (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                          μ (X i)).toReal)) ^ 2 * ∑ i, a i ^ 2))
                  (t / ((Finset.univ.sup' hne
                        (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                          μ (X i)).toReal)) *
                      Finset.univ.sup' hne (fun i => |a i|))))) :=
  bernsteinWeightedTailPsiOne

/-- **Corollary 2.8.3** (printed page 37) in the printed sub-exponential norm,
with the printed right-hand side `2 exp(-c min(t²/K², t/K) N)`.  The absolute
constant precedes the ambient probability space, and zero-gauge families remain
in the source's universal domain. -/
theorem hdp_02_hcor_h2_d8_d3_hpsi1 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (X i) < ∞) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, (Fintype.card ι : ℝ)⁻¹ * X i ω| ≥ t} ≤
            2 * Real.exp (-(c *
              min (t ^ 2 / (Finset.univ.sup' hne
                    (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                      μ (X i)).toReal)) ^ 2)
                  (t / Finset.univ.sup' hne
                    (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
                      μ (X i)).toReal)) *
                (Fintype.card ι : ℝ))) :=
  bernsteinAverageTailPsiOne

/-- Corrected source-facing companion to the unnumbered two-regime display
after Corollary 2.8.3.  Unlike the printed large-deviation branch, this statement
retains the necessary positive coefficient in front of `t * sqrt N`; it is not
an alias claiming that the literal source display is valid as written. -/
theorem hdp_02_body_h2_d8_hnormalized_hregimes_corrected
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty)
    (hmeas : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hSubExp : ∀ i,
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (X i) < ∞)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hK : 0 < Finset.univ.sup' hne
      (fun i => (NumStability.HDP.Scalar.SubExponential.PsiOneGauge
        μ (X i)).toReal)) :
    ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
      (∀ {t : ℝ}, 0 ≤ t → t ≤ C * Real.sqrt (Fintype.card ι : ℝ) →
        μ.real {ω | |∑ i,
            (Real.sqrt (Fintype.card ι : ℝ))⁻¹ * X i ω| ≥ t} ≤
          2 * Real.exp (-(c * t ^ 2))) ∧
      (∀ {t : ℝ}, 0 ≤ t → C * Real.sqrt (Fintype.card ι : ℝ) ≤ t →
        μ.real {ω | |∑ i,
            (Real.sqrt (Fintype.card ι : ℝ))⁻¹ * X i ω| ≥ t} ≤
          2 * Real.exp (-(c * t * Real.sqrt (Fintype.card ι : ℝ)))) :=
  bernsteinNormalizedTwoRegimePsiOne_corrected hne hmeas hCenter hSubExp hIndep hK

end NumStability.HDP.Contract
