/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPropagatingPlaneWaveTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPropagatingModeGeometry
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDirectionalHyperbolicity
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv

/-!
# LeVeque Chapter 2: MaxwellPropagatingPlaneWave

Construction of a nonvacuous propagating Maxwell plane wave.
-/

namespace NumStability.Leveque02Tracer

private theorem phase_time_deriv (direction position : MaxwellVector) (speed time : ℝ) :
    HasDerivAt (fun τ => maxwellWavePhase direction position speed τ) (-speed) time := by
  convert (hasDerivAt_const time (dotProduct direction position)).sub
    ((hasDerivAt_id time).const_mul speed) using 1
  simp

private theorem phase_space_deriv (direction position : MaxwellVector)
    (speed time : ℝ) (coordinate : Fin 3) :
    HasDerivAt (fun s => maxwellWavePhase direction (Function.update position coordinate s) speed time)
      (direction coordinate) (position coordinate) := by
  fin_cases coordinate
  · simpa [maxwellWavePhase, dotProduct, Fin.sum_univ_three, Function.update] using
      ((hasDerivAt_id (position 0)).const_mul (direction 0))
  · simpa [maxwellWavePhase, dotProduct, Fin.sum_univ_three, Function.update] using
      ((hasDerivAt_id (position 1)).const_mul (direction 1))
  · simpa [maxwellWavePhase, dotProduct, Fin.sum_univ_three, Function.update] using
      ((hasDerivAt_id (position 2)).const_mul (direction 2))

private theorem wave_time_deriv (profile : ℝ → ℝ) (direction vector : MaxwellVector)
    (speed : ℝ) (hprofile : ∀ s, HasDerivAt profile (deriv profile s) s)
    (position : MaxwellVector) (time : ℝ) (i : Fin 3) :
    maxwellTimePartial (maxwellDirectionalPlaneWave profile direction vector speed) i position time =
      (deriv profile (maxwellWavePhase direction position speed time) * -speed) * vector i := by
  have h := ((hprofile _).comp time (phase_time_deriv direction position speed time)).mul_const
    (vector i)
  simpa [maxwellTimePartial, maxwellDirectionalPlaneWave] using h.deriv

private theorem wave_space_deriv (profile : ℝ → ℝ) (direction vector : MaxwellVector)
    (speed : ℝ) (hprofile : ∀ s, HasDerivAt profile (deriv profile s) s)
    (position : MaxwellVector) (time : ℝ) (i j : Fin 3) :
    maxwellSpatialPartial (maxwellDirectionalPlaneWave profile direction vector speed) i j position time =
      (deriv profile (maxwellWavePhase direction position speed time) * direction j) * vector i := by
  have h := ((hprofile _).comp (position j)
    (phase_space_deriv direction position speed time j)).mul_const (vector i)
  have hupdate : Function.update position j (position j) = position := by
    funext k
    by_cases hk : k = j
    · subst k
      simp
    · simp [Function.update, hk]
  simpa [maxwellSpatialPartial, maxwellDirectionalPlaneWave, hupdate] using h.deriv

private theorem wave_space_hasDerivAt (profile : ℝ → ℝ)
    (direction vector : MaxwellVector) (speed : ℝ)
    (hprofile : ∀ s, HasDerivAt profile (deriv profile s) s)
    (position : MaxwellVector) (time : ℝ) (i j : Fin 3) :
    HasDerivAt
      (fun s => maxwellDirectionalPlaneWave profile direction vector speed
        (Function.update position j s) time i)
      (maxwellSpatialPartial
        (maxwellDirectionalPlaneWave profile direction vector speed) i j position time)
      (position j) := by
  have h := ((hprofile _).comp (position j)
    (phase_space_deriv direction position speed time j)).mul_const (vector i)
  have hupdate : Function.update position j (position j) = position := by
    funext k
    by_cases hk : k = j
    · subst k
      simp
    · simp [Function.update, hk]
  rw [wave_space_deriv profile direction vector speed hprofile]
  simpa [maxwellDirectionalPlaneWave, hupdate] using h

