/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FiveFieldElasticityStressPlane
import ComputationalMathematics.Analysis.PartialDifferentialEquations.HyperbolicitySimilarity

/-! Independent stress-state eigenbasis for Chapter 22 (22.39)–(22.40). -/
namespace NumStability.Leveque02Tracer.PlaneElasticity

private def stressStationaryVector (nx ny : ℝ) : Fin 5 → ℝ :=
  ![ny ^ 2, nx ^ 2, -(nx * ny), 0, 0]

private def stressPVector (lam mu nx ny c : ℝ) : Fin 5 → ℝ :=
  ![(lam + 2 * mu) * nx ^ 2 + lam * ny ^ 2,
    lam * nx ^ 2 + (lam + 2 * mu) * ny ^ 2,
    2 * mu * nx * ny, -c * nx, -c * ny]

private def stressSVector (mu nx ny c : ℝ) : Fin 5 → ℝ :=
  ![-2 * mu * nx * ny, 2 * mu * nx * ny,
    mu * (nx ^ 2 - ny ^ 2), c * ny, -c * nx]

private theorem stressStationaryVector_eigen
    (lam mu rho nx ny : ℝ) :
    (stressDirectionalSymbol lam mu rho nx ny).mulVec
      (stressStationaryVector nx ny) =
        0 • stressStationaryVector nx ny := by
  ext i
  fin_cases i <;>
    simp [stressDirectionalSymbol, stressXSymbol, stressYSymbol,
      stressStationaryVector, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ] <;> ring

