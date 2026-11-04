/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellMeanStabilityConvergence
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionCellMeanLpCFL
import ComputationalMathematics.Analysis.PartialDifferentialEquations.HyperbolicitySimilarity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection
import Mathlib.Analysis.Calculus.ContDiff.Operations

/-!
# The advection CFL bound from consistent, stable physical cell-mean errors

The equation is the actual scalar constant-linear advection equation, and its
reference is the translated profile, with actual derivatives and joint smoothness.
The numerical arrays are the executed supplied local update initialized by the
same profile's physical cell means. Consistency, stability and convergence use
the same exponent and physical grid weight. Exact initialization makes the
initial error zero. Only the executed prefix needs error identities.

This is a conditional mathematical specialization. It supplies no unqualified
stability-only CFL theorem or closure of a broader source claim.
-/

noncomputable section

namespace NumStability

open Set Filter MeasureTheory
open scoped Topology ENNReal

/-- The actual transported scalar profile as a smooth reference for the fixed
one-component constant-linear equation on the exactly aligned refining meshes. -/
def scalarAdvectionFixedRatioCellReferenceS06
    (speed origin horizon ratio : ℝ) (hhorizon : 0 < horizon) (hratio : 0 < ratio)
    (profile : ℝ → ℝ)
    (hprofile : ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) profile) :
    SmoothOriginalEquationCellReferenceS06
      (FirstOrderEquation.constantLinear (constantCoefficientScalarMatrix speed))
      origin horizon (fixedRatioRefinementCellWidth horizon ratio)
      (fun n : ℕ => horizon / ((n + 1 : ℕ) : ℝ)) (fun n => n + 1) where
  positive_horizon := hhorizon
  positive_width := by
    intro n
    unfold fixedRatioRefinementCellWidth
    positivity
  positive_dt := by
    intro n
    positivity
  clock := by
    intro n
    have hn : ((n + 1 : ℕ) : ℝ) ≠ 0 := by positivity
    field_simp
  hyperbolic := FirstOrderEquation.constantLinear_isHyperbolic _
    (IsRealHyperbolicMatrix.of_symm (by rfl))
  field := fun x t (_ : Fin 1) => travelingWave profile speed x t
  original_equation := by
    intro x t _ht
    apply (FirstOrderEquation.constantLinear_classical_iff _ _ _ _).2
    obtain ⟨qt, qx, hqt, hqx, hresidual⟩ :=
      travelingWave_isLinearAdvectionSolutionAt speed x t
        ((hprofile.differentiable (by simp)) (x - speed * t)).hasDerivAt
    refine ⟨(fun _ => qt), (fun _ => qx), ?_, ?_, ?_⟩
    · exact hasDerivAt_pi.mpr (fun _ => hqt)
    · exact hasDerivAt_pi.mpr (fun _ => hqx)
    · funext i
      simpa [constantCoefficientScalarMatrix, Matrix.mulVec, dotProduct] using hresidual
  smooth := by
    intro a b
    have h : ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞)
        (fun z : ℝ × ℝ => fun _ : Fin 1 => profile (z.1 - speed * z.2)) :=
      contDiff_pi.mpr (fun _ =>
        hprofile.comp (contDiff_fst.sub (contDiff_const.mul contDiff_snd)))
    exact h.contDiffOn
  integrable := by
    intro a b t _ht
    have h : Continuous (fun x : ℝ => fun _ : Fin 1 => profile (x - speed * t)) :=
      continuous_pi (fun _ => hprofile.continuous.comp (continuous_id.sub continuous_const))
    exact h.intervalIntegrable a b

/-- The supplied update is actually iterated from normalized physical cell means. -/
def advectionCellMeanRefinementEvolution
    (update : ℕ → ℕ → (ℤ → Fin 1 → ℝ) → ℤ → Fin 1 → ℝ)
    (origin horizon ratio : ℝ) (profile : ℝ → ℝ) (n k : ℕ) : ℤ → Fin 1 → ℝ :=
  let width := fixedRatioRefinementCellWidth horizon ratio n
  centeredStencilEvolution (update n)
    (fun j : ℤ => oneDimensionalCellAverage
      (fun x (_ : Fin 1) => profile x)
      (origin + (j : ℝ) * width)
      (origin + ((j : ℝ) + 1) * width)) k

