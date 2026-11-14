/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.LinearAlgebra.UnitaryGroup

set_option autoImplicit false
open scoped BigOperators Topology Matrix.Norms.L2Operator

namespace NumStability.Bhatia.Chapter01.Targets

/-- Exercise I.2.5, printed7/PDF19. The full characteristic polynomial
has exactly n distinct roots, counted with their algebraic multiplicities.
The Schur triangularisation sentence is a method hint, not a hypothesis. -/
def simpleSpectrumDense : Prop :=
  ∀ n : ℕ,
    Dense { A : Matrix (Fin n) (Fin n) ℂ |
      ∃ lam : Fin n → ℂ, Function.Injective lam ∧
        A.charpoly = ∏ i : Fin n, (Polynomial.X - Polynomial.C (lam i)) }

/-- Exercise I.2.6, printed7/PDF19. The hypothesis is the genuine Hilbert
operator norm of the Euclidean realization, with threshold strictly below 1.
The limit is explicitly a two-sided inverse; convergence is concluded. -/
def neumannSeries : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (n := Fin n) A‖ < 1 →
      IsUnit (1 - A) ∧
      ∃ B : Matrix (Fin n) (Fin n) ℂ,
        (1 - A) * B = 1 ∧ B * (1 - A) = 1 ∧
        Filter.Tendsto (fun N : ℕ => ∑ k ∈ Finset.range (N + 1), A ^ k)
          Filter.atTop (𝓝 B)

/-- Exercise I.2.7 first sentence, printed7/PDF19. Both ambient-topology
properties are retained. No noncompactness assertion is printed in this row. -/
def generalLinearDenseOpen : Prop :=
  ∀ n : ℕ,
    Dense { A : Matrix (Fin n) (Fin n) ℂ | IsUnit A } ∧
    IsOpen { A : Matrix (Fin n) (Fin n) ℂ | IsUnit A }

/-- Exercise I.2.7 group clause, printed7/PDF19. These are the concrete
library groups on all invertible matrices and all two-sided unitary matrices.
The displayed coercion equations fix the product, identity and inverse in the
ambient matrix algebra. Intrinsic closure follows from the typed operations.
The optional unitary-to-GL inclusion is retained in separate support text. -/
def matrixGroups : Prop :=
  ∀ n : ℕ,
    (let G := Matrix.GeneralLinearGroup (Fin n) ℂ
     (∀ A : Matrix (Fin n) (Fin n) ℂ,
       IsUnit A ↔ ∃ g : G, (g : Matrix (Fin n) (Fin n) ℂ) = A) ∧
     ((1 : G) : Matrix (Fin n) (Fin n) ℂ) = 1 ∧
     (∀ g h : G, ((g * h : G) : Matrix (Fin n) (Fin n) ℂ) =
       (g : Matrix (Fin n) (Fin n) ℂ) * (h : Matrix (Fin n) (Fin n) ℂ)) ∧
     (∀ g h k : G, (g * h) * k = g * (h * k)) ∧
     (∀ g : G, 1 * g = g ∧ g * 1 = g ∧ g⁻¹ * g = 1 ∧ g * g⁻¹ = 1) ∧
     (∀ g : G,
       (g⁻¹ : Matrix (Fin n) (Fin n) ℂ) * (g : Matrix (Fin n) (Fin n) ℂ) = 1 ∧
       (g : Matrix (Fin n) (Fin n) ℂ) * (g⁻¹ : Matrix (Fin n) (Fin n) ℂ) = 1)) ∧
    (let U := Matrix.unitaryGroup (Fin n) ℂ
     (∀ A : Matrix (Fin n) (Fin n) ℂ,
       (A * A.conjTranspose = 1 ∧ A.conjTranspose * A = 1) ↔
         ∃ u : U, (u : Matrix (Fin n) (Fin n) ℂ) = A) ∧
     ((1 : U) : Matrix (Fin n) (Fin n) ℂ) = 1 ∧
     (∀ u v : U, ((u * v : U) : Matrix (Fin n) (Fin n) ℂ) =
       (u : Matrix (Fin n) (Fin n) ℂ) * (v : Matrix (Fin n) (Fin n) ℂ)) ∧
     (∀ u v w : U, (u * v) * w = u * (v * w)) ∧
     (∀ u : U, 1 * u = u ∧ u * 1 = u ∧ u⁻¹ * u = 1 ∧ u * u⁻¹ = 1) ∧
     (∀ u : U, (u⁻¹ : Matrix (Fin n) (Fin n) ℂ) =
       (u : Matrix (Fin n) (Fin n) ℂ).conjTranspose) ∧
     (∀ u : U,
       (u⁻¹ : Matrix (Fin n) (Fin n) ℂ) * (u : Matrix (Fin n) (Fin n) ℂ) = 1 ∧
       (u : Matrix (Fin n) (Fin n) ℂ) * (u⁻¹ : Matrix (Fin n) (Fin n) ℂ) = 1))

/-- I.2.8 convergence, printed8/PDF20. The ordered source factorial
partial sums converge to the ACTUAL analytic matrix exponential. Agreement
with the library exponential is a conclusion here, never a premise or callback.
No absolute-summability, analyticity, error bound or smallness clause is added. -/
def exponentialSeriesConverges : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    Filter.Tendsto
      (fun N : ℕ => ∑ k ∈ Finset.range (N + 1),
        ((Nat.factorial k : ℂ)⁻¹) • A ^ k)
      Filter.atTop (𝓝 (NormedSpace.exp A))

/-- I.2.8 logarithm, printed8/PDF20. Same-size COMPLEX logarithm
existence on ALL invertible matrices, with explicit identification of the
prescribed source series and the actual analytic exponential at that value.
No branch, uniqueness, normality or regular choice is supplied. -/
def matrixLogarithmExists : Prop :=
  ∀ (n : ℕ) (M : Matrix (Fin n) (Fin n) ℂ), IsUnit M →
    ∃ A : Matrix (Fin n) (Fin n) ℂ,
      NormedSpace.exp A = M ∧
      Filter.Tendsto
        (fun N : ℕ => ∑ k ∈ Finset.range (N + 1),
          ((Nat.factorial k : ℂ)⁻¹) • A ^ k)
        Filter.atTop (𝓝 M)

/-- I.2.8 unitary logarithm, printed8/PDF20. Every two-sided unitary
complex matrix has a same-size skew-Hermitian logarithm for the actual
analytic matrix exponential, whose ordered source series converges to U.
No converse, principal branch, norm bound or continuity is asserted. -/
def unitaryLogarithmExists : Prop :=
  ∀ (n : ℕ) (U : Matrix (Fin n) (Fin n) ℂ),
    (U * U.conjTranspose = 1 ∧ U.conjTranspose * U = 1) →
      ∃ K : Matrix (Fin n) (Fin n) ℂ,
        K = -K.conjTranspose ∧
        NormedSpace.exp K = U ∧
        Filter.Tendsto
          (fun N : ℕ => ∑ k ∈ Finset.range (N + 1),
            ((Nat.factorial k : ℂ)⁻¹) • K ^ k)
          Filter.atTop (𝓝 U)

end NumStability.Bhatia.Chapter01.Targets
