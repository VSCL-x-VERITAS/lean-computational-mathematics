import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingStep

/-!
Scratch comparison on explicit mathematical domains. This is not a source
faithfulness claim or an adoption of an interpretation of LeVeque (1.10).
-/

open MeasureTheory

namespace NumStability.DiscontinuityComparisonDraft

variable {ι : Type*} [Fintype ι]

/-- Any finite-vector rectangle solution has a mass derivative almost everywhere
on each fixed spatial interval. A spatial state discontinuity excludes its
spatial derivative and every quasilinear classical residual at that point.
The exceptional null set in time may depend on the spatial interval. -/
theorem rectangleSolution_discontinuity_comparison
    {q : ℝ → ℝ → ι → ℝ} {flux : (ι → ℝ) → ι → ℝ}
    (hrectangle : IsRectangleConservationLawSolution q flux)
    {x t : ℝ} (hjump : ¬ ContinuousAt (fun ξ => q ξ t) x) :
    (∀ a b, ∀ᵐ τ, HasDerivAt (fun s => ∫ ξ in a..b, q ξ s)
      (flux (q a τ) - flux (q b τ)) τ) ∧
    (∀ qx, ¬ HasDerivAt (fun ξ => q ξ t) qx x) ∧
    (¬ DifferentiableAt ℝ (fun ξ => q ξ t) x) ∧
    (∀ fluxDerivative : (ι → ℝ) → ((ι → ℝ) →L[ℝ] (ι → ℝ)),
      ¬ IsQuasilinearConservationLawSolutionAt q fluxDerivative x t) := by
  refine ⟨hrectangle.hasDerivAt_mass_ae, ?_, ?_, ?_⟩
  · intro qx hqx
    exact hjump hqx.continuousAt
  · intro hdiff
    exact hjump hdiff.continuousAt
  · intro fluxDerivative hclassical
    obtain ⟨qt, qx, _, hqx, _⟩ := hclassical
    exact hjump hqx.continuousAt

/-- The conservative residual requires differentiability of the composed flux.
Noncontinuity of that composition, not merely of the state, excludes it. -/
theorem not_conservationLawSolutionAt_of_flux_not_continuousAt
    {q : ℝ → ℝ → ι → ℝ} {flux : (ι → ℝ) → ι → ℝ}
    {x t : ℝ} (hflux : ¬ ContinuousAt (fun ξ => flux (q ξ t)) x) :
    ¬ IsConservationLawSolutionAt q flux x t := by
  rintro ⟨qt, fluxx, _, hfluxx, _⟩
  exact hflux hfluxx.continuousAt

/-- A stationary state with constant flux satisfies the conservative residual
even when the spatial profile is discontinuous. -/
theorem stationaryField_constantFlux_residual
    (profile : ℝ → ι → ℝ) (fluxValue : ι → ℝ) (x t : ℝ) :
    IsConservationLawSolutionAt (fun ξ _ => profile ξ) (fun _ => fluxValue) x t := by
  refine ⟨0, 0, hasDerivAt_const t (profile x), hasDerivAt_const x fluxValue, ?_⟩
  simp

/-- Vector Riemann data with distinct states give actual discontinuities along
the entire moving jump, at every speed and every choice of the jump value. -/
theorem vectorStep_not_continuousAt_jump
    (left valueAtJump right : ι → ℝ) (hne : left ≠ right) (speed t : ℝ) :
    ¬ ContinuousAt (fun x => travelingWave (riemannData left valueAtJump right)
      speed x t) (speed * t) := by
  intro hc
  have hc' : ContinuousAt (fun x => travelingWave (riemannData left valueAtJump right)
      speed x t) ((0 : ℝ) + speed * t) := by simpa using hc
  have hprofile : ContinuousAt (riemannData left valueAtJump right) 0 := by
    simpa only [Function.comp_def, travelingWave, add_sub_cancel_right] using
      hc'.comp (x := 0) (f := fun z : ℝ => z + speed * t)
        (continuousAt_id.add_const (speed * t))
  exact (riemannData_isRiemannData left valueAtJump right).not_continuousAt_zero hne hprofile

/-- The moving vector jump is a conserved field, not an assumed balance
certificate: its rectangle law comes from integrable Riemann data. -/
theorem vectorStep_rectangle_and_discontinuity
    (left valueAtJump right : ι → ℝ) (hne : left ≠ right) (speed : ℝ) :
    IsRectangleConservationLawSolution
      (travelingWave (riemannData left valueAtJump right) speed)
      (fun state => speed • state) ∧
    ∀ t, ¬ ContinuousAt (fun x =>
      travelingWave (riemannData left valueAtJump right) speed x t) (speed * t) := by
  exact ⟨travelingWave_isRectangleConservationLawSolution _
    (riemannData_intervalIntegrable left valueAtJump right) speed,
    vectorStep_not_continuousAt_jump left valueAtJump right hne speed⟩

/-- A concrete finite-vector inhabitant shows the comparison premises are
jointly satisfiable, including a discontinuity at a strictly positive time. -/
theorem exists_discontinuous_rectangle_field :
    ∃ (q : ℝ → ℝ → Fin 1 → ℝ) (flux : (Fin 1 → ℝ) → Fin 1 → ℝ)
      (x t : ℝ),
      IsRectangleConservationLawSolution q flux ∧ 0 < t ∧
      ¬ ContinuousAt (fun ξ => q ξ t) x := by
  have hne : (0 : Fin 1 → ℝ) ≠ 1 := by
    intro h
    have hzero : (0 : ℝ) = 1 := congrFun h 0
    exact zero_ne_one hzero
  obtain ⟨hrectangle, hjump⟩ :=
    vectorStep_rectangle_and_discontinuity (0 : Fin 1 → ℝ) 0 1 hne 1
  exact ⟨_, _, 1, 1, hrectangle, by norm_num, by simpa using hjump 1⟩

/-- A discontinuous conserved vector state can satisfy the existing conservative
residual, because that predicate does not require a spatial state derivative. -/
theorem discontinuous_stationary_conservative_residual
    (left valueAtJump right : ι → ℝ) (hne : left ≠ right) :
    IsRectangleConservationLawSolution
      (fun x _ => riemannData left valueAtJump right x) (fun _ => 0) ∧
    (∀ x t, IsConservationLawSolutionAt
      (fun ξ _ => riemannData left valueAtJump right ξ) (fun _ => 0) x t) ∧
    (∀ t : ℝ, ¬ ContinuousAt (fun x => riemannData left valueAtJump right x) 0) := by
  refine ⟨?_, stationaryField_constantFlux_residual _ 0, ?_⟩
  · have hfield : travelingWave (riemannData left valueAtJump right) 0 =
        (fun x _ => riemannData left valueAtJump right x) := by
      funext x t
      simp only [travelingWave, zero_mul, sub_zero]
    simpa only [hfield, zero_smul] using
      travelingWave_isRectangleConservationLawSolution
        (riemannData left valueAtJump right)
        (riemannData_intervalIntegrable left valueAtJump right) 0
  · intro t
    exact (riemannData_isRiemannData left valueAtJump right).not_continuousAt_zero hne

end NumStability.DiscontinuityComparisonDraft
