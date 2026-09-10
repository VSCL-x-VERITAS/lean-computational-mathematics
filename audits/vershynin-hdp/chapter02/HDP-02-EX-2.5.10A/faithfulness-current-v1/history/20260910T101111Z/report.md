# Faithfulness audit: HDP-02-EX-2.5.10A

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `b2e996c230798ef27893cd0d8f387ddfa40532165e25039e6d82488d265b63aa`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The source and Lean agree on the common probability space, arbitrary dependence, absence of centering, universal positive constant, ψ₂ gauge, countable indexing, logarithmic weight, and inequality direction. The source's real K notation and its normalization by C K tacitly require a finite uniform scale, so Lean's explicit K<top premise is not an applicability defect. The decisive mismatch is instead on the left: Lean bounds the pointwise toReal conversion of an ENNReal supremum, which sends an infinite value to zero. Equality with the source maximal quantity would hold almost everywhere after establishing finiteness, but that finiteness is absent from the audited contract even if it was established internally by the proof. Thus the source claim implies the Lean contract, while the Lean contract does not state the full source claim; extra integrability is not genuine compensating strength because it follows from the source's finite expectation bound.

## Implications

- **Lean implies source:** `no`. The target type asserts only integrability and an expectation bound for Z(ω)=(logWeightedAbsSup X ω).toReal. Since toReal maps top to zero and the contract has no assertion that logWeightedAbsSup is finite almost everywhere, the target contract does not recover the source's expectation bound for the actual normalized supremum. A finiteness fact established only inside a proof is not part of the audited proposition.
- **Source implies lean:** `yes`. The source's real-valued K and its hint tacitly place the claim in the finite-uniform-scale setting used by Lean. A finite expectation bound for the actual nonnegative supremum entails its almost-everywhere finiteness and integrability. On that full-measure set ENNReal.toReal preserves the supremum, so the source claim yields both Lean's integrability conjunct and its inequality.

## Findings

- **major / missing-ae-finiteness-bridge:** The audited theorem statement bounds a transformed representative without stating the condition that makes it agree almost everywhere with the source maximal object, so the central source conclusion is not fully represented.
- **note / tacit-finite-uniform-scale:** The K<top premise makes a tacit source well-formedness condition explicit and is not reduced applicability.
- **note / countable-supremum-convention:** Reading the informal infinite max as a supremum is faithful and does not require attainment.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `fail` | `unclear` |
| `C05` | `fail` | `unclear` |
| `C06` | `fail` | `fail` |
| `C07` | `fail` | `unclear` |
| `C08` | `fail` | `fail` |
| `C09` | `pass` | `pass` |
| `C10` | `fail` | `unclear` |
| `C11` | `fail` | `fail` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `92` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `92` dependencies (`0` hash-reused); failing or unclear: `D001, D003, D013, D017, D042, D046`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/adjudicator.json` (`5ab01c46f1482a9b8ee253315893efdde5cce9547a12ab7748b0e09eee5e8819`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/agent_runs.json` (`ed01ed635312fd7bcee55ce050ac1fea7cbf30d4e913fa996612d626c5dfa120`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/blind_translation.json` (`1b5f96e16b18fe7032bfe49fba5ebbfbbbaf9419b7e3bf9ac218484475d1d427`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/direct_judge.json` (`a979397414500348da103875b1ebc56058608e58560c4ceeed880c169dd0b30f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`817f4b4fffc1882bd998edbf474f9b0ccc541b4392b5ebf9555b15f8b8614b6f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/agent_outputs/source_contract.json` (`5723f4ccf75dc6a5fdce26d5711e2dedb913f9495dfadeda1622d0cb7e3cc904`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/decision.json` (`1c29444836f8fa11b57dd64bd744e1cecd69151661fe4ec9288a9a332b937a89`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`c307a36b46bd192da39cdd59a9f9e32dc1913e7b5a6c763793696b2529570a37`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/blind_dossier.md` (`52a609adcc759789515d8423ce3bfae60450bdfe3ebbd36e18a17c72e1566e85`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/blind_review_packet.md` (`52a609adcc759789515d8423ce3bfae60450bdfe3ebbd36e18a17c72e1566e85`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/declaration_dossier.md` (`e7a300e63f520ad1c74ecdf75a41ab893821d8e0ec36ed32ca9ebcaa764c1427`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/dependency_inventory.json` (`c5b2e97e86eb5bb74f915324ab84ef48dfd4f326cdeb2034744792c450e33a9a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/direct_review_packet.md` (`7c78fec2fca68bba17a6db4c436fc08e813cc73eb8726403182d910dbca7dfac`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10A/faithfulness-current-v1/inputs/source_locator.json` (`979b76ec3a562b9b8fa8726bd6e62ab2e0961c9709870ae660994f60acd8ebff`)
