import ComputationalMathematics.HDP.Optimization.GrothendieckBounds
import ComputationalMathematics.HDP.Optimization.GrothendieckFiniteMaximum
import ComputationalMathematics.HDP.Optimization.GrothendieckGaussian
import ComputationalMathematics.HDP.Optimization.GrothendieckHilbert
import ComputationalMathematics.HDP.Optimization.GrothendieckSymmetric
import ComputationalMathematics.HDP.Optimization.GrothendieckTruncation
import ComputationalMathematics.HDP.Scalar.GaussianTails.Basic
import ComputationalMathematics.HDP.Vector.StandardGaussianSubGaussian

/-!
# The elementary final estimate in the truncation proof

This module isolates the last scalar calculation in the first proof of
Grothendieck's inequality.  It is kept separate from the `L²` identity so that
the latter remains a stable reusable dependency for display (3.16).
-/

namespace NumStability.HDP.Optimization

open MeasureTheory ProbabilityTheory
open scoped InnerProductSpace ENNReal NNReal
open NumStability.HDP.Scalar.LimitTheorems
open NumStability.HDP.Scalar.GaussianTails

universe u

/-- Reindexing the canonical bipartite Euclidean space by `Fin (m + n)`
preserves its Euclidean norm. -/
theorem vecNorm2_bipartiteCoordinates {m n : ℕ}
    (x : BipartiteEuclideanSpace m n) :
    NumStability.vecNorm2
        (fun k : Fin (m + n) ↦ x (finSumFinEquiv.symm k)) = ‖x‖ := by
  unfold NumStability.vecNorm2 NumStability.vecNorm2Sq
  rw [EuclideanSpace.norm_eq]
  simp only [Real.norm_eq_abs, sq_abs]
  congr 1
  symm
  exact Fintype.sum_equiv finSumFinEquiv
    (fun s : Sum (Fin m) (Fin n) ↦ x s ^ 2)
    (fun k : Fin (m + n) ↦ x (finSumFinEquiv.symm k) ^ 2)
    (fun s ↦ by simp)

/-- A maximizing row vector written as a unit direction in ordinary finite
coordinates, ready for the standard-Gaussian construction. -/
noncomputable def bipartiteMaximizerRowDirection {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin m) :
    NumStability.HDP.Vector.SubGaussian.UnitDirection (m + n) :=
  ⟨fun k ↦ ((bipartiteUnitMaximizer A).1 i :
      BipartiteEuclideanSpace m n) (finSumFinEquiv.symm k), by
    rw [vecNorm2_bipartiteCoordinates]
    simp⟩

