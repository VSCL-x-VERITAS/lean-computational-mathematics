/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovREAGlobalSharpness
import ComputationalMathematics.Source.LeVeque.Chapter04.REALinearCauchyWindow
import Mathlib.Analysis.Normed.Module.FiniteDimension

/-!
# Riemann assembly and averaging as a concrete Godunov step

The step reconstructs the stored cell data, assembles their actual linear
Riemann solutions, and averages the resulting field. It agrees with the
existing exact characteristic REA stage, so its error and sharpness producers
are shared with that stage.
-/

namespace NumStability

open MeasureTheory

/-- Reconstruct, evolve by actual Riemann assembly, and average on the
centered uniform grid. The next step reconstructs the new cell array. -/
noncomputable def leveque04_linearRiemannREAStep
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (width ratio : ℝ)
    (hwidth : 0 < width) (hratio : 0 < ratio)
    (old : ℤ → Fin m → ℝ) (i : ℤ) : Fin m → ℝ :=
  oneDimensionalCellAverage
    (fun x => linearRiemannChainEvolution basis speeds old (width / 2) width
      (ratio * width) hwidth (mul_pos hratio hwidth).le x (ratio * width))
    ((i : ℝ) * width - width / 2) ((i : ℝ) * width + width / 2)

/-- The actual Riemann step shares the existing exact-stage implementation
at the level of the resulting cell-array transformation. -/
theorem leveque04_linearRiemannREAStep_eq_uniformStage
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (width ratio : ℝ) (hwidth : 0 < width) (hratio : 0 < ratio) :
    leveque04_linearRiemannREAStep basis speeds width ratio hwidth hratio =
      leveque04_linearUniformREAStep coefficient hcoefficient basis speeds heigen
        (width / 2) width ratio hwidth := by
  funext old i
  have hfield :
      (fun x => linearRiemannChainEvolution basis speeds old (width / 2) width
        (ratio * width) hwidth (mul_pos hratio hwidth).le x (ratio * width)) =
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction (width / 2) width old) x (ratio * width)) := by
    funext x
    exact leveque04_linearRiemannChainEvolution_eq_characteristicCauchy
      basis speeds old (width / 2) width (ratio * width) hwidth
      (mul_pos hratio hwidth).le x (ratio * width)
      ⟨(mul_pos hratio hwidth).le, le_refl _⟩
  unfold leveque04_linearRiemannREAStep
  rw [hfield]
  unfold leveque04_linearUniformREAStep Leveque04REAStage.nextAverage
  dsimp only [leveque04_linearUniformStage]
  rw [(leveque04_centeredUniformGrid_endpoints width hwidth i).1,
    (leveque04_centeredUniformGrid_endpoints width hwidth i).2]

