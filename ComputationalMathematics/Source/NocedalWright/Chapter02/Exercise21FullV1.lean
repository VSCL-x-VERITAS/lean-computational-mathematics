import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise21FullTargetV1
import Mathlib.Analysis.Calculus.FDeriv.WithLp
import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise21PositiveHessianTargetV1
import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise21HessianTargetV1
import Mathlib.Tactic
import Mathlib.Analysis.Calculus.LocalExtr.Basic

open InnerProductSpace

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

private theorem rosenbrock_hasFDerivAt (x : EuclideanSpace ℝ (Fin 2)) :
    HasFDerivAt rosenbrockObjectiveV1
      ((100 : ℝ) • ((2 • (x 1 - (x 0)^2)) •
        ((EuclideanSpace.proj 1 : EuclideanSpace ℝ (Fin 2) →L[ℝ] ℝ) -
          ((2 • (x 0)) • (EuclideanSpace.proj 0 : EuclideanSpace ℝ (Fin 2) →L[ℝ] ℝ)))) +
        ((2 • (1 - x 0)) •
          (-(EuclideanSpace.proj 0 : EuclideanSpace ℝ (Fin 2) →L[ℝ] ℝ)))) x := by
  have h0 : HasFDerivAt (𝕜 := ℝ)
      (fun y : EuclideanSpace ℝ (Fin 2) => y 0)
      (EuclideanSpace.proj 0) x :=
    PiLp.hasFDerivAt_apply (p := 2) (𝕜 := ℝ)
      (E := fun _ : Fin 2 => ℝ) x 0
  have h1 : HasFDerivAt (𝕜 := ℝ)
      (fun y : EuclideanSpace ℝ (Fin 2) => y 1)
      (EuclideanSpace.proj 1) x :=
    PiLp.hasFDerivAt_apply (p := 2) (𝕜 := ℝ)
      (E := fun _ : Fin 2 => ℝ) x 1
  have hg := h1.sub (h0.pow 2)
  have hq := hg.pow 2
  have hr := (h0.const_sub 1).pow 2
  have hf := (hq.const_mul (100 : ℝ)).add hr
  convert hf using 1
  simp


private theorem rosenbrock_gradient_formula (x : EuclideanSpace ℝ (Fin 2)) :
    gradient rosenbrockObjectiveV1 x =
      EuclideanSpace.single 0
        (-400 * x 0 * (x 1 - (x 0)^2) - 2 * (1 - x 0)) +
      EuclideanSpace.single 1
        (200 * (x 1 - (x 0)^2)) := by
  let g : EuclideanSpace ℝ (Fin 2) :=
    EuclideanSpace.single 0
      (-400 * x 0 * (x 1 - (x 0)^2) - 2 * (1 - x 0)) +
    EuclideanSpace.single 1
      (200 * (x 1 - (x 0)^2))
  have hg : HasGradientAt rosenbrockObjectiveV1 g x := by
    rw [hasGradientAt_iff_hasFDerivAt]
    convert rosenbrock_hasFDerivAt x using 1
    ext v
    simp [g, InnerProductSpace.toDual_apply_apply, PiLp.inner_apply,
      Fin.sum_univ_two, EuclideanSpace.single_apply]
    change v 0 * _ + v 1 * _ = _
    simp only [starRingEnd_apply, star_trivial]
    ring
  exact hg.gradient


theorem exercise21GradientV1 : exercise21GradientTargetV1 := by
  intro x
  exact ⟨(rosenbrock_hasFDerivAt x).differentiableAt,
    rosenbrock_gradient_formula x⟩


private noncomputable def rosenbrockXstar : EuclideanSpace ℝ (Fin 2) :=
  EuclideanSpace.single 0 1 + EuclideanSpace.single 1 1

private theorem rosenbrockXstar_is_local : rosenbrockLocalMinV1 rosenbrockXstar := by
  have hstar : rosenbrockObjectiveV1 rosenbrockXstar = 0 := by
    norm_num [rosenbrockObjectiveV1, rosenbrockXstar, EuclideanSpace.single_apply]
  have hnonneg (x : EuclideanSpace ℝ (Fin 2)) :
      0 ≤ rosenbrockObjectiveV1 x := by
    unfold rosenbrockObjectiveV1
    positivity
  exact ⟨Set.univ, isOpen_univ, Set.mem_univ _, fun x _ => by
    rw [hstar]
    exact hnonneg x⟩

