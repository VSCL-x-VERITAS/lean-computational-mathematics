# Faithfulness audit: LEV-CH01-FINITE-VOLUME-CELL-AVERAGE

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `5bf37e483d240afa82a3589b05ef69e9d6db19679528091eb78643d81a8bb6a7`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The theorem encodes the source's entire-cell integral divided by positive cell volume, componentwise for a vector state. It is cell-based rather than a point sample, and its integrability/positivity hypotheses are the technical conditions implicit in the source definition.

## Implications

- **Lean implies source:** `yes`. The target's local definitions make the output exactly the integral over [left,right] divided by right-left, componentwise, with positive volume and integrability.
- **Source implies lean:** `yes`. The source definition of a cell average, specialized to a one-dimensional positive interval and Fin m-valued density, is exactly the Lean specification.

## Findings

No findings were recorded.

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
| `N02` | `pass` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `60` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `60` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/agent_outputs/agent_runs.json` (`b28d92c6299d11d45d6bc77066ce61784a05c80264f5cd63b964fc805fe98fbe`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/agent_outputs/batch_source_contract.json` (`7b946c2a9794a673acc69e1d657a4e46f99d38880d0bf9cd1652eb49ee59a332`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/agent_outputs/blind_translation.json` (`0b204ccd81f7c0f0356f4440d1ea2a522ca4984e03c64981a6aab8395b5db9f5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/agent_outputs/direct_judge.json` (`052a86d63304e7e54a112467c149eaac4fbf0f59618ebb5b5a54ca9400b22cc1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/agent_outputs/roundtrip_judge.json` (`42b1dc9e6e5f8b9a38ecc046b788fa7d03d9987f0abbab56c56688c51f86f6fc`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/agent_outputs/source_contract.json` (`1944b5844695bc0d02ad82e3d9fe91c819bdc7c6f753e84eeafbacba7dc87270`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/decision.json` (`34b8c7320da111d1b63eb9c384b6806a32979bea5a92fedc9bf400daa1914623`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/inputs/batch_source_locator.json` (`0b272037292776c34f1e8ce621cd97c98da8f329dfed4995fa0bb0b41b55aa6f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/inputs/blind_dependency_inventory.json` (`8c74803c21d432e8031be0a5551a1c9d7670252243f8e2cb191783a4929679e6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/inputs/blind_dossier.md` (`088a883de1affd612d55ad491425cd6cc8af5a18fee02d9c73a1af38ab5606ae`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/inputs/blind_review_packet.md` (`088a883de1affd612d55ad491425cd6cc8af5a18fee02d9c73a1af38ab5606ae`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/inputs/declaration_dossier.md` (`561b377c2fabd61a0379145f939c2365f43cd3acd6fc3af65a91d01e9efbec84`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/inputs/dependency_inventory.json` (`f0d8286f8e9f056e179af90205e525f79a1467d36def2e0570df099f40c0cb1c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/inputs/direct_review_packet.md` (`92036848550ffcd398ba4bf0393483b8eab21e3ee86628090e282a5abb6cc78d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE/faithfulness/inputs/source_locator.json` (`b8c0118d6a9999c5d15f0f0d92d846931ef1256356d5d3306b854ef729f5c509`)
