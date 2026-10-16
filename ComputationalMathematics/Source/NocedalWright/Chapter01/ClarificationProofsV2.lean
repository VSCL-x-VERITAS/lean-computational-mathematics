import ComputationalMathematics.Source.NocedalWright.Chapter01.ClarificationTargetsV2
import ComputationalMathematics.Source.NocedalWright.Chapter01.LocalGlobalClarified
import ComputationalMathematics.Optimization.Discrete.Convexity
import ComputationalMathematics.Optimization.Modeling.VolumeDiscount

/-!
# Proofs of separately audited Chapter 1 editorial clarifications

These wrappers inhabit the project-owner clarification targets. The printed
PDF rows remain deferred and are not claimed to be translated by these proofs.
-/

open scoped BigOperators

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

theorem discreteBinaryClarificationV1 : discreteBinaryClarificationTargetV1 := by
  exact ComputationalMathematics.Optimization.Discrete.binary_not_convex

theorem localGlobalClarificationV2 : localGlobalClarificationTargetV1 := by
  intro n D s f x hobj hfeas hsubset hx hloc
  exact localGlobalOfConvexObjectiveOnDomain hobj hfeas hsubset hx hloc

theorem volumeDiscountClarificationV2 : volumeDiscountClarificationTargetV2 := by
  constructor
  · intro δ x hδ hx
    simp
  · intro δ c hδ hc
    simpa only [ComputationalMathematics.Optimization.Modeling.volumeDiscountObjective] using
      ComputationalMathematics.Optimization.Modeling.volumeDiscountObjective_nonaffine_of_nonzero_cost
        δ c hδ hc

end ComputationalMathematics.Source.NocedalWright.Chapter01