private theorem rosenbrock_local_unique (z : EuclideanSpace ℝ (Fin 2))
    (hz : rosenbrockLocalMinV1 z) : z = rosenbrockXstar := by
  obtain ⟨N, hNopen, hzN, hNmin⟩ := hz
  have hlocal : IsLocalMin rosenbrockObjectiveV1 z := by
    filter_upwards [hNopen.mem_nhds hzN] with y hy
    exact hNmin y hy
  have hgrad : gradient rosenbrockObjectiveV1 z = 0 := by
    simp [gradient, hlocal.fderiv_eq_zero]
  rw [rosenbrock_gradient_formula] at hgrad
  have h0 := congrArg (fun v : EuclideanSpace ℝ (Fin 2) => v 0) hgrad
  have h1 := congrArg (fun v : EuclideanSpace ℝ (Fin 2) => v 1) hgrad
  simp [EuclideanSpace.single_apply] at h0 h1
  have hz0 : z 0 = 1 := by nlinarith
  have hz1 : z 1 = 1 := by nlinarith
  ext i
  fin_cases i <;> norm_num [rosenbrockXstar, EuclideanSpace.single_apply, hz0, hz1]

theorem exercise21UniqueLocalMinimizerV1 :
    exercise21UniqueLocalMinimizerTargetV1 := by
  exact ⟨rosenbrockXstar_is_local, rosenbrock_local_unique⟩


private theorem rosenbrock_grad0_hasFDerivAt
    (x : EuclideanSpace ℝ (Fin 2)) :
    HasFDerivAt (𝕜 := ℝ)
      (fun y : EuclideanSpace ℝ (Fin 2) => (gradient rosenbrockObjectiveV1 y) 0)
      ((-400 : ℝ) •
        ((x 0) •
          ((EuclideanSpace.proj 1 : EuclideanSpace ℝ (Fin 2) →L[ℝ] ℝ) -
            ((2 • x 0) • (EuclideanSpace.proj 0 : EuclideanSpace ℝ (Fin 2) →L[ℝ] ℝ))) +
         (x 1 - (x 0)^2) •
           (EuclideanSpace.proj 0 : EuclideanSpace ℝ (Fin 2) →L[ℝ] ℝ)) +
        ((-2 : ℝ) •
          (-(EuclideanSpace.proj 0 : EuclideanSpace ℝ (Fin 2) →L[ℝ] ℝ)))) x := by
  have h0 : HasFDerivAt (𝕜 := ℝ)
      (fun y : EuclideanSpace ℝ (Fin 2) => y 0)
      (EuclideanSpace.proj 0) x :=
    PiLp.hasFDerivAt_apply (p := 2) (𝕜 := ℝ)
      (E := fun _ : Fin 2 => ℝ) x 0
  have h1 : HasFDerivAt (𝕜 := ℝ)
      (fun y : EuclideanSpace ℝ (Fin 2) => y 1)
      (EuclideanSpace.proj 1) x :=
    PiLp.hasFDerivAt_apply (p := 2) (𝕜 := ℝ)
      (E := fun _ : Fin 2 => ℝ) x 1
  have hq := h1.sub (h0.pow 2)
  have hp := h0.mul hq
  have hr := h0.const_sub 1
  have hf := (hp.const_mul (-400 : ℝ)).add (hr.const_mul (-2 : ℝ))
  convert hf using 1 <;> simp
  funext y
  rw [rosenbrock_gradient_formula]
  simp [EuclideanSpace.single_apply]
  ring

