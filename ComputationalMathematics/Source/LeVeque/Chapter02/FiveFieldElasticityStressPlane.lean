/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FiveFieldElasticityTarget

/-! Direct proofs of Chapter 22's printed stress-state claims. -/
namespace NumStability.Leveque02Tracer.PlaneElasticity

private theorem stressX_planeState (lam mu rho : ℝ)
    (hK : lam + 2 * mu ≠ 0) (p s : Fin 2 → ℝ) :
    (stressXSymbol lam mu rho).mulVec (stressPlaneState lam mu p s) =
      stressPlaneState lam mu
        ((pWaveStressVelocityMatrix lam mu rho).mulVec p)
        ((shearWaveStressVelocityMatrix mu rho).mulVec s) := by
  ext i
  fin_cases i <;>
    simp [stressXSymbol, stressPlaneState, pWaveStressVelocityMatrix,
      shearWaveStressVelocityMatrix, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ] <;>
    field_simp [hK] <;> ring

private theorem stressPlaneState_add (lam mu : ℝ)
    (p₁ p₂ s₁ s₂ : Fin 2 → ℝ) :
    stressPlaneState lam mu p₁ s₁ +
        stressPlaneState lam mu p₂ s₂ =
      stressPlaneState lam mu (p₁ + p₂) (s₁ + s₂) := by
  ext i
  fin_cases i <;> simp [stressPlaneState, Pi.add_apply] <;> ring

private theorem stressPlaneState_eq_zero_iff (lam mu : ℝ)
    (p s : Fin 2 → ℝ) :
    stressPlaneState lam mu p s = 0 ↔ p = 0 ∧ s = 0 := by
  constructor
  · intro h
    constructor
    · ext i
      fin_cases i
      · simpa [stressPlaneState] using congrFun h (0 : Fin 5)
      · simpa [stressPlaneState] using congrFun h (3 : Fin 5)
    · ext i
      fin_cases i
      · simpa [stressPlaneState] using congrFun h (2 : Fin 5)
      · simpa [stressPlaneState] using congrFun h (4 : Fin 5)
  · rintro ⟨rfl, rfl⟩
    ext i
    fin_cases i <;> simp [stressPlaneState]

private theorem stressPlaneResidual_iff (lam mu rho : ℝ)
    (hK : lam + 2 * mu ≠ 0)
    (pt px st sx : Fin 2 → ℝ) :
    stressPlaneState lam mu pt st +
        (stressXSymbol lam mu rho).mulVec
          (stressPlaneState lam mu px sx) = 0 ↔
      pt + (pWaveStressVelocityMatrix lam mu rho).mulVec px = 0 ∧
      st + (shearWaveStressVelocityMatrix mu rho).mulVec sx = 0 := by
  rw [stressX_planeState lam mu rho hK, stressPlaneState_add]
  exact stressPlaneState_eq_zero_iff lam mu _ _

