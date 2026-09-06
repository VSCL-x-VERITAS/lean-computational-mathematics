/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Algorithm 11.2: recursive exact active-submatrix trace

Higham states Algorithm 11.2 for the first active stage; the block LDL^T
construction preceding (11.2)--(11.3) then repeats the same choice on the
Schur complement.  This module performs that recursion.  Every constructor
records the branch computed by the finite argmax selector, applies the printed
symmetric interchange, and consumes exactly one or two active indices.

The `noAction` branch is not divided by a possibly zero diagonal.  Its zero
off-diagonal leading column is removed unchanged, which is the exact meaning
of "there is nothing to do on this stage" in the source.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Exact.Trace

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Exact.Trace`.
Declaration names and mathematical terminology are unchanged.
-/
