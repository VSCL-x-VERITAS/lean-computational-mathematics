import ComputationalMathematics.HDP.Vector.WhiteningExistence

/-!
Ordinary sample-only conditional-construction contract for native checking.
The existing canonical inverse-root construction is used on the same actual
probability space. This sample-only view is separate from the full joint-family
interface and from any Equation 4.25 SOURCE selection or parent contract.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory Matrix
open scoped ENNReal NNReal BigOperators MatrixOrder

universe u

namespace NumStability.HDP.Draft

/-- One explicitly fixed canonical family supplies every output below.
The restrictions on m and K are retained even though the reusable core has
a larger domain. This proposition contains no proof or new helper predicate. -/
def WhiteningCanonicalSampleOnlyTarget : Prop :=
  ∀ {Ω : Type u} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {m n : ℕ} (hm : 0 < m)
    (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ)
    (K : ℝ≥0) (hK : 1 ≤ K)
    (hSG : Vector.SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (hRelative : Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
      (fun j ω ↦ X ω j) K)
    (hSampleMeas : ∀ i j, Measurable (fun ω ↦ Xsample i ω j))
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ)
    (hIndep : iIndepFun Xsample μ)
    (hUnit : IsUnit (Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ X ω j))),
    -- F2/F4/F6: actual raw matrix, principal root and fixed canonical W.
    let Sigma := Vector.Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)
    let S := CFC.sqrt Sigma
    let F := Vector.Whitening.populationSampleFamily X Xsample
    let W : Option (Fin m) → Ω → Fin n → ℝ :=
      fun o ω ↦ S⁻¹.mulVec (F o ω)
    -- F1/F3: all-member marginals; independence only of the sample projection.
    (∀ o j, Measurable (fun ω ↦ W o ω j)) ∧
    (∀ o, Vector.Isotropy.IsIsotropic μ (fun j ω ↦ W o ω j)) ∧
    (∀ o, Vector.SubGaussian.PsiTwoNorm μ (fun j ω ↦ W o ω j) ≤ (K : ℝ≥0∞)) ∧
    (∀ i, IdentDistrib (W (some i)) (W none) μ μ) ∧
    iIndepFun (fun i : Fin m ↦ W (some i)) μ ∧
    -- F4: finite coordinate moments and every coordinate-product integral.
    (∀ j, MemLp (fun ω ↦ X ω j) 2 μ) ∧
    (∀ i j, MemLp (fun ω ↦ Xsample i ω j) 2 μ) ∧
    (∀ o j, MemLp (fun ω ↦ W o ω j) 2 μ) ∧
    (∀ j k, Integrable (fun ω ↦ X ω j * X ω k) μ) ∧
    (∀ i j k, Integrable (fun ω ↦ Xsample i ω j * Xsample i ω k) μ) ∧
    (∀ o j k, Integrable (fun ω ↦ W o ω j * W o ω k) μ) ∧
    -- F2/F5: pointwise reconstruction by this one explicitly chosen family.
    (∀ o ω, F o ω = S.mulVec (W o ω)) ∧
    -- F7: sample rows only, full entrywise formula and actual error/norm chain.
    (let A : Ω → Matrix (Fin m) (Fin n) ℝ := fun ω i ↦ W (some i) ω
     let Rm : Ω → Matrix (Fin n) (Fin n) ℝ :=
       fun ω ↦ (m : ℝ)⁻¹ • ((A ω).transpose * A ω) - 1
     (∀ ω a b, Rm ω a b =
       (m : ℝ)⁻¹ * (∑ i : Fin m, W (some i) ω a * W (some i) ω b) -
         (if a = b then 1 else 0)) ∧
     ∀ ω,
       Vector.Covariance.randomSampleCovariance Xsample ω - Sigma =
         S * Rm ω * S ∧
       ‖NumStability.realMatrixContinuousLinearMap
           (Vector.Covariance.randomSampleCovariance Xsample ω - Sigma)‖ =
         ‖NumStability.realMatrixContinuousLinearMap (S * Rm ω * S)‖ ∧
       ‖NumStability.realMatrixContinuousLinearMap
           (Vector.Covariance.randomSampleCovariance Xsample ω - Sigma)‖ ≤
         ‖NumStability.realMatrixContinuousLinearMap (Rm ω)‖ *
           ‖NumStability.realMatrixContinuousLinearMap Sigma‖)

end NumStability.HDP.Draft

end
