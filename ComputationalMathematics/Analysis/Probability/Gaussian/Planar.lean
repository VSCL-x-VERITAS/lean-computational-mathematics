import Mathlib.Analysis.SpecialFunctions.PolarCoord
import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.Probability.Distributions.Gaussian.Real

/-!
# Planar standard-Gaussian density

Reusable measure and polar-coordinate identities for two independent standard
real Gaussian variables.  These facts are source-independent and support both
random-matrix calculations and Gaussian hyperplane rounding.
-/

noncomputable section

namespace NumStability.Analysis.Probability.Gaussian

open Filter MeasureTheory ProbabilityTheory Set

open scoped ENNReal

/-- The elementary radial antiderivative used after a planar Gaussian polar
change of variables. -/
theorem integral_Ioi_mul_exp_neg_sq_div_two (a : ℝ) :
    ∫ r in Ioi a, r * Real.exp (-(r ^ 2) / 2) =
      Real.exp (-(a ^ 2) / 2) := by
  let F : ℝ → ℝ := fun r => -Real.exp (-(r ^ 2) / 2)
  have hderiv : ∀ r : ℝ, HasDerivAt F
      (r * Real.exp (-(r ^ 2) / 2)) r := by
    intro r
    convert (((hasDerivAt_pow 2 r).neg.div_const 2).exp.neg) using 1
    norm_num [F]
    ring
  have hint : IntegrableOn (fun r : ℝ =>
      r * Real.exp (-(r ^ 2) / 2)) (Ioi a) := by
    have hbase : IntegrableOn
        (fun r : ℝ => r * Real.exp (-(1 / 2) * r ^ 2)) (Ioi a) :=
      (integrable_mul_exp_neg_mul_sq (show (0 : ℝ) < 1 / 2 by norm_num)).integrableOn
    refine hbase.congr_fun ?_ measurableSet_Ioi
    intro r _hr
    ring_nf
  have hlim : Tendsto F atTop (nhds 0) := by
    have hsq : Tendsto (fun r : ℝ => -(r ^ 2) / 2) atTop atBot := by
      convert (tendsto_pow_atTop (by norm_num : (2 : ℕ) ≠ 0)).const_mul_atTop_of_neg
        (show (-1 / 2 : ℝ) < 0 by norm_num) using 1
      ring
    simpa [F] using (Real.tendsto_exp_atBot.comp hsq).neg
  simpa [F] using integral_Ioi_of_hasDerivAt_of_tendsto'
    (fun r _ => hderiv r) hint hlim

/-- Convert a measurable event under two independent standard Gaussians to
the corresponding ordinary density integral. -/
theorem gaussianRealProd_real_apply (s : Set (ℝ × ℝ))
    (hs : MeasurableSet s) :
    ((gaussianReal 0 1).prod (gaussianReal 0 1)).real s =
      ∫ p in s,
        gaussianPDFReal 0 1 p.1 * gaussianPDFReal 0 1 p.2 := by
  rw [gaussianReal_of_var_ne_zero 0 (by norm_num)]
  rw [prod_withDensity
    (measurable_gaussianPDF 0 1) (measurable_gaussianPDF 0 1)]
  rw [measureReal_def, withDensity_apply _ hs]
  rw [← integral_toReal (f := fun p : ℝ × ℝ =>
      gaussianPDF 0 1 p.1 * gaussianPDF 0 1 p.2)
    (μ := (volume.prod volume).restrict s)
    (((measurable_gaussianPDF 0 1).comp measurable_fst).mul
      ((measurable_gaussianPDF 0 1).comp measurable_snd) |>.aemeasurable)
    (ae_of_all _ fun p => ENNReal.mul_lt_top gaussianPDF_lt_top gaussianPDF_lt_top)]
  apply integral_congr_ae
  filter_upwards with p
  simp [toReal_gaussianPDF]

