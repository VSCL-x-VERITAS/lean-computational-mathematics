/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann

/-!
# LeVeque Chapter 1, material-interface Riemann data

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 8 (raw PDF page 30).
-/

namespace NumStability

/-- Joint medium/state Riemann data is exactly the componentwise two-state
data at the same interface. This statement supplies no reflection or transmission dynamics. -/
theorem leveque01_materialInterfaceRiemannData_iff {Material State : Type*}
    (medium : ℝ → Material) (initialState : ℝ → State)
    (leftMaterial rightMaterial : Material) (leftState rightState : State) :
    IsRiemannData (fun x => (medium x, initialState x))
        (leftMaterial, leftState) (rightMaterial, rightState) ↔
      IsRiemannData medium leftMaterial rightMaterial ∧
        IsRiemannData initialState leftState rightState :=
  isRiemannData_prod_iff medium initialState leftMaterial rightMaterial leftState rightState

/-- Independently chosen origin values remain free in the paired construction. -/
theorem leveque01_materialInterfaceRiemannData_pair {Material State : Type*}
    (leftMaterial originMaterial rightMaterial : Material)
    (leftState originState rightState : State) :
    (fun x => (riemannData leftMaterial originMaterial rightMaterial x,
      riemannData leftState originState rightState x)) =
      riemannData (leftMaterial, leftState) (originMaterial, originState)
        (rightMaterial, rightState) :=
  riemannData_prod leftMaterial originMaterial rightMaterial leftState originState rightState

end NumStability
