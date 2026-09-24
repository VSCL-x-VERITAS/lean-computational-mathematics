import Mathlib.Analysis.InnerProductSpace.Basic

/-!
# Real feature maps

A real-valued kernel is represented by a feature map when its values are the
pairwise inner products of the feature vectors.  Completeness of the ambient
space can be imposed by callers when a Hilbert-space realization is required.
-/

noncomputable section

open scoped InnerProductSpace

namespace NumStability.HDP.Kernel

/-- `Φ` realizes the real-valued kernel `K` by inner products. -/
def IsRealFeatureMap {X H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℝ H]
    (K : X → X → ℝ) (Φ : X → H) : Prop :=
  ∀ u v, ⟪Φ u, Φ v⟫_ℝ = K u v

theorem isRealFeatureMap_iff {X H : Type*} [NormedAddCommGroup H]
    [InnerProductSpace ℝ H] (K : X → X → ℝ) (Φ : X → H) :
    IsRealFeatureMap K Φ ↔ ∀ u v, ⟪Φ u, Φ v⟫_ℝ = K u v :=
  Iff.rfl

end NumStability.HDP.Kernel
