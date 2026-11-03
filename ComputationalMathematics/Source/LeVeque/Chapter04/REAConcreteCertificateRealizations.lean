/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAGeneralPrescribedCertificate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.QuadraticTaylorRectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv

/-!
# Actual linear and quadratic realizations of prescribed REA certificates

The linear evolution permits arbitrary integer-indexed cell data. The quadratic
Taylor path supplies both legacy residual/reference certificates and its sharp
weak rectangle certificate for the same scalar advection equation.
-/

noncomputable section
namespace NumStability.REA.ConcreteRealization
open MeasureTheory

theorem uniformGrid_covers (origin width : ℝ) (hwidth : 0 < width) :
    Leveque04REAGridCoversLine (leveque04_uniformGrid origin width hwidth) := by
  intro x
  let j : ℤ := ⌈(x - origin) / width⌉
  have hj := Int.ceil_eq_iff.mp (show ⌈(x - origin) / width⌉ = j from rfl)
  refine ⟨j, ?_, ?_⟩
  · change origin + ((j - 1 : ℤ) : ℝ) * width ≤ x
    have h := (lt_div_iff₀ hwidth).mp hj.1
    push_cast
    linarith
  · change x ≤ origin + (j : ℝ) * width
    have h := (div_le_iff₀ hwidth).mp hj.2
    linarith

theorem uniformReconstruction {m : ℕ} (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → State m) :
    Leveque04REAReconstruction (leveque04_uniformGrid origin width hwidth) old
      (leveque04_uniformReconstruction origin width old) := by
  exact ⟨leveque04_uniformReconstruction_piecewisePolynomial origin width hwidth old,
    fun j => leveque04_uniformReconstruction_intervalIntegrable origin width hwidth old _ _,
    leveque04_uniformReconstruction_cellAverage origin width hwidth old⟩

theorem rectangleReference_of_global {m : ℕ} {q : Field m} {flux : State m → State m}
    (h : IsRectangleConservationLawSolution q flux) (a b T : ℝ) :
    LocalConservationLaw.RectangleReferenceOn q flux a b T := by
  exact ⟨fun t _ => h.1 a b t, fun x _ => h.2.1 x 0 T,
    fun x _ y _ s _ t _ => h.2.2 x y s t⟩

theorem uniformLinearIVP {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (old : ℤ → State m) (origin width : ℝ) (hwidth : 0 < width) (step : ℝ) :
    leveque04_linearREAForwardIVP coefficient
      (leveque04_uniformReconstruction origin width old) step
      (linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old)) := by
  refine ⟨linearCharacteristicEvolution_initial basis speeds _, ?_⟩
  intro left right
  apply rectangleReference_of_global
  apply linearCharacteristicEvolution_isRectangleSolution coefficient basis speeds heigen
  intro p a b
  exact leveque04_uniformReconstruction_intervalIntegrable
    origin width hwidth (fun j => basis.equivFun (old j) p) a b

theorem quadraticReconstruction (curvature linear constant : ℝ)
    (grid : OneDimensionalFiniteVolumeGrid) :
    Leveque04REAReconstruction grid
      (leveque04_quadraticREAOldMeans curvature linear constant grid)
      (leveque04_quadraticREAReconstruction curvature linear constant) := by
  refine ⟨?_, ?_, fun _ => rfl⟩
  · intro j component
    refine ⟨Polynomial.C curvature * Polynomial.X ^ 2 +
      Polynomial.C linear * Polynomial.X + Polynomial.C constant, ?_⟩
    intro x _hx
    simp [leveque04_quadraticREAReconstruction, AdvectionTaylor.quadraticProfile]
  · intro j
    apply (intervalIntegrable_pi_iff _ _ _).2
    intro component
    exact AdvectionTaylor.quadraticProfile_intervalIntegrable curvature linear constant _ _

theorem quadraticEndpoint_integrable (speed curvature linear constant step a b : ℝ) :
    IntervalIntegrable (leveque04_quadraticREAEndpoint speed curvature linear constant step)
      volume a b := by
  apply (intervalIntegrable_pi_iff _ _ _).2
  intro component
  exact AdvectionTaylor.quadraticTaylorPath_intervalIntegrable
    speed curvature linear constant step a b

theorem quadraticReference_initial (speed curvature linear constant x : ℝ) :
    leveque04_quadraticREAReference speed curvature linear constant x 0 =
      leveque04_quadraticREAReconstruction curvature linear constant x := by
  funext component
  change AdvectionTaylor.quadraticProfile curvature linear constant (x - speed * 0) =
    AdvectionTaylor.quadraticProfile curvature linear constant x
  rw [mul_zero, sub_zero]

theorem quadraticReference_IVP (speed curvature linear constant step : ℝ) :
    leveque04_scalarAdvectionForwardIVP speed
      (leveque04_quadraticREAReconstruction curvature linear constant) step
      (leveque04_quadraticREAReference speed curvature linear constant) := by
  refine ⟨quadraticReference_initial speed curvature linear constant, ?_⟩
  intro left right
  apply rectangleReference_of_global
  exact travelingWave_isRectangleConservationLawSolution
    (leveque04_quadraticREAReconstruction curvature linear constant)
    (fun a b => (intervalIntegrable_pi_iff _ a b).2
      (fun _ => AdvectionTaylor.quadraticProfile_intervalIntegrable curvature linear constant a b))
    speed

theorem quadraticResidualBudget_integrable (speed curvature a b : ℝ) :
    IntervalIntegrable (AdvectionTaylor.residualBudget speed curvature) volume a b := by
  apply Continuous.intervalIntegrable
  unfold AdvectionTaylor.residualBudget
  fun_prop

