# Faithfulness audit: LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `3d6a605a9fbd08858eef745ec857cbd32c3c1ac11d50756f60fdbe4875ea1052`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source images support the definitional transfer of the complete real eigenvector criterion from A to f′(q). Inspection of the supplied proof-free types, dependency bodies, reuse records, blind translation, and both judgments resolves the disagreement through that source meaning rather than majority vote or declaration names. The target preserves operator identity, real spectral completeness, state-dependent witnesses, ordinary local differentiability, repeated eigenvalues, and positive-dimensional applicability. Both implication directions hold for the selected criterion. No tools were used, and supplied source or dossier hashes were not independently recomputed.

## Implications

- **Lean implies source:** `yes`. In the source's one-dimensional homogeneous conservation-law setting, instantiate state with the value q and derivative with f′(q). The source's real independent eigenpairs satisfy the target's right side. Its right-to-left direction gives D001, whose inspected body classifies the actual Jacobian by the complete real eigenbasis condition D004. This is precisely the selected hyperbolicity criterion. The theorem does not assert global hyperbolicity from a single state; its characterization can be applied at each state of any domain on which the ambient derivative exists.
- **Source implies lean:** `yes`. The source's inherited definition identifies hyperbolicity with the complete real eigenvector condition, then transfers it to the flux Jacobian. Under the target's actual derivative hypothesis, uniqueness identifies the derivative existentially bound in D001 with the supplied derivative. D056 and D068 preserve its action in matrix coordinates. A real eigenbasis supplies m independent eigenvectors, and m independent vectors in R^m form a real basis. These conversions establish the biconditional without adding an independent analytic converse, eigenvalue distinctness, or a solution theorem.

## Findings

