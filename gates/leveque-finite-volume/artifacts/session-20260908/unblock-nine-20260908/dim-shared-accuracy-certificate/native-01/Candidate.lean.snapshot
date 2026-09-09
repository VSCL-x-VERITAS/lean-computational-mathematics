import Lean
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine

/-! Artifact-only all-level certificate. The estimates module supplies
extract_error_le; its old fixed-level accuracy theorem is never used. -/
namespace SharedAccuracyCertificateDraft
open NumStability NumStability.DirectionalLine NumStability.LocalConservationLaw
open NumStability.FiniteCoordinate
variable {m : ℕ}
local notation "State" => Fin m → ℝ

/-- One reference-specific certificate fixes C and N and retains the full
all-level proof. No realization or executed cell is part of its parameters. -/
structure Certificate (family : LineFamily m) (q : ℝ → ℝ → State) (p L : ℝ) where
  constant : ℝ
  constant_nonneg : 0 ≤ constant
  threshold : ℕ
  projection_admitted : ∀ n, threshold ≤ n → ∀ projected,
    family.InitialProjection n q projected → family.admitted n projected
  bound : ∀ n, threshold ≤ n → ∀ projected values,
    family.InitialProjection n q projected → family.admitted n values →
    ∀ E : ℝ, 0 ≤ E →
    (∀ j ∈ Finset.Ico (family.inputStart n) (family.inputStart n + family.inputCount n),
      ‖values j - projected j‖ ≤ E) →
    ∀ j ∈ Finset.Ico (family.activeStart n) (family.activeStart n + family.activeCount n),
      ‖family.advance n values j -
        finiteVolumeCellAverageOn (family.grid n) (fun x => q x (family.dt n)) j‖ ≤
          (1 + L * family.dt n) * E + constant * family.dt n * family.mesh n ^ p

/-- The rates precede the reference, and its certificate precedes every
arbitrary later realization/selected level. Thresholds are shared, not hidden. -/
theorem certificate_exists (family : LineFamily m)
    (quality : family.HasControlledHighResolution) :
    ∃ p L : ℝ, 1 < p ∧ 0 ≤ L ∧ ∀ q : ℝ → ℝ → State,
      SpatialSmoothReferenceOn q family.flux family.states family.left family.right family.horizon →
      Nonempty (Certificate family q p L) := by
  obtain ⟨p, L, hp, hL, accuracy⟩ :=
    LineFamily.HasControlledHighResolution.perturbed_accuracy family quality
  obtain ⟨_, _, order⟩ := quality.order
  refine ⟨p, L, hp, hL, ?_⟩
  intro q hq
  obtain ⟨C, hC, N, hbound⟩ := accuracy q hq
  obtain ⟨_, _, M, horder⟩ := order q hq
  refine ⟨⟨C, hC, max N M, ?_, ?_⟩⟩
  · intro n hn projected hproj
    exact (horder n ((le_max_right N M).trans hn) projected hproj).1
  · intro n hn projected values hproj hadmit E hE herr j hj
    exact hbound n ((le_max_left N M).trans hn) projected values hproj hadmit E hE herr j hj

/-- The exact projected input really exists and is admitted beyond the
same threshold; the all-level accuracy domain is not an empty conditional. -/
theorem Certificate.projected_input_exists {family : LineFamily m} {q : ℝ → ℝ → State}
    {p L : ℝ} (certificate : Certificate family q p L) (n : ℕ)
    (hn : certificate.threshold ≤ n) :
    ∃ projected : ℤ → State, family.InitialProjection n q projected ∧ family.admitted n projected := by
  let projected := fun j => finiteVolumeCellAverageOn (family.grid n) (fun x => q x 0) j
  have hproj : family.InitialProjection n q projected := fun _ _ => rfl
  exact ⟨projected, hproj, certificate.projection_admitted n hn projected hproj⟩

section Execution
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]

/-- Apply the same previously chosen certificate to any later compatible
realization. The actual selected level must exceed its existing threshold. -/
theorem Certificate.executed_bound {f : LineFamily m} {q : ℝ → ℝ → State} {p L : ℝ}
    (certificate : Certificate f q p L)
    {data : PhysicalData D Cell Face Point FacePoint m}
    {coord : LineCoordinates (m := m) D Cell Face Line} {family : D → Line → LineFamily m}
    (realization : LineRealization data coord family) (d : D) (cell : Cell)
    (hf : family d (coord.cellLine d cell) = f)
    (hn : certificate.threshold ≤ realization.level d (coord.cellLine d cell))
    (projected current : Cell → State)
    (hproj : f.InitialProjection (realization.level d (coord.cellLine d cell)) q
      (coord.extract d (coord.cellLine d cell) projected))
    (hadmit : realization.Admitted d current) {E : ℝ} (hE : 0 ≤ E)
    (herr : ∀ c, ‖current c - projected c‖ ≤ E) :
    ‖advance data realization.rule d (realization.duration d) current cell -
      finiteVolumeCellAverageOn (f.grid (realization.level d (coord.cellLine d cell)))
        (fun x => q x (realization.duration d)) (coord.cellIndex d cell)‖ ≤
      (1 + L * realization.duration d) * E + certificate.constant * realization.duration d *
        f.mesh (realization.level d (coord.cellLine d cell)) ^ p := by
  have hdt : realization.duration d = f.dt (realization.level d (coord.cellLine d cell)) := by
    rw [realization.duration_eq, hf]
  have hv : f.admitted (realization.level d (coord.cellLine d cell))
      (coord.extract d (coord.cellLine d cell) current) := by
    simpa only [hf] using hadmit cell
  have hj : coord.cellIndex d cell ∈
      Finset.Ico (f.activeStart (realization.level d (coord.cellLine d cell)))
        (f.activeStart (realization.level d (coord.cellLine d cell)) +
          f.activeCount (realization.level d (coord.cellLine d cell))) := by
    simpa only [hf] using realization.active_cell d cell
  rw [realization.advance_eq, hf, hdt]
  exact certificate.bound _ hn _ _ hproj hv E hE
    (fun j _ => coord.extract_error_le d (coord.cellLine d cell) current projected hE herr j) _ hj

