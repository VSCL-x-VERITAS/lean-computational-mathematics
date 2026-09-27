/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Topology.Instances.AddCircle.Defs
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Analysis.Calculus.FDeriv.Prod
import ComputationalMathematics.Analysis.Calculus.Piecewise

/-!
# Local derivatives of periodically extended real functions

On each open period cell the interval-modulo map is locally a translation.
The seam case additionally needs compatible endpoint values and derivatives.
-/

namespace NumStability

theorem hasFDerivAt_if_of_eq
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup F] [NormedSpace ℝ F]
    (pred : E → Prop) [DecidablePred pred]
    {f g : E → F} {x : E} {L : E →L[ℝ] F}
    (hf : HasFDerivAt f L x) (hg : HasFDerivAt g L x)
    (heq : f x = g x) :
    HasFDerivAt (fun y => if pred y then f y else g y) L x := by
  have h₁ : HasFDerivWithinAt (fun y => if pred y then f y else g y)
      L {y | pred y} x := by
    apply hf.hasFDerivWithinAt.congr
    · intro y hy
      simp only [Set.mem_setOf_eq] at hy
      simp only [if_pos hy]
    · split_ifs <;> simp [heq]
  have h₂ : HasFDerivWithinAt (fun y => if pred y then f y else g y)
      L {y | pred y}ᶜ x := by
    apply hg.hasFDerivWithinAt.congr
    · intro y hy
      simp only [Set.mem_compl_iff, Set.mem_setOf_eq] at hy
      simp only [if_neg hy]
    · split_ifs <;> simp [heq]
  exact hasFDerivWithinAt_univ.mp (by
    simpa only [Set.union_compl_self] using h₁.union h₂)

theorem continuousAt_if_of_eq
    {E F : Type*} [TopologicalSpace E] [TopologicalSpace F]
    (pred : E → Prop) [DecidablePred pred]
    {f g : E → F} {x : E}
    (hf : ContinuousAt f x) (hg : ContinuousAt g x)
    (heq : f x = g x) :
    ContinuousAt (fun y => if pred y then f y else g y) x := by
  have h₁ : ContinuousWithinAt (fun y => if pred y then f y else g y)
      {y | pred y} x := by
    apply hf.continuousWithinAt.congr
    · intro y hy
      simp only [Set.mem_setOf_eq] at hy
      simp only [if_pos hy]
    · split_ifs <;> simp [heq]
  have h₂ : ContinuousWithinAt (fun y => if pred y then f y else g y)
      {y | pred y}ᶜ x := by
    apply hg.continuousWithinAt.congr
    · intro y hy
      simp only [Set.mem_compl_iff, Set.mem_setOf_eq] at hy
      simp only [if_neg hy]
    · split_ifs <;> simp [heq]
  simpa only [Set.union_compl_self, continuousWithinAt_univ] using h₁.union h₂

theorem toIcoMod_eventuallyEq_piecewise
    (p a x : ℝ) (hp : 0 < p) :
    (toIcoMod hp a) =ᶠ[nhds x]
      (fun y => if y < x then y - toIocDiv hp a x • p
        else y - toIcoDiv hp a x • p) := by
  rw [← nhdsLT_sup_nhdsGE, Filter.EventuallyEq, Filter.eventually_sup]
  constructor
  · filter_upwards [eventuallyEq_toIcoDiv_nhdsLT hp a x,
      self_mem_nhdsWithin] with y hy hyx
    have hylt : y < x := hyx
    simp [toIcoMod, hy, if_pos hylt]
  · filter_upwards [eventuallyEq_toIcoDiv_nhdsGE hp a x,
      self_mem_nhdsWithin] with y hy hyx
    have hyle : x ≤ y := hyx
    simp [toIcoMod, hy, if_neg (not_lt.mpr hyle)]

