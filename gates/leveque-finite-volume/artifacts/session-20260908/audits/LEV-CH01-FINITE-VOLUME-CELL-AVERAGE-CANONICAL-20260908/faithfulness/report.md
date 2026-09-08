# Faithfulness audit: LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `4c9e8eee7c8cfce7fa381cf1de2892d5b2326b46aacbbf3a2bff4efad1eca816`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source pages and the inline declarations confirms the intended one-dimensional, finite real-vector, fixed-time normalized cell integral. The disputed dependency was rechecked in both dossiers and against the reuse ledger. Its displayed instance-inference placeholder does not resolve the specific measure normalization challenged by the blind translation and round-trip judgment. The direct judgment's library-boundary assumption supplies no additional declaration evidence for that disputed point. All other identified differences are appropriate definitional or analytic explications, with satisfiable hypotheses and no substantive claim of stronger applicability. Both semantic implication directions therefore remain unclear, requiring an undetermined classification and nonacceptance pending the missing evidence. Source-byte and rendering hashes were accepted as supplied and were not independently recomputed.

## Implications

- **Lean implies source:** `unclear`. The vector type, local interval, fixed-time interpretation, exact-value role, and reciprocal-width normalization match the selected source definition. Recovering the spatial cell integral additionally requires establishing that the fixed measure extracted from D025 is ordinary Lebesgue measure with interval mass right - left. The supplied declaration and reuse evidence do not establish this disputed bridge. Equivalence would follow upon resolving it; no actual counterexample to the target's measure identification has been established.
- **Source implies lean:** `unclear`. Under the intended Lebesgue-measure identification, the source definition yields the normalized integral and the remaining conclusion conjuncts repeat the target premises. As a bare logical proposition, the unfolded target is reflexive regardless of the averaging operator; that observation does not establish semantic representation of the source-defined object. The evidence leaves that representation unresolved through D025.

## Findings

