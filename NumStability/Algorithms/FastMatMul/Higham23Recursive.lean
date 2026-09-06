/-
Copyright (c) 2026 QED. All rights reserved.
Released under Apache 2.0 license as described in LICENSES/Apache-2.0.txt.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.
Authors: QED
-/
import ComputationalMathematics.Algorithms.FastMatMul.Internal.LegacyBounds
import ComputationalMathematics.Source.Higham.Chapter23.BalancedScaling
import ComputationalMathematics.Source.Higham.Chapter23.BilinearAlgorithm
import ComputationalMathematics.Source.Higham.Chapter23.BlockAlgorithms
import ComputationalMathematics.Source.Higham.Chapter23.ConventionalMultiplication
import ComputationalMathematics.Source.Higham.Chapter23.ErrorRecurrences
import ComputationalMathematics.Source.Higham.Chapter23.GammaAsymptotics
import ComputationalMathematics.Source.Higham.Chapter23.Theorem02
import ComputationalMathematics.Source.Higham.Chapter23.Theorem03.Execution
import ComputationalMathematics.Source.Higham.Chapter23.ThreeM
import ComputationalMathematics.Source.Higham.Chapter23.WinogradInnerProduct

/-!
# Historical recursive Chapter 23 import

Compatibility wrapper preserving the former recursive-Strassen import surface. New code should use the canonical Chapter 23 theorem-family modules.
-/
