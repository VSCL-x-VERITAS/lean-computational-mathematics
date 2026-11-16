import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.Basic
import Mathlib.Analysis.InnerProductSpace.Projection.FiniteDimensional

/-!
# Exact finite-dimensional least-squares minimizers

Orthogonal projection onto the image of the matrix gives a minimizer for every
finite real least-squares problem. Neither rank nor positive dimension is
required. The selected coefficient vector is an arbitrary preimage of that
projection; no uniqueness, minimum coefficient norm or computational cost is
asserted.
-/

namespace NumStability

open scoped BigOperators

private theorem euclidean_residual_norm_sq_eq_lsObjective {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ)
    (x : EuclideanSpace ℝ (Fin n)) :
    ‖WithLp.toLp 2 b - Matrix.toEuclideanLin (A : Matrix (Fin m) (Fin n) ℝ) x‖ ^ 2 =
      lsObjective A b (WithLp.ofLp x) := by
  rw [EuclideanSpace.norm_sq_eq]
  change (∑ i : Fin m, ‖b i - rectMatMulVec A (WithLp.ofLp x) i‖ ^ 2) = _
  simp only [Real.norm_eq_abs, sq_abs]
  unfold lsObjective vecNorm2Sq lsResidual
  apply Finset.sum_congr rfl
  intro i _
  ring

/-- Every finite real least-squares problem has an exact minimizer, including
rank-deficient matrices and zero row or column dimensions. -/
theorem exists_isLeastSquaresMinimizer {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ) :
    ∃ x : Fin n → ℝ, IsLeastSquaresMinimizer A b x := by
  let L := Matrix.toEuclideanLin (A : Matrix (Fin m) (Fin n) ℝ)
  let K := LinearMap.range L
  let bE : EuclideanSpace ℝ (Fin m) := WithLp.toLp 2 b
  let p : K := K.orthogonalProjection bE
  obtain ⟨x, hx⟩ := p.property
  have hproj : K.starProjection bE = L x := hx.symm
  refine ⟨WithLp.ofLp x, ?_⟩
  intro y
  have hbelow : BddBelow (Set.range (fun z : K =>
      ‖bE - (z : EuclideanSpace ℝ (Fin m))‖)) := by
    refine ⟨0, ?_⟩
    rintro _ ⟨z, rfl⟩
    exact norm_nonneg _
  have hmin : ‖bE - L x‖ ≤ ‖bE - L (WithLp.toLp 2 y)‖ := by
    calc
      ‖bE - L x‖ = ‖bE - K.starProjection bE‖ := by rw [hproj]
      _ = ⨅ z : K, ‖bE - (z : EuclideanSpace ℝ (Fin m))‖ :=
        K.starProjection_minimal bE
      _ ≤ ‖bE - L (WithLp.toLp 2 y)‖ :=
        ciInf_le hbelow
          (⟨L (WithLp.toLp 2 y), LinearMap.mem_range_self L _⟩ : K)
  have hsq := (sq_le_sq₀ (norm_nonneg _) (norm_nonneg _)).mpr hmin
  change ‖WithLp.toLp 2 b - Matrix.toEuclideanLin (A : Matrix (Fin m) (Fin n) ℝ) x‖ ^ 2 ≤
    ‖WithLp.toLp 2 b - Matrix.toEuclideanLin (A : Matrix (Fin m) (Fin n) ℝ)
      (WithLp.toLp 2 y)‖ ^ 2 at hsq
  rw [euclidean_residual_norm_sq_eq_lsObjective,
    euclidean_residual_norm_sq_eq_lsObjective] at hsq
  exact hsq

/-- A selected exact minimizer. Selection uses classical choice and specifies
no particular coefficient vector when the minimizer is not unique. -/
noncomputable def leastSquaresMinimizer {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ) : Fin n → ℝ :=
  Classical.choose (exists_isLeastSquaresMinimizer A b)

/-- The selected coefficient vector minimizes the squared residual objective. -/
theorem leastSquaresMinimizer_isLeastSquaresMinimizer {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ) :
    IsLeastSquaresMinimizer A b (leastSquaresMinimizer A b) :=
  Classical.choose_spec (exists_isLeastSquaresMinimizer A b)

/-- The selected coefficient vector also minimizes the unsquared residual norm. -/
theorem leastSquaresMinimizer_residual_norm_le {m n : ℕ}
    (A : Fin m → Fin n → ℝ) (b : Fin m → ℝ) (y : Fin n → ℝ) :
    vecNorm2 (lsResidual A b (leastSquaresMinimizer A b)) ≤
      vecNorm2 (lsResidual A b y) :=
  Real.sqrt_le_sqrt (leastSquaresMinimizer_isLeastSquaresMinimizer A b y)

end NumStability
