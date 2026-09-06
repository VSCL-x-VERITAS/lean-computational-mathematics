/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham Theorem 11.8: honest operational DGTTRF/DGTTRS middle certificate

Higham, 2nd ed., p. 224 says that the symmetric-tridiagonal middle system in
Aasen's method is usually solved by GEPP.  The literal adjacent-pivot executor
in `AasenAdjacentPivotTridiagExecutorCh11Closure` models the corresponding
DGTTRF/DGTTRS storage and arithmetic.  Its previously proposed `gamma_6`
composition is conditional on `DGTTRFFactorForwardCertificate`; the concrete
three-by-three trace in
`AasenAdjacentPivotTridiagForwardCounterexampleCh11` proves that certificate
false after two consecutive adjacent interchanges.

This file therefore does not reintroduce the failed accumulated-factor
premise.  Instead it constructs the canonical rank-one correction directly
from the *observable source residual* of the actual computed solution.  The
correction gives an unconditional exact `AasenDirectMiddleBudget` once the
actual no-breakdown and `gamma_3` guards are supplied.  Its entries are
explicit, so the remaining quantitative gate is exactly the checkable norm
bound on this residual correction; the final theorem feeds that obligation,
without a hidden factor-forward certificate, into the existing printed-radius
Theorem-11.8 assembly.
-/

import ComputationalMathematics.Source.Higham.Chapter11.AasenAdjacentPivotOperationalMiddle

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.AasenAdjacentPivotOperationalMiddle`.
Declaration names and mathematical terminology are unchanged.
-/
