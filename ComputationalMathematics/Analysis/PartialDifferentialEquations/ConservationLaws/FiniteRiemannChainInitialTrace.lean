/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainGeometry

/-!
# Initial trace and nonuniform reconstruction of finite Riemann chains

The actual finite assembly inherits constituent initial traces and reconstructs exact nonuniform-mesh initial cell states and masses independently of jump representatives.
-/

open MeasureTheory Filter
open scoped Topology
namespace NumStability

/-- The constructed finite field inherits each constituent initial trace. -/
theorem finiteRiemannChainAssembly_tendsto
    {E : Type*} [NormedAddCommGroup E] {ι : Type*} (l : Filter ι)
    (states limits : ℕ → E) (profiles : ℕ → ι → E) (count : ℕ)
    (hprofiles : ∀ j < count, Tendsto (profiles j) l (𝓝 (limits j))) :
    Tendsto (fun t => finiteRiemannChainAssembly states (fun j => profiles j t) count)
      l (𝓝 (finiteRiemannChainAssembly states limits count)) := by
  have hterm : ∀ j ∈ Finset.range count,
      Tendsto (fun t => profiles j t - states j) l (𝓝 (limits j - states j)) :=
    fun j hj => (hprofiles j (Finset.mem_range.mp hj)).sub tendsto_const_nhds
  simpa only [finiteRiemannChainAssembly] using
    tendsto_const_nhds.add (tendsto_finset_sum (Finset.range count) hterm)

/-- Nonuniform ordered interfaces reconstruct the prescribed initial
cell state on its open cell, allowing arbitrary jump values. -/
theorem finiteRiemannChainAssembly_initial_eq_cell_state_of_centers
    {E : Type*} [AddCommGroup E] (states profiles : ℕ → E)
    (centers : ℕ → ℝ) (count cell : ℕ) (x : ℝ)
    (hcell : cell + 1 < count)
    (hcenters : ∀ i j, i < j → j < count → centers i < centers j)
    (hx : x ∈ Set.Ioo (centers cell) (centers (cell + 1)))
    (hleft : ∀ j < count, x < centers j → profiles j = states j)
    (hright : ∀ j < count, centers j < x → profiles j = states (j + 1)) :
    finiteRiemannChainAssembly states profiles count = states (cell + 1) := by
  apply finiteRiemannChainAssembly_eq_state states profiles count (cell + 1) (by omega)
  · intro j hj
    have hc : centers j ≤ centers cell := by
      by_cases heq : j = cell
      · subst j; exact le_rfl
      · exact (hcenters j cell (by omega) (by omega)).le
    exact hright j (by omega) (hc.trans_lt hx.1)
  · intro j hj hjcount
    have hc : centers (cell + 1) ≤ centers j := by
      by_cases heq : j = cell + 1
      · subst j; exact le_rfl
      · exact (hcenters (cell + 1) j (by omega) hjcount).le
    exact hleft j hjcount (hx.2.trans_le hc)

/-- Initial cell mass on a nonuniform mesh is independent of jump values. -/
theorem finiteRiemannChainAssembly_initial_cell_integral_of_centers
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (states : ℕ → E) (profiles : ℕ → ℝ → E) (centers : ℕ → ℝ) (count cell : ℕ)
    (hcell : cell + 1 < count)
    (hcenters : ∀ i j, i < j → j < count → centers i < centers j)
    (hleft : ∀ j < count, ∀ x, x < centers j → profiles j x = states j)
    (hright : ∀ j < count, ∀ x, centers j < x → profiles j x = states (j + 1)) :
    (∫ x in centers cell..centers (cell + 1),
      finiteRiemannChainAssembly states (fun j => profiles j x) count) =
        (centers (cell + 1) - centers cell) • states (cell + 1) := by
  have horder : centers cell < centers (cell + 1) := hcenters cell (cell + 1) (by omega) hcell
  have heq : (∫ x in centers cell..centers (cell + 1),
      finiteRiemannChainAssembly states (fun j => profiles j x) count) =
      ∫ _ in centers cell..centers (cell + 1), states (cell + 1) := by
    apply intervalIntegral.integral_congr_ae
    filter_upwards [volume.ae_ne (centers (cell + 1))] with x hne hx
    have hx' : x ∈ Set.Ioc (centers cell) (centers (cell + 1)) := by
      simpa only [Set.uIoc_of_le horder.le] using hx
    exact finiteRiemannChainAssembly_initial_eq_cell_state_of_centers states
      (fun j => profiles j x) centers count cell x hcell hcenters
      ⟨hx'.1, lt_of_le_of_ne hx'.2 hne⟩
      (fun j hj => hleft j hj x) (fun j hj => hright j hj x)
  rw [heq, intervalIntegral.integral_const]

end NumStability
