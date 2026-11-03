/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCellMeanErrorConvergence

/-!
# Convergence from consistent, stable physical cell-mean errors

The defect, trajectory error and convergence use the same discrete norm and
physical weight. The numerical arrays execute the prescribed update; their
errors are actual differences from the same equation's reference cell means.
No pointwise convergence is inferred from a finite-p norm.
-/

namespace NumStability

open Set Filter MeasureTheory
open scoped Topology ENNReal

/-- Uniform executed-step consistency for this prescribed equation reference.
An application can require this for its admitted data class without requiring
finite global norm defects for unrelated unbounded smooth solutions. -/
def IsCellMeanReferenceErrorConsistentS06
    {m : ℕ} (p : ENNReal) [Fact (1 ≤ p)]
    {equation : FirstOrderEquation (Fin m)} {origin horizon : ℝ}
    {width dt : ℕ → ℝ} {steps : ℕ → ℕ}
    (reference : SmoothOriginalEquationCellReferenceS06 equation origin horizon width dt steps)
    (update : ℕ → ℕ → (ℤ → Fin m → ℝ) → (ℤ → Fin m → ℝ)) : Prop :=
  ∃ defect : ℕ → ℕ → lp (fun _ : ℤ => Fin m → ℝ) p,
    (∀ n k, k < steps n → ∀ j, defect n k j =
      update n k (physicalCellReferenceMeansS06 reference n k) j -
        physicalCellReferenceMeansS06 reference n (k + 1) j) ∧
    ∀ ε : ℝ, 0 < ε → ∀ᶠ n in atTop, ∀ k, k < steps n →
      physicalLpGridWeight_s03 p width n * ‖defect n k‖ / dt n ≤ ε

/-- Norm convergence transfers to a prescribed observable only when an actual
uniform error bound and compatibility of the reference observations are given.
In particular this supplies no unqualified finite-p-to-pointwise implication. -/
theorem observable_tendsto_of_norm_error
    {V : Type*} [NormedAddCommGroup V]
    (observed referenceObserved : ℕ → V) (exact : V)
    (errorSize : ℕ → ℝ) (amplification : ℝ)
    (hcontrol : ∀ n, ‖observed n - referenceObserved n‖ ≤ amplification * errorSize n)
    (herror : Tendsto errorSize atTop (𝓝 0))
    (hreference : Tendsto referenceObserved atTop (𝓝 exact)) :
    Tendsto observed atTop (𝓝 exact) := by
  have hnorm : Tendsto (fun n => ‖observed n - referenceObserved n‖) atTop (𝓝 0) := by
    apply squeeze_zero' (Eventually.of_forall (fun n => norm_nonneg _))
      (Eventually.of_forall hcontrol)
    simpa using herror.const_mul amplification
  have hdifference : Tendsto (fun n => observed n - referenceObserved n) atTop (𝓝 0) :=
    tendsto_zero_iff_norm_tendsto_zero.mpr hnorm
  simpa only [sub_add_cancel, zero_add] using hdifference.add hreference

theorem finiteHorizon_error_tendsto_zero
    (values : ℕ → ℕ → ℝ) (steps : ℕ → ℕ) (dt rate : ℕ → ℝ)
    (growth horizon : ℝ)
    (hdt : ∀ n, 0 ≤ dt n) (hgrowth : 0 ≤ growth)
    (hvalues : ∀ n k, 0 ≤ values n k) (hrate : ∀ n, 0 ≤ rate n)
    (hstep : ∀ n k, k < steps n →
      values n (k + 1) ≤ (1 + growth * dt n) * values n k + dt n * rate n)
    (hclock : ∀ n, (steps n : ℝ) * dt n ≤ horizon)
    (hinitial : Tendsto (fun n => values n 0) atTop (𝓝 0))
    (hconsistency : Tendsto rate atTop (𝓝 0)) :
    Tendsto (fun n => values n (steps n)) atTop (𝓝 0) := by
  have hupper (n : ℕ) : values n (steps n) ≤
      Real.exp (growth * horizon) * (values n 0 + horizon * rate n) :=
    finiteHorizon_scalar_recurrence_bound_s06 (values n) (steps n)
      (dt n) growth (values n 0) (rate n) horizon
      (hdt n) hgrowth (hvalues n 0) (hrate n) le_rfl (hstep n) (hclock n)
  apply squeeze_zero' (Eventually.of_forall (fun n => hvalues n (steps n)))
    (Eventually.of_forall hupper)
  simpa using (hinitial.add (hconsistency.const_mul horizon)).const_mul
    (Real.exp (growth * horizon))

