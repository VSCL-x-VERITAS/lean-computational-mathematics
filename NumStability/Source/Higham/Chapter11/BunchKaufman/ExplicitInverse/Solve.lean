/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Chapter 11: the scaled explicit-inverse 2 x 2 pivot solve

Higham, *Accuracy and Stability of Numerical Algorithms*, 2nd ed.,
Problems 11.2 and 11.5, and Higham, "Stability of the Diagonal Pivoting Method with
Partial Pivoting", SIAM J. Matrix Anal. Appl. 18 (1997), equation (4.3),
recommend solving a selected symmetric `2 x 2` pivot through

  `s = a/b`, `t = c/b`, `mu = s*t - 1`,
  `x0 = (t*f - g)/(b*mu)`, `x1 = (s*g - f)/(b*mu)`.

The definitions below implement every displayed arithmetic operation with an
`FPModel` primitive.  The proof does not assume a residual certificate.  It
extracts the eleven local standard-model errors, eliminates the right-hand
side from the two computed numerator equations, and obtains an exactly solved
nearby system.  The case-(4) scale guard keeps the two cancellation-sensitive
"minus one" quantities uniformly separated from zero.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.ExplicitInverse.Solve

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.ExplicitInverse.Solve`.
Declaration names and mathematical terminology are unchanged.
-/