theorem continuousAt_comp_toIcoMod_prod
    {E : Type*} [TopologicalSpace E]
    (F : (ℝ × ℝ) → E) (p a x t : ℝ) (hp : 0 < p)
    (hvalue : F (a, t) = F (a + p, t))
    (hcont : ∀ y, a ≤ y → y ≤ a + p →
      ContinuousAt F (y, t)) :
    ContinuousAt (fun z : ℝ × ℝ => F (toIcoMod hp a z.1, z.2))
      (x, t) := by
  by_cases hx : x ≡ a [PMOD p]
  · let k := toIcoDiv hp a x
    let j := toIocDiv hp a x
    have hxa : x - k • p = a := by
      simpa only [toIcoMod, k] using
        (AddCommGroup.modEq_iff_toIcoMod_eq_left hp).mp hx.symm
    have hxb : x - j • p = a + p := by
      simpa only [toIocMod, j] using
        (AddCommGroup.modEq_iff_toIocMod_eq_right hp).mp hx.symm
    have hpair (z : ℝ × ℝ) (n : ℤ) :
        z - (n • p, 0) = (z.1 - n • p, z.2) := by
      ext <;> simp
    have hleft : ContinuousAt
        (fun z : ℝ × ℝ => F (z - (j • p, 0))) (x, t) := by
      have hpoint : (x, t) - (j • p, 0) = (a + p, t) := by
        ext
        · exact hxb
        · simp
      have hF := hcont (a + p) (by linarith) (le_refl _)
      rw [← hpoint] at hF
      have hshift : ContinuousAt
          (fun z : ℝ × ℝ => z - (j • p, 0)) (x, t) :=
        continuousAt_id.sub continuousAt_const
      change ContinuousAt F
        ((fun z : ℝ × ℝ => z - (j • p, 0)) (x, t)) at hF
      simpa only [Function.comp_def] using
        (ContinuousAt.comp (f := fun z : ℝ × ℝ => z - (j • p, 0)) hF hshift)
    have hright : ContinuousAt
        (fun z : ℝ × ℝ => F (z - (k • p, 0))) (x, t) := by
      have hpoint : (x, t) - (k • p, 0) = (a, t) := by
        ext
        · exact hxa
        · simp
      have hF := hcont a (le_refl _) (by linarith)
      rw [← hpoint] at hF
      have hshift : ContinuousAt
          (fun z : ℝ × ℝ => z - (k • p, 0)) (x, t) :=
        continuousAt_id.sub continuousAt_const
      change ContinuousAt F
        ((fun z : ℝ × ℝ => z - (k • p, 0)) (x, t)) at hF
      simpa only [Function.comp_def] using
        (ContinuousAt.comp (f := fun z : ℝ × ℝ => z - (k • p, 0)) hF hshift)
    have hglue : ContinuousAt
        (fun z : ℝ × ℝ => if z.1 < x then F (z - (j • p, 0))
          else F (z - (k • p, 0))) (x, t) := by
      apply continuousAt_if_of_eq (fun z : ℝ × ℝ => z.1 < x)
        hleft hright
      rw [hpair (x, t) j, hpair (x, t) k]
      change F (x - j • p, t) = F (x - k • p, t)
      rw [hxb, hxa]
      exact hvalue.symm
    have heventual :
        (fun z : ℝ × ℝ => F (toIcoMod hp a z.1, z.2)) =ᶠ[nhds (x, t)]
          (fun z => if z.1 < x then F (z - (j • p, 0))
            else F (z - (k • p, 0))) := by
      have hfst : Filter.Tendsto (fun z : ℝ × ℝ => z.1)
          (nhds (x, t)) (nhds x) := continuous_fst.continuousAt
      have hmod := (toIcoMod_eventuallyEq_piecewise p a x hp).comp_tendsto hfst
      filter_upwards [hmod] with z hz
      simp only [Function.comp_def] at hz
      by_cases hzlt : z.1 < x
      · simp only [if_pos hzlt, hz]
        exact congrArg F (hpair z j).symm
      · simp only [if_neg hzlt, hz]
        exact congrArg F (hpair z k).symm
    exact hglue.congr_of_eventuallyEq heventual
  · have hcell := toIcoMod_mem_Ico hp a x
    have hmod1 : ContinuousAt (fun z : ℝ × ℝ =>
        toIcoMod hp a z.1) (x, t) :=
      show ContinuousAt (fun z : ℝ × ℝ => toIcoMod hp a z.1) (x, t) from
        ContinuousAt.comp (f := fun z : ℝ × ℝ => z.1)
          (continuousAt_toIcoMod hp a hx) continuous_fst.continuousAt
    have hmod : ContinuousAt (fun z : ℝ × ℝ =>
        (toIcoMod hp a z.1, z.2)) (x, t) :=
      hmod1.prodMk continuous_snd.continuousAt
    exact ContinuousAt.comp
      (f := fun z : ℝ × ℝ => (toIcoMod hp a z.1, z.2))
      (hcont (toIcoMod hp a x) hcell.1 hcell.2.le) hmod