/-- The exact uniform stage has the selected Godunov update under the full
linear CFL bound. Endpoint face values do not affect time-averaged fluxes. -/
theorem leveque04_linearUniformREA_eq_godunovWaveStep_of_CFL
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width ratio bound : ℝ) (hwidth : 0 < width) (hratio : 0 < ratio)
    (_hbound : 0 ≤ bound) (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : bound * ratio ≤ 1) (old : ℤ → Fin m → ℝ) (i : ℤ) :
    (leveque04_linearUniformStage coefficient hcoefficient basis speeds heigen
      origin width hwidth old).nextAverage (ratio * width) i =
      leveque04_linearGodunovWaveStep basis speeds ratio old i := by
  let stage := leveque04_linearUniformStage coefficient hcoefficient basis speeds heigen
    origin width hwidth old
  have htime : 0 < ratio * width := mul_pos hratio hwidth
  apply leveque04_linearGodunovWaveStep_eq_reaAverage coefficient hcoefficient
    basis speeds heigen stage (ratio * width) ratio htime
  · intro j
    have hvolume : (leveque04_uniformGrid origin width hwidth).cellVolume j = width := by
      dsimp [OneDimensionalFiniteVolumeGrid.cellVolume,
        leveque04_uniformGrid, leveque04_uniformInterface]
      push_cast
      ring
    change (ratio * width) / (leveque04_uniformGrid origin width hwidth).cellVolume j = ratio
    rw [hvolume]
    field_simp
  · intro j
    have havg := linearRectangleRiemannInterfaceFluxMethod_flux_eq_timeAverage
      coefficient hcoefficient basis speeds heigen
      (adjacentCellRiemannProblem
        (linearHyperbolicConservationLaw coefficient hcoefficient) old j) htime
    unfold rectangleRiemannInterfaceFlux adjacentCellRectangleRiemannInformation
    rw [havg]
    unfold oneDimensionalCellAverage
    congr 1
    apply intervalIntegral.integral_congr_ae
    filter_upwards [Measure.ae_ne volume (ratio * width)] with time hne hmem
    have ht : 0 < time ∧ time ≤ ratio * width := by
      simpa only [Set.uIoc_of_le htime.le, Set.mem_Ioc] using hmem
    have htlt : time < ratio * width := lt_of_le_of_ne ht.2 hne
    have hscaled : bound * (ratio * width) ≤ width := by
      have := mul_le_mul_of_nonneg_right hCFL hwidth.le
      nlinarith
    apply congrArg coefficient.mulVec
    change linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old)
      (leveque04_uniformInterface origin width (j - 1)) time =
      linearRiemannSolution basis speeds (old (j - 1)) (old (j - 1)) (old j) 0 time
    have hleft : ∀ p, 0 < speeds p →
        leveque04_uniformInterface origin width ((j - 1) - 1) <
          leveque04_uniformInterface origin width (j - 1) - speeds p * time := by
      intro p hp
      have hboundpos : 0 < bound := lt_of_lt_of_le hp (hspeeds p).2
      have htravel := mul_lt_mul_of_pos_left htlt hboundpos
      have hspeed := mul_le_mul_of_nonneg_right (hspeeds p).2 ht.1.le
      dsimp [leveque04_uniformInterface]
      push_cast
      nlinarith
    have hright : ∀ p, speeds p < 0 →
        leveque04_uniformInterface origin width (j - 1) - speeds p * time <
          leveque04_uniformInterface origin width ((j - 1) + 1) := by
      intro p hp
      have hboundpos : 0 < bound := by linarith [(hspeeds p).1]
      have htravel := mul_lt_mul_of_pos_left htlt hboundpos
      have hspeed := mul_le_mul_of_nonneg_right (hspeeds p).1 ht.1.le
      dsimp [leveque04_uniformInterface]
      push_cast
      nlinarith
    simpa only [sub_add_cancel] using
      (leveque04_linearCharacteristic_face_eq_localRiemann basis speeds
        (leveque04_uniformInterface origin width) old _
        (leveque04_uniformReconstruction_cell origin width hwidth old)
        (leveque04_uniformReconstruction_face origin width hwidth old)
        (j - 1) time ht.1 hleft hright)

/-- The primitive Riemann assembly-and-average step equals the existing
signed Godunov update throughout the full linear CFL range. -/
theorem leveque04_linearRiemannREAStep_eq_waveStep_of_CFL
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (width ratio bound : ℝ) (hwidth : 0 < width) (hratio : 0 < ratio)
    (hbound : 0 ≤ bound) (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : bound * ratio ≤ 1) :
    leveque04_linearRiemannREAStep basis speeds width ratio hwidth hratio =
      leveque04_linearGodunovWaveStep basis speeds ratio := by
  rw [leveque04_linearRiemannREAStep_eq_uniformStage coefficient hcoefficient
    basis speeds heigen width ratio hwidth hratio]
  funext old i
  exact leveque04_linearUniformREA_eq_godunovWaveStep_of_CFL coefficient
    hcoefficient basis speeds heigen (width / 2) width ratio bound
    hwidth hratio hbound hspeeds hCFL old i

