import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleBalanceTemporalDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.LinearProduction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Examples.LocalMaterialInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann

/-!
Prospective scratch capstones. These assemble existing canonical mathematics.
They do not select a source interpretation, assert a source verdict, or define
a solution theory for the first-order problem-data alternatives.
-/

open MeasureTheory Filter Set
open scoped Topology

namespace NumStability.ProspectiveSourceAlternatives

/- Ordinary signed production densities; the state may be spatially discontinuous.
The fixed-interval almost-everywhere statement does not assert a common null set
for all intervals. No singular production measure is represented. -/
theorem density_rectangle_capstone {m : ℕ}
    {q : ℝ → ℝ → Fin (m + 1) → ℝ}
    {flux : (Fin (m + 1) → ℝ) → Fin (m + 1) → ℝ}
    {production : ℝ → ℝ → Fin (m + 1) → ℝ}
    (h : IsRectangleBalanceLawSolution q flux production) :
    IsRectangleBalanceLawSolution q flux production ∧
    (∀ a b s t,
      (∫ τ in s..t, ∫ x in a..b, production x τ) =
        ((∫ x in a..b, q x t) - (∫ x in a..b, q x s)) -
          (∫ τ in s..t, flux (q a τ) - flux (q b τ))) ∧
    (IsRectangleConservationLawSolution q flux ↔
      ∀ a b s t, (∫ τ in s..t, ∫ x in a..b, production x τ) = 0) ∧
    (¬ IsRectangleConservationLawSolution q flux ↔
      ∃ a b s t, (∫ τ in s..t, ∫ x in a..b, production x τ) ≠ 0) ∧
    (∀ a b, ∀ᵐ t,
      HasDerivAt (fun s => ∫ x in a..b, q x s)
        (flux (q a t) - flux (q b t) + ∫ x in a..b, production x t) t) :=
  ⟨h, h.integrated_source_eq_mass_defect, h.conservation_iff_source_integrals_zero,
    h.not_conservation_iff_exists_nonzero_source_integral, h.hasDerivAt_mass_ae⟩

/-- Both production and depletion are admitted by the same arbitrary real rate. -/
theorem signed_density_fixture (rate : ℝ) :
    IsRectangleBalanceLawSolution
      (fun x t => (rate * t) * riemannData (0 : ℝ) 0 1 x) (fun _ => 0)
      (fun x _ => rate * riemannData (0 : ℝ) 0 1 x) ∧
    (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2,
      rate * riemannData (0 : ℝ) 0 1 x) = rate ∧
    (rate ≠ 0 → ¬ IsRectangleConservationLawSolution
      (fun x t => (rate * t) * riemannData (0 : ℝ) 0 1 x) (fun _ => 0)) := by
  have h : IsRectangleBalanceLawSolution
      (fun x t => (rate * t) * riemannData (0 : ℝ) 0 1 x) (fun _ => 0)
      (fun x _ => rate * riemannData (0 : ℝ) 0 1 x) := by
    simpa only [smul_eq_mul] using linearAmplitude_isRectangleBalanceLawSolution
      (riemannData (0 : ℝ) 0 1) (riemannData_intervalIntegrable 0 0 1) rate
  refine ⟨h, riemannStep_signed_source_integral rate, ?_⟩
  intro hrate
  exact h.not_conservation_iff_exists_nonzero_source_integral.mpr
    ⟨1, 2, 1, 2, by rwa [riemannStep_signed_source_integral]⟩

/-- The existing concrete positive fixture also records spatial nonsmoothness. -/
theorem nonsmooth_density_fixture :
    IsRectangleBalanceLawSolution (fun x t => t * riemannData (0 : ℝ) 0 1 x)
      (fun _ => 0) (fun x _ => riemannData (0 : ℝ) 0 1 x) ∧
    ¬ ContinuousAt (fun x => (1 : ℝ) * riemannData (0 : ℝ) 0 1 x) 0 ∧
    (∀ a b t, HasDerivAt (fun τ => ∫ x in a..b, τ * riemannData (0 : ℝ) 0 1 x)
      (∫ x in a..b, riemannData (0 : ℝ) 0 1 x) t) ∧
    (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, riemannData (0 : ℝ) 0 1 x) = 1 ∧
    ¬ IsRectangleConservationLawSolution
      (fun x t => t * riemannData (0 : ℝ) 0 1 x) (fun _ => 0) :=
  riemannStep_source_nonvacuity

