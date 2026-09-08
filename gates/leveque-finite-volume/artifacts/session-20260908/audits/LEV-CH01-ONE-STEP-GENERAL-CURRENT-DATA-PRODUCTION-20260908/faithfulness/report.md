# Faithfulness audit: LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `8d5cc4073cd1cf377bca28100150fbebfa08fc6fe40bee6074816bf73646a73d`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The disagreement concerns whether a generic characterization needs a concrete numerical-method witness. Inspection of the attached source pages shows that no particular method is selected: the passage explains one-step dependence to motivate notation. The unrestricted target can express that dependence at each fixed method and transition without additional hypotheses, loss of current data, or an autonomy requirement. Its declarations and blind translation agree, its attained-data domain preserves all represented cases, and inhabited examples establish nonvacuity. The source images and inline declaration evidence were inspected; supplied hashes were not independently recomputed.

## Implications

- **Lean implies source:** `yes`. Under the selected source context, instantiate the parameters with admissible execution contexts, their data at t_n, and their numerical solutions at t_{n+1}, for a fixed method and transition. Factorization means the next solution receives its variable input only through current data; equal current values therefore give equal next outputs. The equivalence characterizes this dependence exactly. It does not establish that any separately specified method is one-step, and the selected passage requests no such method-specific result.
- **Source implies lean:** `yes`. The source's complete determination condition means that equal relevant current data cannot yield different next numerical outputs. For each attained datum, an execution attaining it supplies an output; this output is independent of the representative by the determination condition, giving a function on the range. Conversely, any such function gives the determination condition. This classical reformulation requires neither an extension to unattained data nor an update uniform across time, and asserts no computable implementation.

## Findings

- **note / scope-of-acceptance:** Acceptance covers the mathematical characterization of one-step dependence. It does not certify a particular numerical method, formalize the book's frequency of using one-step methods, or turn the qualified notation convention into an exceptionless rule.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `unclear` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `unclear` |
| `C09` | `pass` | `unclear` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `unclear` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `unclear` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `7` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `7` dependencies (`3` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`1949e30a701528293a00dcf4a62d083f0144755f6621bbe1fa1bb8101f2e12a3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`64200a66577bb8b0402c4720a9038658e8c8ca4cb868e82743a0e880b6ef8f74`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`d62334b387de7f0b27cd0839afe09fbc1b326e37a331c4bac1a18d47ca693c6d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`dc732726f65cb26633796a9d6425915d2c8eea3c7e745689e3301008c1f0a5b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`05d7359000e3e441f91f021140f22d218ce12a0aebdefada32699db930443f1a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`c60ee72210da5f15263d2d2d78cb3f864f19344421ee1c2af791710186eb6164`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/decision.json` (`c4bd57bca215be6290d02c6376871db7695b2f1c38b780a159aa4d5eda1ce8cd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`da4ad1096a4f9b5a902af7c9de4252d8f229228b0dd2d8e84664f691c8d2eb3f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`a141799decc1ece52d876b550bdbafbba00e91724e02e44cfacf8cde80bda6c4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`a141799decc1ece52d876b550bdbafbba00e91724e02e44cfacf8cde80bda6c4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`bf68f5a837b7ca7596dbc1c52ede3d358ed62e14195127dcb15bea8d14454ac5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`da4ad1096a4f9b5a902af7c9de4252d8f229228b0dd2d8e84664f691c8d2eb3f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`8309075d3c4e128e7a04b6ec9231bbb1f0a035da11f380d4856d70d1a13a1089`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`49af125e6e9e6f448a7e92c12a9db69977e76d237b0de2f8acff2af2ac3ebaa6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`914d7767f96581983c22a583bcd6d75244cce0856a6c540d288882b6163925b5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`9c209a89b0f74a05f5d8b3af97582ca661b02f214bc2254fa8783310d8e72682`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`1949e30a701528293a00dcf4a62d083f0144755f6621bbe1fa1bb8101f2e12a3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`bc3779eaebfbb057f84273971a6f26c6f286c451b6f711ec115b425326755811`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`122c23505c31515faa920bd1e060e7b46caa451e4d37cae9334d122ee8ee029a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`414431b50c74dfd8c6be6b863511387e345ab2cc52456f45bff496aa1df48f6b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`ae4358a4601bc48b9b77f7a94710b1cff0ea8bdc9c4512d5e1166ea318b72673`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`499b91ed192b220386ca98aeb8fe0d9b8aba7fa80e375e0856ae8e6c235a698a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`41770647104f4e2f67af88a8b2797a562561dac1d7c3dcad2909756dc398d6c3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`d62334b387de7f0b27cd0839afe09fbc1b326e37a331c4bac1a18d47ca693c6d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`a945ef0121edce0dd206c17502dce7e1164a3e305e247ad952c27d98b7aac874`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`80c37f9cbcc02b83245f9a852f6b712b10a70ff59e7632a0a9451937e93b9a5d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`490b0eaebab16a23432326c394994aa7e0d4f161d9169dbc8dd93f370c0149c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`2e7c795d66234cbf7fe7c4141d5ce2dce72d41590b58cc7b9241fde15dece492`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`71a7dac328be83851b03f29f4c424d075bdfc9583a516b6cccdb7ad40be60be7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`dc732726f65cb26633796a9d6425915d2c8eea3c7e745689e3301008c1f0a5b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`e2a525766abf6129b75184485dd19d1135524a47c3fdf83c76f3346ca9e8f5eb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`4d60833a9a6646c2b72e1a0b49a78b59b2bcd9a36acad505eb3694a574ab8ae9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`46adf1a2a660f9f060effb29f4d4b6c8db498e39387e75b15bbca578d4fb82e4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`0e99d6dbbad1f613bc7659e5a611343cc124e3dfe518ca845200fbf235464ca7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-031.png` (`923e276bc6cd193e15d1726ec6823613ffb016e6f140c0b5ea7830b4ccc029a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-032.png` (`a960b78a3cdcf233b3dd538eeb07b82f2482bf65009d81cb8704f9455639781d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/page-033.png` (`fc41782f0505fdf94fc36b5f40a2cc44357e3c6fe0eaa0cc040dd5901732531a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`64341fefad12b7bc55c56254b4b8935824cb888edc5b5d97b94deaf4cb8f8be2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`05d7359000e3e441f91f021140f22d218ce12a0aebdefada32699db930443f1a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`8d5f3bfc409706f2d0dfe6c5a0f00eba0d4f2d40cdbfaafa4a0a1ed828ec2ec3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`c9b7058e5b4811b229a592abaabf590187bb28eea60c1049b9c1820f4a3e8122`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`060372e35b02b2493a242fb72251fc8821ae11184b172432311418b9034f051f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`f45837963e1719d1116e913d89fd8798fbcff44ca482fb5e7c3fe2520fb7a09a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`c09330164f7f6437e8dd5823983a11327c6a1215261b29efe7fee2bdadf16cab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`c60ee72210da5f15263d2d2d78cb3f864f19344421ee1c2af791710186eb6164`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`11a8819e101835f39086ebda81b7bfb910b8260b467d7c48c07961c5ab10bb24`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`ace562bcf6a91add9e0811349d5c4a6c960d1d5b98727efb4f827ccdc06f2c59`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`91bf72eb8927e2ee9c9d52819f85596786857c13e36649b9e1b2535263e9fcf6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ONE-STEP-GENERAL-CURRENT-DATA-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`63ff624aae0902a69cff1e717de6a75ed6e453cee0449b3c4d24b968457808d4`)
