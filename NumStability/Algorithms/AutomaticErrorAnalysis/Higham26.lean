/-
Copyright (c) 2026 QED. All rights reserved.
Released under Apache 2.0 license as described in LICENSES/Apache-2.0.txt.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.
Authors: QED
-/
import ComputationalMathematics.Source.Higham.Chapter26.AlternatingDirections.ExactExecution
import ComputationalMathematics.Source.Higham.Chapter26.CubicRoots.DepressedCubic
import ComputationalMathematics.Source.Higham.Chapter26.CubicRoots.MonicCubic
import ComputationalMathematics.Source.Higham.Chapter26.Equation01
import ComputationalMathematics.Source.Higham.Chapter26.Equation02
import ComputationalMathematics.Source.Higham.Chapter26.Equation03
import ComputationalMathematics.Source.Higham.Chapter26.Equation04
import ComputationalMathematics.Source.Higham.Chapter26.Equation05.CardanoRoots
import ComputationalMathematics.Source.Higham.Chapter26.Equation05.ComplexBranches
import ComputationalMathematics.Source.Higham.Chapter26.Equation05.RealBranches
import ComputationalMathematics.Source.Higham.Chapter26.Equation05.ZeroBranchDiscrepancy
import ComputationalMathematics.Source.Higham.Chapter26.Equation06
import ComputationalMathematics.Source.Higham.Chapter26.Equation07
import ComputationalMathematics.Source.Higham.Chapter26.Equation08
import ComputationalMathematics.Source.Higham.Chapter26.IntervalArithmetic.DependencyExamples
import ComputationalMathematics.Source.Higham.Chapter26.IntervalArithmetic.DirectedRounding
import ComputationalMathematics.Source.Higham.Chapter26.IntervalArithmetic.ExactOperations
import ComputationalMathematics.Source.Higham.Chapter26.MultidirectionalSearch.Execution
import ComputationalMathematics.Source.Higham.Chapter26.MultidirectionalSearch.Simplex

/-! # Compatibility import for Higham Chapter 26

Deprecated import path for the original Chapter 26 core. The canonical
declarations now live below `NumStability.Source.Higham.Chapter26`.

This wrapper deliberately excludes the crude-search and initial-simplex
producer leaves that were never exposed by this historical module.
-/
