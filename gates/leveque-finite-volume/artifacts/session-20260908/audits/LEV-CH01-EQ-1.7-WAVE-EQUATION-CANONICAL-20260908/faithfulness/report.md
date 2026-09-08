# Faithfulness audit: LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `1a5a9d4825066697f71333b026f9a6cc25c1368b52f0c5c4683536d626acc482`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached source pages and supplied proof-free declaration evidence supports equivalence in the inherited setting. The disputed restrictions reflect the source's stated domain and physical acoustic context; the locality of the calculation alone does not establish a broader selected theorem. Both implication directions preserve pressure, velocity, material coefficients, actual partial derivatives, and mixed-derivative elimination. Nonvacuity holds for a nonconstant quadratic traveling wave, and the represented positive coefficient recovers the source's second-order hyperbolic classification. No majority vote, target proof, external access, or independent hash recomputation was used.

## Implications

- **Lean implies source:** `yes`. Within the inherited real-plane physical acoustic framework, source fields satisfying (1.5) provide D006–D007. At a point where the source's indicated differentiations and mixed elimination apply, their derivative values provide the four HasDerivAt premises and hmixed. The target concludes exactly (1.7), because the source defines c = √(K/ρ). Positive material parameters also recover the surrounding second-order hyperbolic classification. This implication does not assert coverage of an additional arbitrary-open-domain or signed-parameter theorem.
- **Source implies lean:** `yes`. Every target instance supplies both classical acoustic equations with fixed positive material parameters and the derivatives needed for the source calculation. Differentiating gives ptt + K·uxt = 0 and utx + ρ⁻¹·pxx = 0. Equality of the mixed values yields ptt = (K/ρ)·pxx. Since K/ρ > 0, this equals (√(K/ρ))²·pxx. Derivative uniqueness identifies the certified values with the source derivatives. This compares the two forward statements; it does not claim reconstruction of velocity from a pressure-wave solution.

## Findings

