import ComputationalMathematics.HDP.Vector.CoordinateDistribution
import ComputationalMathematics.HDP.Vector.SubGaussian

/-!
# The sub-Gaussian norm of the coordinate distribution

This module develops the exact exponential-square scale of linear marginals
of the uniform law on the scaled coordinate vectors.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Vector.CoordinateDistribution

/-- The coordinate projections viewed as the canonical random vector on its
own distribution space. -/
def coordinateRandomVector (n : ℕ) : Fin n → (Fin n → ℝ) → ℝ :=
  fun i x ↦ x i

/-- The exponential-square integral of a coordinate-distribution marginal is
the corresponding finite average. -/
lemma coordinateMarginal_exp_integral (n : ℕ) [NeZero n]
    (u : Fin n → ℝ) (t : ℝ) :
    (∫ x, Real.exp
        (NumStability.HDP.Vector.linearMarginal (coordinateRandomVector n) u x ^ 2 / t ^ 2)
      ∂coordinateDistributionMeasure n) =
      (n : ℝ)⁻¹ * ∑ j : Fin n, Real.exp ((Real.sqrt n * u j) ^ 2 / t ^ 2) := by
  unfold coordinateDistributionMeasure
  rw [integral_map (measurable_of_countable _).aemeasurable]
  · simp only [ProbabilityTheory.uniformOn, ProbabilityTheory.cond,
      integral_smul_measure, Measure.restrict_univ, Measure.count_apply_finite,
      Set.toFinite, integral_count]
    have hn : (n : ℝ) ≠ 0 := by exact_mod_cast (NeZero.ne n)
    simp only [coordinateRandomVector, NumStability.HDP.Vector.linearMarginal,
      coordinateVector, Pi.smul_apply, smul_eq_mul, Pi.single_apply]
    rw [ENNReal.toReal_inv]
    simp
  · apply Measurable.aestronglyMeasurable
    unfold NumStability.HDP.Vector.linearMarginal coordinateRandomVector
    fun_prop

/-- The exact candidate scale for the vector `ψ₂` norm of the coordinate
distribution. -/
def coordinatePsiTwoScale (n : ℕ) : ℝ :=
  Real.sqrt ((n : ℝ) / Real.log (n + 1))

lemma coordinatePsiTwoScale_pos (n : ℕ) [NeZero n] :
    0 < coordinatePsiTwoScale n := by
  apply Real.sqrt_pos.2
  exact div_pos (by exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne n))
    (Real.log_pos (by
      exact_mod_cast Nat.succ_lt_succ (Nat.pos_of_ne_zero (NeZero.ne n))))

lemma coordinateMarginal_exp_integrable (n : ℕ) [NeZero n]
    (u : Fin n → ℝ) (t : ℝ) :
    Integrable (fun x ↦ Real.exp
      (NumStability.HDP.Vector.linearMarginal (coordinateRandomVector n) u x ^ 2 / t ^ 2))
      (coordinateDistributionMeasure n) := by
  unfold coordinateDistributionMeasure
  apply (integrable_map_measure ?_ (measurable_of_countable _).aemeasurable).2
  · exact Integrable.of_finite
  · apply Measurable.aestronglyMeasurable
    unfold NumStability.HDP.Vector.linearMarginal coordinateRandomVector
    fun_prop

