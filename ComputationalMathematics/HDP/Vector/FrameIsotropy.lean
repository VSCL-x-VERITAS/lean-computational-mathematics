import ComputationalMathematics.HDP.Vector.Frame
import ComputationalMathematics.HDP.Vector.Isotropy
import Mathlib.Probability.HasLaw
import Mathlib.Probability.ProbabilityMassFunction.Integrals
import Mathlib.Probability.UniformOn

/-!
# Tight frames and isotropic finite laws

This module connects a finite tight frame with the probability law obtained by
choosing its index uniformly.  The index formulation deliberately retains
multiplicity when a frame family repeats a vector.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Vector.FrameIsotropy

/-- The law obtained by choosing an index of a positive-size finite vector
family uniformly.  Repeated family elements retain their index multiplicity. -/
def uniformFrameMeasure {N n : ℕ}
    (u : Fin N → Fin n → ℝ) : Measure (Fin n → ℝ) :=
  Measure.map u (ProbabilityTheory.uniformOn (Set.univ : Set (Fin N)))

instance {N n : ℕ} [NeZero N] (u : Fin N → Fin n → ℝ) :
    IsProbabilityMeasure (uniformFrameMeasure u) := by
  unfold uniformFrameMeasure
  exact Measure.isProbabilityMeasure_map (measurable_of_countable _).aemeasurable

/-- A random vector has the uniform frame law when its joint law is the image
of the uniform law on the frame's index type. -/
def HasUniformFrameLaw {Ω : Type*} [MeasurableSpace Ω] {N n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ)
    (u : Fin N → Fin n → ℝ) : Prop :=
  HasLaw (fun ω i ↦ X i ω) (uniformFrameMeasure u) μ

