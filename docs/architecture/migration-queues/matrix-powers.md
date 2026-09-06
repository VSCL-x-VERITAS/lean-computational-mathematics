# MatrixPowers migration queue resolution

The exact frozen W06 MatrixPowers family contained 23 historical modules and 423 routed declarations. This wave closes that bounded queue: all 23 paths are declaration-free compatibility wrappers, all 390 public declarations retain their original names, and the 33 private declarations move with their six atomic proof closures.

The six formerly declaration-bearing owners route as follows:

| Historical owner | Retained declarations | Canonical owner |
| --- | ---: | --- |
| `Analysis.MatrixPowersBinomialBound` | 17 | `Analysis.LinearOperators.MatrixPowers.Henrici.BinomialPowerBound` |
| `Analysis.MatrixPowersHenriciNormal` | 2 | `Analysis.LinearOperators.MatrixPowers.Henrici.NormalMatrices` |
| `Analysis.MatrixPowersSchur` | 9 | `Analysis.LinearOperators.MatrixPowers.ExactNormBounds.Schur` |
| `Analysis.MatrixPowersSpijkerClosure` | 4 | `Analysis.LinearOperators.MatrixPowers.Spijker.KreissBounds` (2 reusable); `Source.Higham.Chapter18.Section01.MatrixPowerBounds.NamedBounds.SpijkerKreiss` (2 source endpoints) |
| `Analysis.MatrixPowersSpijkerPlanar` | 5 | `Analysis.LinearOperators.MatrixPowers.Spijker.PlanarAlgebra` |
| `Analysis.MatrixPowersSpijkerPlanarAnalysis` | 17 | `Analysis.LinearOperators.MatrixPowers.Spijker.PlanarAnalysis` |

The machine-readable companion lists every historical route. The original phase-wide `unclassified-queue.tsv` remains an immutable discovery snapshot; current classification authority is `tiers.json` plus `layout-exceptions.json`.

F0 and other residual compatibility families are not part of this queue closure. Their historical imports can be narrowed in their own reviewed waves without reopening these 23 routes.
