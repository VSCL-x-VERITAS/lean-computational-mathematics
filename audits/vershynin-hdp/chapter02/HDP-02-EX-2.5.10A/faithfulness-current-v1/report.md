# Faithfulness audit: HDP-02-EX-2.5.10A

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `c321b26e4764f08a80eceee1f66ed78841bb9da99dddeafc72d1af47d9890783`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The repaired target faithfully formalizes Exercise 2.5.10's first countable-sequence estimate. In particular, the new explicit a.e.-finiteness conjunct closes the prior semantic hazard from ENNReal.toReal mapping infinity to zero: together with integrability, it ensures that the real integrand is almost everywhere the actual finite countable weighted supremum. Nat indexing is correctly shifted by i+1, K is represented as the countable supremum of the exact psi-two gauges, one positive C is universal, and no independence, centering, attainment, or finite-N restriction is added.

## Implications

- **Lean implies source:** `yes`. Map source index j>=1 to Lean index i=j-1. The finite ENNReal iSup gauge is K, the a.e.-finite iSup is the source weighted countable maximum, integrability gives its genuine expectation, and the final conjunct is exactly the source inequality with one absolute C.
- **Source implies lean:** `yes`. Under the source's standard mathematically meaningful reading of its countable max symbols as suprema and K as the finite uniform psi-two bound used in the real expression CK, the displayed finite expectation bound implies the nonnegative supremum is finite almost surely and integrable. Thus it supplies the repaired conjuncts and the Lean inequality without adding independence, centering, attainment, or a finite cutoff.

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

## Dependency coverage

- Blind translator covered `96` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `96` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/agent_runs.json` (`bfa0ce7eeeb14f393f61af9038716fb06e7ef0bbcddbf80c0fcd0edbf43f5531`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/blind_translation.json` (`e634873ff4bd17e6b09afc70be0c31f3576178411a277ce6ff30ea131d6574b0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/direct_judge.json` (`7b44c76cc8d82b7c414549656ece6fe007c031109ae1a8fd9fac4ce98ebb69a0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`20986890ad8f983d81732accac766a9a660c9ad33fecf48c191d613e0a8440f3`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/source_contract.json` (`938fa2056640b134bfa42c4af0f6fef08b6590b7697465b656fa6e69b3b7df31`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/decision.json` (`4f0433141d5b5c77c5f27237dbd45a39caa164a4567471e7c779f146711ba417`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/agent_outputs/adjudicator.json` (`5ab01c46f1482a9b8ee253315893efdde5cce9547a12ab7748b0e09eee5e8819`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/agent_outputs/agent_runs.json` (`ed01ed635312fd7bcee55ce050ac1fea7cbf30d4e913fa996612d626c5dfa120`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/agent_outputs/blind_translation.json` (`1b5f96e16b18fe7032bfe49fba5ebbfbbbaf9419b7e3bf9ac218484475d1d427`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/agent_outputs/direct_judge.json` (`a979397414500348da103875b1ebc56058608e58560c4ceeed880c169dd0b30f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/agent_outputs/roundtrip_judge.json` (`817f4b4fffc1882bd998edbf474f9b0ccc541b4392b5ebf9555b15f8b8614b6f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/agent_outputs/source_contract.json` (`5723f4ccf75dc6a5fdce26d5711e2dedb913f9495dfadeda1622d0cb7e3cc904`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/decision.json` (`1c29444836f8fa11b57dd64bd744e1cecd69151661fe4ec9288a9a332b937a89`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/inputs/blind_dependency_inventory.json` (`c307a36b46bd192da39cdd59a9f9e32dc1913e7b5a6c763793696b2529570a37`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/inputs/blind_dossier.md` (`52a609adcc759789515d8423ce3bfae60450bdfe3ebbd36e18a17c72e1566e85`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/inputs/blind_review_packet.md` (`52a609adcc759789515d8423ce3bfae60450bdfe3ebbd36e18a17c72e1566e85`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/inputs/declaration_dossier.md` (`e7a300e63f520ad1c74ecdf75a41ab893821d8e0ec36ed32ca9ebcaa764c1427`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/inputs/dependency_inventory.json` (`c5b2e97e86eb5bb74f915324ab84ef48dfd4f326cdeb2034744792c450e33a9a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/inputs/direct_review_packet.md` (`7c78fec2fca68bba17a6db4c436fc08e813cc73eb8726403182d910dbca7dfac`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/history/20260910T101111Z/inputs/source_locator.json` (`979b76ec3a562b9b8fa8726bd6e62ab2e0961c9709870ae660994f60acd8ebff`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`478fa2ef2c6d6af18ec11b4beff89877c48a37d74b659c33931d2e610f980652`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/blind_dossier.md` (`3d4d4ce1c964e55bc4b384305d2f22bf07a2d9aecec9d35cd144899c91e596e4`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/blind_review_packet.md` (`3d4d4ce1c964e55bc4b384305d2f22bf07a2d9aecec9d35cd144899c91e596e4`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/declaration_dossier.md` (`a208ad276aecd17c5d2b8519290168a5eb3c8a89fce65e00e7fc3a826d328339`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/dependency_inventory.json` (`b48ea95e01f48187d81bc4b2340086a0623c5b91db040077f849a2ee1b8f533e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/direct_review_packet.md` (`fecb01093db6f135b27715964203ca91f59082d12c1d6c80c5b1b6ee36120743`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/source_locator.json` (`979b76ec3a562b9b8fa8726bd6e62ab2e0961c9709870ae660994f60acd8ebff`)
