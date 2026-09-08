# Faithfulness audit: LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `f57692cff2099eb9d755a3867856aeca95100f7a97ce76a067c4db71474730b7`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Inspection of the attached primary-source pages and inline declaration evidence confirms the scalar domain, constant coefficient, exact flux, endpoint orientation, actual derivative semantics, and nonvacuity. The blind translation accurately reconstructs the target. The regularity disagreement is resolved by distinguishing an adequate explicit sufficient formulation from equality of unspecified regularity classes. The decisive failure is the missing nonconservation/source-term case. Source and rendering hashes are treated as supplied provenance; they were not independently recomputed.

## Implications

- **Lean implies source:** `no`. The target represents the exact linear flux and the homogeneous classical conservation-to-advection implication. It does not represent the complete selected paragraph's assertion that nonconserved contaminant mass requires source terms. Its conservation premise excludes that case without supplying the source's conclusion about it.
- **Source implies lean:** `yes`. The source specifies f(r)=ū*r and derives the scalar advection equation from interval conservation subject to sufficient smoothness. The target gives explicit sufficient conditions for those same classical operations: actual derivatives, interval integrability, differentiation under the integral, and continuity of the residual. Under the reversible singleton encoding these yield precisely the two target conjuncts. This interpretation does not assert equality with an unstated minimal regularity class or infer the result from kernel acceptance.

## Findings

- **major / omitted-source-case:** The target is incomplete against the complete selected paragraph. Acceptance is withheld.
- **note / regularity-interpretation:** The regularity question does not establish an additional faithfulness defect or justify a stronger classification. No claim of minimality or exact function-space equivalence is made.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `fail` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `fail` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `134` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `134` dependencies (`72` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The source does not specify a minimal regularity class. No equality between the target's admissible class and every possible interpretation of sufficient smoothness is established; the adjudication recognizes the displayed package as an adequate explicit sufficient formulation.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`ad3077b9d210ebb6c675d7cc7da0f34ac9959911b6bfe622d0b26f46097e743f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`a6ecca826d78c24b3030ffa2aaa9b1c00ba4e698fc28554c88bc5c409a2a22c6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`fa8ad754636cbc8991fa9416afa6750316bd0b5a7bd30f3ef7e74c4f3bb13e98`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`262cbc8ef384fa146512daab6ad713068a27007112cb2c147fee2db8fa218aee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`5994a747d21b5c4910fb9782413e2b17cf1e67ea008e8ff44b48dae4f2952b23`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`7d46a12d1fee9ec8923a48888d693faf92bb38747ea6c2544eddd6c25f8a1aa5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/decision.json` (`82c70fc8aae81f9790650f4e5ed6410008c1bb222dd908a5f89691b4db94c329`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`088baf78993fa6d92d9e6d700e71db39340b59fd097f493dd516bc2afa043215`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`1588b45f6147eb4d77b5c19cf3280e540073fec5858fce3fd13575659c8a1115`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`1588b45f6147eb4d77b5c19cf3280e540073fec5858fce3fd13575659c8a1115`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`5eec7a6689407e259a0326f8f18262c2e0dac8ada533740a1c22428d495d9d1b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`4c2e8e8f90f2e2d13a91b7ad184ffa45c26790ce933bd1c4a378c26840fad460`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`2f4b1348d9086b1e4af2b7dcf155ac2abf48bb630c87f673481fdee826446b67`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`d9a041a3086b5b6e6391caecfea089ce834072d14d91fc97ee40e52f5b9167f4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`15da4b71c74480d3599489f7b6c7fee20c05c88692b778031cb2b5782fe298bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`0d4c98922d4503d3408f7c4e23c2579d4f1b975ef4112a1f3f5d9ae678e10c40`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`ad3077b9d210ebb6c675d7cc7da0f34ac9959911b6bfe622d0b26f46097e743f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`84a75ae5090f5fcbc5e14646864d7fe187f56745903c35f061f0d8965bc89673`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`2806e30ad663b2fda7c2f5616271529d667176d4ed736c87e784dff3747a870b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`105f485683e65c7b7b857753648e312f1dacabd896577cbe8dc19c2b85f0d0ff`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`926449150c6ed4f2ace84a902ecb1fad03b51d079370f71c4690465496d2ed5c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`3c350c496a57d4938bd8f934c8e496b1b6149abd6734c7755cfe4c32c2e2cae6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`f39d412f4e488ae5835b773710ba7b437afeef3cc7705f97000dc3f05b50a3be`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`fa8ad754636cbc8991fa9416afa6750316bd0b5a7bd30f3ef7e74c4f3bb13e98`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`c56c7e6388be3402c2a2985afd7699843935e78593b86a8ef9f8e5be2a52d92f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`7d24c398f7333f1f435b3e0937a95db3981168534902200c2fad750e6d4fe910`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`851d30bcaa86a15204b4b66d145013570388d1e326caa0ce857b0f4decef13f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`9d416327984e783a2ba86b7e8719b32c2ce8acb3481f2cd8abe98ced4c0f0e57`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`9f96df77e600c844174d98a9b329554c878a72dd5d0f1b14b4604212f5d7d430`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`262cbc8ef384fa146512daab6ad713068a27007112cb2c147fee2db8fa218aee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`c394c13fc6c6316050321517bf362713a6e5e8d44d586170f584a4a78e639dae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`f94cc609980044bd823bd7cb12bd3ba1b3a421fd01d7b77d01f3a8a6b29fb80d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`23a055f174e4297e37dec898805ec327fdf6f103f8de8d3657b38a6ae2da6008`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`2e850fa8383518caf8ea167e8c334ec347d5cca761ee39f4097caad27c1d0bbe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/direct_reuse_preparation_20260908.json` (`d6460fe23446f53aa3dea07ff10ad5e902bfdfe35acfc4a9e1300ee5ddb38e52`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`599667e9efc3f101fa6862aa9401cf27fe45aa83f78827e9ed9894a3b0bb3de4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`5994a747d21b5c4910fb9782413e2b17cf1e67ea008e8ff44b48dae4f2952b23`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`101fb56358baad19b962727432e2bc624c4dd97a3a1ae138812f27bc230e27d1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`7319237eb98dc758caf94c7f1be13dd2b1ad13ced3df17c567c2fc8109d4bfcd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`ee4204145c15a190f5526b7f6a749242c5468a3add8de3607373ad2f3320fdf5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`adba7be7a1f5c9a9ee0e87fb801f148e148ce0769bb8b776da6ea8c67cf5d76d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stdout.txt` (`538751f5a8ae82564512613dee8f2044742a0d50d2f477b3610c29a8a77142a3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stdout.txt` (`09fce17e89955a289dc95da4cc9f3c812b25115602512cbe985dc53b0e6ae7d6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`591eae56cfb2f6ad65383392436e30fd95f3fabb82fee7056a06aacf852eaa26`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`7d46a12d1fee9ec8923a48888d693faf92bb38747ea6c2544eddd6c25f8a1aa5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`78514e8dcff20698a0f5a52679d8fa065b3ba09caf21097fa885d899c8bd1f1e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`e7612f411ff5c9798a85b10acbaf8eadf4e3bd41a744605a290da2ec87c2fdac`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`4c79944c72aaf7c4beb181845451dfebba0ae9e4832fba7f3390df9c66375a50`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`053cb173f1e61e6cae10efcbf4d687bf6903fa3ab75467048cc13e7c75e04d6e`)
