/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# The DGTTRF/DGTTRS source domain is necessarily tridiagonal

The literal DGTTRF initialisation reads only the diagonal and the two adjacent
diagonals of its matrix argument.  Consequently no source-residual estimate
against the *full* input matrix can follow from no-breakdown and a gamma guard
alone.  This file records the smallest symmetric exact-arithmetic witness.

This is a domain discrepancy, not a counterexample to Higham's Aasen theorem:
the actual computed Aasen middle factor is symmetric tridiagonal.  The witness
prevents a future closure theorem from silently omitting that source condition.
-/

import ComputationalMathematics.Source.Higham.Chapter11.AasenAdjacentPivotResidualDomain

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.AasenAdjacentPivotResidualDomain`.
Declaration names and mathematical terminology are unchanged.
-/
