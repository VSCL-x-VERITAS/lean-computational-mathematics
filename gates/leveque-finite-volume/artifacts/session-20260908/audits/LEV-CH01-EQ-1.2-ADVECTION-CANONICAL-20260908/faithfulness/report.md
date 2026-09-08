# Faithfulness audit: LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `527d3ae83f64be33bac12cfe093effa4b7ebb33ad0aea81cffc19525be3fa7cd`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

I independently inspected the attached primary-source page and the supplied proof-free declarations, dependency inventory, reuse records, blind dossier and translation, and both judgments. The decisive distinction is between identifying two equation predicates and asserting equation satisfaction in the source's modeling setting. Singleton projection and embedding establish both directions of the internal equivalence, including derivative existence, while leaving the physical and hyperbolicity assertions absent. The regularity ambiguity is preserved without treating it as a counterexample to that equivalence. The no/yes implication pair consistently yields not-faithful-weaker. No tools were used, no files were written, and no source or rendering hashes were independently recomputed.

## Implications

- **Lean implies source:** `no`. The target establishes equivalence of two classical pointwise predicates after singleton identification. It provides neither a premise connecting q to physical transport nor a conclusion that the transported concentration satisfies either predicate, and it contains no hyperbolicity assertion. Universal quantification over points does not turn predicate equivalence into global satisfaction. The field q(x,t)=t illustrates this logical distinction, rather than serving as a counterexample to the physical model. The complete selected source assertion is therefore not represented by the Lean proposition.
- **Source implies lean:** `yes`. The selected source's explicit scalar specialization, together with ordinary real calculus and the supplied definitions, supports the target's representation claim. Evaluating vector derivative witnesses at the sole Fin 1 coordinate yields scalar derivative witnesses and the equality qt+speed*qx=0. Conversely, embedding scalar witnesses as singleton vectors preserves the slice derivatives and gives the matrix balance. These transformations work without assuming that either predicate holds beforehand, so the equivalence applies to arbitrary q, including nondifferentiable cases where both predicates are false. The source's unspecified broader solution concept does not require every source solution to satisfy these classical predicates, because the target asserts only their equivalence.

## Findings

- **major / modeling-assertion-omitted:** The target cannot recover the selected connection between physical transport and satisfaction of the PDE.
- **major / hyperbolicity-conclusion-omitted:** The target omits a conclusion of the selected passage; typing the coefficient as Real does not itself express that conclusion.
- **note / correct-nonvacuous-classical-specialization:** The rejection concerns incomplete representation of the selected source claim, not an incorrect operator, empty domain, or unsupported stronger smoothness requirement.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `fail` | `fail` |
| `C04` | `fail` | `unclear` |
| `C05` | `fail` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `fail` | `fail` |
| `C08` | `fail` | `fail` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `fail` |
| `N01` | `fail` | `fail` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `107` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `107` dependencies (`67` hash-reused); failing or unclear: `D009`.

## Remaining uncertainties

