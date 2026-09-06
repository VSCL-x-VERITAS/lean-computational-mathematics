import ComputationalMathematics.FloatingPoint.Model

/-! Project identity migration: canonical import API regression. -/

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
