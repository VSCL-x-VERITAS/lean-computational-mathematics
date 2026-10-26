/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.Analysis.Normed.Lp.lpSpace
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Data.Finset.Lattice.Fold
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Topology.Order.Basic
import Mathlib.Tactic

/-!
# Physical cell means and error-norm convergence

Positive refining grids and exact fixed-horizon clocks define cell means of
smooth classical hyperbolic references. Consistency and trajectory stability
are measured in actual discrete lp defects and errors; the reference and
numerical arrays need no individual norm membership. A finite executed-step
defect supremum and scalar exponential recurrence estimate supply the error
control mechanism.
-/

namespace NumStability

section
open Filter
open scoped Topology

noncomputable def finiteHorizonDefectSup_s03 (a : ℕ → ℝ) (steps : ℕ) : ℝ := by
  classical
  exact (insert 0 ((Finset.range steps).image a)).sup'
    (by exact ⟨0,Finset.mem_insert_self _ _⟩) id

end

section
open Filter
open scoped Topology

theorem finiteHorizonDefectSup_le_s03 (a : ℕ → ℝ) (steps : ℕ) (ε : ℝ)
    (he : 0 ≤ ε) (ha : ∀ k, k < steps → a k ≤ ε) :
    finiteHorizonDefectSup_s03 a steps ≤ ε := by
  classical
  apply Finset.sup'_le
  intro b hb
  rcases Finset.mem_insert.mp hb with rfl | hb
  · exact he
  · rcases Finset.mem_image.mp hb with ⟨k,hk,rfl⟩
    exact ha k (Finset.mem_range.mp hk)

end

section
open Filter
open scoped Topology

theorem finiteHorizonDefectSup_nonneg_s03 (a : ℕ → ℝ) (steps : ℕ) :
    0 ≤ finiteHorizonDefectSup_s03 a steps := by
  classical
  exact Finset.le_sup' id (Finset.mem_insert_self _ _)

end

section
open Filter
open scoped Topology

theorem le_finiteHorizonDefectSup_s03 (a : ℕ → ℝ) (steps k : ℕ) (hk : k < steps) :
    a k ≤ finiteHorizonDefectSup_s03 a steps := by
  classical
  exact Finset.le_sup' id (Finset.mem_insert_of_mem
    (Finset.mem_image.mpr ⟨k,Finset.mem_range.mpr hk,rfl⟩))

end

section
open Filter
open scoped Topology

theorem finiteHorizonDefectSup_tendsto_zero_s03 (a : ℕ → ℕ → ℝ) (steps : ℕ → ℕ)
    (h : ∀ ε : ℝ, 0 < ε → ∀ᶠ n in atTop, ∀ k, k < steps n → a n k ≤ ε) :
    Tendsto (fun n => finiteHorizonDefectSup_s03 (a n) (steps n)) atTop (𝓝 0) := by
  apply tendsto_order.mpr
  constructor
  · intro b hb
    exact Filter.Eventually.of_forall (fun n => hb.trans_le (finiteHorizonDefectSup_nonneg_s03 _ _))
  · intro b hb
    filter_upwards [h (b/2) (by linarith)] with n hn
    exact (finiteHorizonDefectSup_le_s03 _ _ _ (by linarith) hn).trans_lt (by linarith)

end

section
open Filter
open scoped Topology
open MeasureTheory Filter

noncomputable def physicalLpGridWeight_s03 (p : ENNReal) (width : ℕ → ℝ) (n : ℕ) : ℝ :=
  (width n) ^ (1 / p.toReal)

end

section
open Filter
open scoped Topology
open MeasureTheory Filter

def IsPhysicalCellMeanLpConvergent_s03 {m : ℕ} (p : ENNReal) [Fact (1 ≤ p)]
    (field : ℝ → ℝ → Fin m → ℝ) (origin horizon : ℝ)
    (width dt : ℕ → ℝ) (steps : ℕ → ℕ)
    (approx : ℕ → ℕ → ℤ → Fin m → ℝ) : Prop :=
  0 < horizon ∧ (∀ n, 0 < width n ∧ 0 < dt n ∧ (steps n : ℝ)*dt n = horizon) ∧
  Tendsto width atTop (𝓝 0) ∧ Tendsto dt atTop (𝓝 0) ∧
  (∀ a b, IntervalIntegrable (fun x => field x horizon) volume a b) ∧
  ∃ error : ℕ → lp (fun _ : ℤ => Fin m → ℝ) p,
    (∀ n j, error n j = approx n (steps n) j - oneDimensionalCellAverage
      (fun x => field x horizon)
      (origin+(j : ℝ)*width n) (origin+((j : ℝ)+1)*width n)) ∧
    Tendsto (fun n => physicalLpGridWeight_s03 p width n * ‖error n‖) atTop (𝓝 0)

