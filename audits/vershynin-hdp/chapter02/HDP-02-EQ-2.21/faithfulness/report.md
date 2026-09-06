# Faithfulness audit: HDP-02-EQ-2.21

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `ff8235ddf5867c404b946b323c3d4b65fc5de4dec0048576d64fbd5a6f2279b3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The judges agree that the target specializes to the exact source display, including the infimum, positive scale, exponential moment, and threshold 2. Their only disagreement is whether values assigned outside the source's intended domain count as genuine strength. They do not here: the target is a definitional equality whose left-hand side is defined by the right-hand side, so its wider quantification asserts no extra property of arbitrary measures or functions. In the inherited source context, the admissible set is nonempty and finite nonzero ENNReal scales represent precisely positive real scales. Accordingly Lean implies source and source implies Lean for the audited source claim, yielding faithful-equivalent and acceptance.

## Implications

- **Lean implies source:** `yes`. Specializing the universal Lean equality to the source probability law and sub-exponential real random variable gives display (2.21): admissible ENNReal scales are finite and nonzero, hence correspond order-preservingly to positive real scales, and the integral condition is the source expectation condition.
- **Source implies lean:** `yes`. On every source instance, display (2.21) gives the same equality after the positive-real/finite-ENNReal identification and the source context supplies measurability, integrability, and nonemptiness. The target's additional arbitrary instances impose no further semantic claim: both sides are definitionally the same sInf there, so the totalized cases add no genuine nonvacuous strength beyond the source definition.

## Findings

- **note / conservative-definitional-totalization:** Arbitrary-measure and empty-set cases are formal totalization outside the source domain, not a one-way substantive strengthening; both implication directions remain yes.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `fail` |
| `C04` | `pass` | `fail` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `62` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `62` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/agent_outputs/adjudicator.json` (`2592814f66c2542a6c82efbb2ef6315e35c6c1f998022aa8278a05ce5053da8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/agent_outputs/agent_runs.json` (`8de026a654610c64f1fe3230c0beef16653bca2568e83f6299a9f3f1db76e103`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/agent_outputs/batch_source_contract.json` (`4ebe1af4c0627a3d03ad37d2e0f49d55aa03c0529180ace45df3de42da8b70b0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/agent_outputs/blind_translation.json` (`cc00a6ea742066fc429de511a0e1cb5a25a5d2527d069bd617d2c5402bc281bd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/agent_outputs/direct_judge.json` (`5bafe2b1b3cb71d3e844c04b36ff0a36274ca2e700b7144c287268c7246e7201`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/agent_outputs/roundtrip_judge.json` (`d6117f9b7640f9b56489b731648dcfbf8a32677cd9efd0a9682de4ef190806ac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/agent_outputs/source_contract.json` (`1c8599ab0a6cbf9712f72a49457855e97e6a0829438b0f3a98007374982450ad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/decision.json` (`238e0d908b2d2ac68b9945f7774967d09bc1c376b442210457bcccf917126508`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/agent_outputs/adjudicator.json` (`2592814f66c2542a6c82efbb2ef6315e35c6c1f998022aa8278a05ce5053da8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/agent_outputs/agent_runs.json` (`e51f83f5806b288a10150faf81b9706cd7a63cbb771cc30c9ed451aec03e0096`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/agent_outputs/batch_source_contract.json` (`4ebe1af4c0627a3d03ad37d2e0f49d55aa03c0529180ace45df3de42da8b70b0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/agent_outputs/blind_translation.json` (`cc00a6ea742066fc429de511a0e1cb5a25a5d2527d069bd617d2c5402bc281bd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/agent_outputs/direct_judge.json` (`5bafe2b1b3cb71d3e844c04b36ff0a36274ca2e700b7144c287268c7246e7201`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/agent_outputs/roundtrip_judge.json` (`d6117f9b7640f9b56489b731648dcfbf8a32677cd9efd0a9682de4ef190806ac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/agent_outputs/source_contract.json` (`1c8599ab0a6cbf9712f72a49457855e97e6a0829438b0f3a98007374982450ad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/decision.json` (`c85cf89c083341c24c75bd09e0d2ab0bc1ce2aa244c5263af4d334b055541a12`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/inputs/batch_source_locator.json` (`71ac7c8fdc2c77a852751bf33b7ed201d5c8832272eb22e99a2e37ce5786de30`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/inputs/blind_dependency_inventory.json` (`76fce1e91aca6ffc74a50f674043533b896cad170fea5740db0602543ec13781`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/inputs/blind_dossier.md` (`13d5b016124bf71200ac41d75d1f428ae812424d1890ca35d1166933379154ce`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/inputs/blind_review_packet.md` (`13d5b016124bf71200ac41d75d1f428ae812424d1890ca35d1166933379154ce`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/inputs/declaration_dossier.md` (`6569abe5b2da14312d560cc62bde7e836c861860aca49d9a94f84ab8847400d5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/inputs/dependency_inventory.json` (`73ebb0b449d0eacdc7dbbc7de70c88fe76b841a250df65a1161752cd9be64fa3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/inputs/direct_review_packet.md` (`8be4e1acafbfa07c568b22a247b2b8138d25b23ac20a6d44bf071e6ae44ca0d8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/history/20260831T204307Z/inputs/source_locator.json` (`e87a5442f1a26ef02b49755edeab9479aceae430bfb2aa35a40c000cdc2fe207`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/inputs/blind_dependency_inventory.json` (`76fce1e91aca6ffc74a50f674043533b896cad170fea5740db0602543ec13781`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/inputs/blind_dossier.md` (`13d5b016124bf71200ac41d75d1f428ae812424d1890ca35d1166933379154ce`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/inputs/blind_review_packet.md` (`13d5b016124bf71200ac41d75d1f428ae812424d1890ca35d1166933379154ce`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/inputs/declaration_dossier.md` (`ccb76f2822e39915d10370a462ea187050008bc48ab4a4c2fd8e8896d5d29d37`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/inputs/dependency_inventory.json` (`73ebb0b449d0eacdc7dbbc7de70c88fe76b841a250df65a1161752cd9be64fa3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/inputs/direct_review_packet.md` (`8be4e1acafbfa07c568b22a247b2b8138d25b23ac20a6d44bf071e6ae44ca0d8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.21/faithfulness/inputs/source_locator.json` (`e87a5442f1a26ef02b49755edeab9479aceae430bfb2aa35a40c000cdc2fe207`)