/-- The product of two standard-Gaussian densities becomes radial after the
polar-coordinate Jacobian is included. -/
theorem standardGaussianPairPDF_polar (r theta : ℝ) :
    r * (gaussianPDFReal 0 1 (r * Real.cos theta) *
      gaussianPDFReal 0 1 (r * Real.sin theta)) =
      r / (2 * Real.pi) * Real.exp (-(r ^ 2) / 2) := by
  simp only [gaussianPDFReal, NNReal.coe_one, mul_one, sub_zero]
  rw [show r *
      ((Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-(r * Real.cos theta) ^ 2 / 2) *
        ((Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-(r * Real.sin theta) ^ 2 / 2))) =
      r * (Real.sqrt (2 * Real.pi))⁻¹ *
        (Real.sqrt (2 * Real.pi))⁻¹ *
        (Real.exp (-(r * Real.cos theta) ^ 2 / 2) *
          Real.exp (-(r * Real.sin theta) ^ 2 / 2)) by ring]
  rw [← Real.exp_add]
  have harg :
      (-(r * Real.cos theta) ^ 2 / 2 +
        -(r * Real.sin theta) ^ 2 / 2) = -(r ^ 2) / 2 := by
    calc
      _ = -(r ^ 2) * (Real.cos theta ^ 2 + Real.sin theta ^ 2) / 2 := by
        ring
      _ = _ := by rw [Real.cos_sq_add_sin_sq]; ring
  rw [harg]
  have hsqrt : Real.sqrt (2 * Real.pi) ^ 2 = 2 * Real.pi := by
    rw [Real.sq_sqrt]
    positivity
  have hcoeff : (Real.sqrt (2 * Real.pi))⁻¹ *
      (Real.sqrt (2 * Real.pi))⁻¹ = (2 * Real.pi)⁻¹ := by
    rw [← mul_inv, ← pow_two, hsqrt]
  rw [show r * (Real.sqrt (2 * Real.pi))⁻¹ *
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(r ^ 2) / 2) =
      r * ((Real.sqrt (2 * Real.pi))⁻¹ *
        (Real.sqrt (2 * Real.pi))⁻¹) *
          Real.exp (-(r ^ 2) / 2) by ring]
  rw [hcoeff]
  rfl

