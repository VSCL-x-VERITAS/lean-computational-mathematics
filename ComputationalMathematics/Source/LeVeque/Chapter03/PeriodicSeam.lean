/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.PeriodicCauchy
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.Noncharacteristic
import ComputationalMathematics.Analysis.Calculus.PeriodicExtension

/-!
# Example 3.4: derivative compatibility across a periodic seam

Printed page 61/raw PDF page 83. For a noncharacteristic system, equality of
endpoint states at positive times forces equality of the derivatives needed
to glue neighboring periodic cells. The resulting continuation is used in
the interval-to-whole-line part of the periodic Cauchy correspondence.
-/

namespace NumStability

theorem leveque03_periodicSeam_derivatives
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hinj : Function.Injective coefficient.mulVec)
    (q : ℝ → ℝ → (Fin m → ℝ)) (a b t : ℝ)
    (ht : 0 < t)
    (hboundary : leveque03_IsPeriodicBoundary q a b)
    (ha : IsConstantCoefficientLinearSystemSolutionAt q coefficient a t)
    (hb : IsConstantCoefficientLinearSystemSolutionAt q coefficient b t) :
    ∃ qt qx : Fin m → ℝ,
      HasDerivAt (fun τ => q a τ) qt t ∧
      HasDerivAt (fun τ => q b τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx a ∧
      HasDerivAt (fun ξ => q ξ t) qx b := by
  obtain ⟨qta, qxa, hta, hxa, hpa⟩ := ha
  obtain ⟨qtb, qxb, htb, hxb, hpb⟩ := hb
  have heventual : (fun τ => q b τ) =ᶠ[nhds t] (fun τ => q a τ) := by
    filter_upwards [eventually_gt_nhds ht] with τ hτ
    exact (hboundary τ hτ.le).symm
  have htbeq : HasDerivAt (fun τ => q b τ) qta t :=
    hta.congr_of_eventuallyEq heventual
  have hqteq : qta = qtb := htbeq.unique htb
  have hmul : coefficient.mulVec qxa = coefficient.mulVec qxb := by
    ext i
    have h₁ := congrFun hpa i
    have h₂ := congrFun hpb i
    simp only [Pi.add_apply, Pi.zero_apply] at h₁ h₂
    rw [← hqteq] at h₂
    linarith
  have hqxeq : qxa = qxb := hinj hmul
  exact ⟨qta, qxa, hta, htbeq, hxa, hqxeq ▸ hxb⟩

theorem leveque03_periodicSeam_derivatives_of_eigenvalues
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (hnonzero : ∀ p, eigenvalues p ≠ 0)
    (q : ℝ → ℝ → (Fin m → ℝ)) (a b t : ℝ)
    (ht : 0 < t)
    (hboundary : leveque03_IsPeriodicBoundary q a b)
    (ha : IsConstantCoefficientLinearSystemSolutionAt q coefficient a t)
    (hb : IsConstantCoefficientLinearSystemSolutionAt q coefficient b t) :
    ∃ qt qx : Fin m → ℝ,
      HasDerivAt (fun τ => q a τ) qt t ∧
      HasDerivAt (fun τ => q b τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx a ∧
      HasDerivAt (fun ξ => q ξ t) qx b :=
  leveque03_periodicSeam_derivatives coefficient
    (matrix_mulVec_injective_of_nonzero_eigenvalues
      coefficient eigenbasis eigenvalues heigen hnonzero)
    q a b t ht hboundary ha hb

/-- For a classical system the positive-time periodic boundary condition also
matches the full space-time derivative across the seam. -/
theorem leveque03_periodicSeam_fderiv
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hinj : Function.Injective coefficient.mulVec)
    (q : ℝ → ℝ → (Fin m → ℝ)) (a b t : ℝ)
    (ht : 0 < t)
    (hboundary : leveque03_IsPeriodicBoundary q a b)
    (hda : DifferentiableAt ℝ (Function.uncurry q) (a, t))
    (hdb : DifferentiableAt ℝ (Function.uncurry q) (b, t))
    (ha : IsConstantCoefficientLinearSystemSolutionAt q coefficient a t)
    (hb : IsConstantCoefficientLinearSystemSolutionAt q coefficient b t) :
    fderiv ℝ (Function.uncurry q) (a, t) =
      fderiv ℝ (Function.uncurry q) (b, t) := by
  obtain ⟨qt, qx, hta, htb, hxa, hxb⟩ :=
    leveque03_periodicSeam_derivatives coefficient hinj q a b t ht
      hboundary ha hb
  exact fderiv_prod_eq_of_partial_derivatives
    (Function.uncurry q) a b t qx qt hda hdb hxa hxb hta htb

/-- Periodizing a jointly classical interval solution preserves joint
differentiability throughout the open forward-time strip, including seams. -/
theorem leveque03_periodicContinuation_jointDifferentiable
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hinj : Function.Injective coefficient.mulVec)
    (q : ℝ → ℝ → (Fin m → ℝ)) (a b : ℝ) (hab : a < b)
    (hboundary : leveque03_IsPeriodicBoundary q a b)
    (hdiff : ∀ y t, a ≤ y → y ≤ b → 0 < t →
      DifferentiableAt ℝ (Function.uncurry q) (y, t))
    (hpde : ∀ y t, a ≤ y → y ≤ b → 0 < t →
      IsConstantCoefficientLinearSystemSolutionAt q coefficient y t) :
    ∀ x t, 0 < t → DifferentiableAt ℝ
      (fun z : ℝ × ℝ =>
        q (toIcoMod (sub_pos.mpr hab) a z.1) z.2) (x, t) := by
  intro x t ht
  have hlength : a + (b - a) = b := by ring
  apply differentiableAt_comp_toIcoMod_prod
    (Function.uncurry q) (b - a) a x t (sub_pos.mpr hab)
  · intro y hya hyb
    exact hdiff y t hya (by simpa only [hlength] using hyb) ht
  · simpa only [hlength] using hboundary t ht.le
  · simpa only [hlength] using
      (leveque03_periodicSeam_fderiv coefficient hinj q a b t ht
        hboundary (hdiff a t (le_refl _) hab.le ht)
        (hdiff b t hab.le (le_refl _) ht)
        (hpde a t (le_refl _) hab.le ht)
        (hpde b t hab.le (le_refl _) ht))