private theorem rosenbrock_grad1_hasFDerivAt
    (x : EuclideanSpace ℝ (Fin 2)) :
    HasFDerivAt (𝕜 := ℝ)
      (fun y : EuclideanSpace ℝ (Fin 2) => (gradient rosenbrockObjectiveV1 y) 1)
      ((200 : ℝ) •
        ((EuclideanSpace.proj 1 : EuclideanSpace ℝ (Fin 2) →L[ℝ] ℝ) -
          ((2 • x 0) • (EuclideanSpace.proj 0 : EuclideanSpace ℝ (Fin 2) →L[ℝ] ℝ)))) x := by
  have h0 : HasFDerivAt (𝕜 := ℝ)
      (fun y : EuclideanSpace ℝ (Fin 2) => y 0)
      (EuclideanSpace.proj 0) x :=
    PiLp.hasFDerivAt_apply (p := 2) (𝕜 := ℝ)
      (E := fun _ : Fin 2 => ℝ) x 0
  have h1 : HasFDerivAt (𝕜 := ℝ)
      (fun y : EuclideanSpace ℝ (Fin 2) => y 1)
      (EuclideanSpace.proj 1) x :=
    PiLp.hasFDerivAt_apply (p := 2) (𝕜 := ℝ)
      (E := fun _ : Fin 2 => ℝ) x 1
  have hq := h1.sub (h0.pow 2)
  have hf := hq.const_mul (200 : ℝ)
  convert hf using 1 <;> simp
  funext y
  rw [rosenbrock_gradient_formula]
  simp [EuclideanSpace.single_apply]


private theorem rosenbrock_bookHessian_eq_formula
    (x : EuclideanSpace ℝ (Fin 2)) :
    bookHessianMatrixV1 rosenbrockObjectiveV1 x =
      rosenbrockHessianFormulaV1 x := by
  funext i j
  fin_cases i
  · unfold bookHessianMatrixV1
    dsimp
    rw [(rosenbrock_grad0_hasFDerivAt x).fderiv]
    fin_cases j <;>
      norm_num [rosenbrockHessianFormulaV1, EuclideanSpace.single_apply] <;> ring
  · unfold bookHessianMatrixV1
    dsimp
    rw [(rosenbrock_grad1_hasFDerivAt x).fderiv]
    fin_cases j <;>
      norm_num [rosenbrockHessianFormulaV1, EuclideanSpace.single_apply] <;> ring


private def numericRosenbrockHessian : Fin 2 → Fin 2 → ℝ :=
  fun i j => if i = 0 then (if j = 0 then 802 else -400)
             else (if j = 0 then -400 else 200)

private theorem numericRosenbrockHessian_form (p : Fin 2 → ℝ) :
    bookQuadraticFormV2 numericRosenbrockHessian p =
      2 * (p 0)^2 + 200 * (2 * p 0 - p 1)^2 := by
  simp [bookQuadraticFormV2, numericRosenbrockHessian, Fin.sum_univ_two]
  ring

private theorem numericRosenbrockHessian_pd :
    IsBookPositiveDefiniteV2 numericRosenbrockHessian := by
  intro p hp
  rw [numericRosenbrockHessian_form]
  by_cases h0 : p 0 = 0
  · have h1 : p 1 ≠ 0 := by
      intro h1
      apply hp
      funext i
      fin_cases i <;> simp [h0, h1]
    have hsq : 0 < (p 1)^2 := sq_pos_of_ne_zero h1
    rw [h0]
    nlinarith
  · have hsq : 0 < (p 0)^2 := sq_pos_of_ne_zero h0
    have hrest : 0 ≤ (2 * p 0 - p 1)^2 := sq_nonneg _
    nlinarith

private theorem rosenbrock_bookHessian_at_xstar :
    bookHessianMatrixV1 rosenbrockObjectiveV1 rosenbrockXstar =
      numericRosenbrockHessian := by
  rw [rosenbrock_bookHessian_eq_formula]
  have hnum : (800 : ℝ) + 2 = 802 := by norm_num
  funext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [rosenbrockHessianFormulaV1, numericRosenbrockHessian,
      rosenbrockXstar, EuclideanSpace.single_apply]
  all_goals exact hnum

theorem exercise21PositiveHessianV1 :
    exercise21PositiveHessianTargetV1 := by
  change IsBookPositiveDefiniteV2
    (bookHessianMatrixV1 rosenbrockObjectiveV1 rosenbrockXstar)
  rw [rosenbrock_bookHessian_at_xstar]
  exact numericRosenbrockHessian_pd


private theorem rosenbrock_line_hasDerivAt
    (x : EuclideanSpace ℝ (Fin 2)) (i : Fin 2) :
    HasDerivAt (fun s : ℝ => x + s • EuclideanSpace.single i 1)
      (EuclideanSpace.single i 1) 0 := by
  convert ((hasDerivAt_id (0 : ℝ)).smul_const
    (EuclideanSpace.single i 1)).const_add x using 1 <;> simp

