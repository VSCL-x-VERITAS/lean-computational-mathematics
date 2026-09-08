# Faithfulness audit: LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `d4ce5a2183d62bbeeb6146c775cf754a205c7951317e26179d07deb0e34cddd7`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The complete, hash-verified packet expresses the source's matrix hyperbolicity definition without additional hypotheses or missing eigenstructure conditions. The distinction between an indexed eigenbasis and m independent eigenvectors in R^m is an equivalent finite-dimensional reformulation. Real scalar types, right matrix action, family cardinality, witness scope, and exact equalities agree with the primary PDF. The unique-decomposition consequence is mathematically retained. The source's wave interpretation provides context for the chosen definition; the target does not purport to formalize the separate PDE decoupling argument. All dependencies and configured checks are resolved at the declared external-library boundary.

## Implications

- **Lean implies source:** `yes`. In the source setting of a fixed real m by m coefficient matrix, the target characterizes hyperbolicity by real numbers lambda_p and m linearly independent real vectors r_p with A r_p = lambda_p r_p. Matrix.mulVec is the right matrix action, and the explicit scalar action is ordinary real multiplication. The chosen vectors form a basis of R^m, yielding the unique expansion stated immediately after the source definition. The canonical predicate on the left requires exactly such an eigenbasis. Thus the target supplies the selected defining criterion for every intended source matrix.
- **Source implies lean:** `yes`. The source's full independent real eigenvector family can be indexed by Fin m. In an m-dimensional real space it is a basis, so its eigenvalue equations furnish D002; conversely, D002's basis is independent and supplies the target's right-hand witnesses. Neither direction requires distinct or nonzero eigenvalues or restrictions on A beyond its real square type. The additional m = 0 case is independently immediate from the empty basis and empty family, and does not change the source criterion on its intended dimensions.

## Findings

- **note / empty-dimensional-extension:** The target additionally includes the harmless empty-dimensional equivalence, where both the eigenbasis criterion and the empty independent-family criterion hold. This does not exclude a source case or justify a stronger classification.
- **note / zero-dimensional-extension:** This is an explicitly identified, valid algebraic extension. It changes no stated source case and should not be described as a source assertion about zero-component PDEs.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `44` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `44` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`a98d3a8c3e05a69f98186455f5b166d4fc142dd38541efacff10f0fecdd4c948`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`7a08986aa17f23d53072700e56d63fdfd1aea9dedc6275567005e76802c702fa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`e4431592f8b5f472d0b69f52a4b3e452df8218a252f8d63dd2a6cccaf3e287fc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`b036146bf6397d9ace872e9a2d5cdb515766aa11e03d5df2c339f1c523c52d41`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`cd01d1079c9d69fe1906e8bd2e637d74f3d115addb431092395195a8026dbc39`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/decision.json` (`0f5cd7898d4df556d7846bae42196ac05345bea41672a1b1b6bc570de495fb2d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`8878013a11eee4d09afaf42dade9fa23f3ae4f4c4c406dde4cb36bb857a4c608`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`6f66dc33aa5f583519337f6fdc5de45e7a343ce966cf20c9812c2d967e513409`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`6f66dc33aa5f583519337f6fdc5de45e7a343ce966cf20c9812c2d967e513409`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`3569f61bb560f9bab68f566a10c5f32cb4408e4966a4380522c1b4658ec9d700`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`8ca95ae19c70462120d099677cd5daf652455f66c61481ae091adf6089d8eb0c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`660bdc47e6b4c02485f2072158863d8a94479eb34c99aa0d3c6edca4d1afb0ba`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`9db139cddefbee9127c55e85e3389432e6675d843adcedcdccdef636652710d7`)
