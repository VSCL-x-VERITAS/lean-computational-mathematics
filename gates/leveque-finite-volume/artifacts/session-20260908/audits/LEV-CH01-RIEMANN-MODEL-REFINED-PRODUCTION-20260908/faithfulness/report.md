# Faithfulness audit: LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `1c9647b69667c8b60e21165121352a5096e680d2cf6bb8a1b4fcdcb6b77a577c`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source renderings support the equation-plus-initial-data definition, strict half-lines, unspecified interface, and complete-real-eigenbasis context. The proof-free header and both elaborated types agree, and all 75 supplied dependencies have been reviewed individually. Every target clause matches or follows from the source under the exact recorded coordinator-selected interpretation and refinement. In particular, the algebraic residual clause adds no hidden solution requirement, the fixed domain is part of the selected law, and genuine-jump and degenerate examples are nonvacuous. The verdict is faithful-equivalent only under interpretation SHA256 4ee82294419ec61ef4d763271c84750ef61bf8cd640faad5c4c6ce60da131afa and refinement SHA256 8e24fcad8fc5b8462b243ead716a46b2613360966bbf4d03451056d8731d6f21. The source-only ambiguities remain preserved as limitations of attribution, but none remains unresolved for this explicitly interpreted comparison.

## Implications

- **Lean implies source:** `yes`. Under the recorded coordinator-selected interpretation, SHA256 4ee82294419ec61ef4d763271c84750ef61bf8cd640faad5c4c6ce60da131afa, together with refinement SHA256 8e24fcad8fc5b8462b243ead716a46b2613360966bbf4d03451056d8731d6f21, unfolding D008, D009, and D016 yields exactly a hyperbolic governing law with two admissible constant states on the strict half-lines. D001 and D015 impose the selected pointwise complete-real-eigenbasis condition on the very matrix used by D005. The origin remains free, equal states are included in the selected degenerate family, and unequal states define the genuine-jump subfamily. Thus the Lean classification recovers the source definition as interpreted within the declared positive-dimensional global (Omega,A,b) model. It does not establish an unqualified classification of every hyperbolic equation in the book.
- **Source implies lean:** `yes`. Under interpretation SHA256 4ee82294419ec61ef4d763271c84750ef61bf8cd640faad5c4c6ce60da131afa and refinement SHA256 8e24fcad8fc5b8462b243ead716a46b2613360966bbf4d03451056d8731d6f21, the source's equation-plus-two-state definition gives the first existential classification. The additional residual clause is the universally valid real-vector identity a-b=0 iff a=b for the selected stored expression, including ambient states outside Omega; it imposes no solutionhood there. The genuine-jump equivalence expresses the selected unequal-state subfamily. For fromStates, its explicit branches give the required data for every origin value. If the supplied side states agree, any competing half-line witnesses must equal them by evaluation at -1 and 1, so no unequal witnesses exist; if they differ, they themselves witness a jump. These are consequences of the interpreted definition and representation, not extra solution results. The printed source alone does not supply the full domain, forcing, or degeneracy conventions.

## Findings

- **note / interpretation-qualified-equivalence:** Acceptance is confined to interpretation SHA256 4ee82294419ec61ef4d763271c84750ef61bf8cd640faad5c4c6ce60da131afa plus refinement SHA256 8e24fcad8fc5b8462b243ead716a46b2613360966bbf4d03451056d8731d6f21. It must retain the declared equation/domain/forcing scope and must not be reported as an unqualified printed-source equivalence.
- **note / preserved-source-ambiguity:** The distinction faithfully implements the explicit comparison convention. Equal-state admission remains a selected interpretation, not an explicit statement attributed to the book.
- **note / classification-not-solutionhood:** The residual equivalence links the selected governing expression to its principal matrix but proves no existence, uniqueness, regularity, weak solution property, or numerical guarantee.
- **note / interpretation-qualified-equivalence:** Acceptance applies only under interpretation SHA256 4ee82294419ec61ef4d763271c84750ef61bf8cd640faad5c4c6ce60da131afa and refinement SHA256 8e24fcad8fc5b8462b243ead716a46b2613360966bbf4d03451056d8731d6f21. These model choices must not be attributed to explicit printed assertions.
- **note / source-ambiguity-preserved:** These cases match the recorded comparison convention. The original source-only ambiguity remains, but it creates no unresolved implication within the expressly selected comparison.

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

