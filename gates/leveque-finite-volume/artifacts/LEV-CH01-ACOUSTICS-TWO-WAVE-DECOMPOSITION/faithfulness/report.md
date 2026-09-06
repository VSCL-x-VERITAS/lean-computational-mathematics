# Faithfulness audit: LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `7cf0e7f193f7825eaceb8c9b1febc9b45fca8975568e8209f130d43b44e5d91b`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The formal statement captures exactly the source meaning of decomposition used in this passage: simultaneous reduction to the two characteristic scalar equations with opposite signed speeds. The omitted inverse formulas are also absent from the selected source claim.

## Implications

- **Lean implies source:** `yes`. The Lean conjunction expands to the two exact characteristic equations w^1_t+c*w^1_x=0 and w^2_t-c*w^2_x=0. With c>0 from the hypotheses, these encode the two distinct right- and left-moving waves summarized by the source.
- **Source implies lean:** `yes`. The source derivation of both characteristic equations for every solution of (1.5), together with its positive sound-speed context, directly supplies every Lean conjunct. Lean asks for no inverse formula or stronger classification of all solutions.

## Findings

- **note / decomposition-scope:** This matches the selected passage rather than silently strengthening the word decomposition.

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
| `N01` | `pass` | `pass` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `100` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `100` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/agent_outputs/agent_runs.json` (`3549d4f31f9f43dee24138efc703703f3e1976368e1583f6e12b851da609b480`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/agent_outputs/batch_source_contract.json` (`d0fd4bc8d51f4e43a915edd501472b75abc7eb59c4c22ba8049da4ed8c452133`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/agent_outputs/blind_translation.json` (`8fabe8197eeadfa4c3cf2a776adf95b2cbcc10c562da8f9326fb272f6aaaf727`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/agent_outputs/direct_judge.json` (`29a61b383ea194922a35b84aabc10b3cc89839759c7020b59146aa7a4a50e26c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/agent_outputs/roundtrip_judge.json` (`26b7c393588a26771a5668c45fe09933a8051e59edec3d1f47458bd3ec54ab43`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/agent_outputs/source_contract.json` (`8e8c066ec63a24cc779bae7e4c9597ac5cedc9a991a5f1204b25c7d599a8fc58`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/decision.json` (`cbe5fc20ea2ec8d43771d7e99bb8bfbdc669973da636652b190fcc9d6ee243e1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/agent_outputs/agent_runs.json` (`1cf5094ed51a75079b5997085e6692db57dd9e5104b627fcd090b9e35157717b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/agent_outputs/batch_source_contract.json` (`d8fdc23104f3a4ce44add59aa66515c36255136ffeac295b5f757fb7be5f1438`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/agent_outputs/blind_translation.json` (`8d0d28bf3fec0a3eec1cab054a48b8c45e043054bb8c2d239e8ebc499d3b2d49`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/agent_outputs/direct_judge.json` (`6621c3f88879a2e3e8ae05e00552e8c3140f5e68b28c87f7a6bc0ee65e1ce24c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/agent_outputs/source_contract.json` (`099d4c0a3595574f3cd619dc2ca8d5aef09d640945e1aeda3c30b8c30e4ba735`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/inputs/blind_dependency_inventory.json` (`f2adaaa9761de1a13e1d3e2eebab68fb5a3b0104a38382fd164a7d94a5050213`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/inputs/blind_dossier.md` (`2207431ecbaa1e3faf792049c093738991eb9487fba3f071a4c2d42c9e3a75f1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/inputs/blind_review_packet.md` (`2207431ecbaa1e3faf792049c093738991eb9487fba3f071a4c2d42c9e3a75f1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/inputs/declaration_dossier.md` (`a732313944a75eb2ac6b016e2428d6ee1b974247d9a08d2a45648975cfc51e15`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/inputs/dependency_inventory.json` (`e6692de86ba345466f0c41f07f7b607153a07c0661a0361e75631e38a25a04d1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/inputs/direct_review_packet.md` (`490a0a161502831f7bbe3e629d8609dfb47871eb07d27d9b9ecdbef90b33128f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/history/20260901T052901Z/inputs/source_locator.json` (`38e0b70bb0553b61e62b22ce5279c3311a8c230284d38a2a09893880878d6e1f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/inputs/blind_dependency_inventory.json` (`f2adaaa9761de1a13e1d3e2eebab68fb5a3b0104a38382fd164a7d94a5050213`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/inputs/blind_dossier.md` (`2207431ecbaa1e3faf792049c093738991eb9487fba3f071a4c2d42c9e3a75f1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/inputs/blind_review_packet.md` (`2207431ecbaa1e3faf792049c093738991eb9487fba3f071a4c2d42c9e3a75f1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/inputs/declaration_dossier.md` (`a732313944a75eb2ac6b016e2428d6ee1b974247d9a08d2a45648975cfc51e15`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/inputs/dependency_inventory.json` (`e6692de86ba345466f0c41f07f7b607153a07c0661a0361e75631e38a25a04d1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/inputs/direct_review_packet.md` (`490a0a161502831f7bbe3e629d8609dfb47871eb07d27d9b9ecdbef90b33128f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION/faithfulness/inputs/source_locator.json` (`38e0b70bb0553b61e62b22ce5279c3311a8c230284d38a2a09893880878d6e1f`)
