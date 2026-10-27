/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.UniformTimeGrid

/-!
# Time Grid Target

Section 2.1 works with `k > 0` and `t_n = n k` at every natural level,
including level zero. The working constant-step grid is strictly increasing.
The remark about variable steps is context, with no variable-step scheme or
finite time horizon asserted here.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- Section 2.1 works with `k > 0` and `t_n = n k` at every natural level,
including level zero. The working constant-step grid is strictly increasing.
The remark about variable steps is context, with no variable-step scheme or
finite time horizon asserted here. -/
def timeGridTarget : Prop :=
  ∀ (k : ℝ), 0 < k →
    (∀ n : ℕ, NumStability.FiniteVolume.uniformTimeGrid k n = (n : ℝ) * k) ∧
    NumStability.FiniteVolume.uniformTimeGrid k 0 = 0 ∧
    StrictMono (NumStability.FiniteVolume.uniformTimeGrid k)

end NumStability.Eymard.Chapter01