private theorem stressXOnlySolution_iff
    (lam mu rho x t : ℝ) (hK : lam + 2 * mu ≠ 0)
    (p s : ℝ → ℝ → (Fin 2 → ℝ)) :
    NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (fun x t => stressPlaneState lam mu (p x t) (s x t))
        (stressXSymbol lam mu rho) x t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
          p (pWaveStressVelocityMatrix lam mu rho) x t ∧
        NumStability.IsConstantCoefficientLinearSystemSolutionAt
          s (shearWaveStressVelocityMatrix mu rho) x t := by
  constructor
  · rintro ⟨qt, qx, ht, hx, heq⟩
    let pt : Fin 2 → ℝ := ![qt 0, qt 3]
    let px : Fin 2 → ℝ := ![qx 0, qx 3]
    let st : Fin 2 → ℝ := ![qt 2, qt 4]
    let sx : Fin 2 → ℝ := ![qx 2, qx 4]
    have hqt1 : qt 1 = lam / (lam + 2 * mu) * qt 0 := by
      have h0 : HasDerivAt (fun τ => p x τ 0) (qt 0) t := by
        simpa [stressPlaneState] using hasDerivAt_pi.mp ht (0 : Fin 5)
      have h1 := h0.const_mul (lam / (lam + 2 * mu))
      exact (hasDerivAt_pi.mp ht (1 : Fin 5)).unique
        (by simpa [stressPlaneState] using h1)
    have hqx1 : qx 1 = lam / (lam + 2 * mu) * qx 0 := by
      have h0 : HasDerivAt (fun ξ => p ξ t 0) (qx 0) x := by
        simpa [stressPlaneState] using hasDerivAt_pi.mp hx (0 : Fin 5)
      have h1 := h0.const_mul (lam / (lam + 2 * mu))
      exact (hasDerivAt_pi.mp hx (1 : Fin 5)).unique
        (by simpa [stressPlaneState] using h1)
    have hqt : qt = stressPlaneState lam mu pt st := by
      ext i
      fin_cases i <;> simp [stressPlaneState, pt, st, hqt1]
    have hqx : qx = stressPlaneState lam mu px sx := by
      ext i
      fin_cases i <;> simp [stressPlaneState, px, sx, hqx1]
    rw [hqt, hqx] at heq
    have hres := (stressPlaneResidual_iff lam mu rho hK pt px st sx).mp heq
    constructor
    · refine ⟨pt, px, ?_, ?_, hres.1⟩
      · apply hasDerivAt_pi.mpr
        intro i
        fin_cases i
        · simpa [stressPlaneState, pt] using hasDerivAt_pi.mp ht (0 : Fin 5)
        · simpa [stressPlaneState, pt] using hasDerivAt_pi.mp ht (3 : Fin 5)
      · apply hasDerivAt_pi.mpr
        intro i
        fin_cases i
        · simpa [stressPlaneState, px] using hasDerivAt_pi.mp hx (0 : Fin 5)
        · simpa [stressPlaneState, px] using hasDerivAt_pi.mp hx (3 : Fin 5)
    · refine ⟨st, sx, ?_, ?_, hres.2⟩
      · apply hasDerivAt_pi.mpr
        intro i
        fin_cases i
        · simpa [stressPlaneState, st] using hasDerivAt_pi.mp ht (2 : Fin 5)
        · simpa [stressPlaneState, st] using hasDerivAt_pi.mp ht (4 : Fin 5)
      · apply hasDerivAt_pi.mpr
        intro i
        fin_cases i
        · simpa [stressPlaneState, sx] using hasDerivAt_pi.mp hx (2 : Fin 5)
        · simpa [stressPlaneState, sx] using hasDerivAt_pi.mp hx (4 : Fin 5)
  · rintro ⟨⟨pt, px, hpt, hpx, hp⟩, ⟨st, sx, hst, hsx, hs⟩⟩
    refine ⟨stressPlaneState lam mu pt st,
      stressPlaneState lam mu px sx, ?_, ?_, ?_⟩
    · apply hasDerivAt_pi.mpr
      intro i
      fin_cases i
      · simpa [stressPlaneState] using hasDerivAt_pi.mp hpt (0 : Fin 2)
      · simpa [stressPlaneState] using
          (hasDerivAt_pi.mp hpt (0 : Fin 2)).const_mul
            (lam / (lam + 2 * mu))
      · simpa [stressPlaneState] using hasDerivAt_pi.mp hst (0 : Fin 2)
      · simpa [stressPlaneState] using hasDerivAt_pi.mp hpt (1 : Fin 2)
      · simpa [stressPlaneState] using hasDerivAt_pi.mp hst (1 : Fin 2)
    · apply hasDerivAt_pi.mpr
      intro i
      fin_cases i
      · simpa [stressPlaneState] using hasDerivAt_pi.mp hpx (0 : Fin 2)
      · simpa [stressPlaneState] using
          (hasDerivAt_pi.mp hpx (0 : Fin 2)).const_mul
            (lam / (lam + 2 * mu))
      · simpa [stressPlaneState] using hasDerivAt_pi.mp hsx (0 : Fin 2)
      · simpa [stressPlaneState] using hasDerivAt_pi.mp hpx (1 : Fin 2)
      · simpa [stressPlaneState] using hasDerivAt_pi.mp hsx (1 : Fin 2)
    · exact (stressPlaneResidual_iff lam mu rho hK pt px st sx).mpr ⟨hp, hs⟩

/-- Source-exact x-only stress PDE iff the P/S stress-velocity systems,
with the transverse normal stress constrained by (22.45). -/
theorem stressTwoDimensionalPlaneMotion_iff
    (lam mu rho x y t : ℝ) (hK : lam + 2 * mu ≠ 0)
    (p s : ℝ → ℝ → (Fin 2 → ℝ)) :
    IsStressMatrixSolutionAt
        (fun x _ t => stressPlaneState lam mu (p x t) (s x t))
        lam mu rho x y t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
          p (pWaveStressVelocityMatrix lam mu rho) x t ∧
        NumStability.IsConstantCoefficientLinearSystemSolutionAt
          s (shearWaveStressVelocityMatrix mu rho) x t := by
  rw [show IsStressMatrixSolutionAt
        (fun x _ t => stressPlaneState lam mu (p x t) (s x t))
        lam mu rho x y t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (fun x t => stressPlaneState lam mu (p x t) (s x t))
        (stressXSymbol lam mu rho) x t by
    constructor
    · rintro ⟨qt, qx, qy, ht, hx, hy, heq⟩
      have hy0 : qy = 0 :=
        hy.unique (by simpa using
          (hasDerivAt_const y (stressPlaneState lam mu (p x t) (s x t))))
      refine ⟨qt, qx, ht, hx, ?_⟩
      simpa [hy0] using heq
    · rintro ⟨qt, qx, ht, hx, heq⟩
      refine ⟨qt, qx, 0, ht, hx, ?_, ?_⟩
      · simpa using
          (hasDerivAt_const y (stressPlaneState lam mu (p x t) (s x t)))
      · simpa using heq]
  exact stressXOnlySolution_iff lam mu rho x t hK p s

end NumStability.Leveque02Tracer.PlaneElasticity
