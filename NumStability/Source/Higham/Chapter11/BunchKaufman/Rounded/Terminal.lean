/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Terminal rounded Bunch--Kaufman solve theorem for Higham Chapter 11

This module joins the literal block-diagonal middle solver to the proved
finite-precision `40 n` factor-growth estimate.  Consequently the public
solve theorems below assume neither a product-growth estimate nor an
equation-(11.5) middle-solve certificate: both are derived from the actual
rounded execution.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Terminal

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Terminal`.
Declaration names and mathematical terminology are unchanged.
-/
