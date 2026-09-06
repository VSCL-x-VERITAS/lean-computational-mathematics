/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Algorithm 11.2: literal rounded active-submatrix execution

This module is the rounded counterpart of
`Higham11BunchKaufmanExactTrace`.  The selector is run on the current stored
active matrix, the prescribed symmetric interchange is applied, and the next
selector sees the *rounded*, stored-symmetric Schur complement.  A case-(4)
node uses the actual two-step GEPP kernel already proved to satisfy (11.5).

The executor is total: if the computed second GEPP pivot is zero it records a
`case4Breakdown` node.  Thus successful completion is an observable property
of the produced execution, not a hidden premise in its construction.

Source: Higham, 2nd ed., section 11.1.2, pp. 217--219, Algorithm 11.2 and
equation (11.5).
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Execution

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Execution`.
Declaration names and mathematical terminology are unchanged.
-/