end

noncomputable section
open Set Filter MeasureTheory
open scoped Topology ENNReal

structure SmoothOriginalEquationCellReferenceS06 {m : ℕ}
    (equation : FirstOrderEquation (Fin m)) (origin horizon : ℝ)
    (width dt : ℕ → ℝ) (steps : ℕ → ℕ) where
  positive_horizon : 0 < horizon
  positive_width : ∀ n, 0 < width n
  positive_dt : ∀ n, 0 < dt n
  clock : ∀ n, (steps n : ℝ)*dt n = horizon
  hyperbolic : equation.IsHyperbolic
  field : ℝ → ℝ → Fin m → ℝ
  original_equation : ∀ x τ, τ ∈ Icc 0 horizon → equation.IsClassicalSolutionAt field x τ
  smooth : ∀ a b, ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry field)
    (Icc a b ×ˢ Icc 0 horizon)
  integrable : ∀ a b τ, τ ∈ Icc 0 horizon →
    IntervalIntegrable (fun x => field x τ) volume a b

end

noncomputable section
open Set Filter MeasureTheory
open scoped Topology ENNReal

def physicalCellReferenceMeansS06 {m : ℕ} {equation : FirstOrderEquation (Fin m)}
    {origin horizon : ℝ} {width dt : ℕ → ℝ} {steps : ℕ → ℕ}
    (reference : SmoothOriginalEquationCellReferenceS06 equation origin horizon width dt steps)
    (n k : ℕ) (j : ℤ) : Fin m → ℝ :=
  oneDimensionalCellAverage
    (fun x => reference.field x ((min k (steps n) : ℕ)*dt n))
    (origin+(j : ℝ)*width n) (origin+((j : ℝ)+1)*width n)

end

noncomputable section
open Set Filter MeasureTheory
open scoped Topology ENNReal

def IsAllSmoothCellMeanErrorConsistentS06 {m : ℕ} (p : ENNReal) [Fact (1 ≤ p)]
    (equation : FirstOrderEquation (Fin m)) (origin horizon : ℝ)
    (width dt : ℕ → ℝ) (steps : ℕ → ℕ)
    (update : ℕ → ℕ → (ℤ → Fin m → ℝ) → (ℤ → Fin m → ℝ)) : Prop :=
  ∀ reference : SmoothOriginalEquationCellReferenceS06 equation origin horizon width dt steps,
    ∃ defect : ℕ → ℕ → lp (fun _ : ℤ => Fin m → ℝ) p,
      (∀ n k, k < steps n → ∀ j, defect n k j =
        update n k (physicalCellReferenceMeansS06 reference n k) j -
          physicalCellReferenceMeansS06 reference n (k+1) j) ∧
      ∀ ε : ℝ, 0 < ε → ∀ᶠ n in atTop, ∀ k, k < steps n →
        physicalLpGridWeight_s03 p width n * ‖defect n k‖ / dt n ≤ ε

end

noncomputable section
open Set Filter MeasureTheory
open scoped Topology ENNReal

def IsCellMeanErrorTrajectoryStableS06 {m : ℕ} (p : ENNReal) [Fact (1 ≤ p)]
    {equation : FirstOrderEquation (Fin m)} {origin horizon : ℝ}
    {width dt : ℕ → ℝ} {steps : ℕ → ℕ}
    (reference : SmoothOriginalEquationCellReferenceS06 equation origin horizon width dt steps)
    (update : ℕ → ℕ → (ℤ → Fin m → ℝ) → (ℤ → Fin m → ℝ))
    (approx : ℕ → ℕ → ℤ → Fin m → ℝ)
    (error : ℕ → ℕ → lp (fun _ : ℤ => Fin m → ℝ) p) : Prop :=
  ∃ growth : ℝ, 0 ≤ growth ∧ ∀ n k, k < steps n →
    ∃ difference : lp (fun _ : ℤ => Fin m → ℝ) p,
      (∀ j, difference j = update n k (approx n k) j -
        update n k (physicalCellReferenceMeansS06 reference n k) j) ∧
      ‖difference‖ ≤ (1+growth*dt n)*‖error n k‖

