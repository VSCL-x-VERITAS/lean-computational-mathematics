/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.CenteredSlopeError
import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.Calculus.UniformLocalDerivativeBudget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Analysis.Calculus.ContDiff.Bounds
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.FDeriv.Symmetric
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic

/-!
# LocalVectorCenteredSlope

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem uniform_local_centeredSlope_budget
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (f : ℝ → E) (center : ℝ) (hsmooth : ContDiffAt ℝ 3 f center) :
    ∃ threshold K : ℝ, 0 < threshold ∧ 0 ≤ K ∧
      ∀ cellCenter radius : ℝ, 0 < radius →
        |cellCenter - center| + radius ≤ threshold →
        ‖(2 * radius)⁻¹ • (f (cellCenter + radius) - f (cellCenter - radius)) -
          deriv f cellCenter‖ ≤ K * radius ^ 2 := by
  obtain ⟨rf, Kf, hrf, hKf, hdf, hLf⟩ :=
    uniform_local_derivative_budget f center (hsmooth.of_le (by norm_num))
  have hsmooth' : ContDiffAt ℝ 2 (deriv f) center := hsmooth.derivWithin (by norm_num)
  obtain ⟨rd, K, hrd, hK, hdd, hLd⟩ :=
    uniform_local_derivative_budget (deriv f) center hsmooth'
  refine ⟨min rf rd, K, lt_min hrf hrd, hK, ?_⟩
  intro cellCenter radius hradius hcover
  have hcoverf := hcover.trans (min_le_left rf rd)
  have hcoverd := hcover.trans (min_le_right rf rd)
  have hdistf := abs_le.mp (le_sub_iff_add_le.mpr hcoverf)
  have hdistd := abs_le.mp (le_sub_iff_add_le.mpr hcoverd)
  have hsubf (x : ℝ) (hx : x ∈ Set.Icc (cellCenter - radius) (cellCenter + radius)) :
      x ∈ Set.Icc (center - rf) (center + rf) := by
    constructor <;> linarith [hx.1, hx.2, hdistf.1, hdistf.2]
  have hsubd (x : ℝ) (hx : x ∈ Set.Icc (cellCenter - radius) (cellCenter + radius)) :
      x ∈ Set.Icc (center - rd) (center + rd) := by
    constructor <;> linarith [hx.1, hx.2, hdistd.1, hdistd.2]
  have hc : cellCenter ∈ Set.Icc (center - rd) (center + rd) :=
    hsubd cellCenter ⟨by linarith, by linarith⟩
  exact local_vector_centeredSlope_error
    f (deriv f) (deriv (deriv f)) K cellCenter radius hK hradius
    (fun x hx => hdf x (hsubf x hx))
    (fun x hx => hdd x (hsubd x hx))
    (fun x hx => hLd x (hsubd x hx) cellCenter hc)

theorem uniform_local_centeredSlope_norm_bound
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (f : ℝ → E) (center : ℝ) (hsmooth : ContDiffAt ℝ 3 f center) :
    ∃ threshold M : ℝ, 0 < threshold ∧ 0 ≤ M ∧
      ∀ cellCenter radius : ℝ, 0 < radius → radius ≤ 1 →
        |cellCenter - center| + radius ≤ threshold →
        ‖(2 * radius)⁻¹ • (f (cellCenter + radius) - f (cellCenter - radius))‖ ≤ M := by
  obtain ⟨rs, Ks, hrs, hKs, hs⟩ := uniform_local_centeredSlope_budget f center hsmooth
  obtain ⟨rd, Kd, hrd, hKd, hd, hLd⟩ := uniform_local_derivative_budget
    f center (hsmooth.of_le (by norm_num))
  refine ⟨min rs rd, Ks + Kd * rd + ‖deriv f center‖,
    lt_min hrs hrd, by positivity, ?_⟩
  intro cellCenter radius hradius hradiusOne hcover
  have herror := hs cellCenter radius hradius (hcover.trans (min_le_left rs rd))
  have hdist : |cellCenter - center| ≤ rd := by
    linarith [hcover.trans (min_le_right rs rd)]
  have hmem : cellCenter ∈ Set.Icc (center - rd) (center + rd) := by
    constructor <;> linarith [(abs_le.mp hdist).1, (abs_le.mp hdist).2]
  have hcenter : center ∈ Set.Icc (center - rd) (center + rd) := by
    constructor <;> linarith
  have hvariation := hLd cellCenter hmem center hcenter
  have hvariation' : ‖deriv f cellCenter - deriv f center‖ ≤ Kd * rd :=
    hvariation.trans (mul_le_mul_of_nonneg_left hdist hKd)
  have hsq : radius ^ 2 ≤ 1 := by nlinarith
  have herror' : ‖(2 * radius)⁻¹ • (f (cellCenter + radius) - f (cellCenter - radius)) -
      deriv f cellCenter‖ ≤ Ks := by
    exact herror.trans (by simpa only [mul_one] using mul_le_mul_of_nonneg_left hsq hKs)
  have hderiv : ‖deriv f cellCenter‖ ≤ Kd * rd + ‖deriv f center‖ := by
    calc
      _ ≤ ‖deriv f cellCenter - deriv f center‖ + ‖deriv f center‖ := norm_le_norm_sub_add _ _
      _ ≤ Kd * rd + ‖deriv f center‖ := add_le_add hvariation' (le_refl _)
  calc
    _ ≤ ‖(2 * radius)⁻¹ • (f (cellCenter + radius) - f (cellCenter - radius)) -
          deriv f cellCenter‖ + ‖deriv f cellCenter‖ := norm_le_norm_sub_add _ _
    _ ≤ Ks + (Kd * rd + ‖deriv f center‖) := add_le_add herror' hderiv
    _ = Ks + Kd * rd + ‖deriv f center‖ := by ring

end NumStability
