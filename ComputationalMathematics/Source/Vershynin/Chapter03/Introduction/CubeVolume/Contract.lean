import ComputationalMathematics.Source.Vershynin.Chapter03.Introduction.CubeVolume.Signature

/-! Source-facing contract for the Chapter 3 introductory cube-volume comparison. -/

open MeasureTheory Set

namespace NumStability.HDP.Contract

/-- Chapter 3 introduction, printed page 41: in `ℝ^n`, the cube of side `2`
has `2^n` times the volume of the unit cube. The coordinate boxes `[0,2]^n`
and `[0,1]^n` match the cubes drawn in Figure 3.1. -/
theorem hdp_03_intro_cube_volume (n : ℕ) :
    volume (Icc (0 : Fin n → ℝ) (fun _ ↦ 2)) =
      (2 : ENNReal) ^ n * volume (Icc (0 : Fin n → ℝ) (fun _ ↦ 1)) := by
  simp [Real.volume_Icc_pi]

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen introductory cube-volume signature. -/
theorem hdp_03_intro_cube_volume__contract : hdp_03_intro_cube_volume__contract_type := by
  exact hdp_03_intro_cube_volume

end NumStability.HDP.Contract