/-- A candidate local-medium interpretation, with global initial-state data. -/
def LocalMediumAlternative {M Q : Type*} [TopologicalSpace M]
    (medium : ℝ → M) (initialState : ℝ → Q) (ml mr : M) (ql qr : Q) : Prop :=
  HasJumpAt medium 0 ml mr ∧ IsRiemannData initialState ql qr ∧ ql ≠ qr

/-- The separate stronger candidate also makes the medium constant on each strict half-line. -/
def GlobalMediumAlternative {M Q : Type*}
    (medium : ℝ → M) (initialState : ℝ → Q) (ml mr : M) (ql qr : Q) : Prop :=
  IsRiemannData medium ml mr ∧ ml ≠ mr ∧ IsRiemannData initialState ql qr ∧ ql ≠ qr

theorem local_medium_capstone {M Q : Type*}
    [TopologicalSpace M] [TopologicalSpace Q] [T2Space M] [T2Space Q]
    {medium : ℝ → M} {initialState : ℝ → Q} {ml mr : M} {ql qr : Q}
    (h : LocalMediumAlternative medium initialState ml mr ql qr) :
    (HasJumpAt medium 0 ml mr ∧ HasJumpAt initialState 0 ql qr) ∧
    IsRiemannData initialState ql qr ∧
    ¬ ContinuousAt medium 0 ∧ ¬ ContinuousAt initialState 0 ∧
    (∃ originState, initialState = riemannData ql originState qr) := by
  have hq := h.2.1.hasJumpAt h.2.2
  exact ⟨⟨h.1, hq⟩, h.2.1, h.1.not_continuousAt, hq.not_continuousAt,
    (isRiemannData_iff_exists_valueAtOrigin _ _ _).mp h.2.1⟩

theorem global_medium_capstone {M Q : Type*}
    [TopologicalSpace M] [TopologicalSpace Q]
    {medium : ℝ → M} {initialState : ℝ → Q} {ml mr : M} {ql qr : Q}
    (h : GlobalMediumAlternative medium initialState ml mr ql qr) :
    LocalMediumAlternative medium initialState ml mr ql qr ∧
    IsRiemannData (fun x => (medium x, initialState x)) (ml, ql) (mr, qr) ∧
    ml ≠ mr ∧ ql ≠ qr ∧
    (∃ originMaterial, medium = riemannData ml originMaterial mr) ∧
    (∃ originState, initialState = riemannData ql originState qr) :=
  ⟨⟨h.1.hasJumpAt h.2.1, h.2.2.1, h.2.2.2⟩,
    (isRiemannData_prod_iff _ _ _ _ _ _).mpr ⟨h.1, h.2.2.1⟩,
    h.2.1, h.2.2.2,
    (isRiemannData_iff_exists_valueAtOrigin _ _ _).mp h.1,
    (isRiemannData_iff_exists_valueAtOrigin _ _ _).mp h.2.2.1⟩

/-- Both medium and state values at zero remain independent parameters. -/
theorem global_medium_fixture (originMaterial originState : ℝ) :
    GlobalMediumAlternative (riemannData (0 : ℝ) originMaterial 1)
      (riemannData (2 : ℝ) originState 3) 0 1 2 3 ∧
    riemannData (0 : ℝ) originMaterial 1 0 = originMaterial ∧
    riemannData (2 : ℝ) originState 3 0 = originState := by
  exact ⟨⟨riemannData_isRiemannData _ _ _, zero_ne_one,
    riemannData_isRiemannData _ _ _, by norm_num⟩, by simp, by simp⟩

