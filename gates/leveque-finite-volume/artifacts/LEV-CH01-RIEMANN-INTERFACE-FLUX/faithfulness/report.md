# Faithfulness audit: LEV-CH01-RIEMANN-INTERFACE-FLUX

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `e04cabbcb19c0111bf6826ae3b2ff096547cacdd0bfa70fa2afbc258eefc9bf1`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The repaired target is operationally faithful: it uses genuine normalized cell averages on a positive contiguous grid; forms, for each interface, the exact Riemann problem with left state Q_{i-1} and right state Q_i; obtains a problem-indexed certified solution with Equation (1.11) initial data and the integral conservation law; extracts information from that same solution; computes the numerical flux from that same information; and consumes the resulting edge fluxes in an explicit conservative update. The construction is therefore substantive and Lean implies the selected source claim. The converse fails for genuine additional semantic content, not merely naming or vacuity: the source does not require a total exact certified solver, a global integral-law certificate for every solve, universal constant-state consistency, or the exact update equality, and its inherited context expressly includes approximate solvers. Those differences are compatible strengthening of the exact branch, so the classification is faithful-stronger and accepted, with no unresolved evidence requiring adjudication.

## Implications

- **Lean implies source:** `yes`. Any instance of the Lean target has genuine neighboring cell averages Q_{i-1}, Q_i, solves their law-indexed Riemann problem with precisely those left and right data, extracts information from that solution, computes the corresponding numerical flux, and uses the edge-flux family in an explicit conservative timestep update. Thus it realizes every stage asserted in the selected source passage.
- **Source implies lean:** `no`. The source's claim and inherited context do not entail the target's total certified exact solver, global integral-conservation certificate for every returned solution, constant-state numerical-flux consistency for every state, or the particular explicit conservative update equality. The source also expressly allows arbitrarily good approximations and practical approximate Riemann solvers, which need not inhabit the exact certified method type.

## Findings