theorem cellMean_trajectoryStability_consistency_convergence_s06
    {m : ℕ} (p : ENNReal) [Fact (1 ≤ p)]
    {equation : FirstOrderEquation (Fin m)} {origin horizon : ℝ}
    {width dt : ℕ → ℝ} {steps : ℕ → ℕ}
    (reference : SmoothOriginalEquationCellReferenceS06 equation origin horizon width dt steps)
    (update : ℕ → ℕ → (ℤ → Fin m → ℝ) → (ℤ → Fin m → ℝ))
    (approx : ℕ → ℕ → ℤ → Fin m → ℝ)
    (error : ℕ → ℕ → lp (fun _ : ℤ => Fin m → ℝ) p)
    (hwidth : Tendsto width atTop (𝓝 0)) (hdt : Tendsto dt atTop (𝓝 0))
    (herror : ∀ n k, k ≤ steps n → ∀ j,
      error n k j = approx n k j - physicalCellReferenceMeansS06 reference n k j)
    (hexecute : ∀ n k, k < steps n →
      approx n (k + 1) = update n k (approx n k))
    (hconsistent : IsCellMeanReferenceErrorConsistentS06 p reference update)
    (hstable : IsCellMeanErrorTrajectoryStableS06 p reference update approx error)
    (hinitial : Tendsto
      (fun n => physicalLpGridWeight_s03 p width n * ‖error n 0‖) atTop (𝓝 0)) :
    IsPhysicalCellMeanLpConvergent_s03 p reference.field origin horizon width dt steps approx := by
  obtain ⟨defect, hdefect, hconsistency⟩ := hconsistent
  obtain ⟨growth, hgrowth, hstable⟩ := hstable
  let weight : ℕ → ℝ := physicalLpGridWeight_s03 p width
  let rate : ℕ → ℝ := fun n => finiteHorizonDefectSup_s03
    (fun k => weight n * ‖defect n k‖ / dt n) (steps n)
  let values : ℕ → ℕ → ℝ := fun n k => weight n * ‖error n k‖
  have hweight (n : ℕ) : 0 ≤ weight n := by
    exact (Real.rpow_pos_of_pos (reference.positive_width n) _).le
  have hvalues (n k : ℕ) : 0 ≤ values n k := mul_nonneg (hweight n) (norm_nonneg _)
  have hrate (n : ℕ) : 0 ≤ rate n := finiteHorizonDefectSup_nonneg_s03 _ _
  have hratelimit : Tendsto rate atTop (𝓝 0) :=
    finiteHorizonDefectSup_tendsto_zero_s03 _ steps hconsistency
  have hrecurrence (n k : ℕ) (hk : k < steps n) :
      values n (k + 1) ≤ (1 + growth * dt n) * values n k + dt n * rate n := by
    obtain ⟨difference, hdifference, hbound⟩ := hstable n k hk
    have heq : error n (k + 1) = difference + defect n k := by
      apply lp.ext
      funext j
      change error n (k + 1) j = difference j + defect n k j
      rw [herror n (k + 1) (by omega) j, hexecute n k hk,
        hdifference j, hdefect n k hk j]
      abel
    have htriangle : ‖error n (k + 1)‖ ≤
        (1 + growth * dt n) * ‖error n k‖ + ‖defect n k‖ := by
      rw [heq]
      exact (norm_add_le _ _).trans (add_le_add hbound le_rfl)
    have hlocalRate : weight n * ‖defect n k‖ ≤ dt n * rate n := by
      have h := le_finiteHorizonDefectSup_s03
        (fun j => weight n * ‖defect n j‖ / dt n) (steps n) k hk
      have hmul := (div_le_iff₀ (reference.positive_dt n)).mp h
      simpa only [mul_comm] using hmul
    calc
      values n (k + 1) ≤ weight n *
          ((1 + growth * dt n) * ‖error n k‖ + ‖defect n k‖) :=
        mul_le_mul_of_nonneg_left htriangle (hweight n)
      _ = (1 + growth * dt n) * values n k + weight n * ‖defect n k‖ := by
        dsimp [values]
        ring
      _ ≤ (1 + growth * dt n) * values n k + dt n * rate n :=
        add_le_add le_rfl hlocalRate
  have hfinal := finiteHorizon_error_tendsto_zero values steps dt rate growth horizon
    (fun n => (reference.positive_dt n).le) hgrowth hvalues hrate hrecurrence
    (fun n => (reference.clock n).le) hinitial hratelimit
  refine ⟨reference.positive_horizon, ?_, hwidth, hdt, ?_, ?_⟩
  · intro n
    exact ⟨reference.positive_width n, reference.positive_dt n, reference.clock n⟩
  · intro a b
    exact reference.integrable a b horizon ⟨reference.positive_horizon.le, le_rfl⟩
  · refine ⟨(fun n => error n (steps n)), ?_, hfinal⟩
    intro n j
    simpa only [physicalCellReferenceMeansS06, min_self, reference.clock n] using
      herror n (steps n) le_rfl j

end NumStability