theorem hasFDerivAt_comp_toIcoMod_seam
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (F : (ℝ × ℝ) → E) (p a x t : ℝ) (hp : 0 < p)
    (hx : x ≡ a [PMOD p])
    (L : (ℝ × ℝ) →L[ℝ] E)
    (hvalue : F (a, t) = F (a + p, t))
    (hleft : HasFDerivAt F L (a + p, t))
    (hright : HasFDerivAt F L (a, t)) :
    HasFDerivAt (fun z : ℝ × ℝ => F (toIcoMod hp a z.1, z.2))
      L (x, t) := by
  let k := toIcoDiv hp a x
  let j := toIocDiv hp a x
  have hxa : x - k • p = a := by
    simpa only [toIcoMod, k] using
      (AddCommGroup.modEq_iff_toIcoMod_eq_left hp).mp hx.symm
  have hxb : x - j • p = a + p := by
    simpa only [toIocMod, j] using
      (AddCommGroup.modEq_iff_toIocMod_eq_right hp).mp hx.symm
  have hshift (n : ℤ) : HasFDerivAt
      (fun z : ℝ × ℝ => z - (n • p, 0))
      (ContinuousLinearMap.id ℝ (ℝ × ℝ)) (x, t) :=
    (hasFDerivAt_id (x, t)).sub_const (n • p, 0)
  have hpair (z : ℝ × ℝ) (n : ℤ) :
      z - (n • p, 0) = (z.1 - n • p, z.2) := by
    ext <;> simp
  have hleft' : HasFDerivAt
      (fun z : ℝ × ℝ => F (z - (j • p, 0))) L (x, t) := by
    have hpoint : (x, t) - (j • p, 0) = (a + p, t) := by
      ext
      · exact hxb
      · simp
    rw [← hpoint] at hleft
    simpa only [Function.comp_def, ContinuousLinearMap.comp_id, hpair] using
      hleft.comp (x, t) (hshift j)
  have hright' : HasFDerivAt
      (fun z : ℝ × ℝ => F (z - (k • p, 0))) L (x, t) := by
    have hpoint : (x, t) - (k • p, 0) = (a, t) := by
      ext
      · exact hxa
      · simp
    rw [← hpoint] at hright
    simpa only [Function.comp_def, ContinuousLinearMap.comp_id, hpair] using
      hright.comp (x, t) (hshift k)
  have hglue : HasFDerivAt
      (fun z : ℝ × ℝ => if z.1 < x then F (z - (j • p, 0))
        else F (z - (k • p, 0))) L (x, t) := by
    apply hasFDerivAt_if_of_eq (fun z : ℝ × ℝ => z.1 < x)
      hleft' hright'
    rw [hpair (x, t) j, hpair (x, t) k]
    change F (x - j • p, t) = F (x - k • p, t)
    rw [hxb, hxa]
    exact hvalue.symm
  have heventual :
      (fun z : ℝ × ℝ => F (toIcoMod hp a z.1, z.2)) =ᶠ[nhds (x, t)]
        (fun z => if z.1 < x then F (z - (j • p, 0))
          else F (z - (k • p, 0))) := by
    have hfst : Filter.Tendsto (fun z : ℝ × ℝ => z.1)
        (nhds (x, t)) (nhds x) := continuous_fst.continuousAt
    have hmod := (toIcoMod_eventuallyEq_piecewise p a x hp).comp_tendsto
      hfst
    filter_upwards [hmod] with z hz
    simp only [Function.comp_def] at hz
    by_cases hzlt : z.1 < x
    · simp only [if_pos hzlt, hz]
      exact congrArg F (hpair z j).symm
    · simp only [if_neg hzlt, hz]
      exact congrArg F (hpair z k).symm
  exact hglue.congr_of_eventuallyEq heventual

