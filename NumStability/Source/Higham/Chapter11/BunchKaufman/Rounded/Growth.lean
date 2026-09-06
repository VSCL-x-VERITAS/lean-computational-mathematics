/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Product growth for the literal rounded Bunch--Kaufman execution

Higham [608, 1997, sec. 4.3] proves the constant `36` first for the exact
stage factors.  Replacing those factors by computed factors incurs a finite
precision correction.  This file keeps that distinction explicit and derives
the stage scale used by the literal rounded executor from its actual active
matrices; no target-shaped product-growth hypothesis is built into the scale.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Growth

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Rounded.Growth`.
Declaration names and mathematical terminology are unchanged.
-/
