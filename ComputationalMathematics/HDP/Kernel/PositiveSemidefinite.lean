import ComputationalMathematics.HDP.Kernel.FeatureMap
import Mathlib.Analysis.InnerProductSpace.GramMatrix

/-!
# Positive-semidefinite kernels

A real kernel is positive semidefinite when every finite Gram matrix obtained
from it is positive semidefinite.
-/

noncomputable section

namespace NumStability.HDP.Kernel

/-- The finite Gram matrix of a kernel on a selected family of points. -/
def gramMatrix {X : Type*} (K : X → X → ℝ) {N : ℕ} (u : Fin N → X) :
    Matrix (Fin N) (Fin N) ℝ :=
  fun i j ↦ K (u i) (u j)

/-- A real kernel whose every finite Gram matrix is positive semidefinite. -/
def IsPositiveSemidefinite {X : Type*} (K : X → X → ℝ) : Prop :=
  ∀ (N : ℕ) (u : Fin N → X), (gramMatrix K u).PosSemidef

theorem isPositiveSemidefinite_iff {X : Type*} (K : X → X → ℝ) :
    IsPositiveSemidefinite K ↔
      ∀ (N : ℕ) (u : Fin N → X),
        Matrix.PosSemidef (fun i j ↦ K (u i) (u j)) :=
  Iff.rfl

/-- Every real inner-product feature representation produces a
positive-semidefinite kernel. -/
theorem IsRealFeatureMap.isPositiveSemidefinite {X H : Type*}
    [NormedAddCommGroup H] [InnerProductSpace ℝ H]
    {K : X → X → ℝ} {Φ : X → H} (hΦ : IsRealFeatureMap K Φ) :
    IsPositiveSemidefinite K := by
  intro N u
  have hgram : gramMatrix K u = Matrix.gram ℝ (fun i ↦ Φ (u i)) := by
    ext i j
    exact (hΦ (u i) (u j)).symm
  rw [hgram]
  exact Matrix.posSemidef_gram ℝ _

end NumStability.HDP.Kernel
