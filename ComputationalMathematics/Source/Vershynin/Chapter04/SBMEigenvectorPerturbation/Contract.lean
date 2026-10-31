import ComputationalMathematics.HDP.Matrix.EigenvectorPerturbation
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBMRecovery
import Mathlib.MeasureTheory.Measure.Typeclasses.Probability

/-!
# Vershynin Chapter 4, stochastic-block eigenvector perturbation
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

/-- The deterministic implication used on every realization of the
stochastic-block noise event. -/
theorem hdp_04_sbm_eigenvector_perturbation_on_noise_event
    {n : ℕ} (hn : 0 < n) (D A : Matrix (Fin n) (Fin n) ℝ)
    (hD : D.IsHermitian) (hA : A.IsHermitian) (i : Fin n)
    (C μ : ℝ) (hC : 0 ≤ C) (hμ : 0 < μ)
    (hgap : ∀ j : Fin n, j ≠ i →
      μ * (n : ℝ) ≤ |NumStability.hermitianOrderedEigenvalue hD i -
        NumStability.hermitianOrderedEigenvalue hD j|)
    (hnoise : NumStability.realMatrixOperatorNorm (D - A) ≤
      C * Real.sqrt n) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ‖NumStability.hermitianOrderedEigenbasis hD i -
          θ • NumStability.hermitianOrderedEigenbasis hA i‖ ≤
        2 * Real.sqrt 2 * C / (μ * Real.sqrt n) := by
  exact NumStability.HDP.Matrix.exists_sign_orderedEigenvectors_norm_sub_le_sbm_scale
    hn D A hD hA i C μ hC hμ hgap hnoise

/-- The same deterministic consequence with the chapter's unnormalized
eigenvectors, obtained by multiplying both unit eigenvectors by `√n`. -/
theorem hdp_04_sbm_eigenvector_perturbation_on_noise_event_scaled
    {n : ℕ} (hn : 0 < n) (D A : Matrix (Fin n) (Fin n) ℝ)
    (hD : D.IsHermitian) (hA : A.IsHermitian) (i : Fin n)
    (C μ : ℝ) (hC : 0 ≤ C) (hμ : 0 < μ)
    (hgap : ∀ j : Fin n, j ≠ i →
      μ * (n : ℝ) ≤ |NumStability.hermitianOrderedEigenvalue hD i -
        NumStability.hermitianOrderedEigenvalue hD j|)
    (hnoise : NumStability.realMatrixOperatorNorm (D - A) ≤
      C * Real.sqrt n) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ‖NumStability.hermitianOrderedEigenbasis hD i -
          θ • NumStability.hermitianOrderedEigenbasis hA i‖ ≤
        2 * Real.sqrt 2 * C / (μ * Real.sqrt n) ∧
      ‖Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD i -
          θ • (Real.sqrt n • NumStability.hermitianOrderedEigenbasis hA i)‖ ≤
        2 * Real.sqrt 2 * C / μ := by
  obtain ⟨θ, hθ, hunit⟩ := hdp_04_sbm_eigenvector_perturbation_on_noise_event
    hn D A hD hA i C μ hC hμ hgap hnoise
  refine ⟨θ, hθ, hunit, ?_⟩
  have hsqrt : 0 < Real.sqrt (n : ℝ) := Real.sqrt_pos.2 (by exact_mod_cast hn)
  calc
    ‖Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD i -
        θ • (Real.sqrt n • NumStability.hermitianOrderedEigenbasis hA i)‖ =
        Real.sqrt n *
          ‖NumStability.hermitianOrderedEigenbasis hD i -
            θ • NumStability.hermitianOrderedEigenbasis hA i‖ := by
      rw [show
        Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD i -
            θ • (Real.sqrt n • NumStability.hermitianOrderedEigenbasis hA i) =
          Real.sqrt n •
            (NumStability.hermitianOrderedEigenbasis hD i -
              θ • NumStability.hermitianOrderedEigenbasis hA i) by
        simp [smul_sub, smul_smul, mul_comm]]
      rw [norm_smul, Real.norm_eq_abs, abs_of_pos hsqrt]
    _ ≤ Real.sqrt n *
        (2 * Real.sqrt 2 * C / (μ * Real.sqrt n)) :=
      mul_le_mul_of_nonneg_left hunit hsqrt.le
    _ = 2 * Real.sqrt 2 * C / μ := by
      field_simp [ne_of_gt hsqrt, ne_of_gt hμ]

