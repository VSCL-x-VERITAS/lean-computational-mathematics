# Faithfulness audit: LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `711c14a8889cabc887cb33ee3324cfff0db051ee909d222dd703da7927ccdab6`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source images, both dossiers, dependency inventory and reuse records, blind translation, judgments, and exact triggers were inspected without tools or reliance on target proof. Supplied hashes were treated as provenance, not independently recomputed. Declaration meaning was separated from source correspondence: differentiation and negation are clear, rectangle balance differs from an everywhere derivative law, and the measure identification remains insufficiently exposed. The source's general scope is definitely absent from the target. Because the reverse implication remains unresolved, the classification is undetermined with acceptance false; neither agreement among judges nor the example's mathematical usefulness supplies missing semantic evidence.

## Implications

- **Lean implies source:** `no`. The target gives one scalar unit-speed step family with identity flux and classical failure at one designated point. It does not establish the selected comparison for general vector-valued, potentially nonlinear conservation-law solutions. Even granting ordinary Lebesgue measure and a favorable integrated-in-time interpretation of the source, this scope reduction remains. Under an everywhere ordinary-derivative reading of (1.10), the target additionally denies the required derivative for its chosen interval at time 1.
- **Source implies lean:** `unclear`. The supplied source supports the relevance of translated advection profiles and continued integral validity for discontinuous solutions, but leaves temporal and endpoint conventions unspecified. It does not explicitly identify D002's precise rectangle formulation or assert the extra mass-nondifferentiability conclusion. The displayed D052 evidence also does not certify the integration measure's identity. Under the conventional Lebesgue and integrated-in-time interpretation, the example's claims can be independently verified, but that conditional verification does not resolve the exact source-to-target correspondence.

## Findings

- **major / restricted-applicability:** The theorem is an illustrative specialization. Generic signatures of imported definitions and an extra conclusion do not restore the general selected comparison.
- **major / temporal-formulation:** An everywhere derivative interpretation is incompatible with this target. A weaker temporal interpretation is mathematically plausible but not specified by the selected pages.
- **minor / dependency-evidence-gap:** Identification with ordinary Lebesgue integration remains conditional. This is not evidence that the actual library instance is incorrect.
- **note / additional-conclusion-and-nonvacuity:** The example has substantive mathematical content and no impossible premise. Its extra diagnostic is distinct from classical PDE failure and cannot establish overall faithful strength.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `fail` | `fail` |
| `C03` | `fail` | `fail` |
| `C04` | `unclear` | `fail` |
| `C05` | `fail` | `fail` |
| `C06` | `unclear` | `unclear` |
| `C07` | `fail` | `unclear` |
| `C08` | `pass` | `pass` |
| `C09` | `fail` | `fail` |
| `C10` | `fail` | `fail` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `fail` | `fail` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `unclear` | `unclear` |

## Dependency coverage

- Blind translator covered `109` dependencies (`0` hash-reused); unclear: `D052`.
- Direct judge covered `109` dependencies (`43` hash-reused); failing or unclear: `D001, D002, D003, D005, D006, D014, D020, D040, D045, D067`.

## Remaining uncertainties

