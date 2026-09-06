# Faithfulness audit: LEV-CH01-ADVECTION-WAVE-IDENTITY

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `5701ac7f57ddad784ed0a3dfd4fa07802266740088e87f91411d3a1c742a747a`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The selected mathematical assertion is equality of two scalar PDE forms under renaming. D001 and D002 have identical semantic bodies through D003, and the target states their pointwise equivalence for arbitrary arguments in the source's positive-speed wave regime. The round-trip rejection rests on treating explanatory physical context and a methodological suggestion as extra formal conclusions and on misreading shared arbitrary binders as object conflation. Neither defeats the exact equation-form equivalence.

## Implications

- **Lean implies source:** `yes`. Unfolding the two wrappers yields the same scalar constant-coefficient pointwise PDE predicate with the same signs, derivative variables, coefficient, and zero residual. Universal agreement on a shared arbitrary field and coefficient establishes identity of the two equation schemas under the source's stated renaming; it does not identify the fields' physical meanings.
- **Source implies lean:** `yes`. The source explicitly identifies (1.2) and (1.4) after q <-> w and u-bar <-> c. Instantiating that schema correspondence by an arbitrary scalar field, the positive coefficient of the selected right-going case, and arbitrary x,t gives exactly the target Iff between the two pointwise predicates.

## Findings

- **note / canonical-renaming-encoding:** This is the canonical extensional statement that the equation schemas are identical, not a conflation of concentration with the acoustic variable.
- **note / right-going-coefficient-regime:** The target covers the source-selected right-going correspondence. The assumption is unnecessary for definitional equality but does not remove a case claimed for the cited equation-(1.4) regime.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `fail` |
| `C05` | `pass` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `fail` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `fail` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `not-applicable` | `not-applicable` |

## Dependency coverage