- **note / genuine-certification-strength:** This is a substantive, nonvacuous strengthening of the exact-solution branch, supporting faithful-stronger rather than equivalence.
- **minor / approximate-solver-applicability:** The theorem does not cover the source's practical approximate-solver branch; this limits applicability but does not invalidate the faithfully represented exact branch.
- **note / explicit-consistency-and-update-strength:** These exact downstream laws are genuine additional conclusions/structure and are source-compatible finite-volume strengthening.
- **note / analytic-source-compatible-strengthening:** The result applies to a more structured class of hyperbolic conservation laws and solvers while retaining the source operation.
- **note / explicit-update-specialization:** The exact formula is additional source-compatible structure and is not presented as uniquely dictated by the source.
- **note / abstract-information-semantics:** The abstraction preserves the source's deliberate freedom about what solver information is used.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `pass` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `158` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `158` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/agent_outputs/agent_runs.json` (`dca81f058cd820994ce1e12cda8cff95cc228063e599cf3d58de298641ba2add`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/agent_outputs/blind_translation.json` (`2273fcb87b52f51dc26ebb36d4890facf7d53a5bb616779aa556e04aa985172d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/agent_outputs/direct_judge.json` (`9b2eb7e888ae87e36e94c94be509aa4520b476120cbc46e6fcd972e4d91c9c1c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/agent_outputs/roundtrip_judge.json` (`d24d7a4f272eb6769d7b72244980be3732783fd251bad7f2028e8aaf24e7e663`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/agent_outputs/source_contract.json` (`a00eb49cf502eb6ca2e0bb53ff0218456ce951ef842351817b3dba0f83086e0e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/decision.json` (`94ab5ddeb94064f499796465af9fde9329fd67feb393ce2c43624303ede396a9`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/agent_outputs/agent_runs.json` (`ffccae868fcfc4e170adf55e849e556397198eca5fc24b3cf8b8ba05bb673ce0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/agent_outputs/batch_source_contract.json` (`bddda9768531429c363af90d5c05ed2bfc848979a985ecdf5d08386318ecab93`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/agent_outputs/blind_translation.json` (`0adb7078d7c1899676556304db73d7c16bee55b41d45f10f9c045a53eefe3d2a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/agent_outputs/direct_judge.json` (`39b12658435e53b43e0d09558eaf05b1a6be2f65d81d54005897ff25403bd5ea`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/agent_outputs/roundtrip_judge.json` (`747411576a94de06dd8a2638d90ee17ead7f66ebed6b9484f611392ebc7a986a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/agent_outputs/source_contract.json` (`64612e789ebb3044e085588aa13ca4e8a7e91a309fd87d27136c8385d0b0a70b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/inputs/batch_source_locator.json` (`550718920474263b37166c18428d725cd2014735d4ba54a8f624e00d6823be79`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/inputs/blind_dependency_inventory.json` (`33f13802706429b0e8e8d98a63f39adb2ff51340b559abb1c74afe30c5da52f3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/inputs/blind_dossier.md` (`034e3083256fe94f7cfe9cd9439faaf1d221b0b013fac9b4b5d6d243cf1e1b4f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/inputs/blind_review_packet.md` (`034e3083256fe94f7cfe9cd9439faaf1d221b0b013fac9b4b5d6d243cf1e1b4f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/inputs/declaration_dossier.md` (`46607870136071ad7219438d2ffcd6cfb570d005cd9fbe16d2cd36de1c83fb62`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/inputs/dependency_inventory.json` (`3c8211a9c8b8e50f31400b3e82d68d1c4492bf265124d9b015971038a3b0fdda`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/inputs/direct_review_packet.md` (`53cd9faa78455cd10a7ed79ae7bdcc26c418a7f3ec8407c59b1fa285a443c0d0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073113Z/inputs/source_locator.json` (`8d488af4196a1c56430411e6009647ab8a85ad37c7d0440ecb68a5adf8cdd454`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073819Z/inputs/blind_dependency_inventory.json` (`455318e5655b3dd81404b2edf7ddd1366d2d46e49b40daedffff1e6250460fa5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073819Z/inputs/blind_dossier.md` (`1fc07e81934ef6788b8c1a95a2ebb902f9e0cd433afb4e9a283fa39ad4c5ff95`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073819Z/inputs/blind_review_packet.md` (`1fc07e81934ef6788b8c1a95a2ebb902f9e0cd433afb4e9a283fa39ad4c5ff95`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073819Z/inputs/declaration_dossier.md` (`32eb8fe41e552d3721a414241a23420e00c8d79aecc59a55dff03feec2a14602`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073819Z/inputs/dependency_inventory.json` (`5d38fe35b7f54c99230322978eab525d95f2078b1e9fa295543a56748e2728c8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073819Z/inputs/direct_review_packet.md` (`ccbce8f0ee8a26cb0d114e0e137cd7cd9f8e3f726d3bab470cda5688bc139416`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T073819Z/inputs/source_locator.json` (`8d488af4196a1c56430411e6009647ab8a85ad37c7d0440ecb68a5adf8cdd454`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/agent_outputs/agent_runs.json` (`cfff7aea96eb8b2cc1f157088220435e0626f0dd42937dfca9d3dca55cbb9d5a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/agent_outputs/batch_source_contract.json` (`bddda9768531429c363af90d5c05ed2bfc848979a985ecdf5d08386318ecab93`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/agent_outputs/blind_translation.json` (`ea98f6647d30a21438dded5c1151c7ae61285ab619035bc121a7e8bc243cd808`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/agent_outputs/direct_judge.json` (`08b8cde970aba45ecc80ce3f42eaf4d2a05dc7aa0c8a4b93cd831867c9d6a94b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/agent_outputs/roundtrip_judge.json` (`9b9ab5eb639e0d095f407bf5f48205813b4c504e087f75babdf37e4e689b5116`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/agent_outputs/source_contract.json` (`64612e789ebb3044e085588aa13ca4e8a7e91a309fd87d27136c8385d0b0a70b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/inputs/batch_source_locator.json` (`550718920474263b37166c18428d725cd2014735d4ba54a8f624e00d6823be79`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/inputs/blind_dependency_inventory.json` (`455318e5655b3dd81404b2edf7ddd1366d2d46e49b40daedffff1e6250460fa5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/inputs/blind_dossier.md` (`1fc07e81934ef6788b8c1a95a2ebb902f9e0cd433afb4e9a283fa39ad4c5ff95`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/inputs/blind_review_packet.md` (`1fc07e81934ef6788b8c1a95a2ebb902f9e0cd433afb4e9a283fa39ad4c5ff95`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/inputs/declaration_dossier.md` (`32eb8fe41e552d3721a414241a23420e00c8d79aecc59a55dff03feec2a14602`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/inputs/dependency_inventory.json` (`5d38fe35b7f54c99230322978eab525d95f2078b1e9fa295543a56748e2728c8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/inputs/direct_review_packet.md` (`ccbce8f0ee8a26cb0d114e0e137cd7cd9f8e3f726d3bab470cda5688bc139416`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T090647Z/inputs/source_locator.json` (`8d488af4196a1c56430411e6009647ab8a85ad37c7d0440ecb68a5adf8cdd454`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/agent_outputs/agent_runs.json` (`75957b37dca23614f6cad72722f30f04cc619deeed324daff6ab4e877e175beb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/agent_outputs/blind_translation.json` (`f4881e48ce7d02bed76fe9f2da452a2dd6f79f011ca5d3f9a5ae3fbcd8aa76dd`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/agent_outputs/direct_judge.json` (`3472fab4fae6f26d1b6240540fe901f025f5ddb34c7cabc05ccc97ef76fe3dfa`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/agent_outputs/roundtrip_judge.json` (`033a707295a545fbddc43e91efc574c24692b4fcc99f14d049036febd5aab986`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/agent_outputs/source_contract.json` (`a00eb49cf502eb6ca2e0bb53ff0218456ce951ef842351817b3dba0f83086e0e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/inputs/batch_source_locator.json` (`550718920474263b37166c18428d725cd2014735d4ba54a8f624e00d6823be79`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/inputs/blind_dependency_inventory.json` (`86c90baf9783d76eed5a3e827d81ca869130f09288511136e1175863b5251cff`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/inputs/blind_dossier.md` (`b9623920b4dcd0f76c7e1eb72f8d3a6e960329bbf949be6d7acff5162c6724de`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/inputs/blind_review_packet.md` (`b9623920b4dcd0f76c7e1eb72f8d3a6e960329bbf949be6d7acff5162c6724de`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/inputs/declaration_dossier.md` (`17283425f5880d4e096f107e589f9810ec0152cf4da1e2644e1ad68a712a40fe`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/inputs/dependency_inventory.json` (`9af8a1671c49007dd22e4883552994cc1b6250540466a408057b82b0937561d0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/inputs/direct_review_packet.md` (`4545cb2d5ff8a07ff3f584615515604d1db76d98997e5454c30c356f11b6fe23`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/history/20260901T125615Z/inputs/source_locator.json` (`8d488af4196a1c56430411e6009647ab8a85ad37c7d0440ecb68a5adf8cdd454`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/inputs/blind_dependency_inventory.json` (`c1a64b8df1dd348ff6d4b0cf23589790691b32cdebf208d768c9db7481f5a135`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/inputs/blind_dossier.md` (`51a7753aec48a8ac3a54c549beb4854c938e7047d3b68f2f840b321098f79a0b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/inputs/blind_review_packet.md` (`51a7753aec48a8ac3a54c549beb4854c938e7047d3b68f2f840b321098f79a0b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/inputs/declaration_dossier.md` (`ff08a8860235463c43fae17fd55e5715fa29be80cbcceca12b26f7887baa134c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/inputs/dependency_inventory.json` (`eb32c8c8cef3f5a0b00b0e75524d004b7c4125f4489ccb5638f7e8a8efb77ad4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/inputs/direct_review_packet.md` (`fb8840bab1c90c4fe7e142260b6dab02ca7d64602e4299b5c8d2b96d8fbed4be`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-RIEMANN-INTERFACE-FLUX/faithfulness/inputs/source_locator.json` (`8d488af4196a1c56430411e6009647ab8a85ad37c7d0440ecb68a5adf8cdd454`)
