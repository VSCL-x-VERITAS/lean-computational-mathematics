/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.TransportWeakTest
import Mathlib.Analysis.Calculus.TangentCone.Prod
import Mathlib.Analysis.Calculus.TangentCone.Real

/-!
# Forward weak transport tests specified only on the closed halfspace

The test is C¹ on `forwardSpacetimeHalfspace`, with compact support after
extension by zero outside that halfspace. Its values and regularity outside the
halfspace are unrestricted. No C¹ extension across the initial face is used.

Within derivatives supply continuity and integrability up to the initial face.
At positive times they equal ordinary derivatives. The one-sided fundamental
theorem of calculus needs only continuity from the right at zero, so the initial
term is retained without requiring tests to vanish near zero.
-/

noncomputable section

open Set MeasureTheory Filter
open scoped Topology

namespace NumStability

/-- Closed forward spacetime, with coordinates `(space, time)`. -/
def forwardSpacetimeHalfspace : Set (ℝ × ℝ) := univ ×ˢ Ici 0

private theorem forwardSpacetimeHalfspace_isClosed : IsClosed forwardSpacetimeHalfspace :=
  isClosed_univ.prod isClosed_Ici

private theorem forwardSpacetimeHalfspace_uniqueDiffOn :
    UniqueDiffOn ℝ forwardSpacetimeHalfspace :=
  uniqueDiffOn_univ.prod (uniqueDiffOn_Ici 0)

private theorem halfspace_integrableOn_of_indicator_support
    {X : Type*} [TopologicalSpace X] [MeasureSpace X] [OpensMeasurableSpace X]
    [T2Space X] [SecondCountableTopology X]
    [IsFiniteMeasureOnCompacts (volume : Measure X)]
    (s : Set X) (hs : IsClosed s) (f : X → ℝ) (hf : ContinuousOn f s)
    (hsupport : HasCompactSupport (s.indicator f)) : IntegrableOn f s := by
  classical
  let K := tsupport (s.indicator f)
  have hKs : K ⊆ s := by
    change closure (Function.support (s.indicator f)) ⊆ s
    refine closure_minimal ?_ hs
    intro x hx
    by_contra hxs
    exact hx (by simp [hxs])
  have hKint : IntegrableOn f K :=
    ContinuousOn.integrableOn_compact hsupport (hf.mono hKs)
  apply (integrable_indicator_iff hs.measurableSet).mp
  refine (hKint.integrable_indicator hsupport.measurableSet).congr ?_
  filter_upwards [] with x
  by_cases hxK : x ∈ K
  · simp [hxK, hKs hxK]
  · have hzero : s.indicator f x = 0 := by
      by_contra hnonzero
      exact hxK (subset_tsupport (s.indicator f) hnonzero)
    simp [hxK, hzero]

private theorem halfspace_direction_hasCompactSupport
    (s : Set (ℝ × ℝ)) (test : ℝ × ℝ → ℝ)
    (hsupport : HasCompactSupport (s.indicator test)) (v : ℝ × ℝ) :
    HasCompactSupport (s.indicator (fun z => fderivWithin ℝ test s z v)) := by
  classical
  refine HasCompactSupport.of_support_subset_isCompact hsupport ?_
  intro z hz
  change s.indicator (fun w => fderivWithin ℝ test s w v) z ≠ 0 at hz
  have hzs : z ∈ s := by
    by_contra hnot
    exact hz (by simp [hnot])
  by_contra hzsupport
  have hlocal : test =ᶠ[𝓝[s] z] (fun _ => 0) := by
    have hzero := notMem_tsupport_iff_eventuallyEq.mp hzsupport
    filter_upwards [hzero.filter_mono nhdsWithin_le_nhds,
      (self_mem_nhdsWithin : ∀ᶠ w in 𝓝[s] z, w ∈ s)] with w hw hws
    simpa [hws] using hw
  have hderiv : fderivWithin ℝ test s z = 0 := by
    rw [hlocal.fderivWithin_eq_of_mem hzs]
    exact fderivWithin_const_apply (0 : ℝ)
  apply hz
  simp [hzs, hderiv]

private theorem halfspace_direction_continuousOn
    (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace) (v : ℝ × ℝ) :
    ContinuousOn (fun z => fderivWithin ℝ test forwardSpacetimeHalfspace z v)
      forwardSpacetimeHalfspace := by
  exact (htest.continuousOn_fderivWithin forwardSpacetimeHalfspace_uniqueDiffOn le_rfl).clm_apply
    continuousOn_const

