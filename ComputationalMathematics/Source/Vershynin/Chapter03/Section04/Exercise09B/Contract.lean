import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Exercise09B.Signature

/-! Exercise 3.4.9(b): the isotropically scaled uniform `ℓ₁`-ball vector has
no dimension-free `ψ₂` bound. -/

noncomputable section

open scoped ENNReal

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_4_9b : hdp_03_ex_3_4_9b__contract_type := by
  intro C hC
  let a : ℝ := 32 * Real.log 2 * C ^ 2
  obtain ⟨n, hn⟩ := exists_nat_gt (max 0 a + 2)
  have hnpos : 0 < n := by
    have htwo : (2 : ℝ) < n :=
      lt_of_le_of_lt (by linarith [le_max_left (0 : ℝ) a]) hn
    exact_mod_cast (lt_trans (by norm_num : (0 : ℝ) < 2) htwo)
  refine ⟨n, hnpos, ?_⟩
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have ha_lt : a < (n : ℝ) + 2 := by
    have ha_le : a ≤ max 0 a := le_max_right _ _
    linarith
  have hsq : C ^ 2 < ((n : ℝ) + 2) / (32 * Real.log 2) := by
    apply (lt_div_iff₀ (by positivity : 0 < 32 * Real.log 2)).2
    dsimp [a] at ha_lt
    nlinarith
  have hscalePos :
      0 < Real.sqrt (((n : ℝ) + 2) / (32 * Real.log 2)) := by
    positivity
  have hscale :
      C < Real.sqrt (((n : ℝ) + 2) / (32 * Real.log 2)) :=
    (Real.lt_sqrt hC.le).2 hsq
  have hOfReal :
      ENNReal.ofReal C <
        ENNReal.ofReal (Real.sqrt (((n : ℝ) + 2) / (32 * Real.log 2))) :=
    (ENNReal.ofReal_lt_ofReal_iff hscalePos).2 hscale
  exact hOfReal.trans_le
    (NumStability.HDP.Vector.L1Ball.identityVector_psiTwoNorm_ge_of_pos hnpos)

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_4_9b__contract : hdp_03_ex_3_4_9b__contract_type :=
  hdp_03_ex_3_4_9b

end NumStability.HDP.Contract