/-- Under two independent standard Gaussians, any measurable event depending
only on the polar angle has probability equal to its angular Lebesgue measure
divided by `2π`.  The angle set is represented inside the principal interval
`(-π, π)` used by `polarCoord`. -/
theorem gaussianRealProd_real_of_polar_angular
    (s : Set (ℝ × ℝ)) (A : Set ℝ)
    (hs : MeasurableSet s) (hA : MeasurableSet A)
    (hA_sub : A ⊆ Ioo (-Real.pi) Real.pi)
    (hpolar : ∀ p ∈ polarCoord.target,
      (polarCoord.symm p ∈ s ↔ p.2 ∈ A)) :
    ((gaussianReal 0 1).prod (gaussianReal 0 1)).real s =
      volume.real A / (2 * Real.pi) := by
  rw [gaussianRealProd_real_apply s hs]
  rw [← integral_indicator hs]
  rw [← integral_comp_polarCoord_symm]
  let d : ℝ × ℝ → ℝ := fun p =>
    gaussianPDFReal 0 1 p.1 * gaussianPDFReal 0 1 p.2
  let g : ℝ → ℝ := fun r =>
    r / (2 * Real.pi) * Real.exp (-(r ^ 2) / 2)
  have hintegrand :
      (∫ p in polarCoord.target,
          p.1 • s.indicator d (polarCoord.symm p)) =
        ∫ p in polarCoord.target,
          g p.1 * A.indicator (fun _ : ℝ => (1 : ℝ)) p.2 := by
    apply setIntegral_congr_fun polarCoord.open_target.measurableSet
    intro p hp
    change p.1 • s.indicator d (polarCoord.symm p) =
      g p.1 * A.indicator (fun _ : ℝ => (1 : ℝ)) p.2
    by_cases hpA : p.2 ∈ A
    · rw [Set.indicator_of_mem ((hpolar p hp).2 hpA),
        Set.indicator_of_mem hpA]
      change p.1 * d (polarCoord.symm p) = g p.1 * 1
      simpa [d, g, polarCoord_symm_apply] using
        standardGaussianPairPDF_polar p.1 p.2
    · rw [Set.indicator_of_notMem (fun h => hpA ((hpolar p hp).1 h)),
        Set.indicator_of_notMem hpA]
      simp
  rw [hintegrand, polarCoord_target]
  have hprod :
      (∫ p in Ioi (0 : ℝ) ×ˢ Ioo (-Real.pi) Real.pi,
          g p.1 * A.indicator (fun _ : ℝ => (1 : ℝ)) p.2) =
        (∫ r in Ioi (0 : ℝ), g r) *
          ∫ theta in Ioo (-Real.pi) Real.pi,
            A.indicator (fun _ : ℝ => (1 : ℝ)) theta := by
    exact setIntegral_prod_mul g
      (A.indicator (fun _ : ℝ => (1 : ℝ)))
      (Ioi (0 : ℝ)) (Ioo (-Real.pi) Real.pi)
  rw [hprod]
  have hrad : (∫ r in Ioi (0 : ℝ), g r) = (2 * Real.pi)⁻¹ := by
    rw [show (∫ r in Ioi (0 : ℝ), g r) =
        (2 * Real.pi)⁻¹ *
          ∫ r in Ioi (0 : ℝ), r * Real.exp (-(r ^ 2) / 2) by
      rw [← integral_const_mul]
      apply setIntegral_congr_fun measurableSet_Ioi
      intro r _hr
      dsimp [g]
      rw [div_eq_mul_inv]
      ring]
    rw [integral_Ioi_mul_exp_neg_sq_div_two]
    norm_num
    rfl
  have hang :
      (∫ theta in Ioo (-Real.pi) Real.pi,
          A.indicator (fun _ : ℝ => (1 : ℝ)) theta) = volume.real A := by
    calc
      (∫ theta in Ioo (-Real.pi) Real.pi,
          A.indicator (fun _ : ℝ => (1 : ℝ)) theta) =
          ∫ theta : ℝ,
            A.indicator (fun _ : ℝ => (1 : ℝ)) theta
              ∂volume.restrict (Ioo (-Real.pi) Real.pi) := rfl
      _ = (volume.restrict (Ioo (-Real.pi) Real.pi)).real A := by
        simpa only [Pi.one_apply] using
          (integral_indicator_one
            (μ := volume.restrict (Ioo (-Real.pi) Real.pi)) hA)
      _ = volume.real A := by
        rw [measureReal_restrict_apply hA, inter_eq_left.mpr hA_sub]
  rw [hrad, hang]
  simp only [div_eq_mul_inv]
  ring

/-- The principal-angle region on which two planar half-space signs at
relative angle `theta ∈ [0, π]` disagree.  The second branch records the
wrap across the endpoint of the principal interval `(-π, π)`. -/
def oppositeCosPrincipalAngleSet (theta : ℝ) : Set ℝ :=
  if theta ≤ Real.pi / 2 then
    Ioo (-(Real.pi / 2)) (theta - Real.pi / 2) ∪
      Ioo (Real.pi / 2) (theta + Real.pi / 2)
  else
    (Ioo (-Real.pi) (theta - 3 * Real.pi / 2) ∪
      Ioo (-(Real.pi / 2)) (theta - Real.pi / 2)) ∪
        Ioo (Real.pi / 2) Real.pi

theorem measurableSet_oppositeCosPrincipalAngleSet (theta : ℝ) :
    MeasurableSet (oppositeCosPrincipalAngleSet theta) := by
  unfold oppositeCosPrincipalAngleSet
  split_ifs
  · exact measurableSet_Ioo.union measurableSet_Ioo
  · exact (measurableSet_Ioo.union measurableSet_Ioo).union measurableSet_Ioo

theorem oppositeCosPrincipalAngleSet_subset_principal
    {theta : ℝ} (htheta : theta ∈ Icc (0 : ℝ) Real.pi) :
    oppositeCosPrincipalAngleSet theta ⊆ Ioo (-Real.pi) Real.pi := by
  have htheta0 : 0 ≤ theta := htheta.1
  have hthetaPi : theta ≤ Real.pi := htheta.2
  intro x hx
  unfold oppositeCosPrincipalAngleSet at hx
  split_ifs at hx with hhalf
  · rcases hx with hx | hx
    · rcases hx with ⟨hx₁, hx₂⟩
      exact ⟨by linarith [Real.pi_pos], by linarith [Real.pi_pos]⟩
    · rcases hx with ⟨hx₁, hx₂⟩
      exact ⟨by linarith [Real.pi_pos], by linarith [Real.pi_pos]⟩
  · rcases hx with (hx | hx) | hx
    · rcases hx with ⟨hx₁, hx₂⟩
      exact ⟨hx₁, by linarith [Real.pi_pos]⟩
    · rcases hx with ⟨hx₁, hx₂⟩
      exact ⟨by linarith [Real.pi_pos], by linarith [Real.pi_pos]⟩
    · exact ⟨by linarith [hx.1, Real.pi_pos], hx.2⟩

