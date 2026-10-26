import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

/-!
# Cell averages transported by scalar advection

Translation of a scalar field transports its interval cell average.
-/

namespace NumStability

section
open MeasureTheory
open Set

def leveque04_scalarAdvectedField (q0 : ℝ → ℝ) (u x t : ℝ) : ℝ := q0 (x - u * t)

end

section
open MeasureTheory
open Set

def leveque04_scalarPhysicalFlux (q0 : ℝ → ℝ) (u x t : ℝ) : ℝ :=
  u * leveque04_scalarAdvectedField q0 u x t

end

section
open MeasureTheory
open Set

noncomputable def leveque04_scalarNewCellAverage
    (q0 : ℝ → ℝ) (u dt face width : ℝ) : ℝ :=
  NumStability.oneDimensionalCellAverage
    (fun x => leveque04_scalarAdvectedField q0 u x dt) face (face + width)

end

section
open MeasureTheory
open Set

noncomputable def leveque04_scalarTimeFaceFluxAverage
    (q0 : ℝ → ℝ) (u dt face : ℝ) : ℝ :=
  dt⁻¹ * ∫ t in (0:ℝ)..dt, leveque04_scalarPhysicalFlux q0 u face t

end

end NumStability
