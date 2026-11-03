/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFullCFLFiniteGridREA
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersTranslatedWeakTest

/-!
# Compact-test weak identity for the actual full-CFL finite Burgers field

Actual translated pair weak identities and constant backgrounds are combined
by finite affine sums. The actual nonlinear flux telescopes on the closed
forward CFL window. Above that window its test weight vanishes by actual test
support. The proof makes no rectangle-to-distribution equivalence assumption.
Ordinary global C1 compact tests may be nonzero on the initial time face.
-/

noncomputable section
open Set MeasureTheory Filter

namespace NumStability

private theorem burgers_constant_globalWeakData
    (state : ℝ) (test : ℝ × ℝ → ℝ)
    (htest : ContDiff ℝ 1 test) (hsupport : HasCompactSupport test) :
    Integrable (fun z => state * forwardTestDerivative test (0, 1) z +
      (state ^ 2 / 2) * forwardTestDerivative test (1, 0) z) ∧
    Integrable (fun x => state * test (x, 0)) ∧
    (∫ z : ℝ × ℝ, state * forwardTestDerivative test (0, 1) z +
      (state ^ 2 / 2) * forwardTestDerivative test (1, 0) z) +
      (∫ x, state * test (x, 0)) = 0 := by
  simpa only [leveque04_burgersSelectedField_constant, riemannData, ite_self] using
    leveque04_burgersTranslatedField_weakTest_spacetime state state 0 test htest hsupport