private theorem halfspace_direction_integrableOn
    (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test))
    (v : ℝ × ℝ) :
    IntegrableOn (fun z => fderivWithin ℝ test forwardSpacetimeHalfspace z v)
      forwardSpacetimeHalfspace :=
  halfspace_integrableOn_of_indicator_support forwardSpacetimeHalfspace
    forwardSpacetimeHalfspace_isClosed _ (halfspace_direction_continuousOn test htest v)
    (halfspace_direction_hasCompactSupport forwardSpacetimeHalfspace test hsupport v)

private theorem halfspace_fderivWithin_eq (test : ℝ × ℝ → ℝ)
    (x t : ℝ) (ht : 0 < t) :
    fderivWithin ℝ test forwardSpacetimeHalfspace (x, t) = fderiv ℝ test (x, t) := by
  exact fderivWithin_of_mem_nhds (prod_mem_nhds (Filter.univ_mem) (Ici_mem_nhds ht))

private def halfspaceCharacteristicCoordinates (speed : ℝ) :
    (ℝ × ℝ) ≃ₜ (ℝ × ℝ) where
  toEquiv :=
    { toFun := fun z => (z.2 + speed * z.1, z.1)
      invFun := fun z => (z.2, z.1 - speed * z.2)
      left_inv := by intro z; ext <;> simp
      right_inv := by intro z; ext <;> simp }
  continuous_toFun := by fun_prop
  continuous_invFun := by fun_prop

private theorem halfspace_curve_indicator_hasCompactSupport
    (f : ℝ × ℝ → ℝ)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator f))
    (speed y : ℝ) :
    HasCompactSupport ((Ici (0 : ℝ)).indicator (fun t => f (y + speed * t, t))) := by
  classical
  refine HasCompactSupport.of_support_subset_isCompact
    (hsupport.image continuous_snd) ?_
  intro t ht
  refine ⟨(y + speed * t, t), subset_tsupport (forwardSpacetimeHalfspace.indicator f) ?_, rfl⟩
  change forwardSpacetimeHalfspace.indicator f (y + speed * t, t) ≠ 0
  simpa [forwardSpacetimeHalfspace] using ht

private theorem halfspace_test_curve_integral
    (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test))
    (speed y : ℝ) :
    (∫ t in Ioi (0 : ℝ),
      fderivWithin ℝ test forwardSpacetimeHalfspace (y + speed * t, t) (speed, 1)) =
      -test (y, 0) := by
  have hmap : MapsTo (fun t : ℝ => (y + speed * t, t)) (Ici 0)
      forwardSpacetimeHalfspace := by
    intro t ht
    exact ⟨mem_univ _, ht⟩
  have hcurve : ContinuousOn (fun t : ℝ => test (y + speed * t, t)) (Ici 0) :=
    htest.continuousOn.comp (by fun_prop) hmap
  have hDcurve : ContinuousOn (fun t : ℝ =>
      fderivWithin ℝ test forwardSpacetimeHalfspace (y + speed * t, t) (speed, 1))
      (Ici 0) :=
    (halfspace_direction_continuousOn test htest (speed, 1)).comp (by fun_prop) hmap
  have hDsupport := halfspace_curve_indicator_hasCompactSupport
    (fun z => fderivWithin ℝ test forwardSpacetimeHalfspace z (speed, 1))
    (halfspace_direction_hasCompactSupport forwardSpacetimeHalfspace test hsupport (speed, 1))
    speed y
  have hDint := halfspace_integrableOn_of_indicator_support (Ici (0 : ℝ)) isClosed_Ici
    _ hDcurve hDsupport
  have hderiv (t : ℝ) (ht : t ∈ Ioi (0 : ℝ)) :
      HasDerivAt (fun τ => test (y + speed * τ, τ))
        (fderivWithin ℝ test forwardSpacetimeHalfspace (y + speed * t, t) (speed, 1)) t := by
    have hnhds : forwardSpacetimeHalfspace ∈ 𝓝 (y + speed * t, t) :=
      prod_mem_nhds Filter.univ_mem (Ici_mem_nhds ht)
    have hdiff := (htest.differentiableOn one_ne_zero _
      (hmap (show (0 : ℝ) ≤ t from (show (0 : ℝ) < t from ht).le))).differentiableAt hnhds
    have hγ : HasDerivAt (fun τ : ℝ => (y + speed * τ, τ)) (speed, 1) t := by
      simpa only [mul_one] using
        (((hasDerivAt_id t).const_mul speed).const_add y).prodMk (hasDerivAt_id t)
    rw [halfspace_fderivWithin_eq test _ _ ht]
    exact HasFDerivAt.comp_hasDerivAt (f := fun τ : ℝ => (y + speed * τ, τ)) t
      hdiff.hasFDerivAt hγ
  have htailSupport := halfspace_curve_indicator_hasCompactSupport test hsupport speed y
  rw [hasCompactSupport_iff_eventuallyEq, Filter.coclosedCompact_eq_cocompact] at htailSupport
  have htail : (fun t : ℝ => test (y + speed * t, t)) =ᶠ[atTop] 0 := by
    filter_upwards [htailSupport.filter_mono _root_.atTop_le_cocompact,
      eventually_ge_atTop (0 : ℝ)] with t ht ht0
    simpa [ht0] using ht
  simpa only [zero_sub, mul_zero, add_zero] using integral_Ioi_of_hasDerivAt_of_tendsto (m := (0 : ℝ))
    (hcurve 0 (by simp)) hderiv (hDint.mono_set Ioi_subset_Ici_self) htail.tendsto

