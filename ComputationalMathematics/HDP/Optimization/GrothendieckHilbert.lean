import ComputationalMathematics.HDP.Optimization.GrothendieckBounds
import Mathlib.Analysis.InnerProductSpace.ProdL2

/-!
# Homogeneous Hilbert-space Grothendieck bounds

This module proves the Hilbert-space homogeneity reduction behind Exercise
3.5.2(b). A pair of contractions is padded along two orthogonal real
coordinates, producing unit vectors without changing their cross inner
products.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Optimization

universe u

variable {ι κ : Type*} [Fintype ι] [Fintype κ]

/-- The value of a finite matrix on two families in a real inner-product
space. -/
def innerBilinearValue {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] (A : Matrix ι κ ℝ)
    (u : ι → E) (v : κ → E) : ℝ :=
  ∑ i, ∑ j, A i j * ⟪u i, v j⟫_ℝ

/-- The conclusion of Grothendieck's inequality restricted to unit-vector
families. -/
def UniversalUnitBound (A : Matrix ι κ ℝ) (K : ℝ) : Prop :=
  ∀ (E : Type u) [NormedAddCommGroup E] [InnerProductSpace ℝ E],
    ∀ (u : ι → E) (v : κ → E),
      (∀ i, ‖u i‖ = 1) → (∀ j, ‖v j‖ = 1) →
        innerBilinearValue A u v ≤ K

/-- The homogeneous Pi-sup-norm formulation of the Hilbert-space conclusion
of Grothendieck's inequality. -/
def UniversalPiNormBound (A : Matrix ι κ ℝ) (K : ℝ) : Prop :=
  ∀ (E : Type u) [NormedAddCommGroup E] [InnerProductSpace ℝ E],
    ∀ (u : ι → E) (v : κ → E),
      innerBilinearValue A u v ≤ K * ‖u‖ * ‖v‖

