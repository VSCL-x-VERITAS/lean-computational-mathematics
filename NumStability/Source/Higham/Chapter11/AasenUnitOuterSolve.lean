/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Support-aware outer solves for Aasen's method

The computed Aasen lower factor has first column `e₁`.  Together with lower
triangularity this makes it a direct sum `1 ⊕ Ltail`.  A source-faithful
outer solve therefore does not execute arithmetic against the structural-zero
off-block entries: it solves the scalar head and the `(n-1)`-dimensional tail
separately.  The ordinary Chapter-8 backward-error theorem applied to the tail
then gives the printed `gamma_(n-1)` coefficient.
-/

import ComputationalMathematics.Source.Higham.Chapter11.AasenUnitOuterSolve

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.AasenUnitOuterSolve`.
Declaration names and mathematical terminology are unchanged.
-/