- **note / scope-of-acceptance:** Acceptance concerns the selected classical physical acoustic derivation. It does not establish an arbitrary-open-domain, weak-solution, or nonphysical-parameter generalization.
- **note / reuse-identifier-resolution:** The declaration evidence resolves the historical identifier reference without changing the target's mathematical interpretation.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `unclear` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `68` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `68` dependencies (`43` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`5049a2e20859815a768e848f92ad295eea6f17660d02fab789393d8ba2837608`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`7c9b8bad7e905d40370e0a7de075afb96e4b93ea157edc53e0264f4d1b23ce8d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`55dd3fe4a57e64744a6e7333be4bf158684512e2c8ffe14b05a78a4a0b4d4ec6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`a67c132ee67d2a4feb3acbbbceab05a9415d7c02883d7d6b52d2efe845e08874`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`a38429afb2fd2f4f59a4cbecef587b96f2e0a4b7b5d17abc0ee59ed9c931ae71`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`315166e15cdcd55abbd7808ca7682385922cf41ad95a105170791b6d9693265b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/decision.json` (`1fc5c546c61d2f06ebcfea5d01c7c73781a7699112f028482956bfe432aa2720`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`745de6c2c99980f4a61843b9b11ccd3044766a9809b5d10fc3612e490397836b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`74d036affb9ff1fb1626ce2f2c9674bd506681fbb88e4c8f776d79a5086e3955`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`74d036affb9ff1fb1626ce2f2c9674bd506681fbb88e4c8f776d79a5086e3955`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`f8315540671d30c77f5338a66dde795933e557686feb50132dacdb2a2a9db45c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`3f262ac2a6f28fb5f95a717175480c764bac8b03023a98c35e7fef0532fb1e26`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`e16c3d7b499ad2995886c1d086ee7e6fcef9906f53823afc45a5308e16f8b883`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`ea7dd38dc1d414314238a0d453f24820ff896b660bf8be47917b48a3ca87d651`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`289aa623c865ae778f5de4486b8e2618ad2a5d92e50277f024944344a34df8dd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`380c1f8b29c4858f2aa7649cbf46dea60ff72cf3bb42e5b0071b2ea3b013db77`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`5049a2e20859815a768e848f92ad295eea6f17660d02fab789393d8ba2837608`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`e8ffafe6710967fa8173cb01f13132d3feb6619431ab787417a859c05f229672`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`c343af410e741fa70582dbb32f2b8c220c84b42bf751e1930498de010edf55cb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`db70b102c5b308699fb7ef47f75d2df09e2d3345d557b2479a8baef5d1ad2bb9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`c9970319118301440faeb2dbc44b96d7f9bb25c69477afef92c52e4206331c0f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`3cd048a61314d22d02db6919c23d431f204617218c7fb61e10d97cbafc1ca284`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`b9fbda19d3bae1e9270382ce3e4d1b19f709417edaa21406e9a1966f6f5058e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`6ef00cbd8d2e01d29685409dd40bbf56e5c6957d9e2366ff4e7c9a5855df946b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`55dd3fe4a57e64744a6e7333be4bf158684512e2c8ffe14b05a78a4a0b4d4ec6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`b9762ab6e031b4e05c059903e32e3a07e81c4f41fcbdbb152f0d909f3c5a7e26`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`a9666cbf8e4392042ac64b414b3093247b4d49c8a4397291d780b22c97f4a6f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`a4e0df29b0f9e91e9f275589296894bb823099479d527a69d15a04c44890307f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`99055d19a553c97baca86970136debe691cc7aa0416cf89620a8a94de835603d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`8ac27abc11323ff51e348a51d88013eb971eef358aabb506064cb881e1cc30d9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`a67c132ee67d2a4feb3acbbbceab05a9415d7c02883d7d6b52d2efe845e08874`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`6b8b8cf935e1e8b616e9dae4246d3712c37d4cfa56ac1537ef3e477223a5b996`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`9f85bf60d8621154f72f6622a1f2c14bf011915a7ff0504031edaa2563c84721`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`d11d1333a2a5729dc8a61ce0fbcc10c1390ff49efd67638bc231c913bfa839d2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`c17beafd6f6294084c81d8afa80f87f2deb9cf8d38fa1ebd0689f662fd89635b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/direct_reuse_preparation_20260908.json` (`7559aec6ea81ec3b48c313b072f3b25f2e37d153e784edd77d4a2f8bb522ce17`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`d962aa2ca2e362f04c76fbbcb3355c623978240869325d8436469b6b1087398f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`a38429afb2fd2f4f59a4cbecef587b96f2e0a4b7b5d17abc0ee59ed9c931ae71`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`de8f7daca1fb4a48be12385d4eb24fbcd8ef9825660238051a9d6f237cd60230`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`01156f226585216e18dbfa2fb8221aa4f5ef62b6e539ea387028c6a3dd0a0f60`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`1d15be056cabd7451d34600c79b21dab8bc69224f88b4e3ff406fc1c5ebe3f00`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`d0c911dc9a52ac23b2be0b23a61f2291359305605225f8a937040728318ed4d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stdout.txt` (`c978b3e6286220a632938a4aff67f333b11e7f8f78e04e7f246c4a091a40cd1e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stdout.txt` (`5765feeef17184ce1e763db3deb41f2574f56def179c4b13709a713ce7686f19`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`435ca556b433537772017e4d8cfacf7cc1be4e8a8c34c1c2b6967b60b10a8172`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`315166e15cdcd55abbd7808ca7682385922cf41ad95a105170791b6d9693265b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`ce38ebe4de3cc268ccdb0505196864171855d360d6a64f1074ce5d6d1481dfbb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`28bd03f5d98681180e15aba8c81b2dc9650d5ea7d1a6538e9b4abf1013004ab4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`8d933a14323d236b05c8b36f2543d76ba16df252cd27d805903c3ed496800319`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.7-WAVE-EQUATION-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`bfe03ad9ea16c3f7b70d22fe39f220e0d3035c45459cb09c4d8b95b1d2900376`)
