import ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein

/-!
# Bennett's inequality: exact bounded-variable MGF foundation

Reusable scalar lemmas for the Bennett bound in Vershynin, *High-Dimensional
Probability*, Theorem 2.9.2.  This module first proves the exact exponential
remainder comparison and then integrates it for a centered bounded random
variable.  The finite-sum tensorization and Chernoff optimization are kept as
separate downstream increments.

No numbered-source wrapper is imported.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Scalar.IndependentSums.Bennett

/-- The exponential remainder after its constant and linear terms. -/
private lemma exp_sub_one_sub_eq_tsum (x : ℝ) :
    Real.exp x - 1 - x =
      ∑' n : ℕ, x ^ (n + 2) / ((n + 2).factorial : ℝ) := by
  let f : ℕ → ℝ := fun n => x ^ n / (n.factorial : ℝ)
  have hsum : Summable f := by
    dsimp [f]
    exact NormedSpace.expSeries_div_summable x
  have hexp : (∑' n : ℕ, f n) = Real.exp x := by
    dsimp [f]
    rw [Real.exp_eq_exp_ℝ]
    exact (NormedSpace.expSeries_div_hasSum_exp x).tsum_eq
  have hsplit := hsum.sum_add_tsum_nat_add 2
  have hsplit' : f 0 + f 1 + ∑' n : ℕ, f (n + 2) = Real.exp x := by
    simpa [Finset.sum_range_succ, f, Nat.factorial] using hsplit.trans hexp
  have h0 : f 0 = 1 := by simp [f]
  have h1 : f 1 = x := by simp [f, Nat.factorial]
  rw [h0, h1] at hsplit'
  dsimp [f] at hsplit' ⊢
  linarith

/-- The centered exponential remainder, divided by the square of its
argument, is nondecreasing on the positive half-line.  The division-free
statement below is convenient at zero and follows termwise from the
exponential series. -/
lemma sq_mul_exp_sub_one_sub_le
    {x y : ℝ} (hx : 0 ≤ x) (hxy : x ≤ y) :
    y ^ 2 * (Real.exp x - 1 - x) ≤
      x ^ 2 * (Real.exp y - 1 - y) := by
  have hy : 0 ≤ y := hx.trans hxy
  have hsumX : Summable
      (fun n : ℕ => y ^ 2 * (x ^ (n + 2) / ((n + 2).factorial : ℝ))) := by
    exact (NormedSpace.expSeries_div_summable x).comp_injective
      (fun a b hab => Nat.add_right_cancel hab) |>.mul_left _
  have hsumY : Summable
      (fun n : ℕ => x ^ 2 * (y ^ (n + 2) / ((n + 2).factorial : ℝ))) := by
    exact (NormedSpace.expSeries_div_summable y).comp_injective
      (fun a b hab => Nat.add_right_cancel hab) |>.mul_left _
  have hterm : ∀ n : ℕ,
      y ^ 2 * (x ^ (n + 2) / ((n + 2).factorial : ℝ)) ≤
        x ^ 2 * (y ^ (n + 2) / ((n + 2).factorial : ℝ)) := by
    intro n
    have hpow : x ^ n ≤ y ^ n := pow_le_pow_left₀ hx hxy n
    have hcore : y ^ 2 * x ^ (n + 2) ≤ x ^ 2 * y ^ (n + 2) := by
      rw [pow_add, pow_add]
      calc
        y ^ 2 * (x ^ n * x ^ 2) = (x ^ 2 * y ^ 2) * x ^ n := by ring
        _ ≤ (x ^ 2 * y ^ 2) * y ^ n :=
          mul_le_mul_of_nonneg_left hpow (mul_nonneg (sq_nonneg x) (sq_nonneg y))
        _ = x ^ 2 * (y ^ n * y ^ 2) := by ring
    calc
      y ^ 2 * (x ^ (n + 2) / ((n + 2).factorial : ℝ)) =
          (y ^ 2 * x ^ (n + 2)) / ((n + 2).factorial : ℝ) := by ring
      _ ≤ (x ^ 2 * y ^ (n + 2)) / ((n + 2).factorial : ℝ) :=
        div_le_div_of_nonneg_right hcore (by positivity)
      _ = x ^ 2 * (y ^ (n + 2) / ((n + 2).factorial : ℝ)) := by ring
  rw [exp_sub_one_sub_eq_tsum x, exp_sub_one_sub_eq_tsum y,
    ← tsum_mul_left, ← tsum_mul_left]
  exact hsumX.tsum_le_tsum hterm hsumY

/-- Exact pointwise Bennett majorant.  For a value bounded in absolute value
by `K` and a nonnegative Laplace parameter `lam`, the exponential remainder is
controlled by its value at the endpoint `lam * K`, with the sharp quadratic
variance weight `x² / K²`. -/
lemma exp_le_one_add_bennett
    {x K lam : ℝ} (hK : 0 < K) (hlam : 0 ≤ lam) (hx : |x| ≤ K) :
    Real.exp (lam * x) ≤
      1 + lam * x +
        (x ^ 2 / K ^ 2) * (Real.exp (lam * K) - 1 - lam * K) := by
  rcases eq_or_lt_of_le hlam with rfl | hlampos
  · simp
  have hlamK : 0 < lam * K := mul_pos hlampos hK
  have habs : |lam * x| ≤ lam * K := by
    rw [abs_mul, abs_of_pos hlampos]
    exact mul_le_mul_of_nonneg_left hx hlampos.le
  have hrem := sq_mul_exp_sub_one_sub_le (abs_nonneg (lam * x)) habs
  have hscale :
      (lam * K) ^ 2 * (Real.exp |lam * x| - 1 - |lam * x|) ≤
        (lam * K) ^ 2 *
          ((x ^ 2 / K ^ 2) * (Real.exp (lam * K) - 1 - lam * K)) := by
    calc
      (lam * K) ^ 2 * (Real.exp |lam * x| - 1 - |lam * x|)
          ≤ |lam * x| ^ 2 * (Real.exp (lam * K) - 1 - lam * K) := hrem
      _ = (lam * K) ^ 2 *
          ((x ^ 2 / K ^ 2) * (Real.exp (lam * K) - 1 - lam * K)) := by
        rw [sq_abs]
        field_simp [hK.ne', hlampos.ne']
  have hcoef : 0 < (lam * K) ^ 2 := sq_pos_of_pos hlamK
  have hrem' : Real.exp |lam * x| - 1 - |lam * x| ≤
      (x ^ 2 / K ^ 2) * (Real.exp (lam * K) - 1 - lam * K) :=
    le_of_mul_le_mul_left hscale hcoef
  exact (NumStability.HDP.Scalar.SubExponential.exp_le_centered_remainder
    (lam * x)).trans (by linarith)

/-- The exact per-variable MGF estimate used in Bennett's inequality.

For a centered real random variable with `|X| ≤ K` almost surely and
`lam ≥ 0`,

`E exp(lam X) ≤ exp ((E X² / K²) * (exp(lam K) - 1 - lam K))`.
-/
theorem boundedCenteredMGFBound
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K lam : ℝ} (hK : 0 < K) (hX : Measurable X)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ K) (hlam : 0 ≤ lam) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp (((∫ ω, X ω ^ 2 ∂μ) / K ^ 2) *
          (Real.exp (lam * K) - 1 - lam * K)) := by
  let c : ℝ := (Real.exp (lam * K) - 1 - lam * K) / K ^ 2
  have hc : 0 ≤ c := by
    dsimp [c]
    apply div_nonneg
    · linarith [Real.add_one_le_exp (lam * K)]
    · exact sq_nonneg K
  have hExpInt : Integrable (fun ω => Real.exp (lam * X ω)) μ := by
    have hmeas : AEStronglyMeasurable (fun ω => Real.exp (lam * X ω)) μ :=
      ((hX.const_mul lam).exp).aestronglyMeasurable
    refine Integrable.mono' (g := fun _ => Real.exp (lam * K))
      (integrable_const _) hmeas ?_
    filter_upwards [hBound] with ω hω
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    exact Real.exp_le_exp.2 <| by
      calc
        lam * X ω ≤ lam * |X ω| :=
          mul_le_mul_of_nonneg_left (le_abs_self _) hlam
        _ ≤ lam * K := mul_le_mul_of_nonneg_left hω hlam
  have hSqInt : Integrable (fun ω => X ω ^ 2) μ := by
    have hmeas : AEStronglyMeasurable (fun ω => X ω ^ 2) μ :=
      (hX.pow_const 2).aestronglyMeasurable
    refine Integrable.mono' (g := fun _ => K ^ 2) (integrable_const _) hmeas ?_
    filter_upwards [hBound] with ω hω
    rw [Real.norm_eq_abs, abs_of_nonneg (sq_nonneg _), ← sq_abs]
    nlinarith [abs_nonneg (X ω), hω]
  refine ⟨hExpInt, ?_⟩
  have hpt : ∀ᵐ ω ∂μ,
      Real.exp (lam * X ω) ≤ 1 + lam * X ω + c * X ω ^ 2 := by
    filter_upwards [hBound] with ω hω
    have h := exp_le_one_add_bennett hK hlam hω
    dsimp [c]
    convert h using 1
    field_simp [hK.ne']
  have hRHSInt : Integrable (fun ω => 1 + lam * X ω + c * X ω ^ 2) μ :=
    ((integrable_const (1 : ℝ)).add (hCenter.1.const_mul lam)).add
      (hSqInt.const_mul c)
  have hmono := integral_mono_ae hExpInt hRHSInt hpt
  have hrhs : (∫ ω, (1 + lam * X ω + c * X ω ^ 2) ∂μ) =
      1 + c * ∫ ω, X ω ^ 2 ∂μ := by
    have h1 : Integrable (fun ω => (1 : ℝ) + lam * X ω) μ :=
      (integrable_const (1 : ℝ)).add (hCenter.1.const_mul lam)
    have h2 : Integrable (fun ω => c * X ω ^ 2) μ := hSqInt.const_mul c
    rw [integral_add h1 h2,
      integral_add (integrable_const (1 : ℝ)) (hCenter.1.const_mul lam),
      integral_const_mul, integral_const_mul, hCenter.2, integral_const]
    simp
  rw [hrhs] at hmono
  have hvar : 0 ≤ ∫ ω, X ω ^ 2 ∂μ := integral_nonneg fun ω => sq_nonneg _
  have hfin : 0 ≤ c * ∫ ω, X ω ^ 2 ∂μ := mul_nonneg hc hvar
  refine hmono.trans ?_
  calc
    1 + c * ∫ ω, X ω ^ 2 ∂μ ≤
        Real.exp (c * ∫ ω, X ω ^ 2 ∂μ) := by
      simpa [add_comm] using Real.add_one_le_exp (c * ∫ ω, X ω ^ 2 ∂μ)
    _ = Real.exp (((∫ ω, X ω ^ 2 ∂μ) / K ^ 2) *
        (Real.exp (lam * K) - 1 - lam * K)) := by
      congr 1
      dsimp [c]
      field_simp [hK.ne']

/-- Bennett's scalar transform `h(u) = (1+u) log(1+u) - u`. -/
def bennettTransform (u : ℝ) : ℝ :=
  (1 + u) * Real.log (1 + u) - u

/-- The exact bounded-variable Bennett MGF estimate tensorizes over a finite
independent family, with the second moments adding in the exponent. -/
theorem independentSumMGFBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K lam : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K)
    (hIndep : iIndepFun X μ) (hlam : 0 ≤ lam) :
    Integrable (fun ω => Real.exp (lam * ∑ i, X i ω)) μ ∧
      (∫ ω, Real.exp (lam * ∑ i, X i ω) ∂μ) ≤
        Real.exp (((∑ i, ∫ ω, X i ω ^ 2 ∂μ) / K ^ 2) *
          (Real.exp (lam * K) - 1 - lam * K)) := by
  have hcoord : ∀ i,
      Integrable (fun ω => Real.exp (lam * X i ω)) μ ∧
        (∫ ω, Real.exp (lam * X i ω) ∂μ) ≤
          Real.exp (((∫ ω, X i ω ^ 2 ∂μ) / K ^ 2) *
            (Real.exp (lam * K) - 1 - lam * K)) := fun i =>
    boundedCenteredMGFBound hK (hX i) (hCenter i) (hBound i) hlam
  refine ⟨?_, ?_⟩
  · have h := hIndep.integrable_exp_mul_sum (t := lam) hX
      (s := Finset.univ) (fun i _ => (hcoord i).1)
    simpa [Finset.sum_apply] using h
  · have hFactorization :=
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
        (μ := μ) (X := X) lam (fun _ => (1 : ℝ)) hIndep
        (fun i => by simpa using (hcoord i).1)
    have hProd :
        (∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ) ≤
          ∏ i, Real.exp (((∫ ω, X i ω ^ 2 ∂μ) / K ^ 2) *
            (Real.exp (lam * K) - 1 - lam * K)) := by
      refine Finset.prod_le_prod ?_ ?_
      · intro i _
        exact integral_nonneg (fun ω => Real.exp_nonneg _)
      · intro i _
        simpa using (hcoord i).2
    calc
      (∫ ω, Real.exp (lam * ∑ i, X i ω) ∂μ) =
          ∏ i, ∫ ω, Real.exp (lam * (1 * X i ω)) ∂μ := by
            simpa using hFactorization
      _ ≤ ∏ i, Real.exp (((∫ ω, X i ω ^ 2 ∂μ) / K ^ 2) *
            (Real.exp (lam * K) - 1 - lam * K)) := hProd
      _ = Real.exp (((∑ i, ∫ ω, X i ω ^ 2 ∂μ) / K ^ 2) *
            (Real.exp (lam * K) - 1 - lam * K)) := by
        rw [← Real.exp_sum]
        congr 1
        rw [← Finset.sum_mul, Finset.sum_div]

/-- If the sum of the centered second moments vanishes, then every summand
vanishes almost everywhere and every strictly positive upper-tail event is
null.  This is the nondegenerate-boundary companion used to state Bennett's
inequality without assigning an artificial value to its displayed (0/0). -/
theorem independentSumTail_eq_zero_of_variance_eq_zero
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K)
    (hVariance : (∑ i, ∫ ω, X i ω ^ 2 ∂μ) = 0)
    {t : ℝ} (ht : 0 < t) :
    μ.real {ω | ∑ i, X i ω ≥ t} = 0 := by
  have hEachZero : ∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 0 := by
    have hall := (Finset.sum_eq_zero_iff_of_nonneg
      (fun i _ => integral_nonneg fun ω => sq_nonneg (X i ω))).1 hVariance
    intro i
    exact hall i (Finset.mem_univ i)
  have hSqInt : ∀ i, Integrable (fun ω => X i ω ^ 2) μ := by
    intro i
    have hmeas : AEStronglyMeasurable (fun ω => X i ω ^ 2) μ :=
      ((hX i).pow_const 2).aestronglyMeasurable
    refine Integrable.mono' (g := fun _ => K ^ 2) (integrable_const _) hmeas ?_
    filter_upwards [hBound i] with ω hω
    rw [Real.norm_eq_abs, abs_of_nonneg (sq_nonneg _), ← sq_abs]
    nlinarith [abs_nonneg (X i ω), hω]
  have hXZero : ∀ i, X i =ᵐ[μ] 0 := by
    intro i
    have hSqZero : (fun ω => X i ω ^ 2) =ᵐ[μ] 0 :=
      (integral_eq_zero_iff_of_nonneg
        (fun ω => sq_nonneg (X i ω)) (hSqInt i)).1 (hEachZero i)
    filter_upwards [hSqZero] with ω hω
    simp only [Pi.zero_apply] at hω ⊢
    nlinarith [sq_nonneg (X i ω)]
  have hAllZero : ∀ᵐ ω ∂μ, ∀ i ∈ (Finset.univ : Finset ι), X i ω = 0 := by
    rw [Filter.eventually_all_finset]
    intro i _
    exact hXZero i
  have hSumZero : ∀ᵐ ω ∂μ, (∑ i, X i ω) = 0 := by
    filter_upwards [hAllZero] with ω hω
    simp [hω]
  have hEventNull : μ {ω | ∑ i, X i ω ≥ t} = 0 := by
    have hEventAE : {ω | ∑ i, X i ω ≥ t} =ᵐ[μ] (∅ : Set Ω) := by
      filter_upwards [hSumZero] with ω hω
      apply propext
      change (t ≤ ∑ i, X i ω) ↔ False
      rw [hω]
      exact iff_false_intro (not_le_of_gt ht)
    simpa using measure_congr hEventAE
  rw [Measure.real_def, hEventNull, ENNReal.toReal_zero]

