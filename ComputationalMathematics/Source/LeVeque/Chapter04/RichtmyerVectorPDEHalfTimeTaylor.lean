/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorMidpointPredictorError
import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor

/-!
# Half-time vector face state from the conservation PDE

The scalar Lipschitz-derivative Taylor theorem lifts coordinatewise to
finite vector states. The conservation PDE replaces the initial time
derivative with the negative spatial physical-flux slope.
-/

namespace NumStability

theorem leveque04_richtmyer_vectorPDEFace_halfTimeTaylor
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (timeSlope : ℝ → Fin m → ℝ)
    (face timeStep K : ℝ) (fluxSlope : Fin m → ℝ)
    (hK : 0 ≤ K)
    (htraceDeriv : ∀ τ, HasDerivAt (fun σ => q face σ)
      (timeSlope τ) τ)
    (htraceLip : ∀ τ σ,
      ‖timeSlope τ - timeSlope σ‖ ≤ K * |τ - σ|)
    (hpde : timeSlope 0 + fluxSlope = 0) :
    ‖q face (timeStep / 2) -
      (q face 0 - (timeStep / 2) • fluxSlope)‖ ≤
        (K / 4) * timeStep ^ 2 := by
  have hnonneg : 0 ≤ (K / 4) * timeStep ^ 2 := by positivity
  apply (pi_norm_le_iff_of_nonneg hnonneg).2
  intro p
  have hderiv (τ : ℝ) :
      HasDerivAt (fun σ => q face σ p) (timeSlope τ p) τ :=
    (hasDerivAt_pi.mp (htraceDeriv τ)) p
  have hLip (τ σ : ℝ) :
      |timeSlope τ p - timeSlope σ p| ≤ K * |τ - σ| := by
    have hcoord := norm_le_pi_norm (timeSlope τ - timeSlope σ) p
    have hcoord' : |timeSlope τ p - timeSlope σ p| ≤
        ‖timeSlope τ - timeSlope σ‖ := by
      simpa only [Pi.sub_apply, Real.norm_eq_abs] using hcoord
    exact hcoord'.trans (htraceLip τ σ)
  have hpdeCoord : timeSlope 0 p + fluxSlope p = 0 := by
    have h := congrArg (fun v : Fin m → ℝ => v p) hpde
    simpa only [Pi.add_apply, Pi.zero_apply] using h
  have hscalar := firstOrderTaylorError_le_of_lipschitzDeriv
    (fun τ => q face τ p) (fun τ => timeSlope τ p)
    K 0 (timeStep / 2) hK hderiv hLip
  have hslope : timeSlope 0 p = -fluxSlope p := by linarith
  change |q face (timeStep / 2) p -
    (q face 0 p + timeSlope 0 p * (timeStep / 2 - 0))| ≤
      K * (timeStep / 2 - 0) ^ 2 at hscalar
  rw [hslope] at hscalar
  simp only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul,
    Real.norm_eq_abs]
  convert hscalar using 1 <;> ring_nf

end NumStability
