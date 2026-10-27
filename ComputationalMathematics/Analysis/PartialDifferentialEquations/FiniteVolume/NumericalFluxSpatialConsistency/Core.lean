/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.NumericalFluxSpatialConsistency.Defs
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.MovingCellAverageDerivative
import Mathlib.Analysis.Convex.Integral


/-!
# Uniform numerical-flux spatial consistency

The flux-divergence error for actual vector-valued cell means is at most
`(G2 * Q1 ^ 2 + G1 * Q2) * h`. The proof combines moving averages,
Jacobian variation and cancellation across adjacent faces. Product maximum
norms introduce no dimension-dependent factor. This is a spatial estimate;
it does not assert convergence or a CFL necessity theorem.
-/

open Set MeasureTheory

namespace NumStability.NumericalFluxSpatialConsistency

variable {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  [CompleteSpace E] [NormedAddCommGroup F] [NormedSpace ℝ F]

/-- Reuse the existing VECTOR moving-average derivative theorem, then use FTC
to identify the derivative with the average of the actual derivative profile. -/
private theorem moving_mean_hasDerivAt_mean_derivative
    (r r' : ℝ → E) (l u x : ℝ) (hlu : l < u)
    (hc : Continuous r) (hc' : Continuous r')
    (hr : ∀ y, HasDerivAt r (r' y) y) :
    HasDerivAt
      (fun y => NumStability.oneDimensionalCellAverage r (y + l) (y + u))
      (NumStability.oneDimensionalCellAverage r' (x + l) (x + u)) x := by
  have hm := NumStability.moving_intervalAverage_hasDerivAt_of_local_continuity
    r (x + l - 1) (x + u + 1) l u x hlu hc.continuousOn
    (show x + l ∈ Ioo (x + l - 1) (x + u + 1) from by constructor <;> linarith)
    (show x + u ∈ Ioo (x + l - 1) (x + u + 1) from by constructor <;> linarith)
  have hFTC : (∫ y in x + l..x + u, r' y) = r (x + u) - r (x + l) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt
      (fun y _ => hr y) (hc'.intervalIntegrable _ _)
  have hw : x + u - (x + l) = u - l := by ring
  have hmean : NumStability.oneDimensionalCellAverage r' (x + l) (x + u) =
      (u - l)⁻¹ • (r (x + u) - r (x + l)) := by
    rw [NumStability.oneDimensionalCellAverage, hFTC, hw]
  rw [hmean]
  exact hm

/-- Generic vector version of the elementary endpoint estimate. It reuses
the existing norm-of-mean-difference producer rather than redoing integration. -/
private theorem mean_sub_endpoint_le
    (r : ℝ → E) (L a b z : ℝ) (hL : 0 ≤ L) (hab : a < b)
    (hz : z ∈ Icc a b) (hc : Continuous r)
    (hLip : ∀ x y, ‖r x - r y‖ ≤ L * |x - y|) :
    ‖NumStability.oneDimensionalCellAverage r a b - r z‖ ≤ L * (b - a) := by
  have hconst := NumStability.oneDimensionalCellAverage_const (r z) a b (ne_of_lt hab)
  have h := NumStability.norm_oneDimensionalCellAverage_sub_le
    (f := r) (g := fun _ : ℝ => r z) (bound := L * (b - a)) hab
    (hc.intervalIntegrable _ _) intervalIntegrable_const (fun y hy => by
      have hy' : y ∈ Ioc a b := by simpa only [uIoc_of_le hab.le] using hy
      have hd : |y - z| ≤ b - a := abs_le.mpr
        ⟨by linarith [hy'.1, hy'.2, hz.1, hz.2],
          by linarith [hy'.1, hy'.2, hz.1, hz.2]⟩
      exact (hLip y z).trans (mul_le_mul_of_nonneg_left hd hL))
  simpa only [hconst] using h

private noncomputable def facePair (r : ℝ → E) (h x : ℝ) : E × E :=
  (NumStability.oneDimensionalCellAverage r (x - h) x,
    NumStability.oneDimensionalCellAverage r x (x + h))

private def diagonal (r : ℝ → E) (x : ℝ) : E × E := (r x, r x)

/-- The product maximum norm causes no factor 2 or dimension factor. -/
private theorem facePair_sub_diagonal_le
    (r : ℝ → E) (L h x : ℝ) (hL : 0 ≤ L) (hh : 0 < h)
    (hc : Continuous r) (hLip : ∀ a b, ‖r a - r b‖ ≤ L * |a - b|) :
    ‖facePair r h x - diagonal r x‖ ≤ L * h := by
  have hleft := mean_sub_endpoint_le r L (x - h) x x hL (by linarith)
    ⟨by linarith, le_rfl⟩ hc hLip
  have hright := mean_sub_endpoint_le r L x (x + h) x hL (by linarith)
    ⟨le_rfl, by linarith⟩ hc hLip
  have hwleft : x - (x - h) = h := by ring
  have hwright : x + h - x = h := by ring
  rw [hwleft] at hleft
  rw [hwright] at hright
  simpa only [facePair, diagonal, Prod.mk_sub_mk, Prod.norm_def]
    using max_le hleft hright

/-- The derivative of the pair of moving means is the pair of means of r'. -/
private theorem facePair_hasDerivAt
    (r r' : ℝ → E) (h x : ℝ) (hh : 0 < h)
    (hc : Continuous r) (hc' : Continuous r')
    (hr : ∀ y, HasDerivAt r (r' y) y) :
    HasDerivAt (facePair r h) (facePair r' h x) x := by
  have hl := moving_mean_hasDerivAt_mean_derivative r r' (-h) 0 x
    (by linarith) hc hc' hr
  have hu := moving_mean_hasDerivAt_mean_derivative r r' 0 h x hh hc hc' hr
  simpa only [facePair, sub_eq_add_neg, add_zero] using hl.prodMk hu

omit [CompleteSpace E] in
/-- A real derivative bound gives the global vector Lipschitz estimate.
This is a direct specialization of the pinned convex mean-value theorem. -/
private theorem norm_sub_le_of_hasDerivAt_bound
    (r r' : ℝ → E) (L : ℝ)
    (hr : ∀ x, HasDerivAt r (r' x) x) (hbound : ∀ x, ‖r' x‖ ≤ L)
    (x y : ℝ) : ‖r y - r x‖ ≤ L * |y - x| := by
  simpa only [Real.norm_eq_abs] using
    (convex_univ : Convex ℝ (univ : Set ℝ)).norm_image_sub_le_of_norm_hasDerivWithin_le
      (fun z _ => (hr z).hasDerivWithinAt) (fun z _ => hbound z) (mem_univ x) (mem_univ y)

omit [CompleteSpace E] in
/-- Exact operator cancellation for the positive mesh in the spatial estimate. -/
private theorem cancellation_operator_bound_pos
    (A B : E →L[ℝ] F) (u v : E) (G1 G2 Q1 Q2 h : ℝ)
    (hG1 : 0 ≤ G1) (hG2 : 0 ≤ G2) (hQ1 : 0 ≤ Q1) (hh : 0 < h)
    (hA : ‖A‖ ≤ G1) (hAB : ‖A - B‖ ≤ G2 * (Q1 * h))
    (hv : ‖v‖ ≤ Q1) (huv : ‖u - v‖ ≤ Q2 * h) :
    ‖A u - B v‖ ≤ (G2 * Q1 ^ 2 + G1 * Q2) * h := by
  have hsplit : A u - B v = (A - B) v + A (u - v) := by
    simp only [ContinuousLinearMap.sub_apply, map_sub]
    abel
  calc
    ‖A u - B v‖ = ‖(A - B) v + A (u - v)‖ := by rw [hsplit]
    _ ≤ ‖(A - B) v‖ + ‖A (u - v)‖ := norm_add_le _ _
    _ ≤ ‖A - B‖ * ‖v‖ + ‖A‖ * ‖u - v‖ :=
      add_le_add ((A - B).le_opNorm v) (A.le_opNorm (u - v))
    _ ≤ (G2 * (Q1 * h)) * Q1 + G1 * (Q2 * h) := by
      exact add_le_add
        (mul_le_mul hAB hv (norm_nonneg _) (mul_nonneg hG2 (mul_nonneg hQ1 hh.le)))
        (mul_le_mul hA huv (norm_nonneg _) hG1)
    _ = (G2 * Q1 ^ 2 + G1 * Q2) * h := by ring

omit [CompleteSpace E] in
/-- Exact chain rule for the moving-face discrepancy. -/
private theorem discrepancy_hasDerivAt
    (g : E → F) (P D : ℝ → E) (P' D' : E) (x : ℝ)
    (hP : HasDerivAt P P' x) (hD : HasDerivAt D D' x)
    (hgP : DifferentiableAt ℝ g (P x)) (hgD : DifferentiableAt ℝ g (D x)) :
    HasDerivAt (fun y => g (P y) - g (D y))
      (fderiv ℝ g (P x) P' - fderiv ℝ g (D x) D') x := by
  simpa only [Function.comp_def] using
    (hgP.hasFDerivAt.comp_hasDerivAt x hP).sub (hgD.hasFDerivAt.comp_hasDerivAt x hD)

omit [CompleteSpace E] in
/-- The ambient fderiv bound in the spatial estimate gives precisely the Lipschitz bound on
the Jacobian needed for the cancellation lemma. -/
private theorem jacobian_variation_le
    (S : Set E) (g : E → F) (G2 : ℝ) (hS : Convex ℝ S)
    (hg : ∀ z ∈ S, DifferentiableAt ℝ (fderiv ℝ g) z)
    (hbound : ∀ z ∈ S, ‖fderiv ℝ (fderiv ℝ g) z‖ ≤ G2)
    (p z : E) (hp : p ∈ S) (hz : z ∈ S) :
    ‖fderiv ℝ g p - fderiv ℝ g z‖ ≤ G2 * ‖p - z‖ := by
  exact hS.norm_image_sub_le_of_norm_fderiv_le hg hbound hz hp

/-- Mean value across adjacent faces followed by the positive-h normalization.
No bound on the size of e itself is required. -/
private theorem normalized_adjacent_discrepancy_le
    (e e' : ℝ → F) (B h x : ℝ) (hh : 0 < h)
    (he : ∀ y, HasDerivAt e (e' y) y) (hbound : ∀ y, ‖e' y‖ ≤ B * h) :
    ‖h⁻¹ • (e (x + h) - e x)‖ ≤ B * h := by
  have hvar := norm_sub_le_of_hasDerivAt_bound e e' (B * h) he hbound x (x + h)
  have hvar' : ‖e (x + h) - e x‖ ≤ (B * h) * h := by
    simpa only [add_sub_cancel_left, abs_of_pos hh] using hvar
  rw [norm_smul, Real.norm_eq_abs, abs_inv, abs_of_pos hh]
  calc
    h⁻¹ * ‖e (x + h) - e x‖ ≤ h⁻¹ * ((B * h) * h) :=
      mul_le_mul_of_nonneg_left hvar' (inv_nonneg.mpr hh.le)
    _ = B * h := by field_simp [ne_of_gt hh]

/-- The normalized Bochner mean belongs to the closed convex state set. -/
private theorem oneDimensionalCellAverage_mem_closed_convex
    (K : Set E) (hK : Convex ℝ K) (hclosed : IsClosed K)
    (r : ℝ → E) (a b : ℝ) (hab : a < b)
    (hint : IntervalIntegrable r volume a b) (hr : ∀ x, r x ∈ K) :
    NumStability.oneDimensionalCellAverage r a b ∈ K := by
  have hpos : volume (Ioc a b) ≠ 0 := by
    rw [Real.volume_Ioc]
    exact ne_of_gt (ENNReal.ofReal_pos.mpr (sub_pos.mpr hab))
  have hfinite : volume (Ioc a b) ≠ ⊤ := by
    rw [Real.volume_Ioc]
    exact ENNReal.ofReal_ne_top
  have hav := hK.set_average_mem hclosed hpos hfinite
    (Filter.Eventually.of_forall hr)
    ((intervalIntegrable_iff_integrableOn_Ioc_of_le hab.le).mp hint)
  have hnorm : volume.real (Ioc a b) = b - a := by
    simp only [measureReal_def, Real.volume_Ioc, ENNReal.toReal_ofReal (sub_nonneg.mpr hab.le)]
  simpa only [MeasureTheory.setAverage_eq, hnorm,
    NumStability.oneDimensionalCellAverage, intervalIntegral.integral_of_le hab.le] using hav

omit [CompleteSpace E] in
/-- The moving-face estimate under its explicit first-jet bounds. -/
private theorem moving_discrepancy_normalized_bound
    (S : Set E) (g : E → F) (P D P' D' : ℝ → E)
    (G1 G2 Q1 Q2 h x : ℝ)
    (hG1 : 0 ≤ G1) (hG2 : 0 ≤ G2) (hQ1 : 0 ≤ Q1) (hh : 0 < h)
    (hS : Convex ℝ S)
    (hg : ∀ z ∈ S, DifferentiableAt ℝ g z)
    (hg' : ∀ z ∈ S, DifferentiableAt ℝ (fderiv ℝ g) z)
    (hg1 : ∀ z ∈ S, ‖fderiv ℝ g z‖ ≤ G1)
    (hg2 : ∀ z ∈ S, ‖fderiv ℝ (fderiv ℝ g) z‖ ≤ G2)
    (hP : ∀ y, HasDerivAt P (P' y) y)
    (hD : ∀ y, HasDerivAt D (D' y) y)
    (hPS : ∀ y, P y ∈ S) (hDS : ∀ y, D y ∈ S)
    (hPD : ∀ y, ‖P y - D y‖ ≤ Q1 * h)
    (hD' : ∀ y, ‖D' y‖ ≤ Q1)
    (hP'D' : ∀ y, ‖P' y - D' y‖ ≤ Q2 * h) :
    ‖h⁻¹ • ((g (P (x + h)) - g (D (x + h))) -
      (g (P x) - g (D x)))‖ ≤ (G2 * Q1 ^ 2 + G1 * Q2) * h := by
  let e' : ℝ → F := fun y =>
    fderiv ℝ g (P y) (P' y) - fderiv ℝ g (D y) (D' y)
  apply normalized_adjacent_discrepancy_le
    (fun y => g (P y) - g (D y)) e' (G2 * Q1 ^ 2 + G1 * Q2) h x hh
  · intro y
    exact discrepancy_hasDerivAt g P D (P' y) (D' y) y
      (hP y) (hD y) (hg _ (hPS y)) (hg _ (hDS y))
  · intro y
    apply cancellation_operator_bound_pos
      (fderiv ℝ g (P y)) (fderiv ℝ g (D y)) (P' y) (D' y)
      G1 G2 Q1 Q2 h hG1 hG2 hQ1 hh (hg1 _ (hPS y))
    · exact (jacobian_variation_le S g G2 hS hg' hg2
        (P y) (D y) (hPS y) (hDS y)).trans
          (mul_le_mul_of_nonneg_left (hPD y) hG2)
    · exact hD' y
    · exact hP'D' y


end NumStability.NumericalFluxSpatialConsistency


namespace NumStability.NumericalFluxSpatialConsistency

open Set MeasureTheory

/-- Spatial C2 regularity supplies the first-jet estimates from the derivative budgets. -/
private theorem reference_C2_supplies_global_first_jet_estimates
    (d : ℕ) (r : ℝ → (Fin d → ℝ)) (Q1 Q2 : ℝ)
    (hr : ContDiff ℝ 2 r) (_hQ1 : 0 ≤ Q1) (_hQ2 : 0 ≤ Q2)
    (hb : ∀ x, ‖deriv r x‖ ≤ Q1 ∧ ‖deriv (deriv r) x‖ ≤ Q2) :
    Continuous r ∧ Continuous (deriv r) ∧
    (∀ x, HasDerivAt r (deriv r x) x) ∧
    (∀ x, HasDerivAt (deriv r) (deriv (deriv r) x) x) ∧
    (∀ x y, ‖r x - r y‖ ≤ Q1 * |x - y|) ∧
    (∀ x y, ‖deriv r x - deriv r y‖ ≤ Q2 * |x - y|) := by
  have hd : ∀ x, HasDerivAt r (deriv r x) x :=
    fun x => (hr.differentiable (by decide) x).hasDerivAt
  have hd' : ∀ x, HasDerivAt (deriv r) (deriv (deriv r) x) x :=
    fun x => (hr.differentiable_deriv_two x).hasDerivAt
  refine ⟨hr.continuous, hr.continuous_deriv (by norm_num), hd, hd', ?_, ?_⟩
  · intro x y
    exact norm_sub_le_of_hasDerivAt_bound r (deriv r) Q1 hd (fun z => (hb z).1) y x
  · intro x y
    exact norm_sub_le_of_hasDerivAt_bound (deriv r) (deriv (deriv r)) Q2 hd'
      (fun z => (hb z).2) y x

/-- Extract ordinary ambient derivatives, rather than within-derivatives,
from C2 on an open neighborhood. In the application U=V x V. -/
private theorem ambient_C2_supplies_first_jet
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup F] [NormedSpace ℝ F]
    (U : Set E) (g : E → F) (hU : IsOpen U) (hg : ContDiffOn ℝ 2 g U) :
    (∀ z ∈ U, DifferentiableAt ℝ g z) ∧
    (∀ z ∈ U, DifferentiableAt ℝ (fderiv ℝ g) z) := by
  have hg' : ContDiffOn ℝ 1 (fderiv ℝ g) U :=
    hg.fderiv_of_isOpen hU (by norm_num)
  exact ⟨fun z hz => (hg.contDiffAt (hU.mem_nhds hz)).differentiableAt (by decide),
    fun z hz => (hg'.contDiffAt (hU.mem_nhds hz)).differentiableAt (by decide)⟩

/-- Instantiate every face-jet premise from the unchanged the spatial estimate hypotheses.
There are no additional assumptions on the exact target. -/
private theorem reference_and_flux_hypotheses_supply_face_estimate
    (d : ℕ) (K V : Set (NumStability.NumericalFluxSpatialConsistency.State d))
    (f : NumStability.NumericalFluxSpatialConsistency.State d → NumStability.NumericalFluxSpatialConsistency.State d)
    (g : (NumStability.NumericalFluxSpatialConsistency.State d × NumStability.NumericalFluxSpatialConsistency.State d) → NumStability.NumericalFluxSpatialConsistency.State d)
    (G1 G2 Q1 Q2 H : ℝ)
    (hflux : NumStability.NumericalFluxSpatialConsistency.FluxHypotheses d K V f g G1 G2)
    (hQ1 : 0 ≤ Q1) (hQ2 : 0 ≤ Q2)
    (q : ℝ → ℝ → NumStability.NumericalFluxSpatialConsistency.State d)
    (hq : NumStability.NumericalFluxSpatialConsistency.ReferenceHypotheses K H Q1 Q2 q)
    (h x t : ℝ) (hh : 0 < h) (ht : t ∈ Icc 0 H) :
    ‖h⁻¹ • ((g (facePair (fun y => q y t) h (x + h)) -
        f (q (x + h) t)) -
      (g (facePair (fun y => q y t) h x) - f (q x t)))‖ ≤
      (G2 * Q1 ^ 2 + G1 * Q2) * h := by
  rcases hflux with ⟨_hd, _hne, hcompact, hconv, hopen, hKV,
    _hf, hg, hdiag, hG1, hG2, hgbound⟩
  rcases hq t ht with ⟨hr, hrbound⟩
  let r : ℝ → NumStability.NumericalFluxSpatialConsistency.State d := fun y => q y t
  have hjet := reference_C2_supplies_global_first_jet_estimates d r Q1 Q2 hr hQ1 hQ2
    (fun y => ⟨(hrbound y).2.1, (hrbound y).2.2⟩)
  rcases hjet with ⟨hc, hc', hdr, hdr', hLip, hLip'⟩
  have hK : ∀ y, r y ∈ K := fun y => (hrbound y).1
  have hmeanK : ∀ a b, a < b → NumStability.oneDimensionalCellAverage r a b ∈ K := by
    intro a b hab
    exact oneDimensionalCellAverage_mem_closed_convex K hconv hcompact.isClosed
      r a b hab (hc.intervalIntegrable a b) hK
  have hpairK : ∀ y, facePair r h y ∈ K ×ˢ K := by
    intro y
    exact ⟨hmeanK (y - h) y (by linarith), hmeanK y (y + h) (by linarith)⟩
  have hdiagonalK : ∀ y, diagonal r y ∈ K ×ˢ K := fun y => ⟨hK y, hK y⟩
  have hambient := ambient_C2_supplies_first_jet (V ×ˢ V) g (hopen.prod hopen) hg
  have hgK : ∀ z ∈ K ×ˢ K, DifferentiableAt ℝ g z :=
    fun z hz => hambient.1 z ⟨hKV hz.1, hKV hz.2⟩
  have hgK' : ∀ z ∈ K ×ˢ K, DifferentiableAt ℝ (fderiv ℝ g) z :=
    fun z hz => hambient.2 z ⟨hKV hz.1, hKV hz.2⟩
  have hD : ∀ y, HasDerivAt (diagonal r) (diagonal (deriv r) y) y := by
    intro y
    exact (hdr y).prodMk (hdr y)
  have hDnorm : ∀ y, ‖diagonal (deriv r) y‖ ≤ Q1 := by
    intro y
    simpa only [NumStability.NumericalFluxSpatialConsistency.diagonal, Prod.norm_def, max_self] using (hrbound y).2.1
  have hPsub : ∀ y, ‖facePair r h y - diagonal r y‖ ≤ Q1 * h :=
    fun y => facePair_sub_diagonal_le r Q1 h y hQ1 hh hc hLip
  have hP'sub : ∀ y, ‖facePair (deriv r) h y - diagonal (deriv r) y‖ ≤ Q2 * h :=
    fun y => facePair_sub_diagonal_le (deriv r) Q2 h y hQ2 hh hc' hLip'
  have hest := moving_discrepancy_normalized_bound (K ×ˢ K) g
    (facePair r h) (diagonal r) (facePair (deriv r) h) (diagonal (deriv r))
    G1 G2 Q1 Q2 h x hG1 hG2 hQ1 hh (hconv.prod hconv) hgK hgK'
    (fun z hz => (hgbound z hz).1) (fun z hz => (hgbound z hz).2)
    (fun y => facePair_hasDerivAt r (deriv r) h y hh hc hc' hdr) hD
    hpairK hdiagonalK hPsub hDnorm hP'sub
  have hd0 : g (diagonal r x) = f (r x) := hdiag (r x) (hKV (hK x))
  have hd1 : g (diagonal r (x + h)) = f (r (x + h)) :=
    hdiag (r (x + h)) (hKV (hK (x + h)))
  simpa only [hd0, hd1, r] using hest

/-- Uniform vector-valued spatial consistency for the numerical-flux divergence. -/
theorem spatialEstimate : NumStability.NumericalFluxSpatialConsistency.SpatialEstimate := by
  intro d K V f g G1 G2 Q1 Q2 H hflux _hH hQ1 hQ2 q hq h hh _hh1 b j t ht
  have hc : Continuous (fun y => q y t) := (hq t ht).1.continuous
  have hint : IntervalIntegrable (fun y => q y t) volume
      (b + (j : ℝ) * h) (b + ((j + 1 : ℤ) : ℝ) * h) := hc.intervalIntegrable _ _
  have hwidth : b + (j : ℝ) * h < b + ((j + 1 : ℤ) : ℝ) * h := by
    push_cast
    nlinarith
  have hconv : Convex ℝ K := hflux.2.2.2.1
  have hcompact : IsCompact K := hflux.2.2.1
  have hmean : NumStability.NumericalFluxSpatialConsistency.cellMean q h b t j ∈ K :=
    oneDimensionalCellAverage_mem_closed_convex K hconv hcompact.isClosed
      (fun y => q y t) _ _ hwidth hint (fun y => ((hq t ht).2 y).1)
  refine ⟨hint, hmean, ?_⟩
  let x : ℝ := b + (j : ℝ) * h
  have hx : x + h = b + ((j + 1 : ℤ) : ℝ) * h := by
    dsimp [x]
    push_cast
    ring
  have hxleft : x - h = b + ((j - 1 : ℤ) : ℝ) * h := by
    dsimp [x]
    push_cast
    ring
  have hxright : x + h + h = b + (((j + 1) + 1 : ℤ) : ℝ) * h := by
    dsimp [x]
    push_cast
    ring
  have hjleft : ((j - 1) + 1 : ℤ) = j := by omega
  have hP0 : facePair (fun y => q y t) h x =
      (NumStability.NumericalFluxSpatialConsistency.cellMean q h b t (j - 1),
        NumStability.NumericalFluxSpatialConsistency.cellMean q h b t j) := by
    simp only [facePair, NumStability.NumericalFluxSpatialConsistency.cellMean, hxleft, hx, hjleft, x]
  have hP1 : facePair (fun y => q y t) h (x + h) =
      (NumStability.NumericalFluxSpatialConsistency.cellMean q h b t j,
        NumStability.NumericalFluxSpatialConsistency.cellMean q h b t (j + 1)) := by
    have hcancel : x + h - h = x := by ring
    simp only [facePair, NumStability.NumericalFluxSpatialConsistency.cellMean]
    rw [hcancel, hxright, hx]
  have hest := reference_and_flux_hypotheses_supply_face_estimate
    d K V f g G1 G2 Q1 Q2 H hflux hQ1 hQ2 q hq h x t hh ht
  rw [hP0, hP1] at hest
  have hcancelFlux :
      ((g (NumStability.NumericalFluxSpatialConsistency.cellMean q h b t j,
          NumStability.NumericalFluxSpatialConsistency.cellMean q h b t (j + 1)) - f (q (x + h) t)) -
        (g (NumStability.NumericalFluxSpatialConsistency.cellMean q h b t (j - 1),
          NumStability.NumericalFluxSpatialConsistency.cellMean q h b t j) - f (q x t))) =
      (g (NumStability.NumericalFluxSpatialConsistency.cellMean q h b t j,
          NumStability.NumericalFluxSpatialConsistency.cellMean q h b t (j + 1)) -
        g (NumStability.NumericalFluxSpatialConsistency.cellMean q h b t (j - 1),
          NumStability.NumericalFluxSpatialConsistency.cellMean q h b t j)) -
      (f (q (x + h) t) - f (q x t)) := by abel
  rw [hcancelFlux, smul_sub, hx] at hest
  simpa only [x] using hest

end NumStability.NumericalFluxSpatialConsistency
