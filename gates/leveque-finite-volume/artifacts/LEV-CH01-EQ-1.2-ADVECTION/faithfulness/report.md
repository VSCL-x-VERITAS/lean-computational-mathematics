# Faithfulness audit: LEV-CH01-EQ-1.2-ADVECTION

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `f507a3cd5fc9be930e0f5e6c2b5ec2b28416b6c2b7cf575e6f6d2d37feaf5e89`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

A governing PDE is appropriately formalized as a predicate on candidate fields, and equality of two such equations is equality of those predicates. The theorem therefore should not assert that an unconstrained arbitrary q solves advection; doing so would be false and is not what the scalar-specialization claim means. The round-trip judge's observation that both predicates can be false for a nondifferentiable field is not a weakening: such a field is correctly rejected as a solution by both representations. The source's contaminant language supplies the physical instantiation and name of the equation, while the locator also explicitly selects the generic scalar-specialization paragraph that the Lean declaration proves. The existing declaration closes the selected claim without a remedy.

## Implications

- **Lean implies source:** `yes`. As an identity of governing equations, the Lean equivalence recovers the selected scalar m = 1 specialization: the one-component system with A = [speed] and the scalar advection residual have exactly the same candidate solutions, with the same signed real coefficient and plus sign. Instantiating q and speed with the contaminant density and constant fluid velocity gives equation (1.2).
- **Source implies lean:** `yes`. The source's generic scalar-specialization paragraph, together with equation (1.1), identifies A with a real scalar when m = 1. Under the Fin 1 embedding and A = [speed], its vector residual reduces componentwise to q_t + speed*q_x = 0, yielding the stated predicate equivalence.

## Findings

No findings were recorded.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `fail` |
| `C04` | `pass` | `fail` |
| `C05` | `pass` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `fail` |
| `C08` | `pass` | `fail` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `fail` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `not-applicable` |

## Dependency coverage

- Blind translator covered `107` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `107` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/adjudicator.json` (`18a93c25b0ca2377052d594188314f4d4f7105bdf37a9b186c1743e46fe48d69`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/agent_runs.json` (`6722bbba1919dacefb6e9393c84727450c659e2eb1fa3d7fec20ede74302677a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/blind_translation.json` (`ffff18a8e4a1dcbe8ba6d308226887bea28abe9b5ef97acf201b1498ad3eee0e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/direct_judge.json` (`baf5e151f964d3996f7b26ae748e488a086144e016beb60445345c33a8c9b7ee`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/roundtrip_judge.json` (`d9a15f559c17caa187e975d99119e2105caf9a8fff61ba29fa6de98161f68f66`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/source_contract.json` (`afcea26a0b84d85178ccdf457b87773c4781e4cbb37af13a143e055d3f79aa5c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/decision.json` (`3215cd4d7527df91215cbfa7e58bc7ab9d5fa8a32ce072a286599324bd52f465`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/blind_dependency_inventory.json` (`4dcad9da39b21557e600bb76fa16b280f0b45974351a16c7d6eff03e47698a71`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/blind_dossier.md` (`a40e26154329f781bf7041b1f5be6f6649ee0acfc07f5f6c9471a915668494be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/blind_review_packet.md` (`a40e26154329f781bf7041b1f5be6f6649ee0acfc07f5f6c9471a915668494be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/declaration_dossier.md` (`19f523700d8fcf4235fe91fa74fbd595c016331a9aa7ca5a241c8f92ee76f756`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/dependency_inventory.json` (`eff2cfebba5966e850b00428df27817202c371336fb87011782efa52a08ba3bc`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/direct_review_packet.md` (`fb3828a7fb2e24a4ff08fbc9d23d0cd95ef972e25fc987c16d5810690a8c636a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/source_locator.json` (`eb183d6cc0be045e400cc0c261551473005ec52806ca6d71bea06ddc3669d56d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/agent_outputs/adjudicator.json` (`bcb4fa7d98e5e6a55ce02264a21fc8ef3e026e7b2ff895c016401a8daa54894a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/agent_outputs/agent_runs.json` (`9647c48a0d507331454a0ff2320fc1c5a88ccd29046f542bfacfe69bb3e82888`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/agent_outputs/batch_source_contract.json` (`9532e1ca38b7e4d49830680a12d77b102ed0b6459d6dfdc28d7225f1a53ebdae`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/agent_outputs/blind_translation.json` (`a17541a176f68fb1b749f20458413929900825cf8f94c13f4f5d8a4daf162f0e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/agent_outputs/direct_judge.json` (`71b928ecf0aaeb71335ff3cc1d5ac37672113707383783a01a8e14a4749a5d89`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/agent_outputs/roundtrip_judge.json` (`676dbda54f5ff9a64c8f3550622c4c35b96cb77c86ad9ccd35f18fcd1b82813b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/agent_outputs/source_contract.json` (`250a1311b9e463d512cb8379563bb9abb240dcce22d347fc4026b98b9bf9ea8d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/decision.json` (`6692bd650eb89303d60109975fb21d3d1c560fcd2bafeade613661792fd92945`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/inputs/batch_source_locator.json` (`67dbac17174068b7f3300cb6dcf007101ac0733c40cf72a06ef3274f46edfbce`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/inputs/blind_dependency_inventory.json` (`4dcad9da39b21557e600bb76fa16b280f0b45974351a16c7d6eff03e47698a71`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/inputs/blind_dossier.md` (`a40e26154329f781bf7041b1f5be6f6649ee0acfc07f5f6c9471a915668494be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/inputs/blind_review_packet.md` (`a40e26154329f781bf7041b1f5be6f6649ee0acfc07f5f6c9471a915668494be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/inputs/declaration_dossier.md` (`3d701f4ad97a2d3c4bb2f7ad9a9d4046da0e886957f144463004215f3954e9ad`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/inputs/dependency_inventory.json` (`eff2cfebba5966e850b00428df27817202c371336fb87011782efa52a08ba3bc`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/inputs/direct_review_packet.md` (`fb3828a7fb2e24a4ff08fbc9d23d0cd95ef972e25fc987c16d5810690a8c636a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T042259Z/inputs/source_locator.json` (`eb183d6cc0be045e400cc0c261551473005ec52806ca6d71bea06ddc3669d56d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/blind_dependency_inventory.json` (`4dcad9da39b21557e600bb76fa16b280f0b45974351a16c7d6eff03e47698a71`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/blind_dossier.md` (`a40e26154329f781bf7041b1f5be6f6649ee0acfc07f5f6c9471a915668494be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/blind_review_packet.md` (`a40e26154329f781bf7041b1f5be6f6649ee0acfc07f5f6c9471a915668494be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/declaration_dossier.md` (`235e0039d234635aa04637fa96b4de5e336be3ac23015c8959e6786895b9b7d3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/dependency_inventory.json` (`eff2cfebba5966e850b00428df27817202c371336fb87011782efa52a08ba3bc`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/direct_review_packet.md` (`fb3828a7fb2e24a4ff08fbc9d23d0cd95ef972e25fc987c16d5810690a8c636a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/source_locator.json` (`eb183d6cc0be045e400cc0c261551473005ec52806ca6d71bea06ddc3669d56d`)
