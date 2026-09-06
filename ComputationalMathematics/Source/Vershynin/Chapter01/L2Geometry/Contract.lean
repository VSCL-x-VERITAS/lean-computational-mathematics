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

/-- Equation (1.1): on square-integrable real random variables, the
representative-level inner product is `E[XY]`, and its corresponding norm is
the square root of `E|X|²`.  Mathlib's `Lp` supplies the a.e.-quotient space;
this theorem isolates the two printed formulas. -/
theorem hdp_01_heq_h1_d1_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X Y : Ω → ℝ)
    (_hX : MemLp X 2 μ) (_hY : MemLp Y 2 μ) :
    NumStability.HDP.Scalar.Preliminaries.l2InnerProduct μ X Y =
        NumStability.HDP.Scalar.Preliminaries.expectation μ (fun ω => X ω * Y ω) ∧
      NumStability.HDP.Scalar.Preliminaries.l2Norm μ X =
        Real.sqrt
          (NumStability.HDP.Scalar.Preliminaries.expectation μ
            (fun ω => |X ω| ^ 2)) := by
  constructor
  · rfl
  · simp only [NumStability.HDP.Scalar.Preliminaries.l2Norm, sq_abs]

end NumStability.HDP.Contract