end Execution

/-- Concrete scalar family witness for every genuine C-infinity local
reference, with all-level constants chosen before any later execution. -/
theorem scalar_cfl1_certificate :
    ∃ p L : ℝ, 1 < p ∧ 0 ≤ L ∧ ∀ q : ℝ → ℝ → Fin 1 → ℝ,
      SpatialSmoothReferenceOn q (HighResolutionAdvectionLine.family 1).flux
        (HighResolutionAdvectionLine.family 1).states (HighResolutionAdvectionLine.family 1).left
        (HighResolutionAdvectionLine.family 1).right (HighResolutionAdvectionLine.family 1).horizon →
      Nonempty (Certificate (HighResolutionAdvectionLine.family 1) q p L) :=
  certificate_exists _ (HighResolutionAdvectionLine.family_quality 1)

/-- A specific nonconstant smooth reference inhabits the certificate's
physical domain. This is not an arbitrary eligibility predicate. -/
theorem scalar_nonconstant_reference_certificate :
    ∃ p L : ℝ, 1 < p ∧ 0 ≤ L ∧
      Nonempty (Certificate (HighResolutionAdvectionLine.family 1)
        (fun x t => CFLUnitShift.smoothProfile (x - t)) p L) := by
  obtain ⟨p, L, hp, hL, certificates⟩ := scalar_cfl1_certificate
  exact ⟨p, L, hp, hL, certificates _ HighResolutionAdvectionLine.smooth_local_reference⟩

/-- This rfl guard fails under the original analytic (outer-top) semantics.
It verifies the exact inner-infinity regularity loaded by the native overlay. -/
theorem cinfty_definition (q : ℝ → ℝ → State) (flux : ℝ → State → State)
    (states : Set State) (a b T : ℝ) :
    SpatialSmoothReferenceOn q flux states a b T ↔
      ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry q)
        (Set.Icc a b ×ˢ Set.Icc 0 T) ∧ SpatialRectangleReferenceOn q flux a b T ∧
        ∀ x ∈ Set.Icc a b, ∀ t ∈ Set.Icc 0 T, q x t ∈ states := Iff.rfl

end SharedAccuracyCertificateDraft

set_option pp.fullNames true
set_option pp.deepTerms true
set_option pp.maxSteps 10000000

#check SharedAccuracyCertificateDraft.Certificate
#print axioms SharedAccuracyCertificateDraft.Certificate

#check SharedAccuracyCertificateDraft.certificate_exists
#print axioms SharedAccuracyCertificateDraft.certificate_exists

#check SharedAccuracyCertificateDraft.Certificate.projected_input_exists
#print axioms SharedAccuracyCertificateDraft.Certificate.projected_input_exists

#check SharedAccuracyCertificateDraft.Certificate.executed_bound
#print axioms SharedAccuracyCertificateDraft.Certificate.executed_bound

#check SharedAccuracyCertificateDraft.scalar_cfl1_certificate
#print axioms SharedAccuracyCertificateDraft.scalar_cfl1_certificate

#check SharedAccuracyCertificateDraft.scalar_nonconstant_reference_certificate
#print axioms SharedAccuracyCertificateDraft.scalar_nonconstant_reference_certificate

#check SharedAccuracyCertificateDraft.cinfty_definition
#print axioms SharedAccuracyCertificateDraft.cinfty_definition

open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let names := [
    `SharedAccuracyCertificateDraft.certificate_exists,
    `SharedAccuracyCertificateDraft.Certificate.executed_bound,
    `NumStability.DirectionalLine.LineFamily.HasControlledHighResolution.perturbed_accuracy,
    `NumStability.FiniteCoordinate.LineCoordinates.extract_error_le,
    `NumStability.FiniteCoordinate.LineRealization.advance_eq]
  let forbidden := `NumStability.FiniteCoordinate.LineRealization.smooth_accuracy
  for name in names do
    let some info := env.find? name | throwError "Missing inspected declaration {name}"
    let used := info.getUsedConstantsAsSet
    if used.contains forbidden then
      throwError "Forbidden old accuracy proof dependency in {name}"
    logInfo m!"NO_OLD_ACCURACY_DEPENDENCY {name}"