/-- A constant-coefficient PDE is determined by the full derivative at a
point, so a continuation with the same derivative preserves the equation. -/
theorem leveque03_pde_of_matching_fderiv
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (q Q : ℝ → ℝ → (Fin m → ℝ)) (y x t : ℝ)
    (hq : DifferentiableAt ℝ (Function.uncurry q) (y, t))
    (hQ : DifferentiableAt ℝ (Function.uncurry Q) (x, t))
    (hmatch : fderiv ℝ (Function.uncurry Q) (x, t) =
      fderiv ℝ (Function.uncurry q) (y, t))
    (hpde : IsConstantCoefficientLinearSystemSolutionAt q coefficient y t) :
    IsConstantCoefficientLinearSystemSolutionAt Q coefficient x t := by
  obtain ⟨qt, qx, ht, hx, heq⟩ := hpde
  have hqt : (fderiv ℝ (Function.uncurry q) (y, t)) (0, 1) = qt :=
    (hasDerivAt_snd_slice_of_differentiableAt _ y t hq).unique ht
  have hqx : (fderiv ℝ (Function.uncurry q) (y, t)) (1, 0) = qx :=
    (hasDerivAt_fst_slice_of_differentiableAt _ y t hq).unique hx
  refine ⟨qt, qx, ?_, ?_, heq⟩
  · simpa only [hmatch, hqt] using
      hasDerivAt_snd_slice_of_differentiableAt
        (Function.uncurry Q) x t hQ
  · simpa only [hmatch, hqx] using
      hasDerivAt_fst_slice_of_differentiableAt
        (Function.uncurry Q) x t hQ

