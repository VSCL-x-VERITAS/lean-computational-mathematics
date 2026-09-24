import ComputationalMathematics.HDP.Graph.RepeatedRandomCut

/-!
Frozen proof-free signature for Exercise 3.6.4.

The joint mass `repeatedUniformCutOutputPMF G ε n x` describes the explicit
Las Vegas algorithm that samples independent uniform Boolean cuts until the
observable edge-count threshold is met: `n` is the number of failed attempts
and `x` is the returned successful cut.  Unit total mass expresses almost-sure
termination, support correctness is the zero-error output guarantee, and the
weighted first moment is the expected number of experiments.
-/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_6_4__contract_type : Prop :=
  ∀ {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (ε : ℝ), 0 < ε →
    (∀ n : ℕ, ∀ x : V → Bool,
      0 ≤ NumStability.HDP.Graph.repeatedUniformCutOutputPMF G ε n x) ∧
      (∑' n : ℕ, ∑ x : V → Bool,
        NumStability.HDP.Graph.repeatedUniformCutOutputPMF G ε n x) = 1 ∧
      (∀ n : ℕ, ∀ x : V → Bool,
        NumStability.HDP.Graph.repeatedUniformCutOutputPMF G ε n x ≠ 0 →
        (1 / 2 - ε) * (NumStability.HDP.Graph.maxCut G : ℝ) ≤
          NumStability.HDP.Graph.signCutValue G
            (fun v ↦ NumStability.HDP.Graph.boolSign (x v))) ∧
      (∑' n : ℕ, ∑ x : V → Bool,
        (n + 1 : ℝ) *
          NumStability.HDP.Graph.repeatedUniformCutOutputPMF G ε n x) ≤
        (1 + 2 * ε) / (2 * ε)

end NumStability.HDP.Contract
