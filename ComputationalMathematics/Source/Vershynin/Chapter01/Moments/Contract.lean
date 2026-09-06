import ComputationalMathematics.HDP.Scalar.Preliminaries
/-!
Cross-split stable API for `HDP-01-DEF-MOMENTS`.

The printed raw real-power formula is not real-valued for every real random
variable and every positive real exponent.  This leaf records a concrete
square-root obstruction and exposes the corrected natural-raw/real-absolute
split; the reusable producer owns the underlying definitions.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Stable source-facing corrected moment interface. -/
def hdp_01_hdef_hmoments
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    Type :=
  NumStability.HDP.Scalar.Preliminaries.MomentModelData μ X

/-- There is no real-valued square-root operation on all real inputs, the
`p = 1/2`, `X = -1` obstruction to the printed raw real-power formula. -/
theorem hdp_01_hdef_hmoments_source_obstruction :
    ¬ ∃ sqrtLike : ℝ → ℝ, ∀ x : ℝ, (sqrtLike x) ^ 2 = x := by
  rintro ⟨sqrtLike, hsqrt⟩
  exact NumStability.HDP.Scalar.Preliminaries.no_real_square_root_neg_one
    ⟨sqrtLike (-1), by simpa using hsqrt (-1)⟩

/-- Corrected formulas: raw moments use natural powers, while positive-real
absolute moments use the nonnegative extended Lebesgue integral. -/
theorem hdp_01_hdef_hmoments_corrected
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ)
    (n : ℕ) (p : ℝ) (_hp : 0 < p) :
    NumStability.HDP.Scalar.Preliminaries.rawMoment μ X n =
        NumStability.HDP.Scalar.Preliminaries.expectation μ
          (fun ω => X ω ^ n) ∧
      NumStability.HDP.Scalar.Preliminaries.absoluteMoment μ X p =
        ∫⁻ ω, ENNReal.ofReal (Real.rpow |X ω| p) ∂μ := by
  constructor <;> rfl

end NumStability.HDP.Contract