private theorem wave_divergence (profile : ℝ → ℝ)
    (direction vector : MaxwellVector) (speed : ℝ)
    (hprofile : ∀ s, HasDerivAt profile (deriv profile s) s)
    (position : MaxwellVector) (time : ℝ) :
    maxwellDivergence (maxwellDirectionalPlaneWave profile direction vector speed)
      position time =
      deriv profile (maxwellWavePhase direction position speed time) *
        dotProduct direction vector := by
  simp [maxwellDivergence, wave_space_deriv profile direction vector speed hprofile,
    dotProduct, Fin.sum_univ_three]
  ring

private theorem wave_curl (profile : ℝ → ℝ) (direction vector : MaxwellVector)
    (speed : ℝ) (hprofile : ∀ s, HasDerivAt profile (deriv profile s) s)
    (position : MaxwellVector) (time : ℝ) :
    maxwellCurl (maxwellDirectionalPlaneWave profile direction vector speed) position time =
      (deriv profile (maxwellWavePhase direction position speed time)) •
        crossProduct direction vector := by
  funext i
  fin_cases i <;>
    simp [maxwellCurl, wave_space_deriv profile direction vector speed hprofile,
      cross_apply, Pi.smul_apply, smul_eq_mul] <;>
    ring

theorem propagatingWaveEvolutionExperiment
    (permittivity permeability : ℝ) (direction : MaxwellVector)
    (speed : ℝ) (state : MaxwellStateIndex → ℝ) (profile : ℝ → ℝ)
    (hε : 0 < permittivity) (hμ : 0 < permeability)
    (hmode : Module.End.HasEigenvector
      (Matrix.toLin' (maxwellDirectionalMatrix permittivity permeability direction))
      speed state)
    (hprofile : ∀ s, HasDerivAt profile (deriv profile s) s) :
    let electric := maxwellDirectionalPlaneWave profile direction (state ∘ Sum.inl) speed
    let magnetic := maxwellDirectionalPlaneWave profile direction (state ∘ Sum.inr) speed
    (∀ position time component,
      maxwellTimePartial electric component position time -
        (1 / (permittivity * permeability)) *
          maxwellCurl magnetic position time component = 0) ∧
    (∀ position time component,
      maxwellTimePartial magnetic component position time +
        maxwellCurl electric position time component = 0) := by
  dsimp only
  have haction := (maxwellDirectionalHyperbolicity
    permittivity permeability hε hμ direction).2 state
  have heigen := hmode.apply_eq_smul
  have hE (i : Fin 3) :
      -(1 / (permittivity * permeability)) *
        crossProduct direction (state ∘ Sum.inr) i =
        speed * (state ∘ Sum.inl) i := by
    have hi := congrFun heigen (Sum.inl i)
    rw [Matrix.toLin'_apply, (haction i).1] at hi
    simpa only [Pi.smul_apply, smul_eq_mul] using hi
  have hB (i : Fin 3) :
      crossProduct direction (state ∘ Sum.inl) i =
        speed * (state ∘ Sum.inr) i := by
    have hi := congrFun heigen (Sum.inr i)
    rw [Matrix.toLin'_apply, (haction i).2] at hi
    simpa only [Pi.smul_apply, smul_eq_mul] using hi
  constructor
  · intro position time component
    rw [wave_time_deriv profile direction (state ∘ Sum.inl) speed hprofile,
      wave_curl profile direction (state ∘ Sum.inr) speed hprofile]
    simp only [Pi.smul_apply, smul_eq_mul]
    linear_combination (deriv profile (maxwellWavePhase direction position speed time)) *
      (hE component)
  · intro position time component
    rw [wave_time_deriv profile direction (state ∘ Sum.inr) speed hprofile,
      wave_curl profile direction (state ∘ Sum.inl) speed hprofile]
    simp only [Pi.smul_apply, smul_eq_mul]
    linear_combination (deriv profile (maxwellWavePhase direction position speed time)) *
      (hB component)

/-- Every differentiable profile of a nonzero-speed Maxwell eigenpolarization
is an actual propagating plane-wave field solving the constant-medium Maxwell
evolution equations. Both fields are everywhere mutually orthogonal and
transverse to the propagation direction. -/
theorem maxwellPropagatingPlaneWave : maxwellPropagatingPlaneWaveTarget := by
  intro permittivity permeability direction speed state profile hε hμ hspeed hmode hprofile
  dsimp only
  have hevolution := propagatingWaveEvolutionExperiment
    permittivity permeability direction speed state profile hε hμ hmode hprofile
  have hgeometry := maxwellPropagatingModeGeometry
    permittivity permeability direction speed state hε hμ hspeed hmode
  dsimp only at hgeometry
  rcases hgeometry with ⟨hdirE, hdirB, hEB⟩
  refine ⟨hevolution.1, hevolution.2, ?_, ?_⟩
  · intro position time
    constructor
    · constructor
      · intro component
        exact wave_space_hasDerivAt profile direction (state ∘ Sum.inl)
          speed hprofile position time component component
      · rw [wave_divergence profile direction (state ∘ Sum.inl)
          speed hprofile position time, hdirE]
        ring
    · constructor
      · intro component
        exact wave_space_hasDerivAt profile direction (state ∘ Sum.inr)
          speed hprofile position time component component
      · rw [wave_divergence profile direction (state ∘ Sum.inr)
          speed hprofile position time, hdirB]
        ring
  intro position time
  let amplitude := profile (maxwellWavePhase direction position speed time)
  have hEfield :
      maxwellDirectionalPlaneWave profile direction (state ∘ Sum.inl) speed position time =
        amplitude • (state ∘ Sum.inl) := by
    funext i
    rfl
  have hBfield :
      maxwellDirectionalPlaneWave profile direction (state ∘ Sum.inr) speed position time =
        amplitude • (state ∘ Sum.inr) := by
    funext i
    rfl
  rw [hEfield, hBfield]
  simp [dotProduct_smul, smul_dotProduct, hdirE, hdirB, hEB]

/-- The field-level premise is inhabited by a sinusoidal plane wave in a
positive constant medium. The existing mode witness has electric y and
magnetic z polarization in the x direction. -/
theorem maxwellPropagatingPlaneWave_nonvacuous :
    ∃ (direction : MaxwellVector) (state : MaxwellStateIndex → ℝ),
      Module.End.HasEigenvector
        (Matrix.toLin' (maxwellDirectionalMatrix 1 1 direction)) 1 state ∧
      (let electric := maxwellDirectionalPlaneWave Real.sin direction (state ∘ Sum.inl) 1
       let magnetic := maxwellDirectionalPlaneWave Real.sin direction (state ∘ Sum.inr) 1
       (∀ position time component,
         maxwellTimePartial electric component position time -
           maxwellCurl magnetic position time component = 0) ∧
       (∀ position time component,
         maxwellTimePartial magnetic component position time +
           maxwellCurl electric position time component = 0) ∧
       (∀ position time,
         IsMaxwellDivergenceFreeAt electric position time ∧
         IsMaxwellDivergenceFreeAt magnetic position time) ∧
       (∀ position time,
         dotProduct direction (electric position time) = 0 ∧
         dotProduct direction (magnetic position time) = 0 ∧
         dotProduct (electric position time) (magnetic position time) = 0)) := by
  obtain ⟨direction, state, hmode⟩ := maxwellPropagatingMode_nonvacuous
  refine ⟨direction, state, hmode, ?_⟩
  have hprofile : ∀ s, HasDerivAt Real.sin (deriv Real.sin s) s := by
    intro s
    simpa only [Real.deriv_sin] using Real.hasDerivAt_sin s
  have h := maxwellPropagatingPlaneWave 1 1 direction 1 state Real.sin
    (by norm_num) (by norm_num) (by norm_num) hmode hprofile
  simpa using h


end NumStability.Leveque02Tracer
