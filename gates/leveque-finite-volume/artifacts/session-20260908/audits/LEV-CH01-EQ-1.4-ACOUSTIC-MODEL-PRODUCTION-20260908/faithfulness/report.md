# Faithfulness audit: LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `05fe4d2f1cda9c311340c41e85830bc7a3873d99efc5d4261c5d754f58546843`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The authoritative attached pages and exact inline declarations agree on the acoustic equations, dependent-variable construction, sound-speed formula, derivative semantics, and propagation signs. The decisive resolution is that the disputed signed-parameter extension follows from the target by a reversible transformation preserving the constructed acoustic variable. Both implication directions therefore hold, with nonconstant admissible instances and no purported strength arising merely from extra hypotheses. No tools, target proof, or external audit artifacts were used, and no supplied hashes were independently recomputed.

## Implications

- **Lean implies source:** `yes`. Unfolding D001, D010, and D011 identifies the supplied system with classical acoustic fields satisfying equation (1.5). The target constructs the exact positive speed sqrt(K/rho) and exact combination p+rho c u satisfying equation (1.4). Its scalar conjunct supplies hyperbolicity and rightward translated-profile behavior. If the source domain is read algebraically to include both-negative K,rho with positive ratio, applying the target to (-K,-rho,p,-u) recovers the same speed and combination for those cases. Spatial reflection and velocity sign reversal recover the complementary mode; addition and subtraction recover the two-field decomposition. These reductions use the target's universal scope, elementary derivative rules, and the supplied definitions, not an assumption of the disputed source conclusion.
- **Source implies lean:** `yes`. On the target's positive-parameter domain, the source explicitly states that c=sqrt(K/rho) and w=p+rho c u satisfy the right-going equation. The bundled derivative witnesses express the classical hypotheses needed for this calculation. The scalar discussion on printed page 1 and the hyperbolicity definition on printed page 3 give hyperbolicity of [c]. Equation (1.3), together with the stated mathematical identity of equations (1.2) and (1.4), supports the translated-profile clause wherever the profile derivative exists. Substitution gives profile((x+c*t)-c*t)=profile(x), and c>0 gives strict increase of x+c*t in time. Existentially packaging the specified speed and function preserves their identities and dependence.

## Findings

