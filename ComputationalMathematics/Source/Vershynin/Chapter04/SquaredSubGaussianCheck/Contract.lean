import ComputationalMathematics.HDP.Matrix.IsotropicRows
import ComputationalMathematics.HDP.Scalar.SquaredSubGaussian
import ComputationalMathematics.HDP.Vector.MarginalVariance

/-!
# Vershynin Chapter 4, centered-square sub-exponential check
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators

namespace NumStability.HDP.Contract

/-- The inline check in the proof of Theorem 4.6.1. For independent,
mean-zero, isotropic, sub-Gaussian rows and a fixed unit direction `x`, the
scalar projections `X_i = ⟨A_i, x⟩` have independent centered squares.
Each `X_i² - 1` is mean zero and has sub-exponential norm bounded by an
absolute constant times `K²`. -/
theorem hdp_04_squared_subgaussian_check :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        (A : Ω → Matrix (Fin m) (Fin n) ℝ) {K : ℝ},
        0 ≤ K →
        (∀ i j, Measurable (fun ω ↦ A ω i j)) →
        (∀ i j, MemLp (fun ω ↦ A ω i j) 2 μ) →
        (∀ i j, ∫ ω, A ω i j ∂μ = 0) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω ↦ A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω ↦ A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω ↦ fun j ↦ A ω i j) μ →
        ∀ (x : Fin n → ℝ), NumStability.vecNorm2 x = 1 →
          let X : Fin m → Ω → ℝ := fun i ω ↦
            NumStability.HDP.Vector.linearMarginal
              (fun j ω' ↦ A ω' i j) x ω
          iIndepFun (fun i ω ↦ X i ω ^ 2 - 1) μ ∧
            ∀ i,
              (∫ ω, (X i ω ^ 2 - 1) ∂μ) = 0 ∧
                NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ
                    (fun ω ↦ X i ω ^ 2 - 1) ≤
                  ENNReal.ofReal C * (ENNReal.ofReal K) ^ 2 := by
  let C : ℝ := 1 + 2048 * (Real.exp 1) ^ 3
  refine ⟨C, by dsimp [C]; positivity, ?_⟩
  intro Ω instΩ μ instμ m n A K hK0 hMeas hLp _hMean hIso hPsi hIndep x hx
  let X : Fin m → Ω → ℝ := fun i ω ↦
    NumStability.HDP.Vector.linearMarginal
      (fun j ω' ↦ A ω' i j) x ω
  have hXMeas : ∀ i, Measurable (X i) := by
    intro i
    dsimp [X, NumStability.HDP.Vector.linearMarginal]
    fun_prop
  have hXLp : ∀ i, MemLp (X i) 2 μ := by
    intro i
    simpa [X, NumStability.HDP.Vector.linearMarginal] using
      (NumStability.HDP.Vector.Isotropy.marginal_memLp
        (fun j ↦ hLp i j) x)
  have hXSecond : ∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1 := by
    intro i
    have hbilinear :=
      NumStability.HDP.Vector.Isotropy.integral_linearMarginal_mul_linearMarginal
        (fun j ↦ hLp i j) (hIso i) x x
    calc
      (∫ ω, X i ω ^ 2 ∂μ) = ∫ ω, X i ω * X i ω ∂μ := by
        congr 1
        funext ω
        rw [pow_two]
      _ = ∑ j, x j * x j := hbilinear
      _ = NumStability.vecNorm2 x ^ 2 := by
        rw [NumStability.vecNorm2_sq]
        simp only [NumStability.vecNorm2Sq, pow_two]
      _ = 1 := by rw [hx]; norm_num
  have hScalarLe (i : Fin m) :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i) ≤
        NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω ↦ A ω i j) := by
    unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
    exact le_iSup
      (fun v : NumStability.HDP.Vector.SubGaussian.UnitDirection n ↦
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal
            (fun j ω ↦ A ω i j) v.1)) ⟨x, hx⟩
  have hXIndep : iIndepFun X μ := by
    have hcomp := hIndep.comp
      (fun _i (row : Fin n → ℝ) ↦ ∑ j, row j * x j)
      (fun _i ↦ by fun_prop)
    simpa [X, Function.comp_def,
      NumStability.HDP.Vector.linearMarginal] using hcomp
  have hCenteredIndep : iIndepFun (fun i ω ↦ X i ω ^ 2 - 1) μ := by
    have hcomp := hXIndep.comp
      (fun _i (z : ℝ) ↦ z ^ 2 - 1)
      (fun _i ↦ by fun_prop)
    simpa [Function.comp_def] using hcomp
  refine ⟨hCenteredIndep, ?_⟩
  intro i
  have hi := NumStability.HDP.Scalar.centeredSquare_psiOneGauge_le
    (hXMeas i) (hXLp i).integrable_sq (hXSecond i)
    ((hScalarLe i).trans (hPsi i))
  simpa [C] using hi

end NumStability.HDP.Contract
