/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Theorem 11.7: support-aware outer substitutions

The dense `fl_forwardSub` and `fl_backSub` kernels visit every structural zero
in a triangular row.  The abstract `FPModel` does not make `fl_sub a 0` exact,
so those dense sweeps honestly carry a `gamma n` budget even when the factor is
block bidiagonal.  This module implements the sparse computation that Higham's
tridiagonal analysis requires: each row visits only its two possible strict
lower-band predecessors.  Reversing the index order gives the matching upper
solve.

The local row is an actual rounded product/summation/division computation.  Its
backward error follows from Lemma 8.4 with at most three leaves (right-hand side
plus two products), yielding the dimension-independent componentwise budget
`gamma 3`.  A structural induction on `TriGrowthData` proves that the computed
`flMixedL` factor has precisely the required lower bandwidth two.
-/

import ComputationalMathematics.Algorithms.LinearSystems.SymmetricIndefinite.BlockLDLT.BunchTridiagonalSparseSolve

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Algorithms.LinearSystems.SymmetricIndefinite.BlockLDLT.BunchTridiagonalSparseSolve`.
Declaration names and mathematical terminology are unchanged.
-/
