/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FiveFieldElasticityStressSpectrum
import ComputationalMathematics.Analysis.PartialDifferentialEquations.HyperbolicitySimilarity
import Mathlib.Analysis.Matrix.Spectrum
import Mathlib.Tactic

/-! Proofs for the C2.U.082 Chapter 22 cross-referenced target. -/
namespace NumStability.Leveque02Tracer.PlaneElasticity

private theorem residual_iff_components (lam mu rho : ℝ)
    (hrho : rho ≠ 0) (qt qx qy : Fin 5 → ℝ) :
    qt + (xSymbol lam mu rho).mulVec qx +
        (ySymbol lam mu rho).mulVec qy = 0 ↔
      ComponentEquations lam mu rho qt qx qy := by
  constructor
  · intro h
    have h0 := congrFun h (0 : Fin 5)
    have h1 := congrFun h (1 : Fin 5)
    have h2 := congrFun h (2 : Fin 5)
    have h3 := congrFun h (3 : Fin 5)
    have h4 := congrFun h (4 : Fin 5)
    simp [xSymbol, ySymbol, Matrix.vecHead, Matrix.vecTail, dotProduct,
      Fin.sum_univ_succ] at h0 h1 h2 h3 h4
    refine ⟨?_, ?_, ?_, ?_, ?_⟩
    · simpa [ComponentEquations] using h0
    · simpa [ComponentEquations] using h1
    · dsimp [ComponentEquations]
      linarith [h2]
    · dsimp [ComponentEquations]
      simp [isotropicStress, strainPart]
      field_simp [hrho] at h3
      linear_combination h3
    · dsimp [ComponentEquations]
      simp [isotropicStress, strainPart]
      field_simp [hrho] at h4
      linear_combination h4
  · rintro ⟨h0, h1, h2, h3, h4⟩
    ext i
    fin_cases i
    · simpa [xSymbol, ySymbol, Matrix.vecHead, Matrix.vecTail, dotProduct,
        Fin.sum_univ_succ] using h0
    · simpa [xSymbol, ySymbol, Matrix.vecHead, Matrix.vecTail, dotProduct,
        Fin.sum_univ_succ] using h1
    · simp [xSymbol, ySymbol, Matrix.vecHead, Matrix.vecTail, dotProduct,
        Fin.sum_univ_succ]
      linarith [h2]
    · simp [xSymbol, ySymbol, Matrix.vecHead, Matrix.vecTail, dotProduct,
        Fin.sum_univ_succ]
      simp [isotropicStress, strainPart] at h3
      field_simp [hrho]
      linear_combination h3
    · simp [xSymbol, ySymbol, Matrix.vecHead, Matrix.vecTail, dotProduct,
        Fin.sum_univ_succ]
      simp [isotropicStress, strainPart] at h4
      field_simp [hrho]
      linear_combination h4

/-- The matrix system is equivalent to the five component equations obtained
from symmetric strain kinematics and isotropic Hooke stress. -/
theorem isSolutionAt_iff_components
    (q : ℝ → ℝ → ℝ → (Fin 5 → ℝ))
    (lam mu rho x y t : ℝ) (hrho : rho ≠ 0) :
    IsSolutionAt q lam mu rho x y t ↔
      IsComponentSystemAt q lam mu rho x y t := by
  constructor
  · rintro ⟨qt, qx, qy, ht, hx, hy, heq⟩
    exact ⟨qt, qx, qy, ht, hx, hy,
      (residual_iff_components lam mu rho hrho qt qx qy).mp heq⟩
  · rintro ⟨qt, qx, qy, ht, hx, hy, heq⟩
    exact ⟨qt, qx, qy, ht, hx, hy,
      (residual_iff_components lam mu rho hrho qt qx qy).mpr heq⟩

/-- The shear couplings in both coordinate symbols, and the y evolution of
the transverse normal strain, are nonzero for positive material parameters.
These remain nonzero when `lam = 0`. -/
theorem crossCouplingsNonzero (lam mu rho : ℝ)
    (hrho : 0 < rho) (hmu : 0 < mu) :
    xSymbol lam mu rho 4 2 ≠ 0 ∧
      ySymbol lam mu rho 3 2 ≠ 0 ∧
      ySymbol lam mu rho 1 4 ≠ 0 := by
  have hshear : 0 < 2 * mu / rho := div_pos (by positivity) hrho
  constructor
  · simpa [xSymbol] using (neg_ne_zero.mpr (ne_of_gt hshear))
  constructor
  · simpa [ySymbol] using (neg_ne_zero.mpr (ne_of_gt hshear))
  · change (-1 : ℝ) ≠ 0
    norm_num

