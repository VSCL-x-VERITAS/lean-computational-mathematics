import Mathlib.LinearAlgebra.Matrix.Diagonal
import Mathlib.LinearAlgebra.Matrix.Hermitian
import Mathlib.Tactic

/-!
# Signed eigenvalue order and absolute values

A two-dimensional symmetric matrix has a decreasing signed eigenvalue list
whose absolute values fail to decrease with the same indices.
-/

noncomputable section

namespace NumStability.HDP.Matrix

/-- A real symmetric diagonal matrix has an orthonormal eigenbasis with
decreasing signed eigenvalues, whose absolute values cannot form any decreasing
list with the same indices. -/
theorem exists_symmetric_signed_ordering_absolute_value_obstruction :
    ∃ eigenvalues : Fin 2 → ℝ,
    ∃ eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ),
      eigenbasis = Pi.basisFun ℝ (Fin 2) ∧
      Antitone eigenvalues ∧
      (Matrix.diagonal eigenvalues).IsHermitian ∧
      (∀ i, (Matrix.diagonal eigenvalues).mulVec (eigenbasis i) =
        eigenvalues i • eigenbasis i) ∧
      (∀ i j, (∑ k : Fin 2, eigenbasis i k * eigenbasis j k) =
        if i = j then (1 : ℝ) else 0) ∧
      ¬ Antitone (fun i ↦ |eigenvalues i|) ∧
      ∀ decreasingValues : Fin 2 → ℝ, Antitone decreasingValues →
        ¬ (∀ i, decreasingValues i = |eigenvalues i|) := by
  let eigenvalues : Fin 2 → ℝ := ![1, -2]
  let eigenbasis := Pi.basisFun ℝ (Fin 2)
  have habsolute : ¬ Antitone (fun i ↦ |eigenvalues i|) := by
    intro h
    have h01 := h (show (0 : Fin 2) ≤ 1 by decide)
    norm_num [eigenvalues] at h01
  refine ⟨eigenvalues, eigenbasis, rfl, ?_,
    Matrix.isHermitian_diagonal eigenvalues, ?_, ?_, habsolute, ?_⟩
  · intro i j hij
    fin_cases i <;> fin_cases j <;> norm_num [eigenvalues] at *
  · intro i
    simpa [eigenbasis, Pi.basisFun_apply] using
      (Matrix.diagonal_mulVec_single eigenvalues i (1 : ℝ)).trans
        (Pi.single_smul' i (eigenvalues i) (1 : ℝ))
  · intro i j
    fin_cases i <;> fin_cases j <;>
      norm_num [eigenbasis, Pi.basisFun_apply, Fin.sum_univ_two, Pi.single_apply]
  · intro decreasingValues hdecreasing hequal
    apply habsolute
    intro i j hij
    change |eigenvalues j| ≤ |eigenvalues i|
    rw [← hequal i, ← hequal j]
    exact hdecreasing hij

end NumStability.HDP.Matrix
