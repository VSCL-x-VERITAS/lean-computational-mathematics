import ComputationalMathematics.HDP.Optimization.GrothendieckHilbert
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Matrix.Order
import Mathlib.LinearAlgebra.BilinearForm.Properties
import Mathlib.LinearAlgebra.Matrix.BilinearForm

/-!
# Symmetric Grothendieck reductions

This module develops the polarization foundations used to reduce the symmetric
quadratic form of Exercise 3.5.3 to a bilinear Grothendieck bound.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Optimization

variable {n : ℕ}

/-- The elementary finite-sum bilinear value agrees with Mathlib's bilinear
form associated to the same matrix. -/
theorem bilinearValue_eq_toBilin (A : Matrix (Fin n) (Fin n) ℝ)
    (x y : Fin n → ℝ) :
    bilinearValue A x y = Matrix.toBilin' A x y := by
  rw [Matrix.toBilin'_apply]
  unfold bilinearValue
  apply Finset.sum_congr rfl
  intro i _hi
  apply Finset.sum_congr rfl
  intro j _hj
  ring

/-- A symmetric matrix induces a symmetric bilinear form on its coordinate
space. -/
theorem toBilin_isSymm (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsSymm) :
    (Matrix.toBilin' A).IsSymm := by
  constructor
  intro x y
  simp only [Matrix.toBilin'_apply]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _hi
  apply Finset.sum_congr rfl
  intro j _hj
  rw [hA.apply]
  ring

/-- The polarization identity from the hint to Exercise 3.5.3, with
`u = (x + y) / 2` and `v = (x - y) / 2`. -/
theorem bilinearValue_polarization_of_isSymm
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsSymm)
    (x y : Fin n → ℝ) :
    bilinearValue A x y =
      bilinearValue A ((2 : ℝ)⁻¹ • (x + y)) ((2 : ℝ)⁻¹ • (x + y)) -
        bilinearValue A ((2 : ℝ)⁻¹ • (x - y)) ((2 : ℝ)⁻¹ • (x - y)) := by
  simp_rw [bilinearValue_eq_toBilin]
  let B := Matrix.toBilin' A
  have hB : B.IsSymm := toBilin_isSymm A hA
  change B x y =
    B ((2 : ℝ)⁻¹ • (x + y)) ((2 : ℝ)⁻¹ • (x + y)) -
      B ((2 : ℝ)⁻¹ • (x - y)) ((2 : ℝ)⁻¹ • (x - y))
  simp only [map_smul, LinearMap.smul_apply, map_add, map_sub,
    LinearMap.add_apply, LinearMap.sub_apply]
  rw [hB.eq y x]
  norm_num
  ring

/-- For a positive-semidefinite matrix, an absolute quadratic bound on sign
vectors already implies the corresponding absolute bilinear bound on two sign
vectors. This is the positive-semidefinite branch of the reduction in Exercise
3.5.3. -/
theorem bilinearValue_abs_le_one_of_posSemidef
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.PosSemidef)
    (hquad : ∀ x, IsSignVector x → |bilinearValue A x x| ≤ 1)
    (x y : Fin n → ℝ) (hx : IsSignVector x) (hy : IsSignVector y) :
    |bilinearValue A x y| ≤ 1 := by
  classical
  obtain ⟨B, hB⟩ := Matrix.posSemidef_iff_eq_conjTranspose_mul_self.mp hA
  let w : (Fin n → ℝ) → EuclideanSpace ℝ (Fin n) :=
    fun z => WithLp.toLp 2 (Matrix.mulVec B z)
  have hvalue : ∀ a b, bilinearValue A a b = ⟪w a, w b⟫_ℝ := by
    intro a b
    rw [bilinearValue_eq_toBilin, Matrix.toBilin'_apply', hB]
    change a ⬝ᵥ (B.transpose * B).mulVec b =
      ⟪WithLp.toLp 2 (B.mulVec a), WithLp.toLp 2 (B.mulVec b)⟫_ℝ
    rw [PiLp.inner_apply]
    rw [show (∑ i, ⟪B.mulVec a i, B.mulVec b i⟫_ℝ) =
        B.mulVec a ⬝ᵥ B.mulVec b by
      unfold dotProduct
      apply Finset.sum_congr rfl
      intro i _hi
      exact RCLike.inner_apply' _ _]
    rw [← Matrix.mulVec_mulVec, Matrix.dotProduct_mulVec,
      Matrix.vecMul_transpose]
  have hxnorm : ‖w x‖ ≤ 1 := by
    have hq : ⟪w x, w x⟫_ℝ ≤ 1 := by
      rw [← hvalue]
      exact (le_abs_self _).trans (hquad x hx)
    rw [real_inner_self_eq_norm_sq] at hq
    nlinarith [norm_nonneg (w x)]
  have hynorm : ‖w y‖ ≤ 1 := by
    have hq : ⟪w y, w y⟫_ℝ ≤ 1 := by
      rw [← hvalue]
      exact (le_abs_self _).trans (hquad y hy)
    rw [real_inner_self_eq_norm_sq] at hq
    nlinarith [norm_nonneg (w y)]
  rw [hvalue]
  exact (abs_real_inner_le_norm _ _).trans
    (by nlinarith [norm_nonneg (w x), norm_nonneg (w y)])

private lemma exists_sign_rounding_abs_ge
    {ι : Type*} [Fintype ι] [DecidableEq ι] (f : (ι → ℝ) → ℝ)
    (haverage : ∀ z i, |z i| ≤ 1 →
      f z = ((1 + z i) / 2) * f (Function.update z i 1) +
        ((1 - z i) / 2) * f (Function.update z i (-1)))
    (x : ι → ℝ) (hx : ∀ i, |x i| ≤ 1) :
    ∃ y : ι → ℝ, (∀ i, y i = 1 ∨ y i = -1) ∧ |f x| ≤ |f y| := by
  classical
  have hround : ∀ s : Finset ι, ∃ y : ι → ℝ,
      (∀ i ∈ s, y i = 1 ∨ y i = -1) ∧
      (∀ i ∉ s, y i = x i) ∧ |f x| ≤ |f y| := by
    intro s
    induction s using Finset.induction_on with
    | empty =>
        exact ⟨x, by simp, by simp, le_rfl⟩
    | @insert i s hi ih =>
        obtain ⟨y, hysign, hyout, hxy⟩ := ih
        have hiout : i ∉ s := hi
        have hyi : y i = x i := hyout i hiout
        have hycube : |y i| ≤ 1 := by simpa [hyi] using hx i
        let yp := Function.update y i 1
        let ym := Function.update y i (-1)
        let a := (1 + y i) / 2
        let b := (1 - y i) / 2
        have ha : 0 ≤ a := by
          dsimp [a]
          have := (abs_le.mp hycube).1
          linarith
        have hb : 0 ≤ b := by
          dsimp [b]
          have := (abs_le.mp hycube).2
          linarith
        have hab : a + b = 1 := by
          dsimp [a, b]
          ring
        have havg : f y = a * f yp + b * f ym := by
          simpa [a, b, yp, ym] using haverage y i hycube
        have habs : |f y| ≤ a * |f yp| + b * |f ym| := by
          rw [havg]
          calc
            |a * f yp + b * f ym| ≤ |a * f yp| + |b * f ym| :=
              abs_add_le _ _
            _ = a * |f yp| + b * |f ym| := by
              rw [abs_mul, abs_mul, abs_of_nonneg ha, abs_of_nonneg hb]
        by_cases hpm : |f yp| ≤ |f ym|
        · refine ⟨ym, ?_, ?_, hxy.trans (habs.trans ?_)⟩
          · intro j hj
            rcases Finset.mem_insert.mp hj with rfl | hjs
            · exact Or.inr (by simp [ym])
            · have hji : j ≠ i := by
                intro h
                subst j
                exact hi hjs
              simpa [ym, hji] using hysign j hjs
          · intro j hj
            have hji : j ≠ i := by
              intro h
              subst j
              exact hj (Finset.mem_insert_self i s)
            have hjs : j ∉ s := fun hmem => hj (Finset.mem_insert_of_mem hmem)
            simpa [ym, hji] using hyout j hjs
          · nlinarith [abs_nonneg (f yp), abs_nonneg (f ym)]
        · have hmp : |f ym| ≤ |f yp| := le_of_not_ge hpm
          refine ⟨yp, ?_, ?_, hxy.trans (habs.trans ?_)⟩
          · intro j hj
            rcases Finset.mem_insert.mp hj with rfl | hjs
            · exact Or.inl (by simp [yp])
            · have hji : j ≠ i := by
                intro h
                subst j
                exact hi hjs
              simpa [yp, hji] using hysign j hjs
          · intro j hj
            have hji : j ≠ i := by
              intro h
              subst j
              exact hj (Finset.mem_insert_self i s)
            have hjs : j ∉ s := fun hmem => hj (Finset.mem_insert_of_mem hmem)
            simpa [yp, hji] using hyout j hjs
          · nlinarith [abs_nonneg (f yp), abs_nonneg (f ym)]
  obtain ⟨y, hy, _hyout, hxy⟩ := hround Finset.univ
  exact ⟨y, fun i => hy i (Finset.mem_univ i), hxy⟩

/-- When the diagonal vanishes, the quadratic value is the barycentric
average of the two values obtained by rounding one coordinate to a sign. -/
theorem bilinearValue_coordinate_average_of_diag_zero
    (A : Matrix (Fin n) (Fin n) ℝ) (hdiag : ∀ i, A i i = 0)
    (x : Fin n → ℝ) (i : Fin n) :
    bilinearValue A x x =
      ((1 + x i) / 2) *
          bilinearValue A (Function.update x i 1) (Function.update x i 1) +
        ((1 - x i) / 2) *
          bilinearValue A (Function.update x i (-1))
            (Function.update x i (-1)) := by
  classical
  let B := Matrix.toBilin' A
  let z := Function.update x i 0
  let e : Fin n → ℝ := Pi.single i 1
  have hupdate (t : ℝ) : Function.update x i t = z + t • e := by
    ext j
    by_cases hji : j = i
    · subst j
      simp [z, e]
    · simp [z, e, hji]
  have hee : B e e = 0 := by
    dsimp [B, e]
    rw [Matrix.toBilin'_single, hdiag i]
  have hquad (t : ℝ) :
      B (Function.update x i t) (Function.update x i t) =
        B z z + t * B e z + t * B z e := by
    rw [hupdate]
    simp only [map_add, LinearMap.add_apply, map_smul, LinearMap.smul_apply,
      smul_eq_mul]
    rw [hee]
    ring
  simp_rw [bilinearValue_eq_toBilin]
  calc
    B x x = B (Function.update x i (x i)) (Function.update x i (x i)) := by
      rw [Function.update_eq_self]
    _ = B z z + x i * B e z + x i * B z e := hquad (x i)
    _ = ((1 + x i) / 2) *
          B (Function.update x i 1) (Function.update x i 1) +
        ((1 - x i) / 2) *
          B (Function.update x i (-1)) (Function.update x i (-1)) := by
      rw [hquad 1, hquad (-1)]
      ring

/-- For a zero-diagonal matrix, an absolute quadratic bound on sign vectors
extends to the entire coordinate cube. -/
theorem quadratic_abs_le_one_of_diag_zero
    (A : Matrix (Fin n) (Fin n) ℝ) (hdiag : ∀ i, A i i = 0)
    (hquad : ∀ x, IsSignVector x → |bilinearValue A x x| ≤ 1)
    (x : Fin n → ℝ) (hx : ∀ i, |x i| ≤ 1) :
    |bilinearValue A x x| ≤ 1 := by
  obtain ⟨y, hy, hxy⟩ := exists_sign_rounding_abs_ge
    (fun z => bilinearValue A z z)
    (fun z i _hi => bilinearValue_coordinate_average_of_diag_zero A hdiag z i)
    x hx
  exact hxy.trans (hquad y hy)

/-- For a symmetric zero-diagonal matrix, an absolute quadratic bound on sign
vectors implies the factor-two absolute bilinear sign bound from Exercise
3.5.3. -/
theorem bilinearValue_abs_le_two_of_diag_zero
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsSymm)
    (hdiag : ∀ i, A i i = 0)
    (hquad : ∀ x, IsSignVector x → |bilinearValue A x x| ≤ 1)
    (x y : Fin n → ℝ) (hx : IsSignVector x) (hy : IsSignVector y) :
    |bilinearValue A x y| ≤ 2 := by
  let u : Fin n → ℝ := (2 : ℝ)⁻¹ • (x + y)
  let v : Fin n → ℝ := (2 : ℝ)⁻¹ • (x - y)
  have hu : ∀ i, |u i| ≤ 1 := by
    intro i
    have hxi : |x i| ≤ 1 := by
      rcases hx i with h | h <;> simp [h]
    have hyi : |y i| ≤ 1 := by
      rcases hy i with h | h <;> simp [h]
    have hadd := abs_add_le (x i) (y i)
    dsimp [u]
    simp only [abs_mul]
    norm_num
    nlinarith
  have hv : ∀ i, |v i| ≤ 1 := by
    intro i
    have hxi : |x i| ≤ 1 := by
      rcases hx i with h | h <;> simp [h]
    have hyi : |y i| ≤ 1 := by
      rcases hy i with h | h <;> simp [h]
    have hsub := abs_sub (x i) (y i)
    dsimp [v]
    simp only [abs_mul]
    norm_num
    nlinarith
  rw [bilinearValue_polarization_of_isSymm A hA x y]
  change |bilinearValue A u u - bilinearValue A v v| ≤ 2
  calc
    |bilinearValue A u u - bilinearValue A v v| ≤
        |bilinearValue A u u| + |bilinearValue A v v| := abs_sub _ _
    _ ≤ 1 + 1 := add_le_add
      (quadratic_abs_le_one_of_diag_zero A hdiag hquad u hu)
      (quadratic_abs_le_one_of_diag_zero A hdiag hquad v hv)
    _ = 2 := by norm_num

universe u

/-- A number is a Grothendieck constant when every finite real bilinear form
bounded by one on sign vectors has the corresponding universal Hilbert-space
unit-vector bound. -/
def IsGrothendieckConstant (K : ℝ) : Prop :=
  ∀ {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ),
    (∀ x y, IsSignVector x → IsSignVector y → bilinearValue A x y ≤ 1) →
      UniversalUnitBound.{u} A K

theorem bilinearValue_smul_matrix (c : ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) (x y : Fin n → ℝ) :
    bilinearValue (c • A) x y = c * bilinearValue A x y := by
  unfold bilinearValue
  change (∑ i, ∑ j, (c * A i j) * x i * y j) =
    c * ∑ i, ∑ j, A i j * x i * y j
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _hi
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _hj
  ring

theorem innerBilinearValue_smul_matrix {E : Type*}
    [NormedAddCommGroup E] [InnerProductSpace ℝ E] (c : ℝ)
    (A : Matrix (Fin n) (Fin n) ℝ) (x y : Fin n → E) :
    innerBilinearValue (c • A) x y = c * innerBilinearValue A x y := by
  unfold innerBilinearValue
  change (∑ i, ∑ j, (c * A i j) * ⟪x i, y j⟫_ℝ) =
    c * ∑ i, ∑ j, A i j * ⟪x i, y j⟫_ℝ
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _hi
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _hj
  ring

theorem innerBilinearValue_neg_left {E : Type*}
    [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (A : Matrix (Fin n) (Fin n) ℝ) (x y : Fin n → E) :
    innerBilinearValue A (-x) y = -innerBilinearValue A x y := by
  unfold innerBilinearValue
  simp only [Pi.neg_apply, inner_neg_left, mul_neg, Finset.sum_neg_distrib]

/-- Exercise 3.5.3: a symmetric matrix that is positive semidefinite or has
zero diagonal inherits the absolute Hilbert-space bound `2 * K` from any
Grothendieck constant `K`, provided its quadratic sign form is absolutely
bounded by one. -/
theorem symmetricQuadratic_grothendieck_bound
    (K : ℝ) (hGroth : IsGrothendieckConstant.{u} K)
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsSymm)
    (hcase : A.PosSemidef ∨ ∀ i, A i i = 0)
    (hquad : ∀ x, IsSignVector x → |bilinearValue A x x| ≤ 1) :
    ∀ (E : Type u) [NormedAddCommGroup E] [InnerProductSpace ℝ E],
      ∀ (x y : Fin n → E),
        (∀ i, ‖x i‖ = 1) → (∀ j, ‖y j‖ = 1) →
          |innerBilinearValue A x y| ≤ 2 * K := by
  have hsignTwo : ∀ x y, IsSignVector x → IsSignVector y →
      |bilinearValue A x y| ≤ 2 := by
    intro x y hx hy
    rcases hcase with hpsd | hdiag
    · exact (bilinearValue_abs_le_one_of_posSemidef A hpsd hquad x y hx hy).trans
        (by norm_num)
    · exact bilinearValue_abs_le_two_of_diag_zero A hA hdiag hquad x y hx hy
  let Ahalf : Matrix (Fin n) (Fin n) ℝ := (2 : ℝ)⁻¹ • A
  have hsignHalf : ∀ x y, IsSignVector x → IsSignVector y →
      bilinearValue Ahalf x y ≤ 1 := by
    intro x y hx hy
    have htwo := hsignTwo x y hx hy
    have hone : bilinearValue A x y ≤ 2 := (le_abs_self _).trans htwo
    rw [show Ahalf = (2 : ℝ)⁻¹ • A by rfl, bilinearValue_smul_matrix]
    norm_num
    linarith
  have hunit : UniversalUnitBound.{u} Ahalf K := hGroth Ahalf hsignHalf
  intro E _ _ x y hx hy
  have hpos := hunit E x y hx hy
  have hxneg : ∀ i, ‖(-x) i‖ = 1 := by
    intro i
    simp [hx i]
  have hneg := hunit E (-x) y hxneg hy
  rw [show Ahalf = (2 : ℝ)⁻¹ • A by rfl,
    innerBilinearValue_smul_matrix] at hpos hneg
  rw [innerBilinearValue_neg_left] at hneg
  apply abs_le.mpr
  constructor <;> norm_num at hpos hneg ⊢ <;> nlinarith

end NumStability.HDP.Optimization
