# Faithfulness audit: LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `480a9f3d250898da50839eff61e720ed8fd557936ac6ec6fcfb0f15dddcef647`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The disagreement turns on whether unspecified extensions of the source's equation notation must themselves be formalized. The primary page selects an equation-form introduction, not a comprehensive solution theory. The supplied declarations preserve its objects, derivative roles, coefficient constancy, matrix orientation, and exact residual. Rechecking the disputed dependencies confirms ordinary real coordinate topology and genuine slice derivatives, with no hidden regularity restriction on q. Pointwise characterization preserves the equation's meaning and can be universally closed for global classical satisfaction without confusing that closure with an assertion that every field solves it. Both semantic implication directions hold at this definitional level. The empty-dimensional convention excludes no source case, and positive-dimensional examples establish nonvacuity. Acceptance follows from those primary semantic correspondences, not from agreement counts or provenance hashes.

## Implications

- **Lean implies source:** `yes`. As an equation definition, the target reproduces (1.1) under its stated real-domain and partial-derivative conventions. Unfolding D001 and D002 yields actual time and space derivative vectors satisfying qt + A qx = 0, with ordinary left matrix action and vector zero. The characterization applies at every point without asserting arbitrary or global solution satisfaction.
- **Source implies lean:** `yes`. The displayed equation, read classically where asserted, requires precisely the two partial derivatives and their zero residual. Representing their values by existential witnesses and currying the domain preserves that condition. The defined predicate therefore admits the stated equivalence. No additional smoothness premise or excluded source case is introduced; the empty-dimensional instance is a harmless definitional extension.

## Findings