/-- A maximizing column vector written as a unit direction in ordinary finite
coordinates, ready for the standard-Gaussian construction. -/
noncomputable def bipartiteMaximizerColumnDirection {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (j : Fin n) :
    NumStability.HDP.Vector.SubGaussian.UnitDirection (m + n) :=
  ⟨fun k ↦ ((bipartiteUnitMaximizer A).2 j :
      BipartiteEuclideanSpace m n) (finSumFinEquiv.symm k), by
    rw [vecNorm2_bipartiteCoordinates]
    simp⟩

theorem sum_bipartiteCoordinates_mul {m n : ℕ}
    (x y : BipartiteEuclideanSpace m n) :
    (∑ k : Fin (m + n), x (finSumFinEquiv.symm k) *
        y (finSumFinEquiv.symm k)) = ⟪x, y⟫_ℝ := by
  rw [PiLp.inner_apply]
  have hinner (a b : ℝ) : ⟪a, b⟫_ℝ = a * b := by
    simpa using (RCLike.inner_apply' a b)
  simp_rw [hinner]
  symm
  exact Fintype.sum_equiv finSumFinEquiv
    (fun s : Sum (Fin m) (Fin n) ↦ x s * y s)
    (fun k : Fin (m + n) ↦ x (finSumFinEquiv.symm k) *
      y (finSumFinEquiv.symm k))
    (fun s ↦ by simp)

/-- The compact maximizer's coordinate sum is exactly the attained
matrix-specific optimum. -/
theorem bipartiteUnitMaximum_eq_coordinate_sum {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    bipartiteUnitMaximum A =
      ∑ i, ∑ j, A i j * ∑ k,
        (bipartiteMaximizerRowDirection A i).1 k *
          (bipartiteMaximizerColumnDirection A j).1 k := by
  unfold bipartiteUnitMaximum bipartiteUnitValue innerBilinearValue
  apply Finset.sum_congr rfl
  intro i _hi
  apply Finset.sum_congr rfl
  intro j _hj
  congr 1
  exact (sum_bipartiteCoordinates_mul
    ((bipartiteUnitMaximizer A).1 i : BipartiteEuclideanSpace m n)
    ((bipartiteUnitMaximizer A).2 j : BipartiteEuclideanSpace m n)).symm

theorem standardNormal_id_memLp_two :
    MemLp (fun x : ℝ ↦ x) 2 standardNormalLaw := by
  simpa [standardNormalLaw] using
    (ProbabilityTheory.memLp_id_gaussianReal'
      (μ := (0 : ℝ)) (v := (1 : ℝ≥0)) 2 (by norm_num))

theorem standardNormalRestrictedId_memLp (s : Set ℝ)
    (hs : MeasurableSet s) :
    MemLp (s.indicator fun x : ℝ ↦ x) 2 standardNormalLaw :=
  standardNormal_id_memLp_two.indicator hs

/-- The identity random variable restricted to a measurable event, viewed in
the standard-normal `L²` space. This is the common producer for both pieces of
the truncation at level `R`. -/
noncomputable def standardNormalRestrictedIdLp (s : Set ℝ)
    (hs : MeasurableSet s) : Lp ℝ 2 standardNormalLaw :=
  ((standardNormalRestrictedId_memLp s hs).toLp
    (s.indicator fun x : ℝ ↦ x))

theorem standardNormalRestrictedIdLp_coe_ae (s : Set ℝ)
    (hs : MeasurableSet s) :
    (standardNormalRestrictedIdLp s hs : ℝ → ℝ) =ᵐ[standardNormalLaw]
      s.indicator (fun x : ℝ ↦ x) := by
  change (((standardNormalRestrictedId_memLp s hs).toLp
      (s.indicator fun x : ℝ ↦ x) : Lp ℝ 2 standardNormalLaw) : ℝ → ℝ) =ᵐ[
        standardNormalLaw] s.indicator (fun x : ℝ ↦ x)
  exact MemLp.coeFn_toLp (standardNormalRestrictedId_memLp s hs)

theorem standardNormalRestrictedIdLp_norm_sq (s : Set ℝ)
    (hs : MeasurableSet s) :
    ‖standardNormalRestrictedIdLp s hs‖ ^ 2 =
      ∫ x in s, x ^ 2 ∂standardNormalLaw := by
  rw [← real_inner_self_eq_norm_sq, MeasureTheory.L2.inner_def,
    ← integral_indicator hs]
  apply integral_congr_ae
  filter_upwards [standardNormalRestrictedIdLp_coe_ae s hs] with x hx
  rw [hx]
  by_cases hxs : x ∈ s
  · simp [Set.indicator_of_mem hxs, Real.norm_eq_abs, sq_abs]
  · simp [Set.indicator_of_notMem hxs]

/-- The bounded part `x 1_{|x| ≤ R}` of a standard normal variable. -/
noncomputable def standardNormalBodyLp (R : ℝ) : Lp ℝ 2 standardNormalLaw :=
  standardNormalRestrictedIdLp {x : ℝ | |x| ≤ R}
    (measurableSet_le measurable_abs measurable_const)

/-- The tail part `x 1_{|x| > R}` of a standard normal variable. -/
noncomputable def standardNormalTailLp (R : ℝ) : Lp ℝ 2 standardNormalLaw :=
  standardNormalRestrictedIdLp {x : ℝ | |x| > R}
    (measurableSet_lt measurable_const measurable_abs)

theorem standardNormalBodyLp_norm_sq (R : ℝ) :
    ‖standardNormalBodyLp R‖ ^ 2 =
      ∫ x in {x : ℝ | |x| ≤ R}, x ^ 2 ∂standardNormalLaw := by
  exact standardNormalRestrictedIdLp_norm_sq _ _

theorem standardNormalTailLp_norm_sq (R : ℝ) :
    ‖standardNormalTailLp R‖ ^ 2 =
      ∫ x in {x : ℝ | |x| > R}, x ^ 2 ∂standardNormalLaw := by
  exact standardNormalRestrictedIdLp_norm_sq _ _

theorem standardNormal_secondMoment :
    (∫ x : ℝ, x ^ 2 ∂standardNormalLaw) = 1 := by
  rw [standardNormalLaw]
  have hv := @ProbabilityTheory.variance_id_gaussianReal (0 : ℝ) (1 : ℝ≥0)
  change Var[(fun x : ℝ ↦ x); ProbabilityTheory.gaussianReal 0 1] =
    (1 : ℝ≥0) at hv
  rw [ProbabilityTheory.variance_of_integral_eq_zero
    measurable_id'.aemeasurable (by simp)] at hv
  norm_num at hv ⊢
  exact hv

theorem standardNormalBodyLp_norm_le_one (R : ℝ) :
    ‖standardNormalBodyLp R‖ ≤ 1 := by
  have hsq : ‖standardNormalBodyLp R‖ ^ 2 ≤ 1 := by
    rw [standardNormalBodyLp_norm_sq]
    calc
      (∫ x in {x : ℝ | |x| ≤ R}, x ^ 2 ∂standardNormalLaw) ≤
          ∫ x : ℝ, x ^ 2 ∂standardNormalLaw :=
        setIntegral_le_integral standardNormal_id_memLp_two.integrable_sq
          (Filter.Eventually.of_forall fun x ↦ sq_nonneg x)
      _ = 1 := standardNormal_secondMoment
  nlinarith [norm_nonneg (standardNormalBodyLp R)]

theorem standardNormalTailLp_norm_le_one (R : ℝ) :
    ‖standardNormalTailLp R‖ ≤ 1 := by
  have hsq : ‖standardNormalTailLp R‖ ^ 2 ≤ 1 := by
    rw [standardNormalTailLp_norm_sq]
    calc
      (∫ x in {x : ℝ | |x| > R}, x ^ 2 ∂standardNormalLaw) ≤
          ∫ x : ℝ, x ^ 2 ∂standardNormalLaw :=
        setIntegral_le_integral standardNormal_id_memLp_two.integrable_sq
          (Filter.Eventually.of_forall fun x ↦ sq_nonneg x)
      _ = 1 := standardNormal_secondMoment
  nlinarith [norm_nonneg (standardNormalTailLp R)]

/-- Display (3.15) gives the exact tail-family norm bound needed by each
mixed term in the first proof of Grothendieck's inequality. -/
theorem standardNormalTailLp_norm_lt_two_div (R : ℝ) (hR : 1 ≤ R) :
    ‖standardNormalTailLp R‖ < 2 / R := by
  have hmoment :
      (∫ x in {x : ℝ | |x| > R}, x ^ 2 ∂standardNormalLaw) < 4 / R ^ 2 :=
    (standardNormal_absTail_secondMoment_le R hR).trans_lt
      (standardNormal_absTail_secondMoment_lt_four_div_sq R hR)
  have hsq : ‖standardNormalTailLp R‖ ^ 2 < (2 / R) ^ 2 := by
    rw [standardNormalTailLp_norm_sq]
    calc
      (∫ x in {x : ℝ | |x| > R}, x ^ 2 ∂standardNormalLaw) < 4 / R ^ 2 :=
        hmoment
      _ = (2 / R) ^ 2 := by ring
  have hRpos : 0 < R := zero_lt_one.trans_le hR
  have htwo : 0 < 2 / R := div_pos (by norm_num) hRpos
  nlinarith [norm_nonneg (standardNormalTailLp R)]

theorem standardNormalTailLp_norm_le_two_div (R : ℝ) (hR : 1 ≤ R) :
    ‖standardNormalTailLp R‖ ≤ 2 / R :=
  (standardNormalTailLp_norm_lt_two_div R hR).le

/-- Pull a restricted standard-normal identity variable back along any random
variable having the standard-normal law. -/
theorem standardNormalRestrictedId_comp_memLp
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} (X : Ω → ℝ)
    (hX : HasLaw X standardNormalLaw μ) (s : Set ℝ)
    (hs : MeasurableSet s) :
    MemLp ((s.indicator fun x : ℝ ↦ x) ∘ X) 2 μ := by
  have hmap : MemLp (s.indicator fun x : ℝ ↦ x) 2 (Measure.map X μ) := by
    rw [hX.map_eq]
    exact standardNormalRestrictedId_memLp s hs
  exact hmap.comp_of_map hX.aemeasurable

noncomputable def standardNormalRestrictedIdLpOfHasLaw
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} (X : Ω → ℝ)
    (hX : HasLaw X standardNormalLaw μ) (s : Set ℝ)
    (hs : MeasurableSet s) : Lp ℝ 2 μ :=
  (standardNormalRestrictedId_comp_memLp X hX s hs).toLp
    ((s.indicator fun x : ℝ ↦ x) ∘ X)

theorem standardNormalRestrictedIdLpOfHasLaw_coe_ae
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} (X : Ω → ℝ)
    (hX : HasLaw X standardNormalLaw μ) (s : Set ℝ)
    (hs : MeasurableSet s) :
    (standardNormalRestrictedIdLpOfHasLaw X hX s hs : Ω → ℝ) =ᵐ[μ]
      ((s.indicator fun x : ℝ ↦ x) ∘ X) := by
  change (((standardNormalRestrictedId_comp_memLp X hX s hs).toLp
      ((s.indicator fun x : ℝ ↦ x) ∘ X) : Lp ℝ 2 μ) : Ω → ℝ) =ᵐ[μ]
    ((s.indicator fun x : ℝ ↦ x) ∘ X)
  exact MemLp.coeFn_toLp (standardNormalRestrictedId_comp_memLp X hX s hs)

theorem standardNormalRestrictedIdLpOfHasLaw_norm_sq
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} (X : Ω → ℝ)
    (hX : HasLaw X standardNormalLaw μ) (s : Set ℝ)
    (hs : MeasurableSet s) :
    ‖standardNormalRestrictedIdLpOfHasLaw X hX s hs‖ ^ 2 =
      ∫ x in s, x ^ 2 ∂standardNormalLaw := by
  rw [← real_inner_self_eq_norm_sq, MeasureTheory.L2.inner_def,
    ← integral_indicator hs]
  calc
    (∫ ω, ⟪standardNormalRestrictedIdLpOfHasLaw X hX s hs ω,
        standardNormalRestrictedIdLpOfHasLaw X hX s hs ω⟫_ℝ ∂μ) =
        ∫ ω, (s.indicator (fun x : ℝ ↦ x ^ 2)) (X ω) ∂μ := by
      apply integral_congr_ae
      filter_upwards [standardNormalRestrictedIdLpOfHasLaw_coe_ae X hX s hs]
        with ω hω
      rw [hω]
      by_cases hXs : X ω ∈ s
      · simp [Set.indicator_of_mem hXs, Real.norm_eq_abs, sq_abs]
      · simp [Set.indicator_of_notMem hXs]
    _ = ∫ x, s.indicator (fun x : ℝ ↦ x ^ 2) x ∂standardNormalLaw := by
      exact hX.integral_comp
        ((measurable_id.pow_const 2).indicator hs).aestronglyMeasurable