/-- The disagreement region has angular length exactly twice the angle
between the two normals. -/
theorem volumeReal_oppositeCosPrincipalAngleSet
    {theta : ℝ} (htheta : theta ∈ Icc (0 : ℝ) Real.pi) :
    volume.real (oppositeCosPrincipalAngleSet theta) = 2 * theta := by
  have htheta0 : 0 ≤ theta := htheta.1
  have hthetaPi : theta ≤ Real.pi := htheta.2
  unfold oppositeCosPrincipalAngleSet
  split_ifs with hhalf
  · have hdisj : Disjoint
        (Ioo (-(Real.pi / 2)) (theta - Real.pi / 2))
        (Ioo (Real.pi / 2) (theta + Real.pi / 2)) := by
      rw [Set.disjoint_left]
      intro x hx₁ hx₂
      rcases hx₁ with ⟨hx₁l, hx₁u⟩
      rcases hx₂ with ⟨hx₂l, hx₂u⟩
      linarith
    rw [measureReal_union (μ := volume) hdisj measurableSet_Ioo
        measure_Ioo_lt_top.ne measure_Ioo_lt_top.ne,
      Real.volume_real_Ioo_of_le (by linarith [htheta.1]),
      Real.volume_real_Ioo_of_le (by linarith [htheta.1])]
    ring
  · have hgt : Real.pi / 2 < theta := lt_of_not_ge hhalf
    let A := Ioo (-Real.pi) (theta - 3 * Real.pi / 2)
    let B := Ioo (-(Real.pi / 2)) (theta - Real.pi / 2)
    let C := Ioo (Real.pi / 2) Real.pi
    have hAB : Disjoint A B := by
      rw [Set.disjoint_left]
      intro x hxA hxB
      rcases hxA with ⟨hxAl, hxAu⟩
      rcases hxB with ⟨hxBl, hxBu⟩
      linarith [htheta.2]
    have hAC : Disjoint A C := by
      rw [Set.disjoint_left]
      intro x hxA hxC
      rcases hxA with ⟨hxAl, hxAu⟩
      rcases hxC with ⟨hxCl, hxCu⟩
      linarith [htheta.2]
    have hBC : Disjoint B C := by
      rw [Set.disjoint_left]
      intro x hxB hxC
      rcases hxB with ⟨hxBl, hxBu⟩
      rcases hxC with ⟨hxCl, hxCu⟩
      linarith [htheta.2]
    change volume.real ((A ∪ B) ∪ C) = _
    rw [measureReal_union (μ := volume) (hAC.union_left hBC)
        measurableSet_Ioo
        (measure_union_lt_top measure_Ioo_lt_top measure_Ioo_lt_top).ne
        measure_Ioo_lt_top.ne,
      measureReal_union (μ := volume) hAB measurableSet_Ioo
        measure_Ioo_lt_top.ne measure_Ioo_lt_top.ne]
    dsimp [A, B, C]
    rw [Real.volume_real_Ioo_of_le (by linarith),
      Real.volume_real_Ioo_of_le (by linarith [htheta.1]),
      Real.volume_real_Ioo_of_le (by linarith [Real.pi_pos])]
    ring

