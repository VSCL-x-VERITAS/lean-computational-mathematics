import ComputationalMathematics.HDP.Metric.SetNetBilinear
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Vershynin Chapter 4, Exercise 4.4.3
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.4.3: an arbitrary `ε`-net in each sphere controls
a rectangular matrix's bilinear operator norm, and for a symmetric square
matrix one arbitrary net controls the absolute quadratic form, in both cases
with factor `(1 - 2ε)⁻¹`. -/
theorem hdp_04_exercise_4_4_3 :
    (∀ {m n : ℕ}, 0 < m → 0 < n →
        (A : Matrix (Fin m) (Fin n) ℝ) → (ε : ℝ) →
        (N : Set (EuclideanSpace ℝ (Fin n))) →
        (M : Set (EuclideanSpace ℝ (Fin m))) →
      0 ≤ ε → ε < 1 / 2 →
      NumStability.HDP.Metric.IsUnitSphereNet ε N →
      NumStability.HDP.Metric.IsUnitSphereNet ε M →
      sSup {a : ℝ | ∃ x ∈ N, ∃ y ∈ M,
          a = inner ℝ (Matrix.toEuclideanLin A x) y} ≤
          NumStability.realMatrixOperatorNorm A ∧
        NumStability.realMatrixOperatorNorm A ≤
          (1 - 2 * ε)⁻¹ *
            sSup {a : ℝ | ∃ x ∈ N, ∃ y ∈ M,
              a = inner ℝ (Matrix.toEuclideanLin A x) y}) ∧
    (∀ {n : ℕ}, 0 < n → (A : Matrix (Fin n) (Fin n) ℝ) →
        A.IsHermitian → (ε : ℝ) →
        (N : Set (EuclideanSpace ℝ (Fin n))) →
      0 ≤ ε → ε < 1 / 2 →
      NumStability.HDP.Metric.IsUnitSphereNet ε N →
      sSup {a : ℝ | ∃ x ∈ N,
          a = |NumStability.realMatrixQuadraticForm A x|} ≤
          NumStability.realMatrixOperatorNorm A ∧
        NumStability.realMatrixOperatorNorm A ≤
          (1 - 2 * ε)⁻¹ *
            sSup {a : ℝ | ∃ x ∈ N,
              a = |NumStability.realMatrixQuadraticForm A x|}) := by
  constructor
  · intro m n hm hn A ε N M hε0 hεhalf hN hM
    let i : Fin n := ⟨0, hn⟩
    let j : Fin m := ⟨0, hm⟩
    let e : EuclideanSpace ℝ (Fin n) := EuclideanSpace.single i 1
    let f : EuclideanSpace ℝ (Fin m) := EuclideanSpace.single j 1
    have he : ‖e‖ = 1 := by simp [e]
    have hf : ‖f‖ = 1 := by simp [f]
    obtain ⟨x, hxN, _⟩ := hN.2 e he
    obtain ⟨y, hyM, _⟩ := hM.2 f hf
    simpa [NumStability.realMatrixOperatorNorm,
      NumStability.realMatrixContinuousLinearMap] using
      NumStability.HDP.Metric.sSup_bilinear_bounds_of_isUnitSphereNet
        (NumStability.realMatrixContinuousLinearMap A) ε N M
        hε0 hεhalf hN hM ⟨x, hxN⟩ ⟨y, hyM⟩
  · intro n hn A hA ε N hε0 hεhalf hN
    let i : Fin n := ⟨0, hn⟩
    let e : EuclideanSpace ℝ (Fin n) := EuclideanSpace.single i 1
    have he : ‖e‖ = 1 := by simp [e]
    obtain ⟨x, hxN, _⟩ := hN.2 e he
    obtain ⟨_hop, u, hu, huq, _humax⟩ :=
      NumStability.symmetricRealMatrixOperatorNorm_quadratic_characterization
        hn A hA
    have hattain : ∃ u : EuclideanSpace ℝ (Fin n), ‖u‖ = 1 ∧
        ‖NumStability.realMatrixContinuousLinearMap A‖ ≤
          |inner ℝ (NumStability.realMatrixContinuousLinearMap A u) u| := by
      refine ⟨u, hu, ?_⟩
      simpa [NumStability.realMatrixOperatorNorm,
        NumStability.realMatrixQuadraticForm,
        NumStability.realMatrixContinuousLinearMap] using huq.symm.le
    simpa [NumStability.realMatrixOperatorNorm,
      NumStability.realMatrixQuadraticForm,
      NumStability.realMatrixContinuousLinearMap] using
      NumStability.HDP.Metric.sSup_quadratic_abs_bounds_of_isUnitSphereNet
        (NumStability.realMatrixContinuousLinearMap A) ε N
        hε0 hεhalf hN ⟨x, hxN⟩ hattain

end NumStability.HDP.Contract
