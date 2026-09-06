import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.ArbitraryNorm
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.BlockMatrices
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.DiagonalDominance
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.Factorization
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.FactorizationError
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.FirstOrderFamilies
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.FirstOrderModels
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.GrowthBounds
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.OperatorTwo
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.PositiveDefinite
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.PositiveDefiniteFactorBounds
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.RecursiveFactorization
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.ResidualLifting
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.SchurComplement
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.SolveError
import ComputationalMathematics.Algorithms.LinearSystems.LU.BlockLU.VaryingBlocks

/-!
# Block LU algorithms

Declaration-free aggregate over fifteen reviewed declaration-bearing reusable
Block LU leaves and the `VaryingBlocks` subaggregate over five unequal-order
leaves, completed in Phase 12. Numbered Chapter 13 correspondence is excluded;
use `NumStability.Source.Higham.Chapter13.BlockLU`. The historical
`NumStability.Algorithms.LU.BlockLU` facade imports both aggregates.
-/
