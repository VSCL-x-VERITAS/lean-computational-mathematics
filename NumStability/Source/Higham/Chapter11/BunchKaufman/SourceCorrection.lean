/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# The Higham (1997) exact/computed Bunch--Kaufman product interface

Higham's 1997 analysis proves the `36 n rho_n` max-entry estimate for the
exact factors `|L||D||L^T|`.  Section 4.3 of that paper then observes that
replacing the exact factors by computed factors changes this product by a
first-order amount.  The book prints the computed factors under the unchanged
exact coefficient.  This file records the distinction formally.

The first result is a one-dimensional counterexample to exact transport of the
coefficient.  The remaining results give the finite-precision replacement:
entrywise factor inflation by `1 + epsL` and `1 + epsD` inflates the product by
`(1 + epsL)^2 (1 + epsD)`.  A final polynomial identity isolates the extra
term as second order after multiplication by a first-order backward-error
coefficient.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.SourceCorrection

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.SourceCorrection`.
Declaration names and mathematical terminology are unchanged.
-/
