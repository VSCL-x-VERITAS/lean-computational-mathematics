/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticSuperpositionTarget
import ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsEigenvalues
import ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.Superposition
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ClassicalCharacteristics

/-!
# General solution of stationary linear acoustics
-/

namespace NumStability.Leveque02Tracer
private theorem acousticSuperposition_fromPDE
    (K ρ : ℝ) (hK : 0 < K) (hρ : 0 < ρ)
    (p u : ℝ → ℝ → ℝ)
    (hq : Differentiable ℝ (Function.uncurry (linearAcousticsState p u)))
    (hpde : ∀ x t, IsLinearAcousticsSolutionAt p u K ρ x t) :
    let c := Real.sqrt (K / ρ)
    ∃ leftProfile rightProfile : ℝ → ℝ,
      Differentiable ℝ leftProfile ∧
        Differentiable ℝ rightProfile ∧
          ∀ x t,
            linearAcousticsState p u x t =
              leftProfile (x + c * t) • linearAcousticsLeftEigenvector ρ c +
                rightProfile (x - c * t) • linearAcousticsRightEigenvector ρ c := by
  dsimp only
  let c := Real.sqrt (K / ρ)
  let Z := ρ * c
  have hratio : 0 ≤ K / ρ := (div_pos hK hρ).le
  have hmaterial : K = ρ * c ^ 2 := by
    dsimp [c]
    rw [Real.sq_sqrt hratio]
    field_simp [ne_of_gt hρ]
  have hc : 0 < c := Real.sqrt_pos.2 (div_pos hK hρ)
  have hZ : 0 < Z := mul_pos hρ hc
  have hZne : Z ≠ 0 := ne_of_gt hZ
  have hslice : Differentiable ℝ (fun ξ => linearAcousticsState p u ξ 0) := by
    exact hq.comp ((differentiable_id).prodMk (differentiable_const (0 : ℝ)))
  have hp0 : Differentiable ℝ (fun ξ => p ξ 0) := by
    simpa only [linearAcousticsState, Matrix.cons_val_zero] using
      (differentiable_pi.mp hslice) (0 : Fin 2)
  have hu0 : Differentiable ℝ (fun ξ => u ξ 0) := by
    simpa only [linearAcousticsState, Matrix.cons_val_one, Matrix.cons_val_zero] using
      (differentiable_pi.mp hslice) (1 : Fin 2)
  have hp : Differentiable ℝ (Function.uncurry p) := by
    simpa only [linearAcousticsState, Function.uncurry_apply_pair,
      Matrix.cons_val_zero] using
      (differentiable_pi.mp hq) (0 : Fin 2)
  have hu : Differentiable ℝ (Function.uncurry u) := by
    simpa only [linearAcousticsState, Function.uncurry_apply_pair,
      Matrix.cons_val_one, Matrix.cons_val_zero] using
      (differentiable_pi.mp hq) (1 : Fin 2)
  have hLdiff : Differentiable ℝ
      (Function.uncurry (linearAcousticsLeftInvariant p u ρ c)) := by
    simpa only [linearAcousticsLeftInvariant, Function.uncurry_apply_pair,
      Z] using hp.sub (hu.const_mul Z)
  have hRdiff : Differentiable ℝ
      (Function.uncurry (linearAcousticsRightInvariant p u ρ c)) := by
    simpa only [linearAcousticsRightInvariant, Function.uncurry_apply_pair,
      Z] using hp.add (hu.const_mul Z)
  have hLadv : IsLinearAdvectionSolution
      (linearAcousticsLeftInvariant p u ρ c) (-c) := by
    intro x t
    exact linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt
      p u K ρ c x t (ne_of_gt hρ) hmaterial (hpde x t)
  have hRadv : IsLinearAdvectionSolution
      (linearAcousticsRightInvariant p u ρ c) c := by
    intro x t
    exact linearAcousticsRightInvariant_isLinearAdvectionSolutionAt
      p u K ρ c x t (ne_of_gt hρ) hmaterial (hpde x t)
  have hLprop (x t : ℝ) :
      p x t - Z * u x t = p (x + c * t) 0 - Z * u (x + c * t) 0 := by
    have h := congrFun (congrFun
      (linearAdvection_eq_travelingWave_of_differentiable hLdiff hLadv) x) t
    simpa [travelingWave, linearAcousticsLeftInvariant, Z] using h
  have hRprop (x t : ℝ) :
      p x t + Z * u x t = p (x - c * t) 0 + Z * u (x - c * t) 0 := by
    have h := congrFun (congrFun
      (linearAdvection_eq_travelingWave_of_differentiable hRdiff hRadv) x) t
    simpa [travelingWave, linearAcousticsRightInvariant, Z] using h
  let leftProfile : ℝ → ℝ := fun ξ => (-p ξ 0 + Z * u ξ 0) / (2 * Z)
  let rightProfile : ℝ → ℝ := fun ξ => (p ξ 0 + Z * u ξ 0) / (2 * Z)
  refine ⟨leftProfile, rightProfile, ?_, ?_, ?_⟩
  · exact ((hp0.neg.add (hu0.const_mul Z)).div_const _)
  · exact ((hp0.add (hu0.const_mul Z)).div_const _)
  · intro x t
    have hL : p x t - Z * u x t = -2 * Z * leftProfile (x + c * t) := by
      rw [hLprop]
      dsimp [leftProfile]
      field_simp [hZne]
      ring
    have hR : p x t + Z * u x t = 2 * Z * rightProfile (x - c * t) := by
      rw [hRprop]
      dsimp [rightProfile]
      field_simp [hZne]
    funext i
    fin_cases i
    · simp [linearAcousticsState, linearAcousticsLeftEigenvector,
        linearAcousticsRightEigenvector, Z] at hL hR ⊢
      linarith [hL, hR]
    · simp [linearAcousticsState, linearAcousticsLeftEigenvector,
        linearAcousticsRightEigenvector, Z] at hL hR ⊢
      nlinarith [hL, hR, hZ]


