# Faithfulness audit: LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `59939905a34b7b4188d3f16eec7f956c163d0e158ce46e1f5ee4ef7efb52c75a`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached source images and exact inline declarations resolves the disputed semantics. The native supplement identifies the integral by its construction and characterizing laws, rather than by its name or hashes. A singleton-partition argument resolves the boundary-applicability concern without additional geometric assumptions. All four target conjuncts follow from the selected normalized-integral construction, and a nonconstant physical example establishes nonvacuity. Both implications therefore hold under Q8, supporting faithful-equivalent rather than faithful-stronger. No tools, target proof, or independent hash recomputation were used.

## Implications

- **Lean implies source:** `yes`. Under the recorded coordinator-selected interpretation Q8, instantiate the measure with physical volume and the parameter space with the real scalar or vector ambient space of the material data. The first conjunct assigns each cell its normalized material integral, using the same region in the numerator and denominator. Different cell values are permitted, not required. Exact partition representation does not remove the selected cellwise capability: any measurable physical cell can be used unchanged as a singleton partition, after which the explicit averages assemble into a cell-indexed assignment. The theorem does not exclude other averaging rules or assert quantified numerical suitability.
- **Source implies lean:** `yes`. Under Q8, interpreted through ordinary normalized integration and its relevant admissibility conditions, take assigned(c) = ((μ(R(c))).toReal)⁻¹ • ∫ f d(μ.restrict R(c)). D003 then certifies every value. Any other certified assignment equals this expression at every cell, so function extensionality gives uniqueness. Pointwise equality on a measurable region implies restricted almost-everywhere equality, giving locality by integral_congr_ae. integral_const and restrict_apply_univ give the constant integral as real cell measure times the constant; positive finite volume permits reciprocal cancellation. The supplied native specifications justify these deductions for the target's complete real normed parameter spaces and arbitrary measures. These are consequences of Q8's construction, not laws explicitly printed in Section 1.4.

## Findings

