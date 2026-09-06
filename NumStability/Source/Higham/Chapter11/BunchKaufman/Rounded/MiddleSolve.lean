/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Actual middle solve for the literal rounded Bunch--Kaufman execution

This module closes the operational middle-solve premise in Higham's Theorem
11.3.  It recursively solves the block-diagonal factor actually stored by
`Higham11RoundedBunchKaufmanExecution`.  Scalar blocks use rounded division;
two-by-two blocks use the selected two-step GEPP producer proved to satisfy
equation (11.5).

The only extra run-domain condition is the unavoidable one for a terminal
`noAction` scalar block: its diagonal entry must be nonzero.  The scalar pivots
in cases (1)--(3) are nonzero consequences of the selector, and a successful
case-(4) constructor already records that its computed second GEPP pivot is
nonzero.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.MiddleSolve

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.MiddleSolve`.
Declaration names and mathematical terminology are unchanged.
-/
