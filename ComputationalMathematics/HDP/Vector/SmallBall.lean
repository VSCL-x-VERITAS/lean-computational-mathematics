import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral

/-!
# Small-ball probabilities for random vectors

Reusable Laplace-transform and bounded-density estimates for the lower tail of
the Euclidean norm of a random vector with independent coordinates.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Vector.SmallBall

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- A finite independent-sum small-ball estimate whose event scale `δ` and
per-coordinate Laplace bound `q` may differ. -/
theorem smallBallProbabilityOfLaplace
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {Y : ι → Ω → ℝ} {δ q : ℝ} (hδ : 0 < δ)
    (hY : ∀ i, Measurable (Y i)) (hIndep : iIndepFun Y μ)
    (hLaplace : ∀ i,
      Integrable (fun ω => Real.exp (-(1 / δ) * Y i ω)) μ ∧
        (∫ ω, Real.exp (-(1 / δ) * Y i ω) ∂μ) ≤ q) :
    μ.real {ω | ∑ i, Y i ω ≤ δ * (Fintype.card ι : ℝ)} ≤
      (Real.exp 1 * q) ^ Fintype.card ι := by
  let a : ι → ℝ := fun _ => -(1 / δ)
  let Z : ι → Ω → ℝ := fun i ω => a i * Y i ω
  let S : Ω → ℝ := fun ω => ∑ i, Z i ω
  have ha_meas : ∀ i, Measurable (fun x : ℝ => a i * x) := by
    intro i
    fun_prop
  have hZ_meas : ∀ i, Measurable (Z i) := by
    intro i
    simpa [Z] using (hY i).const_mul (a i)
  have hZ_indep : iIndepFun Z μ := by
    simpa [Z, Function.comp_def] using hIndep.comp (fun i x => a i * x) ha_meas
  have hZ_exp : ∀ i, Integrable (fun ω => Real.exp (Z i ω)) μ := by
    intro i
    simpa [Z, a] using (hLaplace i).1
  have hS_meas : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ (fun i _ => hZ_meas i)
  have hS_exp : Integrable (fun ω => Real.exp (S ω)) μ := by
    simpa [S] using
      (hZ_indep.integrable_exp_mul_sum (t := (1 : ℝ)) hZ_meas
        (s := Finset.univ) (fun i _ => by simpa using hZ_exp i))
  have hmgf := mgfIndependentSum (μ := μ) (X := Y) 1 a hIndep (by
    intro i
    simpa [Z, a] using hZ_exp i)
  have hupper := exponentialMarkovUpper hS_meas (lam := (1 : ℝ))
    (t := -(Fintype.card ι : ℝ)) one_pos (by simpa using hS_exp)
  have hS_formula : ∀ ω, S ω = -(∑ i, Y i ω) / δ := by
    intro ω
    dsimp [S, Z, a]
    rw [← Finset.mul_sum]
    field_simp
  have hevent :
      {ω | ∑ i, Y i ω ≤ δ * (Fintype.card ι : ℝ)} =
        S ⁻¹' Set.Ici (-(Fintype.card ι : ℝ)) := by
    ext ω
    rw [Set.mem_setOf_eq, Set.mem_preimage, Set.mem_Ici]
    rw [hS_formula]
    constructor
    · intro h
      apply (le_div_iff₀ hδ).2
      linarith
    · intro h
      have h' := (le_div_iff₀ hδ).1 h
      linarith
  have hmgfS :
      (∫ ω, Real.exp (S ω) ∂μ) =
        ∏ i, ∫ ω, Real.exp (a i * Y i ω) ∂μ := by
    calc
      (∫ ω, Real.exp (S ω) ∂μ) =
          ∫ ω, Real.exp (1 * ∑ i, a i * Y i ω) ∂μ := by
            simp [S, Z]
      _ = ∏ i, ∫ ω, Real.exp (1 * (a i * Y i ω)) ∂μ := hmgf
      _ = ∏ i, ∫ ω, Real.exp (a i * Y i ω) ∂μ := by simp
  have hprod :
      (∏ i, ∫ ω, Real.exp (a i * Y i ω) ∂μ) ≤ q ^ Fintype.card ι := by
    calc
      (∏ i, ∫ ω, Real.exp (a i * Y i ω) ∂μ) ≤
          ∏ _i, q := Finset.prod_le_prod
            (fun i _ => integral_nonneg_of_ae
              (Filter.Eventually.of_forall (fun ω => le_of_lt (Real.exp_pos _))))
            (fun i _ => by simpa [a] using (hLaplace i).2)
      _ = q ^ Fintype.card ι := by simp
  rw [hevent]
  calc
    μ.real (S ⁻¹' Set.Ici (-(Fintype.card ι : ℝ))) ≤
        Real.exp (Fintype.card ι : ℝ) * (∫ ω, Real.exp (S ω) ∂μ) := by
      simpa using hupper
    _ = Real.exp (Fintype.card ι : ℝ) *
        (∏ i, ∫ ω, Real.exp (a i * Y i ω) ∂μ) := by rw [hmgfS]
    _ ≤ Real.exp (Fintype.card ι : ℝ) * q ^ Fintype.card ι :=
      mul_le_mul_of_nonneg_left hprod (le_of_lt (Real.exp_pos _))
    _ = (Real.exp 1 * q) ^ Fintype.card ι := by
      rw [mul_pow]
      congr 1
      rw [← Real.exp_nat_mul]
      norm_num

/-- If every coordinate law is dominated by Lebesgue measure, then the
Euclidean norm has small-ball probability at most `(C ε)ⁿ` at radius `ε√n`.
Law domination is the extensional form of having a density bounded by one. -/
theorem euclideanNorm_smallBall :
    ∃ C : ℝ, 0 < C ∧
      ∀ {n : ℕ} [Nonempty (Fin n)]
        {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : Fin n → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          iIndepFun X μ →
            (∀ i, Measure.map (X i) μ ≤ (volume : Measure ℝ)) →
              ∀ ε : ℝ, 0 < ε →
                μ.real {ω |
                    NumStability.vecNorm2 (fun i => X i ω) ≤
                      ε * Real.sqrt (n : ℝ)} ≤
                  (C * ε) ^ n := by
  let C : ℝ := Real.exp 1 * Real.sqrt Real.pi
  have hC : 0 < C := mul_pos (Real.exp_pos _) (Real.sqrt_pos.2 Real.pi_pos)
  refine ⟨C, hC, ?_⟩
  intro n _ Ω _ μ _ X hMeas hIndep hLaw ε hε
  let Y : Fin n → Ω → ℝ := fun i ω => X i ω ^ 2
  let δ : ℝ := ε ^ 2
  let q : ℝ := Real.sqrt Real.pi * ε
  have hδ : 0 < δ := sq_pos_of_pos hε
  have hYMeas : ∀ i, Measurable (Y i) := by
    intro i
    dsimp [Y]
    fun_prop
  have hYIndep : iIndepFun Y μ := by
    simpa [Y, Function.comp_def] using
      hIndep.comp (fun (_ : Fin n) (x : ℝ) => x ^ 2) (fun _ => by fun_prop)
  have hLaplace : ∀ i,
      Integrable (fun ω => Real.exp (-(1 / δ) * Y i ω)) μ ∧
        (∫ ω, Real.exp (-(1 / δ) * Y i ω) ∂μ) ≤ q := by
    intro i
    let g : ℝ → ℝ := fun x => Real.exp (-(1 / δ) * x ^ 2)
    have hb : 0 < 1 / δ := one_div_pos.mpr hδ
    have hgMeas : Measurable g := by
      dsimp [g]
      fun_prop
    have hgVol : Integrable g (volume : Measure ℝ) := by
      simpa [g, neg_mul] using integrable_exp_neg_mul_sq hb
    have hgMap : Integrable g (Measure.map (X i) μ) :=
      hgVol.mono_measure (hLaw i)
    have hgComp : Integrable (g ∘ X i) μ :=
      (integrable_map_measure hgMeas.aestronglyMeasurable
        (hMeas i).aemeasurable).mp hgMap
    constructor
    · simpa [g, Y, Function.comp_def] using hgComp
    · calc
        (∫ ω, Real.exp (-(1 / δ) * Y i ω) ∂μ) =
            ∫ x, g x ∂Measure.map (X i) μ := by
          rw [integral_map (hMeas i).aemeasurable hgMeas.aestronglyMeasurable]
        _ ≤ ∫ x, g x ∂(volume : Measure ℝ) :=
          integral_mono_measure (hLaw i)
            (Filter.Eventually.of_forall fun x => (Real.exp_pos _).le) hgVol
        _ = q := by
          rw [show (∫ x, g x ∂(volume : Measure ℝ)) = Real.sqrt (Real.pi / (1 / δ)) by
            simpa [g, neg_mul] using integral_gaussian (1 / δ)]
          have hcalc : Real.pi / (1 / δ) = Real.pi * ε ^ 2 := by
            dsimp [δ]
            field_simp
          rw [hcalc, Real.sqrt_mul Real.pi_nonneg, Real.sqrt_sq_eq_abs,
            abs_of_pos hε]
  have hBound := smallBallProbabilityOfLaplace
    (μ := μ) (Y := Y) (δ := δ) (q := q) hδ hYMeas hYIndep hLaplace
  have hEvent :
      {ω | NumStability.vecNorm2 (fun i => X i ω) ≤
          ε * Real.sqrt (n : ℝ)} =
        {ω | ∑ i : Fin n, Y i ω ≤ δ * (n : ℝ)} := by
    ext ω
    simp only [Set.mem_setOf_eq]
    have hn0 : (0 : ℝ) ≤ n := by positivity
    have hleft0 : 0 ≤ NumStability.vecNorm2 (fun i => X i ω) := by
      dsimp [NumStability.vecNorm2]
      exact Real.sqrt_nonneg _
    have hright0 : 0 ≤ ε * Real.sqrt (n : ℝ) :=
      mul_nonneg hε.le (Real.sqrt_nonneg _)
    rw [← sq_le_sq₀ hleft0 hright0]
    rw [NumStability.vecNorm2_sq, mul_pow, Real.sq_sqrt hn0]
    rfl
  rw [hEvent]
  simpa [C, q, mul_assoc] using hBound

end NumStability.HDP.Vector.SmallBall
