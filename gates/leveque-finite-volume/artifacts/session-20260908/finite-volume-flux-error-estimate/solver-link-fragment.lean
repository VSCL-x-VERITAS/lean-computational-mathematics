/- The linear solver's own physical trace, distinguished from a global exact field. -/
namespace NumStability.FVFluxEstimateDraft

variable {m : ℕ}

noncomputable def selectedLinearSolve (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA)) :
    CertifiedRectangleRiemannSolution (linearHyperbolicConservationLaw A hA) problem :=
  (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve problem trivial

noncomputable def selectedLinearFlux (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA)) : Fin m → ℝ :=
  (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).numericalFluxFromInformation
    ((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).extractInformation
      (selectedLinearSolve A hA basis speeds heigen problem))

/-- For all ordered states, the selected method's actual output is the physical
flux of its particular returned solution at every positive ray-zero time. -/
theorem selectedLinearFlux_eq_physical_trace (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA))
    {τ : ℝ} (hτ : 0 < τ) :
    selectedLinearFlux A hA basis speeds heigen problem =
      A.mulVec ((selectedLinearSolve A hA basis speeds heigen problem).solution 0 τ) :=
  congrArg A.mulVec
    (linearRectangleRiemannInterfaceFluxMethod_information A hA basis speeds heigen problem hτ)

/-- Time integration gives an actual physical-flux reference for this solver,
not merely constant-state consistency. The possibly different value at time
zero is excluded by the oriented integral's almost-everywhere convention. -/
theorem selectedLinearFlux_eq_solver_average (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA))
    {dt : ℝ} (hdt : 0 < dt) :
    selectedLinearFlux A hA basis speeds heigen problem =
      oneDimensionalCellAverage
        (fun τ => A.mulVec ((selectedLinearSolve A hA basis speeds heigen problem).solution 0 τ))
        0 dt := by
  have hint : (∫ τ in (0 : ℝ)..dt,
      A.mulVec ((selectedLinearSolve A hA basis speeds heigen problem).solution 0 τ)) =
      ∫ _ in (0 : ℝ)..dt, selectedLinearFlux A hA basis speeds heigen problem := by
    apply intervalIntegral.integral_congr_ae
    exact Filter.Eventually.of_forall (fun τ hτ =>
      (selectedLinearFlux_eq_physical_trace A hA basis speeds heigen problem
        (by simpa only [min_eq_left hdt.le] using hτ.1)).symm)
  rw [oneDimensionalCellAverage, hint, intervalIntegral.integral_const]
  simp [smul_smul, hdt.ne']

/-- A Riemann-based numerical rule on arbitrary numerical arrays. Time
endpoints are accepted by the update API; the self-similar linear ray flux
does not depend on the positive duration. -/
noncomputable def linearRule (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (_s _t : ℝ) (old : ℤ → (Fin m → ℝ)) (j : ℤ) : Fin m → ℝ :=
  selectedLinearFlux A hA basis speeds heigen
    (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j)

/-- The rule executes the existing canonical interface-flux function with the
selected total linear solver, rather than choosing an unrelated solution. -/
theorem linearRule_eq_rectangleRiemannInterfaceFlux (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (s t : ℝ) (old : ℤ → (Fin m → ℝ)) (j : ℤ) :
    linearRule A hA basis speeds heigen s t old j =
      rectangleRiemannInterfaceFlux
        (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen)
        old (fun _ => trivial) j := rfl

/-- A bound on the local solver's physical trace error against an independently
conserved field implies an averaged numerical-flux error bound. The trace
comparison is an explicit premise, not inferred from unrelated certificates. -/
theorem linearRule_flux_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q A.mulVec)
    (old : ℤ → (Fin m → ℝ)) {dt bound : ℝ} (hdt : 0 < dt) (j : ℤ)
    (htrace : ∀ τ ∈ Set.uIoc 0 dt,
      ‖A.mulVec ((selectedLinearSolve A hA basis speeds heigen
        (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j)).solution 0 τ) -
        A.mulVec (q (grid.cellLeft j) τ)‖ ≤ bound) :
    ‖linearRule A hA basis speeds heigen 0 dt old j -
      FVFluxUpdateDraft.physicalFaceAverage grid q A.mulVec 0 dt j‖ ≤ bound := by
  unfold linearRule FVFluxUpdateDraft.physicalFaceAverage
  rw [selectedLinearFlux_eq_solver_average A hA basis speeds heigen _ hdt]
  exact average_difference_norm_le hdt
    ((selectedLinearSolve A hA basis speeds heigen _).solves.2.2.1 _ _ _)
    (hq.2.1 _ _ _) htrace

/-- End-to-end conditional estimate: old numerical error and independently
justified solver-trace errors give a next-step error for the actual linear rule. -/
theorem linearRule_next_error_bound (grid : OneDimensionalFiniteVolumeGrid)
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q A.mulVec)
    (old : ℤ → (Fin m → ℝ)) {dt oldBound : ℝ} (hdt : 0 < dt) (i : ℤ)
    (faceBound : ℤ → ℝ)
    (hold : ‖old i - finiteVolumeCellAverageOn grid (fun x => q x 0) i‖ ≤ oldBound)
    (htrace : ∀ j τ, τ ∈ Set.uIoc 0 dt →
      ‖A.mulVec ((selectedLinearSolve A hA basis speeds heigen
        (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j)).solution 0 τ) -
        A.mulVec (q (grid.cellLeft j) τ)‖ ≤ faceBound j) :
    ‖FVFluxUpdateDraft.numericalUpdate grid (linearRule A hA basis speeds heigen) 0 dt old i -
      finiteVolumeCellAverageOn grid (fun x => q x dt) i‖ ≤
      oldBound + dt / grid.cellVolume i * (faceBound i + faceBound (i + 1)) := by
  simpa using numericalUpdate_error_bound grid hq (linearRule A hA basis speeds heigen)
    hdt old i hold
    (linearRule_flux_error_le grid A hA basis speeds heigen hq old hdt i (htrace i))
    (linearRule_flux_error_le grid A hA basis speeds heigen hq old hdt (i + 1) (htrace (i + 1)))

end NumStability.FVFluxEstimateDraft