/-- The local alternative does not imply half-line material constancy. -/
theorem local_medium_separating_fixture (originMaterial originState : ℝ) :
    LocalMediumAlternative (LocalMaterialInterface.varyingMedium originMaterial)
      (riemannData (2 : ℝ) originState 3) 0 1 2 3 ∧
    (¬ ∃ ml mr, IsRiemannData (LocalMaterialInterface.varyingMedium originMaterial) ml mr) ∧
    LocalMaterialInterface.varyingMedium originMaterial 0 = originMaterial ∧
    riemannData (2 : ℝ) originState 3 0 = originState := by
  have h := LocalMaterialInterface.varyingMedium_interface_witness originMaterial originState
  exact ⟨⟨h.1.1, h.2.1, h.1.2.2.2⟩, h.2.2.2.2.1, h.2.2.2.2.2⟩

open FirstOrderInitialValueProblem

/-- Positive component dimension is structural. This is equation/data classification only. -/
theorem positive_dimensional_problem_capstone {m : ℕ}
    (problem : FirstOrderInitialValueProblem (Fin (m + 1))) :
    problem.IsRiemann ↔
      (∃ leftState rightState,
        problem.governing.IsHyperbolic ∧
        leftState ∈ problem.governing.admissibleStates ∧
        rightState ∈ problem.governing.admissibleStates ∧
        (∀ x, x < 0 → problem.initialState x = leftState) ∧
        (∀ x, 0 < x → problem.initialState x = rightState)) ∧
      (∀ x t state qt qx,
        problem.governing.residual x t state qt qx = 0 ↔
          qt + (problem.governing.principal x t state).mulVec qx =
            problem.governing.forcing x t state) :=
  problem.isRiemann_characterization

/-- Equal sides remain admissible in the broad family, while the jump subfamily is distinct. -/
theorem equal_or_distinct_initial_states {m : ℕ}
    (equation : FirstOrderEquation (Fin (m + 1))) (hhyper : equation.IsHyperbolic)
    (leftState origin rightState : Fin (m + 1) → ℝ)
    (hleft : leftState ∈ equation.admissibleStates)
    (hright : rightState ∈ equation.admissibleStates) :
    (fromStates equation leftState origin rightState).IsRiemannWithStates leftState rightState ∧
    (leftState = rightState →
      ¬ (fromStates equation leftState origin rightState).IsJumpRiemann) ∧
    (leftState ≠ rightState →
      (fromStates equation leftState origin rightState).IsJumpRiemann) := by
  refine ⟨fromStates_isRiemannWithStates equation hhyper _ _ _ hleft hright, ?_,
    fromStates_isJumpRiemann equation hhyper _ _ _ hleft hright⟩
  intro hequal
  subst rightState
  exact fromEqualStates_not_isJumpRiemann equation leftState origin

/-- Concrete scalar fixture: principal coefficient one, zero forcing, all states admissible. -/
def scalarEquation : FirstOrderEquation (Fin 1) :=
  FirstOrderEquation.constantLinear (1 : Matrix (Fin 1) (Fin 1) ℝ)

theorem scalarEquation_hyperbolic : scalarEquation.IsHyperbolic := by
  apply FirstOrderEquation.constantLinear_isHyperbolic
  refine ⟨fun _ => 1, Pi.basisFun ℝ (Fin 1), ?_⟩
  intro p
  simp only [Matrix.one_mulVec, one_smul]

theorem scalar_problem_fixture (origin : Fin 1 → ℝ) :
    (fromStates scalarEquation (fun _ => 0) origin (fun _ => 1)).IsJumpRiemann ∧
    (fromStates scalarEquation (fun _ => 0) origin (fun _ => 0)).IsRiemann ∧
    ¬ (fromStates scalarEquation (fun _ => 0) origin (fun _ => 0)).IsJumpRiemann ∧
    (∀ x t state qt qx,
      scalarEquation.residual x t state qt qx = 0 ↔ qt + qx = 0) := by
  refine ⟨fromStates_isJumpRiemann scalarEquation scalarEquation_hyperbolic
    _ _ _ (Set.mem_univ _) (Set.mem_univ _) ?_,
    fromEqualStates_isRiemann scalarEquation scalarEquation_hyperbolic _ _ (Set.mem_univ _),
    fromEqualStates_not_isJumpRiemann scalarEquation _ _, ?_⟩
  · intro heq
    have hc := congrFun heq (0 : Fin 1)
    norm_num at hc
  · intro x t state qt qx
    simpa [scalarEquation, FirstOrderEquation.constantLinear] using
      scalarEquation.residual_eq_zero_iff x t state qt qx

