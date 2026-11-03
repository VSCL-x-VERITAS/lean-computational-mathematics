/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionMissedConeWindow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteWindowLpError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv

/-!
# Fixed physical initial data when a characteristic misses the numerical cone

The whole printed-page-70 data-change argument is realized with actual physical
cell averages and a fixed positive-width observation band. A fixed smooth cutoff
and zero are chosen before refinement and before the error norm exponent.
The old point-observation specialization remains in `CFLFailureDataArgument`.
-/

namespace NumStability
open Set Filter
open scoped Topology ENNReal

/-- Actual finite three-state evolution from the physical initial cell means. -/
noncomputable def leveque04_cflPhysicalApproximation
    (F : ℕ → ℕ → ℤ → (Fin 1 → ℝ) → (Fin 1 → ℝ) → (Fin 1 → ℝ) → Fin 1 → ℝ)
    (origin T ratio : ℝ) (profile : ℝ → ℝ) (n : ℕ) (j : ℤ) : Fin 1 → ℝ :=
  let h := fixedRatioRefinementCellWidth T ratio n
  centeredStencilEvolution
    (fun k old i => F n k i (old (i - 1)) (old i) (old (i + 1)))
    (fun i => oneDimensionalCellAverage (fun x (_ : Fin 1) => profile x)
      (origin + (i : ℝ) * h) (origin + ((i : ℝ) + 1) * h)) (n + 1) j

/-- The true transported reference, using the same physical cell integrals. -/
noncomputable def leveque04_cflPhysicalReference
    (speed origin T ratio : ℝ) (profile : ℝ → ℝ) (n : ℕ) (j : ℤ) : Fin 1 → ℝ :=
  let h := fixedRatioRefinementCellWidth T ratio n
  oneDimensionalCellAverage (fun x (_ : Fin 1) => travelingWave profile speed x T)
    (origin + (j : ℝ) * h) (origin + ((j : ℝ) + 1) * h)

/-- The actual error array; no global norm membership is implicit. -/
noncomputable def leveque04_cflPhysicalError
    (F : ℕ → ℕ → ℤ → (Fin 1 → ℝ) → (Fin 1 → ℝ) → (Fin 1 → ℝ) → Fin 1 → ℝ)
    (speed origin T ratio : ℝ) (profile : ℝ → ℝ) (n : ℕ) (j : ℤ) : Fin 1 → ℝ :=
  leveque04_cflPhysicalApproximation F origin T ratio profile n j -
    leveque04_cflPhysicalReference speed origin T ratio profile n j

/-- Exact finite-window errors are meaningful even for unrestricted coarse grids. -/
def Leveque04CFLFailureDataArgumentPhysicalTarget : Prop :=
  ∀ (F : ℕ → ℕ → ℤ → (Fin 1 → ℝ) → (Fin 1 → ℝ) → (Fin 1 → ℝ) → Fin 1 → ℝ)
    (speed origin T ratio : ℝ),
    0 < T → 0 < ratio → 1 < |speed| * ratio →
    let width := fixedRatioRefinementCellWidth T ratio
    let dt := fun n : ℕ => T / ((n + 1 : ℕ) : ℝ)
    let gap := |speed| * T - T / ratio
    let window := fun n => translatedMeshWindow
      (origin - gap / 16) (origin + gap / 16) origin (width n)
    (∀ n, 0 < width n ∧ 0 < dt n ∧ ((n + 1 : ℕ) : ℝ) * dt n = T ∧
      dt n / width n = ratio) ∧
    Tendsto width atTop (𝓝 0) ∧ Tendsto dt atTop (𝓝 0) ∧
    ∃ cutoff : ContDiffBump (origin - speed * T),
      cutoff.rIn = gap / 4 ∧ cutoff.rOut = gap / 2 ∧
      ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (cutoff : ℝ → ℝ) ∧
      HasCompactSupport (cutoff : ℝ → ℝ) ∧
      (∀ x, 0 ≤ cutoff x ∧ cutoff x ≤ 1) ∧ cutoff (origin - speed * T) = 1 ∧
      (∀ᶠ n in atTop, ∀ j ∈ window n,
        EqOn (fun _ : ℝ => (0 : ℝ)) (cutoff : ℝ → ℝ)
          (Icc (origin + (j : ℝ) * width n - ((n + 1 : ℕ) : ℝ) * width n)
            (origin + ((j : ℝ) + 1) * width n + ((n + 1 : ℕ) : ℝ) * width n)) ∧
        leveque04_cflPhysicalApproximation F origin T ratio (fun _ => 0) n j =
          leveque04_cflPhysicalApproximation F origin T ratio cutoff n j ∧
        leveque04_cflPhysicalReference speed origin T ratio (fun _ => 0) n j = 0 ∧
        leveque04_cflPhysicalReference speed origin T ratio cutoff n j =
          (fun _ : Fin 1 => (1 : ℝ))) ∧
      (∀ᶠ n in atTop, gap / 16 ≤ width n * ((window n).card : ℝ)) ∧
      ∀ (p : ENNReal) [Fact (1 ≤ p)],
        let error0 := leveque04_cflPhysicalError F speed origin T ratio (fun _ => 0)
        let error1 := leveque04_cflPhysicalError F speed origin T ratio cutoff
        (¬ (Tendsto (fun n => physicalLpGridWeight_s03 p width n *
              ‖finiteWindowLp p (window n) (error0 n)‖) atTop (𝓝 0) ∧
            Tendsto (fun n => physicalLpGridWeight_s03 p width n *
              ‖finiteWindowLp p (window n) (error1 n)‖) atTop (𝓝 0))) ∧
        ¬ ((∃ e0 : ℕ → lp (fun _ : ℤ => Fin 1 → ℝ) p,
              (∀ᶠ n in atTop, ∀ j, e0 n j = error0 n j) ∧
              Tendsto (fun n => physicalLpGridWeight_s03 p width n * ‖e0 n‖)
                atTop (𝓝 0)) ∧
           (∃ e1 : ℕ → lp (fun _ : ℤ => Fin 1 → ℝ) p,
              (∀ᶠ n in atTop, ∀ j, e1 n j = error1 n j) ∧
              Tendsto (fun n => physicalLpGridWeight_s03 p width n * ‖e1 n‖)
                atTop (𝓝 0)))

end NumStability