theorem standardNormalRestrictedIdLpOfHasLaw_norm_eq
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} (X : Ω → ℝ)
    (hX : HasLaw X standardNormalLaw μ) (s : Set ℝ)
    (hs : MeasurableSet s) :
    ‖standardNormalRestrictedIdLpOfHasLaw X hX s hs‖ =
      ‖standardNormalRestrictedIdLp s hs‖ := by
  have hleft := standardNormalRestrictedIdLpOfHasLaw_norm_sq X hX s hs
  have hright := standardNormalRestrictedIdLp_norm_sq s hs
  nlinarith [norm_nonneg (standardNormalRestrictedIdLpOfHasLaw X hX s hs),
    norm_nonneg (standardNormalRestrictedIdLp s hs)]

noncomputable def standardNormalBodyLpOfHasLaw
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} (X : Ω → ℝ)
    (hX : HasLaw X standardNormalLaw μ) (R : ℝ) : Lp ℝ 2 μ :=
  standardNormalRestrictedIdLpOfHasLaw X hX {x : ℝ | |x| ≤ R}
    (measurableSet_le measurable_abs measurable_const)

noncomputable def standardNormalTailLpOfHasLaw
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} (X : Ω → ℝ)
    (hX : HasLaw X standardNormalLaw μ) (R : ℝ) : Lp ℝ 2 μ :=
  standardNormalRestrictedIdLpOfHasLaw X hX {x : ℝ | |x| > R}
    (measurableSet_lt measurable_const measurable_abs)

theorem standardNormalBodyLpOfHasLaw_norm_le_one
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} (X : Ω → ℝ)
    (hX : HasLaw X standardNormalLaw μ) (R : ℝ) :
    ‖standardNormalBodyLpOfHasLaw X hX R‖ ≤ 1 := by
  rw [show ‖standardNormalBodyLpOfHasLaw X hX R‖ =
      ‖standardNormalBodyLp R‖ by
    exact standardNormalRestrictedIdLpOfHasLaw_norm_eq X hX _ _]
  exact standardNormalBodyLp_norm_le_one R

theorem standardNormalTailLpOfHasLaw_norm_le_one
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} (X : Ω → ℝ)
    (hX : HasLaw X standardNormalLaw μ) (R : ℝ) :
    ‖standardNormalTailLpOfHasLaw X hX R‖ ≤ 1 := by
  rw [show ‖standardNormalTailLpOfHasLaw X hX R‖ =
      ‖standardNormalTailLp R‖ by
    exact standardNormalRestrictedIdLpOfHasLaw_norm_eq X hX _ _]
  exact standardNormalTailLp_norm_le_one R

theorem standardNormalTailLpOfHasLaw_norm_le_two_div
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} (X : Ω → ℝ)
    (hX : HasLaw X standardNormalLaw μ) (R : ℝ) (hR : 1 ≤ R) :
    ‖standardNormalTailLpOfHasLaw X hX R‖ ≤ 2 / R := by
  rw [show ‖standardNormalTailLpOfHasLaw X hX R‖ =
      ‖standardNormalTailLp R‖ by
    exact standardNormalRestrictedIdLpOfHasLaw_norm_eq X hX _ _]
  exact standardNormalTailLp_norm_le_two_div R hR

