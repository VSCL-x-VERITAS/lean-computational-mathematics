import ComputationalMathematics.HDP.Vector.L1Ball
import ComputationalMathematics.HDP.Vector.SubGaussianFinite

/-!
# Sub-Gaussian lower bounds for uniform `ℓ₁` balls

The exact half-radius coordinate tail forces the scalar `ψ₂` norm of every
coordinate, and hence the vector `ψ₂` norm of the identity random vector, to
grow at least on the order of the square root of the dimension.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Vector.L1Ball

theorem isotropicRadius_sq (n : ℕ) :
    isotropicRadius n ^ 2 =
      (((n : ℝ) + 1) * ((n : ℝ) + 2)) / 2 := by
  rw [isotropicRadius]
  exact Real.sq_sqrt (by positivity)

theorem log_half_pow (n : ℕ) :
    Real.log ((1 / 2 : ℝ) ^ n) = -(n : ℝ) * Real.log 2 := by
  rw [Real.log_pow, Real.log_div (by norm_num) (by norm_num)]
  simp

/-- Every coordinate of the isotropically scaled uniform `ℓ₁`-ball law has
an explicit dimension-growing `ψ₂` lower bound. -/
theorem coordinate_psiTwoNorm_ge {n : ℕ} (hn : 0 < n) (i : Fin n) :
    ENNReal.ofReal (Real.sqrt (((n : ℝ) + 2) / (32 * Real.log 2))) ≤
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
        (uniformMeasure n (isotropicRadius n))
        (fun x : Fin n → ℝ ↦ x i) := by
  letI : IsProbabilityMeasure (uniformMeasure n (isotropicRadius n)) :=
    uniformMeasure_isProbabilityMeasure n (isotropicRadius_pos n)
  let μ := uniformMeasure n (isotropicRadius n)
  let X : (Fin n → ℝ) → ℝ := fun x ↦ x i
  let g := NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X
  change ENNReal.ofReal (Real.sqrt (((n : ℝ) + 2) / (32 * Real.log 2))) ≤ g
  by_cases hFinite : g < ⊤
  · have hX : Measurable X := by
      dsimp [X]
      exact measurable_pi_apply i
    have hExact :
        μ.real {x : Fin n → ℝ | isotropicRadius n / 2 ≤ |X x|} =
          (1 / 2 : ℝ) ^ n := by
      simpa [μ, X] using
        (uniformMeasure_abs_coord_half_radius_real hn i (isotropicRadius_pos n))
    have hg0 : g ≠ 0 := by
      intro hg
      have hAE : X =ᵐ[μ] (fun _ ↦ 0) :=
        (NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_eq_zero_iff_ae_eq_zero
          hX).mp hg
      have hEvent :
          {x : Fin n → ℝ | isotropicRadius n / 2 ≤ |X x|} =ᵐ[μ]
            (∅ : Set (Fin n → ℝ)) := by
        filter_upwards [hAE] with x hx
        change (isotropicRadius n / 2 ≤ |X x|) = False
        rw [hx, abs_zero]
        exact propext (iff_false_intro (not_le_of_gt (by
          have := isotropicRadius_pos n
          linarith)))
      have hzero :
          μ.real {x : Fin n → ℝ | isotropicRadius n / 2 ≤ |X x|} = 0 := by
        rw [Measure.real_def, measure_congr hEvent]
        simp
      have hpos :
          0 < μ.real {x : Fin n → ℝ | isotropicRadius n / 2 ≤ |X x|} := by
        rw [hExact]
        positivity
      exact (ne_of_gt hpos) hzero
    have hgTop : g ≠ ⊤ := ne_of_lt hFinite
    have hgRealPos : 0 < g.toReal := ENNReal.toReal_pos hg0 hgTop
    have hTail :=
      NumStability.HDP.Scalar.SubGaussian.psiTwoGaugeToTail
        (μ := μ) (X := X) hX hFinite
        (t := isotropicRadius n / 2)
        (div_nonneg (isotropicRadius_pos n).le (by norm_num))
    have hTail' :
        (1 / 2 : ℝ) ^ n ≤
          2 * Real.exp
            (-(isotropicRadius n / 2) ^ 2 / (2 * g.toReal) ^ 2) := by
      rw [hExact] at hTail
      simpa [g] using hTail
    have hLog := Real.log_le_log
      (show (0 : ℝ) < (1 / 2 : ℝ) ^ n by positivity) hTail'
    rw [log_half_pow,
      Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) (Real.exp_ne_zero _),
      Real.log_exp] at hLog
    have hArg :
        isotropicRadius n ^ 2 / (16 * g.toReal ^ 2) ≤
          ((n : ℝ) + 1) * Real.log 2 := by
      have hfrac :
          -(isotropicRadius n / 2) ^ 2 / (2 * g.toReal) ^ 2 =
            -(isotropicRadius n ^ 2 / (16 * g.toReal ^ 2)) := by
        field_simp [ne_of_gt hgRealPos]
        ring
      rw [hfrac] at hLog
      nlinarith
    have hdenPos : 0 < 16 * g.toReal ^ 2 := by positivity
    have hMul := (div_le_iff₀ hdenPos).mp hArg
    rw [isotropicRadius_sq] at hMul
    have hn1Pos : 0 < (n : ℝ) + 1 := by positivity
    have hCancel :
        ((n : ℝ) + 1) * (((n : ℝ) + 2) / 2) ≤
          ((n : ℝ) + 1) * (16 * Real.log 2 * g.toReal ^ 2) := by
      nlinarith
    have hBase :
        ((n : ℝ) + 2) / 2 ≤ 16 * Real.log 2 * g.toReal ^ 2 :=
      (mul_le_mul_iff_of_pos_left hn1Pos).mp hCancel
    have hlogPos : 0 < Real.log 2 := Real.log_pos (by norm_num)
    have hScaleSq :
        ((n : ℝ) + 2) / (32 * Real.log 2) ≤ g.toReal ^ 2 := by
      apply (div_le_iff₀ (by positivity : 0 < 32 * Real.log 2)).2
      nlinarith
    apply ENNReal.ofReal_le_of_le_toReal
    exact (Real.sqrt_le_left hgRealPos.le).2 hScaleSq
  · have hgTop : g = ⊤ := top_unique (le_of_not_gt hFinite)
    rw [hgTop]
    exact le_top

