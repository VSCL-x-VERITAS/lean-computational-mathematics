import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/-! Frozen proof-free signature for the cube-volume comparison on printed page 41. -/

open MeasureTheory Set

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
/-- The side-two cube in `ℝ^n` has `2^n` times the volume of the unit cube. -/
def hdp_03_intro_cube_volume__contract_type : Prop :=
  ∀ n : ℕ,
    volume (Icc (0 : Fin n → ℝ) (fun _ ↦ 2)) =
      (2 : ENNReal) ^ n * volume (Icc (0 : Fin n → ℝ) (fun _ ↦ 1))

end NumStability.HDP.Contract
