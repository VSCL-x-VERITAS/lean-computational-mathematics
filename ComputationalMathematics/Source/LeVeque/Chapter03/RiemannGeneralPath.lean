/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannFigure33

/-!
# The ordered state-space path of an m-family Riemann problem

Printed page 56/raw PDF page 78. Partial sums of the existing wave vectors
give a path from the left state to the right state. Its straight segments
follow the eigenvectors in increasing characteristic-speed order.
-/

namespace NumStability

/-- The vertex after the first `k` wave vectors have been added. -/
noncomputable def leveque03_riemannStatePath
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) (k : ℕ) : Fin m → ℝ :=
  left + ∑ i ∈ Finset.range k,
    if hi : i < m then leveque03_riemannWave eigenbasis left right ⟨i, hi⟩ else 0

/-- The path begins at the left Riemann state. -/
theorem leveque03_riemannStatePath_start
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) :
    leveque03_riemannStatePath eigenbasis left right 0 = left := by
  simp [leveque03_riemannStatePath]

/-- The next vertex adds precisely the `k`th wave vector. -/
theorem leveque03_riemannStatePath_step
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) (k : ℕ) (hk : k < m) :
    leveque03_riemannStatePath eigenbasis left right (k + 1) =
      leveque03_riemannStatePath eigenbasis left right k +
        leveque03_riemannWave eigenbasis left right ⟨k, hk⟩ := by
  simp [leveque03_riemannStatePath, Finset.sum_range_succ, hk, add_assoc]

/-- After all `m` wave vectors the path reaches the right state. -/
theorem leveque03_riemannStatePath_end
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) :
    leveque03_riemannStatePath eigenbasis left right m = right := by
  change left +
    (∑ i ∈ Finset.range m,
      if hi : i < m then leveque03_riemannWave eigenbasis left right ⟨i, hi⟩ else 0) = right
  rw [← Finset.sum_fin_eq_sum_range]
  have h := leveque03_sumRiemannWaves eigenbasis left right
  rw [h]
  abel

/-- Each affine segment follows the corresponding eigenvector line. -/
theorem leveque03_riemannStatePath_segment
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (left right : Fin m → ℝ) (k : Fin m) (τ : ℝ) :
    AffineMap.lineMap
      (leveque03_riemannStatePath eigenbasis left right k.val)
      (leveque03_riemannStatePath eigenbasis left right (k.val + 1)) τ =
    leveque03_riemannStatePath eigenbasis left right k.val +
      (τ * leveque03_waveStrength eigenbasis left right k) • eigenbasis k := by
  rw [AffineMap.lineMap_apply_module',
    leveque03_riemannStatePath_step eigenbasis left right k.val k.isLt]
  simp only [add_sub_cancel_left, leveque03_riemannWave, smul_smul]
  rw [add_comm]

/-- The m-dimensional piecewise-linear path described on page 56. -/
theorem leveque03_riemannStatePath_ordered
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (hordered : StrictMono speeds)
    (left right : Fin m → ℝ) :
    leveque03_riemannStatePath eigenbasis left right 0 = left ∧
    leveque03_riemannStatePath eigenbasis left right m = right ∧
    (∀ k : Fin m,
      leveque03_riemannStatePath eigenbasis left right (k.val + 1) =
        leveque03_riemannStatePath eigenbasis left right k.val +
          leveque03_riemannWave eigenbasis left right k) ∧
    (∀ i j : Fin m, i < j → speeds i < speeds j) ∧
    (∀ k : Fin m, ∀ τ : ℝ,
      AffineMap.lineMap
        (leveque03_riemannStatePath eigenbasis left right k.val)
        (leveque03_riemannStatePath eigenbasis left right (k.val + 1)) τ =
      leveque03_riemannStatePath eigenbasis left right k.val +
        (τ * leveque03_waveStrength eigenbasis left right k) • eigenbasis k) := by
  refine ⟨leveque03_riemannStatePath_start eigenbasis left right,
    leveque03_riemannStatePath_end eigenbasis left right, ?_, ?_, ?_⟩
  · intro k
    exact leveque03_riemannStatePath_step eigenbasis left right k.val k.isLt
  · intro i j hij
    exact hordered hij
  · intro k τ
    exact leveque03_riemannStatePath_segment eigenbasis left right k τ

end NumStability