/-- For every exponent at least one, same-reference consistency and trajectory
stability on every fixed smooth compact profile force the radius-local CFL bound.
Neither stability alone nor pointwise convergence from a finite-p norm is used. -/
theorem advectionRefinement_courant_le_of_cellMeanConsistency_stability
    (p : ENNReal) [Fact (1 ≤ p)]
    (speed origin horizon ratio : ℝ) (radius : ℕ)
    (update : ℕ → ℕ → (ℤ → Fin 1 → ℝ) → ℤ → Fin 1 → ℝ)
    (hhorizon : 0 < horizon) (hratio : 0 < ratio)
    (hlocal : ∀ n k (left right : ℤ → Fin 1 → ℝ) (i : ℤ),
      (∀ j ∈ Icc (i - (radius : ℤ)) (i + (radius : ℤ)), left j = right j) →
      update n k left i = update n k right i)
    (hsupport : ∀ (profile : ℝ → ℝ)
      (hprofile : ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) profile),
      HasCompactSupport profile → (∀ x, 0 ≤ profile x ∧ profile x ≤ 1) →
      let reference := scalarAdvectionFixedRatioCellReferenceS06
        speed origin horizon ratio hhorizon hratio profile hprofile
      let approx := advectionCellMeanRefinementEvolution update origin horizon ratio profile
      ∃ error : ℕ → ℕ → lp (fun _ : ℤ => Fin 1 → ℝ) p,
        (∀ n k, k ≤ n + 1 → ∀ j,
          error n k j = approx n k j - physicalCellReferenceMeansS06 reference n k j) ∧
        IsCellMeanReferenceErrorConsistentS06 p reference update ∧
        IsCellMeanErrorTrajectoryStableS06 p reference update approx error) :
    |speed| * ratio ≤ (radius : ℝ) := by
  apply advectionRefinement_courant_le_of_cellMeanLpConvergence
    p speed origin horizon ratio radius update hhorizon hratio hlocal
  intro profile hprofile hcompact hrange
  let reference := scalarAdvectionFixedRatioCellReferenceS06
    speed origin horizon ratio hhorizon hratio profile hprofile
  let approx := advectionCellMeanRefinementEvolution update origin horizon ratio profile
  obtain ⟨error, herror, hconsistent, hstable⟩ := hsupport profile hprofile hcompact hrange
  have hwidth : Tendsto (fixedRatioRefinementCellWidth horizon ratio) atTop (𝓝 0) := by
    have h := (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ)).const_mul (horizon / ratio)
    convert h using 1
    · funext n
      simp only [fixedRatioRefinementCellWidth, Nat.cast_add, Nat.cast_one,
        div_eq_mul_inv, mul_inv_rev]
      ring
    · simp
  have hdt : Tendsto (fun n : ℕ => horizon / ((n + 1 : ℕ) : ℝ)) atTop (𝓝 0) := by
    have h := (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ)).const_mul horizon
    convert h using 1
    · funext n
      simp [Nat.cast_add, Nat.cast_one, div_eq_mul_inv]
    · simp
  have hzero (n : ℕ) : error n 0 = 0 := by
    apply lp.ext
    funext j
    change error n 0 j = (0 : Fin 1 → ℝ)
    rw [herror n 0 (by omega) j]
    simp [advectionCellMeanRefinementEvolution,
      centeredStencilEvolution, physicalCellReferenceMeansS06,
      scalarAdvectionFixedRatioCellReferenceS06, travelingWave]
  have hinitial : Tendsto
      (fun n => physicalLpGridWeight_s03 p (fixedRatioRefinementCellWidth horizon ratio) n *
        ‖error n 0‖) atTop (𝓝 0) := by
    simpa only [hzero, norm_zero, mul_zero] using
      (tendsto_const_nhds : Tendsto (fun _ : ℕ => (0 : ℝ)) atTop (𝓝 0))
  exact cellMean_trajectoryStability_consistency_convergence_s06
    p reference update approx error hwidth hdt herror (by intro n k _hk; rfl)
    hconsistent hstable hinitial

end NumStability
