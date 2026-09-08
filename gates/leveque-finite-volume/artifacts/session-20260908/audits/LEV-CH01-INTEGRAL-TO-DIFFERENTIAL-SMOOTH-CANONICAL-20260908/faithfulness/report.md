# Faithfulness audit: LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `3f7d1fb1fe1042e60da31bebfffdae0fc8039b8adc69a233f892984d97222ff5`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached source renderings and inline declaration evidence establishes the same vector conservation identities, signs, arbitrary-endpoint scope, and classical derivative conclusion. The substantive difference is resolved by checking both ordinary smooth applicability and a concrete discontinuous additional instance. The latter has positive dimension, nonzero derivative terms, genuine integrals, and genuine relevant derivatives, so the extension is neither vacuous nor reduced applicability. The source's unspecified smoothness threshold prevents an optimal-regularity attribution but does not prevent recognizing this strict extension beyond smooth states. No tools, target proof, or independent byte-hash recomputation were used.

## Implications

- **Lean implies source:** `yes`. Under the inherited whole-line setting and the source's conventional sufficient smoothness, take qt and fluxx to be the actual indicated derivatives at each selected time. Joint C1 regularity is one standard sufficient interpretation: compact-interval continuity gives integrability, local compactness in space-time justifies differentiation under the integral, and the derivative sum is continuous. Equation (1.10) supplies the integral-law premise, including meaningful interval integrals. D002–D003 then give exactly equation (1.8) at every spatial point. No global integrability, decay, scalar specialization, or extra spectral assumption is imposed.
- **Source implies lean:** `no`. In the protocol's semantic applicability comparison, the selected smooth-state assertion does not cover every target instance. The state q(x,s) = (x − s, H(x)) with flux(u,v) = (u,0) satisfies all target premises with qt = (−1,0) and fluxx = (1,0), yet q has a spatial jump. The source's unspecified smoothness order does not make a discontinuous q smooth. Establishing the target for such inputs requires extending the source argument beyond its stated regularity scope. This verdict concerns source coverage, not a claim that the independently valid Lean theorem is mathematically false.

## Findings

- **note / genuine-regularity-strengthening:** The theorem preserves smooth source applicability and supplies additional nonvacuous applicability. The appropriate accepted classification is faithful-stronger rather than faithful-equivalent.
- **note / dependency-and-operator-consistency:** The disputed regularity effect comes from the explicit target assumptions, not hidden meanings in aliases, reused declarations, coercions, or numerical operators.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `unclear` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `unclear` | `unclear` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `unclear` | `unclear` |

## Dependency coverage

