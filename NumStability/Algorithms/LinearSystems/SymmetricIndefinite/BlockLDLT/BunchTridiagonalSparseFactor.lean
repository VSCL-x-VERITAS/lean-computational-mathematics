/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Theorem 11.7: support-aware tridiagonal factorization

The dense Schur kernels used by the general mixed-pivot development execute a
rounded subtraction even when tridiagonal structure makes the update exactly
zero.  In the abstract `FPModel`, `fl_sub x 0 = x` is deliberately not a global
law, so that dense implementation necessarily accumulates an `O(nu)` copying
budget.  Higham's Theorem 11.7 instead counts only the nonzero operations of the
tridiagonal algorithm.

This file gives that source-faithful policy.  `skipZeroSubFP fp` delegates every
genuine arithmetic operation to `fp`, but copies `x` when the subtrahend is
exactly zero.  It is itself an `FPModel`, with the same unit roundoff.  Thus all
existing executable schedule, factor, growth, middle-solve, and sparse outer
solve code can be instantiated with it; only structurally vacuous Schur
updates are skipped.

The remainder of the file derives the local rounded explicit-inverse residuals
and assembles a dimension-independent factorization error directly along a
`TriGrowthBounded` schedule.  No `FlMixedPivots` or target-shaped residual
premise is used.
-/

import ComputationalMathematics.Algorithms.LinearSystems.SymmetricIndefinite.BlockLDLT.BunchTridiagonalSparseFactor

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Algorithms.LinearSystems.SymmetricIndefinite.BlockLDLT.BunchTridiagonalSparseFactor`.
Declaration names and mathematical terminology are unchanged.
-/
