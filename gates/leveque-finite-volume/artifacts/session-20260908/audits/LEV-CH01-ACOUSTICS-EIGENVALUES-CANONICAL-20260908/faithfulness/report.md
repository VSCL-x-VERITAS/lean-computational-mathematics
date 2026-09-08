# Faithfulness audit: LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `02e8b9172a3f0eb711b8f7ee836eac155ccb83a2e164718cb56c987e40d8721d`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source page images and the inline declaration evidence resolves the disagreement through inherited physical context, not majority vote. The round-trip objection correctly distinguishes algebraic sign conditions from individual positivity, but the source additionally fixes density as a physical material quantity and describes positive sound propagation. Those roles justify the target domain. Fresh checks of the definitions, including reused declarations, confirm the exact matrix, quotient, column-vector action, derivative semantics, and propagation signs. Both implication directions hold; the explicit witnesses are derivable, and the theorem has nontrivial instances. No tools or target proof were used, and no source or rendering hashes were independently recomputed.

## Implications

- **Lean implies source:** `yes`. Interpret the source in its stated gas-or-solid material setting: ρ is positive material density and c is the positive sound speed, so K = ρc² is positive. The target therefore applies throughout this inherited setting. Its matrix is exactly (1.6), and its locally defined speed is exactly √(K/ρ). Nonzero vectors satisfy Av₋ = −cv₋ and Av₊ = cv₊. Since c > 0, these are two distinct eigenvalues and exhaust the spectrum in dimension two. The fields f(x+ct)v₋ and f(x−ct)v₊ satisfy the same acoustic PDE wherever the profile is differentiable, and their phases encode leftward and rightward translation. Thus both the spectral identification and its wave-speed meaning are represented.
- **Source implies lean:** `yes`. For any positive K and ρ in the target domain, the source definition gives c > 0 and K = ρc². Its displayed matrix has the explicit eigenvectors v₋ = (−ρc,1) and v₊ = (ρc,1), as verified by direct multiplication; their second coordinate ensures nonzeroness. Equivalently, any nonzero eigenvector for either signed eigenvalue can be normalized to this form: its velocity coordinate cannot vanish, since the second row would then force its pressure coordinate to vanish. For either branch, a derivative d of f at x−st supplies genuine partial derivatives −sdv and dv of f(x−st)v. Their matrix residual is zero. The independent universal profile and point binders and the existential derivative witnesses consequently follow from the source objects by ordinary algebra and calculus.

## Findings