theorem hasFDerivAt_comp_toIcoMod_offSeam
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (F : (ℝ × ℝ) → E) (p a x t : ℝ) (hp : 0 < p)
    (hx : ¬x ≡ a [PMOD p])
    (L : (ℝ × ℝ) →L[ℝ] E)
    (hF : HasFDerivAt F L (toIcoMod hp a x, t)) :
    HasFDerivAt (fun z : ℝ × ℝ => F (toIcoMod hp a z.1, z.2))
      L (x, t) := by
  let k := toIcoDiv hp a x
  have hshift : HasFDerivAt
      (fun z : ℝ × ℝ => z - (k • p, 0))
      (ContinuousLinearMap.id ℝ (ℝ × ℝ)) (x, t) :=
    (hasFDerivAt_id (x, t)).sub_const (k • p, 0)
  have hpair (z : ℝ × ℝ) :
      z - (k • p, 0) = (z.1 - k • p, z.2) := by
    ext <;> simp
  have hpoint : (x, t) - (k • p, 0) =
      (toIcoMod hp a x, t) := by
    simp only [hpair, toIcoMod, k]
  rw [← hpoint] at hF
  have htranslated : HasFDerivAt
      (fun z : ℝ × ℝ => F (z - (k • p, 0))) L (x, t) := by
    simpa only [Function.comp_def, ContinuousLinearMap.comp_id] using
      hF.comp (x, t) hshift
  have heventual :
      (fun z : ℝ × ℝ => F (toIcoMod hp a z.1, z.2)) =ᶠ[nhds (x, t)]
        (fun z => F (z - (k • p, 0))) := by
    have hfst : Filter.Tendsto (fun z : ℝ × ℝ => z.1)
        (nhds (x, t)) (nhds x) := continuous_fst.continuousAt
    have hmod := (eventuallyEq_toIcoDiv_nhds hp a hx).comp_tendsto hfst
    filter_upwards [hmod] with z hz
    simp only [Function.comp_def] at hz
    simp only [toIcoMod, hz, hpair, k]
  exact htranslated.congr_of_eventuallyEq heventual

/-- Joint differentiability of a periodic continuation at a fixed point.
At a seam, both the endpoint values and full derivatives must agree. -/
theorem differentiableAt_comp_toIcoMod_prod
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (F : (ℝ × ℝ) → E) (p a x t : ℝ) (hp : 0 < p)
    (hdiff : ∀ y, a ≤ y → y ≤ a + p →
      DifferentiableAt ℝ F (y, t))
    (hvalue : F (a, t) = F (a + p, t))
    (hmatch : fderiv ℝ F (a, t) = fderiv ℝ F (a + p, t)) :
    DifferentiableAt ℝ
      (fun z : ℝ × ℝ => F (toIcoMod hp a z.1, z.2)) (x, t) := by
  by_cases hx : x ≡ a [PMOD p]
  · exact (hasFDerivAt_comp_toIcoMod_seam F p a x t hp hx
      (fderiv ℝ F (a, t)) hvalue
      (hmatch ▸ (hdiff (a + p) (by linarith) (le_refl _)).hasFDerivAt)
      (hdiff a (le_refl _) (by linarith)).hasFDerivAt).differentiableAt
  · have hcell := toIcoMod_mem_Ico hp a x
    exact (hasFDerivAt_comp_toIcoMod_offSeam F p a x t hp hx
      (fderiv ℝ F (toIcoMod hp a x, t))
      (hdiff (toIcoMod hp a x) hcell.1 hcell.2.le).hasFDerivAt).differentiableAt

theorem fderiv_comp_toIcoMod_prod
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (F : (ℝ × ℝ) → E) (p a x t : ℝ) (hp : 0 < p)
    (hdiff : ∀ y, a ≤ y → y ≤ a + p →
      DifferentiableAt ℝ F (y, t))
    (hvalue : F (a, t) = F (a + p, t))
    (hmatch : fderiv ℝ F (a, t) = fderiv ℝ F (a + p, t)) :
    fderiv ℝ (fun z : ℝ × ℝ => F (toIcoMod hp a z.1, z.2)) (x, t) =
      fderiv ℝ F (toIcoMod hp a x, t) := by
  by_cases hx : x ≡ a [PMOD p]
  · have hrep : toIcoMod hp a x = a :=
      (AddCommGroup.modEq_iff_toIcoMod_eq_left hp).mp hx.symm
    rw [hrep]
    exact (hasFDerivAt_comp_toIcoMod_seam F p a x t hp hx
      (fderiv ℝ F (a, t)) hvalue
      (hmatch ▸ (hdiff (a + p) (by linarith) (le_refl _)).hasFDerivAt)
      (hdiff a (le_refl _) (by linarith)).hasFDerivAt).fderiv
  · exact (hasFDerivAt_comp_toIcoMod_offSeam F p a x t hp hx
      (fderiv ℝ F (toIcoMod hp a x, t))
      (hdiff (toIcoMod hp a x) (toIcoMod_mem_Ico hp a x).1
        (toIcoMod_mem_Ico hp a x).2.le).hasFDerivAt).fderiv

