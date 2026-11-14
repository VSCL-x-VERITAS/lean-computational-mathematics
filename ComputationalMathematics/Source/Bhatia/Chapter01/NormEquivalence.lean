/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.NormEquivalenceTarget
import Mathlib.Algebra.Module.ULift
import Mathlib.Analysis.Normed.Module.FiniteDimension

/-! # Equivalence of finite-dimensional complex norms

Source correspondence for Bhatia, *Matrix Analysis* (1997), Section I.2,
printed page 7. The two norms are realized on separate copies of the same
vector space. Continuity of the identity maps gives both comparison bounds.
-/

universe u

namespace NumStability.Bhatia.Chapter01

/-- Any two genuine norms on a finite-dimensional complex vector space admit
positive, uniform two-sided comparison constants, including in dimension zero. -/
theorem normEquivalence : Targets.normEquivalence.{u} := by
  classical
  intro V _ _ _ N₁ N₂ h₁ h₂
  letI : Norm (ULift.{0} V) := ⟨fun x => N₂ x.down⟩
  let core₂ : NormedSpace.Core ℂ (ULift.{0} V) :=
    { norm_nonneg := fun x => apply_nonneg N₂ x.down
      norm_smul := fun a x => map_smul_eq_mul N₂ a x.down
      norm_triangle := fun x y => map_add_le_add N₂ x.down y.down
      norm_eq_zero_iff := fun x => by
        change N₂ x.down = 0 ↔ x = 0
        constructor
        · intro hx
          apply ULift.ext
          exact (h₂ x.down).mp hx
        · intro hx
          exact (h₂ x.down).mpr (congrArg ULift.down hx) }
  letI : NormedAddCommGroup (ULift.{0} V) := NormedAddCommGroup.ofCore core₂
  letI : SeminormedAddCommGroup (ULift.{0} V) :=
    (NormedAddCommGroup.ofCore core₂).toSeminormedAddCommGroup
  letI : MetricSpace (ULift.{0} V) :=
    (NormedAddCommGroup.ofCore core₂).toMetricSpace
  letI : PseudoMetricSpace (ULift.{0} V) :=
    (NormedAddCommGroup.ofCore core₂).toMetricSpace.toPseudoMetricSpace
  letI : UniformSpace (ULift.{0} V) :=
    (NormedAddCommGroup.ofCore core₂).toMetricSpace.toUniformSpace
  letI : TopologicalSpace (ULift.{0} V) :=
    (NormedAddCommGroup.ofCore core₂).toMetricSpace.toUniformSpace.toTopologicalSpace
  letI : NormedSpace ℂ (ULift.{0} V) := NormedSpace.ofCore core₂
  letI : Norm V := ⟨N₁⟩
  let core₁ : NormedSpace.Core ℂ V :=
    { norm_nonneg := fun x => apply_nonneg N₁ x
      norm_smul := fun a x => map_smul_eq_mul N₁ a x
      norm_triangle := fun x y => map_add_le_add N₁ x y
      norm_eq_zero_iff := h₁ }
  letI : NormedAddCommGroup V := NormedAddCommGroup.ofCore core₁
  letI : NormedSpace ℂ V := NormedSpace.ofCore core₁
  let e : ULift.{0} V ≃ₗ[ℂ] V := ULift.moduleEquiv
  letI : FiniteDimensional ℂ (ULift.{0} V) := e.symm.finiteDimensional
  let f : V →ₗ[ℂ] ULift.{0} V := e.symm.toLinearMap
  let g : ULift.{0} V →ₗ[ℂ] V := e.toLinearMap
  obtain ⟨C, hC, hf⟩ := SemilinearMapClass.bound_of_continuous f
    f.continuous_of_finiteDimensional
  obtain ⟨D, hD, hg⟩ := SemilinearMapClass.bound_of_continuous g
    g.continuous_of_finiteDimensional
  refine ⟨D⁻¹, C, inv_pos.mpr hD, hC, ?_⟩
  intro x
  have upper := hf x
  change N₂ x ≤ C * N₁ x at upper
  have reverse := hg (ULift.up x)
  change N₁ x ≤ D * N₂ x at reverse
  refine ⟨?_, upper⟩
  calc
    D⁻¹ * N₁ x ≤ D⁻¹ * (D * N₂ x) :=
      mul_le_mul_of_nonneg_left reverse (inv_nonneg.mpr hD.le)
    _ = N₂ x := by rw [← mul_assoc, inv_mul_cancel₀ (ne_of_gt hD), one_mul]

end NumStability.Bhatia.Chapter01
