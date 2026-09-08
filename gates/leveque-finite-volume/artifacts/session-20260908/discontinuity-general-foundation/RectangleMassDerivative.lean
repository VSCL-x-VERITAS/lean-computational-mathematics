import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import Mathlib.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiationThm
import Mathlib.MeasureTheory.SpecificCodomains.Pi
import Mathlib.Analysis.Calculus.Deriv.Prod

/-! Provisional general foundation: rectangle balance yields the mass-rate
identity almost everywhere in time, for every fixed spatial interval and any
finite-dimensional real state. No source interpretation is asserted here. -/

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

theorem IsRectangleConservationLawSolution.hasDerivAt_mass_ae
    {ι : Type*} [Fintype ι] {q : ℝ → ℝ → ι → ℝ}
    {flux : (ι → ℝ) → ι → ℝ}
    (h : IsRectangleConservationLawSolution q flux) (a b : ℝ) :
    ∀ᵐ t, HasDerivAt (fun s => ∫ x in a..b, q x s)
      (flux (q a t) - flux (q b t)) t := by
  have hflux (s t : ℝ) :
      IntervalIntegrable (fun r => flux (q a r) - flux (q b r)) volume s t :=
    (h.2.1 a s t).sub (h.2.1 b s t)
  filter_upwards [ae_hasDerivAt_intervalIntegral_pi _ hflux] with t ht
  have heq : (fun s => ∫ x in a..b, q x s) =
      (fun s => (∫ r in (0 : ℝ)..s, flux (q a r) - flux (q b r)) +
        (∫ x in a..b, q x 0)) := by
    funext s
    exact sub_eq_iff_eq_add.mp (h.2.2 a b 0 s)
  rw [heq]
  exact (ht 0).add_const _

end NumStability

#check NumStability.ae_hasDerivAt_intervalIntegral_pi
#print axioms NumStability.ae_hasDerivAt_intervalIntegral_pi
#check NumStability.IsRectangleConservationLawSolution.hasDerivAt_mass_ae
#print axioms NumStability.IsRectangleConservationLawSolution.hasDerivAt_mass_ae
