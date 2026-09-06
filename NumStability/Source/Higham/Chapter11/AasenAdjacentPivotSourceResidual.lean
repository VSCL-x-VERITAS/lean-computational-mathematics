/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Theorem 11.8: optimal operational middle-solve correction

The printed proof of Theorem 11.8 bounds the accumulated lower factor of
adjacent-pivot tridiagonal GEPP by `‖M‖∞ ≤ 2`.  The exact symmetric
tridiagonal counterexample in `AasenMiddleGEPPCh11Counterexample` shows that
this step is false: consecutive adjacent interchanges can move arbitrarily
many earlier multipliers into one row.  We therefore do not use that step,
nor the false coefficient-one forward certificate derived from it.

This file proves the strongest unconditional normwise statement supplied by
the literal DGTTRF/DGTTRS executor.  Its row-sparse residual correction is not
merely an a posteriori correction: among *all* matrices making the computed
solution exact, it has minimum infinity norm.  Consequently the remaining
printed quantitative claim is equivalent to bounding this observable optimal
backward error.  A final Aasen wrapper consumes exactly that scalar check.
-/

import ComputationalMathematics.Source.Higham.Chapter11.AasenAdjacentPivotSourceResidual

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.AasenAdjacentPivotSourceResidual`.
Declaration names and mathematical terminology are unchanged.
-/
