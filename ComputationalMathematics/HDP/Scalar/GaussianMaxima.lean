import ComputationalMathematics.HDP.Scalar.GaussianTails
import Mathlib.Probability.Independence.Basic

/-!
# Finite maxima and independent Gaussian samples

This file provides the reusable finite-maximum and exact product-event
infrastructure needed for lower bounds on maxima of independent Gaussian
variables.  The asymptotic Gaussian estimate is developed separately from
these order- and independence-theoretic foundations.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Scalar.GaussianMaxima

open NumStability.HDP.Scalar.LimitTheorems

/-- The pointwise maximum of a nonempty finite family of real functions. -/
def finiteMaximum {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) : Ω → ℝ :=
  Finset.univ.sup' Finset.univ_nonempty X

/-- Every coordinate is bounded by the finite maximum. -/
lemma le_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (i : ι) (ω : Ω) :
    X i ω ≤ finiteMaximum X ω := by
  rw [finiteMaximum, Finset.sup'_apply]
  exact Finset.le_sup' (fun j => X j ω) (Finset.mem_univ i)

/-- A pointwise criterion for bounding a finite maximum from above. -/
lemma finiteMaximum_le
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) (a : ℝ)
    (h : ∀ i, X i ω ≤ a) :
    finiteMaximum X ω ≤ a := by
  rw [finiteMaximum, Finset.sup'_apply]
  exact Finset.sup'_le Finset.univ_nonempty _ (fun i _ => h i)

/-- The maximum of a finite family of measurable real functions is
measurable. -/
lemma measurable_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {X : ι → Ω → ℝ} (hX : ∀ i, Measurable (X i)) :
    Measurable (finiteMaximum X) := by
  unfold finiteMaximum
  exact Finset.measurable_sup' Finset.univ_nonempty (fun i _ => hX i)

/-- The maximum of a finite family of integrable real functions is
integrable. -/
lemma integrable_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hX : ∀ i, Integrable (X i) μ) :
    Integrable (finiteMaximum X) μ := by
  unfold finiteMaximum
  exact Finset.sup'_induction Finset.univ_nonempty X
    (p := fun f : Ω → ℝ => Integrable f μ)
    (fun _ hf _ hg => Integrable.sup hf hg) (fun i _ => hX i)

/-- A finite maximum is bounded above by the sum of the coordinate absolute
values. -/
lemma finiteMaximum_le_sum_abs
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) :
    finiteMaximum X ω ≤ ∑ i, |X i ω| := by
  rw [finiteMaximum, Finset.sup'_apply]
  apply Finset.sup'_le
  intro i hi
  calc
    X i ω ≤ |X i ω| := le_abs_self _
    _ ≤ ∑ j, |X j ω| := Finset.single_le_sum
      (s := Finset.univ) (f := fun j => |X j ω|)
      (fun _ _ => abs_nonneg _) hi

/-- The negative sum of the coordinate absolute values is a lower bound for
the finite maximum. -/
lemma neg_sum_abs_le_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) :
    -(∑ i, |X i ω|) ≤ finiteMaximum X ω := by
  let i : ι := Classical.choice inferInstance
  calc
    -(∑ j, |X j ω|) ≤ -|X i ω| := by
      exact neg_le_neg (Finset.single_le_sum
        (s := Finset.univ) (f := fun j => |X j ω|)
        (fun _ _ => abs_nonneg _) (Finset.mem_univ i))
    _ ≤ X i ω := neg_abs_le _
    _ ≤ finiteMaximum X ω := le_finiteMaximum X i ω

/-- Two-sided absolute-value control for the finite maximum. -/
lemma abs_finiteMaximum_le_sum_abs
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) :
    |finiteMaximum X ω| ≤ ∑ i, |X i ω| := by
  rw [abs_le]
  exact ⟨neg_sum_abs_le_finiteMaximum X ω,
    finiteMaximum_le_sum_abs X ω⟩

/-- A finite maximum lies below a threshold exactly when every coordinate
does. -/
lemma finiteMaximum_lt_iff
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) (t : ℝ) :
    finiteMaximum X ω < t ↔ ∀ i, X i ω < t := by
  simp [finiteMaximum, Finset.sup'_apply, Finset.sup'_lt_iff]

/-- Independence turns the lower-tail event of a finite maximum into the
product of its coordinate lower-tail probabilities. -/
lemma measure_finiteMaximum_lt_eq_prod
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hIndep : iIndepFun X μ) (t : ℝ) :
    μ {ω | finiteMaximum X ω < t} =
      ∏ i, μ {ω | X i ω < t} := by
  have hEvent : {ω | finiteMaximum X ω < t} =
      ⋂ i, {ω | X i ω < t} := by
    ext ω
    simp only [Set.mem_setOf_eq, Set.mem_iInter]
    exact finiteMaximum_lt_iff X ω t
  rw [hEvent]
  apply hIndep.meas_iInter
  intro i
  exact MeasurableSpace.measurableSet_comap.2
    ⟨Set.Iio t, measurableSet_Iio, rfl⟩

/-- Exact lower-tail probability of the maximum of an independent finite
standard-normal family. -/
lemma measure_finiteMaximum_lt_of_standardNormal
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) (t : ℝ) :
    μ {ω | finiteMaximum X ω < t} =
      standardNormalLaw (Set.Iio t) ^ Fintype.card ι := by
  rw [measure_finiteMaximum_lt_eq_prod hIndep t]
  have hOne : ∀ i, μ {ω | X i ω < t} = standardNormalLaw (Set.Iio t) := by
    intro i
    rw [← (hLaw i).map_eq,
      Measure.map_apply_of_aemeasurable (hLaw i).aemeasurable measurableSet_Iio]
    rfl
  simp_rw [hOne]
  rw [Finset.prod_const]
  simp

end NumStability.HDP.Scalar.GaussianMaxima
