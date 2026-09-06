/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Closed-form rounded Bunch--Kaufman terminal bounds

This module removes the path-dependent residual coefficient from the public
rounded Bunch--Kaufman solve theorem.  It also records the quantifier order
behind Higham's first-order statement: for each fixed dimension, under an
explicit small-unit-roundoff guard, the exact finite-precision radius is a
linear polynomial in `u` plus a displayed quadratic remainder.

Source: Higham, *Accuracy and Stability of Numerical Algorithms*, 2nd ed.,
Theorems 11.3--11.4, pp. 218--219.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.TerminalClosedForm

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.TerminalClosedForm`.
Declaration names and mathematical terminology are unchanged.
-/
