import Mathlib.Analysis.ODE.Gronwall
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Mathlib.Analysis.Normed.Group.Bounded
import Mathlib.Tactic

/-!
Scratch prerequisite for the Chapter 1 possibility of nonlinear shock formation.
This file proves a characteristic obstruction for smooth bounded initial data.
It does not yet construct a discontinuous weak solution, and does not close the source row.
-/

open Set

namespace NumStability.ShockFoundation

noncomputable section

/-- The nonlinear state-only flux for inviscid Burgers. -/
def burgersFlux (q : ℝ) : ℝ := q ^ 2 / 2

theorem hasDerivAt_burgersFlux (q : ℝ) : HasDerivAt burgersFlux q q := by
  convert ((hasDerivAt_id q).pow 2).div_const 2 using 1
  simp

theorem burgersFlux_not_linear : ¬ ∃ c : ℝ, ∀ q, burgersFlux q = c * q := by
  rintro ⟨c, hc⟩
  have h₁ := hc 1
  have h₂ := hc 2
  norm_num [burgersFlux] at h₁ h₂
  rw [← h₁] at h₂
  norm_num at h₂
  exact (by norm_num : (2 : ℝ) ≠ 1) h₂

/-- A classical Burgers solution with an actual, continuous Fréchet derivative.
The derivative is required on the ambient spacetime; the PDE is imposed only on the strip.
No characteristic identity is assumed. -/
def IsClassicalBurgersOn (u : ℝ × ℝ → ℝ)
    (Du : ℝ × ℝ → (ℝ × ℝ) →L[ℝ] ℝ) (T : ℝ) : Prop :=
  Continuous Du ∧ (∀ p, HasFDerivAt u (Du p) p) ∧
  ∀ x t, t ∈ Icc 0 T → Du (x, t) (0, 1) + u (x, t) * Du (x, t) (1, 0) = 0

/-- Under the stated genuine differentiability hypotheses the Burgers equation is exactly
the differential conservation law for `q ↦ q²/2`, with derivatives of the actual field. -/
theorem isClassicalBurgersOn_iff_conservationLaw {u : ℝ × ℝ → ℝ}
    {Du : ℝ × ℝ → (ℝ × ℝ) →L[ℝ] ℝ} {T : ℝ}
    (hDu : Continuous Du) (hd : ∀ p, HasFDerivAt u (Du p) p) :
    IsClassicalBurgersOn u Du T ↔
      ∀ x t, t ∈ Icc 0 T →
        deriv (fun s => u (x, s)) t + deriv (fun y => burgersFlux (u (y, t))) x = 0 := by
  have ht (x t : ℝ) : HasDerivAt (fun s => u (x, s)) (Du (x, t) (0, 1)) t := by
    simpa only [Function.comp_def] using
      (hd (x, t)).comp_hasDerivAt t ((hasDerivAt_const t x).prodMk (hasDerivAt_id t))
  have hx (x t : ℝ) : HasDerivAt (fun y => burgersFlux (u (y, t)))
      (u (x, t) * Du (x, t) (1, 0)) x := by
    have hu : HasDerivAt (fun y => u (y, t)) (Du (x, t) (1, 0)) x := by
      simpa only [Function.comp_def] using
        (hd (x, t)).comp_hasDerivAt x ((hasDerivAt_id x).prodMk (hasDerivAt_const x t))
    exact (hasDerivAt_burgersFlux (u (x, t))).comp x hu
  simp only [(ht _ _).deriv, (hx _ _).deriv, IsClassicalBurgersOn, hDu, hd, true_and,
    implies_true]