private lemma innerBilinearValue_smul_left {E : Type*}
    [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (A : Matrix ι κ ℝ) (c : ℝ) (u : ι → E) (v : κ → E) :
    innerBilinearValue A (c • u) v = c * innerBilinearValue A u v := by
  unfold innerBilinearValue
  simp only [Pi.smul_apply, real_inner_smul_left]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _hi
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _hj
  ring

private lemma innerBilinearValue_smul_right {E : Type*}
    [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (A : Matrix ι κ ℝ) (c : ℝ) (u : ι → E) (v : κ → E) :
    innerBilinearValue A u (c • v) = c * innerBilinearValue A u v := by
  unfold innerBilinearValue
  simp only [Pi.smul_apply, real_inner_smul_right]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _hi
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _hj
  ring

private abbrev PadSpace (E : Type*) :=
  WithLp 2 (WithLp 2 (E × ℝ) × ℝ)

private def padLeft {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] (x : E) : PadSpace E :=
  WithLp.toLp 2
    (WithLp.toLp 2 (x, Real.sqrt (1 - ‖x‖ ^ 2)), 0)

private def padRight {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] (y : E) : PadSpace E :=
  WithLp.toLp 2
    (WithLp.toLp 2 (y, 0), Real.sqrt (1 - ‖y‖ ^ 2))

private lemma norm_padLeft {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] (x : E) (hx : ‖x‖ ≤ 1) :
    ‖padLeft x‖ = 1 := by
  have hsub : 0 ≤ 1 - ‖x‖ ^ 2 := by
    nlinarith [norm_nonneg x]
  apply sq_eq_sq₀ (norm_nonneg _) zero_le_one |>.mp
  rw [WithLp.prod_norm_sq_eq_of_L2]
  change ‖(WithLp.toLp 2 (x, Real.sqrt (1 - ‖x‖ ^ 2)) :
      WithLp 2 (E × ℝ))‖ ^ 2 + ‖(0 : ℝ)‖ ^ 2 = 1 ^ 2
  rw [WithLp.prod_norm_sq_eq_of_L2]
  simp [Real.sq_sqrt hsub]

private lemma norm_padRight {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] (y : E) (hy : ‖y‖ ≤ 1) :
    ‖padRight y‖ = 1 := by
  have hsub : 0 ≤ 1 - ‖y‖ ^ 2 := by
    nlinarith [norm_nonneg y]
  apply sq_eq_sq₀ (norm_nonneg _) zero_le_one |>.mp
  rw [WithLp.prod_norm_sq_eq_of_L2]
  change ‖(WithLp.toLp 2 (y, (0 : ℝ)) : WithLp 2 (E × ℝ))‖ ^ 2 +
      ‖Real.sqrt (1 - ‖y‖ ^ 2)‖ ^ 2 = 1 ^ 2
  rw [WithLp.prod_norm_sq_eq_of_L2]
  simp [Real.sq_sqrt hsub, abs_of_nonneg (Real.sqrt_nonneg _)]

private lemma inner_padLeft_padRight {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] (x y : E) :
    ⟪padLeft x, padRight y⟫_ℝ = ⟪x, y⟫_ℝ := by
  rw [WithLp.prod_inner_apply]
  rw [WithLp.prod_inner_apply]
  simp [padLeft, padRight]

/-- Exercise 3.5.2(b), display (3.13): for a nonnegative constant, the
universal unit-vector bound is equivalent to its homogeneous Pi-sup-norm
formulation. -/
theorem universalUnitBound_iff_universalPiNormBound
    (A : Matrix ι κ ℝ) (K : ℝ) (hK : 0 ≤ K) :
    UniversalUnitBound.{u} A K ↔ UniversalPiNormBound.{u} A K := by
  constructor
  · intro hunit E _ _ u v
    by_cases hu0 : ‖u‖ = 0
    · have hu : u = 0 := norm_eq_zero.mp hu0
      subst u
      simp [innerBilinearValue]
    by_cases hv0 : ‖v‖ = 0
    · have hv : v = 0 := norm_eq_zero.mp hv0
      subst v
      simp [innerBilinearValue]
    have hupos : 0 < ‖u‖ := lt_of_le_of_ne (norm_nonneg u) (Ne.symm hu0)
    have hvpos : 0 < ‖v‖ := lt_of_le_of_ne (norm_nonneg v) (Ne.symm hv0)
    let un : ι → E := ‖u‖⁻¹ • u
    let vn : κ → E := ‖v‖⁻¹ • v
    have hun_le : ∀ i, ‖un i‖ ≤ 1 := by
      intro i
      dsimp [un]
      rw [norm_smul, Real.norm_eq_abs, abs_inv, abs_norm]
      rw [inv_mul_le_one₀ hupos]
      exact norm_le_pi_norm u i
    have hvn_le : ∀ j, ‖vn j‖ ≤ 1 := by
      intro j
      dsimp [vn]
      rw [norm_smul, Real.norm_eq_abs, abs_inv, abs_norm]
      rw [inv_mul_le_one₀ hvpos]
      exact norm_le_pi_norm v j
    let up : ι → PadSpace E := fun i => padLeft (un i)
    let vp : κ → PadSpace E := fun j => padRight (vn j)
    have hup : ∀ i, ‖up i‖ = 1 := by
      intro i
      exact norm_padLeft (un i) (hun_le i)
    have hvp : ∀ j, ‖vp j‖ = 1 := by
      intro j
      exact norm_padRight (vn j) (hvn_le j)
    have hpad := hunit (PadSpace E) up vp hup hvp
    have hpadValue :
        innerBilinearValue A up vp = innerBilinearValue A un vn := by
      unfold innerBilinearValue
      apply Finset.sum_congr rfl
      intro i _hi
      apply Finset.sum_congr rfl
      intro j _hj
      change A i j * ⟪padLeft (un i), padRight (vn j)⟫_ℝ =
        A i j * ⟪un i, vn j⟫_ℝ
      rw [inner_padLeft_padRight]
    have hscale :
        innerBilinearValue A un vn =
          (‖u‖ * ‖v‖)⁻¹ * innerBilinearValue A u v := by
      rw [show un = ‖u‖⁻¹ • u by rfl,
        show vn = ‖v‖⁻¹ • v by rfl,
        innerBilinearValue_smul_left,
        innerBilinearValue_smul_right]
      field_simp
    rw [hpadValue, hscale] at hpad
    have hprodpos : 0 < ‖u‖ * ‖v‖ := mul_pos hupos hvpos
    have hscaled := (inv_mul_le_iff₀ hprodpos).mp hpad
    nlinarith [hscaled]
  · intro hnorm E _ _ u v hu hv
    have hunorm : ‖u‖ ≤ 1 :=
      (pi_norm_le_iff_of_nonneg zero_le_one).2 fun i => by
        rw [hu i]
    have hvnorm : ‖v‖ ≤ 1 :=
      (pi_norm_le_iff_of_nonneg zero_le_one).2 fun j => by
        rw [hv j]
    calc
      innerBilinearValue A u v ≤ K * ‖u‖ * ‖v‖ := hnorm E u v
      _ ≤ K * 1 * 1 := by gcongr
      _ = K := by ring

end NumStability.HDP.Optimization
