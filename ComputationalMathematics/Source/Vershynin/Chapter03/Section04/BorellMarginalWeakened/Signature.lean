import ComputationalMathematics.HDP.Convex.IsotropicMarginals

/-!
# Weakened Borell marginal contract

Frozen proof-free signature retaining the isotropic convex-body law and unit
direction from Section 3.4.4, but asserting only finiteness of the exact `ψ₁`
gauge.  The source's dimension-free universal bound remains strictly stronger.
-/

noncomputable section

open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_4_borell_marginal_weakened__contract_type : Prop :=
  ∀ {n : ℕ} {K : Set (Fin n → ℝ)},
    NumStability.HDP.Convex.IsConvexBody K →
    NumStability.HDP.Vector.Isotropy.IsIsotropic
      (NumStability.HDP.Convex.uniformConvexBodyMeasure K)
      (fun (i : Fin n) (x : Fin n → ℝ) => x i) →
    ∀ u : Fin n → ℝ, (∑ i, (u i) ^ 2) = 1 →
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge
          (NumStability.HDP.Convex.uniformConvexBodyMeasure K)
          (NumStability.HDP.Vector.linearMarginal
            (fun (i : Fin n) (x : Fin n → ℝ) => x i) u) < ∞

end NumStability.HDP.Contract
