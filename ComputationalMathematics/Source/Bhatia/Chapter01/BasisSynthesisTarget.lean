/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.InnerProductSpace.Orthonormal
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.Basis.Defs

/-! Proof-free source targets for Bhatia, *Matrix Analysis* (1997),
Exercise I.1.2, printed page 3 (PDF page 15): synthesis by a basis,
analysis by its biorthogonal basis, and the orthonormal special case. -/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Synthesis by an arbitrary basis is complex linear and has analysis by its
biorthogonal basis as a two-sided inverse. -/
def basisSynthesisInverse : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let n := Module.finrank ℂ H
    ∀ (X Y : Module.Basis (Fin n) ℂ H),
      (∀ i j, inner ℂ (Y i) (X j) = if i = j then 1 else 0) →
      let synthesis := fun (c : Fin n → ℂ) => ∑ j, (c j) • X j
      let analysis := fun (v : H) => fun i => inner ℂ (Y i) v
      (∀ c d, synthesis (c + d) = synthesis c + synthesis d) ∧
      (∀ (a : ℂ) c, synthesis (a • c) = a • synthesis c) ∧
      (∀ c, analysis (synthesis c) = c) ∧
      (∀ v, synthesis (analysis v) = v)

/-- Orthonormal basis synthesis preserves the full complex inner product of
the standard coordinate Hilbert space. -/
def basisSynthesisInner : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let n := Module.finrank ℂ H
    ∀ (X : Module.Basis (Fin n) ℂ H), Orthonormal ℂ X →
      ∀ (c d : EuclideanSpace ℂ (Fin n)),
        inner ℂ (∑ j, (c j) • X j) (∑ j, (d j) • X j) = inner ℂ c d

end NumStability.Bhatia.Chapter01.Targets
