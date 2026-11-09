import ComputationalMathematics.Optimization.Modeling.Basic
import Mathlib.Analysis.Convex.SpecificFunctions.Pow

/-! Mathematical caveat and corrected theorem for square-root shipping costs. -/

open scoped BigOperators

noncomputable section

namespace ComputationalMathematics.Optimization.Modeling

def volumeDiscountObjective (δ : ℝ) (c x : Fin 2 → Fin 12 → ℝ) : ℝ :=
  ∑ i, ∑ j, c i j * Real.sqrt (δ + x i j)

theorem volumeDiscountObjective_zero_cost (δ : ℝ) (x : Fin 2 → Fin 12 → ℝ) :
    volumeDiscountObjective δ (fun _ _ => 0) x = 0 := by
  simp [volumeDiscountObjective]

theorem volumeDiscountObjective_zero_cost_midpoint (δ : ℝ)
    (x y : Fin 2 → Fin 12 → ℝ) :
    volumeDiscountObjective δ (fun _ _ => 0)
        (fun i j => (x i j + y i j) / 2) =
      (volumeDiscountObjective δ (fun _ _ => 0) x +
        volumeDiscountObjective δ (fun _ _ => 0) y) / 2 := by
  simp [volumeDiscountObjective_zero_cost]

private theorem sqrt_midpoint_strict {δ : ℝ} (hδ : 0 < δ) :
    (Real.sqrt δ + Real.sqrt (δ + 2)) / 2 < Real.sqrt (δ + 1) := by
  have h := Real.strictConcaveOn_sqrt.2
    (show δ ∈ Set.Ici (0 : ℝ) by simp; linarith)
    (show δ + 2 ∈ Set.Ici (0 : ℝ) by simp; linarith)
    (show δ ≠ δ + 2 by linarith)
    (show 0 < (1 / 2 : ℝ) by norm_num)
    (show 0 < (1 / 2 : ℝ) by norm_num)
    (show (1 / 2 : ℝ) + 1 / 2 = 1 by norm_num)
  have harg : (1 / 2 : ℝ) • δ + (1 / 2 : ℝ) • (δ + 2) = δ + 1 := by
    simp only [smul_eq_mul]
    ring
  have hval : (1 / 2 : ℝ) • Real.sqrt δ + (1 / 2 : ℝ) • Real.sqrt (δ + 2) =
      (Real.sqrt δ + Real.sqrt (δ + 2)) / 2 := by
    simp only [smul_eq_mul]
    ring
  rw [harg, hval] at h
  exact h

private def routeShift (i₀ : Fin 2) (j₀ : Fin 12) (t : ℝ) :
    Fin 2 → Fin 12 → ℝ :=
  fun i j => if i = i₀ ∧ j = j₀ then t else 0

private theorem objective_routeShift (δ : ℝ) (c : Fin 2 → Fin 12 → ℝ)
    (i₀ : Fin 2) (j₀ : Fin 12) (t : ℝ) :
    volumeDiscountObjective δ c (routeShift i₀ j₀ t) =
      volumeDiscountObjective δ c (fun _ _ => 0) +
        c i₀ j₀ * (Real.sqrt (δ + t) - Real.sqrt δ) := by
  classical
  have hterm (i : Fin 2) (j : Fin 12) :
      c i j * Real.sqrt (δ + routeShift i₀ j₀ t i j) =
        c i j * Real.sqrt δ +
          (if i = i₀ ∧ j = j₀ then
            c i₀ j₀ * (Real.sqrt (δ + t) - Real.sqrt δ) else 0) := by
    by_cases h : i = i₀ ∧ j = j₀
    · rcases h with ⟨rfl, rfl⟩
      simp [routeShift]
      ring
    · simp [routeShift, h]
  calc
    volumeDiscountObjective δ c (routeShift i₀ j₀ t) =
        ∑ i, ∑ j, (c i j * Real.sqrt δ +
          (if i = i₀ ∧ j = j₀ then
            c i₀ j₀ * (Real.sqrt (δ + t) - Real.sqrt δ) else 0)) := by
      unfold volumeDiscountObjective
      apply Finset.sum_congr rfl
      intro i hi
      apply Finset.sum_congr rfl
      intro j hj
      exact hterm i j
    _ = volumeDiscountObjective δ c (fun _ _ => 0) +
          c i₀ j₀ * (Real.sqrt (δ + t) - Real.sqrt δ) := by
      simp [volumeDiscountObjective, Finset.sum_add_distrib, and_comm]
      fin_cases i₀ <;> simp

/-- A nonzero route coefficient makes the square-root shipping objective
nonaffine on the nonnegative shipment orthant. This is the corrected condition
needed for the informal nonlinear classification. -/
theorem volumeDiscountObjective_nonaffine_of_nonzero_cost
    (δ : ℝ) (c : Fin 2 → Fin 12 → ℝ) (hδ : 0 < δ)
    (hc : ∃ i j, c i j ≠ 0) :
    ∃ x y : Fin 2 → Fin 12 → ℝ,
      (∀ i j, 0 ≤ x i j) ∧
      (∀ i j, 0 ≤ y i j) ∧
      volumeDiscountObjective δ c (fun i j => (x i j + y i j) / 2) ≠
        (volumeDiscountObjective δ c x + volumeDiscountObjective δ c y) / 2 := by
  rcases hc with ⟨i₀, j₀, hc⟩
  refine ⟨routeShift i₀ j₀ 0, routeShift i₀ j₀ 2, ?_, ?_, ?_⟩
  · intro i j
    simp [routeShift]
  · intro i j
    by_cases h : i = i₀ ∧ j = j₀ <;> simp [routeShift, h]
  · have hmid :
        (fun i j => (routeShift i₀ j₀ 0 i j + routeShift i₀ j₀ 2 i j) / 2) =
          routeShift i₀ j₀ 1 := by
      funext i j
      by_cases h : i = i₀ ∧ j = j₀ <;> simp [routeShift, h]
    rw [hmid, objective_routeShift, objective_routeShift,
      objective_routeShift]
    simp only [add_zero, sub_self, mul_zero, add_comm, add_zero]
    intro heq
    have hneq : Real.sqrt (δ + 1) - Real.sqrt δ ≠
        (Real.sqrt (δ + 2) - Real.sqrt δ) / 2 := by
      have hs := sqrt_midpoint_strict hδ
      linarith
    apply hneq
    apply mul_left_cancel₀ hc
    nlinarith [heq]

end ComputationalMathematics.Optimization.Modeling
