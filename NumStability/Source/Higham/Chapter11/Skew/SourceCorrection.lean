/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Algorithm 11.9: printed two-column pivot discrepancy

Higham, 2nd ed., Chapter 11, pp. 225--226, claims that Algorithm 11.9's
search of the first two active columns makes both entries of every row of
`C E^{-1}` at most one in modulus.  The finite example below shows that this
does not follow: after the selected row/column is moved into position two,
that new column was not searched and can contain an arbitrarily larger
entry.

The final theorem records a source-honest correction: a global maximum
skew pivot (complete pivoting) does give both multiplier bounds.
-/

import ComputationalMathematics.Source.Higham.Chapter11.Skew.SourceCorrection

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.Skew.SourceCorrection`.
Declaration names and mathematical terminology are unchanged.
-/