- **note / definition-versus-solution-assertion:** Definitional reflexivity is appropriate here and does not make solution satisfaction vacuous. The target must not be reported as a solution-existence or global-satisfaction theorem.
- **note / regularity-and-applicability:** The target does not reduce theorem applicability through additional hypotheses. Its explicit classical derivative semantics are not grounds for a faithful-stronger classification.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `unclear` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `74` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `74` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The selected paragraph does not specify a broader generalized solution concept or a global regularity class. Acceptance concerns the classical meaning of its displayed equation and does not establish equivalence with weak or distributional satisfaction.
- The source does not explicitly discuss zero-component systems. The formal empty-dimensional instance is accepted as a conservative definitional convention, not as an asserted physical case or substantive strengthening.
- Primary-source inspection used the supplied page rendering. The PDF bytes and supplied provenance hashes were not independently recomputed.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`16eec1d0e0c7492e95671418d80f501a52b7f0a01c6c379b15f74c32ea837878`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`6194b59c699342a1fb0d35d79bee67d12704934cb8f9f70e03b4d45546ab5d40`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`7ff6e8effdec98a28d3234879a8c914da50d128b0e46081da219e41d3d6328bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`7fb786f2780dd55df5ef311e88ba04321ce72720939b9a5076fee1eb48a88a82`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`248db3bd0c565e8d6f2d514dcd74a58c64e2d0a8f4575d88b4e8de5dddde6d61`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`4d14fecc64e0cf3d04d81a3dcdb5c3089dac008eb962a19231cb7afe570eeacb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/decision.json` (`2ee6958a3f12cd57881e33236699d92da47bc0535cc476a29f3ea4d63769109f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`bc8bb5b84cdef1a237d213d4c978600a85330a939aafe66c196a1cda816f1514`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`82e135f2dc0b669a94cd6ab99c6c8622fb67f878c72fdb687393da805f190af5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`82e135f2dc0b669a94cd6ab99c6c8622fb67f878c72fdb687393da805f190af5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`48ce4f8b3ba317e5685047ab1561bb7d09b47d01ccf8b617faada76db61c816d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`4a13741462c47366cdd0ff5bf06d130c3e1d07ac4dc2d56c014063591f9dcce5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`d5cce20815ca2b0be123b788b7b7fb87a50abf9d023c3fbbb3b81ed462465cf4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`35b6b01b90f2cc9fdb991a596d07e0c3c42b163599e6e6fa45cb9316f2068a41`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`7fa7e9769ccc441b2e18c27c9a6bf8661c96531b938f893f85131d227ed5d9f5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/cli_role_collector.py` (`c03a2c5f683e51cf1ce6cf8a6bc9f2bb8fc0a08508ee1a583bb01f1b63619ee8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/cli_role_runner.py` (`ef7d6a395fa83f7e669b8e6bcd0475f0299b644c37e74e638544af7e50a805a1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_adjudicator_cli_events.jsonl` (`5cac420498cb689f1b24156eb79b430af9909f2a97863b814ba52525945c4476`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_adjudicator_cli_final.json` (`16eec1d0e0c7492e95671418d80f501a52b7f0a01c6c379b15f74c32ea837878`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_adjudicator_cli_input.txt` (`542162b166607d9224e58b4ac37d2e78b451ce041c944ec593f705cd464194e0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_adjudicator_cli_runtime.json` (`949072a483a3891f9fab5b3d35cd9cbfd9cc91f161af89989c91b1e1d85c8ec2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_adjudicator_cli_stderr.txt` (`66819de8148ae417bef480828192f83e61b82ea9982ee7e284226ccf1b7e3d4e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_adjudicator_cli_transport.json` (`c47c3e562d4c91c1d5d6e093dfa8eff11dac42180dc1235e6d8d7f2d355be4af`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_blind_cli_events.jsonl` (`d30ad30487b507eb096ca40aa41adad77d07fd4a42f721813d5385efad965ccb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_blind_cli_final.json` (`7ff6e8effdec98a28d3234879a8c914da50d128b0e46081da219e41d3d6328bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_blind_cli_input.txt` (`67d1ee5c218f696424126503c4ef7260849ae4910ba985226bbf4a07e98686b3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_blind_cli_runtime.json` (`2f62a1b5492462377b53463917a2467c966d5d1cc82018bb0d84bce9e68b4a8d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_blind_cli_stderr.txt` (`ed3679bb5c32e6b9db380acad99a1433c1d24c26fea71ef3628c339ea694da66`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_blind_cli_transport.json` (`a5000b623e1bcc679c453131ae5704a53614b93d4464d2ddf8b259d24c0603da`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_direct_cli_events.jsonl` (`98cf5754727948d2812ecd4e04d047b8bff71fb2a1f066048f119e0841f2d315`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_direct_cli_final.json` (`7fb786f2780dd55df5ef311e88ba04321ce72720939b9a5076fee1eb48a88a82`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_direct_cli_input.txt` (`ece9170b2835f0e94d3c84bfc323c4b1f83337495f7acc67484bce3101de6061`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_direct_cli_runtime.json` (`b789b21e6d106c883c840018ee7d1079e49f6cb4cd88603153fcd84395312258`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_direct_cli_stderr.txt` (`35c4e7c5cdf8b29d4293421938841de9b0f57d0224d01c9a150c8f16bc8c5be2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_direct_cli_transport.json` (`8b3f3e6ce3a2cb45bcfea24d141ca040b6d09fb8e5ae1d8d3b20d9208f9eeae5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_roundtrip_cli_events.jsonl` (`5350b6d6a9c51025e1940e407059f6121f6c053a0edf73c66508e1205ae6258a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_roundtrip_cli_final.json` (`248db3bd0c565e8d6f2d514dcd74a58c64e2d0a8f4575d88b4e8de5dddde6d61`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_roundtrip_cli_input.txt` (`0d7e1f4ad3ed8d58fe23888fdc71526b3b8895622bc58caf3d9524e6ec9f162f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_roundtrip_cli_runtime.json` (`429c81d792728d41f332f056fb6a040950e529880c417aaf8c7b8d92b27d419b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_roundtrip_cli_stderr.txt` (`1773f70c12c7e9b15a5d7fc1085aeae1946f5c679467c03116567b6d4a8ec52e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/eq01_roundtrip_cli_transport.json` (`be8b1e73525f4b9fba1e4e75afa90ea2c365344f80eeeacfcf2581f5275498f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.1-DEFINITION-CANONICAL-20260908/faithfulness/orchestration/primary-page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
