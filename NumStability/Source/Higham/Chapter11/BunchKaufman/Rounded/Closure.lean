/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Algorithm 11.2 and Theorems 11.3--11.4: rounded closure

This module derives the local block-LDLT backward-error facts for the literal
rounded Bunch--Kaufman execution.  In particular, the two-by-two path uses the
actual selected two-step GEPP solve and its proved equation-(11.5)
componentwise backward error.  It never assumes the formally false
coefficient-one absolute coupling from the older `FlMixedPivots` interface.

The honest coupling is

  `|w_i| |c_j| <= (1 + 36 u) |w_i| |E| |w_j|`.

Together with the signed residual consequence of (11.5), this yields a fully
derived local Schur residual with constant 18 in units of `gamma_3`.

Source: Higham, 2nd ed., section 11.1.2, pp. 217--219, Algorithm 11.2,
equation (11.5), and Theorems 11.3--11.4.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Closure

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Closure`.
Declaration names and mathematical terminology are unchanged.
-/
