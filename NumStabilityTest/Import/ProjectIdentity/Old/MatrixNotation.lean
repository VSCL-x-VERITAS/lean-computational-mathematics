import NumStability.Analysis.MatrixAlgebra

/-! Project identity migration: old import API regression. -/

#check NumStability.RMat
#check NumStability.matMul_id_right

open NumStability
open scoped BigOperators Matrix.Norms.Frobenius

#synth Norm (RMat 2 2)

example : ‖(0 : RMat 2 2)‖ = 0 := norm_zero

example (A : Fin 2 → Fin 2 → ℝ) : matMul 2 A (idMatrix 2) = A :=
  matMul_id_right 2 A