theorem cos_neg_iff_of_mem_principal {x : ℝ}
    (hx : x ∈ Ioo (-Real.pi) Real.pi) :
    Real.cos x < 0 ↔ x < -(Real.pi / 2) ∨ Real.pi / 2 < x := by
  constructor
  · intro hcos
    by_contra h
    push_neg at h
    exact (not_lt_of_ge (Real.cos_nonneg_of_mem_Icc h) hcos)
  · rintro (hleft | hright)
    · have hneg := Real.cos_neg_of_pi_div_two_lt_of_lt
          (x := -x) (by linarith) (by linarith [hx.1, Real.pi_pos])
      simpa only [Real.cos_neg] using hneg
    · exact Real.cos_neg_of_pi_div_two_lt_of_lt hright
        (by linarith [hx.2, Real.pi_pos])

theorem cos_neg_iff_of_mem_neg_two_pi_pi {x : ℝ}
    (hx : x ∈ Ioo (-2 * Real.pi) Real.pi) :
    Real.cos x < 0 ↔
      (-(3 * Real.pi / 2) < x ∧ x < -(Real.pi / 2)) ∨
        Real.pi / 2 < x := by
  constructor
  · intro hcos
    by_cases hlow : -(3 * Real.pi / 2) < x
    · by_cases hright : Real.pi / 2 < x
      · exact Or.inr hright
      · left
        refine ⟨hlow, ?_⟩
        by_contra hmid
        have hnonneg : 0 ≤ Real.cos x :=
          Real.cos_nonneg_of_mem_Icc ⟨by linarith, by linarith⟩
        exact (not_lt_of_ge hnonneg hcos)
    · have hy : x + 2 * Real.pi ∈
          Icc (-(Real.pi / 2)) (Real.pi / 2) := by
        constructor <;> linarith [hx.1, Real.pi_pos]
      have hnonneg : 0 ≤ Real.cos (x + 2 * Real.pi) :=
        Real.cos_nonneg_of_mem_Icc hy
      rw [Real.cos_add_two_pi] at hnonneg
      exact (not_lt_of_ge hnonneg hcos).elim
  · rintro (hleft | hright)
    · rcases hleft with ⟨hlower, hupper⟩
      by_cases hpi : -Real.pi ≤ x
      · have hneg := Real.cos_neg_of_pi_div_two_lt_of_lt
            (x := -x) (by linarith) (by linarith [hlower])
        simpa only [Real.cos_neg] using hneg
      · have hneg := Real.cos_neg_of_pi_div_two_lt_of_lt
            (x := x + 2 * Real.pi) (by linarith) (by linarith [Real.pi_pos])
        rwa [Real.cos_add_two_pi] at hneg
    · exact Real.cos_neg_of_pi_div_two_lt_of_lt hright
        (by linarith [hx.2, Real.pi_pos])

/-- On the principal polar interval, the explicit angular set is exactly the
event that the signs of `cos phi` and `cos (phi - theta)` differ. -/
theorem mem_oppositeCosPrincipalAngleSet_iff
    {theta phi : ℝ} (htheta : theta ∈ Icc (0 : ℝ) Real.pi)
    (hphi : phi ∈ Ioo (-Real.pi) Real.pi)
    (hne_neg_pi_div_two : phi ≠ -(Real.pi / 2))
    (hne_shift_neg_three_pi_div_two :
      phi - theta ≠ -(3 * Real.pi / 2))
    (hne_shift_pi_div_two : phi - theta ≠ Real.pi / 2) :
    phi ∈ oppositeCosPrincipalAngleSet theta ↔
      (Real.cos phi < 0) ≠ (Real.cos (phi - theta) < 0) := by
  have hshift : phi - theta ∈ Ioo (-2 * Real.pi) Real.pi := by
    constructor <;> linarith [hphi.1, hphi.2, htheta.1, htheta.2]
  rw [cos_neg_iff_of_mem_principal hphi,
    cos_neg_iff_of_mem_neg_two_pi_pi hshift]
  unfold oppositeCosPrincipalAngleSet
  split_ifs <;> simp only [Set.mem_union, Set.mem_Ioo] <;> grind

/-- The exact principal-angle sign-disagreement event.  It differs from
`oppositeCosPrincipalAngleSet` only at finitely many boundary angles. -/
def oppositeCosAngleEvent (theta : ℝ) : Set ℝ :=
  {phi | phi ∈ Ioo (-Real.pi) Real.pi ∧
    (Real.cos phi < 0) ≠ (Real.cos (phi - theta) < 0)}

