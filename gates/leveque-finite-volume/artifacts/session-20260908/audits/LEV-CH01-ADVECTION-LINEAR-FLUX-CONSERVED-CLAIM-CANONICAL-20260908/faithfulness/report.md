# Faithfulness audit: LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `f57692cff2099eb9d755a3867856aeca95100f7a97ce76a067c4db71474730b7`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source images and inline declaration evidence supports the direct classification. The round-trip concerns correctly identify choices that require examination, but the enclosing source resolves them: conservation is expressed through interval endpoint balance, the advective flux is explicitly specified, and the differential passage is expressly qualified by smoothness. The Lean proposition retains that mechanism and both mathematical conclusions through a harmless singleton encoding and explicit sufficient analytic conditions. The other checklist items remain consistent with this decision, including unrestricted zero and negative velocities, arbitrary endpoints, exact quantities, and nonvacuity. No tools or target proof were used, and source bytes or rendering hashes were not independently recomputed.

## Implications

- **Lean implies source:** `yes`. In the source's inherited classical setting, the conservation premise is interval balance (1.10) for the specified advective flux. Sufficiently smooth density supplies the target's explicit derivative, integrability, interchange, and continuity hypotheses. The singleton embedding preserves density, derivatives, and spatial integration. The two conclusions recover exactly f(r) = ūr and q_t(x,t) + ūq_x(x,t) = 0, with the same arbitrary constant velocity and arbitrary selected time. The source does not additionally require a finite whole-pipe integral, an independent kinematic construction, or a nonsmooth differential theorem.
- **Source implies lean:** `yes`. The source identifies the constitutive flux and states the integral-to-differential derivation with sufficient analytic justification. The target makes that justification explicit: interchange and integral balance determine the integral of the temporal derivative; the spatial fundamental theorem determines the integral of the flux derivative; residual continuity gives pointwise cancellation. The constant singleton matrix yields the exact flux and its derivative speed*q_x, producing the scalar PDE with actual derivative witnesses. No source conclusion or independent restriction on velocity, density sign, or endpoints is added.

## Findings

