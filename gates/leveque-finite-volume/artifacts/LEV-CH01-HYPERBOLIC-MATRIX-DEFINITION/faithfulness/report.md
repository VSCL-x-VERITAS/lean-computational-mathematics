# Faithfulness audit: LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `5bb5f8271d1ada27fc703cd969c821a5f724a7727f5517347301b422a6877bd5`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The theorem exactly characterizes real matrix hyperbolicity by a full linearly independent family of real eigenvectors, without imposing distinct eigenvalues or normalization.

## Implications

- **Lean implies source:** `yes`. The Lean criterion gives real eigenvalues, m linearly independent real eigenvectors, and every corresponding eigenpair equation, exactly the source definition.
- **Source implies lean:** `yes`. The source criterion supplies the Lean right-side witnesses, and m independent vectors in R^m form the Basis witness used by the local left predicate.

## Findings

- **note / degenerate-dimension-extension:** The empty-dimensional iff is coherent; the cited positive-dimensional definition is unchanged.
- **minor / zero-dimensional-domain-extension:** The additional case only equates the empty basis with the empty independent family. It does not alter or weaken any source-intended positive-dimensional instance and therefore does not change the equivalence classification.
- **note / matrix-level-representation:** No classification semantics are lost because the source attaches no solution or regularity premise and makes A the sole determining object.

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
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `44` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `44` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/agent_outputs/agent_runs.json` (`30fc371082d2ee90f8127b8078a513110ec0427710606cfe9803db050edbabb6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/agent_outputs/batch_source_contract.json` (`fe7d116cf60b85222283c704141de3ad0bdb72cda6da84ca010c19fbb4d75440`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/agent_outputs/blind_translation.json` (`09e768a3070a8fab5a9ecd78d2b12cc57a8c2f1bbfa873a40f4be4b10c025717`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/agent_outputs/direct_judge.json` (`5cc22dd2ddf12e194e576d2bd2f1364655c6cad5b865c4c310e116ecc094785c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/agent_outputs/roundtrip_judge.json` (`02b6eccb2a1abb41624d9416ca5bff53661dc87dfb830f3d91a8d00546678ce5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/agent_outputs/source_contract.json` (`6d0903ccd82435363d4715952a9cd00b4ce81a957e2f71adafe319aa2f671873`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/decision.json` (`403c217c381ba7f3f6b2016862adfb494ce2a87cd568d7bf910afe9051d9edd4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/inputs/batch_source_locator.json` (`b56e3eeb27c8dfa2b3c34724ee064695b80433250e930ba13128ca7091d3973b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/inputs/blind_dependency_inventory.json` (`70258c8e6187fd247d445fe9b120c8ec5b9d9e3ca12d9686c1e2ff2f76e7804a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/inputs/blind_dossier.md` (`1c2624052a7a4d3eb7fb0c286fdf3ed22432f7a0ba0799e69ba36f3316f76714`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/inputs/blind_review_packet.md` (`1c2624052a7a4d3eb7fb0c286fdf3ed22432f7a0ba0799e69ba36f3316f76714`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/inputs/declaration_dossier.md` (`0409285f7973821e614715d575ed8f1a3836c132d718516ef0a123be600b6d49`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/inputs/dependency_inventory.json` (`b21541186d91924aec374d8d6b22442a90d7256b2489b28ddc419857656de406`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/inputs/direct_review_packet.md` (`60cb9fe89e1eb417fef67ae27706057f67b33faaa2d7c4f39e9877343428a2d7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HYPERBOLIC-MATRIX-DEFINITION/faithfulness/inputs/source_locator.json` (`312f04f2c7655b1f8d71dddcc70fd9976c106241bae77c2e45fb53a3ffe31aab`)
