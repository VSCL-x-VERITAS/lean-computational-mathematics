# Faithfulness audit: LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `24c5d38b77326b89b73456707d05d240bd439882129386fd2ea58ec10845f3f7`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Adjudication turns on the exact proposition, not on the usefulness of the underlying definition or a presumed repository intent. The source passage introduces the constant-coefficient linear PDE by displaying the condition q_t(x,t) + A q_x(x,t) = 0 for the unknown vector q. The audited theorem instead proves that a named pointwise predicate is equivalent to its literal definition. That is a valid and accurate unfolding lemma, and its right-hand side correctly represents the source equation locally, but the lemma is true even when q is not a solution. Thus Lean does not imply the selected source claim, while the source claim implies the always-valid unfolding equivalence, giving not-faithful-weaker and accepted = false. The admitted m = 0 case is a vacuous, source-ambiguous boundary generalization; it is not genuine strength and cannot change the result because the implication failure is witnessed already at m = 1.

## Implications

- **Lean implies source:** `no`. Let S(q,A,x,t) be the existential partial-derivative condition with residual q_t + A q_x = 0. D001 and D002 make the Lean theorem the universally valid definitional equivalence S iff S. It therefore holds for nonsolutions. For example, within the source's positive-dimensional setting m = 1, A = 0 and q(x,t) = t have q_t = 1 and q_x = 0, so the source residual is nonzero even though the Lean equivalence is true.
- **Source implies lean:** `yes`. Whenever the source PDE condition holds, the Lean equivalence also holds; indeed D001 unfolds through D002 to the exact right-hand side, so the equivalence is true regardless of the PDE's truth for the selected q and point.

## Findings

- **critical / claim-shape-and-vacuity:** The theorem is true for q that do not satisfy the displayed PDE, so it does not state the selected source result and is strictly weaker.
- **major / pointwise-condition-not-asserted:** Even before considering global versus pointwise scope, the PDE is not asserted at a single point; a global solution assertion would additionally require the pointwise predicate for all x and t.
- **minor / zero-dimensional-generalization:** This is a vacuous boundary extension rather than genuine theorem strength, and it does not affect the decisive positive-dimensional mismatch.
- **note / local-expression-accuracy:** The local mathematical expression faithfully encodes equation (1.1); the failure is the top-level theorem's failure to assert that expression.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `fail` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `fail` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `not-applicable` | `not-applicable` |

## Dependency coverage

- Blind translator covered `74` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `74` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The selected source passage does not formally quantify m or explicitly state m > 0, so literal authorial inclusion or exclusion of the zero-dimensional convention remains uncertain. The source's statement that m = 1 is the simplest case supports the ordinary positive-dimensional reading, and the uncertainty cannot affect the classification because the Lean-to-source counterexample uses m = 1.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/adjudicator.json` (`de5ed06528b67ef24b90762f973df7baff366208b027d3c7a748295a06990a32`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/agent_runs.json` (`cd599f8ee00c265386243b8fcf871b6128de0222846b5419c1fc694676ec38fc`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/batch_source_contract.json` (`9532e1ca38b7e4d49830680a12d77b102ed0b6459d6dfdc28d7225f1a53ebdae`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/blind_translation.json` (`57f5efa7c965a8c255b30a137dfbf1cf14d68bcdb23e171c621285e0126ba8d1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/direct_judge.json` (`3394a13fcfc6b19b6ffefeb44369360ad91c84f8456926274246f882501eca2c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/roundtrip_judge.json` (`3bd0f0a1027939e906c2095b5460a28708d38f539fce1a902233981128a3a53e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/agent_outputs/source_contract.json` (`bc2ff40cc812b143fce876d5c17c5e8e000ceb77457e398dbc39f9583550833c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/decision.json` (`19114b4af7e1d3828e3ff3b3b5d02aa8aad53b27a2807952a87073a5fccddebb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/batch_source_locator.json` (`67dbac17174068b7f3300cb6dcf007101ac0733c40cf72a06ef3274f46edfbce`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/blind_dependency_inventory.json` (`e65ab8c3e61980fbcc9737e5d17fa77be2b9b5684548b83433d1846ac9368d8c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/blind_dossier.md` (`47bbe61ab19adbd616a6cba67f203866009f02bbf4bfd68d6755871b2a28d54d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/blind_review_packet.md` (`47bbe61ab19adbd616a6cba67f203866009f02bbf4bfd68d6755871b2a28d54d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/declaration_dossier.md` (`269cce5343bdaf79c5b7bc987315af42d4d2d873a686abcebe5b81d9eabcb43b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/dependency_inventory.json` (`0c5093ab6f312543194eb7b3e7aa255e65986604f5b7e70a63ccf6027f31ad2d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/direct_review_packet.md` (`5c7daa39171ce7e8d9e8ce5a62adf9f04d6729c9d1a147918a7614ac83542514`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM/faithfulness/inputs/source_locator.json` (`aafa2c894599978502ddb3ce631c611f710844bbd1b0542f0b5b2e31f8d4ecb4`)
