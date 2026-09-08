# Faithfulness audit: LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `d4ce5a2183d62bbeeb6146c775cf754a205c7951317e26179d07deb0e34cddd7`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The complete hash-verified packet, all 45 dependencies, and all 18 configured checks support equivalence with the selected source sentence. The target retains the real finite-dimensional setting, complete independent eigenvectors, a single fixed eigenbasis for all state vectors, and exact existence and uniqueness of coefficients. Basis packaging and the empty-dimensional case are harmless reformulations. The adjacent wave interpretation is outside the selected assertion and is correctly absent.

## Implications

- **Lean implies source:** `yes`. For a source-admissible real matrix, the target supplies real eigenvalues and a complete independent corresponding eigenbasis, fixed before the state vector. Its explicit ExistsUnique expansion gives exactly one real coefficient assignment for every vector in that family. The source's reference to these eigenvectors is preserved because the same basis occurs in both conjuncts. If the source family is regarded as already fixed arbitrarily, its m independent vectors constitute a basis of R^m, whose invertible coordinate representation gives the same existence and uniqueness; existential packaging therefore loses no substantive decomposition case.
- **Source implies lean:** `yes`. Under the inherited hyperbolicity condition, choose the corresponding real eigenvalues and m independent eigenvectors supplied by the source. In R^m that family is a basis and satisfies the stated right-eigenvector equations. The selected source assertion supplies a unique real coefficient expansion for every state vector in this fixed family, which is exactly the target's finite sum and ExistsUnique predicate after indexing by Fin m. The empty-dimensional instance follows from unique empty functions and the empty sum and creates no additional substantive source obligation.

## Findings

- **note / witness-packaging:** This is a faithful packaging of an unspecified chosen family. It does not assert a canonical or unique eigenbasis, and uniqueness concerns coefficients only.
- **note / empty-dimensional-completion:** The added empty instance has one state vector, one coefficient function, and the empty expansion, so it is a harmless completion of the same finite-dimensional statement.
- **note / basis-packaging-and-proof-content:** The basis interface packages the finite-dimensional completeness argument and makes the coordinate conclusion structurally available. This affects proof content, but does not change the mathematical applicability or conclusion of the selected statement.
- **note / zero-dimensional-boundary:** The translation explicitly covers the harmless empty-dimensional boundary while preserving every intended positive-dimensional case. This is not substantive nonvacuous strengthening.

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

- Blind translator covered `45` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `45` dependencies (`42` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`e01135c886f7ec731b5c87fcf3badd140ba64d89e467c2088114db98e4ce0a7c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`a6b8cf217c9fe62c26502b6a24d41e9d012db6899e5383941af5358c21a734c4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`2c1ed7802351c1089620327fe0cf22d34adb46bcbab702328da20e9caa9a31f9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`8466acfcbb01965570e235ba9b5262e00631eeae2fa9d64b0058c793e3e5cc2e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`0ae8365e073610f0b056f9d56e476a664f709d6c88eca3526ea33c5c66c1ae72`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/decision.json` (`ed28c8865f9151368b7fe894bdda8dd3d3b55cb855db3cd523f7bcc123fd3161`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`c18f1d9170ca6364f232574d63f9081eae350e73aeeea4835f618b30a4f18e61`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`e101a77fbfb255db465be70cc5fd80de3179300e93ee5700df0d86933101d458`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`e101a77fbfb255db465be70cc5fd80de3179300e93ee5700df0d86933101d458`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`ab9374e05e594da115615e7db8f7fa7e1e60abb2ec60244a4bd7f9e01b3a39eb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`d46759d2e72ede5e035f39e9d91206316e9061b7c320dbf4323061c7213f7d86`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`2b96d55741c05e94f9ef6044bac47245e858cb880191c62c511a77fee8453f0b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`916cf1d0cb2f40cc0edcf3e5203c84474f3e2a9718bcb934463c2827b31c2405`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`ba5fc7ac6d3f606bbd176ff64ba6eda8bacc1d69e200190c1b89af5cc702e9bc`)