/-- The full x-symbol preserves the four-dimensional plane-motion subspace,
and its restriction is exactly the established P/S pair of matrices. -/
theorem xSymbol_planeState (lam mu rho : ℝ) (p s : Fin 2 → ℝ) :
    (xSymbol lam mu rho).mulVec (planeState p s) =
      planeState
        ((pWaveCoefficientMatrix lam mu rho).mulVec p)
        ((shearWaveCoefficientMatrix mu rho).mulVec s) := by
  ext i
  fin_cases i <;>
    simp [xSymbol, planeState, pWaveCoefficientMatrix,
      shearWaveCoefficientMatrix, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ]

theorem planeState_add (p₁ p₂ s₁ s₂ : Fin 2 → ℝ) :
    planeState p₁ s₁ + planeState p₂ s₂ =
      planeState (p₁ + p₂) (s₁ + s₂) := by
  ext i
  fin_cases i <;> simp [planeState, Pi.add_apply]

theorem planeState_eq_zero_iff (p s : Fin 2 → ℝ) :
    planeState p s = 0 ↔ p = 0 ∧ s = 0 := by
  constructor
  · intro h
    constructor
    · ext i
      fin_cases i
      · simpa [planeState] using congrFun h (0 : Fin 5)
      · simpa [planeState] using congrFun h (3 : Fin 5)
    · ext i
      fin_cases i
      · simpa [planeState] using congrFun h (2 : Fin 5)
      · simpa [planeState] using congrFun h (4 : Fin 5)
  · rintro ⟨rfl, rfl⟩
    ext i
    fin_cases i <;> simp [planeState]

/-- Algebraic residual of the restricted five-field x equation vanishes
exactly when both two-field P and S residuals vanish. -/
theorem planeResidual_iff (lam mu rho : ℝ)
    (pt px st sx : Fin 2 → ℝ) :
    planeState pt st +
        (xSymbol lam mu rho).mulVec (planeState px sx) = 0 ↔
      pt + (pWaveCoefficientMatrix lam mu rho).mulVec px = 0 ∧
      st + (shearWaveCoefficientMatrix mu rho).mulVec sx = 0 := by
  rw [xSymbol_planeState, planeState_add]
  exact planeState_eq_zero_iff _ _

/-- PDE-level P/S decoupling of the x-only plane-motion restriction of the
five-field system. The stationary transverse normal strain is identically
zero because the state comes from x-only planar displacement. -/
theorem xOnlySolution_iff (lam mu rho x t : ℝ)
    (p s : ℝ → ℝ → (Fin 2 → ℝ)) :
    NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (fun x t => planeState (p x t) (s x t)) (xSymbol lam mu rho) x t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
          p (pWaveCoefficientMatrix lam mu rho) x t ∧
        NumStability.IsConstantCoefficientLinearSystemSolutionAt
          s (shearWaveCoefficientMatrix mu rho) x t := by
  constructor
  · rintro ⟨qt, qx, ht, hx, heq⟩
    let pt : Fin 2 → ℝ := ![qt 0, qt 3]
    let px : Fin 2 → ℝ := ![qx 0, qx 3]
    let st : Fin 2 → ℝ := ![qt 2, qt 4]
    let sx : Fin 2 → ℝ := ![qx 2, qx 4]
    have hqt1 : qt 1 = 0 := by
      have h := hasDerivAt_pi.mp ht (1 : Fin 5)
      have hc : HasDerivAt (fun _ : ℝ => (0 : ℝ)) 0 t := hasDerivAt_const t 0
      exact h.unique (by simpa [planeState] using hc)
    have hqx1 : qx 1 = 0 := by
      have h := hasDerivAt_pi.mp hx (1 : Fin 5)
      have hc : HasDerivAt (fun _ : ℝ => (0 : ℝ)) 0 x := hasDerivAt_const x 0
      exact h.unique (by simpa [planeState] using hc)
    have hqt : qt = planeState pt st := by
      ext i
      fin_cases i <;> simp [planeState, pt, st, hqt1]
    have hqx : qx = planeState px sx := by
      ext i
      fin_cases i <;> simp [planeState, px, sx, hqx1]
    rw [hqt, hqx] at heq
    have hres := (planeResidual_iff lam mu rho pt px st sx).mp heq
    constructor
    · refine ⟨pt, px, ?_, ?_, hres.1⟩
      · apply hasDerivAt_pi.mpr
        intro i
        fin_cases i
        · simpa [planeState, pt] using hasDerivAt_pi.mp ht (0 : Fin 5)
        · simpa [planeState, pt] using hasDerivAt_pi.mp ht (3 : Fin 5)
      · apply hasDerivAt_pi.mpr
        intro i
        fin_cases i
        · simpa [planeState, px] using hasDerivAt_pi.mp hx (0 : Fin 5)
        · simpa [planeState, px] using hasDerivAt_pi.mp hx (3 : Fin 5)
    · refine ⟨st, sx, ?_, ?_, hres.2⟩
      · apply hasDerivAt_pi.mpr
        intro i
        fin_cases i
        · simpa [planeState, st] using hasDerivAt_pi.mp ht (2 : Fin 5)
        · simpa [planeState, st] using hasDerivAt_pi.mp ht (4 : Fin 5)
      · apply hasDerivAt_pi.mpr
        intro i
        fin_cases i
        · simpa [planeState, sx] using hasDerivAt_pi.mp hx (2 : Fin 5)
        · simpa [planeState, sx] using hasDerivAt_pi.mp hx (4 : Fin 5)
  · rintro ⟨⟨pt, px, hpt, hpx, hp⟩, ⟨st, sx, hst, hsx, hs⟩⟩
    refine ⟨planeState pt st, planeState px sx, ?_, ?_, ?_⟩
    · apply hasDerivAt_pi.mpr
      intro i
      fin_cases i
      · simpa [planeState] using hasDerivAt_pi.mp hpt (0 : Fin 2)
      · simpa [planeState] using (hasDerivAt_const t (0 : ℝ))
      · simpa [planeState] using hasDerivAt_pi.mp hst (0 : Fin 2)
      · simpa [planeState] using hasDerivAt_pi.mp hpt (1 : Fin 2)
      · simpa [planeState] using hasDerivAt_pi.mp hst (1 : Fin 2)
    · apply hasDerivAt_pi.mpr
      intro i
      fin_cases i
      · simpa [planeState] using hasDerivAt_pi.mp hpx (0 : Fin 2)
      · simpa [planeState] using (hasDerivAt_const x (0 : ℝ))
      · simpa [planeState] using hasDerivAt_pi.mp hsx (0 : Fin 2)
      · simpa [planeState] using hasDerivAt_pi.mp hpx (1 : Fin 2)
      · simpa [planeState] using hasDerivAt_pi.mp hsx (1 : Fin 2)
    · exact (planeResidual_iff lam mu rho pt px st sx).mpr ⟨hp, hs⟩