/-- The ordinary directional weak integrand is integrable on the open forward
halfspace, for tests specified only as C¹ on the closed halfspace. -/
theorem travelingWave_weakTestOnHalfspace_integrable
    (profile : ℝ → ℝ) (speed : ℝ) (hprofile : Measurable profile)
    (B : ℝ) (hbound : ∀ x, |profile x| ≤ B)
    (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    IntegrableOn (fun z : ℝ × ℝ =>
      travelingWave profile speed z.1 z.2 * fderiv ℝ test z (speed, 1))
      (univ ×ˢ Ioi (0 : ℝ)) := by
  have hD := halfspace_direction_integrableOn test htest hsupport (speed, 1)
  have hproduct : IntegrableOn (fun z : ℝ × ℝ =>
      travelingWave profile speed z.1 z.2 *
        fderivWithin ℝ test forwardSpacetimeHalfspace z (speed, 1))
      forwardSpacetimeHalfspace := by
    apply hD.bdd_mul ((hprofile.comp (by fun_prop)).aestronglyMeasurable)
    filter_upwards [] with z
    simpa only [Real.norm_eq_abs, travelingWave] using hbound (z.1 - speed * z.2)
  have hpositive := hproduct.mono_set
    (show (univ : Set ℝ) ×ˢ Ioi (0 : ℝ) ⊆ forwardSpacetimeHalfspace by
      intro z hz
      exact ⟨hz.1, (show (0 : ℝ) ≤ z.2 from hz.2.le)⟩)
  refine hpositive.congr ?_
  filter_upwards [ae_restrict_mem
    ((MeasurableSet.univ : MeasurableSet (univ : Set ℝ)).prod
      (measurableSet_Ioi : MeasurableSet (Ioi (0 : ℝ))))] with z hz
  rw [halfspace_fderivWithin_eq test z.1 z.2 hz.2]

/-- The initial boundary term is integrable without any condition on the
off-halfspace values of the test. -/
theorem travelingWave_weakTestOnHalfspace_initial_integrable
    (profile : ℝ → ℝ) (hprofile : Measurable profile)
    (B : ℝ) (hbound : ∀ x, |profile x| ≤ B)
    (test : ℝ × ℝ → ℝ) (htest : ContinuousOn test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    Integrable (fun x => profile x * test (x, 0)) := by
  have hslice : Continuous (fun x : ℝ => test (x, 0)) := by
    apply continuousOn_univ.mp
    exact htest.comp (by fun_prop) (by intro x hx; simp [forwardSpacetimeHalfspace])
  have hsliceSupport : HasCompactSupport (fun x : ℝ => test (x, 0)) := by
    refine HasCompactSupport.of_support_subset_isCompact
      (hsupport.image continuous_fst) ?_
    intro x hx
    refine ⟨(x, 0), subset_tsupport (forwardSpacetimeHalfspace.indicator test) ?_, rfl⟩
    simpa [forwardSpacetimeHalfspace] using hx
  apply (hslice.integrable_of_hasCompactSupport hsliceSupport).bdd_mul
    hprofile.aestronglyMeasurable
  filter_upwards [] with x
  simpa only [Real.norm_eq_abs] using hbound x

/-- Forward weak transport for every compact C¹ test on the closed forward
halfspace. Ordinary derivative values on the initial face are immaterial. -/
theorem travelingWave_forward_weakTestOnHalfspace_directional
    (profile : ℝ → ℝ) (speed : ℝ) (hprofile : Measurable profile)
    (B : ℝ) (hbound : ∀ x, |profile x| ≤ B)
    (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    (∫ t in Ici (0 : ℝ), ∫ x,
      travelingWave profile speed x t * fderiv ℝ test (x, t) (speed, 1)) +
      (∫ x, profile x * test (x, 0)) = 0 := by
  classical
  let T : Set (ℝ × ℝ) := Ici 0 ×ˢ univ
  let D : ℝ × ℝ → ℝ := fun z => fderivWithin ℝ test forwardSpacetimeHalfspace z (speed, 1)
  let e := halfspaceCharacteristicCoordinates speed
  have hmap : MapsTo e T forwardSpacetimeHalfspace := fun z hz => ⟨mem_univ _, hz.1⟩
  have hDcont : ContinuousOn (fun z => D (e z)) T :=
    (halfspace_direction_continuousOn test htest (speed, 1)).comp e.continuous.continuousOn hmap
  have hDsupport : HasCompactSupport (T.indicator (fun z => D (e z))) := by
    have hcompact := (halfspace_direction_hasCompactSupport forwardSpacetimeHalfspace
      test hsupport (speed, 1)).comp_homeomorph e
    have heq : T.indicator (fun z => D (e z)) = (forwardSpacetimeHalfspace.indicator D) ∘ e := by
      funext z
      by_cases hz : 0 ≤ z.1 <;>
        simp [T, forwardSpacetimeHalfspace, e, halfspaceCharacteristicCoordinates, hz]
    rw [heq]
    exact hcompact
  have hDint : IntegrableOn (fun z => D (e z)) T :=
    halfspace_integrableOn_of_indicator_support T (isClosed_Ici.prod isClosed_univ)
      _ hDcont hDsupport
  have hpositive := hDint.mono_set
    (show Ioi (0 : ℝ) ×ˢ (univ : Set ℝ) ⊆ T by
      intro z hz
      exact ⟨(show (0 : ℝ) ≤ z.1 from hz.1.le), hz.2⟩)
  have hF : IntegrableOn (fun z : ℝ × ℝ => profile z.2 * D (e z))
      (Ioi (0 : ℝ) ×ˢ univ) := by
    apply hpositive.bdd_mul (hprofile.comp measurable_snd).aestronglyMeasurable
    filter_upwards [] with z
    simpa only [Real.norm_eq_abs] using hbound z.2
  have hprod : Integrable (Function.uncurry (fun t y : ℝ =>
      profile y * D (y + speed * t, t)))
      ((volume.restrict (Ioi (0 : ℝ))).prod volume) := by
    rw [Measure.restrict_prod_eq_prod_univ]
    exact hF
  have htranslate (t : ℝ) :
      (∫ x, travelingWave profile speed x t * D (x, t)) =
        ∫ y, profile y * D (y + speed * t, t) := by
    simpa only [travelingWave, add_sub_cancel_right] using
      (integral_add_right_eq_self
        (fun x => profile (x - speed * t) * D (x, t)) (speed * t)).symm
  have hwithin :
      (∫ t in Ioi (0 : ℝ), ∫ x, travelingWave profile speed x t * D (x, t)) =
        -(∫ x, profile x * test (x, 0)) := by
    simp_rw [htranslate]
    rw [integral_integral_swap hprod]
    simp_rw [D, integral_const_mul,
      halfspace_test_curve_integral test htest hsupport speed, mul_neg]
    exact integral_neg _
  have hordinary :
      (∫ t in Ioi (0 : ℝ), ∫ x,
        travelingWave profile speed x t * fderiv ℝ test (x, t) (speed, 1)) =
        -(∫ x, profile x * test (x, 0)) := by
    calc
      _ = ∫ t in Ioi (0 : ℝ), ∫ x, travelingWave profile speed x t * D (x, t) := by
        apply integral_congr_ae
        filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
        apply integral_congr_ae
        filter_upwards [] with x
        simp only [D, halfspace_fderivWithin_eq test x t ht]
      _ = _ := hwithin
  rw [integral_Ici_eq_integral_Ioi, hordinary]
  exact neg_add_cancel _

/-- The usual whole-line transport weak identity for compact C¹ tests given
only on the closed forward halfspace, with the initial boundary term retained. -/
theorem travelingWave_forward_weakTestOnHalfspace
    (profile : ℝ → ℝ) (speed : ℝ) (hprofile : Measurable profile)
    (B : ℝ) (hbound : ∀ x, |profile x| ≤ B)
    (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    (∫ t in Ici (0 : ℝ), ∫ x,
      travelingWave profile speed x t *
        (fderiv ℝ test (x, t) (0, 1) + speed * fderiv ℝ test (x, t) (1, 0))) +
      (∫ x, profile x * test (x, 0)) = 0 := by
  have hspace (t : ℝ) :
      (∫ x, travelingWave profile speed x t * fderiv ℝ test (x, t) (speed, 1)) =
        ∫ x, travelingWave profile speed x t *
          (fderiv ℝ test (x, t) (0, 1) + speed * fderiv ℝ test (x, t) (1, 0)) := by
    apply integral_congr_ae
    filter_upwards [] with x
    rw [transport_test_direction_eq test speed x t]
  simpa only [hspace] using
    travelingWave_forward_weakTestOnHalfspace_directional profile speed hprofile B hbound
      test htest hsupport

end NumStability

namespace NumStability

/-- The within derivative of a forward test in a fixed direction, extended by
zero outside the forward halfspace. Coordinates are `(space, time)`. -/
def forwardTestDerivative (test : ℝ × ℝ → ℝ) (v : ℝ × ℝ) : ℝ × ℝ → ℝ :=
  forwardSpacetimeHalfspace.indicator
    (fun z => fderivWithin ℝ test forwardSpacetimeHalfspace z v)

theorem forwardTestDerivative_hasCompactSupport
    (test : ℝ × ℝ → ℝ)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test))
    (v : ℝ × ℝ) : HasCompactSupport (forwardTestDerivative test v) :=
  halfspace_direction_hasCompactSupport forwardSpacetimeHalfspace test hsupport v

theorem forwardTestDerivative_integrable
    (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test))
    (v : ℝ × ℝ) : Integrable (forwardTestDerivative test v) :=
  (halfspace_direction_integrableOn test htest hsupport v).integrable_indicator
    forwardSpacetimeHalfspace_isClosed.measurableSet

theorem forwardTestDerivative_eq_fderiv
    (test : ℝ × ℝ → ℝ) (v : ℝ × ℝ) (x t : ℝ) (htime : 0 < t) :
    forwardTestDerivative test v (x, t) = fderiv ℝ test (x, t) v := by
  simp only [forwardTestDerivative,
    indicator_of_mem (show (x, t) ∈ forwardSpacetimeHalfspace from ⟨mem_univ _, htime.le⟩),
    halfspace_fderivWithin_eq test x t htime]

theorem forwardTestDerivative_characteristic
    (test : ℝ × ℝ → ℝ) (speed : ℝ) (z : ℝ × ℝ) :
    forwardTestDerivative test (speed, 1) z =
      forwardTestDerivative test (0, 1) z + speed * forwardTestDerivative test (1, 0) z := by
  classical
  by_cases hz : z ∈ forwardSpacetimeHalfspace
  · simp only [forwardTestDerivative, indicator_of_mem hz]
    have hv : (speed, (1 : ℝ)) = (0, 1) + speed • ((1 : ℝ), 0) := by
      ext <;> simp
    rw [hv, map_add, map_smul]
    rfl
  · simp [forwardTestDerivative, hz]

theorem forwardTestDerivative_mul_integrable
    (q : ℝ × ℝ → ℝ) (hq : Measurable q) (B : ℝ) (hbound : ∀ z, |q z| ≤ B)
    (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test))
    (v : ℝ × ℝ) : Integrable (fun z => q z * forwardTestDerivative test v z) := by
  apply (forwardTestDerivative_integrable test htest hsupport v).bdd_mul
    hq.aestronglyMeasurable
  filter_upwards [] with z
  simpa only [Real.norm_eq_abs] using hbound z