private theorem acousticSuperposition_fromProfiles
    (bulkModulus density : ℝ) (hbulk : 0 < bulkModulus) (hdensity : 0 < density)
    (pressure velocity : ℝ → ℝ → ℝ)
    (leftProfile rightProfile : ℝ → ℝ)
    (hleftdiff : Differentiable ℝ leftProfile)
    (hrightdiff : Differentiable ℝ rightProfile)
    (hform : ∀ x t,
      linearAcousticsState pressure velocity x t =
        leftProfile (x + Real.sqrt (bulkModulus / density) * t) •
          linearAcousticsLeftEigenvector density (Real.sqrt (bulkModulus / density)) +
        rightProfile (x - Real.sqrt (bulkModulus / density) * t) •
          linearAcousticsRightEigenvector density (Real.sqrt (bulkModulus / density))) :
    ∀ x t, IsLinearAcousticsSolutionAt pressure velocity bulkModulus density x t := by
  let c := Real.sqrt (bulkModulus / density)
  have hac := leveque01_acousticsMatrixEigenvalues hbulk hdensity
  dsimp only at hac
  rcases hac with ⟨_, _, hleft, _, _, hright, _⟩
  intro x t
  have hleftsolution : IsConstantCoefficientLinearSystemSolutionAt
      (eigenmodeTravelingWave leftProfile (-c) (linearAcousticsLeftEigenvector density c))
      (linearAcousticsMatrix bulkModulus density) x t := by
    apply eigenmodeTravelingWave_isConstantCoefficientSolutionAt
      (linearAcousticsMatrix bulkModulus density)
      (linearAcousticsLeftEigenvector density c) x t hleft
    simpa only [neg_mul, sub_neg_eq_add] using
      (hleftdiff (x + c * t)).hasDerivAt
  have hrightsolution : IsConstantCoefficientLinearSystemSolutionAt
      (eigenmodeTravelingWave rightProfile c (linearAcousticsRightEigenvector density c))
      (linearAcousticsMatrix bulkModulus density) x t := by
    apply eigenmodeTravelingWave_isConstantCoefficientSolutionAt
      (linearAcousticsMatrix bulkModulus density)
      (linearAcousticsRightEigenvector density c) x t hright
    exact (hrightdiff (x - c * t)).hasDerivAt
  have hsum := constantCoefficientSystem_add_at
    _ _ (linearAcousticsMatrix bulkModulus density) x t hleftsolution hrightsolution
  apply (linearAcoustics_matrixForm_iff pressure velocity bulkModulus density x t).mp
  have heq : linearAcousticsState pressure velocity =
      (fun ξ τ =>
        eigenmodeTravelingWave leftProfile (-c) (linearAcousticsLeftEigenvector density c) ξ τ +
        eigenmodeTravelingWave rightProfile c (linearAcousticsRightEigenvector density c) ξ τ) := by
    funext ξ τ
    simpa [c, eigenmodeTravelingWave, travelingWave] using hform ξ τ
  rw [heq]
  exact hsum


/-- Equation (2.62): every jointly differentiable global classical acoustic
solution decomposes into left and right translated eigenwaves, and every such
differentiable superposition solves the acoustic equations. -/
theorem acousticSuperposition : acousticSuperpositionTarget := by
  intro K ρ hK hρ
  dsimp only
  intro p u hq
  constructor
  · exact acousticSuperposition_fromPDE K ρ hK hρ p u hq
  · rintro ⟨leftProfile, rightProfile, hleftdiff, hrightdiff, hform⟩
    exact acousticSuperposition_fromProfiles K ρ hK hρ p u
      leftProfile rightProfile hleftdiff hrightdiff hform

end NumStability.Leveque02Tracer