import ComputationalMathematics.FloatingPoint.Model
import NumStability.FloatingPoint.Model
import ComputationalMathematics.Analysis.Stability
import NumStability.Analysis.Stability
import ComputationalMathematics.Analysis.Probability.Gaussian.AbsoluteMoment
import NumStability.Analysis.Probability.Gaussian.AbsoluteMoment
import ComputationalMathematics.Source.Vershynin.Chapter02.Section02.Theorem06
import NumStability.Source.Vershynin.Chapter02.Section02.Theorem06
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation03AdvectedProfile
import NumStability.Source.LeVeque.Chapter01.Equation03AdvectedProfile
import ComputationalMathematics.Analysis.MatrixAlgebra
import NumStability.Analysis.MatrixAlgebra

/-! Mixed old/new imports must share one declaration environment. -/

#check NumStability.FPModel.mk
#check NumStability.FPModel.model_basicOp
#check NumStability.BasicOp.rec
#synth DecidableEq NumStability.BasicOp
#synth Repr NumStability.BasicOp

open NumStability

example (fp : FPModel) (x : ℝ) : fp.fl_add 0 x = x := fp.fl_add_zero x

example (fp : FPModel) (x y : ℝ) (hy : y ≠ 0) :
    ∃ δ : ℝ, |δ| ≤ fp.u ∧ fp.round BasicOp.div x y = (x / y) * (1 + δ) := by
  exact fp.model_basicOp BasicOp.div x y (fun _ => hy)

example (u : ℝ) (hu : 0 ≤ u) : (FPModel.exactWithUnitRoundoff u hu).u = u := rfl

example (u x y : ℝ) (hu : 0 ≤ u) :
    (FPModel.exactWithUnitRoundoff u hu).fl_mul x y = x * y := rfl

example (op : BasicOp) : op = .add ∨ op = .sub ∨ op = .mul ∨ op = .div := by
  cases op <;> simp

#check NumStability.isBackwardStable
#check NumStability.isNumericallyStable
#check NumStability.mixedForwardBackward_of_backward

open NumStability

example (fp : FPModel) (f alg : ℝ → ℝ) (cBack cForw : ℝ)
    (hback : isBackwardStable fp f alg cBack) (hforw : 0 ≤ cForw) :
    isNumericallyStable fp f alg cBack cForw := by
  intro a
  exact mixedForwardBackward_of_backward f a (alg a) (cBack * fp.u)
    (cForw * fp.u) (hback a) (mul_nonneg hforw fp.u_nonneg)

#check NumStability.integral_abs_mul_standardGaussianPDF_eq_sqrt

open MeasureTheory ProbabilityTheory

example : (∫ x : ℝ, |x| * gaussianPDFReal 0 1 x) = Real.sqrt (2 / Real.pi) :=
  NumStability.integral_abs_mul_standardGaussianPDF_eq_sqrt

#check NumStability.HDP.Contract.hdp_02_hthm_h2_d2_d6
#check NumStability.HDP.Contract.hdp_02_hthm_h2_d2_d6__contract_type

example : NumStability.HDP.Contract.hdp_02_hthm_h2_d2_d6__contract_type := by
  exact @NumStability.HDP.Contract.hdp_02_hthm_h2_d2_d6

#check NumStability.leveque01_equation03_advectedProfile

open NumStability

example (profile : ℝ → ℝ) (speed x t : ℝ) :
    travelingWave profile speed (x + speed * t) t = profile x :=
  (leveque01_equation03_advectedProfile profile speed).1 x t

example (profile : ℝ → ℝ) (speed : ℝ) (hp : Differentiable ℝ profile) :
    IsLinearAdvectionSolution (travelingWave profile speed) speed :=
  (leveque01_equation03_advectedProfile profile speed).2 hp

#check NumStability.RMat
#check NumStability.matMul_id_right

open NumStability
open scoped BigOperators Matrix.Norms.Frobenius

#synth Norm (RMat 2 2)

example : ‖(0 : RMat 2 2)‖ = 0 := norm_zero

example (A : Fin 2 → Fin 2 → ℝ) : matMul 2 A (idMatrix 2) = A :=
  matMul_id_right 2 A
