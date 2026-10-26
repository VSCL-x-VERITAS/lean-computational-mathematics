/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.Positivity
import ComputationalMathematics.Analysis.Convex.Triangle.Coordinates
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Algebra.Star.Module
import Mathlib.Algebra.GroupWithZero.Invertible
import Mathlib.Tactic.Ring

/-!
# Fixed operators for real affine expectations

Canonical Cartesian parts and operator lifts of real affine functions of the
numerical range, with quadratic-form and positivity identities.
-/
set_option autoImplicit false
open scoped ComplexConjugate
universe u
namespace NumStability.ContractionAffineConstruction
noncomputable section
variable {H : Type u} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
variable [FiniteDimensional ℂ H]

-- Internal field witness; no public declaration acquires an invertibility hypothesis.
local instance : Invertible (2 : ℝ) :=
  invertibleOfNonzero (two_ne_zero : (2 : ℝ) ≠ 0)

/-- The real Cartesian part `(A + A.adjoint) / 2`. -/
def realPartOperator (A : H →ₗ[ℂ] H) : H →ₗ[ℂ] H :=
  (selfAdjointPart ℝ A : H →ₗ[ℂ] H)

/-- The imaginary Cartesian part `(A - A.adjoint) / (2 I)`. -/
def imagPartOperator (A : H →ₗ[ℂ] H) : H →ₗ[ℂ] H :=
  (-Complex.I) • (skewAdjointPart ℝ A : H →ₗ[ℂ] H)

/-- Formula expansion of the canonical real Cartesian producer. -/
theorem realPartOperator_eq (A : H →ₗ[ℂ] H) :
    realPartOperator A = ((1 / 2 : ℝ) : ℂ) • (A + A.adjoint) := by
  unfold realPartOperator
  rw [selfAdjointPart_apply_coe, invOf_eq_inv, LinearMap.star_eq_adjoint]
  ext x
  change (((2 : ℝ)⁻¹ : ℝ) : ℂ) • (A x + A.adjoint x) =
    ((1 / 2 : ℝ) : ℂ) • (A x + A.adjoint x)
  simp only [one_div]

/-- Formula expansion of `-I` times the canonical skew-adjoint producer. -/
theorem imagPartOperator_eq (A : H →ₗ[ℂ] H) :
    imagPartOperator A =
      (((-1 / 2 : ℝ) : ℂ) * Complex.I) • (A - A.adjoint) := by
  unfold imagPartOperator
  rw [skewAdjointPart_apply_coe, invOf_eq_inv, LinearMap.star_eq_adjoint]
  ext x
  change (-Complex.I) • ((((2 : ℝ)⁻¹ : ℝ) : ℂ) • (A x - A.adjoint x)) =
    (((-1 / 2 : ℝ) : ℂ) * Complex.I) • (A x - A.adjoint x)
  rw [smul_smul]
  congr 1
  simp only [neg_div, one_div, Complex.ofReal_neg]
  ring

theorem quadratic_adjoint_conj (A : H →ₗ[ℂ] H) (x : H) :
    inner ℂ x (A.adjoint x) = conj (inner ℂ x (A x)) := by
  rw [LinearMap.adjoint_inner_right]
  exact (inner_conj_symm (𝕜 := ℂ) (A x) x).symm

theorem quadratic_realPartOperator (A : H →ₗ[ℂ] H) (x : H) :
    inner ℂ x (realPartOperator A x) = ((inner ℂ x (A x)).re : ℂ) := by
  simp only [realPartOperator_eq, LinearMap.smul_apply, LinearMap.add_apply,
    inner_smul_right, inner_add_right, quadratic_adjoint_conj]
  apply Complex.ext <;>
    simp only [Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.conj_re, Complex.conj_im] <;> ring

theorem quadratic_imagPartOperator (A : H →ₗ[ℂ] H) (x : H) :
    inner ℂ x (imagPartOperator A x) = ((inner ℂ x (A x)).im : ℂ) := by
  simp only [imagPartOperator_eq, LinearMap.smul_apply, LinearMap.sub_apply,
    inner_smul_right, inner_sub_right, quadratic_adjoint_conj]
  apply Complex.ext <;>
    simp only [Complex.mul_re, Complex.mul_im, Complex.sub_re, Complex.sub_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.conj_re, Complex.conj_im,
      Complex.I_re, Complex.I_im] <;> ring

/-- The operator for the fixed real affine functional `c + a re(z) + b im(z)`.
Its definition is independent of the vector on which it is evaluated. -/
def fixedAffineOperator (A : H →ₗ[ℂ] H) (c a b : ℝ) : H →ₗ[ℂ] H :=
  (c : ℂ) • LinearMap.id +
    (a : ℂ) • realPartOperator A + (b : ℂ) • imagPartOperator A

theorem quadratic_fixedAffineOperator (A : H →ₗ[ℂ] H) (c a b : ℝ) (x : H) :
    inner ℂ x (fixedAffineOperator A c a b x) =
      ((c * ‖x‖ ^ 2 + a * (inner ℂ x (A x)).re +
        b * (inner ℂ x (A x)).im : ℝ) : ℂ) := by
  have hself : inner ℂ x x = (‖x‖ : ℂ) ^ 2 := inner_self_eq_norm_sq_to_K x
  simp only [fixedAffineOperator, LinearMap.add_apply, LinearMap.smul_apply,
    LinearMap.id_apply, inner_add_right, inner_smul_right,
    quadratic_realPartOperator, quadratic_imagPartOperator, hself,
    Complex.ofReal_add, Complex.ofReal_mul, Complex.ofReal_pow]

