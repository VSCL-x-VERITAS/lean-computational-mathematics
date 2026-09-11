/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Section mass of a one-dimensional density

A one-dimensional density assigns to every oriented section of a line the
quantity of substance it contains.  This module defines that assignment as an
oriented interval integral and records the properties that make it behave like
a mass: it is additive over adjacent sections, vanishes on a degenerate
section, reverses sign with orientation, depends only on the density inside
the section, is nonnegative for a nonnegative density, and is monotone in the
density.

The final theorem is the converse direction: a continuous density is
determined by the masses it assigns.  Together these say that the interval
integral and the density carry exactly the same information, which is what
licenses reading one as the other.

The six properties are necessary conditions on a mass, not a characterisation
of this functional.  No result here shows the interval integral is the only
assignment satisfying them, and none is claimed.  Two of them also hold outside
the regime where the quantity is a mass at all: `sectionMass_symm` makes it
signed, so it measures mass only on a positively oriented section, and
`sectionMass_self` and `sectionMass_nonneg` hold even for a density that is not
integrable, because Mathlib's interval integral takes the value zero there.

Every statement carries its integrability hypotheses explicitly rather than
assuming a global regularity class.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- The mass carried by the one-dimensional density `q` between the stations
`a` and `b`, as an oriented interval integral. -/
noncomputable def sectionMass (q : ℝ → ℝ) (a b : ℝ) : ℝ := ∫ x in a..b, q x

theorem sectionMass_def (q : ℝ → ℝ) (a b : ℝ) :
    sectionMass q a b = ∫ x in a..b, q x := rfl

/-- A degenerate section carries no mass. -/
@[simp] theorem sectionMass_self (q : ℝ → ℝ) (a : ℝ) : sectionMass q a a = 0 :=
  intervalIntegral.integral_same

/-- Reversing the orientation of a section negates its mass. -/
theorem sectionMass_symm (q : ℝ → ℝ) (a b : ℝ) :
    sectionMass q a b = -sectionMass q b a :=
  intervalIntegral.integral_symm b a

/-- Mass is additive over adjacent sections. -/
theorem sectionMass_add_adjacent {q : ℝ → ℝ} {a b c : ℝ}
    (hab : IntervalIntegrable q volume a b)
    (hbc : IntervalIntegrable q volume b c) :
    sectionMass q a b + sectionMass q b c = sectionMass q a c :=
  intervalIntegral.integral_add_adjacent_intervals hab hbc

/-- The mass of a section depends only on the density inside that section. -/
theorem sectionMass_congr {q r : ℝ → ℝ} {a b : ℝ}
    (h : Set.EqOn q r (Set.uIcc a b)) :
    sectionMass q a b = sectionMass r a b :=
  intervalIntegral.integral_congr h

/-- A nonnegative density assigns nonnegative mass to a positively oriented
section. -/
theorem sectionMass_nonneg {q : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hq : ∀ x ∈ Set.Icc a b, 0 ≤ q x) :
    0 ≤ sectionMass q a b :=
  intervalIntegral.integral_nonneg hab hq

/-- A pointwise larger density assigns at least as much mass to a positively
oriented section. -/
theorem sectionMass_mono {q r : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hq : IntervalIntegrable q volume a b)
    (hr : IntervalIntegrable r volume a b)
    (hle : ∀ x ∈ Set.Icc a b, q x ≤ r x) :
    sectionMass q a b ≤ sectionMass r a b :=
  intervalIntegral.integral_mono_on hab hq hr hle

/-- A continuous density whose sections all carry zero mass is identically
zero.  This is the scalar companion of
`continuous_eq_zero_of_intervalIntegral_eq_zero`, whose conclusion is stated
for vector-valued densities. -/
theorem eq_zero_of_sectionMass_eq_zero {q : ℝ → ℝ} (hq : Continuous q)
    (h : ∀ a b, sectionMass q a b = 0) :
    ∀ x, q x = 0 := by
  intro x
  have hderiv := intervalIntegral.integral_hasDerivAt_right
    (hq.intervalIntegrable 0 x)
    hq.aestronglyMeasurable.stronglyMeasurableAtFilter
    hq.continuousAt
  have hzero : HasDerivAt (fun _ : ℝ => (0 : ℝ)) (q x) x :=
    hderiv.congr_of_eventuallyEq
      (Filter.Eventually.of_forall fun b => (h 0 b).symm)
  exact hzero.unique (hasDerivAt_const x (0 : ℝ))

/-- A continuous density is determined by the masses it assigns to sections. -/
theorem eq_of_sectionMass_eq {q r : ℝ → ℝ}
    (hq : Continuous q) (hr : Continuous r)
    (h : ∀ a b, sectionMass q a b = sectionMass r a b) :
    q = r := by
  funext x
  have hdifference : ∀ a b, sectionMass (fun y => q y - r y) a b = 0 := by
    intro a b
    have hsub : sectionMass (fun y => q y - r y) a b
        = sectionMass q a b - sectionMass r a b :=
      intervalIntegral.integral_sub
        (hq.intervalIntegrable a b) (hr.intervalIntegrable a b)
    rw [hsub, h a b, sub_self]
  have := eq_zero_of_sectionMass_eq_zero (hq.sub hr) hdifference x
  exact sub_eq_zero.mp this

end NumStability