/-- The two-dimensional five-field predicate, when evaluated on a plane
motion independent of y, is exactly the pair of one-dimensional P/S systems. -/
theorem twoDimensionalPlaneMotion_iff
    (lam mu rho x y t : ℝ) (p s : ℝ → ℝ → (Fin 2 → ℝ)) :
    IsSolutionAt
        (fun x _ t => planeState (p x t) (s x t))
        lam mu rho x y t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
          p (pWaveCoefficientMatrix lam mu rho) x t ∧
        NumStability.IsConstantCoefficientLinearSystemSolutionAt
          s (shearWaveCoefficientMatrix mu rho) x t := by
  rw [show IsSolutionAt
        (fun x _ t => planeState (p x t) (s x t))
        lam mu rho x y t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (fun x t => planeState (p x t) (s x t))
        (xSymbol lam mu rho) x t by
    constructor
    · rintro ⟨qt, qx, qy, ht, hx, hy, heq⟩
      have hy0 : qy = 0 :=
        hy.unique (by simpa using
          (hasDerivAt_const y (planeState (p x t) (s x t))))
      refine ⟨qt, qx, ht, hx, ?_⟩
      simpa [hy0] using heq
    · rintro ⟨qt, qx, ht, hx, heq⟩
      refine ⟨qt, qx, 0, ht, hx, ?_, ?_⟩
      · simpa using (hasDerivAt_const y (planeState (p x t) (s x t)))
      · simpa using heq]
  exact xOnlySolution_iff lam mu rho x t p s

end NumStability.Leveque02Tracer.PlaneElasticity

namespace NumStability.Leveque02Tracer.PlaneElasticity

private def pVector (nx ny c : ℝ) : Fin 5 → ℝ :=
  ![nx ^ 2, ny ^ 2, nx * ny, -c * nx, -c * ny]