/-- Convexity bounds the exponential at a point of `[0,1]` by the chord
joining its endpoint values. -/
lemma exp_chord_bound {A x : ℝ} (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    Real.exp (A * x) ≤ 1 + x * (Real.exp A - 1) := by
  have h := convexOn_exp.2 (Set.mem_univ (0 : ℝ)) (Set.mem_univ A)
    (sub_nonneg.mpr hx1) hx0 (by ring : (1 - x) + x = 1)
  convert h using 1 <;> simp [smul_eq_mul] <;> ring

/-- At the candidate scale, the exponential-square average of every unit
direction is at most the defining threshold `2`. -/
lemma coordinate_exp_sum_le_two (n : ℕ) [NeZero n]
    (u : Fin n → ℝ) (hu : ∑ i, u i ^ 2 = 1) :
    (n : ℝ)⁻¹ * ∑ i : Fin n,
        Real.exp (Real.log (n + 1) * u i ^ 2) ≤ 2 := by
  have hn : (0 : ℝ) < n := by exact_mod_cast (Nat.pos_of_ne_zero (NeZero.ne n))
  have hpoint (i : Fin n) :
      Real.exp (Real.log (n + 1) * u i ^ 2) ≤ 1 + (n : ℝ) * u i ^ 2 := by
    have hsq0 : 0 ≤ u i ^ 2 := sq_nonneg _
    have hsq1 : u i ^ 2 ≤ 1 := by
      rw [← hu]
      exact Finset.single_le_sum (fun j _ ↦ sq_nonneg (u j)) (Finset.mem_univ i)
    calc
      Real.exp (Real.log (n + 1) * u i ^ 2) ≤
          1 + u i ^ 2 * (Real.exp (Real.log (n + 1)) - 1) :=
        exp_chord_bound hsq0 hsq1
      _ = 1 + (n : ℝ) * u i ^ 2 := by
        rw [Real.exp_log (by positivity : (0 : ℝ) < n + 1)]
        norm_num
        ring
  calc
    (n : ℝ)⁻¹ * ∑ i : Fin n,
          Real.exp (Real.log (n + 1) * u i ^ 2) ≤
        (n : ℝ)⁻¹ * ∑ i : Fin n, (1 + (n : ℝ) * u i ^ 2) := by
      gcongr with i
      exact hpoint i
    _ = 2 := by
      rw [Finset.sum_add_distrib, Finset.sum_const, Finset.card_univ,
        Fintype.card_fin, nsmul_eq_mul, ← Finset.mul_sum, hu]
      field_simp
      ring

/-- Every unit marginal of the coordinate distribution satisfies the defining
exponential-square estimate at `coordinatePsiTwoScale`. -/
lemma coordinateMarginal_squarePoint (n : ℕ) [NeZero n]
    (u : Fin n → ℝ) (hu : NumStability.vecNorm2 u = 1) :
    NumStability.HDP.Scalar.SubGaussian.SubGaussianSquarePoint
      (coordinateDistributionMeasure n)
      (NumStability.HDP.Vector.linearMarginal (coordinateRandomVector n) u)
      (coordinatePsiTwoScale n) := by
  have hn0 : (0 : ℝ) < n := by
    exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne n)
  have hlog : 0 < Real.log ((n : ℝ) + 1) :=
    Real.log_pos (by
      exact_mod_cast Nat.succ_lt_succ (Nat.pos_of_ne_zero (NeZero.ne n)))
  have hsqrtSq : (Real.sqrt (n : ℝ)) ^ 2 = n := Real.sq_sqrt hn0.le
  have hscaleSq : coordinatePsiTwoScale n ^ 2 =
      (n : ℝ) / Real.log (n + 1) := by
    exact Real.sq_sqrt (div_nonneg hn0.le hlog.le)
  have huSq : ∑ i, u i ^ 2 = 1 := by
    calc
      ∑ i, u i ^ 2 = NumStability.vecNorm2Sq u := rfl
      _ = NumStability.vecNorm2 u ^ 2 := (NumStability.vecNorm2_sq u).symm
      _ = 1 := by rw [hu]; norm_num
  refine ⟨?_, coordinatePsiTwoScale_pos n, coordinateMarginal_exp_integrable n u _, ?_⟩
  · unfold NumStability.HDP.Vector.linearMarginal coordinateRandomVector
    fun_prop
  · rw [coordinateMarginal_exp_integral]
    have hterm (i : Fin n) :
        (Real.sqrt n * u i) ^ 2 / coordinatePsiTwoScale n ^ 2 =
          Real.log (n + 1) * u i ^ 2 := by
      rw [hscaleSq, mul_pow, hsqrtSq]
      field_simp [ne_of_gt hn0, ne_of_gt hlog]
    simp_rw [hterm]
    exact coordinate_exp_sum_le_two n u huSq

/-- The vector `ψ₂` norm of the coordinate distribution is at most its
exact candidate scale. -/
theorem coordinateDistribution_psiTwoNorm_le (n : ℕ) [NeZero n] :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (coordinateDistributionMeasure n) (coordinateRandomVector n) ≤
      ENNReal.ofReal (coordinatePsiTwoScale n) := by
  unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
  apply iSup_le
  intro u
  simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using
    NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_le_of_squarePoint
      (coordinateMarginal_squarePoint n u.1 u.2)

/-- The first canonical coordinate direction. -/
def coordinateAxisDirection (n : ℕ) [NeZero n] : Fin n → ℝ :=
  Pi.single 0 1

lemma coordinateAxisDirection_unit (n : ℕ) [NeZero n] :
    NumStability.vecNorm2 (coordinateAxisDirection n) = 1 := by
  unfold NumStability.vecNorm2 NumStability.vecNorm2Sq coordinateAxisDirection
  rw [Finset.sum_eq_single (0 : Fin n)]
  · norm_num
  · intro j _ hj
    simp [hj]
  · simp

