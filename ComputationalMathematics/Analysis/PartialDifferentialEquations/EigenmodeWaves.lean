/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection

/-!
# Traveling eigenmodes of constant-coefficient systems

An eigenvector-valued translated scalar profile solves the associated
constant-coefficient system, and its eigenvalue is its translation speed.
-/

namespace NumStability

/-- A scalar translated profile carried by a fixed vector. -/
def eigenmodeTravelingWave {ι : Type*}
    (profile : ℝ → ℝ) (speed : ℝ) (eigenvector : ι → ℝ) :
    ℝ → ℝ → (ι → ℝ) :=
  fun x t => travelingWave profile speed x t • eigenvector

/-- A uniformly transported state whose initial data lie in the span of one
fixed eigenvector. -/
def IsPureEigenmodeWave {ι : Type*}
    (q : ℝ → ℝ → (ι → ℝ)) (speed : ℝ) (eigenvector : ι → ℝ) : Prop :=
  IsUniformAdvection q speed ∧
    ∃ profile : ℝ → ℝ, ∀ x, q x 0 = profile x • eigenvector

/-- Pure eigenmode waves are exactly scalar profiles translated at the
eigenvalue speed and carried by the fixed eigenvector. -/
theorem isPureEigenmodeWave_iff_exists_eq_eigenmodeTravelingWave
    {ι : Type*} (q : ℝ → ℝ → (ι → ℝ)) (speed : ℝ)
    (eigenvector : ι → ℝ) :
    IsPureEigenmodeWave q speed eigenvector ↔
      ∃ profile : ℝ → ℝ,
        q = eigenmodeTravelingWave profile speed eigenvector := by
  constructor
  · rintro ⟨htransport, profile, hinitial⟩
    refine ⟨profile, ?_⟩
    funext x t
    calc
      q x t = q (x - speed * t) 0 := by
        simpa only [sub_add_cancel] using htransport (x - speed * t) t
      _ = profile (x - speed * t) • eigenvector := hinitial _
      _ = eigenmodeTravelingWave profile speed eigenvector x t := rfl
  · rintro ⟨profile, rfl⟩
    constructor
    · intro x t
      simp [eigenmodeTravelingWave, travelingWave]
    · exact ⟨profile, by intro x; simp [eigenmodeTravelingWave, travelingWave]⟩

/-- The derivative of a differentiable scalar eigenmode profile remains in
the span of its fixed eigenvector. -/
theorem hasDerivAt_eigenmodeProfile {ι : Type*} [Fintype ι]
    {profile : ℝ → ℝ} {profile' x : ℝ} (eigenvector : ι → ℝ)
    (hprofile : HasDerivAt profile profile' x) :
    HasDerivAt (fun ξ => profile ξ • eigenvector)
      (profile' • eigenvector) x :=
  hprofile.smul_const eigenvector

/-- If `r` is a right eigenvector of `A` with eigenvalue `λ`, every
differentiable scalar profile translated at speed `λ` and carried by `r`
solves `q_t + A q_x = 0` at the corresponding point. -/
theorem eigenmodeTravelingWave_isConstantCoefficientSolutionAt
    {ι : Type*} [Fintype ι]
    (coefficient : Matrix ι ι ℝ)
    {profile : ℝ → ℝ} {profile' speed : ℝ}
    (eigenvector : ι → ℝ) (x t : ℝ)
    (heigen : coefficient.mulVec eigenvector = speed • eigenvector)
    (hprofile : HasDerivAt profile profile' (x - speed * t)) :
    IsConstantCoefficientLinearSystemSolutionAt
      (eigenmodeTravelingWave profile speed eigenvector)
      coefficient x t := by
  rcases travelingWave_isLinearAdvectionSolutionAt speed x t hprofile with
    ⟨qt, qx, ht, hx, hresidual⟩
  refine ⟨qt • eigenvector, qx • eigenvector, ?_, ?_, ?_⟩
  · simpa [eigenmodeTravelingWave] using ht.smul_const eigenvector
  · simpa [eigenmodeTravelingWave] using hx.smul_const eigenvector
  · have hscaled := congrArg (fun a : ℝ => a • eigenvector) hresidual
    rw [Matrix.mulVec_smul, heigen]
    simpa [add_smul, smul_smul, mul_comm] using hscaled

end NumStability
