/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Nonconservative transport is constant along particle characteristics

Proof-free target for the assertion following (2.19). The field is continuous
along the closed time segment and classical only in its interior.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- A nonconservative solution has the same value at both ends of a characteristic segment. -/
def nonconservativeCharacteristicTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (velocity curve : ℝ → ℝ)
    (F : ℝ → (ℝ × ℝ) →L[ℝ] E) (qt qx : ℝ → E) (a b : ℝ)
    (spaceDomain timeDomain : Set ℝ),
    a ≤ b →
    MapsTo (fun τ => (curve τ, τ)) (Icc a b) (spaceDomain ×ˢ timeDomain) →
    ContinuousOn (fun τ => q (curve τ) τ) (Icc a b) →
    (∀ τ ∈ Ioo a b,
      UniqueDiffWithinAt ℝ spaceDomain (curve τ) ∧
      UniqueDiffWithinAt ℝ timeDomain τ ∧
      HasFDerivWithinAt (Function.uncurry q) (F τ) (spaceDomain ×ˢ timeDomain) (curve τ, τ) ∧
      HasDerivWithinAt (fun r => q (curve τ) r) (qt τ) timeDomain τ ∧
      HasDerivWithinAt (fun x => q x τ) (qx τ) spaceDomain (curve τ) ∧
      HasDerivAt curve (velocity (curve τ)) τ ∧
      qt τ + velocity (curve τ) • qx τ = 0) →
    q (curve b) b = q (curve a) a

end NumStability.Leveque02Tracer
