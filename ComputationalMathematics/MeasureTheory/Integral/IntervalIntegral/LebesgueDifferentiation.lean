/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiationThm
import Mathlib.MeasureTheory.SpecificCodomains.Pi
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Almost-everywhere differentiation of finite-vector interval integrals

Scalar Lebesgue differentiation lifts coordinatewise to finite real vectors.
The exceptional null set is independent of the lower integration endpoint.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

theorem ae_hasDerivAt_intervalIntegral_pi {ι : Type*} [Fintype ι]
    (f : ℝ → ι → ℝ) (hf : ∀ a b, IntervalIntegrable f volume a b) :
    ∀ᵐ t, ∀ c, HasDerivAt (fun s => ∫ r in c..s, f r) (f t) t := by
  have hlocal (i : ι) : LocallyIntegrable (fun t => f t i) volume := by
    intro t
    refine ⟨Ioc (t - 1) (t + 1), Ioc_mem_nhds (by linarith) (by linarith), ?_⟩
    exact (hf (t - 1) (t + 1)).1.eval i
  have hall : ∀ᵐ t, ∀ i, ∀ c,
      HasDerivAt (fun s => ∫ r in c..s, f r i) (f t i) t :=
    ae_all_iff.mpr fun i => LocallyIntegrable.ae_hasDerivAt_integral (hlocal i)
  filter_upwards [hall] with t ht
  intro c
  apply hasDerivAt_pi.mpr
  intro i
  have heq : (fun s => (∫ r in c..s, f r) i) =
      (fun s => ∫ r in c..s, f r i) := by
    funext s
    exact (ContinuousLinearMap.intervalIntegral_comp_comm
      (ContinuousLinearMap.proj (R := ℝ) i) (hf c s)).symm
  rw [heq]
  exact ht i c

end NumStability
