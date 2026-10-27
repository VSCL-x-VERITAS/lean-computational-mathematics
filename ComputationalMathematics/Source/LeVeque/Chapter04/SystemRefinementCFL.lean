/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearSystemRefinementCFL
import ComputationalMathematics.Source.LeVeque.Chapter04.StencilDomains

/-!
# LeVeque Chapter 4: system and five-point refinement CFL necessity

The source invokes the constant-coefficient characteristic feet of (3.14).
A real eigenbasis binds that physical system to the exact Cauchy evolution.
Actual numerical updates may couple all components and vary with time and
refinement. Local initialization includes complete cells, and convergence
at one fixed physical observation for all continuous fields implies the
necessary radius-one or radius-two Courant bound. No stability sufficiency
is asserted. Existing geometric source interfaces remain unchanged.
-/

open Set Filter
open scoped Topology
namespace NumStability

/-- Physical constant-coefficient hyperbolic systems use a real eigenbasis
of the actual coefficient matrix, and the existing exact characteristic
Cauchy evolution. Numerical updates may couple all state components. -/
def Leveque04CenteredLinearSystemRefinementCFLTarget (radius : ℕ) : Prop :=
  ∀ (m : ℕ) [NeZero m] (A : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ),
    (∀ p, A.mulVec (basis p) = speeds p • basis p) →
    ∀ (update : ℕ → ℕ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ)
      (initialData : ℕ → (ℝ → Fin m → ℝ) → ℤ → Fin m → ℝ) (X T ratio : ℝ),
      0 < T → 0 < ratio → IsVectorCenteredStencilUpdateFamily radius update →
      IsVectorLocalRefinementInitialization initialData X T ratio →
      IsLinearSystemRefinementConvergent basis speeds update initialData X T →
      ratio * leveque04_maxCharacteristicSpeed speeds ≤ radius

def Leveque04SystemThreePointRefinementCFLTarget : Prop :=
  Leveque04CenteredLinearSystemRefinementCFLTarget 1

def Leveque04FivePointRefinementCFLTarget : Prop :=
  (∀ (update : ℕ → ℕ → (ℤ → ℝ) → ℤ → ℝ)
    (initialData : ℕ → (ℝ → ℝ) → ℤ → ℝ) (speed X T ratio : ℝ),
    0 < T → 0 < ratio → IsCenteredStencilUpdateFamily 2 update →
    IsLocalRefinementInitialization initialData X T ratio →
    IsAdvectionRefinementConvergent update initialData speed X T → |speed| * ratio ≤ 2) ∧
  Leveque04CenteredLinearSystemRefinementCFLTarget 2


theorem leveque04_centeredSystemRefinementCFL (radius : ℕ) :
    Leveque04CenteredLinearSystemRefinementCFLTarget radius := by
  intro m _ _A basis speeds _heigen update initialData X T ratio hT hratio hlocal hinitial hconverges
  have hEach := linearSystemRefinement_eachCourant_le basis speeds
    update initialData radius X T ratio hT hratio hlocal hinitial hconverges
  have hcone : ∀ p, X-speeds p*ratio ∈ leveque04_centeredStencilCone X 1 radius 1 := by
    intro p
    rw [leveque04_backtrace_mem_cone_iff]
    simpa only [abs_mul,abs_of_pos hratio,mul_one] using hEach p
  have hsys := (leveque04_systemCenteredStencilCFL X ratio 1 radius speeds
    hratio (by norm_num)).mp hcone
  simpa only [leveque04_systemCourantNumber,div_one] using hsys

theorem leveque04_systemThreePointRefinementCFL :
    Leveque04SystemThreePointRefinementCFLTarget :=
  leveque04_centeredSystemRefinementCFL 1

theorem leveque04_fivePointRefinementCFL :
    Leveque04FivePointRefinementCFLTarget := by
  constructor
  · intro update initialData speed X T ratio hT hratio hlocal hinitial hconverges
    simpa using advectionRefinement_courant_le_of_localInitialization
      update initialData 2 speed X T ratio hT hratio hlocal hinitial hconverges
  · exact leveque04_centeredSystemRefinementCFL 2

end NumStability
