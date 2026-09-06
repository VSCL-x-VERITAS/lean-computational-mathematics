import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
Cross-split stable API for `HDP-01-DEF-L2-GEOMETRY`.

The semantic producer owns the representative-level expectation formulas;
this leaf exports the stable constructor alias used by downstream chapters.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

noncomputable def hdp_01_hdef_hl2_hgeometry
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) :
    NumStability.HDP.Scalar.Preliminaries.L2GeometryModelData μ X Y :=
  NumStability.HDP.Scalar.Preliminaries.l2GeometryModel μ X Y

end NumStability.HDP.Contract