/-- The bounded piece of a unit linear marginal of the canonical finite
standard Gaussian vector. -/
theorem gaussianUnitMarginal_hasLaw {d : ℕ}
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection d) :
    HasLaw (fun g : Fin d → ℝ ↦ ∑ k, u.1 k * g k) standardNormalLaw
      (NumStability.standardGaussianVectorMeasure d) := by
  simpa [standardNormalLaw] using
    NumStability.HDP.Vector.Gaussian.unitWeightedGaussianLaw u

noncomputable def gaussianUnitMarginalBodyLp {d : ℕ}
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection d) (R : ℝ) :
    Lp ℝ 2 (NumStability.standardGaussianVectorMeasure d) :=
  standardNormalBodyLpOfHasLaw
    (fun g : Fin d → ℝ ↦ ∑ k, u.1 k * g k)
    (gaussianUnitMarginal_hasLaw u) R

/-- The tail piece of a unit linear marginal of the canonical finite standard
Gaussian vector. -/
noncomputable def gaussianUnitMarginalTailLp {d : ℕ}
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection d) (R : ℝ) :
    Lp ℝ 2 (NumStability.standardGaussianVectorMeasure d) :=
  standardNormalTailLpOfHasLaw
    (fun g : Fin d → ℝ ↦ ∑ k, u.1 k * g k)
    (gaussianUnitMarginal_hasLaw u) R

theorem gaussianUnitMarginalBodyLp_coe_ae {d : ℕ}
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection d) (R : ℝ) :
    (gaussianUnitMarginalBodyLp u R : (Fin d → ℝ) → ℝ) =ᵐ[
        NumStability.standardGaussianVectorMeasure d]
      (({x : ℝ | |x| ≤ R}.indicator fun x : ℝ ↦ x) ∘
        fun g : Fin d → ℝ ↦ ∑ k, u.1 k * g k) := by
  unfold gaussianUnitMarginalBodyLp standardNormalBodyLpOfHasLaw
  exact standardNormalRestrictedIdLpOfHasLaw_coe_ae _
    (gaussianUnitMarginal_hasLaw u) _
    (measurableSet_le measurable_abs measurable_const)

theorem gaussianUnitMarginalTailLp_coe_ae {d : ℕ}
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection d) (R : ℝ) :
    (gaussianUnitMarginalTailLp u R : (Fin d → ℝ) → ℝ) =ᵐ[
        NumStability.standardGaussianVectorMeasure d]
      (({x : ℝ | |x| > R}.indicator fun x : ℝ ↦ x) ∘
        fun g : Fin d → ℝ ↦ ∑ k, u.1 k * g k) := by
  unfold gaussianUnitMarginalTailLp standardNormalTailLpOfHasLaw
  exact standardNormalRestrictedIdLpOfHasLaw_coe_ae _
    (gaussianUnitMarginal_hasLaw u) _
    (measurableSet_lt measurable_const measurable_abs)

theorem gaussianUnitMarginalBody_add_tail_coe_ae {d : ℕ}
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection d) (R : ℝ) :
    (fun g : Fin d → ℝ ↦ gaussianUnitMarginalBodyLp u R g +
        gaussianUnitMarginalTailLp u R g) =ᵐ[
      NumStability.standardGaussianVectorMeasure d]
      (fun g : Fin d → ℝ ↦ ∑ k, u.1 k * g k) := by
  filter_upwards [gaussianUnitMarginalBodyLp_coe_ae u R,
    gaussianUnitMarginalTailLp_coe_ae u R] with g hbody htail
  rw [hbody, htail]
  simp only [Function.comp_apply]
  by_cases hle : |∑ k, u.1 k * g k| ≤ R
  · have hbodyMem : (∑ k, u.1 k * g k) ∈ {x : ℝ | |x| ≤ R} := hle
    have htailNotMem : (∑ k, u.1 k * g k) ∉ {x : ℝ | |x| > R} :=
      not_lt_of_ge hle
    rw [Set.indicator_of_mem hbodyMem, Set.indicator_of_notMem htailNotMem]
    simp
  · have hgt : |∑ k, u.1 k * g k| > R := lt_of_not_ge hle
    have hbodyNotMem : (∑ k, u.1 k * g k) ∉ {x : ℝ | |x| ≤ R} := hle
    have htailMem : (∑ k, u.1 k * g k) ∈ {x : ℝ | |x| > R} := hgt
    rw [Set.indicator_of_notMem hbodyNotMem, Set.indicator_of_mem htailMem]
    simp

theorem gaussianUnitMarginalBodyLp_norm_le_one {d : ℕ}
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection d) (R : ℝ) :
    ‖gaussianUnitMarginalBodyLp u R‖ ≤ 1 := by
  exact standardNormalBodyLpOfHasLaw_norm_le_one _
    (gaussianUnitMarginal_hasLaw u) R

theorem gaussianUnitMarginalTailLp_norm_le_one {d : ℕ}
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection d) (R : ℝ) :
    ‖gaussianUnitMarginalTailLp u R‖ ≤ 1 := by
  exact standardNormalTailLpOfHasLaw_norm_le_one _
    (gaussianUnitMarginal_hasLaw u) R

theorem gaussianUnitMarginalTailLp_norm_le_two_div {d : ℕ}
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (R : ℝ) (hR : 1 ≤ R) :
    ‖gaussianUnitMarginalTailLp u R‖ ≤ 2 / R := by
  exact standardNormalTailLpOfHasLaw_norm_le_two_div _
    (gaussianUnitMarginal_hasLaw u) R hR

/-- The body part of a transported unit Gaussian marginal is bounded by the
truncation level almost everywhere. -/
theorem gaussianUnitMarginalBodyLp_abs_le_ae {d : ℕ}
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (R : ℝ) (hR : 0 ≤ R) :
    ∀ᵐ g ∂NumStability.standardGaussianVectorMeasure d,
      |gaussianUnitMarginalBodyLp u R g| ≤ R := by
  filter_upwards [gaussianUnitMarginalBodyLp_coe_ae u R] with g hg
  rw [hg]
  simp only [Function.comp_apply]
  by_cases hmem : (∑ k, u.1 k * g k) ∈ {x : ℝ | |x| ≤ R}
  · rw [Set.indicator_of_mem hmem]
    exact hmem
  · rw [Set.indicator_of_notMem hmem]
    simpa using hR

