import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.Pi

/-!
# Finite products of real densities

The existing finite-product density theorem, transported from the Higham source
module without changing its declaration, assumptions, or proof.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

/-- A finite product of integrable nonnegative real densities is the density
of the corresponding finite product measure. -/
theorem MeasureTheory.Measure.pi_withDensity_ofReal
    {ι : Type*} [Fintype ι]
    {α : ι → Type*} [∀ i, MeasurableSpace (α i)]
    (μ : ∀ i, Measure (α i)) [∀ i, SigmaFinite (μ i)]
    (f : ∀ i, α i → ℝ)
    (hf : ∀ i, Integrable (f i) (μ i))
    (hf0 : ∀ i x, 0 ≤ f i x) :
    Measure.pi (fun i => (μ i).withDensity (fun x => ENNReal.ofReal (f i x))) =
      (Measure.pi μ).withDensity
        (fun x => ENNReal.ofReal (∏ i, f i (x i))) := by
  refine Measure.pi_eq fun s hs => ?_
  have hrect : MeasurableSet (Set.pi Set.univ s) :=
    MeasurableSet.univ_pi fun i => hs i
  rw [withDensity_apply _ hrect]
  have hprod_nonneg : ∀ x : ∀ i, α i, 0 ≤ ∏ i, f i (x i) := by
    intro x
    exact Finset.prod_nonneg fun i _ => hf0 i (x i)
  have hprod_int : Integrable (fun x : ∀ i, α i => ∏ i, f i (x i))
      (Measure.pi μ) :=
    Integrable.fintype_prod_dep hf
  rw [← ofReal_integral_eq_lintegral_ofReal
    hprod_int.restrict (ae_of_all _ hprod_nonneg)]
  rw [Measure.restrict_pi_pi]
  rw [integral_fintype_prod_eq_prod]
  simp_rw [withDensity_apply _ (hs _)]
  rw [ENNReal.ofReal_prod_of_nonneg
    (fun i _ => integral_nonneg (hf0 i))]
  congr 1
  funext i
  rw [← ofReal_integral_eq_lintegral_ofReal
    (hf i).restrict (ae_of_all _ (hf0 i))]

end