/-- Vershynin, Section 4.5.4: if Equation (4.18)'s stochastic-block noise
event has probability at least `1 - 4 exp (-n)`, then with at least that same
probability the second unit eigenvectors of the signal and observed adjacency
matrices are sign-aligned within `2√2 C/(μ√n)`. After the source's `√n`
rescaling, the corresponding unnormalized vectors are within `2√2 C/μ`.

The noise-event mass is an explicit premise, so this implication composes
the separately inventoried Equation (4.18) with the deterministic
Davis--Kahan consequence. The source applies it to its probability law;
the implication itself holds for any measure and Hermitian matrices with
the displayed eigengap and noise bound, independently of a block model. -/
theorem hdp_04_sbm_eigenvector_perturbation_of_structural_hypotheses
    {Ω : Type*} [MeasurableSpace Ω] (P : MeasureTheory.Measure Ω)
    {n : ℕ} (hn2 : 2 ≤ n) (D : Matrix (Fin n) (Fin n) ℝ)
    (A : Ω → Matrix (Fin n) (Fin n) ℝ)
    (hD : D.IsHermitian) (hA : ∀ ω, (A ω).IsHermitian)
    (C μ : ℝ) (hC : 0 ≤ C) (hμ : 0 < μ)
    (hgap : ∀ j : Fin n, j ≠ ⟨1, hn2⟩ →
      μ * (n : ℝ) ≤
        |NumStability.hermitianOrderedEigenvalue hD ⟨1, hn2⟩ -
          NumStability.hermitianOrderedEigenvalue hD j|)
    (hnoiseProbability :
      ENNReal.ofReal (1 - 4 * Real.exp (-(n : ℝ))) ≤
        P {ω | NumStability.realMatrixOperatorNorm (D - A ω) ≤
          C * Real.sqrt n}) :
    ENNReal.ofReal (1 - 4 * Real.exp (-(n : ℝ))) ≤
      P {ω | ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
        ‖NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
            θ • NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩‖ ≤
          2 * Real.sqrt 2 * C / (μ * Real.sqrt n) ∧
        ‖Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
            θ • (Real.sqrt n •
              NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩)‖ ≤
          2 * Real.sqrt 2 * C / μ} := by
  refine hnoiseProbability.trans (MeasureTheory.measure_mono ?_)
  intro ω hω
  exact hdp_04_sbm_eigenvector_perturbation_on_noise_event_scaled
    (lt_of_lt_of_le (by norm_num) hn2) D (A ω) hD (hA ω) ⟨1, hn2⟩
      C μ hC hμ hgap hω

/-- Vershynin, Section 4.5.4, for the exact balanced loopless
independent-Bernoulli stochastic-block model.  With
`μ = min(q, p-q)` and `n = 2k`, the ordered second empirical eigenvector can
be globally sign-aligned with the population eigenvector at unit scale
`C/(μ√n)` and, after the source's `√n` rescaling, at scale `C/μ`, outside an
event of probability at most `4 exp (-n)`. -/
theorem hdp_04_sbm_eigenvector_perturbation :
    ∃ C : ℝ, 0 < C ∧
      ∀ {k : ℕ} (hk : 0 < k)
        (θ : NumStability.HDP.Graph.StochasticBlock.Parameters),
        0 < θ.q → θ.q < θ.p →
        let n := 2 * k
        let community := BalancedFinSBM.community k
        let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
        let A : (NumStability.HDP.Graph.FinStochasticBlock.UpperPair n → Bool) →
            Matrix (Fin n) (Fin n) ℝ :=
          NumStability.HDP.Graph.FinStochasticBlock.adjacency
        let hA : ∀ ω, (A ω).IsHermitian :=
          NumStability.HDP.Graph.FinStochasticBlock.adjacency_hermitian
        let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
        let μ : ℝ := min θ.q (θ.p - θ.q)
        P.real {ω | ¬ ∃ α : ℝ, (α = -1 ∨ α = 1) ∧
          ‖NumStability.hermitianOrderedEigenbasis hD ⟨1, by omega⟩ -
              α • NumStability.hermitianOrderedEigenbasis (hA ω)
                ⟨1, by omega⟩‖ ≤ C / (μ * Real.sqrt n) ∧
          ‖Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis hD ⟨1, by omega⟩ -
              α • (Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis (hA ω)
                  ⟨1, by omega⟩)‖ ≤ C / μ} ≤
            4 * Real.exp (-(n : ℝ)) :=
  BalancedFinSBMRecovery.exists_eigenvector_perturbation_tail

end NumStability.HDP.Contract