/-- A finite real bilinear expression in two `L²` families is integrable.
This is the integrability companion to
`integral_bilinear_sum_eq_sum_l2_inner`. -/
theorem integrable_bilinearValue_l2
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ)
    (U : Fin m → Lp ℝ 2 μ) (V : Fin n → Lp ℝ 2 μ) :
    Integrable
      (fun ω ↦ bilinearValue A (fun i ↦ U i ω) (fun j ↦ V j ω)) μ := by
  unfold bilinearValue
  apply integrable_finset_sum
  intro i _hi
  apply integrable_finset_sum
  intro j _hj
  have hmul := (Lp.memLp (U i)).integrable_mul (Lp.memLp (V j))
  simpa only [Pi.mul_apply, mul_assoc] using hmul.const_mul (A i j)

theorem innerBilinearValue_add_add {m n : ℕ} {E : Type*}
    [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (A : Matrix (Fin m) (Fin n) ℝ)
    (x x' : Fin m → E) (y y' : Fin n → E) :
    innerBilinearValue A (x + x') (y + y') =
      innerBilinearValue A x y + innerBilinearValue A x' y +
        innerBilinearValue A x y' + innerBilinearValue A x' y' := by
  unfold innerBilinearValue
  simp only [Pi.add_apply, inner_add_left, inner_add_right, mul_add,
    Finset.sum_add_distrib]
  ring

/-- The full Gaussian bilinear moment decomposes exactly into its four body
and tail `L²` pairings. -/
theorem gaussian_unit_marginal_bilinear_decomposition
    {d m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (u : Fin m → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (v : Fin n → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (R : ℝ) :
    (∑ i, ∑ j, A i j * ∑ k, (u i).1 k * (v j).1 k) =
      innerBilinearValue A
          (fun i ↦ gaussianUnitMarginalBodyLp (u i) R)
          (fun j ↦ gaussianUnitMarginalBodyLp (v j) R) +
        innerBilinearValue A
          (fun i ↦ gaussianUnitMarginalTailLp (u i) R)
          (fun j ↦ gaussianUnitMarginalBodyLp (v j) R) +
        innerBilinearValue A
          (fun i ↦ gaussianUnitMarginalBodyLp (u i) R)
          (fun j ↦ gaussianUnitMarginalTailLp (v j) R) +
        innerBilinearValue A
          (fun i ↦ gaussianUnitMarginalTailLp (u i) R)
          (fun j ↦ gaussianUnitMarginalTailLp (v j) R) := by
  let U : Fin m → Lp ℝ 2 (NumStability.standardGaussianVectorMeasure d) :=
    fun i ↦ gaussianUnitMarginalBodyLp (u i) R +
      gaussianUnitMarginalTailLp (u i) R
  let V : Fin n → Lp ℝ 2 (NumStability.standardGaussianVectorMeasure d) :=
    fun j ↦ gaussianUnitMarginalBodyLp (v j) R +
      gaussianUnitMarginalTailLp (v j) R
  have hU (i : Fin m) :
      (U i : (Fin d → ℝ) → ℝ) =ᵐ[NumStability.standardGaussianVectorMeasure d]
        (fun g : Fin d → ℝ ↦ ∑ k, (u i).1 k * g k) := by
    exact (Lp.coeFn_add _ _).trans
      (gaussianUnitMarginalBody_add_tail_coe_ae (u i) R)
  have hV (j : Fin n) :
      (V j : (Fin d → ℝ) → ℝ) =ᵐ[NumStability.standardGaussianVectorMeasure d]
        (fun g : Fin d → ℝ ↦ ∑ k, (v j).1 k * g k) := by
    exact (Lp.coeFn_add _ _).trans
      (gaussianUnitMarginalBody_add_tail_coe_ae (v j) R)
  have hintegral :
      (∫ g : Fin d → ℝ, ∑ i, ∑ j, A i j * U i g * V j g
        ∂NumStability.standardGaussianVectorMeasure d) =
      ∫ g : Fin d → ℝ, ∑ i, ∑ j, A i j *
          (∑ k, (u i).1 k * g k) * (∑ k, (v j).1 k * g k)
        ∂NumStability.standardGaussianVectorMeasure d := by
    apply integral_congr_ae
    filter_upwards [ae_all_iff.2 hU, ae_all_iff.2 hV] with g hUg hVg
    apply Finset.sum_congr rfl
    intro i _hi
    apply Finset.sum_congr rfl
    intro j _hj
    rw [hUg i, hVg j]
  have hfull : innerBilinearValue A U V =
      ∑ i, ∑ j, A i j * ∑ k, (u i).1 k * (v j).1 k := by
    unfold innerBilinearValue
    rw [← integral_bilinear_sum_eq_sum_l2_inner]
    rw [hintegral]
    simpa only [NumStability.HDP.Vector.linearMarginal, mul_comm,
      mul_assoc] using
      (integral_standardGaussian_bilinear_sum A
        (fun i ↦ (u i).1) (fun j ↦ (v j).1))
  rw [← hfull]
  exact innerBilinearValue_add_add A
    (fun i ↦ gaussianUnitMarginalBodyLp (u i) R)
    (fun i ↦ gaussianUnitMarginalTailLp (u i) R)
    (fun j ↦ gaussianUnitMarginalBodyLp (v j) R)
    (fun j ↦ gaussianUnitMarginalTailLp (v j) R)

/-- A homogeneous Grothendieck bound together with pointwise family-norm
bounds gives the corresponding scalar product bound. This packages the
max-norm step used for each of the three truncation error terms. -/
theorem innerBilinearValue_le_of_pointwise_norm_le
    {m n : ℕ} {E : Type u} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (A : Matrix (Fin m) (Fin n) ℝ) {K α β : ℝ}
    (hK : 0 ≤ K) (hα : 0 ≤ α) (hβ : 0 ≤ β)
    (hbound : UniversalPiNormBound.{u} A K)
    (x : Fin m → E) (y : Fin n → E)
    (hx : ∀ i, ‖x i‖ ≤ α) (hy : ∀ j, ‖y j‖ ≤ β) :
    innerBilinearValue A x y ≤ K * α * β := by
  calc
    innerBilinearValue A x y ≤ K * ‖x‖ * ‖y‖ := hbound E x y
    _ ≤ K * α * β := by
      gcongr
      · exact (pi_norm_le_iff_of_nonneg hα).2 hx
      · exact (pi_norm_le_iff_of_nonneg hβ).2 hy

/-- The three mixed/tail terms in the truncation argument contribute at most
`6K/R`.  For the tail-tail term we retain the elementary `L²` contraction
bound on one tail and use the `2/R` estimate on the other. -/
theorem three_innerBilinear_error_terms_le_six_mul_div
    {m n : ℕ} {E : Type u} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (A : Matrix (Fin m) (Fin n) ℝ) {K R : ℝ}
    (hK : 0 ≤ K) (hR : 0 < R)
    (hbound : UniversalPiNormBound.{u} A K)
    (Uminus Uplus : Fin m → E) (Vminus Vplus : Fin n → E)
    (hUminus : ∀ i, ‖Uminus i‖ ≤ 1)
    (hUplus : ∀ i, ‖Uplus i‖ ≤ 2 / R)
    (hVminus : ∀ j, ‖Vminus j‖ ≤ 1)
    (hVplus : ∀ j, ‖Vplus j‖ ≤ 2 / R)
    (hVplusOne : ∀ j, ‖Vplus j‖ ≤ 1) :
    innerBilinearValue A Uplus Vminus +
          innerBilinearValue A Uminus Vplus +
        innerBilinearValue A Uplus Vplus ≤ 6 * K / R := by
  have htwoR : 0 ≤ 2 / R := by positivity
  have h₂ := innerBilinearValue_le_of_pointwise_norm_le A hK htwoR
    zero_le_one hbound Uplus Vminus hUplus hVminus
  have h₃ := innerBilinearValue_le_of_pointwise_norm_le A hK zero_le_one
    htwoR hbound Uminus Vplus hUminus hVplus
  have h₄ := innerBilinearValue_le_of_pointwise_norm_le A hK htwoR
    zero_le_one hbound Uplus Vplus hUplus hVplusOne
  calc
    innerBilinearValue A Uplus Vminus +
          innerBilinearValue A Uminus Vplus +
        innerBilinearValue A Uplus Vplus
        ≤ (K * (2 / R) * 1) + (K * 1 * (2 / R)) +
            (K * (2 / R) * 1) := add_le_add (add_le_add h₂ h₃) h₄
    _ = 6 * K / R := by ring

/-- Step 5 of the truncation proof: once the Gaussian expectation has been
decomposed into its bounded main term and the three `L²` error terms, the
preceding estimates give `K ≤ R² + 6K/R`. -/
theorem le_sq_add_six_mul_div_of_truncation_decomposition
    {m n : ℕ} {E : Type u} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (A : Matrix (Fin m) (Fin n) ℝ) {K R S₁ : ℝ}
    (hK : 0 ≤ K) (hR : 0 < R)
    (hbound : UniversalPiNormBound.{u} A K)
    (Uminus Uplus : Fin m → E) (Vminus Vplus : Fin n → E)
    (hUminus : ∀ i, ‖Uminus i‖ ≤ 1)
    (hUplus : ∀ i, ‖Uplus i‖ ≤ 2 / R)
    (hVminus : ∀ j, ‖Vminus j‖ ≤ 1)
    (hVplus : ∀ j, ‖Vplus j‖ ≤ 2 / R)
    (hVplusOne : ∀ j, ‖Vplus j‖ ≤ 1)
    (hmain : S₁ ≤ R ^ 2)
    (hdecomp : K = S₁ + innerBilinearValue A Uplus Vminus +
          innerBilinearValue A Uminus Vplus +
        innerBilinearValue A Uplus Vplus) :
    K ≤ R ^ 2 + 6 * K / R := by
  have herr := three_innerBilinear_error_terms_le_six_mul_div A hK hR hbound
    Uminus Uplus Vminus Vplus hUminus hUplus hVminus hVplus hVplusOne
  linarith

/-- The abstract three-error estimate specialized to the actual body and tail
pieces of unit Gaussian marginals. All five family-norm side conditions are
discharged by the law-transported form of display (3.15). -/
theorem le_sq_add_six_mul_div_of_gaussian_unit_marginal_decomposition
    {d m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) {K R S₁ : ℝ}
    (hK : 0 ≤ K) (hR : 1 ≤ R)
    (hbound : UniversalPiNormBound.{0} A K)
    (u : Fin m → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (v : Fin n → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (hmain : S₁ ≤ R ^ 2)
    (hdecomp : K = S₁ +
          innerBilinearValue A
            (fun i ↦ gaussianUnitMarginalTailLp (u i) R)
            (fun j ↦ gaussianUnitMarginalBodyLp (v j) R) +
          innerBilinearValue A
            (fun i ↦ gaussianUnitMarginalBodyLp (u i) R)
            (fun j ↦ gaussianUnitMarginalTailLp (v j) R) +
        innerBilinearValue A
          (fun i ↦ gaussianUnitMarginalTailLp (u i) R)
          (fun j ↦ gaussianUnitMarginalTailLp (v j) R)) :
    K ≤ R ^ 2 + 6 * K / R := by
  exact le_sq_add_six_mul_div_of_truncation_decomposition A hK
    (zero_lt_one.trans_le hR) hbound
    (fun i ↦ gaussianUnitMarginalBodyLp (u i) R)
    (fun i ↦ gaussianUnitMarginalTailLp (u i) R)
    (fun j ↦ gaussianUnitMarginalBodyLp (v j) R)
    (fun j ↦ gaussianUnitMarginalTailLp (v j) R)
    (fun i ↦ gaussianUnitMarginalBodyLp_norm_le_one (u i) R)
    (fun i ↦ gaussianUnitMarginalTailLp_norm_le_two_div (u i) R hR)
    (fun j ↦ gaussianUnitMarginalBodyLp_norm_le_one (v j) R)
    (fun j ↦ gaussianUnitMarginalTailLp_norm_le_two_div (v j) R hR)
    (fun j ↦ gaussianUnitMarginalTailLp_norm_le_one (v j) R)
    hmain hdecomp

/-- The Gaussian identity supplies the decomposition hypothesis in the
truncation estimate directly from the Euclidean coefficient sum. -/
theorem le_sq_add_six_mul_div_of_gaussian_unit_marginals
    {d m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) {K R : ℝ}
    (hK : 0 ≤ K) (hR : 1 ≤ R)
    (hbound : UniversalPiNormBound.{0} A K)
    (u : Fin m → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (v : Fin n → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (hcoordinate : K = ∑ i, ∑ j, A i j * ∑ k, (u i).1 k * (v j).1 k)
    (hmain : innerBilinearValue A
          (fun i ↦ gaussianUnitMarginalBodyLp (u i) R)
          (fun j ↦ gaussianUnitMarginalBodyLp (v j) R) ≤ R ^ 2) :
    K ≤ R ^ 2 + 6 * K / R := by
  apply le_sq_add_six_mul_div_of_gaussian_unit_marginal_decomposition A hK
    hR hbound u v hmain
  exact hcoordinate.trans (gaussian_unit_marginal_bilinear_decomposition A u v R)

/-- Integral form of the three truncation error estimates. The finite-sum
`L²` identity converts all three expectations to Hilbert-space bilinear
values, after which the homogeneous Grothendieck bound applies. -/
theorem integral_three_bilinear_error_terms_le_six_mul_div
    {Ω : Type u} [MeasurableSpace Ω] {μ : Measure Ω} {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) {K R : ℝ}
    (hK : 0 ≤ K) (hR : 0 < R)
    (hbound : UniversalPiNormBound.{u} A K)
    (Uminus Uplus : Fin m → Lp ℝ 2 μ)
    (Vminus Vplus : Fin n → Lp ℝ 2 μ)
    (hUminus : ∀ i, ‖Uminus i‖ ≤ 1)
    (hUplus : ∀ i, ‖Uplus i‖ ≤ 2 / R)
    (hVminus : ∀ j, ‖Vminus j‖ ≤ 1)
    (hVplus : ∀ j, ‖Vplus j‖ ≤ 2 / R)
    (hVplusOne : ∀ j, ‖Vplus j‖ ≤ 1) :
    (∫ ω, ∑ i, ∑ j, A i j * Uplus i ω * Vminus j ω ∂μ) +
          (∫ ω, ∑ i, ∑ j, A i j * Uminus i ω * Vplus j ω ∂μ) +
        (∫ ω, ∑ i, ∑ j, A i j * Uplus i ω * Vplus j ω ∂μ) ≤
      6 * K / R := by
  rw [integral_bilinear_sum_eq_sum_l2_inner,
    integral_bilinear_sum_eq_sum_l2_inner,
    integral_bilinear_sum_eq_sum_l2_inner]
  exact three_innerBilinear_error_terms_le_six_mul_div A hK hR hbound
    Uminus Uplus Vminus Vplus hUminus hUplus hVminus hVplus hVplusOne

/-- The bounded main term in the truncation proof is at most `R²`. -/
theorem bilinearValue_le_sq_of_sign_of_abs_le
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (hsign : ∀ x y, IsSignVector x → IsSignVector y → bilinearValue A x y ≤ 1)
    {R : ℝ} (hR : 0 ≤ R) (x : Fin m → ℝ) (y : Fin n → ℝ)
    (hx : ∀ i, |x i| ≤ R) (hy : ∀ j, |y j| ≤ R) :
    bilinearValue A x y ≤ R ^ 2 := by
  calc
    bilinearValue A x y ≤ ‖x‖ * ‖y‖ :=
      bilinearValue_le_norm_mul_norm_of_sign A hsign x y
    _ ≤ R * R := by
      gcongr
      · exact (pi_norm_le_iff_of_nonneg hR).2 fun i => by
          simpa only [Real.norm_eq_abs] using hx i
      · exact (pi_norm_le_iff_of_nonneg hR).2 fun j => by
          simpa only [Real.norm_eq_abs] using hy j
    _ = R ^ 2 := by ring

/-- The pointwise bounded main term remains bounded by `R²` after expectation
under a probability measure. -/
theorem integral_bilinearValue_le_sq_of_sign_of_abs_le
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (hsign : ∀ x y, IsSignVector x → IsSignVector y → bilinearValue A x y ≤ 1)
    {R : ℝ} (hR : 0 ≤ R) (U : Fin m → Ω → ℝ) (V : Fin n → Ω → ℝ)
    (hInt : Integrable (fun ω => bilinearValue A (fun i => U i ω) (fun j => V j ω)) μ)
    (hU : ∀ᵐ ω ∂μ, ∀ i, |U i ω| ≤ R)
    (hV : ∀ᵐ ω ∂μ, ∀ j, |V j ω| ≤ R) :
    (∫ ω, bilinearValue A (fun i => U i ω) (fun j => V j ω) ∂μ) ≤ R ^ 2 := by
  calc
    (∫ ω, bilinearValue A (fun i => U i ω) (fun j => V j ω) ∂μ) ≤
        ∫ _ : Ω, R ^ 2 ∂μ := by
      apply integral_mono_ae hInt (integrable_const (R ^ 2))
      filter_upwards [hU, hV] with ω hUω hVω
      exact bilinearValue_le_sq_of_sign_of_abs_le A hsign hR _ _ hUω hVω
    _ = R ^ 2 := by simp

/-- The body-body term of the canonical Gaussian marginal decomposition is
bounded by `R²` under the sign-vector hypothesis. -/
theorem gaussianUnitMarginalBody_innerBilinearValue_le_sq
    {d m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (hsign : ∀ x y, IsSignVector x → IsSignVector y →
      bilinearValue A x y ≤ 1)
    (u : Fin m → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (v : Fin n → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    {R : ℝ} (hR : 0 ≤ R) :
    innerBilinearValue A
        (fun i ↦ gaussianUnitMarginalBodyLp (u i) R)
        (fun j ↦ gaussianUnitMarginalBodyLp (v j) R) ≤ R ^ 2 := by
  unfold innerBilinearValue
  rw [← integral_bilinear_sum_eq_sum_l2_inner]
  exact integral_bilinearValue_le_sq_of_sign_of_abs_le
    (NumStability.standardGaussianVectorMeasure d) A hsign hR
    (fun i g ↦ gaussianUnitMarginalBodyLp (u i) R g)
    (fun j g ↦ gaussianUnitMarginalBodyLp (v j) R g)
    (integrable_bilinearValue_l2 A
      (fun i ↦ gaussianUnitMarginalBodyLp (u i) R)
      (fun j ↦ gaussianUnitMarginalBodyLp (v j) R))
    (ae_all_iff.2 fun i ↦ gaussianUnitMarginalBodyLp_abs_le_ae (u i) R hR)
    (ae_all_iff.2 fun j ↦ gaussianUnitMarginalBodyLp_abs_le_ae (v j) R hR)

/-- The complete analytic truncation estimate for unit Gaussian marginals:
the sign-vector bound discharges the body-body term, while the transported
`L²` bounds discharge all three error terms. -/
theorem le_sq_add_six_mul_div_of_gaussian_unit_marginals_of_sign
    {d m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) {K R : ℝ}
    (hK : 0 ≤ K) (hR : 1 ≤ R)
    (hbound : UniversalPiNormBound.{0} A K)
    (hsign : ∀ x y, IsSignVector x → IsSignVector y →
      bilinearValue A x y ≤ 1)
    (u : Fin m → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (v : Fin n → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (hcoordinate : K = ∑ i, ∑ j, A i j * ∑ k, (u i).1 k * (v j).1 k) :
    K ≤ R ^ 2 + 6 * K / R := by
  exact le_sq_add_six_mul_div_of_gaussian_unit_marginals A hK hR hbound u v
    hcoordinate
    (gaussianUnitMarginalBody_innerBilinearValue_le_sq A hsign u v
      (zero_le_one.trans hR))

/-- Substituting `R = 12` in `K ≤ R² + 6K/R` yields `K ≤ 288`. -/
theorem le_288_of_le_twelve_sq_add_six_mul_div (K : ℝ)
    (hK : K ≤ (12 : ℝ) ^ 2 + 6 * K / 12) :
    K ≤ 288 := by
  norm_num at hK ⊢
  linarith

/-- The numerical end of the source proof after instantiating the canonical
Gaussian truncation at `R = 12`. -/
theorem le_288_of_gaussian_unit_marginal_decomposition
    {d m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) {K S₁ : ℝ}
    (hK : 0 ≤ K) (hbound : UniversalPiNormBound.{0} A K)
    (u : Fin m → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (v : Fin n → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (hmain : S₁ ≤ (12 : ℝ) ^ 2)
    (hdecomp : K = S₁ +
          innerBilinearValue A
            (fun i ↦ gaussianUnitMarginalTailLp (u i) 12)
            (fun j ↦ gaussianUnitMarginalBodyLp (v j) 12) +
          innerBilinearValue A
            (fun i ↦ gaussianUnitMarginalBodyLp (u i) 12)
            (fun j ↦ gaussianUnitMarginalTailLp (v j) 12) +
        innerBilinearValue A
          (fun i ↦ gaussianUnitMarginalTailLp (u i) 12)
          (fun j ↦ gaussianUnitMarginalTailLp (v j) 12)) :
    K ≤ 288 := by
  apply le_288_of_le_twelve_sq_add_six_mul_div K
  exact le_sq_add_six_mul_div_of_gaussian_unit_marginal_decomposition A hK
    (by norm_num) hbound u v hmain hdecomp

/-- The numerical `K ≤ 288` conclusion with the Gaussian decomposition
discharged by the canonical marginal construction. -/
theorem le_288_of_gaussian_unit_marginals
    {d m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) {K : ℝ}
    (hK : 0 ≤ K) (hbound : UniversalPiNormBound.{0} A K)
    (u : Fin m → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (v : Fin n → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (hcoordinate : K = ∑ i, ∑ j, A i j * ∑ k, (u i).1 k * (v j).1 k)
    (hmain : innerBilinearValue A
          (fun i ↦ gaussianUnitMarginalBodyLp (u i) 12)
          (fun j ↦ gaussianUnitMarginalBodyLp (v j) 12) ≤ (12 : ℝ) ^ 2) :
    K ≤ 288 := by
  apply le_288_of_le_twelve_sq_add_six_mul_div K
  exact le_sq_add_six_mul_div_of_gaussian_unit_marginals A hK (by norm_num)
    hbound u v hcoordinate hmain

/-- The complete conditional `K ≤ 288` estimate: only the finite-dimensional
coordinate realization of `K` and its homogeneous Hilbert-space bound remain
as hypotheses. -/
theorem le_288_of_gaussian_unit_marginals_of_sign
    {d m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) {K : ℝ}
    (hK : 0 ≤ K) (hbound : UniversalPiNormBound.{0} A K)
    (hsign : ∀ x y, IsSignVector x → IsSignVector y →
      bilinearValue A x y ≤ 1)
    (u : Fin m → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (v : Fin n → NumStability.HDP.Vector.SubGaussian.UnitDirection d)
    (hcoordinate : K = ∑ i, ∑ j, A i j * ∑ k, (u i).1 k * (v j).1 k) :
    K ≤ 288 := by
  apply le_288_of_le_twelve_sq_add_six_mul_div K
  exact le_sq_add_six_mul_div_of_gaussian_unit_marginals_of_sign A hK
    (by norm_num) hbound hsign u v hcoordinate

/-- The attained finite-dimensional matrix optimum is at most `288` under
the sign-vector hypothesis. -/
theorem bipartiteUnitMaximum_le_288_of_sign
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (hsign : ∀ x y, IsSignVector x → IsSignVector y →
      bilinearValue A x y ≤ 1) :
    bipartiteUnitMaximum A ≤ 288 := by
  exact le_288_of_gaussian_unit_marginals_of_sign A
    (bipartiteUnitMaximum_nonneg A)
    (bipartiteUnitMaximum_universalPiNormBound A)
    hsign
    (bipartiteMaximizerRowDirection A)
    (bipartiteMaximizerColumnDirection A)
    (bipartiteUnitMaximum_eq_coordinate_sum A)

/-- The elementary Gaussian proof gives the universal Grothendieck constant
`288` in every universe. -/
theorem isGrothendieckConstant_288 : IsGrothendieckConstant.{u} 288 := by
  intro m n A hsign E _ _ X Y hX hY
  exact (innerBilinearValue_le_bipartiteUnitMaximum A X Y hX hY).trans
    (bipartiteUnitMaximum_le_288_of_sign A hsign)

end NumStability.HDP.Optimization
