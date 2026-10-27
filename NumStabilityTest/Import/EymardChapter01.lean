/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.Eymard.Chapter01

/-! Integration checks for the three accepted Chapter 1 wrappers. -/

namespace NumStabilityTest.EymardChapter01

open NumStability.Eymard.Chapter01

example : localConservativityTarget := localConservativity
example : cellUnknownsTarget := cellUnknowns
example : conservativeExchangeTarget := conservativeExchange

end NumStabilityTest.EymardChapter01
