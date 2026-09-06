import Batteries.Data.Array.Scan
import Mathlib.Data.Vector.Basic
import Mathlib.Tactic
import ComputationalMathematics.Algorithms.LU.TridiagonalCond
import ComputationalMathematics.Source.Higham.Chapter15.Theorem07.TridiagonalLU.Basic
import ComputationalMathematics.Source.Higham.Chapter15.Theorem08.TridiagonalDiagonalDominance.Basic
import ComputationalMathematics.Source.Higham.Chapter15.Theorem09.Ikebe.Basic
import ComputationalMathematics.Source.Higham.Chapter15.Theorem09.Ikebe.IrreducibleRightInverse.RankOneStructure
import ComputationalMathematics.Source.Higham.Chapter15.Problem06.TridiagonalInverseNorm.Recurrences.EntryFormulas
import ComputationalMathematics.Source.Higham.Chapter15.Problem06.TridiagonalInverseNorm.TridiagonalInverse
import ComputationalMathematics.Source.Higham.Chapter15.Problem06.TridiagonalInverseNorm.Recurrences.FactorizationAndNorm
import ComputationalMathematics.Source.Higham.Chapter15.Problem06.TridiagonalInverseNorm.TridiagonalInverseCompletion
import ComputationalMathematics.Source.Higham.Chapter15.Problem06.TridiagonalInverseNorm.Recurrences.ArrayExecution
import ComputationalMathematics.Source.Higham.Chapter15.Problem06.TridiagonalInverseNorm.TridiagonalInverseRuns

/-!
# Higham15Problem15_6Operational (compatibility wrapper)

Import-only historical path, retained so existing imports of `NumStability.Algorithms.LU.Higham15Problem15_6Operational`
keep resolving. Its whole declaration block moved unchanged to
`NumStability.Source.Higham.Chapter15.Problem06.TridiagonalInverseNorm.Recurrences.ArrayExecution`, which is imported above. The module's own original imports are
re-stated so consumers that reached an identifier transitively through this
path still see the same surface. This module declares nothing.
-/
