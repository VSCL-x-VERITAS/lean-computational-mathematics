# Faithfulness audit: LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `353e101df40a1692beb8d09afd4d77bd9b0d86f661a114317ec46f59c2cacf20`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source renderings and the supplied declaration evidence establishes an exact match for equation (1.11), but an omission from the surrounding definition: the governing equation must be hyperbolic. All twelve dependencies have been reassessed for their current effects; none restores that qualification. The reverse implication follows by explicitly interpreting the predicate as satisfaction of a source governing equation, without choosing an unsupported solution theory or claiming existence. The equal-state ambiguity remains unresolved but does not affect either implication. This is a weaker representation, not genuine stronger content or reduced applicability disguised as strength. Source and rendering hashes are supplied provenance and were not independently recomputed.

## Implications

- **Lean implies source:** `no`. As a representation of the full selected definition, the formal property does not establish that its supplied governing object is a hyperbolic equation. D001–D003 allow an arbitrary predicate, including the always-true predicate with a nonconstant two-state initial trace. Such an instance supplies no identification or certification of the governing hyperbolic equation required by Section 1.2.1. The fact that one might separately find a hyperbolic equation compatible with a particular field does not establish that the supplied predicate represents that equation. Exact recovery of (1.11) therefore does not recover the complete source definition.
- **Source implies lean:** `yes`. Interpret State as the source state space and evolutionEquation as satisfaction of the source instance's governing equation. A candidate satisfying the source equation and initial data satisfies evolutionEquation q and both universally quantified branches of D003, hence D002 and D001. This is a direct forgetting of the equation's hyperbolic qualification, not an assertion of solution existence. It remains valid whether the source permits or excludes equal states. The universally quantified unfolding theorem is independently definitionally valid; its validity is not being used to invent missing source semantics.

## Findings

- **major / missing-hyperbolic-equation-semantics:** The declaration faithfully unfolds a generic equation-predicate and initial-data constructor, but does not faithfully characterize the full selected Riemann-problem definition.
- **note / degenerate-state-ambiguity:** Full agreement on this boundary case remains uncertain. Either interpretation leaves the adjudicated implication directions and rejection unchanged.
- **note / preserved-initial-data-and-solution-roles:** The initial-data component and constraint-based presentation are supported. These correct components do not supply the missing governing-equation qualification.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `fail` | `fail` |
| `C03` | `pass` | `pass` |
| `C04` | `fail` | `fail` |
| `C05` | `fail` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `fail` |
| `C09` | `pass` | `pass` |
| `C10` | `fail` | `fail` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `12` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `12` dependencies (`7` hash-reused); failing or unclear: `D001, D002, D003`.

## Remaining uncertainties

