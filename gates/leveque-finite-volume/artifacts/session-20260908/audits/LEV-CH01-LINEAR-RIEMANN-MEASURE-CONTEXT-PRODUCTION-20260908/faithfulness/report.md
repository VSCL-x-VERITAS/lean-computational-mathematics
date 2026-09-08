# Faithfulness audit: LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `9057f66a6ca85e9a164fcf8dbde7d12e251b264fd55cbf642323e48de1d6d8d8`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The disagreements concern additional conclusion content rather than a lost source case or an incorrect operator. Independent inspection confirms the complete real spectral hypothesis, correct coordinate reconstruction and propagation sign, strict initial branches, fixed nonzero length measure, substantive conservation, and nonvacuity. The representative convention remains harmless even for stationary characteristics because their flux vanishes. The all-real-time and representative-level certifications strengthen the selected qualitative existence assertion without restricting its applicability. No unresolved semantic item remains for this selected claim.

## Implications

- **Lean implies source:** `yes`. For any source dimension, hyperbolic real matrix, and left/right state pair, instantiate the finite coordinate type and choose any origin value. D001 matches the source hyperbolicity condition. The target provides a complete real eigenbasis and a finite spectral construction with fronts x=λ_p t, the correct strict initial branches, positive-time dependence on x/t, and integral conservation with flux Aq under ordinary real length integration. Restricting to forward time gives the selected Riemann solution without extra source hypotheses.
- **Source implies lean:** `no`. As an assertion in the selected passage, spectral solvability does not include the entire prescribed representative construction for every origin value together with slice integrability and conservation for all real temporal endpoints. Those compatible additional conclusions exceed what the passage asserts. Their independent mathematical justification does not make them explicit or implicit representative conventions of the selected source claim.

## Findings

- **note / genuine-conclusion-strengthening:** Acceptance is as faithful-stronger, not as an exact transcription or an equivalence of arbitrary solution classes.
- **note / evidence-verification-scope:** Source-byte verification, rendering hashes, native execution, and environment provenance are supplied evidence; they were not independently recomputed.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `unclear` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `94` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `94` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`c78b0b3e7ff8e1d8c645dd7dfa3cd3f4e5e66cf858e9d41d918cb8b31b0e7b83`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`4b85207279c7ff855e9de8fce6312453e7172871f3f66d7d2dcb0deb652c4b65`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`77ad20675875a93c5a9529510093a967722d9bd67250275a6095cbe00fb7cb55`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`e8c7d7f839b0962e197545df33efae7e9e393451bc52f8b2f7c16f6d76b1e8cd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`54f2358636cc7c27527f1406459ad8819668ff0459f238948506e121b2da7cf7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`adf5d6240c1ff518105c4cab646773306cdc30d1e7ebf97c95bfcfa164da780a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/decision.json` (`d1725ddbd6c0f2013969af9fc50529a4cf50552002d9e1fb5bb285cdcb068edb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`0356802407445bdf34f74ca2461b499e30e1f64556589450a7e6c2a989190d47`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`19d6d4c66a055c16434af0e59f125f93de57bcfd5c3cfd4d63c8b38bf8004174`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`19d6d4c66a055c16434af0e59f125f93de57bcfd5c3cfd4d63c8b38bf8004174`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`2fce846a14df378ca9e26a87085be3a6ab61796e6dc25c97672eb3fde6ce85cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`91e911b0b941ea6c676cef596bb5f271962999362e85b0029244c772c50a5beb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`06e82dde7c9c90a4e7096f915133d48bfc044fffa00d3cfde37acd618d254d95`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`06e4192438a2e8c7eea30c5eac82f2f00467b9b1b43b92a9a5a79efc36162f31`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`67761bad5606d3302fa26043c02ba270939db45202e00133699c35cd6f8ad9a7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`c78b0b3e7ff8e1d8c645dd7dfa3cd3f4e5e66cf858e9d41d918cb8b31b0e7b83`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`b5163d797af0b6350ef04b565cec137ec92ba73cf7078f5388597790a8ba9a31`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`9716094475845ab85bde9c4def6d249a5decf6767c5d7297e6a617c8776d9fb9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`9038676abcf79bb2805a98e0b8d9c0af39a9bdac7e55b06dadafbdec0100b719`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`1704f262df22c96dd9c14ab8586e31c602588a606f0957f07007dc292217475e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`9556df8e50483c4d8f516bb5fb3eaf154655a7c8ea760522360fbe6ebb1f9adf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`e0033a4a8a7a4f0522e03b6cebbb75493457da7e9d058098aebfa1407ac8d3c1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`77ad20675875a93c5a9529510093a967722d9bd67250275a6095cbe00fb7cb55`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`23cac76532b7ba6e077c8b624f714ecc92f898bb09c61223235da550622f2d71`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`af5b4051b78b7afc849f6a3844805597a422b80080aa4ba5969564d294e01038`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`adebda98495b853b55f703af250287b777a284623eb42bbc67ba61410802a585`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`a5392dcdfc32a42ca740ae264820668894cca50c6d42240bc5e29c9c72f25f56`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`5828cbf010a21aeaaddcbe1df67fea609a631934f5008f5b1309c80166c9b96e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`b610c8eb573733699a41a3141e71a5fc784d0009162f1bf89cf62f05a76774e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`e8c7d7f839b0962e197545df33efae7e9e393451bc52f8b2f7c16f6d76b1e8cd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`663dfccdfc0c12d0d182b15085537b4579d0dd1386598e6b719c3aabe5fa148a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`ed9db993b487ab4c1d61f53a5b9f2129609f2eacf595ac9efd2386a9eb621c42`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`22e85212d0ed044b8753258e505abe1e7e03d76e1ec64bddc1ab686333219ed4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`4820cde381f0ad4b342b008a993bb2fd19d4097a3cb3f7b34f645b8e3ad20d8a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/page-028.png` (`ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`0f80c75fdc0748b4a406b0ed356b4ae070e9229ea15a77381dcd2d00b146ee8b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`563149a9b6ce3f233f22f5c43747461c749813c442edef0df1e4e8b795c849e5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`f106dab3b3f00fc27069cfaa74207f6f1a588a5bef84d63559803bb95798c8b9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`54f2358636cc7c27527f1406459ad8819668ff0459f238948506e121b2da7cf7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`5531d6d1a9520d1ac34b1fb53ccb31a074dcd7b12cc33defd4e54a9dd45422cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`d3e24c4b62a67a5a35ed5684cd3fb7496612db3fd4ca0ffe8719c94d272b5d26`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`640a5d0b120ed893f2f4252912d42a02ddf81cc808182bdff0ff3d94b1892eae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`eca423687d0e849a7542ee959bd2c9c9e506a71bc44cc94c6064ebc9e766955a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`6182e219ed8c3da333afea45e80517897aaa8ea5ab8b794dff69d67ca40fb5bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`adf5d6240c1ff518105c4cab646773306cdc30d1e7ebf97c95bfcfa164da780a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`648bfcf0616a577b7c319cd1757e3b8c8d6ec5baf5405d92dd8ee585c9e0785d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`bb4b5007ff206ee43500eee555b274c113235148079bf24706a3eb612d1d8ad9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`c996740e954941cc6a995b72370101c77c7ad06abf064d3c5f34c124d998edee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`02d1af109f6fed637c887500d61bc6412982f2c77502643f3c7afdde263100d1`)
