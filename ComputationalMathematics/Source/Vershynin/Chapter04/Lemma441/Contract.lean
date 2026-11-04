import ComputationalMathematics.HDP.Metric.SetNetApproximation
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Vershynin Chapter 4, Lemma 4.4.1
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Lemma 4.4.1: the supremum of a matrix's action on any
set-valued `ε`-net of the Euclidean unit sphere approximates its operator norm
within the factor `(1 - ε)⁻¹`. -/
theorem hdp_04_lemma_4_4_1 {m n : ℕ}
    (hn : 0 < n) (A : Matrix (Fin m) (Fin n) ℝ) (ε : ℝ)
    (N : Set (EuclideanSpace ℝ (Fin n)))
    (hε0 : 0 ≤ ε) (hε1 : ε < 1)
    (hN : NumStability.HDP.Metric.IsUnitSphereNet ε N) :
    sSup {a : ℝ | ∃ y ∈ N, a = ‖Matrix.toEuclideanLin A y‖} ≤
        ‖NumStability.realMatrixContinuousLinearMap A‖ ∧
      ‖NumStability.realMatrixContinuousLinearMap A‖ ≤
        (1 - ε)⁻¹ *
          sSup {a : ℝ | ∃ y ∈ N, a = ‖Matrix.toEuclideanLin A y‖} := by
  let i : Fin n := ⟨0, hn⟩
  let e : EuclideanSpace ℝ (Fin n) := EuclideanSpace.single i 1
  have he : ‖e‖ = 1 := by simp [e]
  obtain ⟨y, hyN, _⟩ := hN.2 e he
  simpa [NumStability.realMatrixContinuousLinearMap] using
    NumStability.HDP.Metric.sSup_action_norm_bounds_of_isUnitSphereNet
      (NumStability.realMatrixContinuousLinearMap A) ε N hε0 hε1 hN
      ⟨y, hyN⟩

end NumStability.HDP.Contract
