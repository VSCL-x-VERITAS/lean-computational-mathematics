/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsDiagonalSmoothGlobal

/-!
# Nonlinear fluxes coupled by a fixed eigenbasis

A diagonal nonlinear flux in characteristic variables becomes a
generally coupled physical flux after a fixed linear change of basis.
The periodic source equation-(4.20) update commutes with that change.
-/

namespace NumStability

/-- A componentwise nonlinear flux conjugated into physical state
coordinates by a fixed real basis. -/
noncomputable def leveque04_conjugateNonlinearFlux
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (flux : Fin m → ℝ → ℝ) (state : Fin m → ℝ) : Fin m → ℝ :=
  basis.equivFun.symm (fun p => flux p (basis.equivFun state p))

/-- The periodic equation-(4.20) vector update for an arbitrary
physical flux. -/
noncomputable def leveque04_periodicVectorLaxFriedrichsStep
    {m : ℕ} (n : ℕ) [NeZero n]
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (ratio : ℝ) (u : ZMod n → Fin m → ℝ) :
    ZMod n → Fin m → ℝ :=
  fun i => (1 / 2 : ℝ) • (u (i - 1) + u (i + 1)) -
    (ratio / 2) • (physicalFlux (u (i + 1)) -
      physicalFlux (u (i - 1)))

/-- The vector periodic stencil is the conservative source
equation-(4.20) update on the three actual neighboring states. -/
theorem leveque04_periodicVectorLaxFriedrichs_eq_equation20
    {m : ℕ} (n : ℕ) [NeZero n]
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (ratio width : ℝ) (hratio : 0 < ratio) (hwidth : 0 < width)
    (u : ZMod n → Fin m → ℝ) (i : ZMod n) (p : Fin m) :
    let old : ℤ → Fin m → ℝ := fun j =>
      if j = -1 then u (i - 1) else if j = 0 then u i else u (i + 1)
    leveque04_periodicVectorLaxFriedrichsStep
        n physicalFlux ratio u i p =
      leveque04_finiteVolumeUpdate (ratio * width) width old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux
            (ratio * width) width physicalFlux) old) 0 p := by
  dsimp only
  rw [leveque04_equation20 (ratio * width) width physicalFlux
    (fun j => if j = -1 then u (i - 1) else if j = 0 then u i else u (i + 1))
    0 p (mul_pos hratio hwidth) hwidth]
  simp only [zero_sub, zero_add, ite_true]
  have hnot : (1 : ℤ) ≠ -1 := by norm_num
  have hnot0 : (1 : ℤ) ≠ 0 := by norm_num
  simp only [hnot, hnot0, ↓reduceIte]
  have hcoef : ratio * width / (2 * width) = ratio / 2 := by
    field_simp
  rw [hcoef]
  simp only [leveque04_periodicVectorLaxFriedrichsStep,
    Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  ring

/-- The physical vector update for a conjugated nonlinear flux is
exactly the diagonal nonlinear update in basis coordinates. -/
theorem leveque04_periodicConjugateNonlinearLaxFriedrichs_characteristicStep
    {m : ℕ} (n : ℕ) [NeZero n]
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (flux : Fin m → ℝ → ℝ) (ratio : ℝ)
    (u : ZMod n → Fin m → ℝ) (i : ZMod n) (p : Fin m) :
    basis.equivFun
        (leveque04_periodicVectorLaxFriedrichsStep n
          (leveque04_conjugateNonlinearFlux basis flux) ratio u i) p =
      leveque04_periodicDiagonalNonlinearLaxFriedrichsStep n flux ratio
        (fun j => basis.equivFun (u j)) i p := by
  simp only [leveque04_periodicVectorLaxFriedrichsStep,
    leveque04_periodicDiagonalNonlinearLaxFriedrichsStep,
    leveque04_conjugateNonlinearFlux, map_sub, map_add, map_smul,
    basis.equivFun.apply_symm_apply, Pi.sub_apply, Pi.add_apply,
    Pi.smul_apply, smul_eq_mul]

end NumStability