private theorem rosenbrock_line_deriv_eq_gradient_component
    (x : EuclideanSpace ℝ (Fin 2)) (i : Fin 2) :
    deriv (fun s : ℝ =>
      rosenbrockObjectiveV1 (x + s • EuclideanSpace.single i 1)) 0 =
      (gradient rosenbrockObjectiveV1 x) i := by
  have hF : HasFDerivAt rosenbrockObjectiveV1
      (fderiv ℝ rosenbrockObjectiveV1 x)
      ((fun s : ℝ => x + s • EuclideanSpace.single i 1) 0) := by
    simpa using (rosenbrock_hasFDerivAt x).differentiableAt.hasFDerivAt
  have hf := hF.comp_hasDerivAt (0 : ℝ)
    (rosenbrock_line_hasDerivAt x i)
  have hderiv : deriv (fun s : ℝ =>
      rosenbrockObjectiveV1 (x + s • EuclideanSpace.single i 1)) 0 =
      (fderiv ℝ rosenbrockObjectiveV1 x) (EuclideanSpace.single i 1) := by
    simpa [Function.comp_def] using hf.deriv
  rw [hderiv]
  have hd := inner_gradient_left
    (rosenbrock_hasFDerivAt x).differentiableAt
    (y := EuclideanSpace.single i 1)
  rw [← hd]
  fin_cases i <;> simp [PiLp.inner_apply, Fin.sum_univ_two,
    EuclideanSpace.single_apply]
  all_goals change (1 : ℝ) * (starRingEnd ℝ) _ = _
  all_goals simp


theorem exercise21HessianV1 : exercise21HessianTargetV1 := by
  intro x
  constructor
  · intro i
    have hF : HasFDerivAt rosenbrockObjectiveV1
        (fderiv ℝ rosenbrockObjectiveV1 x)
        ((fun s : ℝ => x + s • EuclideanSpace.single i 1) 0) := by
      simpa using (rosenbrock_hasFDerivAt x).differentiableAt.hasFDerivAt
    have hd := hF.comp_hasDerivAt (0 : ℝ)
      (rosenbrock_line_hasDerivAt x i)
    simpa [Function.comp_def] using hd.differentiableAt
  · intro i j
    have hgi : DifferentiableAt ℝ
        (fun y : EuclideanSpace ℝ (Fin 2) =>
          (gradient rosenbrockObjectiveV1 y) i) x := by
      fin_cases i
      · exact (rosenbrock_grad0_hasFDerivAt x).differentiableAt
      · exact (rosenbrock_grad1_hasFDerivAt x).differentiableAt
    have hF : HasFDerivAt
        (fun y : EuclideanSpace ℝ (Fin 2) =>
          (gradient rosenbrockObjectiveV1 y) i)
        (fderiv ℝ (fun y : EuclideanSpace ℝ (Fin 2) =>
          (gradient rosenbrockObjectiveV1 y) i) x)
        ((fun t : ℝ => x + t • EuclideanSpace.single j 1) 0) := by
      simpa using hgi.hasFDerivAt
    have hd := hF.comp_hasDerivAt (0 : ℝ)
      (rosenbrock_line_hasDerivAt x j)
    have heq :
        (fun t : ℝ =>
          deriv (fun s : ℝ =>
            rosenbrockObjectiveV1
              ((x + t • EuclideanSpace.single j 1) +
                s • EuclideanSpace.single i 1)) 0) =
        (fun t : ℝ =>
          (gradient rosenbrockObjectiveV1
            (x + t • EuclideanSpace.single j 1)) i) := by
      funext t
      exact rosenbrock_line_deriv_eq_gradient_component
        (x + t • EuclideanSpace.single j 1) i
    have hm := congrArg
      (fun M : Fin 2 → Fin 2 → ℝ => M i j)
      (rosenbrock_bookHessian_eq_formula x)
    change (fderiv ℝ (fun y : EuclideanSpace ℝ (Fin 2) =>
      (gradient rosenbrockObjectiveV1 y) i) x)
      (EuclideanSpace.single j 1) =
      rosenbrockHessianFormulaV1 x i j at hm
    rw [heq]
    convert hd using 1
    exact hm.symm


theorem exercise21FullV1 : exercise21FullTargetV1 := by
  exact ⟨exercise21GradientV1,
    exercise21HessianV1,
    exercise21UniqueLocalMinimizerV1,
    exercise21PositiveHessianV1⟩

end ComputationalMathematics.Source.NocedalWright.Chapter02