/-- Equality of both coordinate derivatives determines the full Fréchet
derivative of a jointly differentiable map on the real plane. -/
theorem fderiv_prod_eq_of_partial_derivatives
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (F : ℝ × ℝ → E) (a b t : ℝ) (dx dt : E)
    (hda : DifferentiableAt ℝ F (a, t))
    (hdb : DifferentiableAt ℝ F (b, t))
    (hxa : HasDerivAt (fun x => F (x, t)) dx a)
    (hxb : HasDerivAt (fun x => F (x, t)) dx b)
    (hta : HasDerivAt (fun s => F (a, s)) dt t)
    (htb : HasDerivAt (fun s => F (b, s)) dt t) :
    fderiv ℝ F (a, t) = fderiv ℝ F (b, t) := by
  have hax : (fderiv ℝ F (a, t)) (1, 0) = dx := by
    have h := ((hda.hasFDerivAt).comp a
      (hasFDerivAt_prodMk_left a t)).hasDerivAt
    exact h.unique hxa
  have hbx : (fderiv ℝ F (b, t)) (1, 0) = dx := by
    have h := ((hdb.hasFDerivAt).comp b
      (hasFDerivAt_prodMk_left b t)).hasDerivAt
    exact h.unique hxb
  have hat : (fderiv ℝ F (a, t)) (0, 1) = dt := by
    have h := ((hda.hasFDerivAt).comp t
      (hasFDerivAt_prodMk_right a t)).hasDerivAt
    exact h.unique hta
  have hbt : (fderiv ℝ F (b, t)) (0, 1) = dt := by
    have h := ((hdb.hasFDerivAt).comp t
      (hasFDerivAt_prodMk_right b t)).hasDerivAt
    exact h.unique htb
  apply ContinuousLinearMap.ext
  intro v
  have hv : v = v.1 • ((1, 0) : ℝ × ℝ) + v.2 • (0, 1) := by
    ext <;> simp
  rw [hv]
  simp only [map_add, map_smul]
  rw [hax, hbx, hat, hbt]

theorem hasDerivAt_fst_slice_of_differentiableAt
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (F : ℝ × ℝ → E) (x t : ℝ)
    (hF : DifferentiableAt ℝ F (x, t)) :
    HasDerivAt (fun y => F (y, t))
      ((fderiv ℝ F (x, t)) (1, 0)) x := by
  exact ((hF.hasFDerivAt).comp x (hasFDerivAt_prodMk_left x t)).hasDerivAt

theorem hasDerivAt_snd_slice_of_differentiableAt
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (F : ℝ × ℝ → E) (x t : ℝ)
    (hF : DifferentiableAt ℝ F (x, t)) :
    HasDerivAt (fun s => F (x, s))
      ((fderiv ℝ F (x, t)) (0, 1)) t := by
  exact ((hF.hasFDerivAt).comp t (hasFDerivAt_prodMk_right x t)).hasDerivAt

theorem hasDerivAt_comp_toIcoMod_offSeam
    (f : ℝ → ℝ) (p a x d : ℝ) (hp : 0 < p)
    (hx : ¬x ≡ a [PMOD p])
    (hf : HasDerivAt f d (toIcoMod hp a x)) :
    HasDerivAt (fun y => f (toIcoMod hp a y)) d x := by
  let k := toIcoDiv hp a x
  have hrep : x - k • p = toIcoMod hp a x := by
    rfl
  have htranslated : HasDerivAt (fun y => f (y - k • p)) d x := by
    have hshift : HasDerivAt (fun y : ℝ => y - k • p) 1 x :=
      (hasDerivAt_id x).sub_const (k • p)
    rw [← hrep] at hf
    simpa only [Function.comp_def, mul_one] using hf.comp x hshift
  have heventual :
      (fun y => f (toIcoMod hp a y)) =ᶠ[nhds x]
        (fun y => f (y - k • p)) := by
    filter_upwards [eventuallyEq_toIcoDiv_nhds hp a hx] with y hy
    simp [toIcoMod, k, hy]
  exact htranslated.congr_of_eventuallyEq heventual

