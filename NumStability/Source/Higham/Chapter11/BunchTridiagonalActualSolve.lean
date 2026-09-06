/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Theorem 11.7: actual Algorithm 11.6 block solves

This module removes the abstract equation-(11.5) middle-solve input from the
tridiagonal Bunch path.  At an accepted `2 × 2` pivot, Algorithm 11.6 makes the
off-diagonal entry the largest entry in the first pivot column.  Swapping the
two equations therefore gives the actual two-step GEPP order.  The printed
pivot inequality and the fixed-scale stage bound control the only elimination
fill term, so the rounded `2 × 2` kernel has a componentwise perturbation bounded
by `36 u |E|` under `9u ≤ 1/2`.

The stage result is then folded over a `PivotSchedule`, producing the concrete
`MixedMiddleSolveHigham115Blocks` witness for every right-hand side.  The only
run condition left is that each computed second GEPP pivot is nonzero, exactly
the usual no-breakdown domain condition for a floating-point solve.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchTridiagonalActualSolve

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchTridiagonalActualSolve`.
Declaration names and mathematical terminology are unchanged.
-/
