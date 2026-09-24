import ComputationalMathematics.HDP.Tensor.Finite
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Data.Fintype.BigOperators

/-!
# Finite polynomial tensor features

Concrete Euclidean feature spaces obtained by adjoining tensor powers.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Tensor

/-- The disjoint coordinate set for second- and third-order tensor features. -/
abbrev QuadraticCubicIndex (n : ℕ) :=
  (Fin 2 → Fin n) ⊕ (Fin 3 → Fin n)

/-- The finite-dimensional real Hilbert space carrying quadratic and cubic
tensor features. -/
abbrev QuadraticCubicFeatureSpace (n : ℕ) :=
  EuclideanSpace ℝ (QuadraticCubicIndex n)

/-- The direct-sum feature map `sqrt 2 * u^⊗2 ⊕ sqrt 5 * u^⊗3`. -/
def quadraticCubicFeature {n : ℕ} (u : Fin n → ℝ) :
    QuadraticCubicFeatureSpace n :=
  WithLp.toLp 2 (Sum.elim
    (fun i => Real.sqrt 2 * power u 2 i)
    (fun i => Real.sqrt 5 * power u 3 i))

/-- The quadratic-cubic feature inner product realizes
`2 * ⟪u,v⟫^2 + 5 * ⟪u,v⟫^3`. -/
theorem quadraticCubicFeature_inner {n : ℕ} (u v : Fin n → ℝ) :
    ⟪quadraticCubicFeature u, quadraticCubicFeature v⟫_ℝ =
      2 * (∑ i, u i * v i) ^ 2 + 5 * (∑ i, u i * v i) ^ 3 := by
  simp only [PiLp.inner_apply, quadraticCubicFeature,
    Fintype.sum_sum_type, Sum.elim_inl, Sum.elim_inr]
  change (∑ x, (Real.sqrt 2 * power v 2 x) *
      (Real.sqrt 2 * power u 2 x)) +
    (∑ x, (Real.sqrt 5 * power v 3 x) *
      (Real.sqrt 5 * power u 3 x)) = _
  have hterm2 (x : Fin 2 → Fin n) :
      (Real.sqrt 2 * power v 2 x) * (Real.sqrt 2 * power u 2 x) =
        (Real.sqrt 2 * Real.sqrt 2) * (power u 2 x * power v 2 x) := by
    ring
  have hterm3 (x : Fin 3 → Fin n) :
      (Real.sqrt 5 * power v 3 x) * (Real.sqrt 5 * power u 3 x) =
        (Real.sqrt 5 * Real.sqrt 5) * (power u 3 x * power v 3 x) := by
    ring
  rw [Finset.sum_congr rfl (fun x _ => hterm2 x),
    Finset.sum_congr rfl (fun x _ => hterm3 x)]
  rw [← Finset.mul_sum, ← Finset.mul_sum]
  have h2 : Real.sqrt 2 * Real.sqrt 2 = (2 : ℝ) := by norm_num
  have h5 : Real.sqrt 5 * Real.sqrt 5 = (5 : ℝ) := by norm_num
  rw [h2, h5]
  change 2 * inner (power u 2) (power v 2) +
      5 * inner (power u 3) (power v 3) = _
  rw [inner_power_power, inner_power_power]

/-- The disjoint coordinate set for tensor powers through degree `d`. -/
abbrev PolynomialFeatureIndex (n d : ℕ) :=
  Σ k : Fin (d + 1), Fin k.1 → Fin n

/-- The finite-dimensional real Hilbert space containing tensor powers through
degree `d` as orthogonal coordinate blocks. -/
abbrev PolynomialFeatureSpace (n d : ℕ) :=
  EuclideanSpace ℝ (PolynomialFeatureIndex n d)

/-- The feature map obtained by scaling the degree-`k` tensor block by
`sqrt (a k)`. -/
def polynomialFeature {n d : ℕ} (a : Fin (d + 1) → ℝ)
    (u : Fin n → ℝ) : PolynomialFeatureSpace n d :=
  WithLp.toLp 2 (fun i ↦ Real.sqrt (a i.1) * power u i.1 i.2)

/-- A polynomial with nonnegative coefficients is the inner-product kernel of
its finite direct sum of scaled tensor-power features. -/
theorem polynomialFeature_inner {n d : ℕ} (a : Fin (d + 1) → ℝ)
    (ha : ∀ k, 0 ≤ a k) (u v : Fin n → ℝ) :
    ⟪polynomialFeature a u, polynomialFeature a v⟫_ℝ =
      ∑ k, a k * (∑ i, u i * v i) ^ k.1 := by
  simp only [PiLp.inner_apply, polynomialFeature]
  change (∑ x : PolynomialFeatureIndex n d,
      (Real.sqrt (a x.1) * power v x.1 x.2) *
        (Real.sqrt (a x.1) * power u x.1 x.2)) = _
  rw [Fintype.sum_sigma]
  apply Finset.sum_congr rfl
  intro k _
  have hterm (i : Fin k.1 → Fin n) :
      (Real.sqrt (a k) * power v k.1 i) *
          (Real.sqrt (a k) * power u k.1 i) =
        (Real.sqrt (a k) * Real.sqrt (a k)) *
          (power u k.1 i * power v k.1 i) := by
    ring
  rw [Finset.sum_congr rfl (fun i _ ↦ hterm i), ← Finset.mul_sum,
    Real.mul_self_sqrt (ha k)]
  change a k * inner (power u k.1) (power v k.1) = _
  rw [inner_power_power]

end NumStability.HDP.Tensor