theorem measurableSet_oppositeCosAngleEvent (theta : ℝ) :
    MeasurableSet (oppositeCosAngleEvent theta) := by
  have hleft : MeasurableSet {phi : ℝ | Real.cos phi < 0} :=
    measurableSet_lt (by fun_prop) measurable_const
  have hright : MeasurableSet
      {phi : ℝ | Real.cos (phi - theta) < 0} :=
    measurableSet_lt (by fun_prop) measurable_const
  apply measurableSet_Ioo.inter
  convert (hleft.diff hright).union (hright.diff hleft) using 1
  ext phi
  change ((Real.cos phi < 0) ≠ (Real.cos (phi - theta) < 0)) ↔
    (Real.cos phi < 0 ∧ ¬ Real.cos (phi - theta) < 0) ∨
      (Real.cos (phi - theta) < 0 ∧ ¬ Real.cos phi < 0)
  tauto

theorem oppositeCosAngleEvent_subset_principal (theta : ℝ) :
    oppositeCosAngleEvent theta ⊆ Ioo (-Real.pi) Real.pi := by
  intro phi hphi
  exact hphi.1

/-- The exact sign-disagreement event has angular length `2 * theta`; the
finitely many boundary angles separating it from the open-interval model are
Lebesgue-null. -/
theorem volumeReal_oppositeCosAngleEvent
    {theta : ℝ} (htheta : theta ∈ Icc (0 : ℝ) Real.pi) :
    volume.real (oppositeCosAngleEvent theta) = 2 * theta := by
  have hae : oppositeCosAngleEvent theta =ᵐ[volume]
      oppositeCosPrincipalAngleSet theta := by
    filter_upwards [
      (volume : Measure ℝ).ae_ne (-(Real.pi / 2)),
      (volume : Measure ℝ).ae_ne (theta - 3 * Real.pi / 2),
      (volume : Measure ℝ).ae_ne (theta + Real.pi / 2)] with phi hneg hshiftNeg hshiftPos
    apply propext
    by_cases hphi : phi ∈ Ioo (-Real.pi) Real.pi
    · have hshiftNeg' : phi - theta ≠ -(3 * Real.pi / 2) := by
        intro h
        apply hshiftNeg
        linarith
      have hshiftPos' : phi - theta ≠ Real.pi / 2 := by
        intro h
        apply hshiftPos
        linarith
      change (phi ∈ Ioo (-Real.pi) Real.pi ∧
          (Real.cos phi < 0) ≠ (Real.cos (phi - theta) < 0)) ↔
        phi ∈ oppositeCosPrincipalAngleSet theta
      rw [mem_oppositeCosPrincipalAngleSet_iff htheta hphi hneg
        hshiftNeg' hshiftPos']
      exact and_iff_right hphi
    · have hexplicit : phi ∉ oppositeCosPrincipalAngleSet theta := by
        intro hm
        exact hphi (oppositeCosPrincipalAngleSet_subset_principal htheta hm)
      change (phi ∈ Ioo (-Real.pi) Real.pi ∧
          (Real.cos phi < 0) ≠ (Real.cos (phi - theta) < 0)) ↔
        phi ∈ oppositeCosPrincipalAngleSet theta
      constructor
      · intro hevent
        exact (hphi hevent.1).elim
      · intro hm
        exact (hexplicit hm).elim
  rw [measureReal_def, measure_congr hae]
  exact volumeReal_oppositeCosPrincipalAngleSet htheta

/-- The Cartesian event that two planar half-spaces with relative angle
`theta` give opposite strict signs. -/
def standardGaussianPairOppositeSet (theta : ℝ) : Set (ℝ × ℝ) :=
  {p | (p.1 < 0) ≠
    (Real.cos theta * p.1 + Real.sin theta * p.2 < 0)}