theorem isPositive_fixedAffineOperator_of_unit_sphere
    (A : H →ₗ[ℂ] H) (c a b : ℝ)
    (h : ∀ v : H, ‖v‖ = 1 →
      0 ≤ c + a * (inner ℂ v (A v)).re + b * (inner ℂ v (A v)).im) :
    LinearMap.IsPositive (fixedAffineOperator A c a b) := by
  apply isPositive_of_unit_sphere
  intro v hv
  have hq : inner ℂ v (fixedAffineOperator A c a b v) =
      ((c + a * (inner ℂ v (A v)).re + b * (inner ℂ v (A v)).im : ℝ) : ℂ) := by
    simpa only [hv, one_pow, mul_one] using quadratic_fixedAffineOperator A c a b v
  rw [hq]
  constructor
  · simp only [Complex.ofReal_re]
  · simpa only [Complex.ofReal_re] using h v hv

/-- The prescribed first signed-area barycentric coordinate as an operator. -/
def bary1Operator (A : H →ₗ[ℂ] H) (x0 y0 x1 y1 x2 y2 : ℝ) : H →ₗ[ℂ] H :=
  fixedAffineOperator A
    ((-x0 * (y2 - y0) + y0 * (x2 - x0)) / signedArea x0 y0 x1 y1 x2 y2)
    ((y2 - y0) / signedArea x0 y0 x1 y1 x2 y2)
    (-(x2 - x0) / signedArea x0 y0 x1 y1 x2 y2)

/-- The prescribed second signed-area barycentric coordinate as an operator. -/
def bary2Operator (A : H →ₗ[ℂ] H) (x0 y0 x1 y1 x2 y2 : ℝ) : H →ₗ[ℂ] H :=
  fixedAffineOperator A
    ((-y0 * (x1 - x0) + x0 * (y1 - y0)) / signedArea x0 y0 x1 y1 x2 y2)
    (-(y1 - y0) / signedArea x0 y0 x1 y1 x2 y2)
    ((x1 - x0) / signedArea x0 y0 x1 y1 x2 y2)

/-- The zeroth operator is fixed by the affine sum identity. -/
def bary0Operator (A : H →ₗ[ℂ] H) (x0 y0 x1 y1 x2 y2 : ℝ) : H →ₗ[ℂ] H :=
  LinearMap.id - bary1Operator A x0 y0 x1 y1 x2 y2 - bary2Operator A x0 y0 x1 y1 x2 y2


/-- On unit vectors the first prescribed operator has precisely `bary1` as
its quadratic form. Nondegeneracy is needed for geometric use, not this identity. -/
theorem quadratic_bary1Operator_unit (A : H →ₗ[ℂ] H)
    (x0 y0 x1 y1 x2 y2 : ℝ) (x : H) (hx : ‖x‖ = 1) :
    inner ℂ x (bary1Operator A x0 y0 x1 y1 x2 y2 x) =
      (bary1 x0 y0 x1 y1 x2 y2 (inner ℂ x (A x)).re (inner ℂ x (A x)).im : ℂ) := by
  unfold bary1Operator
  rw [quadratic_fixedAffineOperator, hx]
  simp only [one_pow, mul_one]
  congr 1
  unfold bary1
  ring

/-- On unit vectors the second prescribed operator has precisely `bary2` as
its quadratic form. -/
theorem quadratic_bary2Operator_unit (A : H →ₗ[ℂ] H)
    (x0 y0 x1 y1 x2 y2 : ℝ) (x : H) (hx : ‖x‖ = 1) :
    inner ℂ x (bary2Operator A x0 y0 x1 y1 x2 y2 x) =
      (bary2 x0 y0 x1 y1 x2 y2 (inner ℂ x (A x)).re (inner ℂ x (A x)).im : ℂ) := by
  unfold bary2Operator
  rw [quadratic_fixedAffineOperator, hx]
  simp only [one_pow, mul_one]
  congr 1
  unfold bary2
  ring

/-- The zeroth prescribed operator has the corresponding zeroth coordinate
as its quadratic form on unit vectors. -/
theorem quadratic_bary0Operator_unit (A : H →ₗ[ℂ] H)
    (x0 y0 x1 y1 x2 y2 : ℝ) (x : H) (hx : ‖x‖ = 1) :
    inner ℂ x (bary0Operator A x0 y0 x1 y1 x2 y2 x) =
      (bary0 x0 y0 x1 y1 x2 y2 (inner ℂ x (A x)).re (inner ℂ x (A x)).im : ℂ) := by
  have hself : inner ℂ x x = (‖x‖ : ℂ) ^ 2 := inner_self_eq_norm_sq_to_K x
  simp only [bary0Operator, LinearMap.sub_apply, LinearMap.id_apply, inner_sub_right]
  rw [hself, hx, quadratic_bary1Operator_unit A x0 y0 x1 y1 x2 y2 x hx,
    quadratic_bary2Operator_unit A x0 y0 x1 y1 x2 y2 x hx]
  simp only [one_pow, bary0, Complex.ofReal_sub, Complex.ofReal_one]

end
end NumStability.ContractionAffineConstruction
