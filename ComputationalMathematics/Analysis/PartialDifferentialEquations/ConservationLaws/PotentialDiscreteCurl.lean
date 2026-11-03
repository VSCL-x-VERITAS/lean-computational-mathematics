/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Group.Integral
import Mathlib.Tactic.Ring

/-!
# Finite-difference integration by parts and the discrete curl of a potential

Translation invariance gives exact integration by parts for a backward
difference of a potential and a forward difference of a test function.
Commutation of the two translations then gives the discrete curl identity.
Only integrability of the four actual translated products is required.
No derivatives, conservation equation, or weak-solution certificate is assumed.
-/

noncomputable section
open MeasureTheory Measure Filter

namespace NumStability

/-- The backward potential difference is adjoint to the negative forward
test difference. Both products in the conclusion are genuinely integrable. -/
theorem integral_potential_backwardDifference_mul
    {G : Type*} [AddCommGroup G] [MeasurableSpace G] [MeasurableAdd G]
    (μ : Measure G) [IsAddRightInvariant μ] (potential test : G → ℝ) (shift : G)
    (hzero : Integrable (fun z => potential z * test z) μ)
    (hshift : Integrable (fun z => potential z * test (z + shift)) μ) :
    Integrable (fun z => (potential z - potential (z - shift)) * test z) μ ∧
      Integrable (fun z => potential z * (test (z + shift) - test z)) μ ∧
      (∫ z, (potential z - potential (z - shift)) * test z ∂μ) =
        -(∫ z, potential z * (test (z + shift) - test z) ∂μ) := by
  have hback : Integrable (fun z => potential (z - shift) * test z) μ := by
    simpa only [sub_add_cancel] using hshift.comp_sub_right shift
  have hbackIntegral : (∫ z, potential (z - shift) * test z ∂μ) =
      ∫ z, potential z * test (z + shift) ∂μ := by
    simpa only [sub_add_cancel] using
      integral_sub_right_eq_self (μ := μ) (fun z => potential z * test (z + shift)) shift
  have hleft : (fun z => (potential z - potential (z - shift)) * test z) =
      (fun z => potential z * test z - potential (z - shift) * test z) := by
    funext z
    ring
  have hright : (fun z => potential z * (test (z + shift) - test z)) =
      (fun z => potential z * test (z + shift) - potential z * test z) := by
    funext z
    ring
  rw [hleft, hright]
  refine ⟨hzero.sub hback, hshift.sub hzero, ?_⟩
  rw [integral_sub hzero hback, integral_sub hshift hzero, hbackIntegral]
  ring

/-- The exact two-direction curl cancellation before passing to derivatives.
This uses forward differences of the test and backward differences of the
same potential, with no regularity or PDE hypothesis hidden in the statement. -/
theorem integral_potential_discreteCurl
    {G : Type*} [AddCommGroup G] [MeasurableSpace G] [MeasurableAdd G]
    (μ : Measure G) [IsAddRightInvariant μ] (potential test : G → ℝ) (a b : G)
    (hzero : Integrable (fun z => potential z * test z) μ)
    (ha : Integrable (fun z => potential z * test (z + a)) μ)
    (hb : Integrable (fun z => potential z * test (z + b)) μ)
    (hab : Integrable (fun z => potential z * test (z + (a + b))) μ) :
    Integrable (fun z => (potential z - potential (z - a)) * (test (z + b) - test z)) μ ∧
      Integrable (fun z => (potential z - potential (z - b)) * (test (z + a) - test z)) μ ∧
      (∫ z, (potential z - potential (z - a)) * (test (z + b) - test z) ∂μ) =
        ∫ z, (potential z - potential (z - b)) * (test (z + a) - test z) ∂μ := by
  have hdiffb : Integrable (fun z => potential z * (test (z + b) - test z)) μ := by
    simpa only [mul_sub] using hb.sub hzero
  have hdiffa : Integrable (fun z => potential z * (test (z + a) - test z)) μ := by
    simpa only [mul_sub] using ha.sub hzero
  have hshiftab : Integrable (fun z => potential z * (test (z + a + b) - test (z + a))) μ := by
    simpa only [add_assoc, mul_sub] using hab.sub ha
  have hshiftba : Integrable (fun z => potential z * (test (z + b + a) - test (z + b))) μ := by
    simpa only [add_assoc, add_comm b a, mul_sub] using hab.sub hb
  have hleft := integral_potential_backwardDifference_mul μ potential
    (fun z => test (z + b) - test z) a hdiffb hshiftab
  have hright := integral_potential_backwardDifference_mul μ potential
    (fun z => test (z + a) - test z) b hdiffa hshiftba
  refine ⟨hleft.1, hright.1, hleft.2.2.trans ?_⟩
  rw [hright.2.2]
  congr 1
  apply integral_congr_ae
  filter_upwards [] with z
  rw [add_right_comm z a b]
  ring

end NumStability
