# Faithfulness audit: HDP-02-COR-2.8.3

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `75f95d4891e3ba80a9ff155b4501f1e08172d525dd278570ec40a7c39c3fe3c5`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The pinned PDF hash matches the specified SHA-256. Corollary 2.8.3 states the two-sided concentration inequality for the arithmetic average with a positive absolute constant, exact prefactor 2, branches t²/K² and t/K, and N multiplying the minimum. The target matches this exactly for every K > 0 and uses nonempty finite indexing, so its reciprocal-cardinality normalization never divides by zero. The sole consequential difference is that Lean's real division gives definite zero values to the rate quotients when K = 0, producing right-hand side 2, while the source neither excludes K = 0 nor supplies a convention for those fractions. Adopting any source value would silently repair the printed notation. Both complete-domain implications therefore remain unclear, the classification remains undetermined, and the audit is not accepted.

## Implications

- **Lean implies source:** `unclear`. Yes on the exact nondegenerate core K > 0, including t = 0 there. The positive family cardinality makes 1/N unproblematic. On K = 0, Lean assigns zero to both rate quotients, whereas the source supplies no boundary convention, so the whole-domain implication cannot be asserted without silently repairing the source.
- **Source implies lean:** `unclear`. Yes on K > 0: the source and Lean statements then coincide after finite reindexing, and the source assumptions support the explicit formal regularity conditions. On K = 0, the source expression has no stipulated value and therefore cannot entail Lean's totalized bound without an added convention.

## Findings

- **major / source-silent-boundary-semantics:** The target chooses definite K = 0 semantics absent from the source, preventing certification of either full implication.
- **note / nondegenerate-core:** The formalization is equivalent to the source throughout the substantive nondegenerate domain.
- **note / average-normalization:** D054 introduces no discrepancy in the average; the only unresolved denominator is K.
- **note / threshold-boundary:** The threshold t = 0 alone is not a discrepancy.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `unclear` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `97` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `97` dependencies (`0` hash-reused); failing or unclear: `D053, D054`.

## Remaining uncertainties

