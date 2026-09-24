import ComputationalMathematics.HDP.Optimization.SignQuadratic
import ComputationalMathematics.HDP.Optimization.GrothendieckSymmetric
import ComputationalMathematics.HDP.Optimization.VectorQuadratic

/-!
# The elementary side of the Grothendieck relaxation guarantee

This module embeds sign solutions into the unit-vector relaxation, proving the
first inequality in Theorem 3.5.6.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Optimization

universe u

/-- Every Grothendieck constant is nonnegative. -/
theorem IsGrothendieckConstant.nonneg {K : ℝ}
    (hGroth : IsGrothendieckConstant.{u} K) : 0 ≤ K := by
  let A : Matrix (Fin 1) (Fin 1) ℝ := 0
  have hsign : ∀ x y, IsSignVector x → IsSignVector y →
      bilinearValue A x y ≤ 1 := by
    intro x y _hx _hy
    simp [A, bilinearValue]
  have hunit := hGroth A hsign
  let k : ULift.{u} (Fin 1) := ULift.up 0
  let e : EuclideanSpace ℝ (ULift.{u} (Fin 1)) :=
    EuclideanSpace.single k 1
  have he : ‖e‖ = 1 := by simp [e, k]
  have hone : ∀ _ : Fin 1, ‖e‖ = 1 := fun _ => he
  have hbound := hunit (EuclideanSpace ℝ (ULift.{u} (Fin 1)))
    (fun _ : Fin 1 => e) (fun _ : Fin 1 => e) hone hone
  simpa [A, innerBilinearValue] using hbound

/-- Homogeneous positive-semidefinite form of the symmetric Grothendieck
bound. The epsilon argument includes the case where the quadratic sign bound
`C` is zero. -/
theorem symmetricPosSemidefinite_grothendieck_bound_homogeneous
    (K : ℝ) (hGroth : IsGrothendieckConstant.{u} K)
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.PosSemidef)
    {C : ℝ} (hC : 0 ≤ C)
    (hquad : ∀ x, IsSignVector x → |bilinearValue A x x| ≤ C) :
    ∀ (E : Type u) [NormedAddCommGroup E] [InnerProductSpace ℝ E],
      ∀ (x y : Fin n → E),
        (∀ i, ‖x i‖ = 1) → (∀ j, ‖y j‖ = 1) →
          |innerBilinearValue A x y| ≤ 2 * K * C := by
  have hK : 0 ≤ K := hGroth.nonneg
  intro E _ _ x y hx hy
  have hscale : ∀ D : ℝ, C < D →
      |innerBilinearValue A x y| ≤ 2 * K * D := by
    intro D hCD
    have hD : 0 < D := hC.trans_lt hCD
    let AD : Matrix (Fin n) (Fin n) ℝ := D⁻¹ • A
    have hAD : AD.PosSemidef := hA.smul (inv_nonneg.mpr hD.le)
    have hquadD : ∀ z, IsSignVector z → |bilinearValue AD z z| ≤ 1 := by
      intro z hz
      have hzbound := hquad z hz
      rw [show AD = D⁻¹ • A by rfl, bilinearValue_smul_matrix,
        abs_mul, abs_inv, abs_of_pos hD]
      calc
        D⁻¹ * |bilinearValue A z z| ≤ D⁻¹ * C := by gcongr
        _ ≤ D⁻¹ * D := by gcongr
        _ = 1 := inv_mul_cancel₀ hD.ne'
    have hADsymm : AD.IsSymm := by
      apply Matrix.IsSymm.ext
      intro i j
      have hij := hAD.isHermitian.apply i j
      simpa [Matrix.conjTranspose_apply] using hij
    have hs := symmetricQuadratic_grothendieck_bound K hGroth AD
      hADsymm (Or.inl hAD) hquadD E x y hx hy
    rw [show AD = D⁻¹ • A by rfl, innerBilinearValue_smul_matrix,
      abs_mul, abs_inv, abs_of_pos hD] at hs
    have hs' : |innerBilinearValue A x y| / D ≤ 2 * K := by
      simpa [div_eq_inv_mul, mul_comm] using hs
    have := (div_le_iff₀ hD).mp hs'
    nlinarith
  apply le_of_forall_pos_le_add
  intro ε hε
  have hden : 0 < 2 * K + 1 := by nlinarith
  let δ : ℝ := ε / (2 * K + 1)
  have hδ : 0 < δ := div_pos hε hden
  have hraw := hscale (C + δ) (lt_add_of_pos_right C hδ)
  have hsmall : 2 * K * δ ≤ ε := by
    have hratio : 2 * K / (2 * K + 1) ≤ 1 :=
      (div_le_one hden).2 (by linarith)
    calc
      2 * K * δ = (2 * K / (2 * K + 1)) * ε := by
        dsimp [δ]
        ring
      _ ≤ 1 * ε := mul_le_mul_of_nonneg_right hratio hε.le
      _ = ε := one_mul ε
  calc
    |innerBilinearValue A x y| ≤ 2 * K * (C + δ) := hraw
    _ = 2 * K * C + 2 * K * δ := by ring
    _ ≤ 2 * K * C + ε := by gcongr

