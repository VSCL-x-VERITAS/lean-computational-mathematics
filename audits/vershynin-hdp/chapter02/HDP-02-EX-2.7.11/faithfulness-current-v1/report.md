# Faithfulness audit: HDP-02-EX-2.7.11

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `5ec3b7824b6de7814aa8b8a7fd1a2fde110d6f73a8de8954328040ba8d30b6a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target is a faithful definitional expansion of Exercise 2.7.11. The Orlicz-function hypotheses agree on the only effective domain [0,∞); the admissible ENNReal scales are exactly positive finite real scales; lintegral gives the extended expectation; the carrier consists exactly of finite-gauge real random variables modulo a.e. equality; and the target states nonnegativity, definiteness, triangle inequality, and absolute homogeneity while correctly omitting the separately mentioned completeness claim. The pinned carrier chain rules out the proposed arbitrary-nonmeasurable-function reading. Both implication directions therefore hold, so the result is faithful-equivalent and accepted.

## Implications

- **Lean implies source:** `yes`. For every source probability space and Orlicz function, the Lean proposition supplies the four norm laws on exactly the finite Luxemburg-gauge a.e. classes of real random variables. Its ENNReal scales t ≠ 0,∞ correspond to source scales t > 0, its lintegral is the extended nonnegative expectation, and its toReal conversion occurs only after finite-gauge restriction.
- **Source implies lean:** `yes`. For any Lean parameters, restricting ψ to [0,∞) and viewing each AEEqFun element through its strongly measurable representative gives the source setup. The source assertion that the displayed functional is a norm on finite-gauge Lψ yields all four target conjuncts; a.e. quotienting is the necessary equality convention for definiteness, not an added restriction.

## Findings

No findings were recorded.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `unclear` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `unclear` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `156` dependencies (`0` hash-reused); unclear: `D036, D154`.
- Direct judge covered `156` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/agent_outputs/adjudicator.json` (`7c3e0a77da07c716d12edb6e64029f04b6782400744699381319a50c5bb08cfc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/agent_outputs/agent_runs.json` (`b5fde4a1bc324d47f7e8bcc465afa3be085606b9865d844fe6f81415b6e88b7e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/agent_outputs/blind_translation.json` (`97c703852f7f607e164e2aa3df91dba601e8e960f51d327757fd9a4c329a025b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/agent_outputs/direct_judge.json` (`f6242803cf114482d4cd2110833e7aa7818997137bbd8fa0ec4f90af5f21126f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`7762bd0ff43dbf0e4c02c10a8d34388990c73ffafb408fb091f2d7680a9aafdb`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/agent_outputs/source_contract.json` (`8b3319d0f592445a3958bc4c604058b8afc912c0c4c9c77cc32b5f7f13612404`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/decision.json` (`e9a82ac7297977ec83bdccb25dd2c82a64b4efde6b0251b10b10e0728e132232`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`99ce83e6e7ae3b6e558e69574ed30ba2ceeb283ad7e4eacf542668f443eea4aa`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/inputs/blind_dossier.md` (`95c142852368beae2a3edaccdbf2be27dacc34b243267f9b0b20ca4acdd69988`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/inputs/blind_review_packet.md` (`95c142852368beae2a3edaccdbf2be27dacc34b243267f9b0b20ca4acdd69988`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/inputs/declaration_dossier.md` (`1a544de78fe40f2748b09788478b5367d4fa9a65178dfc0c0016f00b3f957734`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/inputs/dependency_inventory.json` (`a7be5a62f1d6a7d9a8eabd71fad4aa8eb007c9eff2235ecc75970af4689ea113`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/inputs/direct_review_packet.md` (`c4ffb2343e80b6a90084be8881b3eaee3a19ed4568952780c956878fbb9718cb`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.11/faithfulness-current-v1/inputs/source_locator.json` (`6d8ec654742f490caf59ef82798b581e87d30e7ada5c032e252954a09306bc46`)
