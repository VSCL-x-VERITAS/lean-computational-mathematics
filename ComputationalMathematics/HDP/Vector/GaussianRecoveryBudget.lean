import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Sqrt

/-!
# Eventual recovery budgets

Source-independent convergence of the displayed covariance budget and
exponential confidence term. This module chooses no book sample threshold.
-/

noncomputable section
set_option warningAsError true
open Filter
open scoped Topology

namespace NumStability.HDP.Vector.GaussianMixture

theorem eventually_budget_and_confidence
    (Ccov : ℝ) (n : ℕ) (r epsilon : ℝ)
    (hr : 0 < r) (hepsilon : 0 < epsilon)
    (hideal : 4 * Real.exp (-(r ^ 2) / 64) < epsilon / 2) :
    ∀ᶠ m : ℕ in atTop,
      let L : ℝ := 2 * (r + 1)
      let delta : ℝ := Ccov *
        (Real.sqrt ((n : ℝ) / (m : ℝ)) +
          Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
      let q : ℝ := L ^ 2 * max delta (delta ^ 2)
      (2 * Real.sqrt q) ^ 2 * ((n : ℝ) + r ^ 2 + (n : ℝ) * q) ≤
          epsilon / 2 * (r ^ 2 / 2) ^ 2 ∧
      Real.exp (-2 * (m : ℝ) *
        (epsilon / 2 - 4 * Real.exp (-(r ^ 2) / 64)) ^ 2) ≤
        2 * Real.exp (-(n : ℝ)) := by
  let L : ℝ := 2 * (r + 1)
  let delta : ℕ → ℝ := fun m => Ccov *
    (Real.sqrt ((n : ℝ) / (m : ℝ)) +
      Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
  let q : ℕ → ℝ := fun m => L ^ 2 * max (delta m) ((delta m) ^ 2)
  let gap : ℝ := epsilon / 2 - 4 * Real.exp (-(r ^ 2) / 64)
  have hcast : Tendsto (fun m : ℕ => (m : ℝ)) atTop atTop :=
    tendsto_natCast_atTop_atTop
  have hinv : Tendsto (fun m : ℕ => (m : ℝ)⁻¹) atTop (𝓝 0) :=
    tendsto_inv_atTop_zero.comp hcast
  have hratio : Tendsto (fun m : ℕ => (n : ℝ) / (m : ℝ)) atTop (𝓝 0) := by
    simpa [div_eq_mul_inv] using hinv.const_mul (n : ℝ)
  have hfirst : Tendsto (fun m : ℕ => Real.sqrt ((n : ℝ) / (m : ℝ)))
      atTop (𝓝 0) := by
    simpa only [Function.comp_def, Real.sqrt_zero] using
      (Real.continuous_sqrt.tendsto 0).comp hratio
  have hsqrtinv : Tendsto (fun m : ℕ => (Real.sqrt (m : ℝ))⁻¹)
      atTop (𝓝 0) :=
    tendsto_inv_atTop_zero.comp (Real.tendsto_sqrt_atTop.comp hcast)
  have hsecond : Tendsto (fun m : ℕ => Real.sqrt (n : ℝ) / Real.sqrt (m : ℝ))
      atTop (𝓝 0) := by
    simpa [div_eq_mul_inv] using hsqrtinv.const_mul (Real.sqrt (n : ℝ))
  have hdelta : Tendsto delta atTop (𝓝 0) := by
    simpa [delta] using (hfirst.add hsecond).const_mul Ccov
  have hq : Tendsto q atTop (𝓝 0) := by
    simpa [q] using (hdelta.max (hdelta.pow 2)).const_mul (L ^ 2)
  have hbudget : Tendsto (fun m : ℕ =>
      (2 * Real.sqrt (q m)) ^ 2 * ((n : ℝ) + r ^ 2 + (n : ℝ) * q m))
      atTop (𝓝 0) := by
    have hs := (((Real.continuous_sqrt.tendsto 0).comp hq).const_mul 2).pow 2
    have hbase : Tendsto (fun _ : ℕ => (n : ℝ) + r ^ 2)
        atTop (𝓝 ((n : ℝ) + r ^ 2)) := tendsto_const_nhds
    have hf := hbase.add (hq.const_mul (n : ℝ))
    simpa using hs.mul hf
  have hright : 0 < epsilon / 2 * (r ^ 2 / 2) ^ 2 := by positivity
  have hgap : 0 < gap := sub_pos.mpr hideal
  have hcoefficient : -2 * gap ^ 2 < 0 := by
    have hsq : 0 < gap ^ 2 := sq_pos_of_pos hgap
    nlinarith
  have hconfidence : Tendsto (fun m : ℕ => Real.exp (-2 * (m : ℝ) * gap ^ 2))
      atTop (𝓝 0) := by
    simpa only [mul_assoc, mul_comm, mul_left_comm] using
      Real.tendsto_exp_atBot.comp (hcast.const_mul_atTop_of_neg hcoefficient)
  have hbudgetEventually := hbudget.eventually_lt_const hright
  have hconfidenceEventually := hconfidence.eventually_lt_const
    (by positivity : 0 < 2 * Real.exp (-(n : ℝ)))
  filter_upwards [hbudgetEventually, hconfidenceEventually] with m hmBudget hmConfidence
  simpa [q, delta, L, gap] using And.intro hmBudget.le hmConfidence.le


end NumStability.HDP.Vector.GaussianMixture