/-- The canonical uniform law on a tight frame becomes isotropic after the
normalization `sqrt (N / A)`. -/
theorem uniformFrameMeasure_scaled_isIsotropic {N n : ℕ} [NeZero N]
    (u : Fin N → Fin n → ℝ) (A : ℝ)
    (hFrame : NumStability.HDP.Vector.Frame.IsTightFrame u A) :
    NumStability.HDP.Vector.Isotropy.IsIsotropic (uniformFrameMeasure u)
      (fun j x ↦ Real.sqrt ((N : ℝ) / A) * x j) := by
  rw [NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul]
  intro i j
  unfold uniformFrameMeasure
  rw [integral_map (measurable_of_countable _).aemeasurable]
  · simp only [ProbabilityTheory.uniformOn, ProbabilityTheory.cond,
      integral_smul_measure, Measure.restrict_univ, Measure.count_apply_finite,
      Set.toFinite, integral_count]
    simp only [Set.toFinite_toFinset, Set.toFinset_univ, Finset.card_univ,
      Fintype.card_fin, ENNReal.toReal_inv, ENNReal.toReal_natCast, smul_eq_mul]
    have hA : 0 < A := hFrame.1
    have hN0 : (N : ℝ) ≠ 0 := by exact_mod_cast (NeZero.ne N)
    have hN : (0 : ℝ) < N := lt_of_le_of_ne (Nat.cast_nonneg N) (Ne.symm hN0)
    have hA0 : A ≠ 0 := ne_of_gt hA
    have hratio : 0 ≤ (N : ℝ) / A := div_nonneg hN.le hA.le
    have hsqrt : Real.sqrt ((N : ℝ) / A) ^ 2 = (N : ℝ) / A :=
      Real.sq_sqrt hratio
    have hM :=
      (NumStability.HDP.Vector.Frame.isTightFrame_iff_pos_and_sum_vecMulVec u A).1 hFrame
    have hij := congrFun (congrFun hM.2 i) j
    simp only [Matrix.sum_apply, Matrix.vecMulVec_apply, Matrix.smul_apply,
      Matrix.one_apply] at hij
    have hij' : ∑ x, u x i * u x j = if i = j then A else 0 := by
      simpa [smul_eq_mul] using hij
    have hsum :
        ∑ x, Real.sqrt ((N : ℝ) / A) * u x i *
            (Real.sqrt ((N : ℝ) / A) * u x j) =
          Real.sqrt ((N : ℝ) / A) ^ 2 * ∑ x, u x i * u x j := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro x _
      ring
    rw [hsum, hij']
    by_cases e : i = j
    · subst j
      simp only [↓reduceIte]
      rw [hsqrt]
      field_simp
    · simp [e]
  · fun_prop

/-- Any realization of the uniform law on a tight frame becomes isotropic
after the canonical normalization. -/
theorem isIsotropic_scaled_of_hasUniformFrameLaw
    {Ω : Type*} [MeasurableSpace Ω] {N n : ℕ} [NeZero N]
    {μ : Measure Ω} {X : Fin n → Ω → ℝ}
    (u : Fin N → Fin n → ℝ) (A : ℝ)
    (hFrame : NumStability.HDP.Vector.Frame.IsTightFrame u A)
    (hX : HasUniformFrameLaw μ X u) :
    NumStability.HDP.Vector.Isotropy.IsIsotropic μ
      (fun j ω ↦ Real.sqrt ((N : ℝ) / A) * X j ω) := by
  rw [NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul]
  intro i j
  have htransfer := hX.integral_comp
    (f := fun x : Fin n → ℝ ↦
      (Real.sqrt ((N : ℝ) / A) * x i) *
        (Real.sqrt ((N : ℝ) / A) * x j)) (by fun_prop)
  have hcanonical :=
    (NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul
      (uniformFrameMeasure u)
      (fun j x ↦ Real.sqrt ((N : ℝ) / A) * x j)).1
      (uniformFrameMeasure_scaled_isIsotropic u A hFrame) i j
  exact htransfer.trans hcanonical

/-- The probability mass function determined by nonnegative weights whose
finite sum is one. -/
def finiteWeightedPMF {N : ℕ} (p : Fin N → ℝ≥0)
    (hp : ∑ i, p i = 1) : PMF (Fin N) :=
  PMF.ofFintype (fun i ↦ (p i : ℝ≥0∞)) (by
    simpa only [← ENNReal.coe_finset_sum] using
      congrArg (fun q : ℝ≥0 ↦ (q : ℝ≥0∞)) hp)

/-- The finite vector law with indexed atoms `x i` and indexed weights `p i`.
Repeated atoms combine their weights under the pushforward. -/
def finiteWeightedVectorMeasure {N n : ℕ} (p : Fin N → ℝ≥0)
    (hp : ∑ i, p i = 1) (x : Fin N → Fin n → ℝ) : Measure (Fin n → ℝ) :=
  Measure.map x (finiteWeightedPMF p hp).toMeasure

instance {N n : ℕ} (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
    (x : Fin N → Fin n → ℝ) :
    IsProbabilityMeasure (finiteWeightedVectorMeasure p hp x) := by
  unfold finiteWeightedVectorMeasure
  exact Measure.isProbabilityMeasure_map (measurable_of_countable _).aemeasurable

/-- A random vector has a specified finite weighted law when its joint law is
the pushforward of the corresponding finite probability mass function. -/
def HasFiniteWeightedVectorLaw {Ω : Type*} [MeasurableSpace Ω]
    {N n : ℕ} (μ : Measure Ω) (X : Fin n → Ω → ℝ)
    (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
    (x : Fin N → Fin n → ℝ) : Prop :=
  HasLaw (fun ω i ↦ X i ω) (finiteWeightedVectorMeasure p hp x) μ

/-- If a finite weighted vector law is isotropic, scaling each atom by the
square root of its weight produces a tight frame with bound one. -/
theorem finiteWeightedVectorMeasure_sqrtWeights_isTightFrame
    {N n : ℕ} (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
    (x : Fin N → Fin n → ℝ)
    (hIso : NumStability.HDP.Vector.Isotropy.IsIsotropic
      (finiteWeightedVectorMeasure p hp x)
      (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j)) :
    NumStability.HDP.Vector.Frame.IsTightFrame
      (fun i ↦ Real.sqrt (p i : ℝ) • x i) 1 := by
  apply (NumStability.HDP.Vector.Frame.isTightFrame_iff_sum_vecMulVec _ one_pos).2
  ext j k
  have hMoment :=
    (NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul
      (finiteWeightedVectorMeasure p hp x)
      (fun j : Fin n ↦ fun y : Fin n → ℝ ↦ y j)).1 hIso j k
  unfold finiteWeightedVectorMeasure at hMoment
  rw [integral_map (measurable_of_countable _).aemeasurable] at hMoment
  · rw [PMF.integral_eq_sum] at hMoment
    simp only [finiteWeightedPMF, PMF.ofFintype_apply, ENNReal.coe_toReal,
      smul_eq_mul] at hMoment
    simp only [Matrix.sum_apply, Matrix.vecMulVec_apply, Pi.smul_apply, smul_eq_mul,
      Matrix.smul_apply, Matrix.one_apply, one_mul]
    rw [show (∑ i, (Real.sqrt (p i : ℝ) * x i j) *
          (Real.sqrt (p i : ℝ) * x i k)) =
        ∑ i, (p i : ℝ) * (x i j * x i k) by
      apply Finset.sum_congr rfl
      intro i _
      calc
        Real.sqrt (p i : ℝ) * x i j * (Real.sqrt (p i : ℝ) * x i k) =
            Real.sqrt (p i : ℝ) ^ 2 * (x i j * x i k) := by ring
        _ = (p i : ℝ) * (x i j * x i k) := by
          congr 1
          exact Real.sq_sqrt (p i).2]
    simpa using hMoment
  · fun_prop

/-- The preceding construction transported from any realization of the same
finite weighted law. -/
theorem isTightFrame_sqrtWeights_of_hasFiniteWeightedVectorLaw
    {Ω : Type*} [MeasurableSpace Ω] {N n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ}
    (p : Fin N → ℝ≥0) (hp : ∑ i, p i = 1)
    (x : Fin N → Fin n → ℝ)
    (hIso : NumStability.HDP.Vector.Isotropy.IsIsotropic μ X)
    (hLaw : HasFiniteWeightedVectorLaw μ X p hp x) :
    NumStability.HDP.Vector.Frame.IsTightFrame
      (fun i ↦ Real.sqrt (p i : ℝ) • x i) 1 := by
  apply finiteWeightedVectorMeasure_sqrtWeights_isTightFrame p hp x
  rw [NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul]
  intro j k
  have hTransfer := hLaw.integral_comp
    (f := fun y : Fin n → ℝ ↦ y j * y k) (by fun_prop)
  have hSource :=
    (NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul μ X).1 hIso j k
  exact hTransfer.symm.trans hSource

end NumStability.HDP.Vector.FrameIsotropy