- The selected primary-source page does not specify whether its intended solutions are exclusively classical or also include nonsmooth solutions through another formulation. In particular, it does not settle the solution-status interpretation of nonsmooth stationary profiles at zero velocity. This uncertainty does not change either implication verdict for the representation theorem actually stated.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`df0b2ff371e77adfcd30a434afb8abeb5c2892bc6774009e243dbd644bff0ec2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`785bfcd6e625b05838b28b03cc06000f532c3c53230717b1eae7dfd57fca0146`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`b0f82a7b656343380e7506a76c2f94f733d0b61f5ad3192f0d9e1a30f8fb1779`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`216a52ff0b17ebd8e2068e8469921216d6e6496b71af7b2756f74aee223d16e9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`a2ffca16413d7a539805bc10a82a2da09c8660cd396e941ee4cd2f5b0e72c9aa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`b525cbf6d8aa7478ec8bde0fd26155809f12744e27c4addb7abe2a98e38a5c20`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/decision.json` (`6072faa49270450621c181e13cb3f19aa6eb589c1b5ae950a28c203bd799b2b9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`949ff7e41ba598ae4f23cef654ec9dbbd2cedb2a902ce3cfb461c78355701f34`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`11d07619ae28a7da0cee8f8bb9e50336866d7604f4a25521a071b055f7d65946`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`11d07619ae28a7da0cee8f8bb9e50336866d7604f4a25521a071b055f7d65946`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`e555f8a6fc0bef10a7b42336f4eae4488aecb31e5a66a2af21048d6f821e0817`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`4f699ad2b508dd5a2910cc56280d3f07c6f676807c8cc49ebee8b141239032bc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`4c7a6186ce9af96014494f5a74a21cff9d379a753545f1d12d10cf683447f46c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`e4a7fe9365bff705b565de3790002d8c500a95660807289d87048ef44547b4ce`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`c9f435646d5c9d97009bbd2c918d0cee87604cc731063d3f76177ab372fdb5c4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`cce54f0d3e361857f47f477bca2583b0e39b1b4c12fed78639d5bc7ce7d605f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`df0b2ff371e77adfcd30a434afb8abeb5c2892bc6774009e243dbd644bff0ec2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`b7608093577f934db1478e56ca3d3e00da71b4c9d14ce77b37a02c74fd9c51d6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`d35a1b888a9cd8efc73f7e81c09999d362009e02499a8a30db3708b12ffdd1e3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`cadb06790d0fe57c87a522342365d1f8d0062155fa5c25a7b0fd67e3ae8560ea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`440a21b06a61ea70536705013cad66fb985c17698b951bebddc536d02f7f936f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`bb4c9df7069c1076566f9b85161ed4b6fa9d4324f076895f704e7e5d72a756c3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`096f2aa19010d7ad1157d47128c0f6d236bd98386bd4f7817a8cee7f6455fa9f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`b0f82a7b656343380e7506a76c2f94f733d0b61f5ad3192f0d9e1a30f8fb1779`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`ec1650be0a9fb668cd95355b1a502b3be7b9df0a8d37f01d97d899495e9951d7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`05a4bfbceec6e70d33f97645e1e5c74d1e21647714a43a824cf32154805e4908`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`6158ba661830f42256422897b19124a3bdab244c8ea3726f461c5806ae113cc2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`1a68bb5ede14f75f1512f05912ee4006966d8bebaf86b753e1d4d37cde56b124`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/blind_reuse_limitation_20260908.json` (`51a4a122f4d7b55552fb8cbc4650ac6eb7a550dc5d3deb8aa8a8e703aa37ace4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/c.py` (`351ac0fe3d6f169562f7975e7979cac2754bf3c38c4f51af78c781e94cf0ded8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`7b62f5cf10845a68f56371c44767a56fb4f99f0d3c086efcddbbaa7bc544fa7c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`216a52ff0b17ebd8e2068e8469921216d6e6496b71af7b2756f74aee223d16e9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`d85039bbea9f9a448d75d15dc9e25f01bd2c9c6f0ac86594a5d9e01b8b4bf5ab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`91428dbf223fd5d7b22499390a98d9997027808bafa080adb5570fc587afee34`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`a64176d0aa1e913f15165a5c8495e4795de04f9d09faf9e009e665d4cfb329f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`1857a5640f937a81bf3feabc0831a67bd97612fb10309bb0aea4334c505346d6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/q.py` (`c919c4d7cba201a8213e345c211e7a611b935c09f98e9d8b4a1c0b16c7bdd2ec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/r.py` (`b642e41886970764c08c2d50bf181f47ce1eab5706a18a15ce2a905137e110f6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`8fee0ad06ec8bf7389eac4b14847a6ed0b78b2e748eef38d6c89b9a30765f1fc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`a2ffca16413d7a539805bc10a82a2da09c8660cd396e941ee4cd2f5b0e72c9aa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`7abb7acbb99cacb3fde64b06a7e4955fb944be5744a93ad5c59d69c4892189cf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`25323981f23c05bbe55dcf3fe02cd94ab3b13376523130e158ef0c54b28955b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`4695b56ff0cea1af1643204705fa6ad14d7f53cbf81ebc324904bb9ce493209e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`fc087cb13857d076496a4e2ca940aba9565fa9503327456f24144411b9e4ce07`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`556f500406d7b63092d2016f27cf1c1461fef30e628cb550c7f1cb58936f5f72`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`b525cbf6d8aa7478ec8bde0fd26155809f12744e27c4addb7abe2a98e38a5c20`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`bd87771f8718377f9c17aedcb8f70cba7a7b1ab19155ff55e1f60d384fef5ed4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`dbf4bcea16a0db8812f1962bc2784d78e8ac8b3dbd5625975f2a69f043df20d6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`2f90d8dcc8f557f787b4796b82a3bbf88f9ae7036d28952c068ce7b7f8f36e39`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`7b82d96ba414a50c0666152a422e7b9326e37dca3973e0fc29450009f923f884`)