/-- Along the first coordinate axis the exponential-square sum has one
nontrivial term and `n - 1` unit terms. -/
lemma coordinateAxis_exp_sum (n : ℕ) [NeZero n] (t : ℝ) :
    ∑ j : Fin n, Real.exp ((Real.sqrt n * coordinateAxisDirection n j) ^ 2 / t ^ 2) =
      Real.exp ((n : ℝ) / t ^ 2) + (n - 1 : ℕ) := by
  have hsqrtSq : (Real.sqrt (n : ℝ)) ^ 2 = n :=
    Real.sq_sqrt (by positivity)
  rw [← Finset.sum_erase_add Finset.univ _ (Finset.mem_univ (0 : Fin n))]
  have hoff : ∑ j ∈ Finset.univ.erase (0 : Fin n),
      Real.exp ((Real.sqrt n * coordinateAxisDirection n j) ^ 2 / t ^ 2) =
        (n - 1 : ℕ) := by
    calc
      ∑ j ∈ Finset.univ.erase (0 : Fin n),
          Real.exp ((Real.sqrt n * coordinateAxisDirection n j) ^ 2 / t ^ 2) =
          ∑ _j ∈ Finset.univ.erase (0 : Fin n), (1 : ℝ) := by
            apply Finset.sum_congr rfl
            intro j hj
            have hj0 : j ≠ (0 : Fin n) := Finset.ne_of_mem_erase hj
            simp [coordinateAxisDirection, hj0]
      _ = (n - 1 : ℕ) := by simp
  rw [hoff]
  simp only [coordinateAxisDirection, Pi.single_eq_same, mul_one]
  rw [hsqrtSq]
  ring

/-- The coordinate-axis marginal has `ψ₂` norm at least the candidate
scale. -/
lemma coordinateAxis_psiTwoNorm_ge (n : ℕ) [NeZero n] :
    ENNReal.ofReal (coordinatePsiTwoScale n) ≤
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
        (coordinateDistributionMeasure n)
        (NumStability.HDP.Vector.linearMarginal
          (coordinateRandomVector n) (coordinateAxisDirection n)) := by
  have hnNat : 0 < n := Nat.pos_of_ne_zero (NeZero.ne n)
  have hn0 : (0 : ℝ) < n := by exact_mod_cast hnNat
  have hlog : 0 < Real.log ((n : ℝ) + 1) :=
    Real.log_pos (by exact_mod_cast Nat.succ_lt_succ hnNat)
  have hscaleSq : coordinatePsiTwoScale n ^ 2 =
      (n : ℝ) / Real.log (n + 1) := by
    exact Real.sq_sqrt (div_nonneg hn0.le hlog.le)
  unfold NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
  apply le_sInf
  intro t ht
  rcases ht with ⟨_, ht0, htTop, _, hBound⟩
  rw [coordinateMarginal_exp_integral, coordinateAxis_exp_sum] at hBound
  have hBound' : Real.exp ((n : ℝ) / t.toReal ^ 2) + (n - 1 : ℕ) ≤
      2 * (n : ℝ) := by
    apply (div_le_iff₀ hn0).mp
    simpa [div_eq_inv_mul] using hBound
  have hcast : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
    have hn1 : 1 ≤ n := hnNat
    rw [Nat.cast_sub hn1]
    norm_num
  have hExp : Real.exp ((n : ℝ) / t.toReal ^ 2) ≤ (n : ℝ) + 1 := by
    rw [hcast] at hBound'
    linarith
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hArg : (n : ℝ) / t.toReal ^ 2 ≤ Real.log ((n : ℝ) + 1) := by
    calc
      (n : ℝ) / t.toReal ^ 2 =
          Real.log (Real.exp ((n : ℝ) / t.toReal ^ 2)) := by
            rw [Real.log_exp]
      _ ≤ Real.log ((n : ℝ) + 1) :=
        Real.log_le_log (Real.exp_pos _) hExp
  have hScaleLe : coordinatePsiTwoScale n ≤ t.toReal := by
    apply (sq_le_sq₀ (coordinatePsiTwoScale_pos n).le htpos.le).mp
    rw [hscaleSq]
    apply (div_le_iff₀ hlog).2
    have hmul := (div_le_iff₀ (sq_pos_of_pos htpos)).mp hArg
    simpa [mul_comm] using hmul
  rw [ENNReal.ofReal_le_iff_le_toReal htTop]
  exact hScaleLe