- The supplied source passage does not conclusively determine whether equal left and right states count as a degenerate Riemann problem: the prose describes a jump discontinuity, while equation (1.11) supplies no explicit distinctness condition.
- The selected definition does not choose a precise solution framework or time interval. The formal constructor leaves those choices to its predicate; no particular choice is established by this audit.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`a854da9abcc31b628ace607ed97ffec152897b6a244afd7e3111082ad77e24cb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`2978086193de06ced044e9805652303bea069d4e9f86e75725375e8a30235c33`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`197f89af0ffb46b921e5ff15b282ae773eaf1fa738a8731ccc21bd2e7c3b6d76`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`e6b40aee83d746c31f977163302b0e08516384d6a483d7b8dd2de3996f942dea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`23c4ee6e3be4975352281c7ac92a047de177761fb44c11f1732619e8bca780ba`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`158b87d154fb5af506915b4011d1e1f4fde1ff533cef7d620394bbe99ffe5a83`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/decision.json` (`5bcb31b0d05629a35f39086f22f044187188ad043dd38ebebdc8518b6987b825`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`0c544a2de1da44f5d82093f5e4040976d8bbfa04ffbf96b0744c349fe3de42cb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`87068e941c690b7bededb8f138ee01721838cbdf4bdb464cc84805fc2b2e4fa2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`87068e941c690b7bededb8f138ee01721838cbdf4bdb464cc84805fc2b2e4fa2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`703223d50a2deef26a992081da6ff2b1e82fc4168a849c188ae4e88b8411a2fe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`ec5a8939cbc7df78109b871e4c90994f13eb48c25cec0a6ce356766fbb67cffc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`af6d37f59b1e6845796d80e7215a310f65652ce2f1a146176493206dee2d404d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`273234c821a5b7c2f4f9c66fa44ee6823431e5f1915476b4fe144b6d2244c81a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`64954fb6f4d05ca4b2797a226aa969bb78912c69e9e15935b5344f1664e9c5a9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`73b13ba01e20a48fdf857dbd669aeb765ed0a195e2cdbf26233f4cc2bfe9872b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`a854da9abcc31b628ace607ed97ffec152897b6a244afd7e3111082ad77e24cb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`ed2f15af5f54166bc4b074187537858f795a7f3a6af9b0ed72eb198c860c0850`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`80a33f2d0e9c535effb1f6ac845a7e53a74e046f9eeac20eedfb89beb424538d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`cfefb5bfd3b7cd175b052bca62a3fbec63d2b4c1897df1ba65851bbb12194681`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`01bca88f1e78db8ff044bb1a05eeaff1a4090a7edc44898b99c115de5bcf73c6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`7468ac90e0d6fc67bd3a2f9b7641c0310a7b262479c7033f2b0ce87733ba0255`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`f7d3f98334aac48d935ea722de080c1a265a850f733295dfb808b49d6e87b937`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`9a722ea087bc522c4bf3d37c0ff2978a3f24dbf8838e940f6bed070de9ec4862`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`197f89af0ffb46b921e5ff15b282ae773eaf1fa738a8731ccc21bd2e7c3b6d76`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`93ca0a15f1b930209946baf9afc3c8cf082e243a6d79e272a03cc659da035c76`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`480284b9c36d5f47c6ba913f001d62b1dd15e1e630c5dec2db308d324cc31b6a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`ccaeba2d9d90c00faa754bc6dc7dc5f5dc2a312e106e810d50acb427cda47b90`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`91b1404434fcbfe449929eff3d3ec8d604d2978fc9bd3301e4cdd26b2ea257ea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`0117791e73a82024404d6e068413fa89e2a86eea26cfb823e0cda5df82e3ee7b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`e6b40aee83d746c31f977163302b0e08516384d6a483d7b8dd2de3996f942dea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`677bb55a394f280830aa9979e52b0a177ec0695ef0c6777b70806481de46d169`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`74fbb04a5c30882de9c7a07553527deba547975f74031c473aed457e86d37bb5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`35b6997b57e95d5c63352e71d3d25c539fa644a1eb77f3d984aace2a0556da34`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`388cf8cc95a26f5d8c63982237bc4da38b47aee07e84b6a1a02a3c1f9b508e29`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`11799bb0b4ccee8078a1a7dcfb1e07100462908a2a242a2d39646f7f8c5a7b62`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`c305f759d24b140fb24873b669f2f22ef7eb3d2b81666ff10df036118f45197f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/page-028.png` (`ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`8b67bb15849df1cd1bae3c92757b1efc24195760a8cf359d4f594f65a7b1f21d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`5f5f1d07599f8f1119db19227006272eda8b38fec4ccefb8f3046364eeaaa9d4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`23c4ee6e3be4975352281c7ac92a047de177761fb44c11f1732619e8bca780ba`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`07ce19d1bf09dbff0519e27e6e42b6980e353731d12b624b42bc23f57bc57255`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`24da6ebbd62c56f9e05badeff19c715043d847279b3d160ee2164e8a942a6b3f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`111a3a08cc23602680b2ca7ba6a3cba080a6076a732b9659a8f9c6e60ff8d90e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`6f01c7d0d30892bba1a11db6f8e076484f0559b48c9b66fb75c83837709ef76d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`5164d0ed8e3068742b143c26f710ecfdedde97c6469db8cfa2bf2d0a23d05c94`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`158b87d154fb5af506915b4011d1e1f4fde1ff533cef7d620394bbe99ffe5a83`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`d103aef130fba4a90be0ac30c0910c9487afc77b1b02f7b1086f78d078711c9f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`3d5c2c65e8b5125d263c0fa0590850460dd7ad6b15fb4d694c8d8869d8414c20`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`c979bbdde71cb9f17f70d00ced3deed5820d99aba6af3c06d710793584594e15`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`3a3765a78bdf3791e798aa9ae3d1e323eae14aaf903846c5002828043a918bbd`)