- **note / inherited-physical-domain:** Acceptance uses the physical roles and surrounding propagation context as inherited assumptions. It does not certify equivalence to a broader algebraic assertion for arbitrary signed parameters or degenerate sound speeds.
- **note / eigenvector-orientation:** There is no semantic orientation error. For the negative mode, w¹ vanishes and w² = −2ρc f(x+ct); for the positive mode, w² vanishes and w¹ = 2ρc f(x−ct). The source's direction assignments are preserved.
- **note / derived-conclusions-and-nonvacuity:** The extra explicit witnesses do not warrant faithful-stronger classification. They express the selected spectral and propagation content with ordinary derivative existence and without vacuous premises.

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
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `110` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `110` dependencies (`14` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`4c10cbf5cbb788fd930b776d8ee3fe1a4d2b76d9072282416bdad4df03653b6c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`568c7c162710b602a492f34e79153042ff57379858fde4cde4d29252b430f6df`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`d32e7ba80c2b718ce7626ad8b098cff825553780002c368e3d0b2569901f6f40`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`edb48d021082415c9653dd4da54d3998125ce30dd7449bddc55da13fa16f7cc1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`d9acf3bdfec310d2265130e299544699831a2379de3d792e5e98a78ce34628dc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`c9550fffa2b0eac2bc353e9d5dd76d3c6970d02761a9b9dedc4a8b18823f3edf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/decision.json` (`e1c0988ada33f693acf8cc68207d39891bca4afde70154c024b9203c2936638e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`eb576d2dcf4fe29ce797b825ef24296fbb129bb9b8c47985938649acf2332b7d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`5b180b224bf13e32996d504b990b2a7d2af1ca76e9caa2ea8db63bd5310266c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`5b180b224bf13e32996d504b990b2a7d2af1ca76e9caa2ea8db63bd5310266c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`e8246e9ee54a3b05834d476ef953d80c7804b961988af777e3258bcd1de79c84`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`1d7b8c5b145e18baf669e9eab3eed52030c86b726435a7929b533adf67d54bc1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`0508176a3eba9cc26c42c62f19d5dd2bb43fcce69034b81e8386227a01fdb73f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`a5a24fcba701e630003c97ede3a32c811959c353d13f27d115aaeb2ad002ca33`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`371e1fcdbce3524122ce2a9e4bf5dc2c007315a61dbf36e5d4f9fe583814cb2f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`975162c7e3c4caeea639423052b0deb39acb642ea24f2c15aa674391baef3364`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`4c10cbf5cbb788fd930b776d8ee3fe1a4d2b76d9072282416bdad4df03653b6c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`e3fcf6d71eb891b46d0b210fd3f749150f17ee81a995b5dd24dfb61694d8576d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`d25510991fe62d59d94d86c1bd1b870747410b725bdae88573c7553b2fa689ba`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`edebbaee2210d399c6ca2b4165e813627f5d8af5319e18c7ba30a6c53996513b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`6f8c36e1c07a8624b034149fd42c74d1cd9c42098dc4d993ce3d1e630c40551b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`c20b1e38cd7e9f44f4712246447aebff1fd72e25e7780e9ca9743841c81704ca`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`58bccd306be9c1a486171e3ddf6e34b349074b22de566cf1d7289ea68a83be20`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`0b08e2c2d37b27f9c6476bc8dd2e0295899e16fb6537cfe036970c861cb0c78d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`d32e7ba80c2b718ce7626ad8b098cff825553780002c368e3d0b2569901f6f40`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`80175a4e431d42ecb82ce56259a42296779b9f541461a0e4fe857b1a14ff19d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`1ab12397f36076e2b86ed9f83f82a261d6b181c8811055bda7c3784877f9a266`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`9b15daa0a24fbfca870ad7aba5adcdb0146a1583fdfe210a4b11640669da86d3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`4004f69b1d4bd763b5757beb70f6200b6d64ae16cd6d37fca958c83867863c1a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`571e3605bb0d62e481bd6925f6ca0c4b6aa2141ed54a1171e210942e5d11966b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`edb48d021082415c9653dd4da54d3998125ce30dd7449bddc55da13fa16f7cc1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`02b0f9bc3f1ec2ad42bf56b39115dcf62d0f9ac43e99b23cfa4af50643e8246d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`2a9be21add456ad630c48c87c9b7870713b3facece00ff494a645e38e6cbc5e3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`1765f0efbfb7550552af06796db676f5409bcdf274e69a7297082ea016cd3066`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`cf850c0c45ae0c5eb72fb07026e99f697efddde2f9e0237aaad1535e57267f03`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`b6db82e3a44b5b62a8b1e6768da689cde446f7aecf9040421388b03086a8d609`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`d9acf3bdfec310d2265130e299544699831a2379de3d792e5e98a78ce34628dc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`0864e1aa0a534316cf6447c8502fdf15fa1ee22c471a14796499d1b4fd3367b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`dd4ea3ddc4e1aee3a1620e2226c30ce34c5b0757a74a7ce632affaf3c36dfc40`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`617b2abb5810b8e957caa16fb982cb7ee4ccdc8621d56b7f3c6b118ad844ffff`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`edb2f21d5a1f309807da94d2c2034347978573b00f27df374001c6aaf5967303`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`f1b93535b2e505cdf9ff9168c99ce80acbf2f5410c794c7453d13c251f7fff58`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`c9550fffa2b0eac2bc353e9d5dd76d3c6970d02761a9b9dedc4a8b18823f3edf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`ebf884bc87ddfd23815c58d1fbd686bf12e4bfa62ccce5bb1a00626b281bec65`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`3bbd7939f3579adffc073e25f6388242461c3815fefe764c29e3ec0e0328a9df`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`b1db0eb475ac8181f466f955ce5dbb3057c0c775c2e77e246aa2642a8e0e35d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-EIGENVALUES-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`a5ac985f68b9c496c658021a64fcfee17cbad5d31324347474f83a7bf5bcc46f`)