private theorem pVector_eigen (lam mu rho nx ny c : ℝ)
    (hc : c ^ 2 = ((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2)) :
    (directionalSymbol lam mu rho nx ny).mulVec (pVector nx ny c) =
      c • pVector nx ny c := by
  rw [add_div] at hc
  ext i
  fin_cases i <;>
    simp [directionalSymbol, xSymbol, ySymbol, pVector, add_div,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ, Pi.smul_apply] <;>
    nlinarith [congrArg (fun z : ℝ => z * nx) hc,
      congrArg (fun z : ℝ => z * ny) hc]

private noncomputable def sVector (nx ny c : ℝ) : Fin 5 → ℝ :=
  ![-(nx * ny), nx * ny, (nx ^ 2 - ny ^ 2) / 2, c * ny, -c * nx]

private theorem sVector_eigen (lam mu rho nx ny c : ℝ)
    (hc : c ^ 2 = (mu / rho) * (nx ^ 2 + ny ^ 2)) :
    (directionalSymbol lam mu rho nx ny).mulVec (sVector nx ny c) =
      c • sVector nx ny c := by
  ext i
  fin_cases i <;>
    simp [directionalSymbol, xSymbol, ySymbol, sVector, add_div,
      mul_div_assoc,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ, Pi.smul_apply] <;>
    nlinarith [congrArg (fun z : ℝ => z * nx) hc,
      congrArg (fun z : ℝ => z * ny) hc]

private def stationaryVector (lam mu nx ny : ℝ) : Fin 5 → ℝ :=
  ![(lam + 2 * mu) * ny ^ 2 - lam * nx ^ 2,
    (lam + 2 * mu) * nx ^ 2 - lam * ny ^ 2,
    -2 * (lam + mu) * nx * ny, 0, 0]

private theorem stationaryVector_eigen (lam mu rho nx ny : ℝ) :
    (directionalSymbol lam mu rho nx ny).mulVec
        (stationaryVector lam mu nx ny) =
      0 • stationaryVector lam mu nx ny := by
  ext i
  fin_cases i <;>
    simp [directionalSymbol, xSymbol, ySymbol, stationaryVector,
      add_div, mul_div_assoc, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ] <;>
    ring

private theorem pVector_ne_zero (nx ny c : ℝ)
    (hc : c ≠ 0) (hn : nx ≠ 0 ∨ ny ≠ 0) :
    pVector nx ny c ≠ 0 := by
  intro h
  rcases hn with hnx | hny
  · have hv : -c * nx = 0 := by simpa [pVector] using congrFun h (3 : Fin 5)
    exact (mul_ne_zero (neg_ne_zero.mpr hc) hnx) hv
  · have hv : -c * ny = 0 := by simpa [pVector] using congrFun h (4 : Fin 5)
    exact (mul_ne_zero (neg_ne_zero.mpr hc) hny) hv

private theorem sVector_ne_zero (nx ny c : ℝ)
    (hc : c ≠ 0) (hn : nx ≠ 0 ∨ ny ≠ 0) :
    sVector nx ny c ≠ 0 := by
  intro h
  rcases hn with hnx | hny
  · have hv : -c * nx = 0 := by simpa [sVector] using congrFun h (4 : Fin 5)
    exact (mul_ne_zero (neg_ne_zero.mpr hc) hnx) hv
  · have hv : c * ny = 0 := by simpa [sVector] using congrFun h (3 : Fin 5)
    exact (mul_ne_zero hc hny) hv

private theorem stationaryVector_ne_zero (lam mu nx ny : ℝ)
    (hmu : 0 < mu) (hn : 0 < nx ^ 2 + ny ^ 2) :
    stationaryVector lam mu nx ny ≠ 0 := by
  intro h
  have h0 : (lam + 2 * mu) * ny ^ 2 - lam * nx ^ 2 = 0 := by
    simpa [stationaryVector] using congrFun h (0 : Fin 5)
  have h1 : (lam + 2 * mu) * nx ^ 2 - lam * ny ^ 2 = 0 := by
    simpa [stationaryVector] using congrFun h (1 : Fin 5)
  have hpos : 0 < (2 * mu) * (nx ^ 2 + ny ^ 2) :=
    mul_pos (by positivity) hn
  nlinarith

private theorem direction_norm_sq_pos (nx ny : ℝ)
    (hdir : nx ≠ 0 ∨ ny ≠ 0) : 0 < nx ^ 2 + ny ^ 2 := by
  rcases hdir with hnx | hny
  · nlinarith [sq_pos_of_ne_zero hnx, sq_nonneg ny]
  · nlinarith [sq_pos_of_ne_zero hny, sq_nonneg nx]

private theorem directional_speed_data
    (lam mu rho nx ny : ℝ)
    (hrho : 0 < rho) (hmu : 0 < mu) (hbulk : 0 < lam + mu)
    (hn : 0 < nx ^ 2 + ny ^ 2) :
    let cp := Real.sqrt (((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2))
    let cs := Real.sqrt ((mu / rho) * (nx ^ 2 + ny ^ 2))
    0 < cs ∧ cs < cp ∧
      cp ^ 2 = ((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2) ∧
      cs ^ 2 = (mu / rho) * (nx ^ 2 + ny ^ 2) := by
  dsimp
  have hK : 0 < lam + 2 * mu := by linarith
  have hSarg : 0 < (mu / rho) * (nx ^ 2 + ny ^ 2) :=
    mul_pos (div_pos hmu hrho) hn
  have hParg : 0 < ((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2) :=
    mul_pos (div_pos hK hrho) hn
  have harg : (mu / rho) * (nx ^ 2 + ny ^ 2) <
      ((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2) := by
    apply mul_lt_mul_of_pos_right _ hn
    exact div_lt_div_of_pos_right (by linarith) hrho
  exact ⟨Real.sqrt_pos.2 hSarg,
    Real.sqrt_lt_sqrt hSarg.le harg,
    Real.sq_sqrt hParg.le,
    Real.sq_sqrt hSarg.le⟩

private def elasticEigenvalues (cp cs : ℝ) : Fin 5 → ℝ :=
  ![0, cp, -cp, cs, -cs]

private theorem elasticEigenvalues_injective (cp cs : ℝ)
    (hcs : 0 < cs) (hpc : cs < cp) :
    Function.Injective (elasticEigenvalues cp cs) := by
  intro i j hij
  fin_cases i <;> fin_cases j <;>
    simp [elasticEigenvalues] at hij ⊢ <;>
    linarith

private noncomputable def elasticEigenvectors
    (lam mu nx ny cp cs : ℝ) : Fin 5 → (Fin 5 → ℝ) :=
  ![stationaryVector lam mu nx ny,
    pVector nx ny cp, pVector nx ny (-cp),
    sVector nx ny cs, sVector nx ny (-cs)]

private noncomputable def strainBasis (lam mu nx ny : ℝ) :
    Matrix (Fin 3) (Fin 3) ℝ :=
  !![(lam + 2 * mu) * ny ^ 2 - lam * nx ^ 2,
      nx ^ 2, -(nx * ny);
     (lam + 2 * mu) * nx ^ 2 - lam * ny ^ 2,
      ny ^ 2, nx * ny;
     -2 * (lam + mu) * nx * ny,
      nx * ny, (nx ^ 2 - ny ^ 2) / 2]

private theorem strainBasis_det (lam mu nx ny : ℝ) :
    (strainBasis lam mu nx ny).det =
      -((lam + 2 * mu) * (nx ^ 2 + ny ^ 2) ^ 3) / 2 := by
  simp [strainBasis, Matrix.det_fin_three]
  ring

private theorem eigenvector_strain_combination
    (lam mu nx ny cp cs : ℝ) (g : Fin 5 → ℝ)
    (hg : ∑ i, g i • elasticEigenvectors lam mu nx ny cp cs i = 0) :
    (strainBasis lam mu nx ny).mulVec
        ![g 0, g 1 + g 2, g 3 + g 4] = 0 := by
  ext i
  fin_cases i
  · have hi := congrFun hg (0 : Fin 5)
    simp [strainBasis, elasticEigenvectors, stationaryVector,
      pVector, sVector, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Pi.smul_apply, smul_eq_mul] at hi ⊢
    linear_combination hi

  · have hi := congrFun hg (1 : Fin 5)
    simp [strainBasis, elasticEigenvectors, stationaryVector,
      pVector, sVector, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Pi.smul_apply, smul_eq_mul] at hi ⊢
    linear_combination hi
  · have hi := congrFun hg (2 : Fin 5)
    simp [strainBasis, elasticEigenvectors, stationaryVector,
      pVector, sVector, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Pi.smul_apply, smul_eq_mul] at hi ⊢
    linear_combination hi

private theorem eigenvector_strain_coefficients_zero
    (lam mu nx ny cp cs : ℝ)
    (hK : 0 < lam + 2 * mu) (hn : 0 < nx ^ 2 + ny ^ 2)
    (g : Fin 5 → ℝ)
    (hg : ∑ i, g i • elasticEigenvectors lam mu nx ny cp cs i = 0) :
    g 0 = 0 ∧ g 1 + g 2 = 0 ∧ g 3 + g 4 = 0 := by
  have hdet : (strainBasis lam mu nx ny).det ≠ 0 := by
    rw [strainBasis_det]
    have hpos : 0 < (lam + 2 * mu) * (nx ^ 2 + ny ^ 2) ^ 3 := by
      positivity
    exact ne_of_lt (div_neg_of_neg_of_pos (neg_neg_of_pos hpos) (by norm_num))
  have hc := Matrix.eq_zero_of_mulVec_eq_zero hdet
    (eigenvector_strain_combination lam mu nx ny cp cs g hg)
  exact ⟨by simpa using congrFun hc (0 : Fin 3),
    by simpa using congrFun hc (1 : Fin 3),
    by simpa using congrFun hc (2 : Fin 3)⟩

private def velocityBasis (nx ny cp cs : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![-cp * nx, cs * ny; -cp * ny, -cs * nx]

private theorem velocityBasis_det (nx ny cp cs : ℝ) :
    (velocityBasis nx ny cp cs).det =
      cp * cs * (nx ^ 2 + ny ^ 2) := by
  simp [velocityBasis, Matrix.det_fin_two]
  ring

private theorem eigenvector_velocity_combination
    (lam mu nx ny cp cs : ℝ) (g : Fin 5 → ℝ)
    (hg : ∑ i, g i • elasticEigenvectors lam mu nx ny cp cs i = 0) :
    (velocityBasis nx ny cp cs).mulVec
        ![g 1 - g 2, g 3 - g 4] = 0 := by
  ext i
  fin_cases i
  · have hi := congrFun hg (3 : Fin 5)
    simp [velocityBasis, elasticEigenvectors, stationaryVector,
      pVector, sVector, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Pi.smul_apply, smul_eq_mul] at hi ⊢
    linear_combination hi
  · have hi := congrFun hg (4 : Fin 5)
    simp [velocityBasis, elasticEigenvectors, stationaryVector,
      pVector, sVector, Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      Pi.smul_apply, smul_eq_mul] at hi ⊢
    linear_combination hi

private theorem eigenvector_velocity_coefficients_zero
    (lam mu nx ny cp cs : ℝ)
    (hcp : 0 < cp) (hcs : 0 < cs)
    (hn : 0 < nx ^ 2 + ny ^ 2) (g : Fin 5 → ℝ)
    (hg : ∑ i, g i • elasticEigenvectors lam mu nx ny cp cs i = 0) :
    g 1 - g 2 = 0 ∧ g 3 - g 4 = 0 := by
  have hdet : (velocityBasis nx ny cp cs).det ≠ 0 := by
    rw [velocityBasis_det]
    exact ne_of_gt (by positivity)
  have hc := Matrix.eq_zero_of_mulVec_eq_zero hdet
    (eigenvector_velocity_combination lam mu nx ny cp cs g hg)
  exact ⟨by simpa using congrFun hc (0 : Fin 2),
    by simpa using congrFun hc (1 : Fin 2)⟩

private theorem elasticEigenvectors_independent
    (lam mu nx ny cp cs : ℝ)
    (hK : 0 < lam + 2 * mu) (hcp : 0 < cp) (hcs : 0 < cs)
    (hn : 0 < nx ^ 2 + ny ^ 2) :
    LinearIndependent ℝ (elasticEigenvectors lam mu nx ny cp cs) := by
  apply Fintype.linearIndependent_iff.mpr
  intro g hg i
  obtain ⟨h0, h12, h34⟩ :=
    eigenvector_strain_coefficients_zero lam mu nx ny cp cs hK hn g hg
  obtain ⟨hd12, hd34⟩ :=
    eigenvector_velocity_coefficients_zero lam mu nx ny cp cs hcp hcs hn g hg
  have h1 : g 1 = 0 := by linarith
  have h2 : g 2 = 0 := by linarith
  have h3 : g 3 = 0 := by linarith
  have h4 : g 4 = 0 := by linarith
  fin_cases i <;> simp [h0, h1, h2, h3, h4]

private theorem directional_hyperbolic_nonzero
    (lam mu rho nx ny : ℝ)
    (hrho : 0 < rho) (hmu : 0 < mu) (hK : 0 < lam + 2 * mu)
    (hdir : nx ≠ 0 ∨ ny ≠ 0) :
    NumStability.IsRealHyperbolicMatrix
      (directionalSymbol lam mu rho nx ny) := by
  let cp : ℝ := Real.sqrt (((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2))
  let cs : ℝ := Real.sqrt ((mu / rho) * (nx ^ 2 + ny ^ 2))
  have hn : 0 < nx ^ 2 + ny ^ 2 := direction_norm_sq_pos nx ny hdir
  have hpArg : 0 < ((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2) :=
    mul_pos (div_pos hK hrho) hn
  have hsArg : 0 < (mu / rho) * (nx ^ 2 + ny ^ 2) :=
    mul_pos (div_pos hmu hrho) hn
  have hcp : 0 < cp := Real.sqrt_pos.2 hpArg
  have hcs : 0 < cs := Real.sqrt_pos.2 hsArg
  have hcpSq : cp ^ 2 = ((lam + 2 * mu) / rho) * (nx ^ 2 + ny ^ 2) :=
    Real.sq_sqrt hpArg.le
  have hcsSq : cs ^ 2 = (mu / rho) * (nx ^ 2 + ny ^ 2) :=
    Real.sq_sqrt hsArg.le
  let ev := elasticEigenvalues cp cs
  let evec := elasticEigenvectors lam mu nx ny cp cs
  have heigen : ∀ i, (directionalSymbol lam mu rho nx ny).mulVec (evec i) =
      ev i • evec i := by
    intro i
    fin_cases i
    · simpa [ev, evec, elasticEigenvalues, elasticEigenvectors] using
        stationaryVector_eigen lam mu rho nx ny
    · simpa [ev, evec, elasticEigenvalues, elasticEigenvectors] using
        pVector_eigen lam mu rho nx ny cp hcpSq
    · have hneg : (-cp) ^ 2 = ((lam + 2 * mu) / rho) *
          (nx ^ 2 + ny ^ 2) := by simpa using hcpSq
      simpa [ev, evec, elasticEigenvalues, elasticEigenvectors] using
        pVector_eigen lam mu rho nx ny (-cp) hneg
    · simpa [ev, evec, elasticEigenvalues, elasticEigenvectors] using
        sVector_eigen lam mu rho nx ny cs hcsSq
    · have hneg : (-cs) ^ 2 = (mu / rho) *
          (nx ^ 2 + ny ^ 2) := by simpa using hcsSq
      simpa [ev, evec, elasticEigenvalues, elasticEigenvectors] using
        sVector_eigen lam mu rho nx ny (-cs) hneg
  have hindependent : LinearIndependent ℝ evec :=
    elasticEigenvectors_independent lam mu nx ny cp cs hK hcp hcs hn
  exact (NumStability.isRealHyperbolicMatrix_iff_independent_real_eigenvectors
    (directionalSymbol lam mu rho nx ny)).mpr
      ⟨ev, evec, hindependent, heigen⟩

/-- Full five-field real directional hyperbolicity under the positive
density and P/S speed assumptions from the source. The proof remains valid
when the P and S speeds coincide at `lam+mu=0`. -/
theorem directionalHyperbolicity
    (lam mu rho nx ny : ℝ)
    (hrho : 0 < rho) (hmu : 0 < mu) (hK : 0 < lam + 2 * mu) :
    NumStability.IsRealHyperbolicMatrix
      (directionalSymbol lam mu rho nx ny) := by
  by_cases hzero : nx = 0 ∧ ny = 0
  · rcases hzero with ⟨rfl, rfl⟩
    have hz : directionalSymbol lam mu rho 0 0 = 0 := by
      simp [directionalSymbol]
    rw [hz]
    exact NumStability.IsRealHyperbolicMatrix.of_symm (by simp)
  · have hdir : nx ≠ 0 ∨ ny ≠ 0 := by tauto
    exact directional_hyperbolic_nonzero lam mu rho nx ny
      hrho hmu hK hdir

theorem directionalHyperbolicityTarget_proved :
    directionalHyperbolicityTarget := by
  intro lam mu rho nx ny hrho hmu hK
  exact directionalHyperbolicity lam mu rho nx ny hrho hmu hK

/-- The positive two-dimensional bulk regime is an immediate special case. -/
theorem directionalHyperbolicity_positiveBulk
    (lam mu rho nx ny : ℝ)
    (hrho : 0 < rho) (hmu : 0 < mu) (hbulk : 0 < lam + mu) :
    NumStability.IsRealHyperbolicMatrix
      (directionalSymbol lam mu rho nx ny) := by
  apply directionalHyperbolicity lam mu rho nx ny hrho hmu
  linarith

/-- Exact combined scratch target for C2.U.082. -/
theorem fiveFieldElasticityTarget_proved : fiveFieldElasticityTarget := by
  refine ⟨?_, ?_, ?_, ?_, directionalHyperbolicityTarget_proved⟩
  · intro lam mu e
    simp [isotropicStress]
  · intro q lam mu rho x y t hrho
    exact isSolutionAt_iff_components q lam mu rho x y t (ne_of_gt hrho)
  · intro lam mu rho hrho hmu
    exact crossCouplingsNonzero lam mu rho hrho hmu
  · intro p s lam mu rho x y t _ _ _
    exact twoDimensionalPlaneMotion_iff lam mu rho x y t p s

private theorem stressResidual_iff_components (lam mu rho : ℝ)
    (hrho : rho ≠ 0) (qt qx qy : Fin 5 → ℝ) :
    qt + (stressXSymbol lam mu rho).mulVec qx +
        (stressYSymbol lam mu rho).mulVec qy = 0 ↔
      StressComponentEquations lam mu rho qt qx qy := by
  constructor
  · intro h
    have h0 := congrFun h (0 : Fin 5)
    have h1 := congrFun h (1 : Fin 5)
    have h2 := congrFun h (2 : Fin 5)
    have h3 := congrFun h (3 : Fin 5)
    have h4 := congrFun h (4 : Fin 5)
    simp [stressXSymbol, stressYSymbol, Matrix.vecHead,
      Matrix.vecTail, dotProduct, Fin.sum_univ_succ] at h0 h1 h2 h3 h4
    refine ⟨?_, ?_, ?_, ?_, ?_⟩
    · linear_combination h0
    · linear_combination h1
    · linear_combination h2
    · field_simp [hrho] at h3
      linear_combination h3
    · field_simp [hrho] at h4
      linear_combination h4
  · rintro ⟨h0, h1, h2, h3, h4⟩
    ext i
    fin_cases i
    · simp [stressXSymbol, stressYSymbol, Matrix.vecHead,
        Matrix.vecTail, dotProduct, Fin.sum_univ_succ]
      linear_combination h0
    · simp [stressXSymbol, stressYSymbol, Matrix.vecHead,
        Matrix.vecTail, dotProduct, Fin.sum_univ_succ]
      linear_combination h1
    · simp [stressXSymbol, stressYSymbol, Matrix.vecHead,
        Matrix.vecTail, dotProduct, Fin.sum_univ_succ]
      linear_combination h2
    · simp [stressXSymbol, stressYSymbol, Matrix.vecHead,
        Matrix.vecTail, dotProduct, Fin.sum_univ_succ]
      field_simp [hrho]
      linear_combination h3
    · simp [stressXSymbol, stressYSymbol, Matrix.vecHead,
        Matrix.vecTail, dotProduct, Fin.sum_univ_succ]
      field_simp [hrho]
      linear_combination h4

private theorem stressMatrix_iff_components
    (q : ℝ → ℝ → ℝ → (Fin 5 → ℝ))
    (lam mu rho x y t : ℝ) (hrho : rho ≠ 0) :
    IsStressMatrixSolutionAt q lam mu rho x y t ↔
      IsStressComponentSolutionAt q lam mu rho x y t := by
  constructor
  · rintro ⟨qt, qx, qy, ht, hx, hy, heq⟩
    exact ⟨qt, qx, qy, ht, hx, hy,
      (stressResidual_iff_components lam mu rho hrho qt qx qy).mp heq⟩
  · rintro ⟨qt, qx, qy, ht, hx, hy, heq⟩
    exact ⟨qt, qx, qy, ht, hx, hy,
      (stressResidual_iff_components lam mu rho hrho qt qx qy).mpr heq⟩

private theorem stressX_intertwine (lam mu rho : ℝ) (q : Fin 5 → ℝ) :
    (stressXSymbol lam mu rho).mulVec (stressOfStrain lam mu q) =
      stressOfStrain lam mu ((xSymbol lam mu rho).mulVec q) := by
  ext i
  fin_cases i <;>
    simp [stressXSymbol, stressOfStrain, xSymbol, Matrix.mulVec,
      dotProduct, Fin.sum_univ_succ, add_div, mul_div_assoc] <;>
    ring

private theorem stressY_intertwine (lam mu rho : ℝ) (q : Fin 5 → ℝ) :
    (stressYSymbol lam mu rho).mulVec (stressOfStrain lam mu q) =
      stressOfStrain lam mu ((ySymbol lam mu rho).mulVec q) := by
  ext i
  fin_cases i <;>
    simp [stressYSymbol, stressOfStrain, ySymbol, Matrix.mulVec,
      dotProduct, Fin.sum_univ_succ, add_div, mul_div_assoc] <;>
    ring

private theorem stressOfStrain_planeState (lam mu : ℝ) (p s : Fin 2 → ℝ) :
    stressOfStrain lam mu (planeState p s) =
      ![(lam + 2 * mu) * p 0, lam * p 0,
        2 * mu * s 0, p 1, s 1] := by
  ext i
  fin_cases i <;> simp [stressOfStrain, planeState]

private theorem pStressPair_intertwine (lam mu rho : ℝ) (p : Fin 2 → ℝ) :
    (pWaveStressVelocityMatrix lam mu rho).mulVec (pStressPair lam mu p) =
      pStressPair lam mu ((pWaveCoefficientMatrix lam mu rho).mulVec p) := by
  ext i
  fin_cases i <;>
    simp [pWaveStressVelocityMatrix, pStressPair, pWaveCoefficientMatrix,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;>
    ring

private theorem sStressPair_intertwine (mu rho : ℝ) (s : Fin 2 → ℝ) :
    (shearWaveStressVelocityMatrix mu rho).mulVec (sStressPair mu s) =
      sStressPair mu ((shearWaveCoefficientMatrix mu rho).mulVec s) := by
  ext i
  fin_cases i <;>
    simp [shearWaveStressVelocityMatrix, sStressPair, shearWaveCoefficientMatrix,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ, mul_div_assoc] <;>
    ring

/-- Exact Chapter 22 stress laws and constitutive bridge to the Chapter 2
strain-state model. -/
theorem stressChapter22Target_proved : stressChapter22Target := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro q lam mu rho x y t hrho
    exact stressMatrix_iff_components q lam mu rho x y t (ne_of_gt hrho)
  · intro lam mu rho q
    exact ⟨stressX_intertwine lam mu rho q,
      stressY_intertwine lam mu rho q⟩
  · intro lam mu p s
    exact stressOfStrain_planeState lam mu p s
  · intro lam mu rho p s
    exact ⟨pStressPair_intertwine lam mu rho p,
      sStressPair_intertwine mu rho s⟩

theorem chapter22CrossReferencedTarget_proved :
    chapter22CrossReferencedTarget :=
  ⟨fiveFieldElasticityTarget_proved, stressChapter22Target_proved,
    stressPrintedClaimsTarget_proved⟩


end NumStability.Leveque02Tracer.PlaneElasticity