- The pinned source does not define t²/K² or t/K when K = 0. No whole-domain implication or accepted classification can be obtained without adopting an extra division or limiting convention.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/agent_outputs/adjudicator.json` (`a4fac3f205f4a487c1b6713d518b1d667bfbcfb35e133f5feae5c5832f4c3cb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/agent_outputs/agent_runs.json` (`eab893d97580e3785178fedc0c89259b8cada2d5204c0400e71caa992e32da69`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/agent_outputs/blind_translation.json` (`8e19239f8f1f5860301edb8bdec30fbbd334aed7434039e54c4008bff3567ae1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/agent_outputs/direct_judge.json` (`3742ccadbe46924d6399c5375e24a0bc830cde0a7c67d62da4ad816a49d0a3f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/agent_outputs/roundtrip_judge.json` (`0b24a25c10660f272fa0597926ebeb3d16327eb78d97e2be26ae91d542dd9517`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/decision.json` (`640d4f241aef4022186c0b1062a61ecabd5f400eeb45ba5b4245ceacf5a259d8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T024636Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T024636Z/inputs/blind_dependency_inventory.json` (`33550c50c7039c9d4edebaf45a382be58cbbdbe3ce51cdd67963105c7685cb0e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T024636Z/inputs/blind_dossier.md` (`5cdda78a7de975e2d77860923410ad18d803b206e5f0600538624fa7359ee326`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T024636Z/inputs/blind_review_packet.md` (`5cdda78a7de975e2d77860923410ad18d803b206e5f0600538624fa7359ee326`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T024636Z/inputs/declaration_dossier.md` (`011b0a28ad3e2b1e0bea6b9acafb9f98fb43ccabd9f973f9678cf911d327d694`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T024636Z/inputs/dependency_inventory.json` (`1f71d085ef0ac97daf8de6080e98295c4604590bc9347d92a35b0772ec38c156`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T024636Z/inputs/direct_review_packet.md` (`02568291fa744becce305f35eaeb005ddf1dd5ac1d1b9ac32226f2f47e42076e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T024636Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T030220Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T030220Z/inputs/blind_dependency_inventory.json` (`33550c50c7039c9d4edebaf45a382be58cbbdbe3ce51cdd67963105c7685cb0e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T030220Z/inputs/blind_dossier.md` (`5cdda78a7de975e2d77860923410ad18d803b206e5f0600538624fa7359ee326`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T030220Z/inputs/blind_review_packet.md` (`5cdda78a7de975e2d77860923410ad18d803b206e5f0600538624fa7359ee326`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T030220Z/inputs/declaration_dossier.md` (`011b0a28ad3e2b1e0bea6b9acafb9f98fb43ccabd9f973f9678cf911d327d694`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T030220Z/inputs/dependency_inventory.json` (`1f71d085ef0ac97daf8de6080e98295c4604590bc9347d92a35b0772ec38c156`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T030220Z/inputs/direct_review_packet.md` (`02568291fa744becce305f35eaeb005ddf1dd5ac1d1b9ac32226f2f47e42076e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T030220Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/agent_outputs/agent_runs.json` (`9a41d3ab047b4ef90d13d2016a40a9b2ec134a06e8c78f77a9ccc5911d552dfa`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/inputs/blind_dependency_inventory.json` (`33550c50c7039c9d4edebaf45a382be58cbbdbe3ce51cdd67963105c7685cb0e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/inputs/blind_dossier.md` (`5cdda78a7de975e2d77860923410ad18d803b206e5f0600538624fa7359ee326`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/inputs/blind_review_packet.md` (`5cdda78a7de975e2d77860923410ad18d803b206e5f0600538624fa7359ee326`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/inputs/declaration_dossier.md` (`011b0a28ad3e2b1e0bea6b9acafb9f98fb43ccabd9f973f9678cf911d327d694`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/inputs/dependency_inventory.json` (`1f71d085ef0ac97daf8de6080e98295c4604590bc9347d92a35b0772ec38c156`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/inputs/direct_review_packet.md` (`02568291fa744becce305f35eaeb005ddf1dd5ac1d1b9ac32226f2f47e42076e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T221507Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/agent_outputs/agent_runs.json` (`0ac6ccafa0c20f7f3a51239db680ac65deb3a95f41e39136d94131ffe3f60ae3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/inputs/blind_dependency_inventory.json` (`759bb54a11f6eb22b93d5887b05495d77daa687b64135d36cada78c0335ce439`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/inputs/blind_dossier.md` (`5a10830caaed2ab1d5f945cb76e88d49096e9b5aa86d231ee1ada0328f88a5d5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/inputs/blind_review_packet.md` (`5a10830caaed2ab1d5f945cb76e88d49096e9b5aa86d231ee1ada0328f88a5d5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/inputs/declaration_dossier.md` (`dafaf2ebed9d5d5ac0f14fde39420e95ca9628b33ac53e54af3c2a26446cbec1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/inputs/dependency_inventory.json` (`d1cb9730cd1c6fede8561c053818100dc9f2e274d26877c1e9a21c7b1c3d21af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/inputs/direct_review_packet.md` (`e3c626c50589bed49bcf8dd3e595b609f245c4d50f6f8fa68cf861f1097185ef`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260828T230029Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T002848Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T002848Z/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T002848Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T002848Z/inputs/blind_dependency_inventory.json` (`759bb54a11f6eb22b93d5887b05495d77daa687b64135d36cada78c0335ce439`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T002848Z/inputs/blind_dossier.md` (`5a10830caaed2ab1d5f945cb76e88d49096e9b5aa86d231ee1ada0328f88a5d5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T002848Z/inputs/blind_review_packet.md` (`5a10830caaed2ab1d5f945cb76e88d49096e9b5aa86d231ee1ada0328f88a5d5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T002848Z/inputs/declaration_dossier.md` (`dafaf2ebed9d5d5ac0f14fde39420e95ca9628b33ac53e54af3c2a26446cbec1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T002848Z/inputs/dependency_inventory.json` (`d1cb9730cd1c6fede8561c053818100dc9f2e274d26877c1e9a21c7b1c3d21af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T002848Z/inputs/direct_review_packet.md` (`e3c626c50589bed49bcf8dd3e595b609f245c4d50f6f8fa68cf861f1097185ef`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T002848Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/agent_outputs/agent_runs.json` (`0ac6ccafa0c20f7f3a51239db680ac65deb3a95f41e39136d94131ffe3f60ae3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/inputs/blind_dependency_inventory.json` (`759bb54a11f6eb22b93d5887b05495d77daa687b64135d36cada78c0335ce439`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/inputs/blind_dossier.md` (`5a10830caaed2ab1d5f945cb76e88d49096e9b5aa86d231ee1ada0328f88a5d5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/inputs/blind_review_packet.md` (`5a10830caaed2ab1d5f945cb76e88d49096e9b5aa86d231ee1ada0328f88a5d5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/inputs/declaration_dossier.md` (`dafaf2ebed9d5d5ac0f14fde39420e95ca9628b33ac53e54af3c2a26446cbec1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/inputs/dependency_inventory.json` (`d1cb9730cd1c6fede8561c053818100dc9f2e274d26877c1e9a21c7b1c3d21af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/inputs/direct_review_packet.md` (`e3c626c50589bed49bcf8dd3e595b609f245c4d50f6f8fa68cf861f1097185ef`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T014629Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/agent_outputs/agent_runs.json` (`0ac6ccafa0c20f7f3a51239db680ac65deb3a95f41e39136d94131ffe3f60ae3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/inputs/blind_dependency_inventory.json` (`759bb54a11f6eb22b93d5887b05495d77daa687b64135d36cada78c0335ce439`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/inputs/blind_dossier.md` (`5a10830caaed2ab1d5f945cb76e88d49096e9b5aa86d231ee1ada0328f88a5d5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/inputs/blind_review_packet.md` (`5a10830caaed2ab1d5f945cb76e88d49096e9b5aa86d231ee1ada0328f88a5d5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/inputs/declaration_dossier.md` (`dafaf2ebed9d5d5ac0f14fde39420e95ca9628b33ac53e54af3c2a26446cbec1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/inputs/dependency_inventory.json` (`d1cb9730cd1c6fede8561c053818100dc9f2e274d26877c1e9a21c7b1c3d21af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/inputs/direct_review_packet.md` (`e3c626c50589bed49bcf8dd3e595b609f245c4d50f6f8fa68cf861f1097185ef`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T021246Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/agent_outputs/adjudicator.json` (`a4fac3f205f4a487c1b6713d518b1d667bfbcfb35e133f5feae5c5832f4c3cb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/agent_outputs/agent_runs.json` (`32da4492ef66755f36e5c4d5abe5a183700d1e4740d1ffac6144650d95bd1851`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/agent_outputs/blind_translation.json` (`8e19239f8f1f5860301edb8bdec30fbbd334aed7434039e54c4008bff3567ae1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/agent_outputs/direct_judge.json` (`3742ccadbe46924d6399c5375e24a0bc830cde0a7c67d62da4ad816a49d0a3f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/agent_outputs/roundtrip_judge.json` (`0b24a25c10660f272fa0597926ebeb3d16327eb78d97e2be26ae91d542dd9517`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/decision.json` (`ce7551a8084f357d5ba6b0c16f3baafd53d8c2bc043df5bc1bee7c67f47cfd4a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/inputs/blind_dependency_inventory.json` (`759bb54a11f6eb22b93d5887b05495d77daa687b64135d36cada78c0335ce439`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/inputs/blind_dossier.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/inputs/blind_review_packet.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/inputs/declaration_dossier.md` (`6c8b26fc61ae8effa731f506d41044e9337203aa96f9045ee4e87e0f9923fed5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/inputs/dependency_inventory.json` (`d1cb9730cd1c6fede8561c053818100dc9f2e274d26877c1e9a21c7b1c3d21af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/inputs/direct_review_packet.md` (`184ce1d40573c526169a7afefbcc7e567b908a561c648f8ca23f7b8a625d8cc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T023453Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/agent_outputs/adjudicator.json` (`a4fac3f205f4a487c1b6713d518b1d667bfbcfb35e133f5feae5c5832f4c3cb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/agent_outputs/agent_runs.json` (`32da4492ef66755f36e5c4d5abe5a183700d1e4740d1ffac6144650d95bd1851`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/agent_outputs/blind_translation.json` (`8e19239f8f1f5860301edb8bdec30fbbd334aed7434039e54c4008bff3567ae1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/agent_outputs/direct_judge.json` (`3742ccadbe46924d6399c5375e24a0bc830cde0a7c67d62da4ad816a49d0a3f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/agent_outputs/roundtrip_judge.json` (`0b24a25c10660f272fa0597926ebeb3d16327eb78d97e2be26ae91d542dd9517`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/decision.json` (`44af861de642e41d244270d8d5784265b42c9d143fa662beef58ff7a1d0c8f1a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/inputs/blind_dependency_inventory.json` (`759bb54a11f6eb22b93d5887b05495d77daa687b64135d36cada78c0335ce439`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/inputs/blind_dossier.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/inputs/blind_review_packet.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/inputs/declaration_dossier.md` (`6c8b26fc61ae8effa731f506d41044e9337203aa96f9045ee4e87e0f9923fed5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/inputs/dependency_inventory.json` (`d1cb9730cd1c6fede8561c053818100dc9f2e274d26877c1e9a21c7b1c3d21af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/inputs/direct_review_packet.md` (`184ce1d40573c526169a7afefbcc7e567b908a561c648f8ca23f7b8a625d8cc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260829T031511Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/agent_outputs/adjudicator.json` (`a4fac3f205f4a487c1b6713d518b1d667bfbcfb35e133f5feae5c5832f4c3cb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/agent_outputs/agent_runs.json` (`32da4492ef66755f36e5c4d5abe5a183700d1e4740d1ffac6144650d95bd1851`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/agent_outputs/blind_translation.json` (`8e19239f8f1f5860301edb8bdec30fbbd334aed7434039e54c4008bff3567ae1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/agent_outputs/direct_judge.json` (`3742ccadbe46924d6399c5375e24a0bc830cde0a7c67d62da4ad816a49d0a3f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/agent_outputs/roundtrip_judge.json` (`0b24a25c10660f272fa0597926ebeb3d16327eb78d97e2be26ae91d542dd9517`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/decision.json` (`7e95d6710a9e7cf556918d4df38f2a10ccafcbcf62f86ca98b0877ef0d634476`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/inputs/blind_dependency_inventory.json` (`759bb54a11f6eb22b93d5887b05495d77daa687b64135d36cada78c0335ce439`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/inputs/blind_dossier.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/inputs/blind_review_packet.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/inputs/declaration_dossier.md` (`df7514f90bb82ad1db037b43221b9b6290c71836b98f7f00092b2e72cb70d2a8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/inputs/dependency_inventory.json` (`d1cb9730cd1c6fede8561c053818100dc9f2e274d26877c1e9a21c7b1c3d21af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/inputs/direct_review_packet.md` (`184ce1d40573c526169a7afefbcc7e567b908a561c648f8ca23f7b8a625d8cc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T083044Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/agent_outputs/adjudicator.json` (`a4fac3f205f4a487c1b6713d518b1d667bfbcfb35e133f5feae5c5832f4c3cb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/agent_outputs/agent_runs.json` (`eab893d97580e3785178fedc0c89259b8cada2d5204c0400e71caa992e32da69`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/agent_outputs/blind_translation.json` (`8e19239f8f1f5860301edb8bdec30fbbd334aed7434039e54c4008bff3567ae1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/agent_outputs/direct_judge.json` (`3742ccadbe46924d6399c5375e24a0bc830cde0a7c67d62da4ad816a49d0a3f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/agent_outputs/roundtrip_judge.json` (`0b24a25c10660f272fa0597926ebeb3d16327eb78d97e2be26ae91d542dd9517`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/decision.json` (`2afeb9f1204cb983ed65c684372d8971cbe3615a94076a6a192f903b4fe03dda`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/inputs/blind_dependency_inventory.json` (`759bb54a11f6eb22b93d5887b05495d77daa687b64135d36cada78c0335ce439`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/inputs/blind_dossier.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/inputs/blind_review_packet.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/inputs/declaration_dossier.md` (`662297e53234f5846851dfd46a0cf69bcfb62cc93f6b1f3f261b659b078487e3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/inputs/dependency_inventory.json` (`d1cb9730cd1c6fede8561c053818100dc9f2e274d26877c1e9a21c7b1c3d21af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/inputs/direct_review_packet.md` (`184ce1d40573c526169a7afefbcc7e567b908a561c648f8ca23f7b8a625d8cc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T100953Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/agent_outputs/adjudicator.json` (`a4fac3f205f4a487c1b6713d518b1d667bfbcfb35e133f5feae5c5832f4c3cb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/agent_outputs/agent_runs.json` (`eab893d97580e3785178fedc0c89259b8cada2d5204c0400e71caa992e32da69`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/agent_outputs/blind_translation.json` (`8e19239f8f1f5860301edb8bdec30fbbd334aed7434039e54c4008bff3567ae1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/agent_outputs/direct_judge.json` (`3742ccadbe46924d6399c5375e24a0bc830cde0a7c67d62da4ad816a49d0a3f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/agent_outputs/roundtrip_judge.json` (`0b24a25c10660f272fa0597926ebeb3d16327eb78d97e2be26ae91d542dd9517`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/agent_outputs/source_contract.json` (`adcf5c0ac2bc92ed2d61a29b98c10a9bcf516883ecd3ca385db613fd673045a6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/decision.json` (`ce9bbdb0e3ce4f2f6480552bba90daa6946821303ab6cfeff5a5f2015dcccb46`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/inputs/blind_dependency_inventory.json` (`759bb54a11f6eb22b93d5887b05495d77daa687b64135d36cada78c0335ce439`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/inputs/blind_dossier.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/inputs/blind_review_packet.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/inputs/declaration_dossier.md` (`8e9d39afea564618f09e4740c92c7747f09ab8ce2febda047d20c99a8d604311`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/inputs/dependency_inventory.json` (`d1cb9730cd1c6fede8561c053818100dc9f2e274d26877c1e9a21c7b1c3d21af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/inputs/direct_review_packet.md` (`184ce1d40573c526169a7afefbcc7e567b908a561c648f8ca23f7b8a625d8cc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/history/20260831T203207Z/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/inputs/blind_dependency_inventory.json` (`759bb54a11f6eb22b93d5887b05495d77daa687b64135d36cada78c0335ce439`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/inputs/blind_dossier.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/inputs/blind_review_packet.md` (`a68c1bb15a193f6c1e0cc2f8e9fa260afc0cc226b8e3888400898fe1e9cfb754`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/inputs/declaration_dossier.md` (`b470f13469af3e3bba3dfd108886a9614ed5c45e876bf88fac59f9ae589289a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/inputs/dependency_inventory.json` (`d1cb9730cd1c6fede8561c053818100dc9f2e274d26877c1e9a21c7b1c3d21af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/inputs/direct_review_packet.md` (`184ce1d40573c526169a7afefbcc7e567b908a561c648f8ca23f7b8a625d8cc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3/faithfulness/inputs/source_locator.json` (`7fb17f864cf711e03c31293ec98ee4288ad7ac4b8dae0097ce875ce4e0b3d8f6`)
