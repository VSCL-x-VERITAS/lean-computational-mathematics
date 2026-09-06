import ComputationalMathematics.Algorithms.Summation.Accumulator
import ComputationalMathematics.Algorithms.Summation.Compensated
import ComputationalMathematics.Algorithms.Summation.DoublyCompensated
import ComputationalMathematics.Algorithms.Summation.Insertion
import ComputationalMathematics.Algorithms.Summation.Pairwise
import ComputationalMathematics.Algorithms.Summation.PlusMinus
import ComputationalMathematics.Algorithms.Summation.Recursive
import ComputationalMathematics.Algorithms.Summation.Tree

/-!
# Summation algorithms

This complete published surface re-exports the canonical recursive, pairwise,
tree-based, insertion, compensated, and accumulator summation families.
Reusable code should prefer narrow semantic leaves such as `Recursive.Core`,
`Pairwise.Core`, and `Tree.Chain`; the broad family umbrellas intentionally
retain supported Chapter 4 source declarations.
-/
