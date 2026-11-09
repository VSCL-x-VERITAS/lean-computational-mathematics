import ComputationalMathematics.Source.NocedalWright.Chapter02.QuarticDegenerateHessianTargetV5

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

theorem quarticDegenerateHessianV5 : quarticDegenerateHessianTargetV5 := by
  have hfirst (y : ℝ) : deriv (fun z : ℝ => z ^ 4) y = 4 * y ^ 3 := by
    convert (deriv_pow (f := fun z : ℝ => z) differentiableAt_id 4) using 1; norm_num [quarticFourSubOne]
  have hsecond : deriv (deriv (fun z : ℝ => z ^ 4)) 0 = 0 := by
    have hfun : deriv (fun z : ℝ => z ^ 4) = (fun z : ℝ => 4 * z ^ 3) := by
      funext z; exact hfirst z
    rw [hfun]
    rw [deriv_const_mul (4 : ℝ) (differentiableAt_pow 3)]
    have hpow : deriv (fun z : ℝ => z ^ 3) 0 = 0 := by
      convert (deriv_pow (f := fun z : ℝ => z) differentiableAt_id 3) using 1; norm_num [quarticThreeSubOne]
    rw [hpow]
    norm_num
  refine ⟨?_, hsecond, ?_⟩
  · refine ⟨Set.univ, isOpen_univ, Set.mem_univ _, ?_⟩
    intro x hx hx0
    simp only [zero_pow (by norm_num : 4 ≠ 0)]
    have h4 : 0 < (x ^ 2) ^ 2 := pow_pos (sq_pos_of_ne_zero hx0) 2
    nlinarith [h4]
  · intro hpd
    have h := hpd 1 (by norm_num)
    rw [hsecond] at h
    norm_num at h

end ComputationalMathematics.Source.NocedalWright.Chapter02
