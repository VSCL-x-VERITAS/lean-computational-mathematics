import Mathlib.Topology.Algebra.InfiniteSum.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Topology.Algebra.Ring.Real

/-!
# Globally convergent real power series

The coefficient-level interface used by tensor-power feature maps for analytic
kernels.
-/

noncomputable section

open scoped Topology

namespace NumStability.HDP.Tensor

/-- A real function is represented by coefficients `a` as a power series
converging at every real input. -/
def GloballyConvergentPowerSeries (f : ℝ → ℝ) (a : ℕ → ℝ) : Prop :=
  ∀ x : ℝ, HasSum (fun k : ℕ => a k * x ^ k) (f x)

/-- A globally convergent real power-series representation with nonnegative
coefficients. -/
def HasNonnegativeGlobalPowerSeries (f : ℝ → ℝ) : Prop :=
  ∃ a : ℕ → ℝ, (∀ k, 0 ≤ a k) ∧ GloballyConvergentPowerSeries f a

theorem GloballyConvergentPowerSeries.eq_tsum {f : ℝ → ℝ} {a : ℕ → ℝ}
    (h : GloballyConvergentPowerSeries f a) (x : ℝ) :
    f x = ∑' k : ℕ, a k * x ^ k :=
  (h x).tsum_eq.symm

theorem GloballyConvergentPowerSeries.summable {f : ℝ → ℝ} {a : ℕ → ℝ}
    (h : GloballyConvergentPowerSeries f a) (x : ℝ) :
    Summable (fun k : ℕ => a k * x ^ k) :=
  (h x).summable

end NumStability.HDP.Tensor
