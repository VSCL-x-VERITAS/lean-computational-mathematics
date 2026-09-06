/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Algorithm 11.9: actual skew-pivot argmax and permutation

This module replaces the scalar-only `SkewBunchPivotChoice` interface by a
finite matrix selector.  It chooses the printed pair `(p,q)`, proves the
argmax property, and constructs the symmetric row/column permutation that
moves `q` and `p` to the first two positions.
-/

import ComputationalMathematics.Source.Higham.Chapter11.Skew.ActualSelector

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.Skew.ActualSelector`.
Declaration names and mathematical terminology are unchanged.
-/