- Blind translator covered `67` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `67` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/agent_outputs/adjudicator.json` (`00c56a3461679e1973cce158e70786ed0a2af0738c3e5dee6e504aae7a2e8340`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/agent_outputs/agent_runs.json` (`1cb8ad1351cf21feb0e3bf053b28b1062065f419da6c037a6daa0e4e0d71ca9b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/agent_outputs/batch_source_contract.json` (`07b5cb23032d902d4562359219d877aa7842adee87f053fb665056701fb4bb33`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/agent_outputs/blind_translation.json` (`520e700dcf96967ab91ae997363229ed8815787da5b011c9a7680bbb7fc53889`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/agent_outputs/direct_judge.json` (`ac8e7d25577b44d5df5ab16926617d96314c82d1e2b75d8cf736b8a11c993abb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/agent_outputs/roundtrip_judge.json` (`267d4e774e6acd1c6ede4a6f34228347ea7288c3e2dc7dc9195d227d5eea9e13`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/agent_outputs/source_contract.json` (`a264d6fe313c91d410d38207698401881045f48624734cd49312605c2fd2e656`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/decision.json` (`c963ac8941097331f51d9d3274b228efcc319bfd98c63918dccdd6aae6a7d471`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/agent_outputs/agent_runs.json` (`3cdc22190db7e982f43e267d650f501cee827915d8f49d5df64e8005c2496762`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/agent_outputs/batch_source_contract.json` (`80110095831f6efd5aa2f52c8f3df8472abf682c640ebbfd2815ea9773271536`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/agent_outputs/source_contract.json` (`fd8628979b10add0cdc42ccb60445a1a9fe91c27a8fd829c8d37b8e7e6b7966d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/inputs/batch_source_locator.json` (`81d5c88e01fd1294a616e09d4de65d1ef6e93d0f7fa4aa6ddc9cb5b5a92d37e5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/inputs/blind_dependency_inventory.json` (`ad3ff56df40ee71f16f52bbbe0a7b94ecf3f3c92be2a9f55b6b0e8228cfc2aba`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/inputs/blind_dossier.md` (`31b2662d000fffef0bb545032c0be47197eac6a730b47844a7cd02041daa99a0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/inputs/blind_review_packet.md` (`31b2662d000fffef0bb545032c0be47197eac6a730b47844a7cd02041daa99a0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/inputs/declaration_dossier.md` (`fd587d3d9c29b6a4ddaaf7444ec98eb092d996b5bdd77ea92576ee48bdd2e332`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/inputs/dependency_inventory.json` (`524c2b144b90ac3aa8efa0907f764f0d7623eb247f01adfe8172ccdf891bc51d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/inputs/direct_review_packet.md` (`41c1ee1c2a9d2b08c0e401ea14104c20a0ea7e53f599d4f93900e2539cbc2176`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T023340Z/inputs/source_locator.json` (`93c06fc17bc77bfcd4cd72ba5b37eea25ffbecc8e8b61cdc8f01c35f5692b2b6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/agent_outputs/agent_runs.json` (`c94d6353d03ef40fa85cc62cc17336d3972ad7fe1c04627bafe54c715012fe1d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/agent_outputs/batch_source_contract.json` (`80110095831f6efd5aa2f52c8f3df8472abf682c640ebbfd2815ea9773271536`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/agent_outputs/blind_translation.json` (`2c9cd577795d4e1371529ceb9491ccc74b999c9199ef33421fbb359d314da9f5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/agent_outputs/direct_judge.json` (`000d7293e0a20380b7bcefdc1b3cde91208e2f7e09d1974ef35a0556a4981f81`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/agent_outputs/source_contract.json` (`fd8628979b10add0cdc42ccb60445a1a9fe91c27a8fd829c8d37b8e7e6b7966d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/inputs/batch_source_locator.json` (`81d5c88e01fd1294a616e09d4de65d1ef6e93d0f7fa4aa6ddc9cb5b5a92d37e5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/inputs/blind_dependency_inventory.json` (`ad3ff56df40ee71f16f52bbbe0a7b94ecf3f3c92be2a9f55b6b0e8228cfc2aba`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/inputs/blind_dossier.md` (`31b2662d000fffef0bb545032c0be47197eac6a730b47844a7cd02041daa99a0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/inputs/blind_review_packet.md` (`31b2662d000fffef0bb545032c0be47197eac6a730b47844a7cd02041daa99a0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/inputs/declaration_dossier.md` (`f1b5e2b3b29f4f26bbec0c780b534940da7830b53303421c4d97fbbb889aa32c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/inputs/dependency_inventory.json` (`524c2b144b90ac3aa8efa0907f764f0d7623eb247f01adfe8172ccdf891bc51d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/inputs/direct_review_packet.md` (`41c1ee1c2a9d2b08c0e401ea14104c20a0ea7e53f599d4f93900e2539cbc2176`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/history/20260901T031723Z/inputs/source_locator.json` (`93c06fc17bc77bfcd4cd72ba5b37eea25ffbecc8e8b61cdc8f01c35f5692b2b6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/inputs/batch_source_locator.json` (`81d5c88e01fd1294a616e09d4de65d1ef6e93d0f7fa4aa6ddc9cb5b5a92d37e5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/inputs/blind_dependency_inventory.json` (`ad3ff56df40ee71f16f52bbbe0a7b94ecf3f3c92be2a9f55b6b0e8228cfc2aba`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/inputs/blind_dossier.md` (`31b2662d000fffef0bb545032c0be47197eac6a730b47844a7cd02041daa99a0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/inputs/blind_review_packet.md` (`31b2662d000fffef0bb545032c0be47197eac6a730b47844a7cd02041daa99a0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/inputs/declaration_dossier.md` (`715bf25db2702f9832ab9fc1c3bb42e49c521b8b300bd2d7dd8d26ba6e664e03`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/inputs/dependency_inventory.json` (`524c2b144b90ac3aa8efa0907f764f0d7623eb247f01adfe8172ccdf891bc51d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/inputs/direct_review_packet.md` (`41c1ee1c2a9d2b08c0e401ea14104c20a0ea7e53f599d4f93900e2539cbc2176`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-WAVE-IDENTITY/faithfulness/inputs/source_locator.json` (`93c06fc17bc77bfcd4cd72ba5b37eea25ffbecc8e8b61cdc8f01c35f5692b2b6`)