theorem measurableSet_standardGaussianPairOppositeSet (theta : ℝ) :
    MeasurableSet (standardGaussianPairOppositeSet theta) := by
  have hleft : MeasurableSet {p : ℝ × ℝ | p.1 < 0} :=
    measurableSet_lt measurable_fst measurable_const
  have hright : MeasurableSet {p : ℝ × ℝ |
      Real.cos theta * p.1 + Real.sin theta * p.2 < 0} :=
    measurableSet_lt (by fun_prop) measurable_const
  convert (hleft.diff hright).union (hright.diff hleft) using 1
  ext p
  change ((p.1 < 0) ≠
      (Real.cos theta * p.1 + Real.sin theta * p.2 < 0)) ↔
    (p.1 < 0 ∧ ¬ Real.cos theta * p.1 + Real.sin theta * p.2 < 0) ∨
      (Real.cos theta * p.1 + Real.sin theta * p.2 < 0 ∧ ¬ p.1 < 0)
  tauto

/-- The planar Gaussian wedge formula: two standard independent Gaussian
coordinates fall on opposite sides of normals separated by `theta` with
probability `theta / π`. -/
theorem standardGaussianPairOppositeProbability
    {theta : ℝ} (htheta : theta ∈ Icc (0 : ℝ) Real.pi) :
    ((gaussianReal 0 1).prod (gaussianReal 0 1)).real
        (standardGaussianPairOppositeSet theta) = theta / Real.pi := by
  rw [gaussianRealProd_real_of_polar_angular
    (standardGaussianPairOppositeSet theta) (oppositeCosAngleEvent theta)
    (measurableSet_standardGaussianPairOppositeSet theta)
    (measurableSet_oppositeCosAngleEvent theta)
    (oppositeCosAngleEvent_subset_principal theta)]
  · rw [volumeReal_oppositeCosAngleEvent htheta]
    field_simp [Real.pi_ne_zero]
  · rintro ⟨r, phi⟩ hp
    rcases hp with ⟨hr, hphi⟩
    change 0 < r at hr
    change phi ∈ Ioo (-Real.pi) Real.pi at hphi
    change ((r * Real.cos phi < 0) ≠
        (Real.cos theta * (r * Real.cos phi) +
          Real.sin theta * (r * Real.sin phi) < 0)) ↔
      phi ∈ oppositeCosAngleEvent theta
    have hlinear :
        Real.cos theta * (r * Real.cos phi) +
            Real.sin theta * (r * Real.sin phi) =
          r * Real.cos (phi - theta) := by
      rw [Real.cos_sub]
      ring
    rw [hlinear]
    have hmul (x : ℝ) : r * x < 0 ↔ x < 0 := by
      rw [mul_neg_iff]
      simp only [hr, true_and, not_lt_of_ge hr.le, false_and, or_false]
    rw [hmul, hmul]
    exact (and_iff_right hphi).symm

/-- Transport the planar wedge formula to any pair of independent random
variables with standard one-dimensional Gaussian laws. -/
theorem oppositeProbability_of_indep_standardGaussian
    {Omega : Type*} [MeasurableSpace Omega] (mu : Measure Omega)
    [IsProbabilityMeasure mu] (X Y : Omega → ℝ)
    (hX : HasLaw X (gaussianReal 0 1) mu)
    (hY : HasLaw Y (gaussianReal 0 1) mu)
    (hXY : IndepFun X Y mu)
    {theta : ℝ} (htheta : theta ∈ Icc (0 : ℝ) Real.pi) :
    mu.real {omega |
        (X omega < 0) ≠
          (Real.cos theta * X omega + Real.sin theta * Y omega < 0)} =
      theta / Real.pi := by
  let pair : Omega → ℝ × ℝ := fun omega => (X omega, Y omega)
  have hpair : AEMeasurable pair mu := hX.aemeasurable.prodMk hY.aemeasurable
  have hjoint : Measure.map pair mu =
      (gaussianReal 0 1).prod (gaussianReal 0 1) := by
    have hfactor := (indepFun_iff_map_prod_eq_prod_map_map
      hX.aemeasurable hY.aemeasurable).mp hXY
    rw [hX.map_eq, hY.map_eq] at hfactor
    exact hfactor
  change mu.real (pair ⁻¹' standardGaussianPairOppositeSet theta) = _
  rw [measureReal_def,
    ← Measure.map_apply_of_aemeasurable hpair
      (measurableSet_standardGaussianPairOppositeSet theta),
    hjoint]
  exact standardGaussianPairOppositeProbability htheta

end NumStability.Analysis.Probability.Gaussian
