/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Flat factors for the rounded Algorithm 11.2 execution

This file flattens the stagewise symmetric interchanges and block eliminations
of `Higham11RoundedBunchKaufmanExecution` into one global permutation and named
finite matrices `Lhat,Dhat`.  Later stages permute only the current trailing
indices; the lift operations below make that invariant explicit.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Factors

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Factors`.
Declaration names and mathematical terminology are unchanged.
-/