/-- A straight characteristic of speed equal to its initial value transports that value.
The proof derives the transport identity from the PDE by the chain rule and Grönwall. -/
theorem characteristic_value {u : ℝ × ℝ → ℝ}
    {Du : ℝ × ℝ → (ℝ × ℝ) →L[ℝ] ℝ} {T ξ v : ℝ}
    (h : IsClassicalBurgersOn u Du T) (hinit : u (ξ, 0) = v)
    {t : ℝ} (ht : t ∈ Icc 0 T) : u (ξ + v * t, t) = v := by
  let path : ℝ → ℝ × ℝ := fun s => (ξ + v * s, s)
  let error : ℝ → ℝ := fun s => u (path s) - v
  let coeff : ℝ → ℝ := fun s => Du (path s) (1, 0)
  have hpath : Continuous path := (continuous_const.add (continuous_const.mul continuous_id)).prodMk continuous_id
  have hu : Continuous u := continuous_iff_continuousAt.mpr fun p => (h.2.1 p).continuousAt
  have he : Continuous error := (hu.comp hpath).sub continuous_const
  have hc : Continuous coeff := (h.1.comp hpath).clm_apply continuous_const
  obtain ⟨K, hK⟩ := isCompact_Icc.exists_bound_of_continuousOn hc.continuousOn
  have hderiv (s : ℝ) (hs : s ∈ Ico 0 T) :
      HasDerivWithinAt error (-coeff s * error s) (Ici s) s := by
    have hp : HasDerivAt path (v, 1) s := by
      convert ((hasDerivAt_id s).const_mul v |>.const_add ξ).prodMk (hasDerivAt_id s) using 1
      simp
    have hd := ((h.2.1 (path s)).comp_hasDerivAt s hp).sub_const v
    have hlin : Du (path s) (v, 1) = v * coeff s + Du (path s) (0, 1) := by
      have hpv : (v, (1 : ℝ)) = v • ((1, 0) : ℝ × ℝ) + (0, 1) := by ext <;> simp
      rw [hpv, map_add, map_smul]
      rfl
    have hpde := h.2.2 (ξ + v * s) s ⟨hs.1, hs.2.le⟩
    have hid : Du (path s) (v, 1) = -coeff s * error s := by
      rw [hlin]
      dsimp [coeff, error, path] at *
      nlinarith [hpde]
    simpa only [Function.comp_def, hid] using hd.hasDerivWithinAt
  have hz : error 0 = 0 := by simp [error, path, hinit]
  have hbound (s : ℝ) (hs : s ∈ Ico 0 T) :
      ‖-coeff s * error s‖ ≤ K * ‖error s‖ := by
    rw [norm_mul, norm_neg]
    exact mul_le_mul_of_nonneg_right (hK s ⟨hs.1, hs.2.le⟩) (norm_nonneg _)
  have hzero := eq_zero_of_abs_deriv_le_mul_abs_self_of_eq_zero_right
    he.continuousOn hderiv hz hbound t ht
  exact sub_eq_zero.mp hzero

/-- Any two distinct transported values cannot have crossing characteristics in a classical strip. -/
theorem characteristic_collision_impossible {u : ℝ × ℝ → ℝ}
    {Du : ℝ × ℝ → (ℝ × ℝ) →L[ℝ] ℝ} {T ξ₁ ξ₂ v₁ v₂ t : ℝ}
    (h : IsClassicalBurgersOn u Du T)
    (h₁ : u (ξ₁, 0) = v₁) (h₂ : u (ξ₂, 0) = v₂)
    (ht : t ∈ Icc 0 T) (hcross : ξ₁ + v₁ * t = ξ₂ + v₂ * t) : v₁ = v₂ := by
  have hv₁ := characteristic_value h h₁ ht
  have hv₂ := characteristic_value h h₂ ht
  rw [hcross] at hv₁
  exact hv₁.symm.trans hv₂

/-- The smooth initial profile used for the concrete obstruction is bounded by one. -/
theorem neg_sin_smooth_bounded :
    ContDiff ℝ ⊤ (fun x : ℝ => -Real.sin x) ∧ ∀ x : ℝ, |(-Real.sin x)| ≤ 1 := by
  exact ⟨Real.contDiff_sin.neg, fun x => by simpa using Real.abs_sin_le_one x⟩

/-- Smooth bounded data `-sin x` admit no classical Burgers solution extending to `π/2`.
This is a breakdown result, not a claim of existence of a post-breakdown weak shock. -/
theorem neg_sin_no_classical_solution_to_pi_div_two :
    ¬ ∃ (u : ℝ × ℝ → ℝ) (Du : ℝ × ℝ → (ℝ × ℝ) →L[ℝ] ℝ),
      IsClassicalBurgersOn u Du (Real.pi / 2) ∧
      ∀ x, u (x, 0) = -Real.sin x := by
  rintro ⟨u, Du, h, hinit⟩
  have hleft : u (-Real.pi / 2, 0) = 1 := by
    rw [hinit]
    simp [neg_div, Real.sin_neg, Real.sin_pi_div_two]
  have hright : u (Real.pi / 2, 0) = -1 := by simp [hinit, Real.sin_pi_div_two]
  have htime : Real.pi / 2 ∈ Icc (0 : ℝ) (Real.pi / 2) := ⟨by positivity, le_rfl⟩
  have hcross : -Real.pi / 2 + 1 * (Real.pi / 2) = Real.pi / 2 + (-1) * (Real.pi / 2) := by ring
  have hbad := characteristic_collision_impossible h hleft hright htime hcross
  norm_num at hbad

#print axioms characteristic_value
#print axioms characteristic_collision_impossible
#print axioms neg_sin_smooth_bounded
#print axioms neg_sin_no_classical_solution_to_pi_div_two
#print axioms hasDerivAt_burgersFlux
#print axioms burgersFlux_not_linear
#print axioms isClassicalBurgersOn_iff_conservationLaw

end

end NumStability.ShockFoundation