- **note / material-domain-reduction:** The disputed domain interpretation does not change the implication verdict. Acceptance is supported by an explicit reduction, rather than solely by inferred physical positivity.
- **note / derived-complementary-mode:** The complementary conclusion is derived coverage rather than an explicit conjunct; its absence does not establish a loss of the source's mathematical conclusion.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
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
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `130` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `130` dependencies (`10` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`10fcb05f49b636e7a55fe555c697e5f96934c0bcc29fd33966e3c4c29ddc48e9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`0d3dfbc35a945503e98d175b7ff3997ae44c8df8083ea536448075e878c52dd5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`b77aa8255ed0045966a973f050f19bbbd3a3aecae3b98736de4430cca8321b23`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`7e8fe70b4c6a3852dfc77ffac2bcfa337d8a13c5e298b6c9e711de6d8b89ad52`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`b9dba2229d00f19e2cd1167acf4a4a46cf96aa34cbe0820472313aa27ece4e63`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`616d80871deca9cae2c3d7f47df6c305d1dcd5c04f347e96d8dbbe59ad1ee20f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/decision.json` (`45c7565c2321a0981dd9c3c479106d7ef8deae388b631f289f6e753d1a07f87a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`bf17b1581c5285283b1355c89706e0e3b05c1916a5aa6c9c6098d70f91dc6d8f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`80e01430527ac399ef60b8c34fee37a63df331438abc36bd1431c7e0629ae042`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`80e01430527ac399ef60b8c34fee37a63df331438abc36bd1431c7e0629ae042`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`e531eee24b37dc90acea501fb6f326a44797aedee85b2ab30c00d995c427ae4b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`de67e63c52022e2ffe7c6fbaabd3486068a12c6fb43a969104244ec837f075f3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`070e2eb5a759e76505e668f3e359d9cc6b55fbbc86103f11b8b7f472e6083e10`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`16ac3d98df19cb1c174fb84f4bae87a73fca40cf28f3df1ed2ee492a89cfa0fa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`52e7b3675aee121c5397e694f8ba3990040051ffbd462942ae4941970d1ee9dc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`b9b81c4e990b49973191d030ba1885d0251de0445920a88a91d76cadea256801`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`10fcb05f49b636e7a55fe555c697e5f96934c0bcc29fd33966e3c4c29ddc48e9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`8c1228663f7daee6314038da75a2e21603644ba4c7202faa6afc39d6296c2906`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`d7af02b6490b553544006343218c01ba7c9e7fe71eee89081cc1ad170d197116`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`3838fb680000b264804d345d0468f97e80f9898a060019d722e8b47e3811ae58`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`5fc379249c94da9ac3980436e00f65119df36bb34b766219ebeac8d1e7e497a0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`1250775b6d8df8021145fbfeb9b39d925ef70907bcddaa9f3f56b127afddc24e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`58bccd306be9c1a486171e3ddf6e34b349074b22de566cf1d7289ea68a83be20`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`07cc3443c699cb47b3b84e1c9e75d23fd5353101c457eb62f895db5835fd3012`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`b77aa8255ed0045966a973f050f19bbbd3a3aecae3b98736de4430cca8321b23`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`f8def9179d0d4856521628307a2f8e3f7166085bce5dee58cdedef511cb70b53`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`caf13c5a002a642a6bdefbc60389f8e20085cfc6b9aafa78df971f8ef7367372`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`eae2842fe697c4da586229e12ab56f83594492f6f30a49a8646a1adb29952c89`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`329478605cf051d985c54a0ac25c749ee6894199fea815185baab18bf561a736`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`c9dd9357b2ad4ceda6c9df7c839230997ff0d81dd492aab5ea7f61c669007a6e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`7e8fe70b4c6a3852dfc77ffac2bcfa337d8a13c5e298b6c9e711de6d8b89ad52`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`360a8249842a08037ccd813f8fdc859d82c5366d67f324b70c9c2d8496e6b1de`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`abd1b4be3c2d66cc445bf0a5dc78867d733f9db20b34fe91c71e12c6ea97de98`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`2a53741e6143bea645f399edfb350aea7a99b6d7478eefa417a892619e69b0ca`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`8a0db8300c78fcbad7ca0c1ac87ed7f9689ce9944924d0af36d6110424341ca8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`53a4060d8c820964bacdbde9f236a27077f695c6a33a5dda5dd2496d4643ff59`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`ae73585e118be8e9119732bbdbba54fdac9f90b434e5e9827af49aaae341928c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`b9dba2229d00f19e2cd1167acf4a4a46cf96aa34cbe0820472313aa27ece4e63`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`a087b8f25b37e09559e566f65a2fd221c0dfa221b6ec6724cdbea1ac118406de`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`d42924a66f29a3d7c7c4a4ff83dce79847c020d6464ae45eb7f16174115eabe0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`eb7ad3518612f9f5bc4dd25e6d2ccf945ee51922266fb0dce18b5950bd6f2e06`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`6e80ecb66c786f917dd6b9980f644b83fb6fd4d7505ea2479513ab3cd897dacc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`fc16f114fbefb98e7d7f9370bdf6f47dc3bd4b5e5253adb9867b38b68b4a3320`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`616d80871deca9cae2c3d7f47df6c305d1dcd5c04f347e96d8dbbe59ad1ee20f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`20a31e976881950ce80fc3bb2d39de15c032d1e8cd304fd34f3203f682bfd07f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`98705d4e939c485623353c887873fb53a01213fcf13809ab48c65977593db7ee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`c5a70bb8ade3fbacb1b7388a33b6ab0f0dc271091a5054722a48c8c0c6a9aef9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ACOUSTIC-MODEL-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`52a6791e7590f2665fc783e3461abb6c329c1231c23d99032e1dd905ac9c68a8`)