theorem quadraticLegacyResidual (speed curvature linear constant step : ℝ)
    (grid : OneDimensionalFiniteVolumeGrid) :
    Leveque04REAPrescribedCertificate
      (.scalarResidual speed (fun _ _ _ t => AdvectionTaylor.residualBudget speed curvature t))
      grid (leveque04_quadraticREAReconstruction curvature linear constant) step
      (leveque04_quadraticREAEndpoint speed curvature linear constant step) := by
  refine ⟨quadraticResidualBudget_integrable speed curvature 0 step,
    fun t ht => AdvectionTaylor.residualBudget_nonneg speed curvature t ht.1,
    AdvectionTaylor.quadraticTaylorPath speed curvature linear constant,
    (AdvectionTaylor.quadraticTaylorPath_contDiff speed curvature linear constant).contDiffOn,
    AdvectionTaylor.quadraticTaylorPath_initial speed curvature linear constant,
    fun _ => rfl, ?_⟩
  intro x t ht
  refine ⟨?_, ?_, (AdvectionTaylor.quadraticTaylorPath_abs_residual
    speed curvature linear constant x t ht.1).le⟩
  · rw [(AdvectionTaylor.quadraticTaylorPath_hasDerivAt_time
      speed curvature linear constant x t).deriv]
    exact AdvectionTaylor.quadraticTaylorPath_hasDerivAt_time speed curvature linear constant x t
  · rw [(AdvectionTaylor.quadraticTaylorPath_hasDerivAt_space
      speed curvature linear constant x t).deriv]
    exact AdvectionTaylor.quadraticTaylorPath_hasDerivAt_space speed curvature linear constant x t

theorem quadraticLegacyReference (speed curvature linear constant step : ℝ)
    (grid : OneDimensionalFiniteVolumeGrid) :
    Leveque04REAPrescribedCertificate
      (.reference (leveque04_scalarAdvectionForwardIVP speed)
        (fun _ _ time => AdvectionTaylor.endpointBudget speed curvature time))
      grid (leveque04_quadraticREAReconstruction curvature linear constant) step
      (leveque04_quadraticREAEndpoint speed curvature linear constant step) := by
  refine ⟨AdvectionTaylor.endpointBudget_nonneg speed curvature step,
    leveque04_quadraticREAReference speed curvature linear constant,
    quadraticReference_IVP speed curvature linear constant step,
    quadraticReference_initial speed curvature linear constant, ?_⟩
  intro x
  change ‖fun _ : Fin 1 => AdvectionTaylor.quadraticTaylorPath speed curvature linear constant x step -
    travelingWave (AdvectionTaylor.quadraticProfile curvature linear constant) speed x step‖ ≤ _
  rw [pi_norm_const, Real.norm_eq_abs,
    AdvectionTaylor.quadraticTaylorPath_abs_error speed curvature linear constant x step]

theorem quadraticExecute (speed curvature linear constant step : ℝ)
    (grid : OneDimensionalFiniteVolumeGrid) :
    (leveque04_scalarTaylorProcedure speed curvature).execute grid
      (leveque04_quadraticREAReconstruction curvature linear constant) step =
        some (leveque04_quadraticREAEndpoint speed curvature linear constant step) := by
  apply congrArg some
  funext x component
  change AdvectionTaylor.quadraticProfile curvature linear constant x - speed * step *
    deriv (AdvectionTaylor.quadraticProfile curvature linear constant) x = _
  rw [(AdvectionTaylor.quadraticProfile_hasDerivAt curvature linear constant x).deriv]
  rfl

theorem quadraticRectangleCertificate (speed curvature linear constant step : ℝ)
    (hstep : 0 < step) (grid : OneDimensionalFiniteVolumeGrid) :
    RectangleCertificate (fun state : State 1 => speed • state)
      (fun _ t => AdvectionTaylor.residualBudget speed curvature t)
      ⟨grid, leveque04_quadraticREAReconstruction curvature linear constant, step, hstep⟩
      (leveque04_quadraticREAEndpoint speed curvature linear constant step) := by
  let w : ConservativePath (fun state : State 1 => speed • state)
      ⟨grid, leveque04_quadraticREAReconstruction curvature linear constant, step, hstep⟩ :=
    { field := fun x t _ => AdvectionTaylor.quadraticTaylorPath speed curvature linear constant x t
      initial := fun x => by
        funext component
        exact AdvectionTaylor.quadraticTaylorPath_initial speed curvature linear constant x
      spatial_integrable := fun t _ a b =>
        quadraticEndpoint_integrable speed curvature linear constant t a b
      flux_integrable := fun x => by
        apply Continuous.intervalIntegrable
        change Continuous (fun t => speed •
          (fun _ : Fin 1 => AdvectionTaylor.quadraticTaylorPath speed curvature linear constant x t))
        unfold AdvectionTaylor.quadraticTaylorPath AdvectionTaylor.quadraticProfile
        fun_prop }
  refine ⟨quadraticResidualBudget_integrable speed curvature 0 step,
    fun t ht => AdvectionTaylor.residualBudget_nonneg speed curvature t ht.1,
    w, fun _ => rfl, ?_⟩
  intro r
  exact (AdvectionTaylor.quadraticTaylorPath_vector_rectangleDefect_norm 1
    speed curvature linear constant r.left r.right r.start r.stop
    r.space_pos.le r.start_nonneg r.time_pos.le).le

end NumStability.REA.ConcreteRealization