- The selected primary-source pages do not specify whether continued validity of (1.10) means an almost-everywhere derivative identity, an integrated-in-time balance, or a statement subject to endpoint trace conventions.
- D052's displayed body does not expose the inferred measure-space instance sufficiently to certify its measure identity and normalization from the permitted declaration evidence.
- Consequently, source-implies-Lean remains uncertified, although the missing general source scope definitively excludes acceptance.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`d76e1c26e107d3b26bdc2144f4ff45feab9ca1d78f617147b57f86f093ba1190`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`dd90f70cd59804f8e944bc769d5fdb33b92aa2fec86840a7479534f502c5d3aa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`ddae6d0e5be8e759573a6853350c12f603870f86d0f6119a0d2ce7a9e9a01b25`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`c3c59124bae463a4ccf9491b7da6df0af7e9804f4992b78e6e5daa12b4c164fe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`0d91da89bcce00a434cb00ac5ea1816bf5638318a85a73c4884260f751b0d712`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/agent_outputs/source-contract.json` (`d75ed04a5c95beee54bbdeca10b02c8cb3fa98b79919e0ba6443f0de2e8313fa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`d75ed04a5c95beee54bbdeca10b02c8cb3fa98b79919e0ba6443f0de2e8313fa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/decision.json` (`f1b9a00bbc4a18c2dbc7d31a6dae87aecb561ff9dfcddb38e6a16d232afd29aa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/history/20260908T091449Z/inputs/blind_dependency_inventory.json` (`53dea726e8ffa3e0d29bbe2a03d82835d867f8ead827af692a74f2da634e7f55`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/history/20260908T091449Z/inputs/blind_dossier.md` (`c076d8eeb4896795baa87847308d3da21a21f9962d44b53743b8124b74ab38a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/history/20260908T091449Z/inputs/blind_review_packet.md` (`c076d8eeb4896795baa87847308d3da21a21f9962d44b53743b8124b74ab38a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/history/20260908T091449Z/inputs/declaration_dossier.md` (`a171677ac916815cb130784f472615d7d511b457a9535c059d7e996410165f95`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/history/20260908T091449Z/inputs/dependency_inventory.json` (`ef132f7b9658850d5603360209c95d01657a2fd99aef744f83945f5e99f225e1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/history/20260908T091449Z/inputs/direct_review_packet.md` (`8d52c60bb3f2e9af0365bf211c27c631f642fa679e40f917abbbc539177bfc44`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/history/20260908T091449Z/inputs/source_locator.json` (`e695885bbcbb47318b1a6324c2896f99bed620b9a4ccac722ecde7a25565b048`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`53dea726e8ffa3e0d29bbe2a03d82835d867f8ead827af692a74f2da634e7f55`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`c076d8eeb4896795baa87847308d3da21a21f9962d44b53743b8124b74ab38a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`c076d8eeb4896795baa87847308d3da21a21f9962d44b53743b8124b74ab38a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`8d6beb35c137afb2ebed90f37de50ccb0f40f4737cbe696980d998b6a396fa8c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`ef132f7b9658850d5603360209c95d01657a2fd99aef744f83945f5e99f225e1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`a70c7c3eb24af6b67b7946650db7c860898c6e2674635067a3f4e192da8c2cbd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`8ef6214b29161f88555c6de8faf0241cf9693fd5191d122cf4e3809315cd73a4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`e695885bbcbb47318b1a6324c2896f99bed620b9a4ccac722ecde7a25565b048`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`e113f591aae46995e9754adc42a6828216a919c889b54acd37be30f939374560`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`d76e1c26e107d3b26bdc2144f4ff45feab9ca1d78f617147b57f86f093ba1190`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`a25d5b9f3fb64333447afb5ed9f90a0c06bd25534b81779368cf7876ca859e30`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`c74edfdea1f6be2c9b936d0f15d67a24fa3d32e16212e42b35c54ed518bc66f0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`b57c3c3dd94f75798154412432cfc202c55152839d53382553565fd27045330c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`534c65eef62461929e04efdb03e3b76364f5e741905ae99dba83bd6050f33c7b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`457eaeb4d637ced08914ee4887c28d32609f848726589b761efeddce1a2a10bb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`c81b28b8aace66867f72fc75481697ed1e46306d7b7aa72da80aa4e094a0dc46`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`ddae6d0e5be8e759573a6853350c12f603870f86d0f6119a0d2ce7a9e9a01b25`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`40a844a3988a3b51ee941ec62092148ab9ce5f6b0b7315018f681cbff992e706`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`692aada57a5caef817834923af80c0735c156af5197bf46fcf8798922c2d41c6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`1968b00246e7c9f0164728410d1021b26b83f370abbbfe4de819d132fc3cf92b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`3221f16b8c495449548fc75dd2d4f9f7e2082a409eb63dabb3e423a92ddc559d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`e937286e9f4a75b2eba3b96934ca5766698e3f18242dddee8f5bc2c8f1e1bed1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`c3c59124bae463a4ccf9491b7da6df0af7e9804f4992b78e6e5daa12b4c164fe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`180d0c9a6fe02d9f0089fbdd0efe679f4d81fcd21205194a7b19d78a689b45d1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`afcaa359a4207954bcce1d736a82dfa19916b03c9caf69ce7c159e3ff0309500`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`fc413b793bacd12a70f81674d39c95d46e1baaff43109a72d87315abe1b5727d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`f5ea78c98ee56fb9b19459f1167b2c03e7519893943be4b791e2424e9605a3f7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`a6d7bbf7512583f648a964c9c1dd55780175d02ca11fe135b625b58c18087027`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`f30f9f670262ebd1ffacd7c101c7451b18b4fc868bed90fb381a6fcc6654d84c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`dbd415870ac52ee1a784d8b5eacffafdbd80d6b218be26211a16e1d227041a5e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`61b08513b25b3f995b1633103781f29e818a59fa91c58123dde37254a502902a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`0d91da89bcce00a434cb00ac5ea1816bf5638318a85a73c4884260f751b0d712`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`8316e3b61b919c334b1f00a0478e9db6410c6b1219179f5eb9885017877b35ea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`249f26e1771213a2c5300c59af5b3d0b312468004cf3ccca6e976f2c77ecaea1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`464c72602364dc5c94c214db1db354cac17317e62a8682e4e6158adfe2502590`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`c158b6e5ded9d62bd4f22e8da72d8a483fa6034e48ef0b837b8537c0c954b692`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`cc686728703678d2b6fa8d3942917fd7370b260ce9123888c898d78506381557`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`d75ed04a5c95beee54bbdeca10b02c8cb3fa98b79919e0ba6443f0de2e8313fa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`69e6aaa6344bee6217d7e07b2c9178828df446892a800ac5bb6f56a53fc8b2a0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`706e843953178ea3493a5034fe2a9108883e7ce97f561b062a07693ea850db62`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`09595c980697c9b3c08cb2a783e7e3a348812f189acf978bb0aa301f3809e6d4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`d6132d226e49eccfd03dd664019b77bd6752faa7710345637478c72c295bde87`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DISCONTINUITY-INTEGRAL-LAW-PRODUCTION-20260908/faithfulness/orchestration/source_filename_correction_20260908.json` (`9f306d99178a4c46387377ff2b0ca04a2a71ec4c0690a2a8a7bb9b3a9bbd13c6`)