/-- The repeated interval state solves the same linear system at every
positive time on the whole line. -/
theorem leveque03_periodicContinuation_pde
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hinj : Function.Injective coefficient.mulVec)
    (q : ℝ → ℝ → (Fin m → ℝ)) (a b : ℝ) (hab : a < b)
    (hboundary : leveque03_IsPeriodicBoundary q a b)
    (hdiff : ∀ y t, a ≤ y → y ≤ b → 0 < t →
      DifferentiableAt ℝ (Function.uncurry q) (y, t))
    (hpde : ∀ y t, a ≤ y → y ≤ b → 0 < t →
      IsConstantCoefficientLinearSystemSolutionAt q coefficient y t) :
    ∀ x t, 0 < t →
      IsConstantCoefficientLinearSystemSolutionAt
        (fun ξ τ => q (toIcoMod (sub_pos.mpr hab) a ξ) τ)
        coefficient x t := by
  intro x t ht
  let p := b - a
  let y := toIcoMod (sub_pos.mpr hab) a x
  have hcell : a ≤ y ∧ y ≤ b := by
    have h := toIcoMod_mem_Ico (sub_pos.mpr hab) a x
    exact ⟨h.1, by dsimp [y] at h ⊢; linarith [h.2]⟩
  have hlength : a + p = b := by dsimp [p]; ring
  have hmatch : fderiv ℝ (Function.uncurry q) (a, t) =
      fderiv ℝ (Function.uncurry q) (a + p, t) := by
    rw [hlength]
    exact leveque03_periodicSeam_fderiv coefficient hinj q a b t ht
      hboundary (hdiff a t (le_refl _) hab.le ht)
      (hdiff b t hab.le (le_refl _) ht)
      (hpde a t (le_refl _) hab.le ht)
      (hpde b t hab.le (le_refl _) ht)
  have hvalue : q a t = q (a + p) t := by
    rw [hlength]
    exact hboundary t ht.le
  have hdiffcell : ∀ r, a ≤ r → r ≤ a + p →
      DifferentiableAt ℝ (Function.uncurry q) (r, t) := by
    intro r har hrb
    exact hdiff r t har (hlength ▸ hrb) ht
  have hderiv := fderiv_comp_toIcoMod_prod
    (Function.uncurry q) p a x t (sub_pos.mpr hab)
    hdiffcell hvalue hmatch
  exact leveque03_pde_of_matching_fderiv coefficient q
    (fun ξ τ => q (toIcoMod (sub_pos.mpr hab) a ξ) τ)
    y x t (hdiff y t hcell.1 hcell.2 ht)
    (leveque03_periodicContinuation_jointDifferentiable
      coefficient hinj q a b hab hboundary hdiff hpde x t ht)
    hderiv (hpde y t hcell.1 hcell.2 ht)

/-- Compatible endpoint values and continuity of the interval state give a
continuous periodic continuation up to the initial-time boundary. -/
theorem leveque03_periodicContinuation_continuousOn
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (a b : ℝ) (hab : a < b)
    (hboundary : leveque03_IsPeriodicBoundary q a b)
    (hcont : ∀ y t, a ≤ y → y ≤ b → 0 ≤ t →
      ContinuousAt (Function.uncurry q) (y, t)) :
    ContinuousOn
      (Function.uncurry
        (fun ξ τ => q (toIcoMod (sub_pos.mpr hab) a ξ) τ))
      (Set.prod Set.univ (Set.Ici 0)) := by
  intro z hz
  have ht : 0 ≤ z.2 := hz.2
  have hlength : a + (b - a) = b := by ring
  have hcontinuity := continuousAt_comp_toIcoMod_prod
    (Function.uncurry q) (b - a) a z.1 z.2 (sub_pos.mpr hab)
    (by simpa only [hlength] using hboundary z.2 ht)
    (by
      intro y hya hyb
      exact hcont y z.2 hya (by simpa only [hlength] using hyb) ht)
  exact hcontinuity.continuousWithinAt

/-- The periodic continuation of each positive-time spatial slice is
differentiable, including every seam, when the interval solution is classical
and noncharacteristic. -/
theorem leveque03_periodicContinuation_spatialDifferentiable
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (eigenvalues : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p)
    (hnonzero : ∀ p, eigenvalues p ≠ 0)
    (q : ℝ → ℝ → (Fin m → ℝ)) (a b t : ℝ)
    (hab : a < b) (ht : 0 < t)
    (hboundary : leveque03_IsPeriodicBoundary q a b)
    (hclassical : ∀ y, a ≤ y → y ≤ b →
      DifferentiableAt ℝ (fun ξ => q ξ t) y)
    (ha : IsConstantCoefficientLinearSystemSolutionAt q coefficient a t)
    (hb : IsConstantCoefficientLinearSystemSolutionAt q coefficient b t) :
    Differentiable ℝ (fun x => q (toIcoMod (sub_pos.mpr hab) a x) t) := by
  obtain ⟨_, qx, _, _, hxa, hxb⟩ :=
    leveque03_periodicSeam_derivatives_of_eigenvalues coefficient
      eigenbasis eigenvalues heigen hnonzero q a b t ht hboundary ha hb
  have hlength : a + (b - a) = b := by ring
  apply differentiable_comp_toIcoMod_pi
    (fun y => q y t) (b - a) a (sub_pos.mpr hab)
  · simpa only [hlength] using hboundary t ht.le
  · intro y hya hyb
    exact hclassical y hya (by simpa only [hlength] using hyb)
  · simpa only [hlength] using (show ∃ d : Fin m → ℝ,
      HasDerivAt (fun y => q y t) d a ∧
      HasDerivAt (fun y => q y t) d b from ⟨qx, hxa, hxb⟩)

end NumStability
