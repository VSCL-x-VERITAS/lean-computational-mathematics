import ComputationalMathematics.HDP.Scalar.BerryEsseen
import ComputationalMathematics.Source.Vershynin.Chapter01.StandardizedSum.Contract

/-!
# Frozen weakened contract signature for Theorem 2.1.3

The printed theorem has coefficient one.  This proof-free signature records
the currently certified consequence with the explicit maximal-cutoff Prawitz
constant in its place.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal BigOperators

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems
open NumStability.HDP.Scalar.BerryEsseen

def hdp_02_hthm_h2_d1_d3_weakened__contract_type : Prop :=
  ∀ {Omega : Type*} [MeasurableSpace Omega]
    (mu : Measure Omega) [IsProbabilityMeasure mu]
    (X : ℕ → Omega → ℝ) (m sigma : ℝ),
    0 < sigma →
    (hX : ∀ i, MemLp (X i) 3 mu) →
    iIndepFun X mu →
    (∀ i, IdentDistrib (X i) (X 0) mu mu) →
    (∫ omega, X 0 omega ∂mu = m) →
    Var[X 0; mu] = sigma ^ 2 →
    ∀ {N : ℕ}, 1 ≤ N → ∀ t : ℝ,
      |(probabilityLaw
            (hdp_01_hdef_hzn X m sigma N)
            (hdp_01_hdef_hzn_aemeasurable mu X m sigma N
              (fun i => (hX i).aemeasurable)) :
          Measure ℝ).real (Ici t) -
        standardNormalLaw.real (Ici t)| ≤
        prawitzMaximalSharpBerryEsseenConstant *
          ((∫ omega, |X 0 omega - m| ^ 3 ∂mu) / sigma ^ 3) /
            Real.sqrt (N : ℝ)

end NumStability.HDP.Contract
