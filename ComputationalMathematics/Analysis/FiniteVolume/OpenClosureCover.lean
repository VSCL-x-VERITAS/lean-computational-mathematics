/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Topology.Defs.Basic

set_option autoImplicit false

namespace NumStability.FiniteVolume

/-- An unrestricted collection of open regions contained in a domain, whose
closures cover exactly the closure of the domain. This imposes no partition,
finiteness, nonemptiness or boundary regularity condition. -/
def IsOpenClosureCover {Point : Type*} [TopologicalSpace Point]
    (domain : Set Point) (regions : Set (Set Point)) : Prop :=
  (∀ K ∈ regions, IsOpen K ∧ K ⊆ domain) ∧
    closure domain = ⋃ K ∈ regions, closure K

end NumStability.FiniteVolume
