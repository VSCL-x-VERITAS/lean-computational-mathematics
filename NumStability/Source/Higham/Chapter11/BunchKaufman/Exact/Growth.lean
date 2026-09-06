/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Exact and small-`u` Bunch--Kaufman product growth

This module proves the exact-factor inequality quoted in Higham's discussion
of Theorem 11.4.  The proof is attached to the literal Algorithm 11.2
producer: every branch equality is computed from the current active matrix,
and the global factors are the factors flattened from that execution.

Higham [1997, §4.3] proves the constant `36` for the exact factors and observes
that replacing them by computed factors changes the analysis by `O(u)`.  The
exact theorem below formalizes that source argument.  The same structural
proof, combined with the sharper finite-`u` local bounds proved for the literal
GEPP producer, also yields an independent strengthening: the computed factors
retain the constant `36` when `36u ≤ 1/1000` and the execution completes.

The rounded strengthening uses the maximum over the *rounded* active matrices
actually visited.  It does not identify that quantity with the exact-path
growth factor, and neither theorem assumes a product-entry or target-shaped
growth bound.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Exact.Growth

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Exact.Growth`.
Declaration names and mathematical terminology are unchanged.
-/
