/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorTaylorResidual
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivativeContinuous
import Mathlib.Tactic.Module

/-!
# Vector flux secant near a cell-average state

Two quadratic flux-linearization remainders at the cell faces give a
first-order defect in the normalized physical-flux secant. The flux may
couple all state components.
-/

namespace NumStability

/-- A Lipschitz Jacobian gives a quadratic flux Taylor remainder along
any finite-vector state increment. -/
theorem leveque04_laxFriedrichs_vectorFluxTaylorError
    {m : ℕ} (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) →
      (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (base increment : Fin m → ℝ) (K : ℝ) (hK : 0 ≤ K)
    (hflux : ∀ u, HasFDerivAt flux (jacobian u) u)
    (hLip : ∀ u v, ‖jacobian u - jacobian v‖ ≤ K * ‖u - v‖) :
    ‖flux (base + increment) -
        (flux base + jacobian base increment)‖ ≤
      K * ‖increment‖ ^ 2 := by
  let path : ℝ → Fin m → ℝ := fun t => base + t • increment
  let pathFlux : ℝ → Fin m → ℝ := fun t => flux (path t)
  let pathDeriv : ℝ → Fin m → ℝ :=
    fun t => jacobian (path t) increment
  have hpath (t : ℝ) : HasDerivAt path increment t := by
    simpa only [path, one_smul] using
      ((hasDerivAt_id (x := t)).smul_const increment).const_add base
  have hpathFlux (t : ℝ) :
      HasDerivAt pathFlux (pathDeriv t) t := by
    simpa only [pathFlux, pathDeriv] using
      (hflux (path t)).comp_hasDerivAt t (hpath t)
  have hpathDist (t s : ℝ) :
      ‖path t - path s‖ = |t - s| * ‖increment‖ := by
    have hid : path t - path s = (t - s) • increment := by
      dsimp [path]
      module
    rw [hid, norm_smul, Real.norm_eq_abs]
  have hpathLip (t s : ℝ) :
      ‖pathDeriv t - pathDeriv s‖ ≤
        (K * ‖increment‖ ^ 2) * |t - s| := by
    have heq : pathDeriv t - pathDeriv s =
        (jacobian (path t) - jacobian (path s)) increment := by
      simp only [pathDeriv, ContinuousLinearMap.sub_apply]
    rw [heq]
    calc
      _ ≤ ‖jacobian (path t) - jacobian (path s)‖ *
        ‖increment‖ :=
          (jacobian (path t) - jacobian (path s)).le_opNorm increment
      _ ≤ (K * ‖path t - path s‖) * ‖increment‖ :=
        mul_le_mul_of_nonneg_right (hLip (path t) (path s))
          (norm_nonneg _)
      _ = (K * ‖increment‖ ^ 2) * |t - s| := by
        rw [hpathDist]
        ring
  have hbound := vectorFirstOrderTaylorError_le_of_lipschitzDeriv
    pathFlux pathDeriv (K * ‖increment‖ ^ 2) 0 1
    (mul_nonneg hK (sq_nonneg _)) hpathFlux hpathLip
  simpa only [pathFlux, pathDeriv, path, zero_smul, add_zero, one_smul,
    sub_zero, one_pow, mul_one] using hbound

/-- Vector flux secant control from left and right Taylor remainders
about the same center cell-average state. -/
theorem leveque04_laxFriedrichs_vectorFluxSecant_error_of_remainders
    {m : ℕ} (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (base left right : Fin m → ℝ)
    (width F : ℝ) (hwidth : 0 < width)
    (hleft : ‖flux left -
        (flux base + jacobian (left - base))‖ ≤ F * width ^ 2)
    (hright : ‖flux right -
        (flux base + jacobian (right - base))‖ ≤ F * width ^ 2) :
    ‖width⁻¹ •
        ((flux right - flux left) - jacobian (right - left))‖ ≤
      2 * F * width := by
  have hlinear :
      (flux right - flux left) - jacobian (right - left) =
        (flux right - (flux base + jacobian (right - base))) -
          (flux left - (flux base + jacobian (left - base))) := by
    rw [show right - left = (right - base) - (left - base) by module,
      map_sub]
    module
  rw [hlinear, norm_smul, Real.norm_eq_abs,
    abs_inv, abs_of_pos hwidth]
  have hsum :
      ‖(flux right - (flux base + jacobian (right - base))) -
          (flux left - (flux base + jacobian (left - base)))‖ ≤
        2 * F * width ^ 2 := by
    calc
      _ ≤ ‖flux right - (flux base + jacobian (right - base))‖ +
          ‖flux left - (flux base + jacobian (left - base))‖ :=
            norm_sub_le _ _
      _ ≤ F * width ^ 2 + F * width ^ 2 :=
        add_le_add hright hleft
      _ = 2 * F * width ^ 2 := by ring
  have hnonneg : 0 ≤ width⁻¹ := (inv_pos.mpr hwidth).le
  calc
    width⁻¹ *
        ‖(flux right - (flux base + jacobian (right - base))) -
          (flux left - (flux base + jacobian (left - base)))‖ ≤
      width⁻¹ * (2 * F * width ^ 2) :=
        mul_le_mul_of_nonneg_left hsum hnonneg
    _ = 2 * F * width := by
      field_simp [ne_of_gt hwidth]

/-- Rectangle conservation identifies the exact vector cell-average time
slope, and face-flux Taylor remainders control its mismatch with the
Jacobian applied to the face-state secant. -/
theorem leveque04_laxFriedrichs_vectorCellAverage_pdeSlope_of_remainders
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (base : Fin m → ℝ) (a b t F : ℝ)
    (hwidth : 0 < b - a)
    (hq : IsRectangleConservationLawSolution q flux)
    (hcont : Continuous
      (fun τ => flux (q a τ) - flux (q b τ)))
    (hbase : base = oneDimensionalCellAverage (fun x => q x t) a b)
    (hleft : ‖flux (q a t) -
        (flux base + jacobian (q a t - base))‖ ≤
      F * (b - a) ^ 2)
    (hright : ‖flux (q b t) -
        (flux base + jacobian (q b t - base))‖ ≤
      F * (b - a) ^ 2) :
    HasDerivAt
      (fun τ => oneDimensionalCellAverage (fun x => q x τ) a b)
      ((b - a)⁻¹ • (flux (q a t) - flux (q b t))) t ∧
    ‖(b - a)⁻¹ • (flux (q a t) - flux (q b t)) +
        jacobian ((b - a)⁻¹ • (q b t - q a t))‖ ≤
      2 * F * (b - a) := by
  rcases hbase with rfl
  constructor
  · exact hq.hasDerivAt_cellAverage_of_continuous_flux a b t hcont
  · have hsecant :=
      leveque04_laxFriedrichs_vectorFluxSecant_error_of_remainders
        flux jacobian
        (oneDimensionalCellAverage (fun x => q x t) a b)
        (q a t) (q b t) (b - a) F hwidth hleft hright
    have hid :
        (b - a)⁻¹ • (flux (q a t) - flux (q b t)) +
            jacobian ((b - a)⁻¹ • (q b t - q a t)) =
          -((b - a)⁻¹ •
            ((flux (q b t) - flux (q a t)) -
              jacobian (q b t - q a t))) := by
      rw [map_smul]
      module
    rw [hid, norm_neg]
    exact hsecant

/-- A Lipschitz flux Jacobian and face states within O(width) of the
exact cell average discharge the vector PDE-slope budget. -/
theorem leveque04_laxFriedrichs_vectorCellAverage_pdeSlope_of_lipschitzJacobian
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) →
      (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (base : Fin m → ℝ) (a b t K S : ℝ)
    (hwidth : 0 < b - a) (hK : 0 ≤ K) (hS : 0 ≤ S)
    (hq : IsRectangleConservationLawSolution q flux)
    (hcont : Continuous
      (fun τ => flux (q a τ) - flux (q b τ)))
    (hbase : base = oneDimensionalCellAverage (fun x => q x t) a b)
    (hflux : ∀ u, HasFDerivAt flux (jacobian u) u)
    (hjacobianLip : ∀ u v,
      ‖jacobian u - jacobian v‖ ≤ K * ‖u - v‖)
    (hleftClose : ‖q a t - base‖ ≤ S * (b - a))
    (hrightClose : ‖q b t - base‖ ≤ S * (b - a)) :
    HasDerivAt
      (fun τ => oneDimensionalCellAverage (fun x => q x τ) a b)
      ((b - a)⁻¹ • (flux (q a t) - flux (q b t))) t ∧
    ‖(b - a)⁻¹ • (flux (q a t) - flux (q b t)) +
        jacobian base ((b - a)⁻¹ • (q b t - q a t))‖ ≤
      2 * (K * S ^ 2) * (b - a) := by
  have hfaceSquare (face : Fin m → ℝ)
      (hclose : ‖face - base‖ ≤ S * (b - a)) :
      ‖face - base‖ ^ 2 ≤ S ^ 2 * (b - a) ^ 2 := by
    have hnonneg : 0 ≤ S * (b - a) := mul_nonneg hS hwidth.le
    nlinarith [norm_nonneg (face - base), sq_nonneg (S * (b - a))]
  have hfaceTaylor (face : Fin m → ℝ)
      (hclose : ‖face - base‖ ≤ S * (b - a)) :
      ‖flux face - (flux base + jacobian base (face - base))‖ ≤
        (K * S ^ 2) * (b - a) ^ 2 := by
    have h := leveque04_laxFriedrichs_vectorFluxTaylorError
      flux jacobian base (face - base) K hK hflux hjacobianLip
    have h' :
        ‖flux face - (flux base + jacobian base (face - base))‖ ≤
          K * ‖face - base‖ ^ 2 := by
      have hstate : base + (face - base) = face := by module
      rw [hstate] at h
      exact h
    calc
      _ ≤ K * ‖face - base‖ ^ 2 := h'
      _ ≤ K * (S ^ 2 * (b - a) ^ 2) :=
        mul_le_mul_of_nonneg_left (hfaceSquare face hclose) hK
      _ = (K * S ^ 2) * (b - a) ^ 2 := by ring
  exact leveque04_laxFriedrichs_vectorCellAverage_pdeSlope_of_remainders
    q flux (jacobian base) base a b t (K * S ^ 2) hwidth
    hq hcont hbase (hfaceTaylor (q a t) hleftClose)
    (hfaceTaylor (q b t) hrightClose)

end NumStability
