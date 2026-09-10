# Faithfulness audit: HDP-02-EXAMPLE-2.7.13

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `94ee33826bed0684739f46bc19f59106923984dd5a0ecfcd60ff60f153a12a80`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The apparent judge conflict is entirely an information-boundary artifact. In the pinned Mathlib revision, IsProbabilityMeasure is exactly total mass one, the condition needed to convert the Orlicz threshold 1 for exp(x^2)-1 into the exponential-moment threshold 2. Nat.AtLeastTwo only supports elaboration of the literal 2 and imposes no source-level restriction. With these definitions exposed, all four unclear checklist items pass, both implications hold, and the target is faithfully equivalent to Example 2.7.13.

## Implications

- **Lean implies source:** `yes`. The bundled psiTwoOrliczFunction certifies every Orlicz-function property used by the source. For each measurable real X and positive finite scale, abs(X)^2=X^2 and IsProbabilityMeasure gives mu(univ)=1, so the Orlicz threshold integral of exp(X^2/t^2)-1 being at most 1 is equivalent to the integrable exponential moment being at most 2. Thus the target's exact gauge equality and finite-membership iff recover all parts of Example 2.7.13.
- **Source implies lean:** `yes`. A source random variable is measurable, and its probability space yields an IsProbabilityMeasure instance semantically. The source explicitly asserts the exact equality of the two infimum gauges and that finite Orlicz norm is equivalent to sub-gaussianity as defined by equation (2.13), which are exactly the equality and iff in D001.

## Findings

No findings were recorded.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `unclear` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `129` dependencies (`0` hash-reused); unclear: `D026, D125`.
- Direct judge covered `129` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/agent_outputs/adjudicator.json` (`1571c93c5b739a2e32d477d90bffbb83039ba18b670dae9cf94f26237e052042`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/agent_outputs/agent_runs.json` (`e63a6a8686a8c531aa9d7a314fb1abfc8a379081f447384ced90c18e80e3ece1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/agent_outputs/blind_translation.json` (`4f78cf5a93b57781f533bd63d15afc3d8221177032189e26e8d5f239a19378be`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/agent_outputs/direct_judge.json` (`97094878399b89f4bd125c7ac73f42d8c9e9bf9609df3456799a10c202baf040`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`59c7b203c098de76b813130e6c85a863d1468a0376bb20f615d84004009d1d9c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/agent_outputs/source_contract.json` (`d0ea6e611a9bc0675d314425404d6b2997445e0a9d4e1335b3ea92904ff0c1a5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/decision.json` (`5e0641dad4c57f3afd7f34dac7f39c1aa17fadae34289a64b58df8db612fb5e9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T212307Z/inputs/blind_dependency_inventory.json` (`ac67ff17f6b4a9216de0baa44c3e388515a62d2b1fb23d95081dd0d090cd1019`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T212307Z/inputs/blind_dossier.md` (`424df5c4caa257cb1f8e268c628a6c91b966217e3415b31d7c22abbc9e561944`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T212307Z/inputs/blind_review_packet.md` (`424df5c4caa257cb1f8e268c628a6c91b966217e3415b31d7c22abbc9e561944`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T212307Z/inputs/declaration_dossier.md` (`2a961b016b1d188dbc1cedab71a2bf60719834e62f7d4f5075b4cc39beb8a30c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T212307Z/inputs/dependency_inventory.json` (`ce68b433c146634313df49a4513ae6355eb33b31fdd8e22291e3b2cfbf5bd5d9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T212307Z/inputs/direct_review_packet.md` (`eda083241d9aa154a801ac1cdd19b2c794921b296ae0596a7b7f5eb1c9885924`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T212307Z/inputs/source_locator.json` (`89776543484f7430f90d4e90a50bf6c3252999a3ad9c885c088b49b3938d82c8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/agent_outputs/agent_runs.json` (`ec50e2d51ee29bee1158c823ad05337d6c070e7297227317cd5132331f810d51`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/agent_outputs/blind_translation.json` (`4f78cf5a93b57781f533bd63d15afc3d8221177032189e26e8d5f239a19378be`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/agent_outputs/direct_judge.json` (`97094878399b89f4bd125c7ac73f42d8c9e9bf9609df3456799a10c202baf040`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/agent_outputs/roundtrip_judge.json` (`59c7b203c098de76b813130e6c85a863d1468a0376bb20f615d84004009d1d9c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/agent_outputs/source_contract.json` (`d0ea6e611a9bc0675d314425404d6b2997445e0a9d4e1335b3ea92904ff0c1a5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/inputs/blind_dependency_inventory.json` (`23a6a7048c1b27cb8633b3b3d9ad256b11d6f4a44739fa833d3fe6a0b250a46b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/inputs/blind_dossier.md` (`47734c9dd6922d703bcf861425dac99dea16d8a74b9625b4c16c750189a4c809`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/inputs/blind_review_packet.md` (`47734c9dd6922d703bcf861425dac99dea16d8a74b9625b4c16c750189a4c809`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/inputs/declaration_dossier.md` (`7e47e5d7840ed30bc210a3f527772736c517aef1d725d296dbbcc96e3d6faa20`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/inputs/dependency_inventory.json` (`6d2525ec5f5d3af815cd12e9aca614592242aa7d36b5be295ecfec9b3a8da1b5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/inputs/direct_review_packet.md` (`3a08deea2e619481f86a033d695e7341bafd74b47de7149cab28e9a7e32bf76e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/history/20260910T215218Z/inputs/source_locator.json` (`89776543484f7430f90d4e90a50bf6c3252999a3ad9c885c088b49b3938d82c8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`23a6a7048c1b27cb8633b3b3d9ad256b11d6f4a44739fa833d3fe6a0b250a46b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/inputs/blind_dossier.md` (`47734c9dd6922d703bcf861425dac99dea16d8a74b9625b4c16c750189a4c809`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/inputs/blind_review_packet.md` (`47734c9dd6922d703bcf861425dac99dea16d8a74b9625b4c16c750189a4c809`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/inputs/declaration_dossier.md` (`b715117ecfc4b01832ff697e734494d77f288337baf5caa951ff846147106914`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/inputs/dependency_inventory.json` (`6d2525ec5f5d3af815cd12e9aca614592242aa7d36b5be295ecfec9b3a8da1b5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/inputs/direct_review_packet.md` (`3a08deea2e619481f86a033d695e7341bafd74b47de7149cab28e9a7e32bf76e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EXAMPLE-2.7.13/faithfulness-current-v1/inputs/source_locator.json` (`89776543484f7430f90d4e90a50bf6c3252999a3ad9c885c088b49b3938d82c8`)
