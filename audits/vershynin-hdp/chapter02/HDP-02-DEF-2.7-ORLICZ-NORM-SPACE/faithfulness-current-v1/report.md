# Faithfulness audit: HDP-02-DEF-2.7-ORLICZ-NORM-SPACE

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `f72814549aa1b6e3441ead5d4ce6739f33266e875fc7e71ac97dd38925cbf66e`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target transparently unfolds the extended-valued Orlicz gauge as the infimum over exactly the positive finite scales satisfying the exact expectation threshold and transparently identifies L_psi membership with finiteness. Its ENNReal and lintegral choices resolve source conventions without altering the probability-space case. The only semantic difference is a clear extension from probability measures and random variables to arbitrary measures and functions, so the correct classification is faithful-stronger. No evidence or dependency remains unresolved.

## Implications

- **Lean implies source:** `yes`. Specialize the Lean quantifiers to the source probability measure and a measurable random variable. The ENNReal finite nonzero scale set, lintegral expectation, threshold one, infimum, and finite-gauge membership then reproduce both displayed source definitions.
- **Source implies lean:** `no`. The source only defines the construction for probability spaces and random variables; it does not itself assert the same equations for arbitrary measures or arbitrary, potentially nonmeasurable functions, which D001 universally includes.

## Findings

- **note / broader applicability:** The target is a conservative generalization: it recovers the source verbatim by specialization, but the reverse implication does not establish the extra cases.
- **minor / measure generality:** The translated proposition is stronger outside the source domain, while its specialization to probability measures preserves the source construction.
- **minor / function generality:** The translated proposition covers additional functions but retains every source random-variable instance; its library integral convention governs those additional cases.
- **note / extended-value implementation:** This resolves a source ambiguity compatibly and makes divergence/nonmembership explicit.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `fail` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `not-applicable` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `65` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `65` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/agent_outputs/agent_runs.json` (`b939fe9044892c6df50df23b47350ba20ca8b3760c708fa3457bb38e13c239e7`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/agent_outputs/blind_translation.json` (`57311e8af29558915aebc797725153bef218570039ec552a3bf43ef26092732d`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/agent_outputs/direct_judge.json` (`0113a9bd23dd7623e8335862c44b90292d52a3dcef7046bb638b2fc4d036f6af`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`4c93a7d30ec3ab77f26c674a54565673fc0dba27a929e65cd95c5213630941fb`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/agent_outputs/source_contract.json` (`31d7ec4cf81d56225dc127b2d980505f4a615c9837bc0f429556bb3611541da7`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/decision.json` (`b834aa87b23ccca0a2c5f75ba9bf7393b8cb621651c5987433b219dcfd3e28fa`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`a5940b0f95295aa28e371fb3cafda8831adc0ce9ff731f935dad7d8190807a75`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/inputs/blind_dossier.md` (`17bc0f493fdb43a7d7d9bcb90fa01bdb577509e0ff81c3777f28d176f44763da`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/inputs/blind_review_packet.md` (`17bc0f493fdb43a7d7d9bcb90fa01bdb577509e0ff81c3777f28d176f44763da`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/inputs/declaration_dossier.md` (`488f8f0c381913ca4baf2210e3e99e8deb96b6ceb4835faf764d5c4a8bd4fda1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/inputs/dependency_inventory.json` (`dd0d8550d74c96c5e8359d4a542884d31b4bdf5740f39e2d6c8463fea27f25fa`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/inputs/direct_review_packet.md` (`fe3c1d515a737d37321ce02d42f9be03203dd79be96f4dd60b4f07254905c710`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7-ORLICZ-NORM-SPACE/faithfulness-current-v1/inputs/source_locator.json` (`6c3b779beb814db13cbbe37f308de39b1b52ce08a8c68f01a68e465239c91141`)