#check density_rectangle_capstone
#check signed_density_fixture
#check nonsmooth_density_fixture
#print LocalMediumAlternative
#print GlobalMediumAlternative
#check local_medium_capstone
#check global_medium_capstone
#check global_medium_fixture
#check local_medium_separating_fixture
#check positive_dimensional_problem_capstone
#check equal_or_distinct_initial_states
#print scalarEquation
#check scalarEquation_hyperbolic
#check scalar_problem_fixture

/- Definition bodies below are semantic contract inputs, never theorem proofs. -/
#print NumStability.IsRectangleBalanceLawSolution
#print NumStability.IsRectangleConservationLawSolution
#print NumStability.HasJumpAt
#print NumStability.IsRiemannData
#print NumStability.riemannData
#print NumStability.FirstOrderEquation
#print NumStability.FirstOrderEquation.residual
#print NumStability.FirstOrderEquation.IsHyperbolic
#print NumStability.IsRealHyperbolicMatrix
#print NumStability.FirstOrderInitialValueProblem
#print NumStability.FirstOrderInitialValueProblem.IsRiemannWithStates
#print NumStability.FirstOrderInitialValueProblem.IsRiemann
#print NumStability.FirstOrderInitialValueProblem.IsJumpRiemann
#print NumStability.FirstOrderInitialValueProblem.fromStates
set_option pp.all true in
#check (volume : Measure ℝ)

#print axioms density_rectangle_capstone
#print axioms signed_density_fixture
#print axioms nonsmooth_density_fixture
#print axioms local_medium_capstone
#print axioms global_medium_capstone
#print axioms global_medium_fixture
#print axioms local_medium_separating_fixture
#print axioms positive_dimensional_problem_capstone
#print axioms equal_or_distinct_initial_states
#print axioms scalarEquation_hyperbolic
#print axioms scalar_problem_fixture

end NumStability.ProspectiveSourceAlternatives


/-!
# A literal finite-vector instance of the prospective density capstone

The field and production take values in `Fin 1 → ℝ`, exactly the `m = 0`
instance of the frozen positive-dimensional target. A signed real rate permits
both production and depletion. This construction adopts no source convention.
-/

namespace NumStability.DensityCapstoneVectorWitness

def unitState : Fin 1 → ℝ := fun _ => 1

noncomputable def profile : ℝ → Fin 1 → ℝ := riemannData 0 0 unitState

noncomputable def state (rate : ℝ) (x t : ℝ) : Fin 1 → ℝ :=
  (rate * t) • profile x

noncomputable def production (rate : ℝ) (x _t : ℝ) : Fin 1 → ℝ :=
  rate • profile x

theorem profile_eq_scalar_smul (x : ℝ) :
    profile x = riemannData (0 : ℝ) 0 1 x • unitState := by
  unfold profile riemannData
  split_ifs <;> simp

/-- The existing generic producer proves all four integrability conditions and
the actual rectangle balance for these explicit finite-vector fields. -/
theorem balance (rate : ℝ) :
    IsRectangleBalanceLawSolution (state rate) (fun _ => 0) (production rate) :=
  linearAmplitude_isRectangleBalanceLawSolution profile
    (riemannData_intervalIntegrable 0 0 unitState) rate

/-- The ordinary source integral on `[1,2] × [1,2]` keeps the supplied sign. -/
theorem source_integral (rate : ℝ) :
    (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, production rate x _τ) =
      rate • unitState := by
  simp only [production, profile_eq_scalar_smul, smul_smul,
    intervalIntegral.integral_smul_const, riemannStep_signed_source_integral]

