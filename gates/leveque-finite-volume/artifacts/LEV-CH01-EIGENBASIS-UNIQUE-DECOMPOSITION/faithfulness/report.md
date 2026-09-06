# Faithfulness audit: LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `5bb5f8271d1ada27fc703cd969c821a5f724a7727f5517347301b422a6877bd5`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The declaration faithfully states the page-25 unique eigenbasis decomposition consequence. Its only extension is the harmless zero-dimensional boundary.

## Implications

- **Lean implies source:** `yes`. Lean supplies one fixed real eigenbasis and explicitly gives an exact unique amplitude tuple for every vector, which is the source consequence.
- **Source implies lean:** `yes`. The source m independent real eigenvectors form a basis of R^m, and its unique-decomposition conclusion supplies exactly the Lean ExistsUnique amplitudes.

## Findings

- **note / degenerate-dimension-extension:** The empty-dimensional instance is coherent and trivial; equivalence on the cited positive-dimensional domain is unchanged.
- **minor / zero-dimensional-domain-extension:** This adds only the consistent empty-vector-space case. It neither weakens nor changes the claim on the source's intended positive-dimensional domain, so it does not change the equivalence classification.
- **note / algebraic-representation:** No selected conclusion is lost: the source uses the PDE setting as motivation, while the unique-decomposition assertion depends only on the eigenbasis.

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

- Blind translator covered `45` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `45` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/agent_outputs/agent_runs.json` (`3f68b81bc1b72c089c6f5b13cc728b4eccbb2b8610f91de24f501db6abe6fae1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/agent_outputs/batch_source_contract.json` (`fe7d116cf60b85222283c704141de3ad0bdb72cda6da84ca010c19fbb4d75440`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/agent_outputs/blind_translation.json` (`5b557173cb450e78662218d1a1b7aaf35bcd8b26ff1ea27a8ba918150aa8423c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/agent_outputs/direct_judge.json` (`eca137eb5b4f6bcda9f3c2c8aa260fe391619bb93cc9ca45187142c6340e9495`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/agent_outputs/roundtrip_judge.json` (`1451bf5c14135f48cb80a97c28fd7b74ce36304b55fb72875302ff37b7942f94`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/agent_outputs/source_contract.json` (`06f4935b4e0712221d91e46292342691ca0dea5790d0a357436cb08f34dffca2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/decision.json` (`0e9f08bff4547dfcdbe85bb4007b0e80fde7416a1be3fea31bf6a45a83506404`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/inputs/batch_source_locator.json` (`b56e3eeb27c8dfa2b3c34724ee064695b80433250e930ba13128ca7091d3973b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/inputs/blind_dependency_inventory.json` (`60c6d8a9004e0df82d07baf49f0f6a7e98120eca16555c2758d654be3130c0a8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/inputs/blind_dossier.md` (`3f45dd10a7e333a66fa752cf710e20de761a272c1e1e7a488a07a9eb79f96699`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/inputs/blind_review_packet.md` (`3f45dd10a7e333a66fa752cf710e20de761a272c1e1e7a488a07a9eb79f96699`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/inputs/declaration_dossier.md` (`ea96cd6d4e7586ce5c78334f0a3d923b2fc3fcee650a88fc90b5a3b480139913`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/inputs/dependency_inventory.json` (`09e42c7c2dff001fc9308aa5b6e225414fc7a70d40a797978e8b628fcc47d8c6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/inputs/direct_review_packet.md` (`defc2ccae07c65a203db2db77952c2077b95c779bc86d25ecdc16116f4d8e85d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EIGENBASIS-UNIQUE-DECOMPOSITION/faithfulness/inputs/source_locator.json` (`b8800777af1aac6348b3dbff17878f15bde3f5a7450ade117e4f40235865befb`)