/-- A coordinate axis is a Euclidean unit direction. -/
theorem coordinateAxis_unit {n : ℕ} (i : Fin n) :
    NumStability.vecNorm2 (Pi.single i 1 : Fin n → ℝ) = 1 := by
  unfold NumStability.vecNorm2 NumStability.vecNorm2Sq
  rw [Finset.sum_eq_single i]
  · norm_num
  · intro j _ hji
    simp [hji]
  · simp

theorem identity_linearMarginal_coordinateAxis {n : ℕ} (i : Fin n) :
    NumStability.HDP.Vector.linearMarginal
        (fun j (x : Fin n → ℝ) ↦ x j) (Pi.single i 1) =
      (fun x : Fin n → ℝ ↦ x i) := by
  funext x
  unfold NumStability.HDP.Vector.linearMarginal
  rw [Finset.sum_eq_single i]
  · simp
  · intro j _ hji
    simp [hji]
  · simp

/-- The identity random vector under isotropically scaled uniform `ℓ₁`-ball
volume has vector `ψ₂` norm at least the explicit coordinate scale. -/
theorem identityVector_psiTwoNorm_ge {n : ℕ} (hn : 0 < n) (i : Fin n) :
    ENNReal.ofReal (Real.sqrt (((n : ℝ) + 2) / (32 * Real.log 2))) ≤
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (uniformMeasure n (isotropicRadius n))
        (fun j (x : Fin n → ℝ) ↦ x j) := by
  calc
    ENNReal.ofReal (Real.sqrt (((n : ℝ) + 2) / (32 * Real.log 2))) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          (uniformMeasure n (isotropicRadius n))
          (fun x : Fin n → ℝ ↦ x i) := coordinate_psiTwoNorm_ge hn i
    _ = NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          (uniformMeasure n (isotropicRadius n))
          (NumStability.HDP.Vector.linearMarginal
            (fun j (x : Fin n → ℝ) ↦ x j) (Pi.single i 1)) := by
      rw [identity_linearMarginal_coordinateAxis]
    _ ≤ NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (uniformMeasure n (isotropicRadius n))
          (fun j (x : Fin n → ℝ) ↦ x j) :=
      NumStability.HDP.Vector.SubGaussian.scalarPsiTwoNorm_le_vectorPsiTwoNorm
        (Pi.single i 1) (coordinateAxis_unit i)

/-- Dimension-positive form avoiding an externally supplied coordinate. -/
theorem identityVector_psiTwoNorm_ge_of_pos {n : ℕ} (hn : 0 < n) :
    ENNReal.ofReal (Real.sqrt (((n : ℝ) + 2) / (32 * Real.log 2))) ≤
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (uniformMeasure n (isotropicRadius n))
        (fun j (x : Fin n → ℝ) ↦ x j) := by
  let i : Fin n := ⟨0, hn⟩
  exact identityVector_psiTwoNorm_ge hn i

end NumStability.HDP.Vector.L1Ball
