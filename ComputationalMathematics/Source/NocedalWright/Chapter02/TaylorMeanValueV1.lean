import ComputationalMathematics.Source.NocedalWright.Chapter02.TaylorMeanValueTargetV1
import Mathlib.Analysis.Calculus.Deriv.MeanValue

/-!
Checked Taylor mean-value statement from Chapter 2.
-/

open Set
namespace ComputationalMathematics.Source.NocedalWright.Chapter02

private theorem scalarInnerMV (a b : ℝ) : inner ℝ a b = a * b := by
  calc
    inner ℝ a b = inner ℝ (a • (1 : ℝ)) (b • (1 : ℝ)) := by
      simp only [smul_eq_mul, mul_one]
    _ = a * b := by
      rw [real_inner_smul_left, real_inner_smul_right]
      simp

private theorem lineDerivMV {n : ℕ}
    (f : EuclideanSpace ℝ (Fin n) → ℝ)
    (hf : ContDiff ℝ (1 : ℕ) f)
    (x p : EuclideanSpace ℝ (Fin n)) (t : ℝ) :
    HasDerivAt (fun ε : ℝ => f (x + ε • p))
      (∑ i, p i * (gradient f (x + t • p)) i) t := by
  have hdiff : DifferentiableAt ℝ f (x + t • p) := hf.differentiable (by decide) _
  have hline : HasDerivAt (fun ε : ℝ => x + ε • p) p t := by
    convert ((hasDerivAt_id t).smul_const p).const_add x using 1; simp
  have hF : HasFDerivAt f (fderiv ℝ f (x + t • p)) (x + t • p) :=
    hdiff.hasFDerivAt
  have hcomp := hF.comp_hasDerivAt t hline
  convert hcomp using 1
  rw [← inner_gradient_left hdiff]
  rw [PiLp.inner_apply]
  simp only [scalarInnerMV, mul_comm]

theorem taylorMeanValueV1 : taylorMeanValueTargetV1 := by
  intro n hn f hf x p
  let g : ℝ → ℝ := fun t => f (x + t • p)
  have hderiv : ∀ t : ℝ, HasDerivAt g
      (∑ i, p i * (gradient f (x + t • p)) i) t := by
    intro t
    exact lineDerivMV f hf x p t
  have hcont : Continuous g :=
    continuous_iff_continuousAt.mpr (fun t => (hderiv t).continuousAt)
  have hdiff : DifferentiableOn ℝ g (Ioo (0:ℝ) 1) := by
    intro t ht
    exact (hderiv t).differentiableAt.differentiableWithinAt
  obtain ⟨t, ht, heq⟩ := exists_deriv_eq_slope g (by norm_num : (0:ℝ) < 1)
    hcont.continuousOn hdiff
  refine ⟨t, ht.1, ht.2, ?_⟩
  have hderivEq : deriv g t = ∑ i, p i * (gradient f (x + t • p)) i :=
    (hderiv t).deriv
  rw [hderivEq] at heq
  have hcore : f (x + p) - f x =
      ∑ i, p i * (gradient f (x + t • p)) i := by
    simpa [g, div_one] using heq.symm
  rw [PiLp.inner_apply]
  simp only [scalarInnerMV]
  have hsum : (∑ i, (gradient f (x + t • p)) i * p i) =
      ∑ i, p i * (gradient f (x + t • p)) i := by
    apply Finset.sum_congr rfl
    intro i hi
    ring
  rw [hsum]
  linarith [hcore]
end ComputationalMathematics.Source.NocedalWright.Chapter02
