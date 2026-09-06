# Faithfulness audit: LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `36551fdb0f45d1138ef4133a5c14e662e59999428c5098d3f603aa935e49ba9f`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The semantic closure confirms exact agreement on q ordering, matrix placement, matrix-vector multiplication, derivative witnesses, and the two scalar equations. The sole consequential difference is that Lean drops the inherited physical positivity restrictions while retaining density nonzero. Since this enlarges the universally covered coefficient domain, has concrete nonphysical satisfying instances, and specializes exactly to the source, it is an accepted faithful nonvacuous strengthening.

## Implications

- **Lean implies source:** `yes`. Specializing the universally quantified Lean proposition to positive physical bulk modulus and density gives q=(p,u)^T, A=[[0,K],[1/rho,0]], and exactly the bidirectional row expansion of equations (1.5)-(1.6). All state ordering, matrix entries, derivative semantics, signs, and pointwise scope match.
- **Source implies lean:** `no`. The source claim is situated in the positive physical material-parameter domain and therefore supplies no assertion for negative density, zero or negative bulk modulus, or the corresponding nonphysical coefficient matrices. Lean asserts the equivalence for all those additional cases whenever density is nonzero.

## Findings

- **note / nonvacuous-coefficient-domain-generalization:** The additional coefficient cases contain genuine solutions and are not admitted through an impossible premise or false-only equivalence. The broader universal theorem is therefore genuine strength and remains faithful because its positive-parameter specialization is exactly the selected source claim.
- **note / algebraic-well-definedness:** The zero-density case is correctly excluded. No extra hypothesis narrows the physical source domain.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `fail` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `not-applicable` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `not-applicable` |

## Dependency coverage

- Blind translator covered `88` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `88` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/agent_outputs/adjudicator.json` (`2da280674135551fbd53832e34d828648c21a1fdd3b99d1800db24215a820275`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/agent_outputs/agent_runs.json` (`2aa713e5f2f96f30700f9cdb8c6b4be9e8c2a20da400d83d984f4c8361359d52`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/agent_outputs/batch_source_contract.json` (`d0fd4bc8d51f4e43a915edd501472b75abc7eb59c4c22ba8049da4ed8c452133`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/agent_outputs/blind_translation.json` (`5ff4225a11b5aac01dd63408b962d3b17357d351f6a51e9dcfc3e354699a45aa`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/agent_outputs/direct_judge.json` (`273912517290021cb2b4bf64c1b2a3a01f42c8e01e82db16763b467248663160`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/agent_outputs/roundtrip_judge.json` (`b623543ef3deff20943eda3e9b385f38e97081e9e2f0caf77d380a5af7ec2133`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/agent_outputs/source_contract.json` (`23f87c274302b6e62d4af60b962c22511b615bf73f1c829dad72f042cefa1fd0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/decision.json` (`5f2196c253727ff82ed5e82d2e1e9f6821ffbf2b7bf838df616ac41d2eb4781e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/agent_outputs/agent_runs.json` (`d82aef65fe2afad0d097002f0f370cef67fbc6e35f405c37fa8ed72ee5b635d2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/agent_outputs/batch_source_contract.json` (`d8fdc23104f3a4ce44add59aa66515c36255136ffeac295b5f757fb7be5f1438`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/agent_outputs/blind_translation.json` (`39b13c51820c63762eb8afe0d92152031d505c8a6929df50a3d169972838efb5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/agent_outputs/direct_judge.json` (`cab49bd5a8005571279577592624aafb51a1827e59558cdeeee9a0fbeb337bd3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/agent_outputs/source_contract.json` (`01a159d67769dbd4de88a2ae8f399fa57dd4dbb2ac11c582b13235ebd02f1705`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/inputs/blind_dependency_inventory.json` (`a727daffc0ca60b0b3ed466781e8739c7b448efd637a907b274a98caf9f98fdb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/inputs/blind_dossier.md` (`a6e7079d07f9ed34eacbcec1d7eba73ce3534dac68a54804363b6f316c799308`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/inputs/blind_review_packet.md` (`a6e7079d07f9ed34eacbcec1d7eba73ce3534dac68a54804363b6f316c799308`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/inputs/declaration_dossier.md` (`a49ffef6b778ad5ceee14f10a1ab184ab0b69fbb17c95f1c53e4adaafe02aba1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/inputs/dependency_inventory.json` (`2fff7f3a62b7b465fd2a39f4b8640759f07a05f108ba1b0bec03c241aebac221`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/inputs/direct_review_packet.md` (`ec7dec0d438efee6fdfe5f4ac9b7bf7e9fab867e0557be2635348b6aee4beffb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/history/20260901T052854Z/inputs/source_locator.json` (`5d7d41cc6d0c6eb852a4babc07ec316ad94de780557ff257c6e5e4a0988b8b7c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/inputs/blind_dependency_inventory.json` (`a727daffc0ca60b0b3ed466781e8739c7b448efd637a907b274a98caf9f98fdb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/inputs/blind_dossier.md` (`a6e7079d07f9ed34eacbcec1d7eba73ce3534dac68a54804363b6f316c799308`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/inputs/blind_review_packet.md` (`a6e7079d07f9ed34eacbcec1d7eba73ce3534dac68a54804363b6f316c799308`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/inputs/declaration_dossier.md` (`a49ffef6b778ad5ceee14f10a1ab184ab0b69fbb17c95f1c53e4adaafe02aba1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/inputs/dependency_inventory.json` (`2fff7f3a62b7b465fd2a39f4b8640759f07a05f108ba1b0bec03c241aebac221`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/inputs/direct_review_packet.md` (`ec7dec0d438efee6fdfe5f4ac9b7bf7e9fab867e0557be2635348b6aee4beffb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX/faithfulness/inputs/source_locator.json` (`5d7d41cc6d0c6eb852a4babc07ec316ad94de780557ff257c6e5e4a0988b8b7c`)
