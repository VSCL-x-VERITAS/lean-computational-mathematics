/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Topology.Defs.Basic

/-!
# Open Closure Cover

An unrestricted collection of open regions contained in a domain, whose
closures cover exactly the closure of the domain. This imposes no partition,
finiteness, nonemptiness or boundary regularity condition.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

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