/-- The coordinate direction supplies the matching lower bound for the vector
` ψ₂` norm. -/
theorem coordinateDistribution_psiTwoNorm_ge (n : ℕ) [NeZero n] :
    ENNReal.ofReal (coordinatePsiTwoScale n) ≤
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (coordinateDistributionMeasure n) (coordinateRandomVector n) := by
  calc
    ENNReal.ofReal (coordinatePsiTwoScale n) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          (coordinateDistributionMeasure n)
          (NumStability.HDP.Vector.linearMarginal
            (coordinateRandomVector n) (coordinateAxisDirection n)) :=
      coordinateAxis_psiTwoNorm_ge n
    _ ≤ NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (coordinateDistributionMeasure n) (coordinateRandomVector n) := by
      unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
      exact le_iSup (fun u : NumStability.HDP.Vector.SubGaussian.UnitDirection n ↦
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          (coordinateDistributionMeasure n)
          (NumStability.HDP.Vector.linearMarginal (coordinateRandomVector n) u.1))
        ⟨coordinateAxisDirection n, coordinateAxisDirection_unit n⟩

/-- Exact `ψ₂` norm of the coordinate distribution. -/
theorem coordinateDistribution_psiTwoNorm_exact (n : ℕ) [NeZero n] :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (coordinateDistributionMeasure n) (coordinateRandomVector n) =
      ENNReal.ofReal (coordinatePsiTwoScale n) := by
  exact le_antisymm (coordinateDistribution_psiTwoNorm_le n)
    (coordinateDistribution_psiTwoNorm_ge n)

/-- For dimensions at least two, the exact scale is comparable to the source's
`sqrt (n / log n)` expression with universal constants. -/
lemma coordinatePsiTwoScale_comparable {n : ℕ} (hn : 2 ≤ n) :
    (1 / Real.sqrt 2) * Real.sqrt ((n : ℝ) / Real.log n) ≤
        coordinatePsiTwoScale n ∧
      coordinatePsiTwoScale n ≤ Real.sqrt ((n : ℝ) / Real.log n) := by
  letI : NeZero n := ⟨by omega⟩
  have hn0 : (0 : ℝ) < n := by positivity
  have hn1 : (1 : ℝ) < n := by exact_mod_cast hn
  have hlogn : 0 < Real.log (n : ℝ) := Real.log_pos hn1
  have hlognp1 : 0 < Real.log ((n : ℝ) + 1) :=
    Real.log_pos (by linarith)
  have hlog_le : Real.log (n : ℝ) ≤ Real.log ((n : ℝ) + 1) := by
    exact Real.log_le_log hn0 (by linarith)
  have hsquare : (n : ℝ) + 1 ≤ (n : ℝ) ^ 2 := by
    have hn2 : (2 : ℝ) ≤ n := by exact_mod_cast hn
    nlinarith
  have hlog_two : Real.log ((n : ℝ) + 1) ≤ 2 * Real.log (n : ℝ) := by
    calc
      Real.log ((n : ℝ) + 1) ≤ Real.log ((n : ℝ) ^ 2) :=
        Real.log_le_log (by positivity) hsquare
      _ = 2 * Real.log (n : ℝ) := by rw [Real.log_pow]; norm_num
  have hbaseSq : (Real.sqrt ((n : ℝ) / Real.log n)) ^ 2 =
      (n : ℝ) / Real.log n :=
    Real.sq_sqrt (div_nonneg hn0.le hlogn.le)
  constructor
  · have hleft0 : 0 ≤ (1 / Real.sqrt 2) *
        Real.sqrt ((n : ℝ) / Real.log n) := by positivity
    apply (sq_le_sq₀ hleft0 (Real.sqrt_nonneg _)).mp
    rw [mul_pow, hbaseSq, div_pow,
      Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2),
      Real.sq_sqrt (div_nonneg hn0.le hlognp1.le)]
    calc
      1 ^ 2 / 2 * ((n : ℝ) / Real.log n) =
          (n : ℝ) / (2 * Real.log n) := by field_simp
      _ ≤ (n : ℝ) / Real.log (n + 1) :=
        (div_le_div_iff_of_pos_left hn0 (mul_pos (by norm_num) hlogn) hlognp1).2
          hlog_two
  · apply Real.sqrt_le_sqrt
    exact (div_le_div_iff_of_pos_left hn0 hlognp1 hlogn).2 hlog_le

end NumStability.HDP.Vector.CoordinateDistribution