/-- Convert the integrable, zero-extended test derivatives on the spacetime
plane to the ordinary-derivative weak integral on forward time. The required
integrability is an analytic hypothesis, not a weak-law hypothesis. -/
theorem forwardTestDerivative_spacetimeIntegral_pair
    (q g : ℝ × ℝ → ℝ) (test : ℝ × ℝ → ℝ)
    (hint : Integrable (fun z =>
      q z * forwardTestDerivative test (0, 1) z +
        g z * forwardTestDerivative test (1, 0) z)) :
    (∫ z : ℝ × ℝ, q z * forwardTestDerivative test (0, 1) z +
      g z * forwardTestDerivative test (1, 0) z) =
      ∫ t in Ici (0 : ℝ), ∫ x,
        q (x, t) * fderiv ℝ test (x, t) (0, 1) +
          g (x, t) * fderiv ℝ test (x, t) (1, 0) := by
  classical
  let F : ℝ × ℝ → ℝ := fun z => q z * forwardTestDerivative test (0, 1) z +
    g z * forwardTestDerivative test (1, 0) z
  calc
    _ = ∫ t, ∫ x, F (x, t) := integral_prod_symm F hint
    _ = ∫ t in Ici (0 : ℝ), ∫ x, F (x, t) := by
      symm
      apply setIntegral_eq_integral_of_forall_compl_eq_zero
      intro t ht
      simp [F, forwardTestDerivative, forwardSpacetimeHalfspace, ht]
    _ = ∫ t in Ioi (0 : ℝ), ∫ x, F (x, t) := integral_Ici_eq_integral_Ioi
    _ = ∫ t in Ioi (0 : ℝ), ∫ x,
        q (x, t) * fderiv ℝ test (x, t) (0, 1) +
          g (x, t) * fderiv ℝ test (x, t) (1, 0) := by
      apply integral_congr_ae
      filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
      apply integral_congr_ae
      filter_upwards [] with x
      simp only [F, forwardTestDerivative_eq_fderiv test _ x t ht]
    _ = _ := integral_Ici_eq_integral_Ioi.symm

