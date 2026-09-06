# Faithfulness audit: LEV-CH01-EQ-1.2-ADVECTION

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `f507a3cd5fc9be930e0f5e6c2b5ec2b28416b6c2b7cf575e6f6d2d37feaf5e89`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The authoritative page contains a scalar-specialization claim and then a physical example. Mathematically, the selected relationship is that setting m = 1 in equation (1.1), identifying the one component with q, and replacing the 1-by-1 constant matrix by the real scalar velocity yields equation (1.2). The exact Lean proposition states precisely that the corresponding pointwise solution predicates are equivalent. Its universal q binder does not say that every real function solves advection; it says that, for every candidate field, the one-component system condition and scalar condition agree. That distinction defeats the round-trip judge's vacuity objection. The concentration/density wording is illustrative source context rather than an unstated mathematical premise. Both implication directions therefore hold, the result is nonvacuous, and the classification is faithful-equivalent.

## Implications

- **Lean implies source:** `yes`. Expanding the authorized declarations, the left predicate is equation (1.1) for the singleton field i |-> q(x,t) and the 1-by-1 matrix with entry speed. Its unique residual component is exactly q_t(x,t) + speed*q_x(x,t) = 0, which is the right scalar-advection predicate and equation (1.2). Thus the Lean iff directly entails the selected claim that equation (1.2) is the m = 1 scalar form of equation (1.1). It is not required to assert that every q is a solution, because neither the source scalar-specialization claim nor an equation specification has that scope.
- **Source implies lean:** `yes`. The source says that in the scalar case m = 1 the matrix A reduces to a scalar and displays the resulting scalar equation. Under the standard singleton encoding supplied by D001, D004, and Matrix.mulVec in D043, scalar derivative witnesses lift to unique Fin 1 derivative vectors and vector witnesses project back to scalars. Hence the one-component equation-(1.1) predicate and the equation-(1.2) predicate hold in exactly the same cases, giving both directions of the target iff.

## Findings

- **note / physical-context-is-illustrative:** Omitting a physical-role predicate, nonnegativity, units, or normalization is not a faithfulness defect for this selected scalar-specialization proposition.
- **note / iff-nonvacuity:** The iff is an extensional equality of the system and scalar PDE conditions, not an unintended truth caused by impossible premises or an empty domain.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `fail` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `fail` |
| `C04` | `pass` | `fail` |
| `C05` | `pass` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `fail` |
| `C08` | `pass` | `fail` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `fail` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `fail` |
| `N01` | `not-applicable` | `fail` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `not-applicable` | `fail` |

## Dependency coverage

- Blind translator covered `107` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `107` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/adjudicator.json` (`bcb4fa7d98e5e6a55ce02264a21fc8ef3e026e7b2ff895c016401a8daa54894a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/agent_runs.json` (`9647c48a0d507331454a0ff2320fc1c5a88ccd29046f542bfacfe69bb3e82888`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/batch_source_contract.json` (`9532e1ca38b7e4d49830680a12d77b102ed0b6459d6dfdc28d7225f1a53ebdae`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/blind_translation.json` (`a17541a176f68fb1b749f20458413929900825cf8f94c13f4f5d8a4daf162f0e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/direct_judge.json` (`71b928ecf0aaeb71335ff3cc1d5ac37672113707383783a01a8e14a4749a5d89`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/roundtrip_judge.json` (`676dbda54f5ff9a64c8f3550622c4c35b96cb77c86ad9ccd35f18fcd1b82813b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/agent_outputs/source_contract.json` (`250a1311b9e463d512cb8379563bb9abb240dcce22d347fc4026b98b9bf9ea8d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/decision.json` (`6692bd650eb89303d60109975fb21d3d1c560fcd2bafeade613661792fd92945`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/blind_dependency_inventory.json` (`4dcad9da39b21557e600bb76fa16b280f0b45974351a16c7d6eff03e47698a71`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/blind_dossier.md` (`a40e26154329f781bf7041b1f5be6f6649ee0acfc07f5f6c9471a915668494be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/blind_review_packet.md` (`a40e26154329f781bf7041b1f5be6f6649ee0acfc07f5f6c9471a915668494be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/declaration_dossier.md` (`19f523700d8fcf4235fe91fa74fbd595c016331a9aa7ca5a241c8f92ee76f756`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/dependency_inventory.json` (`eff2cfebba5966e850b00428df27817202c371336fb87011782efa52a08ba3bc`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/direct_review_packet.md` (`fb3828a7fb2e24a4ff08fbc9d23d0cd95ef972e25fc987c16d5810690a8c636a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/history/20260901T012155Z/inputs/source_locator.json` (`eb183d6cc0be045e400cc0c261551473005ec52806ca6d71bea06ddc3669d56d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/batch_source_locator.json` (`67dbac17174068b7f3300cb6dcf007101ac0733c40cf72a06ef3274f46edfbce`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/blind_dependency_inventory.json` (`4dcad9da39b21557e600bb76fa16b280f0b45974351a16c7d6eff03e47698a71`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/blind_dossier.md` (`a40e26154329f781bf7041b1f5be6f6649ee0acfc07f5f6c9471a915668494be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/blind_review_packet.md` (`a40e26154329f781bf7041b1f5be6f6649ee0acfc07f5f6c9471a915668494be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/declaration_dossier.md` (`3d701f4ad97a2d3c4bb2f7ad9a9d4046da0e886957f144463004215f3954e9ad`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/dependency_inventory.json` (`eff2cfebba5966e850b00428df27817202c371336fb87011782efa52a08ba3bc`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/direct_review_packet.md` (`fb3828a7fb2e24a4ff08fbc9d23d0cd95ef972e25fc987c16d5810690a8c636a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.2-ADVECTION/faithfulness/inputs/source_locator.json` (`eb183d6cc0be045e400cc0c261551473005ec52806ca6d71bea06ddc3669d56d`)