- Blind translator covered `75` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `75` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`6f7b075a8812b9a23277c176a387fc6688b72f16f5dde07fddc865329c6750f1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`cb7395c79c30fb728d707080cfda805958349f4f9b7aa108a1edf6b567f1f673`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`30eb932b1b4a705c1b6482f473dc1c1b90bfee7684a0bbb5c896e4c9502be4dc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`6f0a83e5d1228afb49b8455472e050eea9b48e111c54163f9fc2d87a4d73e313`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`441147b5513847445032f3621b98488d6dcf335847f291d4e9e23083333fe266`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/decision.json` (`0fc55ff9712a2fa30b2066a36a84f62cf647f5d4d602230c90fb15d4ef24c609`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`f44161578ee64d947b23c858c5162b535d45fae27883b370f55f47a1747e6f3a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`0d47b77afa3c4929f237bc11dedb29e5f06d2a68272e464c402cdb2ba7217e8f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`0d47b77afa3c4929f237bc11dedb29e5f06d2a68272e464c402cdb2ba7217e8f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`90956afb0654f166625891ac9ddb58891dc68e9ffa5f239742c1335af9e9e81f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`8588b440d469f56a61fa85568c0b551441960a3a4e0fb46c0718c212c0b62327`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`d013e50a760baf838d46cb0401f8c44c67e185e8b933341738859975f2c7b172`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`835dbc135291303b5004fc20f724aade504b874e1b7a94a895b58fc533ef9eb6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`8240dfdea3a81262cf80c8c2357ad6816458be7734845d8e8ec987e866042889`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`cb7395c79c30fb728d707080cfda805958349f4f9b7aa108a1edf6b567f1f673`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`9e64a7942a6c84e07438afdd55aaeb08bfa73fafd010772a12ea4e0ad115451d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`163ce2579013556566dbc33b75b03bc5f94bccb3b83c10724f68e26d2a50e8ff`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`c4e7a1ab1690947da78402a5543f54d64f7d639aa42caf55587389e80d3a41db`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`90e688c2a2b77025853de53d512b87493b14592ae26ac8452165ef5e4ee2105a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`5148730136281ce49a7fe405882f50bd0d761f93283ed1937ba22ab08190aac4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`350b121d292163448417b33e29593ea712df1cef52ad53e97e4e3a45e620f114`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`30eb932b1b4a705c1b6482f473dc1c1b90bfee7684a0bbb5c896e4c9502be4dc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`97d087a232079ba8e0b349a6b9df4061ff1b5d4d7e0868719f1afcc96cef054e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`002274b92d97f3a69841bdab2d6764a0dbd26eaee427dd1da2fbc413178857bc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`a54a6f458b050a8d96d91ed2aa3818f08795bdd446a96e68ba28e695207b0ada`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`690cbd0c38828b506784afc0f117e0a6bb8ba91172fe48a3c7e4d36539df72b4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/page-029.png` (`4761f39e0daa52023709eb5180beddc142e1e0aa54112fef39059d81caa737d8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/page-030.png` (`da658725af4b8a2b539d19ce5201c239a181999fd1cd4161e1cabb5a54c2288a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`0cfd6a84904e17b918fa25976785a9e18d0b0d2827e0d500edf8e759c72cd2ee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`bc4db4b521545945cdf31d4cb655e0d920cc3f9850a1c93e99c7432b5d834b5a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`f6fddfdad27d7627ae4b240f95a508f872c3ccfa5917abd73e8f850890a7a01e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`6f0a83e5d1228afb49b8455472e050eea9b48e111c54163f9fc2d87a4d73e313`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`7daed79d3bde34977a4c6b32ec363734e38b4268c0e44dba02edde8040970623`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`140f154ee787748c845d195cdf1f0b1979ad3625293643d818f304cfe263766e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`02dd556e90d9dd374e62e55be162c46e99400026839f51e11ba8961d6ab3dacf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`07367fcb73f0d9f2a0e923f504e29e25ffb1c206637dc4a586b4f3533863acb9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`8ed1e4688694fb7b4029a290b1f22f6665eb8f3d9e5197363bee460f1b6e1c3d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`441147b5513847445032f3621b98488d6dcf335847f291d4e9e23083333fe266`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`fa2b4f2332d05f8da4804021213e3dd4f97f5b95e9c81b52b1d64f08ddf89ea6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`a7905a0cece72bf4bec7f623005b82b9853ee04e82244a089168b0b680ea37df`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`93b922ac83dd57895dcf79ea9c6946439f62ea8f98316da47aa1433bcc4a5ba6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-MODEL-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`c22e51b7f78dacc0e99d1d88254ebc68a0ca2a9d56b17ae8bbc8dfc012741d69`)
