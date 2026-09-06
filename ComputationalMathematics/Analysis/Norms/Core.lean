-- Analysis/Norms/Core.lean
--
-- Declaration-free aggregate for the reusable norms APIs.

import ComputationalMathematics.Analysis.Asymptotics
import ComputationalMathematics.Analysis.Conditioning
import ComputationalMathematics.Analysis.LinearOperators
import ComputationalMathematics.Analysis.MatrixNorms
import ComputationalMathematics.Analysis.OperatorNorms
import ComputationalMathematics.Analysis.SingularValues.Basic
import ComputationalMathematics.Analysis.SingularValues.Realification
import ComputationalMathematics.Analysis.VectorNorms

/-!
# Reusable norms aggregate

This module keeps the historical `NumStability.Analysis.Norms.Core` path
importable for its reusable mathematical subset while declarations live in
focused semantic owners. Numbered Chapter 6 results are available through
`NumStability.Source.Higham.Chapter06.Norms` or the broader historical
`NumStability.Analysis.Norms` facade.
-/