/-- Characteristic projection commutes with repeated actual Riemann REA
steps under the full CFL condition. This uses the generic semiconjugacy
iteration theorem rather than a separate induction on the method. -/
theorem leveque04_linearRiemannREA_positiveCharacteristic_iterate_of_CFL
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (width ratio bound : ℝ) (hwidth : 0 < width) (hratio : 0 < ratio)
    (hbound : 0 ≤ bound) (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : bound * ratio ≤ 1) (p : Fin m) (hp : 0 < speeds p)
    (old : ℤ → Fin m → ℝ) (steps : ℕ) (i : ℤ) :
    basis.equivFun
      (((leveque04_linearRiemannREAStep basis speeds width ratio hwidth hratio)^[steps]
        old) i) p =
      (((leveque04_positiveUpwindStep (ratio * width) width (speeds p))^[steps]
        (fun j => basis.equivFun (old j) p)) i) := by
  let project := fun states : ℤ → Fin m → ℝ => fun j => basis.equivFun (states j) p
  have hcommute : Function.Semiconj project
      (leveque04_linearRiemannREAStep basis speeds width ratio hwidth hratio)
      (leveque04_positiveUpwindStep (ratio * width) width (speeds p)) := by
    intro states
    funext j
    dsimp only [project]
    rw [leveque04_linearRiemannREAStep_eq_waveStep_of_CFL coefficient
      hcoefficient basis speeds heigen width ratio bound hwidth hratio hbound hspeeds hCFL,
      leveque04_linearGodunovWaveStep_characteristic]
    simp only [leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_left hp.le, min_eq_right hp.le, zero_mul, add_zero]
    rw [leveque04_equation25 (ratio * width) width (speeds p)
      (fun k => basis.equivFun (states k) p) j hp]
    have hwne : width ≠ 0 := ne_of_gt hwidth
    field_simp
  exact congrFun (hcommute.iterate_right steps old) i

/-- The actual Riemann REA method has the existing scalar quadratic
fixed-horizon error in each positive characteristic. -/
theorem leveque04_linearRiemannREA_positiveQuadratic_fixedHorizonError
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (width ratio bound horizon : ℝ) (hwidth : 0 < width) (hratio : 0 < ratio)
    (hbound : 0 ≤ bound) (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : bound * ratio ≤ 1) (p : Fin m) (hp : 0 < speeds p)
    (steps : ℕ) (i : ℤ) (htime : (steps : ℝ) * (ratio * width) = horizon) :
    let old : ℤ → Fin m → ℝ := fun j => basis.equivFun.symm
      (fun _ => leveque04_quadraticCellAverage width j)
    basis.equivFun
      (((leveque04_linearRiemannREAStep basis speeds width ratio hwidth hratio)^[steps]
        old) i) p -
      oneDimensionalCellAverage (fun x : ℝ => (x - speeds p * horizon) ^ 2)
        ((i : ℝ) * width - width / 2) ((i : ℝ) * width + width / 2) =
      (horizon * speeds p * (1 - speeds p * ratio)) * width := by
  dsimp only
  rw [leveque04_linearRiemannREA_positiveCharacteristic_iterate_of_CFL coefficient
    hcoefficient basis speeds heigen width ratio bound hwidth hratio hbound hspeeds
    hCFL p hp]
  have hinit :
      (fun j : ℤ => basis.equivFun
        (basis.equivFun.symm (fun _ => leveque04_quadraticCellAverage width j)) p) =
      leveque04_quadraticCellAverage width := by
    funext j
    simp only [LinearEquiv.apply_symm_apply]
  rw [hinit]
  exact leveque04_positiveGodunov_quadratic_fixedHorizonError
    (speeds p) ratio width horizon steps i hp hwidth htime

/-- The same actual repeated method violates every second-order
fixed-horizon bound on arbitrarily fine meshes with interior positive
characteristic Courant number. The scalar witness is reused. -/
theorem leveque04_linearRiemannREA_positiveQuadratic_fine_not_secondOrder
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (ratio bound horizon : ℝ) (hratio : 0 < ratio) (hbound : 0 ≤ bound)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : bound * ratio ≤ 1) (p : Fin m) (hp : 0 < speeds p)
    (hhorizon : 0 < horizon) (hinterior : speeds p * ratio < 1) :
    ∀ C ε : ℝ, 0 ≤ C → 0 < ε →
      ∃ steps : ℕ, ∃ width : ℝ, ∃ hwidth : 0 < width,
        width < ε ∧ (steps : ℝ) * (ratio * width) = horizon ∧
          ∀ i : ℤ,
            let old : ℤ → Fin m → ℝ := fun j => basis.equivFun.symm
              (fun _ => leveque04_quadraticCellAverage width j)
            C * width ^ 2 <
              basis.equivFun
                (((leveque04_linearRiemannREAStep basis speeds width ratio hwidth hratio)^[steps]
                  old) i) p -
                oneDimensionalCellAverage (fun x : ℝ => (x - speeds p * horizon) ^ 2)
                  ((i : ℝ) * width - width / 2) ((i : ℝ) * width + width / 2) := by
  intro C ε hC hε
  obtain ⟨steps, width, hwidth, hsmall, htime, herror⟩ :=
    leveque04_positiveGodunov_fixedHorizon_arbitrarilyFine_not_secondOrder
      (speeds p) ratio horizon hp hratio hhorizon hinterior C ε hC hε
  refine ⟨steps, width, hwidth, hsmall, htime, ?_⟩
  intro i
  dsimp only
  rw [leveque04_linearRiemannREA_positiveQuadratic_fixedHorizonError coefficient
    hcoefficient basis speeds heigen width ratio bound horizon hwidth hratio hbound
    hspeeds hCFL p hp steps i htime]
  have hi := herror i
  rw [leveque04_positiveGodunov_quadratic_fixedHorizonError
    (speeds p) ratio width horizon steps i hp hwidth htime] at hi
  exact hi

