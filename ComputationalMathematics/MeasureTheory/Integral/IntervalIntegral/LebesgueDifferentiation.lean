/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiationThm
import Mathlib.MeasureTheory.SpecificCodomains.Pi
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Almost-everywhere differentiation of finite-vector interval integrals

Scalar Lebesgue differentiation lifts coordinatewise to finite real vectors,
both locally and on the whole line. The exceptional null set is independent
of the lower integration endpoint within the supplied domain.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

/-- Local finite-vector Lebesgue differentiation on an ordered interval.
No integrability or behavior outside that interval is required. -/
theorem ae_hasDerivAt_intervalIntegral_pi_on {ι : Type*} [Fintype ι]
    (f : ℝ → ι → ℝ) {a b : ℝ} (hab : a ≤ b)
    (hf : IntervalIntegrable f volume a b) :
    ∀ᵐ t, t ∈ Icc a b → ∀ c ∈ Icc a b,
      HasDerivAt (fun s => ∫ r in c..s, f r) (f t) t := by
  have hall : ∀ᵐ t, ∀ i, t ∈ Icc a b → ∀ c ∈ Icc a b,
      HasDerivAt (fun s => ∫ r in c..s, f r i) (f t i) t := by
    apply ae_all_iff.mpr
    intro i
    have hfi : IntervalIntegrable (fun x => f x i) volume a b :=
      ⟨hf.1.eval i, hf.2.eval i⟩
    simpa only [uIcc_of_le hab] using
      hfi.ae_hasDerivAt_integral
  have hleft : ∀ᵐ t : ℝ, t ≠ a := by simp [ae_iff, measure_singleton]
  have hright : ∀ᵐ t : ℝ, t ≠ b := by simp [ae_iff, measure_singleton]
  filter_upwards [hall, hleft, hright] with t ht hta htb
  intro htab c hc
  have hta' : a < t := lt_of_le_of_ne htab.1 (Ne.symm hta)
  have htb' : t < b := lt_of_le_of_ne htab.2 htb
  apply hasDerivAt_pi.mpr
  intro i
  apply (ht i htab c hc).congr_of_eventuallyEq
  filter_upwards [Ioo_mem_nhds hta' htb'] with s hs
  have hcs : IntervalIntegrable f volume c s := hf.mono_set
    (uIcc_subset_uIcc (Icc_subset_uIcc hc) (Icc_subset_uIcc ⟨hs.1.le, hs.2.le⟩))
  exact (ContinuousLinearMap.intervalIntegral_comp_comm
    (ContinuousLinearMap.proj (R := ℝ) i) hcs).symm

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
