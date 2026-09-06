# Faithfulness audit: LEV-CH01-FINITE-VOLUME-FLUX-UPDATE

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `839fbc74ac757fdc0cb3643d19b8de38a97e7f99af5755f0eb97fa42b6f65562`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The repaired theorem gives substantive semantics to every part of the selected finite-volume description. Its cell regions form a nonempty measurable, disjoint, exhaustive partition; positive finite measure and integrability make each normalized Bochner cell average genuine; each oriented interface joins distinct cells at a common closure point; the numerical flux at that interface is exactly a function of the two incident cell averages and is kept distinct from the physical flux by a strict metric-tolerance hypothesis; and the same interface-flux family is consumed in an exact volume-weighted timestep update. The definitions of net outward and boundary flux also prove exact internal cancellation and conservation for every finite collection of cells. Consequently Lean implies the source. The converse fails because the prose does not entail the exact local and aggregate balance equalities or the target's quantitative and structural package. The aggregate conservation identity is genuine additional conclusion strength, so the target is faithful-stronger and accepted. Its finite internal-interface abstraction and exact-cell-average specialization reduce coverage but are explicitly recorded and are not misused as evidence of strength. No semantic dependency, check, or implication remains unclear, so adjudication is not required.

## Implications

- **Lean implies source:** `yes`. For every target instance, the domain is genuinely partitioned into measurable cells; each supplied cell value is its normalized volume integral; each designated interface flux is computed only from the two incident cell averages; that numerical flux is within the stated positive tolerance of the physical interface flux; and the same edge-flux family modifies each volume-weighted average over the positive timestep. Thus the target realizes every operational claim in the selected source paragraph.
- **Source implies lean:** `no`. The qualitative source paragraph does not entail the target's specified measurable exhaustive partition, finite oriented internal-interface package, pointwise metric tolerance at every interface, exact volume-weighted update equality, or the exact cancellation identity equating every finite collection's mass change to its algebraic boundary flux. In particular, the arbitrary-finite-cell-set conservation law is genuine additional semantic content, not merely an extra applicability hypothesis.

## Findings