/-- One-sided Bennett inequality for a finite independent family of centered
variables bounded in absolute value by a common positive radius. -/
theorem independentSumTail
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω| ≤ K)
    (hIndep : iIndepFun X μ)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | ∑ i, X i ω ≥ t} ≤
      Real.exp (-((∑ i, ∫ ω, X i ω ^ 2 ∂μ) / K ^ 2) *
        bennettTransform (K * t / (∑ i, ∫ ω, X i ω ^ 2 ∂μ))) := by
  set sig : ℝ := ∑ i, ∫ ω, X i ω ^ 2 ∂μ with hsigdef
  have hsig_nonneg : 0 ≤ sig := by
    rw [hsigdef]
    exact Finset.sum_nonneg fun i _ => integral_nonneg fun ω => sq_nonneg (X i ω)
  rcases eq_or_lt_of_le ht with rfl | htpos
  · have hprob : μ.real {ω | ∑ i, X i ω ≥ (0 : ℝ)} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    simpa [bennettTransform] using hprob
  by_cases hsigpos : 0 < sig
  swap
  · have hsigzero : sig = 0 := le_antisymm (le_of_not_gt hsigpos) hsig_nonneg
    rw [independentSumTail_eq_zero_of_variance_eq_zero hK hX hBound
      (by simpa [hsigdef] using hsigzero) htpos]
    positivity
  set u : ℝ := K * t / sig with hudef
  have hu : 0 < u := by rw [hudef]; positivity
  set lam : ℝ := Real.log (1 + u) / K with hlamdef
  have hlog : 0 < Real.log (1 + u) := Real.log_pos (by linarith)
  have hlam : 0 < lam := by rw [hlamdef]; positivity
  have hlamK : lam * K = Real.log (1 + u) := by
    rw [hlamdef]
    field_simp [hK.ne']
  have hexpK : Real.exp (lam * K) = 1 + u := by
    rw [hlamK, Real.exp_log (by linarith : 0 < 1 + u)]
  obtain ⟨hInt, hMGF⟩ := independentSumMGFBound hK hX hCenter hBound hIndep hlam.le
  let S : Ω → ℝ := fun ω => ∑ i, X i ω
  let Y : Ω → ℝ := fun ω => Real.exp (lam * S ω)
  have hS : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ (fun i _ => hX i)
  have hY : Measurable Y := by
    simpa [Y] using (hS.const_mul lam).exp
  have hmarkov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite hY
      (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _)))
      (by simpa [Y, S] using hInt) (Real.exp_pos (lam * t))
  have hsubset : {ω | S ω ≥ t} ⊆ Y ⁻¹' Set.Ici (Real.exp (lam * t)) := by
    intro ω hω
    change Real.exp (lam * t) ≤ Real.exp (lam * S ω)
    exact Real.exp_le_exp.2 (mul_le_mul_of_nonneg_left hω hlam.le)
  have hmono {A B : Set Ω} (hAB : A ⊆ B) : μ.real A ≤ μ.real B := by
    rw [Measure.real_def, Measure.real_def]
    exact ENNReal.toReal_mono (measure_ne_top μ B) (measure_mono hAB)
  have hexponent :
      (sig / K ^ 2) * (Real.exp (lam * K) - 1 - lam * K) - lam * t =
        -(sig / K ^ 2) * bennettTransform u := by
    have hsig_u : sig * u = K * t := by
      rw [hudef]
      field_simp [hsigpos.ne']
    rw [hexpK, hlamK]
    dsimp [bennettTransform]
    rw [hlamdef]
    field_simp [hK.ne']
    nlinarith
  calc
    μ.real {ω | ∑ i, X i ω ≥ t} = μ.real {ω | S ω ≥ t} := by rfl
    _ ≤ μ.real (Y ⁻¹' Set.Ici (Real.exp (lam * t))) := hmono hsubset
    _ ≤ (∫ ω, Y ω ∂μ) / Real.exp (lam * t) := by
      simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hmarkov
    _ ≤ Real.exp ((sig / K ^ 2) *
          (Real.exp (lam * K) - 1 - lam * K)) / Real.exp (lam * t) := by
      refine div_le_div_of_nonneg_right ?_ (Real.exp_pos _).le
      simpa [Y, S, hsigdef] using hMGF
    _ = Real.exp ((sig / K ^ 2) *
          (Real.exp (lam * K) - 1 - lam * K) - lam * t) := by
      rw [div_eq_mul_inv, ← Real.exp_neg, ← Real.exp_add]
      ring_nf
    _ = Real.exp (-(sig / K ^ 2) * bennettTransform u) := by rw [hexponent]
    _ = Real.exp (-(sig / K ^ 2) *
        bennettTransform (K * t / sig)) := by rw [hudef]
    _ = Real.exp (-((∑ i, ∫ ω, X i ω ^ 2 ∂μ) / K ^ 2) *
        bennettTransform (K * t / (∑ i, ∫ ω, X i ω ^ 2 ∂μ))) := by
      rw [hsigdef]

/-- The centered sum has a null positive upper tail when its exact variance
sum is zero.  This supplies the exceptional case that the printed Bennett
formula leaves implicit because it contains division by that variance. -/
theorem bennettTail_eq_zero_of_variance_eq_zero
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω - ∫ y, X i y ∂μ| ≤ K)
    (hVariance :
      (∑ i, ∫ ω, (X i ω - ∫ y, X i y ∂μ) ^ 2 ∂μ) = 0)
    {t : ℝ} (ht : 0 < t) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} = 0 := by
  let Z : ι → Ω → ℝ := fun i ω => X i ω - ∫ y, X i y ∂μ
  have hZ : ∀ i, Measurable (Z i) := fun i => (hX i).sub measurable_const
  have hZBound : ∀ i, ∀ᵐ ω ∂μ, |Z i ω| ≤ K := by
    intro i
    simpa [Z] using hBound i
  have hZVariance : (∑ i, ∫ ω, Z i ω ^ 2 ∂μ) = 0 := by
    simpa [Z] using hVariance
  simpa [Z] using
    independentSumTail_eq_zero_of_variance_eq_zero hK hZ hZBound hZVariance ht

/-- Bennett's inequality in the source-facing form: an arbitrary independent
family is centered by subtracting each expectation, and the variance proxy is
the exact sum of the centered second moments. -/
theorem bennettTail
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hX : ∀ i, Measurable (X i))
    (hInt : ∀ i, Integrable (X i) μ)
    (hBound : ∀ i, ∀ᵐ ω ∂μ, |X i ω - ∫ y, X i y ∂μ| ≤ K)
    (hIndep : iIndepFun X μ)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
      Real.exp (-((∑ i, ∫ ω, (X i ω - ∫ y, X i y ∂μ) ^ 2 ∂μ) / K ^ 2) *
        bennettTransform
          (K * t / (∑ i, ∫ ω, (X i ω - ∫ y, X i y ∂μ) ^ 2 ∂μ))) := by
  let Z : ι → Ω → ℝ := fun i ω => X i ω - ∫ y, X i y ∂μ
  have hZ : ∀ i, Measurable (Z i) := fun i => (hX i).sub measurable_const
  have hZCenter : ∀ i, Integrable (Z i) μ ∧ (∫ ω, Z i ω ∂μ) = 0 := by
    intro i
    have hZi : Integrable (Z i) μ := (hInt i).sub (integrable_const _)
    refine ⟨hZi, ?_⟩
    dsimp [Z]
    rw [integral_sub (hInt i) (integrable_const _), integral_const]
    simp
  have hZBound : ∀ i, ∀ᵐ ω ∂μ, |Z i ω| ≤ K := by
    intro i
    simpa [Z] using hBound i
  have hZIndep : iIndepFun Z μ := by
    have hg : ∀ i, Measurable (fun x : ℝ => x - ∫ y, X i y ∂μ) := by
      intro i
      fun_prop
    have h := hIndep.comp (fun i x => x - ∫ y, X i y ∂μ) hg
    simpa [Z, Function.comp_def] using h
  simpa [Z] using independentSumTail hK hZ hZCenter hZBound hZIndep ht

end NumStability.HDP.Scalar.IndependentSums.Bennett