- **note / regularity-scope:** Equivalence is assessed against the qualified classical modeling assertion. It does not assert equality with a uniquely specified minimal regularity class, and no stronger classification is claimed.
- **note / constitutive-flux:** This preserves the source's constitutive specification. It neither derives an unknown physical flux from conservation alone nor weakens the flux identity to equality up to an additive constant.
- **note / dependency-and-nonvacuity-review:** The disputed semantic dependencies introduce no empty-domain, default-derivative, nonintegrable-mass, hidden nonzero-speed, or impossible-premise shortcut. Reuse provenance was not treated as task-specific semantic validation.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `unclear` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `134` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `134` dependencies (`66` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`4a83e54600acae5088a482ac165fe48844d54db8ad5f82134799c65f0c33f8ae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`d960b558664362e8d4623bf43b8f7daceb2feddaf4a6c57c784279771f1288e9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`717ecb3dd7dc4934908f6484d380632db70358094b6b547fda30eda112ea54d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`bd59b4a5839f0482b05cff787775040e2a78a68dc83059445612c52968ef7d1e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`a01fe4fa7160b7858feacc4e5b2b0acb3811e747330f65899dcd49a496c950d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`db7900e12a8c5e59fa267948d3a9bcea41cb318bd9a22a17a89895e5aae13650`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/decision.json` (`c63c9040403aa195fa47ed240e0cfed9273ba98afc8d7bf8fba12f6d06037c26`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`088baf78993fa6d92d9e6d700e71db39340b59fd097f493dd516bc2afa043215`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`1588b45f6147eb4d77b5c19cf3280e540073fec5858fce3fd13575659c8a1115`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`1588b45f6147eb4d77b5c19cf3280e540073fec5858fce3fd13575659c8a1115`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`7bc189519dd5262cb0cdcfbae8e9c6cade96347aff52314d2797b18b3e4239ec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`4c2e8e8f90f2e2d13a91b7ad184ffa45c26790ce933bd1c4a378c26840fad460`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`6e032d8b83dc2e12b7de2cfcbd7ba7cf21cba4977e967287f2220ad34e84e228`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`11d647aea38e960d1b0cd6e0cb1df61b282bc7a6bb5e0b2997dee25d452a782c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`a8c0ef9e9eaa3e9be832080a33c0c86295af6c28a768b771de15880245699b93`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`65bc1bd007be8dbe08a7b92affadd60def5691cfe052082aac7d40c0fa3903d2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`4a83e54600acae5088a482ac165fe48844d54db8ad5f82134799c65f0c33f8ae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`92d3aadf341ef959a2f41d93f882a7fafd8b850849283ab6caa2c1dafa047d43`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`1d5bb9580a7ea81e6bbf037eb74e8d051e5922462f3ee248630dafb0680a50a7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`a60087a8d655fb2d278eedc93f6ffa4b2698047f79247cfc4610feeb4b542015`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`db3c7b78b350b2d4e38cffa6e8dd25efc34a6fedb6b6410d53cc0bd8e1571557`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`0e8d979466590ed445ef2650318fd34416d6b10bca48d01b3633bc6f5e555b35`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`9a11a87d3903f54b26adb58138c560d2837d219c0ee86f8f2a80602fa1737e6c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`717ecb3dd7dc4934908f6484d380632db70358094b6b547fda30eda112ea54d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`c56c7e6388be3402c2a2985afd7699843935e78593b86a8ef9f8e5be2a52d92f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`f5dac0a5a76408b83e2548dd7428e08ee7bfc9fa89f138dc31cf231325cc08ad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`c25bdf3d17042f8a9cf0df49daa645d964e486b5a3d3c54be3183341925319ea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`d6ac859eb10443d59e8a7cbaf3989c71b0a870b6c86902550fa2b3cee79e1a90`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`082033de0d825a17492c95a3a7c20036df7d2d6dd2d1cbe12dd3f37835ea9f25`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`bd59b4a5839f0482b05cff787775040e2a78a68dc83059445612c52968ef7d1e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`a4c2b5470f0b3489bf56cd7125616adac5fcdf519912b01ca107af30fc7d2422`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`240e8fdef50086436d12fde7a0db30b3b2b47caf64c5094656d4e36dbd3522a2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`6322c0c468c42b4cd74a12fa22b182275bf622b3107b73bcba5de7e9d86e383d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`233d0dd0b74246dab29bcf54a0e1400ac931e477b508311e9651c734cc541ebc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/page-026.png` (`de53be1aae881a448dd2718b09830eadd7387124ea339f874ee5f55d49fa2257`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`40246b2ddbf6d8e80b0879f455dd9f2f138b51e65c720f33c5c6b79c9caa4c10`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`a01fe4fa7160b7858feacc4e5b2b0acb3811e747330f65899dcd49a496c950d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`105593bf9505f2f84a7bb6c1846b737877a3c11ab7d349b51dfae82ddaff7488`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`66dbb6e9fc920527972fd56b408112b5d878ef9e51f72152a5132945853d7997`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`e263796a43ceebb6392344cef6bd753bdb389a9b6c606a9904dd9a3fa9c39765`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`68d2df24f9daadc8bed18af15677ee4907f86f077d802855edfba2a17b944520`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`bb51f67e1503a38e810f2b2138139337e2c995fe2ad69eaa6d6b74dbb28da117`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`db7900e12a8c5e59fa267948d3a9bcea41cb318bd9a22a17a89895e5aae13650`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`e54c253995446b5b890c37170be054c503612d5109f83fe82491240ea5346ec4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`6fba699a99c063f5a8fa095271ba37cd734a56c7a2bbcae89c0a88dfaceb351b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`904aff9796837c1b466ee12b2f284851a73872d12e5c689c73beccec4473f928`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`58bb61432b46b577b06284d5af87a2ac1fe3649807655b7d4fcafed9c61ab7c4`)
