/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Algorithm 11.2: actual finite first-pivot selector

The chapter-level predicate `BunchKaufmanPartialPivotCase` records the four
printed scalar tests but, by itself, does not compute the column maxima, the
maximizing row, or the symmetric interchange.  This module constructs those
objects from a finite matrix.  It is the matrix-level front end needed by a
permutation-aware recursive Bunch--Kaufman executor.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.ActualSelector

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.ActualSelector`.
Declaration names and mathematical terminology are unchanged.
-/
