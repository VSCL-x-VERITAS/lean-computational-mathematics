import ComputationalMathematics.HDP.Vector.EuclideanSpectralClustering

/-!
# Vershynin Chapter 4, spectral clustering algorithm for point sets

The actual selected direction is characterized by coordinate eigen-equations
and maximality on the Euclidean unit sphere, followed by the printed sign rule.
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Section 4.7.1: form the uncentered empirical second moment,
choose a unit leading eigenvector, and split the sample by projection sign.
Unit normalization is a compatible algorithm choice. The case `m=0` is a
nonvacuous totalization beyond the printed averaging domain. -/
theorem hdp_04_algorithm_4_7_spectral_clustering {m n : ℕ}
    (hn : 0 < n) (X : Fin m → Fin n → ℝ) :
    let M : Matrix (Fin n) (Fin n) ℝ :=
      fun a b ↦ (m : ℝ)⁻¹ * ∑ i, X i a * X i b
    let v := NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn X
    (∑ j, v j ^ 2) = 1 ∧
      (∃ eigenvalue : ℝ,
        (∀ a, (∑ b, M a b * v b) = eigenvalue * v a) ∧
        (∀ w : Fin n → ℝ, (∑ j, w j ^ 2) = 1 →
          (∑ a, w a * ∑ b, M a b * w b) ≤ eigenvalue)) ∧
      (∃ first second : Set (Fin m),
        (∀ i, i ∈ first ↔ 0 < ∑ j, v j * X i j) ∧
        (∀ i, i ∈ second ↔ (∑ j, v j * X i j) ≤ 0)) := by
  dsimp only
  let v := NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn X
  let M := NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X
  let eigenvalue := NumStability.hermitianOrderedEigenvalue
    (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian X)
    ⟨0, hn⟩
  have hvnorm : ‖v‖ = 1 :=
    NumStability.HDP.Vector.EuclideanSpectralClustering.norm_leadingEigenvector hn X
  have hnormsq (w : EuclideanSpace ℝ (Fin n)) : ‖w‖ ^ 2 = ∑ j, w j ^ 2 := by
    simpa only [Real.norm_eq_abs, sq_abs] using PiLp.norm_sq_eq_of_L2 (fun _ ↦ ℝ) w
  have hvunit : (∑ j, v j ^ 2) = 1 := by rw [← hnormsq, hvnorm]; norm_num
  have heigen :=
    NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_apply_leadingEigenvector
      hn X
  have hmax :=
    NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector_isTopRayleigh hn X
  have hray (w : EuclideanSpace ℝ (Fin n)) :
      NumStability.matrixRayleighForm M w = ∑ a, w a * ∑ b, M a b * w b := by
    simp [NumStability.matrixRayleighForm, PiLp.inner_apply, real_inner_eq_re_inner,
      RCLike.inner_apply, Matrix.toLpLin_apply, Matrix.mulVec, dotProduct, mul_comm]
  have hattain : NumStability.matrixRayleighForm M v = eigenvalue :=
    NumStability.matrixRayleighForm_hermitianOrderedEigenbasis
      (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment_isHermitian X)
      ⟨0, hn⟩
  refine ⟨hvunit, ⟨eigenvalue, ?_, ?_⟩,
    ⟨{i | 0 < ∑ j, v j * X i j}, {i | (∑ j, v j * X i j) ≤ 0},
      fun _ ↦ Iff.rfl, fun _ ↦ Iff.rfl⟩⟩
  · intro a
    have h := congrArg (fun w : EuclideanSpace ℝ (Fin n) ↦ w a) heigen
    simpa [M, v, eigenvalue, Matrix.toLpLin_apply, Matrix.mulVec, dotProduct,
      NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment,
      NumStability.HDP.Vector.Covariance.sampleCovariance] using h
  · intro w hw
    have hwunit : ‖WithLp.toLp 2 w‖ = 1 := by
      have hsq : ‖WithLp.toLp 2 w‖ ^ 2 = 1 := (hnormsq _).trans hw
      nlinarith [norm_nonneg (WithLp.toLp 2 w)]
    have h := (hmax.2 (WithLp.toLp 2 w) hwunit).trans_eq hattain
    rw [hray] at h
    simpa [M,
      NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment,
      NumStability.HDP.Vector.Covariance.sampleCovariance] using h

/-- The printed nonempty point-sample algorithm admits a unit leading
eigenvector and the exact positive/nonpositive clusters. The existential
output permits all eigenvalue ties and either sign orientation. -/
theorem hdp_04_algorithm_4_7_spectral_clustering_exists_output {m n : ℕ}
    (X : Fin (m + 1) → Fin (n + 1) → ℝ) :
    let M : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ :=
      fun a b ↦ ((m + 1 : ℕ) : ℝ)⁻¹ * ∑ i, X i a * X i b
    ∃ (v : Fin (n + 1) → ℝ) (eigenvalue : ℝ)
      (first second : Set (Fin (m + 1))),
      (∑ j, v j ^ 2) = 1 ∧
      (∀ a, (∑ b, M a b * v b) = eigenvalue * v a) ∧
      (∀ w : Fin (n + 1) → ℝ, (∑ j, w j ^ 2) = 1 →
        (∑ a, w a * ∑ b, M a b * w b) ≤ eigenvalue) ∧
      (∀ i, i ∈ first ↔ 0 < ∑ j, v j * X i j) ∧
      (∀ i, i ∈ second ↔ (∑ j, v j * X i j) ≤ 0) := by
  obtain ⟨hunit, ⟨eigenvalue, heigen, htop⟩, ⟨first, second, hfirst, hsecond⟩⟩ :=
    hdp_04_algorithm_4_7_spectral_clustering (Nat.succ_pos n) X
  exact ⟨fun j ↦
      NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
        (Nat.succ_pos n) X j,
    eigenvalue, first, second, hunit, heigen, htop, hfirst, hsecond⟩

end NumStability.HDP.Contract