- **major / unresolved-integration-measure-evidence:** Acceptance cannot be certified from the allowed evidence. This is an unresolved evidence gap, not a demonstrated mathematical error. A resolved instance declaration and its spatial normalization evidence would address the common cause of the outstanding semantic checks.
- **note / appropriate-definitional-packaging:** The theorem's definitional simplicity is not a faithfulness defect or evidence of impossible-premise vacuity. It also provides no independent verification of the disputed measure.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `60` dependencies (`0` hash-reused); unclear: `D025`.
- Direct judge covered `60` dependencies (`18` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The supplied D025 body does not expose the resolved Real.measureSpace instance or establish that its projected measure is Lebesgue measure normalized by interval length. Consequently, matching the numerator, effective integrability domain, and endpoint-null conventions remains conditional on that identification.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`5b1a761a85759a5dbc5451b40820703459821277b5641968be43bf7f4fc57a6f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`72db3cdeed724a8fa9cbe7cb58a66fa286fc747626b5b017f2fcec263bde7aa2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`9ece9ddb27db9592cb3fe7520e7d533e1e3c90e06df56947f772d312c1dc0ab5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`50a7dfd299d7ae14a110a7d62d1c8e64263655d32757533624108239eb507a38`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`cee7d4738779df13a13819c4a9de1ad9768d6e8322e3078af8498fdd8417307b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`578ac94df58a9d37e80588306504347b1a54fb2fe1e2c1b91de882285fab1f89`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/decision.json` (`d1c97d14be0ffaaf83897b80df8759ebeb4f7167c597a84cddd2a95efb54d843`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`faf1efebd6c7bcfd531c150e18769462ec047338f44fbaa0e94d2f4db8b30381`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`62de33638fafec98124c7f90b54e3ad33222e4e8fedc457d80333ae5567b17c5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`62de33638fafec98124c7f90b54e3ad33222e4e8fedc457d80333ae5567b17c5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`e27067f2354b964ef58bc95ce2e6388af89f68e33449d7d38a03a0ddc41d17a1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`7d0299a90a810c1e7da5b4d61eaa0003a286399d3c128028b891c5d602125978`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`0457e0b8950c41087d5076f52ccd051545bedf4367e62b2ee7c812cecd92cf6d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`dd14fcbaf2d9a0d28c95374da8aa6314510d4222834d025bb037233bbfc4669a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`fd098efa88ec8ed5949e91cbf1b8d074b2c6ae85917099121657cec188944fc8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`e6e29d111d273959502f073955a9f57a5ebf05acd8511a49f4b2ff75a2f84346`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`5b1a761a85759a5dbc5451b40820703459821277b5641968be43bf7f4fc57a6f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`e8fe322e21784ec76e99fe19fac92e6f3e16fd728314ccf1c1908f25445cbf01`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`59c0fa791aa53b9d90a567c3c872df678aa0675c85a05dbf71602bbe3eec69c6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`7dcd34a555fb571bc11826239174696dfdb2e72a9d45783902073e824de06b46`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`15793a3521903a2499e4966d649e82600477274a301dfb1d6c81a2436c1fe861`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`f088231f57b8b1c14cd285dba87a0750a90a73d234f0a8ecf4c3b8021dfa3208`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`5cc4f787269fb724a6d2b79b62c161f7f272481f1e19ac7ab65fc1f0046abe71`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`731bea08086cd2a3f8079e8f1d98affd9c078a8fd13722e097c9264dba730abf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`9ece9ddb27db9592cb3fe7520e7d533e1e3c90e06df56947f772d312c1dc0ab5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`2a8ed6314a98154c165b2792ab2fc60bbe12fecc8426c1432caff885c5028b38`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`c7d6584966d8196ac5f46d32dfbff35f373791ba008608962c266148a12c11aa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`1dd50e917dda725e2848d3c79a2cbc94793731eb7c25c54cda3dd11acd2c1733`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`45e0f1590a3c8e5b198052a7cae24196c76df3dfa1e24db900d151fdc760fd38`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`ce60eb270c01b22660a0e0a63fd6887e0c16ecb20bb54781747a9dfccec9ffe1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`50a7dfd299d7ae14a110a7d62d1c8e64263655d32757533624108239eb507a38`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`fb05d4cdc68e664c828a481380095330b74323e9dcc21af168565e4a4e7bfaec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`b970512455b5f0006cf9e92749043b2e446c11d73b0a3d374f20c9007d6fb2ad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`6134b536f60d7dee554195cfb644ba1984910c5f31d816c6c93842230c36ffc8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`0d10821b9ee24527bd530eb9e426dc132427b5695466d0b17f68ed2c27dcf963`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`2b4a108b0f82531c11f5fa0f4a928514847debd254db40407346eabdf2ffdd0a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`cee7d4738779df13a13819c4a9de1ad9768d6e8322e3078af8498fdd8417307b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`4c8c86b87673b6f93aef15671249097897b5169b60d4b4a54653693c74f1b65b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`10b56a188f001680f36163b7daf8e0fc9032c3a37cc321c15402de6b05bc74a4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`3c0d198eab0f445982e758050fc64461f6c1efc867981053fa283786d917e485`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`a471f4dccc087586db9882c466c9bee7eec628b1526cb15a642bf53a7ef34d6e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`bf7f66cf99cd107c4d902091ef90aab2f7e6dfaf920d9675ec3a9f644372b9db`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`578ac94df58a9d37e80588306504347b1a54fb2fe1e2c1b91de882285fab1f89`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`3e1893f06aa94fc9048a8e743b8e3f1d7a4074151d47e1b4d40b68f729a00e82`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`46f244769180c5a1aa1f5c86c166cfad97146439a88804fb911b5245057c255e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`bd7846b279be2809046d83e233be39953b3e363b20bc743ec3162006af38a05e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`5340fb7d31f903042790bf8779c376d5515fec4e644532729e83e8d254dd0e0d`)
