import ComputationalMathematics.Source.Higham.Chapter11.Theorem07.Core.Results

/-!
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Chapter 11, Theorem 11.7 — growth-derived closure

This module composes the two halves of the Theorem 11.7 closure that were, until
now, only linked by a hypothesis:

  * `hfactor_derived` (in `BunchTridiagonalGrowthInvariantCh11Closure`): from the
    Algorithm-11.6 pivot *schedule* `TriGrowthData` (every stage uses the FIXED
    global scale `σ = M0 = ‖A‖_M` in its acceptance test) together with the input
    bound `∀ i j, |A i j| ≤ M0`, the computed factors satisfy the factor-norm
    bound `|L̂||D̂||L̂ᵀ| ≤ c₀·M0` with the *constant* growth factor
    `c₀ = growthFactorConst …` (this is Higham's "constant element growth" fact,
    now derived rather than assumed);

  * `higham11_7_bunch_tridiagonal_backward_error` (in
    `BlockLDLTBunchTridiagonalCh11Closure`): the conditional Theorem 11.7 that,
    *given* such a factor-norm bound and the (11.5) solve backward error, produces
    the normwise backward error `|ΔAₖ| ≤ 20 n (1+c₀)·u·‖A‖_M`.

The capstone `higham11_7_bunch_tridiagonal_backward_error_growth_derived` discharges
the `hfactor` hypothesis of the conditional theorem outright, leaving only the two
genuine Higham source hypotheses (`FlMixedPivots` per-stage (11.5) coupling, and the
(11.5) solve backward error `hsolve`).  The constant `c₀ = bunchTriGrowthC0` is
explicit and depends only on `u`, `M0`, and the number of stages. -/

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.Theorem07.Core.Results`.
Declaration names and mathematical terminology are unchanged.
-/