/-- The same forward transport law as the iterated weak-test theorem, with the
test derivative indicated on the spacetime plane. This form permits parameter
Fubini for finite superpositions of transported profiles. -/
theorem travelingWave_forward_weakTestOnHalfspace_spacetime
    (profile : ℝ → ℝ) (speed : ℝ) (hprofile : Measurable profile)
    (B : ℝ) (hbound : ∀ x, |profile x| ≤ B)
    (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    (∫ z : ℝ × ℝ, travelingWave profile speed z.1 z.2 *
      forwardTestDerivative test (speed, 1) z) +
      (∫ x, profile x * test (x, 0)) = 0 := by
  let q : ℝ × ℝ → ℝ := fun z => travelingWave profile speed z.1 z.2
  have hint : Integrable (fun z => q z * forwardTestDerivative test (speed, 1) z) :=
    forwardTestDerivative_mul_integrable q (hprofile.comp (by fun_prop)) B
      (fun z => hbound (z.1 - speed * z.2)) test htest hsupport (speed, 1)
  have heq (z : ℝ × ℝ) :
      q z * forwardTestDerivative test (speed, 1) z =
        q z * forwardTestDerivative test (0, 1) z +
          (speed * q z) * forwardTestDerivative test (1, 0) z := by
    rw [forwardTestDerivative_characteristic test speed z]
    simp only [mul_add, mul_assoc, mul_left_comm]
  have hpair : Integrable (fun z => q z * forwardTestDerivative test (0, 1) z +
      (speed * q z) * forwardTestDerivative test (1, 0) z) :=
    hint.congr (Eventually.of_forall heq)
  have hplane :
      (∫ z : ℝ × ℝ, q z * forwardTestDerivative test (speed, 1) z) =
        ∫ t in Ici (0 : ℝ), ∫ x, q (x, t) *
          (fderiv ℝ test (x, t) (0, 1) + speed * fderiv ℝ test (x, t) (1, 0)) := by
    calc
      _ = ∫ z : ℝ × ℝ, q z * forwardTestDerivative test (0, 1) z +
          (speed * q z) * forwardTestDerivative test (1, 0) z :=
        integral_congr_ae (Eventually.of_forall heq)
      _ = _ := by
        rw [forwardTestDerivative_spacetimeIntegral_pair q (fun z => speed * q z) test hpair]
        apply integral_congr_ae
        filter_upwards [] with t
        apply integral_congr_ae
        filter_upwards [] with x
        simp only [mul_add, mul_assoc, mul_left_comm]
  rw [hplane]
  exact travelingWave_forward_weakTestOnHalfspace profile speed hprofile B hbound
    test htest hsupport

end NumStability