- Blind translator covered `94` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `94` dependencies (`64` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The source does not prescribe a minimal differentiability class. Joint C1 regularity is used here as a standard sufficient interpretation, not attributed to the text as an explicit or optimal threshold.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`4858753a076f7f68298317b9044b18e197d7bb8b03eaa90093025d0ef3e1d7c2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`01fc3dc2e3ddac3430f6c7b9a91908d7b5d1a526ec0c7a7fd5c73e8354cf22ab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`94140e8a4e7205b818908c641342112d5d85d28a8a49f652c87082dc56325abf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`df51623a27608ef77cf14c7221418d87aba7926bb9e905d59bdb6f8c8a260f93`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`472339bbd432b4309beccba5bfa8d5b9fda82d34d67177c6a11eaf1c3b1ed65e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`3fbd540e54301644560aa0f13715405a81566bb1aab9e49a552fbb0e4afc818e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/decision.json` (`923861c4036334a4c9cff5e5ebb3f3ffc9329c40c1fab4f1f0ad9559a0c58b53`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`20aa40a86851c44308f6c0e908168f7dc10d13b6becfc5f399688a45e0d4dc74`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`57487b30103484461251005a54e37a1b1ec9290776b3b6fd1c5102a6210a9617`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`57487b30103484461251005a54e37a1b1ec9290776b3b6fd1c5102a6210a9617`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`3b6e0e2f25a0a2e0512ff986442256e5fc6d4113f683fae8e1dee76d44a6a980`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`e0c7cb17202bade9263b3dcab1a3935f74f679ab8ebb696fa3381f11a4904be3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`0d0d82312dc6c6364cc688378a769a90fd7a7eb59764d22ca6696faaf12e80fe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`c7f8d0d07a063542159f999040ca4d34def621f6544a900d6c80cf4f3e6617d3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`4a1224c428be5c4ee87ef7781f0886116078be062d6aa7e5d04f369fd3ebdbb6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`0987cbf2337de5aa9f4169affb3dd8b61a4da7a0e7078af46a1e3785bd74a5c0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`4858753a076f7f68298317b9044b18e197d7bb8b03eaa90093025d0ef3e1d7c2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`9465bcf013333ba572cb07b515ed0c2847aeb7044a243e22ef8dda2ad3c349d4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`052825628c601ad3b44acdae1e9e783a5722bc03d2d1ba9ac4c862935cea13c8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`655ac04df4aa0b82a346dbc2401e02fa8fd2541834aa1e388f988ecf93f8dbcb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`f6f4d908d86439529dd9193eff9f068db8be91312ec9b50f95dfd7f8cdada6d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`821264e2fc8bae35cd0e1a201884a367d3fa1df892b2e61aa2dca7e9c3c1964c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`9658cbae00e0f80c172415afe705d1b4e474eae9d00fe0f918fec932d3f27929`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`6946d3f19e1c34976921928d03f6eed1b2743380d6cb0796a6d85b8353c52932`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`94140e8a4e7205b818908c641342112d5d85d28a8a49f652c87082dc56325abf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`9fa8c140970b88448ca4cfbdac3e2e3b79260f8be89af5a99786d8fa68a16d82`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`8cdd9f3a6070b7025a8b6b955746b843cffa24b1edef6eb90e1c141039f7e514`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`d0b942b5e74d18b27c5fc9678f37bf46bf4931972dd0d61d86b558cbc42fe678`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`bc792c1ae2ea2e02c1da68da08bb7f351692f176e55daf74fb7e7b8e68a348df`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`889fe87639d48abd191f99a847e5796cc36138009fc638816fe4096c65cbcd38`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`df51623a27608ef77cf14c7221418d87aba7926bb9e905d59bdb6f8c8a260f93`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`d795afb7ff5b23059c4ca5af390f5bad432640c7756703b736be775b20c5e27b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`f2a74485a4ab250d85da61469534ad3b26a3f73eaa4b5cea3350405ef7c978cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`136b69a03acee49aa1f0248e0c18a585a86e3e48dd0ef853988b7905cfce1b9f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`e5987c46e7ea78d17b76141bde1921ad0e78a68cc4ae3e7344b9605661973218`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`48dbe7a52015a992e0c09037d5721801be270177d8708638c343e90f12d8a65b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`472339bbd432b4309beccba5bfa8d5b9fda82d34d67177c6a11eaf1c3b1ed65e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`7fa71d49eefacf2e4add5f13f0adf995e3fcaefe86975f590aa577593c65a1fd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`efedfc311abd57be57039e01b8a2353ec1a9a594e5c28ea765624e5cc473840e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`ff0fd91f78eda4b6c573cf89d66a14d715b4a93fd1ba40f91124621887a2f810`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`02bd079a57bcde8d2f027f2994f4ab217898eaa8fa06972322c20da24059595b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`b3b20474224d53d941860a59fb857fb08cbb7a00aaf4e1589935ec88de648f38`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`3fbd540e54301644560aa0f13715405a81566bb1aab9e49a552fbb0e4afc818e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`ef9f250ae3fc017b62a15948f564ded6279e878ccdb77ce9c2cde95cae1ab7c4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`cfbe497dbbc7eb434c95a545addc083571faf6ddcf1f40ecd4602aa276383736`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`c2a94a956efd631406f99a815a325cefdb26053da4abc105af1713e5996d23e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`99da097ebb1a2dfc4505f925426ed353772891f6c9a74c1f3dddf924a79c672b`)