theorem hasDerivAt_comp_toIcoMod_seam
    (f : ℝ → ℝ) (p a x d : ℝ) (hp : 0 < p)
    (hx : x ≡ a [PMOD p])
    (hvalue : f a = f (a + p))
    (hleft : HasDerivAt f d (a + p))
    (hright : HasDerivAt f d a) :
    HasDerivAt (fun y => f (toIcoMod hp a y)) d x := by
  let k := toIcoDiv hp a x
  let j := toIocDiv hp a x
  have hxa : x - k • p = a := by
    simpa only [toIcoMod, k] using
      (AddCommGroup.modEq_iff_toIcoMod_eq_left hp).mp hx.symm
  have hxb : x - j • p = a + p := by
    simpa only [toIocMod, j] using
      (AddCommGroup.modEq_iff_toIocMod_eq_right hp).mp hx.symm
  have hleft' : HasDerivAt (fun y => f (y - j • p)) d x := by
    have hshift : HasDerivAt (fun y : ℝ => y - j • p) 1 x :=
      (hasDerivAt_id x).sub_const (j • p)
    rw [← hxb] at hleft
    simpa only [Function.comp_def, mul_one] using hleft.comp x hshift
  have hright' : HasDerivAt (fun y => f (y - k • p)) d x := by
    have hshift : HasDerivAt (fun y : ℝ => y - k • p) 1 x :=
      (hasDerivAt_id x).sub_const (k • p)
    rw [← hxa] at hright
    simpa only [Function.comp_def, mul_one] using hright.comp x hshift
  have hglue : HasDerivAt
      (fun y => if y < x then f (y - j • p) else f (y - k • p)) d x := by
    apply hasDerivAt_if_of_eq (fun y => y < x) hleft' hright'
    rw [hxa, hxb]
    exact hvalue.symm
  have heventual :
      (fun y => f (toIcoMod hp a y)) =ᶠ[nhds x]
        (fun y => if y < x then f (y - j • p) else f (y - k • p)) := by
    rw [← nhdsLT_sup_nhdsGE, Filter.EventuallyEq, Filter.eventually_sup]
    constructor
    · filter_upwards [eventuallyEq_toIcoDiv_nhdsLT hp a x,
        self_mem_nhdsWithin] with y hy hyx
      have hylt : y < x := hyx
      simp [toIcoMod, j, hy, if_pos hylt]
    · filter_upwards [eventuallyEq_toIcoDiv_nhdsGE hp a x,
        self_mem_nhdsWithin] with y hy hyx
      have hyle : x ≤ y := hyx
      simp [toIcoMod, k, hy, if_neg (not_lt.mpr hyle)]
  exact hglue.congr_of_eventuallyEq heventual

/-- Matching values and first derivatives at the ends of one cell give a
globally differentiable periodic extension of scalar interval data. -/
theorem differentiable_comp_toIcoMod
    (f : ℝ → ℝ) (p a : ℝ) (hp : 0 < p)
    (hvalue : f a = f (a + p))
    (hderiv : ∀ y, a ≤ y → y ≤ a + p → DifferentiableAt ℝ f y)
    (hmatch : deriv f a = deriv f (a + p)) :
    Differentiable ℝ (fun x => f (toIcoMod hp a x)) := by
  intro x
  by_cases hx : x ≡ a [PMOD p]
  · exact (hasDerivAt_comp_toIcoMod_seam f p a x (deriv f a)
      hp hx hvalue
      ((hderiv (a + p) (by linarith) (le_refl _)).hasDerivAt.congr_deriv
        hmatch.symm)
      (hderiv a (le_refl _) (by linarith)).hasDerivAt).differentiableAt
  · have hcell := toIcoMod_mem_Ico hp a x
    exact (hasDerivAt_comp_toIcoMod_offSeam f p a x
      (deriv f (toIcoMod hp a x)) hp hx
      (hderiv (toIcoMod hp a x) hcell.1 hcell.2.le).hasDerivAt).differentiableAt

theorem differentiable_comp_toIcoMod_pi
    {m : ℕ} (f : ℝ → (Fin m → ℝ))
    (p a : ℝ) (hp : 0 < p)
    (hvalue : f a = f (a + p))
    (hderiv : ∀ y, a ≤ y → y ≤ a + p → DifferentiableAt ℝ f y)
    (hmatch : ∃ d : Fin m → ℝ,
      HasDerivAt f d a ∧ HasDerivAt f d (a + p)) :
    Differentiable ℝ (fun x => f (toIcoMod hp a x)) := by
  obtain ⟨d, hda, hdb⟩ := hmatch
  apply differentiable_pi.mpr
  intro i
  apply differentiable_comp_toIcoMod (fun x => f x i) p a hp
  · exact congrFun hvalue i
  · intro y hya hyb
    exact (differentiableAt_pi.mp (hderiv y hya hyb)) i
  · have ha := (hasDerivAt_pi.mp hda) i
    have hb := (hasDerivAt_pi.mp hdb) i
    rw [ha.deriv, hb.deriv]

end NumStability