- **note / exact-discrete-conservation-strength:** This is genuine nonvacuous additional strength and is the principal reason the accepted classification is faithful-stronger rather than equivalent.
- **note / quantitative-flux-approximation:** This makes the qualitative requirement precise without reversing roles or weakening the comparison.
- **minor / finite-internal-interface-scope:** This is reduced applicability/abstraction, not the basis for the stronger classification. It does not defeat the focal internal-edge update represented by the target, but boundary-condition applications require additional structure.
- **note / exact-cell-average-specialization:** The target faithfully covers the exact-data specialization and preserves the only-data dependency; it does not formalize a separate error relation between stored and exact PDE cell averages.
- **note / quantitative-flux-quality-strengthening:** The result applies to a quantitatively controlled subclass of source-compatible numerical fluxes.
- **note / explicit-geometric-and-update-specialization:** These choices add source-compatible structure and are not presented as the only possible realization of the source principle.
- **note / finite-set-conservation-strengthening:** The aggregate identity makes the source conservation principle explicit and stronger.

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
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `pass` |
| `N04` | `pass` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `112` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `112` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/agent_outputs/agent_runs.json` (`05e58b575c8b6bff79a4ddc5904413019490249b12216e4e56823a286b605565`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/agent_outputs/batch_source_contract.json` (`7b946c2a9794a673acc69e1d657a4e46f99d38880d0bf9cd1652eb49ee59a332`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/agent_outputs/blind_translation.json` (`2360e2c8677fe9f0788de60a2f10bbd8ff34ee6fffedf757d36b5d9bdad3271f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/agent_outputs/direct_judge.json` (`7eafc3ccd856fcaaf10bd0a9a539ce0c0d0de392e882dd44ea36a8ce44fe6a8e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/agent_outputs/roundtrip_judge.json` (`1e7288ed9174e0908f0774add71fd9f30e70f73f6afeefe7ee2fca79dfc2812c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/agent_outputs/source_contract.json` (`d3244e8d2499f0ce633a3fbc86012d50ceb4ae5baf5c59a0ecb159a29ab26972`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/decision.json` (`893ae7bca7f02c041e885d777676ad3602a788f0a7f82e0181c56f2707e5cf46`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/agent_outputs/agent_runs.json` (`b52305447f675bec17a81a1f75f745b324a94735762fed76bbd2914ee64d8d2c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/agent_outputs/batch_source_contract.json` (`7b946c2a9794a673acc69e1d657a4e46f99d38880d0bf9cd1652eb49ee59a332`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/agent_outputs/blind_translation.json` (`ca4c7ce122f31ecba7cc538d73d9f043b072947046936889cf345840fb8c7a0e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/agent_outputs/direct_judge.json` (`75fa8505a9ac4ecddf972cb70ae55badde33a084c334e770fb83a69ac080adfa`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/agent_outputs/roundtrip_judge.json` (`5fc7910680ad799eb77afdcd1cf68218857d85eb54aec92affb8088167f50ba8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/agent_outputs/source_contract.json` (`d3244e8d2499f0ce633a3fbc86012d50ceb4ae5baf5c59a0ecb159a29ab26972`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/inputs/batch_source_locator.json` (`0b272037292776c34f1e8ce621cd97c98da8f329dfed4995fa0bb0b41b55aa6f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/inputs/blind_dependency_inventory.json` (`5d664547ab0e5ac4a60c3d4fbda277f2c3d4343259a383487513074860e119ec`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/inputs/blind_dossier.md` (`e0cb99374da18c0358e3408aad7851e46dfaf33649de4a6af70f4ed7d8ac6d5e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/inputs/blind_review_packet.md` (`e0cb99374da18c0358e3408aad7851e46dfaf33649de4a6af70f4ed7d8ac6d5e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/inputs/declaration_dossier.md` (`3f138867c6b1863766f7a48c69417d1ec89e99bc69bc8fff2aa7cc2f3da95bc6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/inputs/dependency_inventory.json` (`ed5823a083fc0c9401a4253f8356d6ee59579fb2aace25a7cddc41de7fd5540d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/inputs/direct_review_packet.md` (`f6c3b4fc0befb4c3d5a991e84436ab857b70fe48014d5df974744c0a0c68ffca`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T072540Z/inputs/source_locator.json` (`9b7205e7ce53cb9a6569f8097f123bb4a30b2292430473f4b4e11c2d97237558`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/agent_outputs/agent_runs.json` (`4c8307194fecbd794fb01050fd4bc2f9b48d688538e4eecfcef1db9b022f6b63`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/agent_outputs/batch_source_contract.json` (`7b946c2a9794a673acc69e1d657a4e46f99d38880d0bf9cd1652eb49ee59a332`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/agent_outputs/blind_translation.json` (`c0fc5b8ca47d79a083c07c8efba089e347e704a704fea4ab061149cc47766afd`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/agent_outputs/direct_judge.json` (`f13e8104f7d853aeabcb5b5e891304173d826aaa71778ee879641535a86fd629`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/agent_outputs/roundtrip_judge.json` (`fd7489616dd994729b544860b32a2c29fb20bcfcb888e02628cb9bcf78f7d40f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/agent_outputs/source_contract.json` (`d3244e8d2499f0ce633a3fbc86012d50ceb4ae5baf5c59a0ecb159a29ab26972`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/inputs/batch_source_locator.json` (`0b272037292776c34f1e8ce621cd97c98da8f329dfed4995fa0bb0b41b55aa6f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/inputs/blind_dependency_inventory.json` (`a9a936557a5434459a31a6ce0ffe63f96e2147e50908d6f5f60c2e5594bb814a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/inputs/blind_dossier.md` (`c8f5e018c701d667c2496ade828d2b5c3361516b2ff2d4c2f22c0420313c8d64`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/inputs/blind_review_packet.md` (`c8f5e018c701d667c2496ade828d2b5c3361516b2ff2d4c2f22c0420313c8d64`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/inputs/declaration_dossier.md` (`a22c718e60b194ec26f206f1e0f73dd62631c8c88864af678c39981777b66738`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/inputs/dependency_inventory.json` (`7a83247d5feb95a9892e949d754967fc79d9d6011e72e49c74ff34a26b7f3764`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/inputs/direct_review_packet.md` (`ce2213ca4578691623b61f8e8b2ff0fcd1512347e18793efaa5ca2f101867905`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T091030Z/inputs/source_locator.json` (`9b7205e7ce53cb9a6569f8097f123bb4a30b2292430473f4b4e11c2d97237558`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/agent_outputs/agent_runs.json` (`4dd8672d7dfe91f2b9bdeea16d0df69d11395fa3096c431ea33033a5dc95ca48`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/agent_outputs/batch_source_contract.json` (`7b946c2a9794a673acc69e1d657a4e46f99d38880d0bf9cd1652eb49ee59a332`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/agent_outputs/blind_translation.json` (`a4ca0fb48066e8a14daf3f130bf11836a80794252f2e39cb218cee14cf2555c1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/agent_outputs/direct_judge.json` (`ba3d697c81876d41176390a02b22e95d864b0eb538b13e8700918f67cb2b93b3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/agent_outputs/roundtrip_judge.json` (`fba11c845082e1508969e2dc580e5ff2f6e78ef41932a14e980929c486ca70b3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/agent_outputs/source_contract.json` (`d3244e8d2499f0ce633a3fbc86012d50ceb4ae5baf5c59a0ecb159a29ab26972`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/inputs/batch_source_locator.json` (`0b272037292776c34f1e8ce621cd97c98da8f329dfed4995fa0bb0b41b55aa6f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/inputs/blind_dependency_inventory.json` (`96e9c51e7ec4ced2f76cc593ac3eab684c8d7b88f130a9bf7136001052be1bea`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/inputs/blind_dossier.md` (`f148817fe356eaf95035804a81932089d5e7772e14213c5246716a690fa296b1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/inputs/blind_review_packet.md` (`f148817fe356eaf95035804a81932089d5e7772e14213c5246716a690fa296b1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/inputs/declaration_dossier.md` (`7b5ac9b1f8291edf2e7ff1fcb21ed0022d49c37031be6a0f8cef257bc9256d9f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/inputs/dependency_inventory.json` (`cb9ed41c837d3cef3e85b879e3ea581d789624b1ac03d672e919b2b4b28a6f8d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/inputs/direct_review_packet.md` (`765e955c28d3dd51082b037fd4a9b0409704133c6cf4fcd904d62ea065268280`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/history/20260901T130306Z/inputs/source_locator.json` (`9b7205e7ce53cb9a6569f8097f123bb4a30b2292430473f4b4e11c2d97237558`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/inputs/blind_dependency_inventory.json` (`2eef2a2488d3a04a909ae4a7caff89f361f61039523eb6d63515155f34642132`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/inputs/blind_dossier.md` (`addc3a9fc80d9b6cbb970def7ccca41c2a2433e86a2fbb82c593fb8887f3822b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/inputs/blind_review_packet.md` (`addc3a9fc80d9b6cbb970def7ccca41c2a2433e86a2fbb82c593fb8887f3822b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/inputs/declaration_dossier.md` (`d470b184f8e840c00615f10fbde964f5d471115157f99588c3d4f0d22ee98695`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/inputs/dependency_inventory.json` (`550ad235fa8b97b08e8c30d9f2e7f265780275eee47f23075b916a10380019e7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/inputs/direct_review_packet.md` (`17ea8330eb41eb5b20a4e78704e47b9f78eef645a011c2e6aaefdafda5589e20`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE/faithfulness/inputs/source_locator.json` (`9b7205e7ce53cb9a6569f8097f123bb4a30b2292430473f4b4e11c2d97237558`)