end

section
open Set Filter MeasureTheory
open scoped Topology ENNReal

theorem finiteHorizon_scalar_recurrence_bound_s06
    (values : ℕ → ℝ) (steps : ℕ) (dt growth initialBound defectRate horizon : ℝ)
    (hdt : 0 ≤ dt) (hgrowth : 0 ≤ growth)
    (hi : 0 ≤ initialBound) (hd : 0 ≤ defectRate)
    (hinit : values 0 ≤ initialBound)
    (hstep : ∀ k < steps,
      values (k+1) ≤ (1+growth*dt)*values k + dt*defectRate)
    (ht : (steps : ℝ)*dt ≤ horizon) :
    values steps ≤ Real.exp (growth*horizon)*(initialBound+horizon*defectRate) := by
  let budget := dt*defectRate
  have hbudget : 0 ≤ budget := mul_nonneg hdt hd
  have hexpInc : 1 ≤ Real.exp (growth*dt) := Real.one_le_exp (mul_nonneg hgrowth hdt)
  have hfactor : 1+growth*dt ≤ Real.exp (growth*dt) := by
    simpa only [add_comm] using Real.add_one_le_exp (growth*dt)
  have hind (n : ℕ) (hn : n ≤ steps) :
      values n ≤ Real.exp ((n : ℝ)*growth*dt)*(initialBound+(n : ℝ)*budget) := by
    induction n with
    | zero => simpa using hinit
    | succ n ih =>
      have h := ih (by omega)
      have hB : 0 ≤ initialBound+(n : ℝ)*budget := by positivity
      have hexpOld : 1 ≤ Real.exp ((n : ℝ)*growth*dt) := Real.one_le_exp (by positivity)
      have hboth : 1 ≤ Real.exp (growth*dt)*Real.exp ((n : ℝ)*growth*dt) := by
        nlinarith [mul_nonneg (sub_nonneg.mpr hexpInc) (sub_nonneg.mpr hexpOld)]
      have heq : Real.exp (growth*dt)*Real.exp ((n : ℝ)*growth*dt) =
          Real.exp (((n+1 : ℕ) : ℝ)*growth*dt) := by
        rw [← Real.exp_add]
        congr 1
        push_cast
        ring
      calc
        _ ≤ (1+growth*dt)*values n+budget := hstep n (by omega)
        _ ≤ (1+growth*dt)*(Real.exp ((n : ℝ)*growth*dt)*
            (initialBound+(n : ℝ)*budget))+budget :=
          add_le_add (mul_le_mul_of_nonneg_left h (by positivity)) le_rfl
        _ ≤ (Real.exp (growth*dt)*Real.exp ((n : ℝ)*growth*dt))*
            (initialBound+(n : ℝ)*budget)+budget := by
          have hm := mul_le_mul_of_nonneg_right hfactor
            (mul_nonneg (Real.exp_pos ((n : ℝ)*growth*dt)).le hB)
          simpa only [mul_assoc] using add_le_add hm (le_refl budget)
        _ ≤ (Real.exp (growth*dt)*Real.exp ((n : ℝ)*growth*dt))*
            (initialBound+(n : ℝ)*budget)+
            (Real.exp (growth*dt)*Real.exp ((n : ℝ)*growth*dt))*budget :=
          add_le_add le_rfl (by simpa only [one_mul] using
            mul_le_mul_of_nonneg_right hboth hbudget)
        _ = _ := by rw [← mul_add,heq];congr 1;push_cast;ring
  have h := hind steps le_rfl
  have hexponent : (steps : ℝ)*growth*dt ≤ growth*horizon := by
    have hh := mul_le_mul_of_nonneg_left ht hgrowth
    nlinarith
  have hsum : initialBound+(steps : ℝ)*budget ≤ initialBound+horizon*defectRate := by
    have hm := mul_le_mul_of_nonneg_right ht hd
    dsimp [budget]
    nlinarith
  exact h.trans (mul_le_mul (Real.exp_le_exp.mpr hexponent) hsum
    (by positivity) (Real.exp_pos _).le)

end

end NumStability