private theorem stressPVector_eigen
    (lam mu rho nx ny c : ℝ)
    (hc : c ^ 2 = ((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2)) :
    (stressDirectionalSymbol lam mu rho nx ny).mulVec
      (stressPVector lam mu nx ny c) =
        c • stressPVector lam mu nx ny c := by
  simp only [div_eq_mul_inv] at hc
  ext i
  fin_cases i <;>
    simp [stressDirectionalSymbol, stressXSymbol, stressYSymbol,
      stressPVector, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ, Pi.smul_apply] <;>
    nlinarith [congrArg (fun z : ℝ => z * nx) hc,
      congrArg (fun z : ℝ => z * ny) hc]

private theorem stressSVector_eigen
    (lam mu rho nx ny c : ℝ)
    (hc : c ^ 2 = (mu / rho) * (nx ^ 2 + ny ^ 2)) :
    (stressDirectionalSymbol lam mu rho nx ny).mulVec
      (stressSVector mu nx ny c) =
        c • stressSVector mu nx ny c := by
  simp only [div_eq_mul_inv] at hc
  ext i
  fin_cases i <;>
    simp [stressDirectionalSymbol, stressXSymbol, stressYSymbol,
      stressSVector, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ, Pi.smul_apply] <;>
    nlinarith [congrArg (fun z : ℝ => z * nx) hc,
      congrArg (fun z : ℝ => z * ny) hc]

private noncomputable def stressEigenvectors
    (lam mu nx ny cp cs : ℝ) : Fin 5 → (Fin 5 → ℝ) :=
  ![stressStationaryVector nx ny,
    stressPVector lam mu nx ny cp, stressPVector lam mu nx ny (-cp),
    stressSVector mu nx ny cs, stressSVector mu nx ny (-cs)]

private noncomputable def stressBasis (lam mu nx ny : ℝ) :
    Matrix (Fin 3) (Fin 3) ℝ :=
  !![ny ^ 2,
      (lam + 2 * mu) * nx ^ 2 + lam * ny ^ 2,
      -2 * mu * nx * ny;
     nx ^ 2,
      lam * nx ^ 2 + (lam + 2 * mu) * ny ^ 2,
      2 * mu * nx * ny;
     -(nx * ny), 2 * mu * nx * ny,
      mu * (nx ^ 2 - ny ^ 2)]

private theorem stressBasis_det (lam mu nx ny : ℝ) :
    (stressBasis lam mu nx ny).det =
      -((lam + 2 * mu) * mu * (nx ^ 2 + ny ^ 2) ^ 3) := by
  simp [stressBasis, Matrix.det_fin_three]
  ring

private theorem stressEigenvector_top_combination
    (lam mu nx ny cp cs : ℝ) (g : Fin 5 → ℝ)
    (hg : ∑ i, g i • stressEigenvectors lam mu nx ny cp cs i = 0) :
    (stressBasis lam mu nx ny).mulVec
      ![g 0, g 1 + g 2, g 3 + g 4] = 0 := by
  ext i
  fin_cases i
  · have hi := congrFun hg (0 : Fin 5)
    simp [stressBasis, stressEigenvectors, stressStationaryVector,
      stressPVector, stressSVector, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ, Pi.smul_apply, smul_eq_mul] at hi ⊢
    linear_combination hi
  · have hi := congrFun hg (1 : Fin 5)
    simp [stressBasis, stressEigenvectors, stressStationaryVector,
      stressPVector, stressSVector, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ, Pi.smul_apply, smul_eq_mul] at hi ⊢
    linear_combination hi
  · have hi := congrFun hg (2 : Fin 5)
    simp [stressBasis, stressEigenvectors, stressStationaryVector,
      stressPVector, stressSVector, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ, Pi.smul_apply, smul_eq_mul] at hi ⊢
    linear_combination hi

private theorem stressEigenvector_top_coefficients_zero
    (lam mu nx ny cp cs : ℝ)
    (hK : 0 < lam + 2 * mu) (hmu : 0 < mu)
    (hn : 0 < nx ^ 2 + ny ^ 2) (g : Fin 5 → ℝ)
    (hg : ∑ i, g i • stressEigenvectors lam mu nx ny cp cs i = 0) :
    g 0 = 0 ∧ g 1 + g 2 = 0 ∧ g 3 + g 4 = 0 := by
  have hdet : (stressBasis lam mu nx ny).det ≠ 0 := by
    rw [stressBasis_det]
    exact ne_of_lt (neg_neg_of_pos (by positivity))
  have hc := Matrix.eq_zero_of_mulVec_eq_zero hdet
    (stressEigenvector_top_combination lam mu nx ny cp cs g hg)
  exact ⟨by simpa using congrFun hc (0 : Fin 3),
    by simpa using congrFun hc (1 : Fin 3),
    by simpa using congrFun hc (2 : Fin 3)⟩

private def stressVelocityBasis (nx ny cp cs : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  !![-cp * nx, cs * ny; -cp * ny, -cs * nx]

private theorem stressVelocityBasis_det (nx ny cp cs : ℝ) :
    (stressVelocityBasis nx ny cp cs).det =
      cp * cs * (nx ^ 2 + ny ^ 2) := by
  simp [stressVelocityBasis, Matrix.det_fin_two]
  ring

private theorem stressEigenvector_velocity_combination
    (lam mu nx ny cp cs : ℝ) (g : Fin 5 → ℝ)
    (hg : ∑ i, g i • stressEigenvectors lam mu nx ny cp cs i = 0) :
    (stressVelocityBasis nx ny cp cs).mulVec
      ![g 1 - g 2, g 3 - g 4] = 0 := by
  ext i
  fin_cases i
  · have hi := congrFun hg (3 : Fin 5)
    simp [stressVelocityBasis, stressEigenvectors,
      stressStationaryVector, stressPVector, stressSVector,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Pi.smul_apply, smul_eq_mul] at hi ⊢
    linear_combination hi
  · have hi := congrFun hg (4 : Fin 5)
    simp [stressVelocityBasis, stressEigenvectors,
      stressStationaryVector, stressPVector, stressSVector,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Pi.smul_apply, smul_eq_mul] at hi ⊢
    linear_combination hi

private theorem stressEigenvectors_independent
    (lam mu nx ny cp cs : ℝ)
    (hK : 0 < lam + 2 * mu) (hmu : 0 < mu)
    (hcp : 0 < cp) (hcs : 0 < cs)
    (hn : 0 < nx ^ 2 + ny ^ 2) :
    LinearIndependent ℝ (stressEigenvectors lam mu nx ny cp cs) := by
  apply Fintype.linearIndependent_iff.mpr
  intro g hg i
  obtain ⟨h0, h12, h34⟩ :=
    stressEigenvector_top_coefficients_zero lam mu nx ny cp cs
      hK hmu hn g hg
  have hdet : (stressVelocityBasis nx ny cp cs).det ≠ 0 := by
    rw [stressVelocityBasis_det]
    exact ne_of_gt (by positivity)
  have hc := Matrix.eq_zero_of_mulVec_eq_zero hdet
    (stressEigenvector_velocity_combination lam mu nx ny cp cs g hg)
  have hd12 : g 1 - g 2 = 0 := by simpa using congrFun hc (0 : Fin 2)
  have hd34 : g 3 - g 4 = 0 := by simpa using congrFun hc (1 : Fin 2)
  have h1 : g 1 = 0 := by linarith
  have h2 : g 2 = 0 := by linarith
  have h3 : g 3 = 0 := by linarith
  have h4 : g 4 = 0 := by linarith
  fin_cases i <;> simp [h0, h1, h2, h3, h4]

/-- Exact `0, ±cp, ±cs` stress-state eigenfamily from (22.40), with
five independent vectors even when `cp=cs`. -/
theorem stressDirectionalSpectrum
    (lam mu rho nx ny : ℝ)
    (hrho : 0 < rho) (hmu : 0 < mu)
    (hK : 0 < lam + 2 * mu)
    (hdir : nx ≠ 0 ∨ ny ≠ 0) :
    let cp := Real.sqrt (((lam + 2 * mu) / rho) *
      (nx ^ 2 + ny ^ 2))
    let cs := Real.sqrt ((mu / rho) * (nx ^ 2 + ny ^ 2))
    ∃ evec : Fin 5 → (Fin 5 → ℝ),
      LinearIndependent ℝ evec ∧
      ∀ i, (stressDirectionalSymbol lam mu rho nx ny).mulVec (evec i) =
        (![0, cp, -cp, cs, -cs] : Fin 5 → ℝ) i • evec i := by
  dsimp
  let cp : ℝ := Real.sqrt (((lam + 2 * mu) / rho) *
    (nx ^ 2 + ny ^ 2))
  let cs : ℝ := Real.sqrt ((mu / rho) *
    (nx ^ 2 + ny ^ 2))
  have hn : 0 < nx ^ 2 + ny ^ 2 := by
    rcases hdir with hnx | hny
    · nlinarith [sq_pos_of_ne_zero hnx, sq_nonneg ny]
    · nlinarith [sq_pos_of_ne_zero hny, sq_nonneg nx]
  have hpArg : 0 < ((lam + 2 * mu) / rho) *
      (nx ^ 2 + ny ^ 2) :=
    mul_pos (div_pos hK hrho) hn
  have hsArg : 0 < (mu / rho) * (nx ^ 2 + ny ^ 2) :=
    mul_pos (div_pos hmu hrho) hn
  have hcp : 0 < cp := Real.sqrt_pos.2 hpArg
  have hcs : 0 < cs := Real.sqrt_pos.2 hsArg
  have hcpSq : cp ^ 2 = ((lam + 2 * mu) / rho) *
      (nx ^ 2 + ny ^ 2) := Real.sq_sqrt hpArg.le
  have hcsSq : cs ^ 2 = (mu / rho) *
      (nx ^ 2 + ny ^ 2) := Real.sq_sqrt hsArg.le
  let evec := stressEigenvectors lam mu nx ny cp cs
  refine ⟨evec, stressEigenvectors_independent lam mu nx ny cp cs
    hK hmu hcp hcs hn, ?_⟩
  intro i
  fin_cases i
  · simpa [evec, stressEigenvectors] using
      stressStationaryVector_eigen lam mu rho nx ny
  · simpa [evec, stressEigenvectors] using
      stressPVector_eigen lam mu rho nx ny cp hcpSq
  · have hneg : (-cp) ^ 2 = ((lam + 2 * mu) / rho) *
        (nx ^ 2 + ny ^ 2) := by simpa using hcpSq
    simpa [evec, stressEigenvectors] using
      stressPVector_eigen lam mu rho nx ny (-cp) hneg
  · simpa [evec, stressEigenvectors] using
      stressSVector_eigen lam mu rho nx ny cs hcsSq
  · have hneg : (-cs) ^ 2 = (mu / rho) *
        (nx ^ 2 + ny ^ 2) := by simpa using hcsSq
    simpa [evec, stressEigenvectors] using
      stressSVector_eigen lam mu rho nx ny (-cs) hneg

/-- Full real diagonalizability of the printed stress symbol. -/
theorem stressDirectionalHyperbolicity
    (lam mu rho nx ny : ℝ)
    (hrho : 0 < rho) (hmu : 0 < mu)
    (hK : 0 < lam + 2 * mu) :
    NumStability.IsRealHyperbolicMatrix
      (stressDirectionalSymbol lam mu rho nx ny) := by
  by_cases hzero : nx = 0 ∧ ny = 0
  · rcases hzero with ⟨rfl, rfl⟩
    have hz : stressDirectionalSymbol lam mu rho 0 0 = 0 := by
      simp [stressDirectionalSymbol]
    rw [hz]
    exact NumStability.IsRealHyperbolicMatrix.of_symm (by simp)
  · have hdir : nx ≠ 0 ∨ ny ≠ 0 := by tauto
    obtain ⟨evec, hind, heigen⟩ :=
      stressDirectionalSpectrum lam mu rho nx ny hrho hmu hK hdir
    exact (NumStability.isRealHyperbolicMatrix_iff_independent_real_eigenvectors
      (stressDirectionalSymbol lam mu rho nx ny)).mpr
        ⟨![0,
          Real.sqrt (((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2)),
          -Real.sqrt (((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2)),
          Real.sqrt ((mu / rho) * (nx ^ 2 + ny ^ 2)),
          -Real.sqrt ((mu / rho) * (nx ^ 2 + ny ^ 2))],
          evec, hind, heigen⟩

theorem stressPrintedClaimsTarget_proved : stressPrintedClaimsTarget := by
  refine ⟨?_, ?_, ?_⟩
  · intro p s lam mu rho x y t _ _ hK
    exact stressTwoDimensionalPlaneMotion_iff lam mu rho x y t
      (ne_of_gt hK) p s
  · intro lam mu rho nx ny hrho hmu hK hdir
    exact stressDirectionalSpectrum lam mu rho nx ny
      hrho hmu hK hdir
  · intro lam mu rho nx ny hrho hmu hK
    exact stressDirectionalHyperbolicity lam mu rho nx ny
      hrho hmu hK


end NumStability.Leveque02Tracer.PlaneElasticity
