import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Exercise03B.Signature

/-! Exercise 3.4.3(2): an arbitrarily large dependent-coordinate `ψ₂`-norm gap. -/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- There are finite random vectors whose vector `ψ₂` norm exceeds the
largest coordinate `ψ₂` norm by an arbitrarily large factor. -/
theorem hdp_03_ex_3_4_3b : hdp_03_ex_3_4_3b__contract_type := by
  intro m hm
  let n := m * m
  have hn : 0 < n := by
    dsimp [n]
    exact Nat.mul_pos hm hm
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  let μ := NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw
  let X := NumStability.HDP.Vector.SubGaussian.repeatedCoordinateVector n
  let q : ℝ≥0∞ := ENNReal.ofReal (1 / Real.sqrt (Real.log 2))
  have hCounter :=
    NumStability.HDP.Vector.SubGaussian.repeatedCoordinate_counterexample
      (n := n) hn
  rcases hCounter with ⟨hCoord, hVector, hCoordNorm, hGap⟩
  have hSup :
      (⨆ i, NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i)) = q := by
    simp only [μ, X, q, hCoordNorm, iSup_const]
  have hq : 0 < q := by
    apply ENNReal.ofReal_pos.mpr
    exact div_pos zero_lt_one (Real.sqrt_pos.2 (Real.log_pos (by norm_num)))
  have hsqrt : Real.sqrt (n : ℝ) = (m : ℝ) := by
    rw [show (n : ℝ) = (m : ℝ) ^ 2 by simp [n, pow_two]]
    exact Real.sqrt_sq (by positivity)
  refine ⟨n, μ, X, ?_, hCoord, hVector, ?_, ?_⟩
  · exact NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw_probability
  · simpa [hSup] using hq
  · simpa [hSup, q, hsqrt] using hGap

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_4_3b__contract : hdp_03_ex_3_4_3b__contract_type :=
  hdp_03_ex_3_4_3b

end NumStability.HDP.Contract
