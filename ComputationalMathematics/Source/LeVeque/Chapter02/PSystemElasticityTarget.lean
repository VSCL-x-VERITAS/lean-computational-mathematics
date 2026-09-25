/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.GenericPSystemNotationModel

/-!
# Proof-free target: structural p-system and nonlinear elasticity analogy

This compares the two displayed pointwise systems at a common formal spatial
coordinate. The coordinate in gas dynamics is a mass label, while that in the
elasticity display is a reference position; the theorem does not identify
their physical state spaces or assert a change of coordinates between them.
-/

namespace NumStability.Leveque02Tracer

/-- At constant positive density, the elasticity momentum law becomes the
generic p-system law after normalizing stress by density and reversing its
sign. In the unit-density case this is the printed identification `p=-σ`.
The derivative witnesses keep the comparison within the classical systems.
The final two clauses state the unit-density identification and exhibit signed
elastic states that do not satisfy both positive gas state conditions. -/
def pSystemElasticityTarget : Prop :=
  (∀ (strain velocity : ℝ → ℝ → ℝ) (stressLaw : ℝ → ℝ)
      (density x t strainTime velocitySpace velocityTime stressSpace : ℝ),
      0 < density →
      HasDerivAt (fun τ => strain x τ) strainTime t →
      HasDerivAt (fun y => velocity y t) velocitySpace x →
      HasDerivAt (fun τ => velocity x τ) velocityTime t →
      HasDerivAt (fun y => stressLaw (strain y t)) stressSpace x →
      let pressureLaw : ℝ → ℝ := fun e => -stressLaw e / density
      HasDerivAt (fun y => pressureLaw (strain y t)) (-stressSpace / density) x ∧
      ((strainTime - velocitySpace = 0 ∧
          density * velocityTime - stressSpace = 0) ↔
        IsGenericPSystemAt strain velocity pressureLaw x t)) ∧
  (∀ (stressLaw : ℝ → ℝ) (e : ℝ),
    -stressLaw e / (1 : ℝ) = -stressLaw e) ∧
  (let stressLaw : ℝ → ℝ := fun e => e
   ∃ extension compression : ℝ,
     0 < extension ∧ 0 < stressLaw extension ∧
     -1 < compression ∧ compression < 0 ∧ stressLaw compression < 0 ∧
     ¬ (0 < extension ∧ 0 < -stressLaw extension) ∧
     ¬ (0 < compression ∧ 0 < -stressLaw compression))

end NumStability.Leveque02Tracer
