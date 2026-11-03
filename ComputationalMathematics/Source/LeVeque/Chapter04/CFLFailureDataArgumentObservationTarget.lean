/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CFLFailureDataArgumentPhysicalTarget

/-!
# Chapter 4: the fixed-observation initial-data obstruction

Proof-free draft. The existing physical approximation, transported reference and
error definitions are used at one shrinking cell. The old window/all-p target is
not a premise or a conjunct. No finite-p-to-point implication is asserted.
-/

namespace NumStability
open Set Filter
open scoped Topology

/-- Proposed fixed-observation realization of the printed-page-70 argument. -/
def Leveque04CFLFailureDataArgumentObservationTarget : Prop :=
  ∀ (F : ℕ → ℕ → ℤ → (Fin 1 → ℝ) → (Fin 1 → ℝ) → (Fin 1 → ℝ) → Fin 1 → ℝ)
    (speed X T ratio : ℝ),
    0 < T → 0 < ratio → 1 < |speed| * ratio →
    let width := fixedRatioRefinementCellWidth T ratio
    let dt := fun n : ℕ => T / ((n + 1 : ℕ) : ℝ)
    let approximation := fun (profile : ℝ → ℝ) (n : ℕ) =>
      leveque04_cflPhysicalApproximation F X T ratio profile n 0
    let reference := fun (profile : ℝ → ℝ) (n : ℕ) =>
      leveque04_cflPhysicalReference speed X T ratio profile n 0
    let error := fun (profile : ℝ → ℝ) (n : ℕ) =>
      leveque04_cflPhysicalError F speed X T ratio profile n 0
    (∀ n, 0 < width n ∧ 0 < dt n ∧ ((n + 1 : ℕ) : ℝ) * dt n = T ∧
      dt n / width n = ratio) ∧
    Tendsto width atTop (𝓝 0) ∧ Tendsto dt atTop (𝓝 0) ∧
    (∃ f g : ℝ → ℝ, Continuous f ∧ Continuous g ∧
      f (X - speed * T) ≠ g (X - speed * T) ∧
      (∀ᶠ n in atTop,
        EqOn f g (Icc (X - ((n + 1 : ℕ) : ℝ) * width n)
          (X + width n + ((n + 1 : ℕ) : ℝ) * width n)) ∧
        approximation f n = approximation g n) ∧
      Tendsto (reference f) atTop (𝓝 (fun _ : Fin 1 => f (X - speed * T))) ∧
      Tendsto (reference g) atTop (𝓝 (fun _ : Fin 1 => g (X - speed * T))) ∧
      ¬ (Tendsto (error f) atTop (𝓝 0) ∧ Tendsto (error g) atTop (𝓝 0))) ∧
    ¬ (∀ profile : ℝ → ℝ, Continuous profile →
      Tendsto (error profile) atTop (𝓝 0))

end NumStability
