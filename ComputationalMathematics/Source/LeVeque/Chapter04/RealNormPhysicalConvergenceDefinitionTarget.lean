/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RealNormPhysicalMeshConvergence
import Mathlib.Analysis.Normed.Module.FiniteDimension

/-!
# Convergence qualifications on actual refining physical meshes

The original definition does not assert that all methods converge. Each problem,
datum class, reference solution concept, norm, physical mesh path and observation
setting is fixed before qualification. Different qualifications are not asserted
equivalent. The geometry, physical counting weights and reconstruction indices
are actual mathematical data and certificates, not prose-only associations.
-/

noncomputable section

namespace NumStability

open Filter MeasureTheory Set
open scoped Topology ENNReal

/-- The approved Chapter 4 physical-mesh convergence specification with real norms. -/
def leveque04_RealNormPhysicalConvergenceDefinitionTarget : Prop :=
  (∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
      [FiniteDimensional ℝ E] [CompleteSpace E],
    (∀ (A : Type) (origin dx : A → ℝ) (_h : ∀ a, 0 < dx a),
      IsPhysicalCellMesh univ (fun _ => univ) (uniformPhysicalEdge origin dx) dx) ∧
    (∀ (A : Type) (dt : A → ℝ) (_h : ∀ a, 0 < dt a),
      IsPhysicalTimeMesh (uniformPhysicalTime dt) dt) ∧
    (∀ (A : Type) (time : A → ℕ → ℝ) (dt : A → ℝ)
        (steps : A → ℕ) (T : ℝ) (_ht : IsPhysicalTimeMesh time dt)
        (_hc : HasPhysicalHorizon time steps T),
      HasPhysicalObservationTime time steps T) ∧
    (∀ (A : Type) (l : Filter A) (time : A → ℕ → ℝ) (dt : A → ℝ)
        (steps : A → ℕ) (T : ℝ) (_ht : IsPhysicalTimeMesh time dt)
        (_hc : HasPhysicalObservationTime time steps T) (_hr : Tendsto dt l (𝓝 0)),
      Tendsto (fun a => time a (steps a)) l (𝓝 T)) ∧
    (∀ (A : Type) (origin dx dt : A → ℝ)
        (_h : ∀ a, 0 < dx a ∧ 0 < dt a),
      HasPhysicalReconstructionIndices univ (fun _ => univ)
        (uniformPhysicalEdge origin dx) (uniformPhysicalTime dt)
        (uniformPhysicalSpaceCell origin dx) (uniformPhysicalTimeCell dt)) ∧
    (∀ (A : Type) (l : Filter A) (domain : Set ℝ) (active : A → Set ℤ)
        (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
        (_hr : IsSpaceTimeRefinement l dx dt)
        (_hm : IsPhysicalCellMesh domain active edge dx)
        (index : A → ℤ) (_hi : ∀ a, index a ∈ active a),
      Tendsto (fun a => edge a (index a + 1) - edge a (index a)) l (𝓝 0)) ∧
    (∀ (A : Type) (l : Filter A) (domain : Set ℝ) (active : A → Set ℤ)
        (edge : A → ℤ → ℝ) (time : A → ℕ → ℝ) (dx dt : A → ℝ)
        (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ)
        (_hr : IsSpaceTimeRefinement l dx dt)
        (_hm : IsPhysicalCellMesh domain active edge dx)
        (_ht : IsPhysicalTimeMesh time dt)
        (_hl : HasPhysicalReconstructionIndices domain active edge time spaceCell timeCell)
        (x t : ℝ) (_hx : x ∈ domain) (_ht0 : 0 ≤ t),
      Tendsto (fun a => (physicalCellCenter edge a (spaceCell a x),
        time a (timeCell a t))) l (𝓝 (x, t))) ∧
    (∀ (A : Type) (domain : Set ℝ) (active : A → Set ℤ)
        (edge : A → ℤ → ℝ) (dx : A → ℝ)
        (_hm : IsPhysicalCellMesh domain active edge dx) (a : A) (i : ℤ)
        (_hi : i ∈ active a),
      physicalCellGridMeasure active edge a {i} =
        ENNReal.ofReal (edge a (i + 1) - edge a i) ∧
        0 < physicalCellGridMeasure active edge a {i}) ∧
    (∀ (A : Type) (origin dx : A → ℝ) (_h : ∀ a, 0 < dx a) (a : A),
      physicalCellGridMeasure (fun _ => univ) (uniformPhysicalEdge origin dx) a =
        ENNReal.ofReal (dx a) • Measure.count) ∧
    (∀ (A : Type) (active : A → Set ℤ) (edge : A → ℤ → ℝ) (a : A)
        (p : ℝ≥0∞) (_hp0 : p ≠ 0) (_hpinf : p ≠ ∞) (Q reference : ℤ → E),
      gridErrorENorm p (physicalCellGridMeasure active edge a) Q reference =
        (∑' i : ℤ, physicalCellWeight active edge a i *
          ‖Q i - reference i‖ₑ ^ p.toReal) ^ (1 / p.toReal)) ∧
    (∀ (A : Type) (origin dx : A → ℝ) (_h : ∀ a, 0 < dx a) (a : A)
        (p : ℝ≥0∞) (_hp0 : p ≠ 0) (_hpinf : p ≠ ∞) (Q reference : ℤ → E),
      gridErrorENorm p
          (physicalCellGridMeasure (fun _ => univ) (uniformPhysicalEdge origin dx) a)
          Q reference =
        (ENNReal.ofReal (dx a) * ∑' i : ℤ, ‖Q i - reference i‖ₑ ^ p.toReal) ^
          (1 / p.toReal)) ∧
    (∀ (A : Type) (domain : Set ℝ) (active : A → Set ℤ)
        (edge : A → ℤ → ℝ) (dx : A → ℝ)
        (_hm : IsPhysicalCellMesh domain active edge dx) (a : A) (Q reference : ℤ → E),
      gridErrorENorm ∞ (physicalCellGridMeasure active edge a) Q reference =
        ⨆ i : active a, ‖Q i - reference i‖ₑ) ∧
    (∀ (A : Type) (l : Filter A) (domain : Set ℝ) (active : A → Set ℤ)
        (edge : A → ℤ → ℝ) (dx dt : A → ℝ) (time : A → ℕ → ℝ)
        (steps : A → ℕ) (Q : A → ℕ → ℤ → E) (reference : A → ℤ → E)
        (X : A → Type) [∀ a, NormedAddCommGroup (X a)]
        [∀ a, NormedSpace ℝ (X a)]
        (representation : ∀ a, X a →ₗ[ℝ] (ℤ → E)) (T : ℝ),
      HasPhysicalRealNormConvergence l domain active edge dx dt time steps Q
          reference X representation T ↔
        IsSpaceTimeRefinement l dx dt ∧ IsPhysicalCellMesh domain active edge dx ∧
        IsPhysicalTimeMesh time dt ∧ HasPhysicalObservationTime time steps T ∧
        (∀ a, Function.Injective (representation a)) ∧
        ∃ error : ∀ a, X a,
          (∀ a i, representation a (error a) i =
            activePhysicalGridFunction active (numericalAtHorizon Q steps) a i -
              activePhysicalGridFunction active reference a i) ∧
          ∀ ε : ℝ, 0 < ε → ∀ᶠ a in l, ‖error a‖ < ε) ∧
    (∀ (A : Type) (l : Filter A) (p : ℝ≥0∞) (domain : Set ℝ)
        (active : A → Set ℤ) (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
        (time : A → ℕ → ℝ) (steps : A → ℕ) (Q : A → ℕ → ℤ → E)
        (q : ℝ → ℝ → E) (T : ℝ),
      HasPhysicalPointConvergence l p domain active edge dx dt time steps Q q T ↔
        1 ≤ p ∧ IsSpaceTimeRefinement l dx dt ∧ IsPhysicalCellMesh domain active edge dx ∧
        IsPhysicalTimeMesh time dt ∧ HasPhysicalObservationTime time steps T ∧
        (∀ a, AEStronglyMeasurable (fun i => Q a (steps a) i -
          q (physicalCellCenter edge a i) T) (physicalCellGridMeasure active edge a)) ∧
        ∀ ε : ℝ≥0∞, 0 < ε → ∀ᶠ a in l,
          eLpNorm (fun i => Q a (steps a) i - q (physicalCellCenter edge a i) T)
            p (physicalCellGridMeasure active edge a) < ε) ∧
    (∀ (A : Type) (l : Filter A) (p : ℝ≥0∞) (domain : Set ℝ)
        (active : A → Set ℤ) (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
        (time : A → ℕ → ℝ) (steps : A → ℕ) (Q : A → ℕ → ℤ → E)
        (q : ℝ → ℝ → E) (T : ℝ),
      HasPhysicalCellMeanConvergence l p domain active edge dx dt time steps Q q T ↔
        1 ≤ p ∧ IsSpaceTimeRefinement l dx dt ∧ IsPhysicalCellMesh domain active edge dx ∧
        IsPhysicalTimeMesh time dt ∧ HasPhysicalObservationTime time steps T ∧
        (∀ a i, i ∈ active a →
          IntervalIntegrable (fun x => q x T) volume (edge a i) (edge a (i + 1))) ∧
        (∀ a, AEStronglyMeasurable (fun i => Q a (steps a) i -
          (edge a (i + 1) - edge a i)⁻¹ • ∫ x in edge a i..edge a (i + 1), q x T)
          (physicalCellGridMeasure active edge a)) ∧
        ∀ ε : ℝ≥0∞, 0 < ε → ∀ᶠ a in l,
          eLpNorm (fun i => Q a (steps a) i - (edge a (i + 1) - edge a i)⁻¹ •
            ∫ x in edge a i..edge a (i + 1), q x T)
            p (physicalCellGridMeasure active edge a) < ε) ∧
    (∀ (A : Type) (l : Filter A) (domain : Set ℝ) (active : A → Set ℤ)
        (edge : A → ℤ → ℝ) (dx dt : A → ℝ) (time : A → ℕ → ℝ)
        (Q : A → ℕ → ℤ → E) (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ)
        (q : ℝ → ℝ → E) (T : ℝ),
      HasPhysicalSpaceTimeConvergence l domain active edge dx dt time Q spaceCell timeCell q T ↔
        IsSpaceTimeRefinement l dx dt ∧ IsPhysicalCellMesh domain active edge dx ∧
        IsPhysicalTimeMesh time dt ∧
        HasPhysicalReconstructionIndices domain active edge time spaceCell timeCell ∧
        0 < T ∧
        (∀ a, MeasurableSpaceTimeError domain T
          (fun x t => Q a (timeCell a t) (spaceCell a x)) q) ∧
        ∀ ε : ℝ≥0∞, 0 < ε → ∀ᶠ a in l,
          (∫⁻ t in Icc 0 T, ∫⁻ x in domain,
            ‖Q a (timeCell a t) (spaceCell a x) - q x t‖ₑ) < ε) ∧
    (∀ (A : Type) (l : Filter A) (domain : Set ℝ) (active : A → Set ℤ)
        (edge : A → ℤ → ℝ) (dx dt : A → ℝ) (time : A → ℕ → ℝ)
        (Q : A → ℕ → ℤ → E) (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ)
        (q : ℝ → ℝ → E),
      HasPhysicalLocalSpaceTimeConvergence l domain active edge dx dt time Q spaceCell timeCell q ↔
        IsSpaceTimeRefinement l dx dt ∧ IsPhysicalCellMesh domain active edge dx ∧
        IsPhysicalTimeMesh time dt ∧
        HasPhysicalReconstructionIndices domain active edge time spaceCell timeCell ∧
        ∀ a b T : ℝ, a ≤ b → 0 < T →
          (∀ j, MeasurableSpaceTimeError (domain ∩ Icc a b) T
            (fun x t => Q j (timeCell j t) (spaceCell j x)) q) ∧
          ∀ ε : ℝ≥0∞, 0 < ε → ∀ᶠ j in l,
            (∫⁻ t in Icc 0 T, ∫⁻ x in domain ∩ Icc a b,
              ‖Q j (timeCell j t) (spaceCell j x) - q x t‖ₑ) < ε) ∧
    (∀ (A : Type) (l : Filter A) (domain : Set ℝ) (active : A → Set ℤ)
        (edge : A → ℤ → ℝ) (dx dt : A → ℝ) (time : A → ℕ → ℝ)
        (Q : A → ℕ → ℤ → E) (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ)
        (W : Set (ℝ → ℝ → E)) (T : ℝ),
      HasPhysicalSolutionSetConvergence l domain active edge dx dt time Q spaceCell timeCell W T ↔
        IsSpaceTimeRefinement l dx dt ∧ IsPhysicalCellMesh domain active edge dx ∧
        IsPhysicalTimeMesh time dt ∧
        HasPhysicalReconstructionIndices domain active edge time spaceCell timeCell ∧
        0 < T ∧
        (∀ a q, q ∈ W → MeasurableSpaceTimeError domain T
          (fun x t => Q a (timeCell a t) (spaceCell a x)) q) ∧
        ∀ ε : ℝ≥0∞, 0 < ε → ∀ᶠ a in l,
          ∃ q ∈ W, (∫⁻ t in Icc 0 T, ∫⁻ x in domain,
            ‖Q a (timeCell a t) (spaceCell a x) - q x t‖ₑ) < ε) ∧
    (∀ (A : Type) (l : Filter A) (domain : Set ℝ) (active : A → Set ℤ)
        (edge : A → ℤ → ℝ) (dx dt : A → ℝ) (time : A → ℕ → ℝ)
        (Q : A → ℕ → ℤ → E) (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ)
        (q : ℝ → ℝ → E) (T : ℝ),
      HasPhysicalSolutionSetConvergence l domain active edge dx dt time Q spaceCell timeCell {q} T ↔
        HasPhysicalSpaceTimeConvergence l domain active edge dx dt time Q spaceCell timeCell q T) ∧
    (∀ (A : Type) (l : Filter A) (domain : Set ℝ) (active : A → Set ℤ)
        (edge : A → ℤ → ℝ) (dx dt : A → ℝ) (time : A → ℕ → ℝ)
        (Q : A → ℕ → ℤ → E) (spaceCell : A → ℝ → ℤ) (timeCell : A → ℝ → ℕ) (T : ℝ),
      ¬ HasPhysicalSolutionSetConvergence l domain active edge dx dt time Q spaceCell timeCell ∅ T) ∧
    (∀ (D A : Type) (dataClass : Set D) (solutions : D → Set (ℝ → ℝ → E))
        (selected : D → ℝ → ℝ → E) (l : Filter A) (p : ℝ≥0∞) (domain : Set ℝ)
        (active : D → A → Set ℤ) (edge : D → A → ℤ → ℝ)
        (dx dt : D → A → ℝ) (time : D → A → ℕ → ℝ) (steps : D → A → ℕ)
        (Q : D → A → ℕ → ℤ → E) (initial : D → A → ℤ → E) (T : ℝ),
      HasPhysicalDataClassConvergence dataClass solutions selected l p domain active edge
          dx dt time steps Q initial T ↔
        ∀ d ∈ dataClass, (∀ a i, i ∈ active d a → Q d a 0 i = initial d a i) ∧
          selected d ∈ solutions d ∧
          HasPhysicalPointConvergence l p domain (active d) (edge d) (dx d) (dt d)
            (time d) (steps d) (Q d) (selected d) T) ∧
    (∀ (A : Type) (l : Filter A) (p : ℝ≥0∞) (domain : Set ℝ)
        (active : A → Set ℤ) (edge : A → ℤ → ℝ) (dx dt : A → ℝ)
        (time : A → ℕ → ℝ) (steps : A → ℕ) (q : ℝ → ℝ → E) (T : ℝ)
        (_hp : 1 ≤ p) (_hr : IsSpaceTimeRefinement l dx dt)
        (_hm : IsPhysicalCellMesh domain active edge dx)
        (_ht : IsPhysicalTimeMesh time dt) (_hc : HasPhysicalHorizon time steps T),
      HasPhysicalPointConvergence l p domain active edge dx dt time steps
        (fun a n i => q (physicalCellCenter edge a i) (time a n)) q T)) ∧
  (∀ (A : Type) (l : Filter A) (domain : Set ℝ) (active : A → Set ℤ)
      (edge : A → ℤ → ℝ) (dx dt : A → ℝ) (time : A → ℕ → ℝ)
      (steps : A → ℕ) (T : ℝ),
    ¬ HasPhysicalPointConvergence l ∞ domain active edge dx dt time steps
      (fun _ _ _ => (1 : ℝ)) (fun _ _ => (0 : ℝ)) T)

end NumStability