/-- This is the full frozen target at `m = 0`, with its actual premise supplied.
It retains both equivalences, all rectangles and the fixed-interval a.e. rate. -/
theorem capstone_instance (rate : ℝ) :
    IsRectangleBalanceLawSolution (state rate) (fun _ => 0) (production rate) ∧
    (∀ a b s t,
      (∫ τ in s..t, ∫ x in a..b, production rate x τ) =
        ((∫ x in a..b, state rate x t) - (∫ x in a..b, state rate x s)) -
          (∫ _τ in s..t, (0 : Fin 1 → ℝ) - 0)) ∧
    (IsRectangleConservationLawSolution (state rate) (fun _ => 0) ↔
      ∀ a b s t, (∫ τ in s..t, ∫ x in a..b, production rate x τ) = 0) ∧
    (¬ IsRectangleConservationLawSolution (state rate) (fun _ => 0) ↔
      ∃ a b s t, (∫ τ in s..t, ∫ x in a..b, production rate x τ) ≠ 0) ∧
    (∀ a b, ∀ᵐ t,
      HasDerivAt (fun s => ∫ x in a..b, state rate x s)
        ((0 : Fin 1 → ℝ) - 0 + ∫ x in a..b, production rate x t) t) :=
  ProspectiveSourceAlternatives.density_rectangle_capstone (m := 0) (balance rate)

/-- Nonconservation follows from the target's actual conclusion and the
computed nonzero source integral, not an assumed adequacy or existence claim. -/
theorem nonconservation (rate : ℝ) (hrate : rate ≠ 0) :
    ¬ IsRectangleConservationLawSolution (state rate) (fun _ => 0) := by
  apply (capstone_instance rate).2.2.2.1.mpr
  refine ⟨1, 2, 1, 2, ?_⟩
  rw [source_integral]
  intro heq
  apply hrate
  simpa [unitState] using congrFun heq (0 : Fin 1)

/-- Actual positive and negative instances have opposite unit-rectangle source
contributions, and each fails the homogeneous conservation predicate. -/
theorem positive_and_negative_instances :
    ¬ IsRectangleConservationLawSolution (state 1) (fun _ => 0) ∧
    ¬ IsRectangleConservationLawSolution (state (-1)) (fun _ => 0) ∧
    ((∫ τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, production 1 x τ) (0 : Fin 1)) = 1 ∧
    ((∫ τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, production (-1) x τ) (0 : Fin 1)) = -1 := by
  refine ⟨nonconservation 1 (by norm_num), nonconservation (-1) (by norm_num), ?_, ?_⟩ <;>
    simp [source_integral, unitState]

end NumStability.DensityCapstoneVectorWitness


#check NumStability.DensityCapstoneVectorWitness.unitState
#print axioms NumStability.DensityCapstoneVectorWitness.unitState
#check NumStability.DensityCapstoneVectorWitness.profile
#print axioms NumStability.DensityCapstoneVectorWitness.profile
#check NumStability.DensityCapstoneVectorWitness.state
#print axioms NumStability.DensityCapstoneVectorWitness.state
#check NumStability.DensityCapstoneVectorWitness.production
#print axioms NumStability.DensityCapstoneVectorWitness.production
#check NumStability.DensityCapstoneVectorWitness.profile_eq_scalar_smul
#print axioms NumStability.DensityCapstoneVectorWitness.profile_eq_scalar_smul
#check NumStability.DensityCapstoneVectorWitness.balance
#print axioms NumStability.DensityCapstoneVectorWitness.balance
#check NumStability.DensityCapstoneVectorWitness.source_integral
#print axioms NumStability.DensityCapstoneVectorWitness.source_integral
#check NumStability.DensityCapstoneVectorWitness.capstone_instance
#print axioms NumStability.DensityCapstoneVectorWitness.capstone_instance
#check NumStability.DensityCapstoneVectorWitness.nonconservation
#print axioms NumStability.DensityCapstoneVectorWitness.nonconservation
#check NumStability.DensityCapstoneVectorWitness.positive_and_negative_instances
#print axioms NumStability.DensityCapstoneVectorWitness.positive_and_negative_instances
#check NumStability.ProspectiveSourceAlternatives.density_rectangle_capstone
#print axioms NumStability.ProspectiveSourceAlternatives.density_rectangle_capstone
#check NumStability.linearAmplitude_isRectangleBalanceLawSolution
#print axioms NumStability.linearAmplitude_isRectangleBalanceLawSolution
#check NumStability.riemannData_intervalIntegrable
#print axioms NumStability.riemannData_intervalIntegrable
#check NumStability.riemannStep_signed_source_integral
#print axioms NumStability.riemannStep_signed_source_integral
#check intervalIntegral.integral_smul_const
#print axioms intervalIntegral.integral_smul_const
