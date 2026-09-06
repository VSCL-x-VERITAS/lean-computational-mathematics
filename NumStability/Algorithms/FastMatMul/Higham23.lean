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
import ComputationalMathematics.Source.Higham.Chapter23.ThreeM
import ComputationalMathematics.Source.Higham.Chapter23.WinogradInnerProduct

/-!
# Historical Higham Chapter 23 import

Compatibility wrapper for the former base Chapter 23 implementation. New code should import `NumStability.Source.Higham.Chapter23` or a specific canonical leaf.
-/
