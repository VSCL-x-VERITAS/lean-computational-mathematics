import ComputationalMathematics.HDP.Vector.Isotropy
import ComputationalMathematics.HDP.Vector.Moments

/-!
# Marginal and norm characterizations of isotropy

This module connects the second-moment-matrix definition of isotropy to
one-dimensional marginal moments and squared Euclidean norms.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Vector.Isotropy

/-- The second moment of the one-dimensional marginal of `X` in direction
`x`.  Finite vectors are represented by their coordinate functions, so the
inner product is the displayed finite sum. -/
def marginalSecondMoment {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) (x : Fin n → ℝ) : ℝ :=
  ∫ ω, (∑ i, X i ω * x i) ^ 2 ∂μ

/-- The marginal second moment is the quadratic form of the second-moment
matrix. -/
theorem marginalSecondMoment_eq_quadraticForm
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ)
    (hX : ∀ i j, Integrable (fun ω => X i ω * X j ω) μ)
    (x : Fin n → ℝ) :
    marginalSecondMoment μ X x =
      ∑ i, ∑ j, x i *
        NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X i j * x j := by
  unfold marginalSecondMoment
  have hterm : ∀ i j, Integrable (fun ω => x i * (X i ω * X j ω) * x j) μ := by
    intro i j
    exact ((hX i j).const_mul (x i)).mul_const (x j)
  calc
    (∫ ω, (∑ i, X i ω * x i) ^ 2 ∂μ) =
        ∫ ω, ∑ i, ∑ j, x i * (X i ω * X j ω) * x j ∂μ := by
          congr 1
          funext ω
          simp only [pow_two, Finset.sum_mul, Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          ring
    _ = ∑ i, ∫ ω, ∑ j, x i * (X i ω * X j ω) * x j ∂μ := by
          rw [integral_finset_sum]
          intro i _
          exact integrable_finset_sum _ (fun j _ => hterm i j)
    _ = ∑ i, ∑ j, ∫ ω, x i * (X i ω * X j ω) * x j ∂μ := by
          apply Finset.sum_congr rfl
          intro i _
          rw [integral_finset_sum]
          intro j _
          exact hterm i j
    _ = ∑ i, ∑ j, x i *
        NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X i j * x j := by
          simp only [NumStability.HDP.Vector.Covariance.secondMomentMatrix,
            integral_const_mul, integral_mul_const]

/-- Isotropy is equivalent to every one-dimensional marginal having second
moment equal to the squared norm of its direction. -/
theorem isIsotropic_iff_marginalSecondMoment
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ)
    (hX : ∀ i j, Integrable (fun ω => X i ω * X j ω) μ) :
    IsIsotropic μ X ↔
      ∀ x : Fin n → ℝ, marginalSecondMoment μ X x = ∑ i, (x i) ^ 2 := by
  classical
  constructor
  · intro h x
    rw [marginalSecondMoment_eq_quadraticForm μ X hX x, h]
    simp [pow_two, Matrix.one_apply, apply_ite]
  · intro h
    apply (isIsotropic_iff_integral_mul μ X).2
    intro i j
    by_cases hij : i = j
    · subst j
      have hi := h (Pi.single i (1 : ℝ))
      rw [marginalSecondMoment_eq_quadraticForm μ X hX] at hi
      simpa [NumStability.HDP.Vector.Covariance.secondMomentMatrix,
        Pi.single_apply] using hi
    · have hi := h (Pi.single i (1 : ℝ))
      have hj := h (Pi.single j (1 : ℝ))
      have hijsum := h (Pi.single i (1 : ℝ) + Pi.single j (1 : ℝ))
      rw [marginalSecondMoment_eq_quadraticForm μ X hX] at hi hj hijsum
      have hsym :
          NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X j i =
            NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X i j := by
        simp [NumStability.HDP.Vector.Covariance.secondMomentMatrix, mul_comm]
      simp [Pi.single_apply] at hi hj
      simp only [Pi.add_apply, Pi.single_apply] at hijsum
      simp_rw [mul_add, add_mul, Finset.sum_add_distrib] at hijsum
      simp_rw [show ∀ a b : ℝ, (a + b) ^ 2 = a ^ 2 + 2 * a * b + b ^ 2 by
        intro a b
        ring] at hijsum
      simp_rw [Finset.sum_add_distrib] at hijsum
      simp [Ne.symm hij] at hijsum
      have :
          NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X i j = 0 := by
        linarith
      simpa [NumStability.HDP.Vector.Covariance.secondMomentMatrix, hij] using this

/-- An isotropic finite random vector has expected squared Euclidean norm equal
to its dimension. -/
theorem integral_vecNorm2Sq_eq_card
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ}
    (hLp : ∀ i, MemLp (X i) 2 μ) (hX : IsIsotropic μ X) :
    (∫ ω, NumStability.vecNorm2Sq (fun i => X i ω) ∂μ) = n := by
  apply NumStability.HDP.Vector.Moments.expectation_vecNorm2Sq_eq_card μ X
  · intro i
    simpa [pow_two] using (hLp i).integrable_mul (hLp i)
  · exact integral_sq_coordinate hX

end NumStability.HDP.Vector.Isotropy
