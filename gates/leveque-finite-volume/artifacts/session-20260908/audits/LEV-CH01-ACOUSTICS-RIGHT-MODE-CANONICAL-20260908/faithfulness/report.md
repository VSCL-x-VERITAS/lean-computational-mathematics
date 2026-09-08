# Faithfulness audit: LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `314da48d06992924535db624d9872074d95ad6d44320e8b42682ee9f3c708e37`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source renderings and inline declaration evidence confirms the exact equations, field roles, mode normalization, parameter linkage, derivative interpretation, quantifier scope, and nonvacuity. No dependency mismatch or excessive regularity restriction was found. The only material uncertainty is the source's exhaustive parameter domain. Keeping Lean-implies-source unclear, source-implies-Lean yes, classification undetermined, and accepted false is consistent with the supplied policy and avoids converting plausible physical context into an unverified mathematical restriction. Source and rendering hashes were supplied provenance and were not independently recomputed.

## Implications

- **Lean implies source:** `unclear`. For positive material parameters, the source fields can be packaged using D007, and unfolding the target gives exactly the selected source conclusion with genuine coordinate derivatives and the prescribed positive speed. Full source coverage remains uncertain because the passage does not conclusively specify whether individual material positivity exhausts its parameter domain. Algebraic both-negative instances cannot directly instantiate the target; their source admissibility is not established.
- **Source implies lean:** `yes`. For every target instance, K and rho are positive and the bundled fields satisfy both source acoustic equations with all required partial derivatives. The selected source consequence gives the equation for exactly p + rho sqrt(K/rho) u. Constant linear combinations preserve the coordinate derivatives, and sqrt(K/rho) > 0 follows from the positive parameters. Bundling and existential derivative witnesses are harmless reformulations.

## Findings

- **note / unresolved-parameter-domain:** The theorem matches the source on positive material parameters. Unconditional equivalence remains uncertified; no source-admissible missing case has been established. The round-trip judgment's major severity overstates the evidence if interpreted as a confirmed defect.

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
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `94` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `94` dependencies (`38` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- Whether the selected source's physical material context restricts K and rho individually to positive values, or whether its asserted mathematical parameter scope includes nonzero both-negative values with K/rho > 0. The attached pages support the physical reading but do not conclusively settle that exhaustive domain question.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`bbcba17e20729c7d93dc6b6f8877157c198a1de68bca0eeabfe83aa29c5a80b9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`6d063cbc540173a781d51857a42e92e6556152f4c316c2fdf6e06a0fd5b274fb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`e00c93aa491985cc5868afe56779bf6b3df4fc034453b1e7e80c52308fe4550c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`fb137ca07542fe339758614921330558133761672fd9ed4b238ebfb8da08e05a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`4a52d245adb5cb0b1469504d7d80a18c0ea77b2d6e8cb7e59884756af40ec5fc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`f86811ff17c2802bacc2827459e97eec6d637f745768ae4e821a3b8fbe022302`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/decision.json` (`a6363aafd8ed62009ba884b91bcabc7d8af735da52d5894375a35344f8eecb28`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`5eeedf5898fedc3abb67e34c30f91a19a29414e21945617b64d36d62f074517c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`c3380d1db8169ba8bec1502b3fe3c36534f1387403319cd10054993e97dbb277`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`c3380d1db8169ba8bec1502b3fe3c36534f1387403319cd10054993e97dbb277`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`0b6f08f02d1c99a23c5d42ca1e50f5b2856e48f905b75089324aa90e3515ae6b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`bdf22c0bdc4aadf76856e5ebccded82d510bfb7974b1ecbe54f6e194b055e3d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`454a208de177cd7527a8be5bd5bec1d635baead4d929db5d87a1a1344d910e03`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`7e5640b7ff032f5b0bb35fb27321273caa97a3fd70f16a9174a4d935f377f60a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`3763da28f80cf49ec9b6cc2362d2b3cf7f6bcf97d1c8212cabb827aa37d6420d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`8c4245ec4c3c9243dbbfa0305aac28ef76414c5482adf1ead846f96f70d02079`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`bbcba17e20729c7d93dc6b6f8877157c198a1de68bca0eeabfe83aa29c5a80b9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`583732719e6f5a7184bb6ef3a3e05b64a8065aa6c8d13cafc7a9458d35be5215`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`4a1cfc302a51ececb0d1ba39dc92f6ead98a55e2ceebdfdc81ed166c2ffc27ab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`cf2427c4cbeb05ad0467321939d98928fd97e6fd6f7640648ddcb733781bb0dc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`64c20f69b86178234daa20926cc92c1fbe4348e963d5708582ba7173483cbd49`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`49f361a810b3110b98274bc53fe5c4a4da4ddb4fe737adbd38c4354a90fe06e8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`32fb6ed24427c3fa581837144ce1f4dfeb7fbb3fe4954a9e8cbddac8578446be`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`e00c93aa491985cc5868afe56779bf6b3df4fc034453b1e7e80c52308fe4550c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`500855248897d836b3883691441f135faf61015eadd6230e48716966f5c15439`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`23b6b96e0623e099dca5b905f6efd8c4354236295a31ecaa9f40d1c5f24220e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`792f8de6539205d15b21f2e09ecd45fff8fa1e32432c1d1945a1eb695aea1f62`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`b96167635ddbb5dd61f1f67fbe31ea836e3ab1c7a5a04205fb6c46a883a3cd6e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`e390af3977f66cca248f2fc61bdedbff2d6db2130981ca9c371967bbbb561c4a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`fb137ca07542fe339758614921330558133761672fd9ed4b238ebfb8da08e05a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`36eec015454f81e391b9ddd198252bddebcd416954236c8b7b68f272d204fb14`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`fc007fb3d25b417432cee2c95af679c5667a5d2ba8af38140fad3219edfcc518`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`15219332e9659ec3e9483a88056262dafbe374712a18e55128c286a4e7aab297`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`7d121024e0e9b98c1f088276574fa2d669aa29d898c83349cc9816e78815582d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`4db40d7a78e97bc60a1ed05207275e835fc18fb04e855d16611111cbb6166135`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`4a52d245adb5cb0b1469504d7d80a18c0ea77b2d6e8cb7e59884756af40ec5fc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`09f8e25b9e73f051641427c16a3621447c3e6f9a2a5872e6108be7bbdb466540`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`c930a47fefe698e80e06bd13c5ddb1b61622ce716c4dce83ba5ac350d7b9ec5d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`37dd80d4bdea62dfe0742309ce1c9ef2c18f653aa561175014d1315d26330818`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`6556f73f6034e232c9fcbb26a246b0d8485e79e5f0c639c211a7fb10dfe0fa04`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`4cf4e2af055600506b6ec19604ea9b06a9ecfc7763b98076092ef7b46cf6ed5e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`f86811ff17c2802bacc2827459e97eec6d637f745768ae4e821a3b8fbe022302`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`9edf536780ad039df93eacfcea2e9321c63a54bddbef5ddc25a3afb99f139ee0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`809ca732438bbfa1c4c4e1ed64cbef691ea4cae527de30f623d64a0d17bf49f3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`05da230633077c091ead62a5d60378045ed882d7b301b90f546caacdee3ca713`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`45de4fcd8ae64242b6b0a3fb25cf3e7361af18ef3606d28b213c77748d7a0681`)