- **note / scope-of-acceptance:** Acceptance covers the spectral criterion. It does not certify the adjacent chain-rule rewriting, PDE well-posedness, or an assertion that a particular flux is hyperbolic throughout a domain.
- **note / domain-and-empty-dimension-conventions:** Open-domain interior criteria retain their meaning through arbitrary extension outside the domain. Boundary-relative differentiation is outside this claim. The empty-basis case is harmless and is not substantive additional strength.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `unclear` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `82` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `82` dependencies (`39` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`73fa85d80fdb02b63ee5bdc69084b94822a298630f7faa3030d1fc89716b5962`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`e70119cef4c50683becd10c545cc3b183219794790ab2e2628ef4b8c4ce52281`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`4cf92361314c519236d1c4bcf703312ea49ccf78a6d0e0f6e79297c4140d967b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`ae48bc53ea67c25501bed82fca3878a962b84494639ced25ca6cbfaeea847ce4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`a20ca65b5430ad7cfb7e0cbe9fefc754a0124977d216e9773b1b5911398e8151`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`482b4fd783fceb339b114301986aea6ba9d04eb875264c06c24f39e66e0023d6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/decision.json` (`09e4fe080c26f82b13d6b8f87d65ec3b525617c89d67a57a9a9eb37c16702359`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`989f86285a6845c9b170a77af7fae7e51295685271c3e1f27144458be4a766a7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`889bcce00d5097c614ab7328dbc67da347eb278028a1550966eb63dc11960652`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`889bcce00d5097c614ab7328dbc67da347eb278028a1550966eb63dc11960652`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`f771e719931829d912396837e18e60e676332362ebff36f3d88f4710721cc333`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`9fa74673fc0568cff52149c705b2975411b671b1d202e03ffa0d2cd4249e5bda`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`0f477b932bf05463d35e3bdf359ca10e6e0d5bca55ec070954a305bac407db50`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`af3cfc3b6580d9e88ba99bcbb67f0cf40d85538e228cb7f738ddf25b07531b4e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`26e924bc26ef65784364bfd4bd7e24b4e56bb324256cdc88ef3a0c470fd3cd8c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`358766465e0359a51187656dcc3d2c1c47f0b8ac53260a9a023a747f6f0990f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`73fa85d80fdb02b63ee5bdc69084b94822a298630f7faa3030d1fc89716b5962`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`ea6c040b83596b868ced9b28d19db5a7b9c3b35bcb3a6451d6b863e3c15076ee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`3c4a0bf40fc26110250b9861956f538f20e3da0d3a58c2074f8db2a648d9364e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`f069c5608f071f955262d2ef1bd6e08b3c1ae52411e45d8c492826288f3901e3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`bd3a5d1642b2b19b6adea650eae55785009052617f1f1b7b820b681ce72ecbc9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`dc98908f89a74c82975a62aa02d777647486880757aa4b53242e3cd2130fbe97`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`b7d492854a83e99069253378ae6970ea9ddc4ab58c60937dbae6767c44137d57`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`1319ad142a095977fc4ec30b696cf3f36c3da83e1952f835d9e95582ecf64123`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`4cf92361314c519236d1c4bcf703312ea49ccf78a6d0e0f6e79297c4140d967b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`50af055bdf5541c04817596f162f162fba960a48ee157c647178783836f8750d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`19662511a7521fd8ff06f08ae4cefc7e60fe459b648a4fadbf38626fe9af084a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`4cd8fc3e74fb7b9fc03ce6f78d8f2ca8ae82a43fac46d6c8cdded1b6c999301e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`a78da15d255752c58532693a5dbb9dd4cececc5b292a5eb1e1eb394a4f51526d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`f43a790d2fd8c4c4b6dafb0e3165c8ac2156cf0f4fa145979810cb552dcf8983`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`ae48bc53ea67c25501bed82fca3878a962b84494639ced25ca6cbfaeea847ce4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`3d56feab9177afe7c1168c5c61bd676b00b3a2c359428b6a8ececf3a0d4b7eaa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`7451056eeef3bb398150fc08839cd7723a0851e9badfdb71ba70e086758ea7ba`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`b7c877f01ffb65a5ee48f357e8dea07ddee9d863d5ddecc0dea488c16c5d2968`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`fb7621fff9c899c8f049f8b62d30d074d1efe99b3fff2687e993b491c3e60d9b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`a40cf76590e956809b5d52c55f9634f0480a42756ca93a80566ecbcb47895509`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`56487f727a4a684f191709bf5dd2988b73332eb553854523e4703dd61dc47f81`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`f8bd96911b16d4b6d3b6d0bd491a9b42e30c4e23936f1acf7ffe2372aa2dbaf6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`f60906090230b075d85b6754bdf7173ec271ad95e6b002abd75e6a5a677d29a4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`a20ca65b5430ad7cfb7e0cbe9fefc754a0124977d216e9773b1b5911398e8151`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`3a6918a545aeca28976f4b5c6943f58ff7936107ab6eb8369bae4d1857671bfc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`6ca88b4be89bdb8fa3af4dd9db9406a7102770360183db60df090bc35258f25f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`064439caa8d4193675d72b8ed39d907b56e318fc4a6e27929c6237e53e500107`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`b3d13963556b102a429bdad3860c5246c53876363eaa66301e1bdb6968ce457a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`6d8d76d04bea924eb07db3f40ad6829144ab50505dfea442f248baf3c87f3355`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`482b4fd783fceb339b114301986aea6ba9d04eb875264c06c24f39e66e0023d6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`c62d5a4c498a8be9ef13efe95e8dfd0e6b21128f9dc75e949d67d94db0254e68`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`3a7a7ad1f92679c80bf5d611c2d44da2a5d14bd6d9f810a52edb87d69e4a192b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`427e68069356fa2cd476b7a6ff444a85c126eb62e22b312189b34bf2432bde20`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FLUX-JACOBIAN-HYPERBOLICITY-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`a35fc8b392b28f8b332f1cd9894cae0a4635891e7d774ed6a31659e4982c926a`)
