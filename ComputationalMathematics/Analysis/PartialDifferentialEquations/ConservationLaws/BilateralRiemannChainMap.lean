/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BilateralRiemannChain

/-!
# Additive maps of bilateral Riemann assemblies

An additive map commutes with assembly in a compatible finite window.
In particular, characteristic coordinate maps can be applied before assembly.
-/

namespace NumStability

/-- Additive maps preserve the constant exterior tails of a finite window. -/
theorem IsRiemannChainWindow.map
    {E F : Type*} [AddCommGroup E] [AddCommGroup F]
    {states profiles : ℤ → E} {radius : ℕ}
    (h : IsRiemannChainWindow states profiles radius) (f : E →+ F) :
    IsRiemannChainWindow (fun j => f (states j)) (fun j => f (profiles j)) radius :=
  ⟨fun j hj => congrArg f (h.1 j hj), fun j hj => congrArg f (h.2 j hj)⟩

/-- Compatible-window assembly commutes with every additive map. -/
theorem bilateralRiemannChainAssembly_map
    {E F : Type*} [AddCommGroup E] [AddCommGroup F]
    (states profiles : ℤ → E) (f : E →+ F)
    (hfinite : ∃ radius, IsRiemannChainWindow states profiles radius)
    (hmapped : ∃ radius,
      IsRiemannChainWindow (fun j => f (states j)) (fun j => f (profiles j)) radius) :
    f (bilateralRiemannChainAssembly states profiles hfinite) =
      bilateralRiemannChainAssembly (fun j => f (states j))
        (fun j => f (profiles j)) hmapped := by
  obtain ⟨radius, hradius⟩ := hfinite
  rw [bilateralRiemannChainAssembly_eq_window states profiles _ radius hradius,
    bilateralRiemannChainAssembly_eq_window _ _ hmapped radius (hradius.map f)]
  simp [integerRiemannChainWindow, finiteRiemannChainAssembly, map_sum]

end NumStability
