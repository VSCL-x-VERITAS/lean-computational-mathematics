/-
SPDX-License-Identifier: MIT
-/

/- Scratch proof for LeVeque Chapter 2, C2.U.055. -/
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPropagatingModeGeometryTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDirectionalHyperbolicity

/-!
# LeVeque Chapter 2: MaxwellPropagatingModeGeometry

Proof of the geometry of propagating Maxwell modes.
-/

namespace NumStability.Leveque02Tracer

theorem maxwellPropagatingModeGeometry :
    maxwellPropagatingModeGeometryTarget := by
  intro permittivity permeability direction speed state hε hμ hspeed hmode
  dsimp only
  let electric : MaxwellVector := state ∘ Sum.inl
  let magnetic : MaxwellVector := state ∘ Sum.inr
  have haction := (maxwellDirectionalHyperbolicity
    permittivity permeability hε hμ direction).2 state
  have heigen := hmode.apply_eq_smul
  have hE (i : Fin 3) :
      -(1 / (permittivity * permeability)) *
          crossProduct direction magnetic i = speed * electric i := by
    have hi := congrFun heigen (Sum.inl i)
    rw [Matrix.toLin'_apply, (haction i).1] at hi
    simpa only [Pi.smul_apply, smul_eq_mul] using hi
  have hB (i : Fin 3) :
      crossProduct direction electric i = speed * magnetic i := by
    have hi := congrFun heigen (Sum.inr i)
    rw [Matrix.toLin'_apply, (haction i).2] at hi
    simpa only [Pi.smul_apply, smul_eq_mul] using hi
  have hEvec : speed • electric =
      (-(1 / (permittivity * permeability))) •
        crossProduct direction magnetic := by
    funext i
    simpa only [Pi.smul_apply, smul_eq_mul] using (hE i).symm
  have hBvec : speed • magnetic = crossProduct direction electric := by
    funext i
    simpa only [Pi.smul_apply, smul_eq_mul] using (hB i).symm
  have hdirE : dotProduct direction electric = 0 := by
    have hzero : dotProduct direction (speed • electric) = 0 := by
      rw [hEvec]
      simp [dotProduct_smul, dot_self_cross]
    have hmul : speed * dotProduct direction electric = 0 := by
      simpa [dotProduct_smul, smul_eq_mul] using hzero
    exact (mul_eq_zero.mp hmul).resolve_left hspeed
  have hdirB : dotProduct direction magnetic = 0 := by
    have hzero : dotProduct direction (speed • magnetic) = 0 := by
      rw [hBvec]
      exact dot_self_cross direction electric
    have hmul : speed * dotProduct direction magnetic = 0 := by
      simpa [dotProduct_smul, smul_eq_mul] using hzero
    exact (mul_eq_zero.mp hmul).resolve_left hspeed
  have hEB : dotProduct electric magnetic = 0 := by
    have hzero : dotProduct electric (speed • magnetic) = 0 := by
      rw [hBvec]
      exact dot_cross_self direction electric
    have hmul : speed * dotProduct electric magnetic = 0 := by
      simpa [dotProduct_smul, smul_eq_mul] using hzero
    exact (mul_eq_zero.mp hmul).resolve_left hspeed
  exact ⟨hdirE, hdirB, hEB⟩

/-- A concrete x-directed mode shows that the nonzero-speed premise is
satisfiable: E points in y, B in z, and the wave speed is one. -/
theorem maxwellPropagatingMode_nonvacuous :
    ∃ (direction : MaxwellVector) (state : MaxwellStateIndex → ℝ),
      Module.End.HasEigenvector
        (Matrix.toLin' (maxwellDirectionalMatrix 1 1 direction)) 1 state := by
  let direction : MaxwellVector := ![1, 0, 0]
  let electric : MaxwellVector := ![0, 1, 0]
  let magnetic : MaxwellVector := ![0, 0, 1]
  let state : MaxwellStateIndex → ℝ := Sum.elim electric magnetic
  refine ⟨direction, state, ?_⟩
  rw [Module.End.hasEigenvector_iff]
  constructor
  · rw [Module.End.mem_eigenspace_iff]
    have haction := (maxwellDirectionalHyperbolicity 1 1 (by norm_num)
      (by norm_num) direction).2 state
    funext j
    rcases j with i | i
    · have h := (haction i).1
      rw [Matrix.toLin'_apply, h]
      fin_cases i <;>
        norm_num [direction, electric, magnetic, state, cross_apply,
          Matrix.cons_val_two] ; rfl
    · have h := (haction i).2
      rw [Matrix.toLin'_apply, h]
      fin_cases i <;>
        norm_num [direction, electric, magnetic, state, cross_apply,
          Matrix.cons_val_two]
  · intro hz
    have h := congrFun hz (Sum.inl (1 : Fin 3))
    norm_num [state, electric] at h


end NumStability.Leveque02Tracer