- **note / interpretation-qualified-acceptance:** The accepted result must be reported as faithful under Q8, without attributing its formula, admissibility conditions, or operator identities to explicit printed assertions.
- **note / boundary-applicability:** Direct representation of an overlapping family differs from recovery of its cellwise averages. The latter preserves the selected assignment claim without assuming boundary measure zero or silently deleting boundary contributions.
- **note / relative-uniqueness:** The theorem establishes uniqueness for the selected prescription, not uniqueness of physically appropriate material models.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `unclear` |
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
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `70` dependencies (`0` hash-reused); unclear: `D047`.
- Direct judge covered `70` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The printed source alone does not determine the appropriate material-averaging formula or its analytic domain. Acceptance is exclusively under the recorded coordinator-selected interpretation Q8; it does not resolve that original source ambiguity or extend to other material-averaging prescriptions.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`8f50f0c89ef2287271edc7c5fc8b65c61e95469125476633655757bd26a65800`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`4bf8947bef1f8d663a6be4d258d514ff6266416eb94e43564ce04e0d27dced4f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`cdca549a8991aa6ebfa19d3377391cad70cf987d5edfff241ec1e8504787933b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`348c8a46cdc0bb9bdc173ac518d1926718218a9a9a8bd07ce59c62056561badc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`8d82c90b68ac374615fbb11806825ba5618d2643f85f911770fcb757564aa21f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`5ac1715d6848aeafe3806880a6b9533b6b7d2b901d9eb1256d5d2e2cb815e8bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/decision.json` (`9058d347b84d927ed757bfd5a2585948e764b2d7d2e9e92689b29e4d3b0cc5b3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`24c2e1a367c676db944ca9f46c5649867615e0e051cda87aed26d72d0001f288`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`05242e3d07a99a74f871ec59a1133d6d5e78150fa403cfa7812863e9503011f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`05242e3d07a99a74f871ec59a1133d6d5e78150fa403cfa7812863e9503011f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`d3534af2eb09965054a1d78e14201ae371009f86b8dcb10e8017e12153ae3224`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`4f69d50b1ed4fe82e7358e3acf7fc903976cb990962d1c719f26bd571286b49a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`4f701c844074b1107e8770320d294d1a8de74454dc5cddfdd8e071bc4f2e611e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`b42e2a2a729b7c97225c955f4b648662f05446a0c7ea8f6d114a8075e07bf791`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`12124e87e5545f6d84904dd6901417c4bce212ce6175af481a3472d7233d9fcf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`8f50f0c89ef2287271edc7c5fc8b65c61e95469125476633655757bd26a65800`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`673c595a69403ad7fb8abeb783172fd855bd190db8709ea0417af8ac5561f420`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`f76d3c74eb4421b5962625aa339202a81aa2572ed52538b253460cd1045968d2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`9de6060b55977c4f08e8e1953b3ecd07ec01c9bae698bf39ca53c962d8dc7fe1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`222cfebac31ecc0f9e67d8c466fed76036d0b69705fb5ff0122148f16887ea13`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`3820dc3940ee3b8eb82f856236fddb35607934a5fe03214fdd6080ca88ed1e89`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`2c30e71ff14af05ce551c13eb43015286256d4ff444e319924e5ebd3a83e14f1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`cdca549a8991aa6ebfa19d3377391cad70cf987d5edfff241ec1e8504787933b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`47f421ed4ca8ce37895279c90a7517aef67ea726a517fa7b12bdc480f3324597`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`b1ffcbaa374c96a0266df726667abe7cf15a70fe8aeb5513f1924aec67c3e52e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`737f721084abe9a735cd26ddae3a9417457e75b630e9ecd9cb937d7e96a7cdff`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`9cd0f59aef7bf160f6686e8e50bd604f9d5cd7cbb273c55fce991eb2b3e101e2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`2e64eb053d3459955e016c8a75530e0fa2a593eb901a5ccda05c3d9ceafb7f08`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`098728a7a9e7980a3ca33730ffc21deedfcbf68eb2b6c3d6f898ee6f547c1bee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`348c8a46cdc0bb9bdc173ac518d1926718218a9a9a8bd07ce59c62056561badc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`74ee6249d1960d49b12dbb3fbdbec1ae2a46d9240c4ea1f81c6d1aaf6e90f2f5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`23c057a5435ddbd63d911685613188eafbd89b8a61c760b0c5b384af067565d1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`9005f6d4f62d334002ad51c99dfca09bdbf7af0e8354b5de0b756e07ebbfde45`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`2b8e835e1f23f33b57aa7ccdccc0be27f87515f0cf41a4d3b5897a10c909f181`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/page-029.png` (`4761f39e0daa52023709eb5180beddc142e1e0aa54112fef39059d81caa737d8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/page-030.png` (`da658725af4b8a2b539d19ce5201c239a181999fd1cd4161e1cabb5a54c2288a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`e553435041b19b06e12c79c1d322767cbfab2ede7b8d8dee46f0b26b8fa5fc37`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`64fdc93eeb206265d22462541c3a06fb3aeb25de8efaeb05c43f87c6a2110459`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`f27c6b3b466506a8d7dc4a703618aa1fa81035a9d3eded01861b18745f3174f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`8d82c90b68ac374615fbb11806825ba5618d2643f85f911770fcb757564aa21f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`fbbb521ad80e0ef93db13a96cc61930a4cfe3de88ba1430ae8605270a45a6643`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`033c248e5fedc8be0ab6651cd7384b890356c14b52d9f1fa6c21c02d6e488aa4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`30c98a97470e70edae323a6c355919c128edc5fb6df0e22d73be5c9662ffafd9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`55324e10e70f0268a1b568c8386348ed8fafda72ae47ca607e131fc2a78b3669`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`81c30eafba1ba7202cbe1ea20355dd86066724574bc17dcc3f0895bd4a75cb33`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`5ac1715d6848aeafe3806880a6b9533b6b7d2b901d9eb1256d5d2e2cb815e8bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`17b5f336203bee0cd33c6b81a9b10cb97086ce1fd1c7d019f5724c9912e885a8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`ed5ff19cb5f94750e09b68ac5e7a4f75cac38639d5492e43689cce874d7e8530`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`f8d6cb47d23a0eeecf11e9532ae2c97d1bf0468fde05aede825d15b937d0d717`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-MATERIAL-AVG-OPERATORS-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`de89cd65d3c54c2d81df580be31b50cb244413d7eb07c34d418ba5b1d1fedf0c`)