/-- Genuine spacetime/initial integrability and weak identity for the actual
finite sum, under the full characteristic CFL and actual compact time support. -/
theorem leveque04_burgersFiniteChain_weakTest_spacetime_fullCFL
    (states : ℕ → ℝ) (count : ℕ) (width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hstates : ∀ j ≤ count, |states j| ≤ bound) (hcfl : bound * horizon ≤ width)
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test)
    (hsupport : HasCompactSupport test)
    (hslab : tsupport test ⊆ {z : ℝ × ℝ | z.2 < horizon}) :
    Integrable (fun z : ℝ × ℝ =>
      leveque04_burgersFiniteChain states count width z.1 z.2 0 *
          forwardTestDerivative test (0, 1) z +
        (leveque04_burgersFiniteChain states count width z.1 z.2 0 ^ 2 / 2) *
          forwardTestDerivative test (1, 0) z) ∧
    Integrable (fun x => leveque04_burgersFiniteChain states count width x 0 0 * test (x, 0)) ∧
    (∫ z : ℝ × ℝ,
      leveque04_burgersFiniteChain states count width z.1 z.2 0 *
          forwardTestDerivative test (0, 1) z +
        (leveque04_burgersFiniteChain states count width z.1 z.2 0 ^ 2 / 2) *
          forwardTestDerivative test (1, 0) z) +
      (∫ x, leveque04_burgersFiniteChain states count width x 0 0 * test (x, 0)) = 0 := by
  classical
  let q : ℝ × ℝ → ℝ := fun z => leveque04_burgersFiniteChain states count width z.1 z.2 0
  let piece : ℕ → ℝ × ℝ → ℝ := fun j z => leveque04_burgersSelectedField
    (states j) (states (j + 1)) (z.1 - (j : ℝ) * width) z.2
  let P : ℕ → ℝ × ℝ → ℝ := fun j z => piece j z * forwardTestDerivative test (0, 1) z +
    (piece j z ^ 2 / 2) * forwardTestDerivative test (1, 0) z
  let B : ℕ → ℝ × ℝ → ℝ := fun j z => states j * forwardTestDerivative test (0, 1) z +
    (states j ^ 2 / 2) * forwardTestDerivative test (1, 0) z
  let IP : ℕ → ℝ → ℝ := fun j x => piece j (x, 0) * test (x, 0)
  let IB : ℕ → ℝ → ℝ := fun j x => states j * test (x, 0)
  let F : ℝ × ℝ → ℝ := fun z => q z * forwardTestDerivative test (0, 1) z +
    (q z ^ 2 / 2) * forwardTestDerivative test (1, 0) z
  let I : ℝ → ℝ := fun x => q (x, 0) * test (x, 0)
  have hP (j : ℕ) : Integrable (P j) ∧ Integrable (IP j) ∧
      (∫ z, P j z) + (∫ x, IP j x) = 0 := by
    simpa only [P, IP, piece, leveque04_burgersSelectedField_initial] using
      leveque04_burgersTranslatedField_weakTest_spacetime
        (states j) (states (j + 1)) ((j : ℝ) * width) test htest hsupport
  have hB (j : ℕ) : Integrable (B j) ∧ Integrable (IB j) ∧
      (∫ z, B j z) + (∫ x, IB j x) = 0 :=
    burgers_constant_globalWeakData (states j) test htest hsupport
  have hstate (z : ℝ × ℝ) : q z = states 0 +
      ∑ j ∈ Finset.range count, (piece j z - states j) := by
    simp only [q, piece, leveque04_burgersFiniteChain, finiteRiemannChainAssembly,
      Pi.add_apply, Pi.sub_apply, Finset.sum_apply]
  have hfluxWeighted (z : ℝ × ℝ) :
      (q z ^ 2 / 2) * forwardTestDerivative test (1, 0) z =
        (states 0 ^ 2 / 2 + ∑ j ∈ Finset.range count,
          (piece j z ^ 2 / 2 - states j ^ 2 / 2)) * forwardTestDerivative test (1, 0) z := by
    by_cases hzero : 0 ≤ z.2
    · by_cases htime : z.2 ≤ horizon
      · have hmap := leveque04_burgersFiniteChain_map_fullCFL (fun u => u 0 ^ 2 / 2)
          states count width bound horizon z.1 z.2 hwidth hbound hstates hcfl ⟨hzero, htime⟩
        have heq : q z ^ 2 / 2 = states 0 ^ 2 / 2 +
            ∑ j ∈ Finset.range count, (piece j z ^ 2 / 2 - states j ^ 2 / 2) := by
          simpa only [q, piece, finiteRiemannChainAssembly] using hmap
        rw [heq]
      · have htpos : 0 < z.2 := lt_of_le_of_lt hhorizon (lt_of_not_ge htime)
        have hD : forwardTestDerivative test (1, 0) z = 0 := by
          rw [show z = (z.1, z.2) from rfl,
            forwardTestDerivative_eq_fderiv test (1, 0) z.1 z.2 htpos]
          exact globalTest_fderiv_zero_above_slab test horizon hslab _ (le_of_not_ge htime) _
        rw [hD]
        simp
    · have hz : z ∉ forwardSpacetimeHalfspace := by
        simpa only [forwardSpacetimeHalfspace, mem_prod, mem_univ, true_and, mem_Ici] using hzero
      simp [forwardTestDerivative, hz]
  have hFpoint (z : ℝ × ℝ) : F z = B 0 z +
      ∑ j ∈ Finset.range count, (P j z - B j z) := by
    dsimp only [F]
    rw [hfluxWeighted, hstate]
    have hsum : (∑ j ∈ Finset.range count,
        (piece j z - states j) * forwardTestDerivative test (0, 1) z) +
        (∑ j ∈ Finset.range count,
          (piece j z ^ 2 / 2 - states j ^ 2 / 2) * forwardTestDerivative test (1, 0) z) =
        ∑ j ∈ Finset.range count, (P j z - B j z) := by
      rw [← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro j _
      dsimp only [P, B]
      ring
    simp only [add_mul, Finset.sum_mul]
    calc
      _ = B 0 z + ((∑ j ∈ Finset.range count,
          (piece j z - states j) * forwardTestDerivative test (0, 1) z) +
          (∑ j ∈ Finset.range count,
            (piece j z ^ 2 / 2 - states j ^ 2 / 2) * forwardTestDerivative test (1, 0) z)) := by
        dsimp only [B]
        ring
      _ = _ := by rw [hsum]
  have hIpoint (x : ℝ) : I x = IB 0 x + ∑ j ∈ Finset.range count, (IP j x - IB j x) := by
    dsimp only [I, IP, IB]
    rw [hstate]
    simp only [add_mul, Finset.sum_mul, sub_mul]
  have hintFsum : Integrable (fun z => ∑ j ∈ Finset.range count, (P j z - B j z)) :=
    integrable_finset_sum _ (fun j _ => (hP j).1.sub (hB j).1)
  have hintIsum : Integrable (fun x => ∑ j ∈ Finset.range count, (IP j x - IB j x)) :=
    integrable_finset_sum _ (fun j _ => (hP j).2.1.sub (hB j).2.1)
  have hintF : Integrable F := ((hB 0).1.add hintFsum).congr
    (Eventually.of_forall (fun z => (hFpoint z).symm))
  have hintI : Integrable I := ((hB 0).2.1.add hintIsum).congr
    (Eventually.of_forall (fun x => (hIpoint x).symm))
  refine ⟨hintF, hintI, ?_⟩
  change (∫ z, F z) + (∫ x, I x) = 0
  rw [show F = (fun z => B 0 z + ∑ j ∈ Finset.range count, (P j z - B j z)) from funext hFpoint,
    show I = (fun x => IB 0 x + ∑ j ∈ Finset.range count, (IP j x - IB j x)) from funext hIpoint,
    integral_add (hB 0).1 hintFsum, integral_add (hB 0).2.1 hintIsum,
    integral_finset_sum (Finset.range count) (f := fun j z => P j z - B j z)
      (fun j _ => (hP j).1.sub (hB j).1),
    integral_finset_sum (Finset.range count) (f := fun j x => IP j x - IB j x)
      (fun j _ => (hP j).2.1.sub (hB j).2.1)]
  have hbulk (j : ℕ) : (∫ z, P j z - B j z) = (∫ z, P j z) - (∫ z, B j z) :=
    integral_sub (hP j).1 (hB j).1
  have hinitial (j : ℕ) : (∫ x, IP j x - IB j x) = (∫ x, IP j x) - (∫ x, IB j x) :=
    integral_sub (hP j).2.1 (hB j).2.1
  simp_rw [hbulk, hinitial]
  have hsum : (∑ j ∈ Finset.range count,
      (((∫ z, P j z) - (∫ z, B j z)) + ((∫ x, IP j x) - (∫ x, IB j x)))) = 0 := by
    apply Finset.sum_eq_zero
    intro j _
    linarith [(hP j).2.2, (hB j).2.2]
  rw [Finset.sum_add_distrib] at hsum
  linarith [(hB 0).2.2]

/-- Literal whole-real-line forward weak formula on the actual finite field,
with ordinary global C1 compact tests supported below the CFL horizon. -/
theorem leveque04_burgersFiniteChain_weakTest_fullCFL
    (states : ℕ → ℝ) (count : ℕ) (width bound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hhorizon : 0 ≤ horizon)
    (hstates : ∀ j ≤ count, |states j| ≤ bound) (hcfl : bound * horizon ≤ width)
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test)
    (hsupport : HasCompactSupport test)
    (hslab : tsupport test ⊆ {z : ℝ × ℝ | z.2 < horizon}) :
    (∫ time in Ici (0 : ℝ), ∫ x,
      leveque04_burgersFiniteChain states count width x time 0 *
          fderiv ℝ test (x, time) (0, 1) +
        (leveque04_burgersFiniteChain states count width x time 0 ^ 2 / 2) *
          fderiv ℝ test (x, time) (1, 0)) +
      (∫ x, leveque04_burgersFiniteChain states count width x 0 0 * test (x, 0)) = 0 := by
  have h := leveque04_burgersFiniteChain_weakTest_spacetime_fullCFL states count width bound horizon
    hwidth hbound hhorizon hstates hcfl test htest hsupport hslab
  rw [← forwardTestDerivative_spacetimeIntegral_pair
    (fun z => leveque04_burgersFiniteChain states count width z.1 z.2 0)
    (fun z => leveque04_burgersFiniteChain states count width z.1 z.2 0 ^ 2 / 2) test h.1]
  exact h.2.2

end NumStability
