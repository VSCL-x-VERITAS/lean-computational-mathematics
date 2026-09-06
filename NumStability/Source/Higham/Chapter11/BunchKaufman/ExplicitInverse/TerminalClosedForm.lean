/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Closed-form terminal bounds for the explicit-inverse pivot solve

This module carries the actual scaled explicit-inverse implementation for
Algorithm 11.2 all the way to the source-coordinate endpoint of Theorem 11.4.
The local two-by-two solve contributes `360u`, the finite factorization path
coefficient is replaced by a dimension-only bound, and the final result is
an exact linear term plus an explicit quadratic remainder.

Sources: Higham, *Accuracy and Stability of Numerical Algorithms*, 2nd ed.,
Problems 11.2 and 11.5 and Theorems 11.3--11.4, pp. 218--219; Higham,
"Stability of the Diagonal Pivoting Method with Partial Pivoting" (1997),
equations (4.3)--(4.5).
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.ExplicitInverse.TerminalClosedForm

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.ExplicitInverse.TerminalClosedForm`.
Declaration names and mathematical terminology are unchanged.
-/
