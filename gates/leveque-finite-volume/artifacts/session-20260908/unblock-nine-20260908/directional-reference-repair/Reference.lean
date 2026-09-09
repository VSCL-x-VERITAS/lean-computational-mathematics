import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.PhysicalIntervalSweep

open MeasureTheory
namespace NumStability.DirectionalReferenceRepair
open DirectionalFiniteVolume

variable {D : Type*} [DecidableEq D] {m : ℕ}
variable {Point FacePoint : Type*} [MeasurableSpace Point] [TopologicalSpace Point]
  [MeasurableSpace FacePoint]

/-- Physical directional conservation on every subinterval of the actual time slab. -/
def PhysicalReferenceOn (data : PhysicalData D Point FacePoint m) (d : D)
    (q : Point → ℝ → Fin m → ℝ) (s t : ℝ) : Prop :=
  ∀ u ∈ Set.uIcc s t, ∀ v ∈ Set.uIcc s t, data.ReferenceOn d q u v

theorem PhysicalReferenceOn.endpoints {data : PhysicalData D Point FacePoint m} {d : D}
    {q : Point → ℝ → Fin m → ℝ} {s t : ℝ} (h : PhysicalReferenceOn data d q s t) :
    data.ReferenceOn d q s t := h s Set.left_mem_uIcc t Set.right_mem_uIcc

theorem PhysicalReferenceOn.restrict {data : PhysicalData D Point FacePoint m} {d : D}
    {q : Point → ℝ → Fin m → ℝ} {s t u v : ℝ} (h : PhysicalReferenceOn data d q s t)
    (hu : u ∈ Set.uIcc s t) (hv : v ∈ Set.uIcc s t) : PhysicalReferenceOn data d q u v := by
  intro a ha b hb
  exact h a (Set.uIcc_subset_uIcc hu hv ha) b (Set.uIcc_subset_uIcc hu hv hb)

/-- Every intermediate physical mass difference uses its actual boundary flux history. -/
theorem PhysicalReferenceOn.mass_balance {data : PhysicalData D Point FacePoint m} {d : D}
    {q : Point → ℝ → Fin m → ℝ} {s t u v : ℝ} (h : PhysicalReferenceOn data d q s t)
    (hu : u ∈ Set.uIcc s t) (hv : v ∈ Set.uIcc s t) (cell : D → ℤ) :
    data.cellVolume cell • (data.cellMean q cell v - data.cellMean q cell u) =
      ∫ τ in u..v, data.faceFlux d q cell τ -
        data.faceFlux d q (Function.update cell d (cell d + 1)) τ :=
  (h u hu v hv).2.2.2.2.2 cell

/-- The existing transported nonconstant step is a reference throughout every finite slab. -/
theorem physical_interval_reference (q : ℝ → ℝ → Fin 1 → ℝ)
    (hq : IsRectangleConservationLawSolution q id) (d : Fin 1) (s t : ℝ) :
    PhysicalReferenceOn PhysicalIntervalSweep.data d q s t := by
  intro u _ v _
  exact PhysicalIntervalSweep.reference_on q hq d u v

theorem nonconstant_reference (d : Fin 1) (s t : ℝ) :
    PhysicalReferenceOn PhysicalIntervalSweep.data d PhysicalIntervalSweep.reference s t ∧
    PhysicalIntervalSweep.reference (-1) 0 = 0 ∧ PhysicalIntervalSweep.reference 1 0 = 1 := by
  refine ⟨physical_interval_reference _ PhysicalIntervalSweep.reference_conserved d s t, ?_⟩
  exact PhysicalIntervalSweep.nonconstant_execution.2.2.2

end NumStability.DirectionalReferenceRepair

#check NumStability.DirectionalReferenceRepair.PhysicalReferenceOn
#print axioms NumStability.DirectionalReferenceRepair.PhysicalReferenceOn
#check NumStability.DirectionalReferenceRepair.PhysicalReferenceOn.endpoints
#print axioms NumStability.DirectionalReferenceRepair.PhysicalReferenceOn.endpoints
#check NumStability.DirectionalReferenceRepair.PhysicalReferenceOn.restrict
#print axioms NumStability.DirectionalReferenceRepair.PhysicalReferenceOn.restrict
#check NumStability.DirectionalReferenceRepair.PhysicalReferenceOn.mass_balance
#print axioms NumStability.DirectionalReferenceRepair.PhysicalReferenceOn.mass_balance
#check NumStability.DirectionalReferenceRepair.physical_interval_reference
#print axioms NumStability.DirectionalReferenceRepair.physical_interval_reference
#check NumStability.DirectionalReferenceRepair.nonconstant_reference
#print axioms NumStability.DirectionalReferenceRepair.nonconstant_reference