/-- The fine-mesh witness violates every second-order bound in the
physical state norm. The basis-coordinate operator norm only rescales the
scalar comparison constant; it introduces no restriction on the mesh. -/
theorem leveque04_linearRiemannREA_positiveQuadratic_fine_physicalNorm_not_secondOrder
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (ratio bound horizon : ℝ) (hratio : 0 < ratio) (hbound : 0 ≤ bound)
    (hspeeds : ∀ p, -bound ≤ speeds p ∧ speeds p ≤ bound)
    (hCFL : bound * ratio ≤ 1) (p : Fin m) (hp : 0 < speeds p)
    (hhorizon : 0 < horizon) (hinterior : speeds p * ratio < 1) :
    ∀ C ε : ℝ, 0 ≤ C → 0 < ε →
      ∃ steps : ℕ, ∃ width : ℝ, ∃ hwidth : 0 < width,
        width < ε ∧ (steps : ℝ) * (ratio * width) = horizon ∧
          ∀ i : ℤ,
            let old : ℤ → Fin m → ℝ := fun j => basis.equivFun.symm
              (fun _ => leveque04_quadraticCellAverage width j)
            let exact := basis.equivFun.symm (fun q =>
              oneDimensionalCellAverage (fun x : ℝ => (x - speeds q * horizon) ^ 2)
                ((i : ℝ) * width - width / 2) ((i : ℝ) * width + width / 2))
            C * width ^ 2 <
              ‖((leveque04_linearRiemannREAStep basis speeds width ratio hwidth hratio)^[steps]
                old) i - exact‖ := by
  intro C ε hC hε
  let d := ‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖
  have hd : 0 ≤ d := norm_nonneg _
  obtain ⟨steps, width, hwidth, hsmall, htime, herror⟩ :=
    leveque04_linearRiemannREA_positiveQuadratic_fine_not_secondOrder coefficient
      hcoefficient basis speeds heigen ratio bound horizon hratio hbound hspeeds
      hCFL p hp hhorizon hinterior (d * C) ε (mul_nonneg hd hC) hε
  refine ⟨steps, width, hwidth, hsmall, htime, ?_⟩
  intro i
  let old : ℤ → Fin m → ℝ := fun j => basis.equivFun.symm
    (fun _ => leveque04_quadraticCellAverage width j)
  let computed := ((leveque04_linearRiemannREAStep basis speeds width ratio
    hwidth hratio)^[steps] old) i
  let exact := basis.equivFun.symm (fun q =>
    oneDimensionalCellAverage (fun x : ℝ => (x - speeds q * horizon) ^ 2)
      ((i : ℝ) * width - width / 2) ((i : ℝ) * width + width / 2))
  change C * width ^ 2 < ‖computed - exact‖
  have hlarge : (d * C) * width ^ 2 < basis.equivFun (computed - exact) p := by
    simpa only [computed, exact, old, map_sub, Pi.sub_apply, LinearEquiv.apply_symm_apply]
      using herror i
  have hcoord : |basis.equivFun (computed - exact) p| ≤
      ‖basis.equivFun (computed - exact)‖ := by
    simpa only [Real.norm_eq_abs] using
      norm_le_pi_norm (basis.equivFun (computed - exact)) p
  have hmap : ‖basis.equivFun (computed - exact)‖ ≤ d * ‖computed - exact‖ :=
    basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap.le_opNorm _
  have hupper := (le_abs_self (basis.equivFun (computed - exact) p)).trans
    (hcoord.trans hmap)
  by_contra! hfail
  have hmul := mul_le_mul_of_nonneg_left hfail hd
  nlinarith

end NumStability
