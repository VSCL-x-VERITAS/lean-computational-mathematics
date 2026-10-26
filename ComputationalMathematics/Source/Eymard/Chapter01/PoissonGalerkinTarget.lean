import ComputationalMathematics.Analysis.FiniteVolume.WeakSobolevGraph

/-! Concrete physical Poisson-Galerkin target and separate unproved foundation contracts.
This module defines propositions; it supplies no proof inhabitants. -/

set_option autoImplicit false
noncomputable section

namespace NumStability.Eymard.Chapter01.PoissonGalerkin

open MeasureTheory TopologicalSpace Set Module
open scoped BigOperators ENNReal Topology InnerProductSpace

open NumStability.FiniteVolume.SobolevGraph

/-- The specified physical Poisson form, never supplied bilinear data. -/
def poissonForm {d : ℕ} {Ω : Opens (Space d)} (w v : ValueGradient Ω) : ℝ :=
  ∫ x, inner ℝ (w.2 x) (v.2 x) ∂domainMeasure Ω

/-- Actual L² source pairing, never supplied linear data. -/
def loadForm {d : ℕ} {Ω : Opens (Space d)}
    (f : ScalarL2 Ω) (v : ValueGradient Ω) : ℝ :=
  ∫ x, f x * v.1 x ∂domainMeasure Ω

/-- Continuous zero-boundary variational problem for the supplied square-integrable load. -/
def continuousProblem {d : ℕ} {Ω : Opens (Space d)}
    (f : ScalarL2 Ω) (u : ValueGradient Ω) : Prop :=
  InH01Graph u ∧ ∀ v : ValueGradient Ω, InH01Graph v → poissonForm u v = loadForm f v

/-- Conformity of the discrete space with the zero-boundary weak-gradient graph. -/
def IsConforming {d : ℕ} {Ω : Opens (Space d)}
    (Vh : Submodule ℝ (ValueGradient Ω)) : Prop :=
  ∀ w ∈ Vh, InH01Graph w

/-- Reconstruct the value-gradient pair from its finite basis coefficients. -/
def reconstruction {d N : ℕ} {Ω : Opens (Space d)}
    {Vh : Submodule ℝ (ValueGradient Ω)} (b : Basis (Fin N) ℝ Vh)
    (U : Fin N → ℝ) : Vh :=
  ∑ i : Fin N, U i • b i

/-- Galerkin variational problem in the supplied finite-dimensional subspace. -/
def discreteProblem {d N : ℕ} {Ω : Opens (Space d)}
    {Vh : Submodule ℝ (ValueGradient Ω)} (f : ScalarL2 Ω)
    (b : Basis (Fin N) ℝ Vh) (U : Fin N → ℝ) : Prop :=
  ∀ v : Vh, poissonForm (reconstruction b U : ValueGradient Ω) (v : ValueGradient Ω) =
    loadForm f (v : ValueGradient Ω)

/-- Row = test, column = trial, matching Chen A_ij=a(phi_j,phi_i). -/
def stiffnessEntry {d N : ℕ} {Ω : Opens (Space d)}
    {Vh : Submodule ℝ (ValueGradient Ω)} (b : Basis (Fin N) ℝ Vh)
    (j i : Fin N) : ℝ :=
  poissonForm (b i : ValueGradient Ω) (b j : ValueGradient Ω)

/-- Galerkin equations expressed in the supplied finite basis. -/
def basisLinearSystem {d N : ℕ} {Ω : Opens (Space d)}
    {Vh : Submodule ℝ (ValueGradient Ω)} (f : ScalarL2 Ω)
    (b : Basis (Fin N) ℝ Vh) (U : Fin N → ℝ) : Prop :=
  ∀ j : Fin N, (∑ i : Fin N, stiffnessEntry b j i * U i) =
    loadForm f (b j : ValueGradient Ω)

/-- Physical Poisson-Galerkin basis-equivalence target. Source meanings are
recorded in the claim; elaboration and formal support remain unaccepted. No existence, uniqueness,
solver, positive definiteness, strong/weak equivalence or Céa claim is added. -/
def poissonGalerkinTarget : Prop :=
  ∀ (d : ℕ), 0 < d → ∀ (Ω : Opens (Space d)), IsBoundedLipschitzOpen Ω →
    ∀ (f : ScalarL2 Ω) (N : ℕ) (Vh : Submodule ℝ (ValueGradient Ω)),
      IsConforming Vh → ∀ (b : Basis (Fin N) ℝ Vh) (U : Fin N → ℝ),
        discreteProblem f b U ↔ basisLinearSystem f b U

/-- Separate foundation obligations, not assumptions of the candidate. -/
def smoothClosureHasWeakGradient : Prop :=
  ∀ (d : ℕ) (Ω : Opens (Space d)) (w : ValueGradient Ω),
    w ∈ closure (smoothCompactGraph Ω) → HasWeakGradient w

/-- Uniqueness obligation for a weak gradient on the selected open domain. -/
def weakGradientUnique : Prop :=
  ∀ (d : ℕ) (Ω : Opens (Space d)) (u : ScalarL2 Ω) (g h : GradientL2 Ω),
    HasWeakGradient (u, g) → HasWeakGradient (u, h) → g = h

/-- Linearity obligation for the zero-boundary weak-gradient graph. -/
def h01GraphLinear : Prop :=
  ∀ (d : ℕ) (Ω : Opens (Space d)),
    InH01Graph (0 : ValueGradient Ω) ∧
    (∀ w v : ValueGradient Ω, InH01Graph w → InH01Graph v → InH01Graph (w + v)) ∧
    (∀ (c : ℝ) (w : ValueGradient Ω), InH01Graph w → InH01Graph (c • w))

/-- Integrability obligation for the gradient and load pairings in the weak problem. -/
def physicalPairingIntegrable : Prop :=
  ∀ (d : ℕ) (Ω : Opens (Space d)) (f : ScalarL2 Ω) (w v : ValueGradient Ω),
    Integrable (fun x => inner ℝ (w.2 x) (v.2 x)) (domainMeasure Ω) ∧
    Integrable (fun x => f x * v.1 x) (domainMeasure Ω)

end NumStability.Eymard.Chapter01.PoissonGalerkin
