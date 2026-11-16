import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.Elementwise.ResidualMoments

/-!
# Covered-support entry-residual moment contract

Original row016, p83, concerns zero mean and bounded variance of entries of the
raw Algorithm1 residual. This conditional contract explicitly retains the
nonzero-entry support coverage required by corrected unbiasedness. It does not
silently repair the original unrestricted claim. The supplied distribution is
normalized by its finite-probability type, and draws use its literal iid law.
No truncation or independence between different residual coordinates is asserted.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- Coordinate mean, exact variance, finite support bound and zero-atom branch
for the original zero-initialized iid importance sketch on covered support. -/
def entryResidualMeanVariance : Prop :=
  ∀ (m n s : ℕ) (A : Fin m → Fin n → ℝ)
    (P : FiniteProbability (Fin m × Fin n)),
    0 < m → 0 < n → 0 < s →
    (∀ i j, A i j ≠ 0 → 0 < P.prob (i,j)) →
    ∀ i j,
      (P.iid s).expectationReal (fun ω => entrySamplingResidual A P ω i j) = 0 ∧
      (0 < P.prob (i,j) →
        (P.iid s).varianceReal (fun ω => entrySamplingResidual A P ω i j) =
          A i j ^ 2 * (1 / P.prob (i,j) - 1) / (s : ℝ) ∧
        0 ≤ A i j ^ 2 * (1 / P.prob (i,j) - 1) / (s : ℝ) ∧
        ∀ ω, 0 < (P.iid s).prob ω →
          |entrySamplingResidual A P ω i j| ≤ |A i j| * (1 + 1 / P.prob (i,j))) ∧
      (P.prob (i,j) = 0 →
        A i j = 0 ∧
        (P.iid s).eventProb {ω | entrySamplingResidual A P ω i j = 0} = 1 ∧
        (P.iid s).varianceReal (fun ω => entrySamplingResidual A P ω i j) = 0)

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