/-- Regard a finite `SignVector` as a real sign vector. -/
def realVectorOfSign {n : ℕ} (x : SignVector n) : Fin n → ℝ :=
  fun i ↦ (x i).value

theorem realVectorOfSign_isSignVector {n : ℕ} (x : SignVector n) :
    IsSignVector (realVectorOfSign x) := by
  intro i
  cases hi : x i <;> simp [realVectorOfSign, hi]

theorem bilinearValue_realVectorOfSign {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (x : SignVector n) :
    bilinearValue A (realVectorOfSign x) (realVectorOfSign x) =
      signQuadraticValue A x := by
  rfl

/-- Choose the corresponding finite sign at each coordinate of a real sign
vector. Outside the sign cube this convention chooses the negative sign. -/
def signVectorOfReal {n : ℕ} (x : Fin n → ℝ) : SignVector n :=
  fun i ↦ if x i = 1 then .pos else .neg

theorem signVectorOfReal_value_of_isSignVector {n : ℕ}
    (x : Fin n → ℝ) (hx : IsSignVector x) (i : Fin n) :
    (signVectorOfReal x i).value = x i := by
  rcases hx i with hi | hi
  · simp [signVectorOfReal, hi]
  · norm_num [signVectorOfReal, hi]

theorem signQuadraticValue_signVectorOfReal {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (x : Fin n → ℝ)
    (hx : IsSignVector x) :
    signQuadraticValue A (signVectorOfReal x) = bilinearValue A x x := by
  unfold signQuadraticValue bilinearValue
  apply Finset.sum_congr rfl
  intro i _hi
  apply Finset.sum_congr rfl
  intro j _hj
  rw [signVectorOfReal_value_of_isSignVector x hx i,
    signVectorOfReal_value_of_isSignVector x hx j]

theorem bilinearValue_self_nonneg_of_posSemidef {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.PosSemidef)
    (x : Fin n → ℝ) :
    0 ≤ bilinearValue A x x := by
  rw [bilinearValue_eq_toBilin, Matrix.toBilin'_apply']
  simpa using hA.dotProduct_mulVec_nonneg x

theorem signQuadraticMaximum_nonneg_of_posSemidef {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.PosSemidef) :
    0 ≤ signQuadraticMaximum A := by
  let x : SignVector n := fun _ ↦ .pos
  have hx : 0 ≤ signQuadraticValue A x := by
    rw [← bilinearValue_realVectorOfSign]
    exact bilinearValue_self_nonneg_of_posSemidef A hA _
  exact hx.trans (signQuadraticValue_le_maximum A x)

theorem quadratic_abs_le_signQuadraticMaximum_of_posSemidef {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.PosSemidef)
    (x : Fin n → ℝ) (hx : IsSignVector x) :
    |bilinearValue A x x| ≤ signQuadraticMaximum A := by
  rw [abs_of_nonneg (bilinearValue_self_nonneg_of_posSemidef A hA x),
    ← signQuadraticValue_signVectorOfReal A x hx]
  exact signQuadraticValue_le_maximum A _

/-- Embed every sign as a unit vector along one fixed Euclidean coordinate. -/
noncomputable def signUnitVectorFamily {n : ℕ} [Nonempty (Fin n)]
    (x : SignVector n) : UnitVectorFamily n :=
  let k : Fin n := Classical.choice inferInstance
  fun i => ⟨EuclideanSpace.single k (x i).value, by
    cases x i <;> simp⟩

theorem vectorQuadraticValue_signUnitVectorFamily {n : ℕ}
    [Nonempty (Fin n)] (A : Matrix (Fin n) (Fin n) ℝ)
    (x : SignVector n) :
    vectorQuadraticValue A (signUnitVectorFamily x) =
      signQuadraticValue A x := by
  let k : Fin n := Classical.choice inferInstance
  unfold vectorQuadraticValue signQuadraticValue signUnitVectorFamily
  apply Finset.sum_congr rfl
  intro i _hi
  apply Finset.sum_congr rfl
  intro j _hj
  change A i j *
      ⟪EuclideanSpace.single k (x i).value,
        EuclideanSpace.single k (x j).value⟫_ℝ =
    A i j * (x i).value * (x j).value
  have hinner :
      ⟪EuclideanSpace.single k (x i).value,
        EuclideanSpace.single k (x j).value⟫_ℝ =
        (x i).value * (x j).value := by
    rw [PiLp.inner_apply]
    classical
    rw [Finset.sum_eq_single k]
    · simpa [EuclideanSpace.single_apply] using
        (RCLike.inner_apply' (x i).value (x j).value)
    · intro b _hb hbk
      simp [EuclideanSpace.single_apply, hbk]
    · simp
  rw [hinner]
  ring

/-- Every feasible sign solution is feasible for the unit-vector relaxation,
so the integer optimum is at most the semidefinite/vector optimum. -/
theorem signQuadraticMaximum_le_vectorQuadraticMaximum {n : ℕ}
    [Nonempty (Fin n)] (A : Matrix (Fin n) (Fin n) ℝ) :
    signQuadraticMaximum A ≤ vectorQuadraticMaximum A := by
  obtain ⟨x, hx⟩ := exists_signQuadraticValue_eq_maximum A
  rw [← hx, ← vectorQuadraticValue_signUnitVectorFamily]
  exact vectorQuadraticValue_le_maximum A (signUnitVectorFamily x)

/-- The upper half of Theorem 3.5.6: the unit-vector relaxation of a symmetric
positive-semidefinite quadratic form is at most twice the Grothendieck constant
times its sign optimum. -/
theorem vectorQuadraticMaximum_le_two_mul_grothendieck_mul_signQuadraticMaximum
    {n : ℕ} [Nonempty (Fin n)] (K : ℝ)
    (hGroth : IsGrothendieckConstant.{0} K)
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.PosSemidef) :
    vectorQuadraticMaximum A ≤ 2 * K * signQuadraticMaximum A := by
  let X : UnitVectorFamily n := vectorQuadraticMaximizer A
  let x : Fin n → EuclideanSpace ℝ (Fin n) := fun i ↦ X i
  have hx : ∀ i, ‖x i‖ = 1 := by
    intro i
    simp [x]
  have hbound := symmetricPosSemidefinite_grothendieck_bound_homogeneous
    K hGroth A hA (signQuadraticMaximum_nonneg_of_posSemidef A hA)
    (quadratic_abs_le_signQuadraticMaximum_of_posSemidef A hA)
    (EuclideanSpace ℝ (Fin n)) x x hx hx
  have hvalue :
      innerBilinearValue A x x = vectorQuadraticMaximum A := by
    rfl
  rw [hvalue] at hbound
  exact (le_abs_self _).trans hbound

/-- Theorem 3.5.6: for a symmetric positive-semidefinite matrix, the finite
sign optimum is bounded by its unit-vector relaxation, which is in turn within
the factor `2 * K` supplied by any Grothendieck constant `K`. Symmetry is
already included in `Matrix.PosSemidef`. -/
theorem grothendieck_relaxation_guarantee {n : ℕ} [Nonempty (Fin n)]
    (K : ℝ) (hGroth : IsGrothendieckConstant.{0} K)
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.PosSemidef) :
    signQuadraticMaximum A ≤ vectorQuadraticMaximum A ∧
      vectorQuadraticMaximum A ≤ 2 * K * signQuadraticMaximum A :=
  ⟨signQuadraticMaximum_le_vectorQuadraticMaximum A,
    vectorQuadraticMaximum_le_two_mul_grothendieck_mul_signQuadraticMaximum
      K hGroth A hA⟩

end NumStability.HDP.Optimization
