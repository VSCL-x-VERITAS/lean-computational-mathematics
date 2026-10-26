import Mathlib.Analysis.Distribution.TestFunction
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Normed.Lp.MeasurableSpace
import Mathlib.MeasureTheory.Measure.Haar.OfBasis
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.LinearAlgebra.Basis.Defs
import Mathlib.Topology.Algebra.Module.Basic
import Mathlib.Topology.EMetricSpace.Lipschitz

/-! Real L² weak-gradient graphs and compact-smooth closure on open sets. -/

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume.SobolevGraph

open MeasureTheory TopologicalSpace Set
open scoped BigOperators ENNReal Topology InnerProductSpace NNReal

/-- Finite-dimensional real Euclidean space used by the weak-gradient graph. -/
abbrev Space (d : ℕ) := EuclideanSpace ℝ (Fin d)

/-- Lebesgue measure restricted to the selected open domain. -/
def domainMeasure {d : ℕ} (Ω : Opens (Space d)) : Measure (Space d) :=
  volume.restrict (Ω : Set (Space d))

/-- Square-integrable real scalar functions on the selected open domain. -/
abbrev ScalarL2 {d : ℕ} (Ω : Opens (Space d)) := Lp ℝ 2 (domainMeasure Ω)
/-- Square-integrable Euclidean vector fields on the selected open domain. -/
abbrev GradientL2 {d : ℕ} (Ω : Opens (Space d)) := Lp (Space d) 2 (domainMeasure Ω)
/-- Pair consisting of a square-integrable scalar value and vector gradient. -/
abbrev ValueGradient {d : ℕ} (Ω : Opens (Space d)) := ScalarL2 Ω × GradientL2 Ω

/-- Local one-sided Lipschitz graph description at every boundary point.
The unit vector n is the inward vertical direction; g is Lipschitz on the
horizontal disk. No polygon, mesh, chart callback or dimension is selected. -/
def HasLipschitzGraphBoundary {d : ℕ} (Ω : Opens (Space d)) : Prop :=
  ∀ p ∈ frontier (Ω : Set (Space d)),
    ∃ (r : ℝ) (n : Space d) (K : ℝ≥0) (g : Space d → ℝ),
      0 < r ∧ ‖n‖ = 1 ∧ g 0 = 0 ∧
      LipschitzOnWith K g (Metric.ball 0 r ∩ {y | inner ℝ n y = 0}) ∧
      ∀ x ∈ Metric.ball p r,
        (x ∈ (Ω : Set (Space d)) ↔
          g ((x - p) - (inner ℝ n (x - p)) • n) < inner ℝ n (x - p))

/-- Boundedness and the prescribed Lipschitz-graph boundary condition for the open domain. -/
def IsBoundedLipschitzOpen {d : ℕ} (Ω : Opens (Space d)) : Prop :=
  Bornology.IsBounded (Ω : Set (Space d)) ∧ HasLipschitzGraphBoundary Ω

/-- Spatial partial derivative of the test function in the selected coordinate direction. -/
def testPartial {d : ℕ} {Ω : Opens (Space d)}
    (φ : TestFunction Ω ℝ ⊤) (i : Fin d) (x : Space d) : ℝ :=
  (fderiv ℝ (φ : Space d → ℝ) x) (EuclideanSpace.single i 1)

/-- Vector of spatial partial derivatives of the smooth test function. -/
def testGradient {d : ℕ} {Ω : Opens (Space d)}
    (φ : TestFunction Ω ℝ ⊤) (x : Space d) : Space d :=
  ∑ i : Fin d, (testPartial φ i x) • EuclideanSpace.single i 1

/-- True distributional coordinate identities on the actual open set.
The L² quotient already enforces integrability of value and gradient. -/
def HasWeakGradient {d : ℕ} {Ω : Opens (Space d)} (w : ValueGradient Ω) : Prop :=
  ∀ (φ : TestFunction Ω ℝ ⊤) (i : Fin d),
    Integrable (fun x => w.1 x * testPartial φ i x) (domainMeasure Ω) ∧
    Integrable (fun x => (w.2 x) i * φ x) (domainMeasure Ω) ∧
    -(∫ x, w.1 x * testPartial φ i x ∂domainMeasure Ω) =
      ∫ x, (w.2 x) i * φ x ∂domainMeasure Ω

/-- The graph of actual smooth compactly supported functions, mapped into
L²×L² by a.e. equality. No choice of representative is used as vector equality. -/
def smoothCompactGraph {d : ℕ} (Ω : Opens (Space d)) : Set (ValueGradient Ω) :=
  {w | ∃ φ : TestFunction Ω ℝ ⊤,
    (w.1 : Space d → ℝ) =ᵐ[domainMeasure Ω] (φ : Space d → ℝ) ∧
    (w.2 : Space d → Space d) =ᵐ[domainMeasure Ω] testGradient φ}

/-- H¹₀ graph: actual weak-gradient pairs in the L²-product closure
of the smooth compact graph. The product norm has the same topology as the
usual graph norm. This is not the set of compactly supported C¹ functions.
On bounded Lipschitz open sets this represents the standard zero-trace space;
formal correspondence support remains separate work. -/
def InH01Graph {d : ℕ} {Ω : Opens (Space d)} (w : ValueGradient Ω) : Prop :=
  HasWeakGradient w ∧ w ∈ closure (smoothCompactGraph Ω)

end NumStability.FiniteVolume.SobolevGraph
