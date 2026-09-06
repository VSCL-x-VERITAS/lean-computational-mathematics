# Faithfulness audit: LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `bf433cf8ca84ad036a62f95a905663d4e218e0ada695211f3e2eb56d74f61188`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The exact algebraic and analytic content of equation (1.1) is reconstructed correctly: q has two real arguments and m real components, A is one fixed real square matrix, the time and space slices have the intended derivatives, matrix multiplication acts only on q_x, and the residual is the zero vector. The decisive mismatch is logical rather than algebraic. ConstantCoefficientLinearSystemSolution A is essentially a state q paired with a proof of the complete all-points source equation. The audited theorem universally quantifies over that proof-carrying package and merely returns one instance of the stored proof. Constructor/projection equivalence shows that the package loses no certified solutions, but it does not show that this projection proposition states the source constraint: from the theorem one cannot obtain the equation for an independently supplied q, whereas a source q satisfying the equation can be packaged and hence implies the Lean conclusion. The premise is demonstrably inhabited, including by nonconstant affine states, so the failure is not empty-type vacuity; it is circular assumption of the source content. The m = 0 and solution-concept questions remain limited source ambiguities and do not change the two implication verdicts.

## Implications

- **Lean implies source:** `no`. After expanding D001-D004, the theorem has the form: for every q already accompanied by a proof that P_A(q,x,t) holds for all x,t, P_A(q,x,t) holds at a selected point. It yields the source equation only for an already-certified state and cannot impose the source's PDE constraint on an independently supplied unknown q. The constructor and the external existence of certified examples cannot supply the missing certificate for an arbitrary candidate q.
- **Source implies lean:** `yes`. Under the source passage's ordinary pointwise partial-derivative reading, a q satisfying q_t + A q_x = 0 at all relevant x,t supplies exactly D004 everywhere. D003 packages q with that global certificate as a D001 system, and the target then projects the same pointwise fact. The m = 0 conclusion is independently trivial and does not block this direction.

## Findings

- **critical / source constraint moved into proof-carrying premise:** The target is a certificate-projection lemma. It does not imply the source constraint for an independently presented q, so it is strictly weaker as an audited proposition.
- **major / nonvacuous but circular conclusion:** The premise is not impossible, but the theorem remains true for the unintended trivial reason that its conclusion is stored in its input.
- **minor / zero-dimensional extension:** This is a source-ambiguous, componentwise-vacuous endpoint and does not determine the classification.
- **note / classical derivative choice:** The choice is a coherent minimal classical reading, though the selected passage does not settle broader weak/distributional conventions.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `fail` |
| `C04` | `pass` | `fail` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `fail` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `not-applicable` | `unclear` |

## Dependency coverage

- Blind translator covered `75` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `75` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The source does not explicitly say whether the component count m may be zero; Lean includes the well-defined but componentwise-vacuous m = 0 endpoint.
- The selected passage names partial derivatives but does not explicitly distinguish classical pointwise solutions from weak or distributional solution concepts.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/adjudicator.json` (`7caebfff99718f413dd8f5aabb05acd9a935b2bcb6e4de88c7753e72d852be0e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/agent_runs.json` (`835865408e1703d08bd0c99605da1c6eb493306620ac94f345eaa92d53e0b20d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/blind_translation.json` (`eafdb0bd52c23c135aa698c8ce937d498af5e06d2ad81a81ac0e5b7c22b72743`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/direct_judge.json` (`8fa6fc5c4ade16bb24caced89580cc29072716a23d2a0de499dc442789fdc284`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/roundtrip_judge.json` (`ec9df23f277f515d8a1fd2b125fe2ae80e9d50462b4883a8ccdae8bdfef5941f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/source_contract.json` (`f71dfe03b433f2ae367c8d10ebca8437ca0821816f7e7ff7eb1214e0ef56c3c5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/decision.json` (`63cd016d0478b4ae6ac67ac8e10c95cf16615ad47cf0dfed32a0ee223b08596d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/agent_outputs/adjudicator.json` (`de5ed06528b67ef24b90762f973df7baff366208b027d3c7a748295a06990a32`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/agent_outputs/agent_runs.json` (`cd599f8ee00c265386243b8fcf871b6128de0222846b5419c1fc694676ec38fc`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/agent_outputs/batch_source_contract.json` (`9532e1ca38b7e4d49830680a12d77b102ed0b6459d6dfdc28d7225f1a53ebdae`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/agent_outputs/blind_translation.json` (`57f5efa7c965a8c255b30a137dfbf1cf14d68bcdb23e171c621285e0126ba8d1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/agent_outputs/direct_judge.json` (`3394a13fcfc6b19b6ffefeb44369360ad91c84f8456926274246f882501eca2c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/agent_outputs/roundtrip_judge.json` (`3bd0f0a1027939e906c2095b5460a28708d38f539fce1a902233981128a3a53e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/agent_outputs/source_contract.json` (`bc2ff40cc812b143fce876d5c17c5e8e000ceb77457e398dbc39f9583550833c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/decision.json` (`19114b4af7e1d3828e3ff3b3b5d02aa8aad53b27a2807952a87073a5fccddebb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/inputs/batch_source_locator.json` (`67dbac17174068b7f3300cb6dcf007101ac0733c40cf72a06ef3274f46edfbce`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/inputs/blind_dependency_inventory.json` (`e65ab8c3e61980fbcc9737e5d17fa77be2b9b5684548b83433d1846ac9368d8c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/inputs/blind_dossier.md` (`47bbe61ab19adbd616a6cba67f203866009f02bbf4bfd68d6755871b2a28d54d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/inputs/blind_review_packet.md` (`47bbe61ab19adbd616a6cba67f203866009f02bbf4bfd68d6755871b2a28d54d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/inputs/declaration_dossier.md` (`269cce5343bdaf79c5b7bc987315af42d4d2d873a686abcebe5b81d9eabcb43b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/inputs/dependency_inventory.json` (`0c5093ab6f312543194eb7b3e7aa255e65986604f5b7e70a63ccf6027f31ad2d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/inputs/direct_review_packet.md` (`5c7daa39171ce7e8d9e8ce5a62adf9f04d6729c9d1a147918a7614ac83542514`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/history/20260901T022832Z/inputs/source_locator.json` (`aafa2c894599978502ddb3ce631c611f710844bbd1b0542f0b5b2e31f8d4ecb4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/blind_dependency_inventory.json` (`46a87003afcdfd766d74735a8bf009cb5f27b552d85cfd2b597ca7bb8c36643c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/blind_dossier.md` (`34528e171efeadecc596cea99faf9a4a0b4ce1b7e647cfa7c7e6ac221a37b42c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/blind_review_packet.md` (`34528e171efeadecc596cea99faf9a4a0b4ce1b7e647cfa7c7e6ac221a37b42c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/declaration_dossier.md` (`4ceb14b4d757fc06c423f7c117bf3137783ec58b90fc719bc85cca1ffad49561`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/dependency_inventory.json` (`30ab2cd284877252b9a8759832bd3d0f01aa614e4939beed8e325a52c0a6e3ca`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/direct_review_packet.md` (`d46af18454f974dd5b42a48a4f6ead912fb7b8553875a7de4ae7b6aa30ddec6c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/source_locator.json` (`aafa2c894599978502ddb3ce631c611f710844bbd1b0542f0b5b2e31f8d4ecb4`)
