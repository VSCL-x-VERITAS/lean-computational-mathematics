# Faithfulness audit: HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `79b73ba28ba7dfd620512abe84a51ddccb9748a93b6bc49dde7d54a2de992eb8`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Primary-source and declaration evidence agree on every material component of the nondegenerate weighted Bernstein inequality: finite nonempty indexing, a common probability measure, independent centered sub-exponential real variables, arbitrary real coefficients, a universal positive constant, K as the maximum psi-one gauge, the two-sided event, the prefactor 2, and the minimum of the quadratic and linear rates. The only dispute is C11. The printed source includes degenerate inputs but leaves their divisions undefined. The formal target avoids totalized division at the endpoint by partitioning on A and asserting a separate A = 0 tail conclusion. Since this is an added conclusion over inputs retained by the same universal quantification—not an extra premise or a smaller domain—it is genuine, satisfiable strength. Thus Lean implies the source's well-defined content, the literal source does not imply the added branch, the classification is faithful-stronger, and acceptance is warranted with the boundary extension recorded explicitly.

## Implications

- **Lean implies source:** `yes`. On the source's unambiguous effective domain K > 0 and a != 0, the target has A = K^2 sum_i a_i^2 > 0 and B = K max_i |a_i| > 0 and states exactly the same two-sided weighted tail bound, with the same universal positive c, prefactor 2, threshold range, and quadratic and linear denominators. Its additional A = 0 branch does not remove any source case or weaken this conclusion.
- **Source implies lean:** `no`. The hash-pinned source passage supplies no defined value for its displayed rates when K = 0 or a = 0 and states no separate degenerate conclusion. The target nevertheless requires, under A = 0, probability at most 0 for every positive threshold (and at most 2 at threshold zero). That chosen endpoint completion is not entailed by the literal source statement without adding a convention or auxiliary argument.

## Findings

- **minor / explicit-effective-domain-extension:** The target is not literally equivalent to the incomplete boundary semantics of the printed display. It is accepted as faithful-stronger because it retains the entire well-defined source theorem and gives additional nonvacuous coverage rather than narrowing the hypotheses or domain.

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
| `C11` | `fail` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `95` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `95` dependencies (`0` hash-reused); failing or unclear: `D001, D080`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/adjudicator.json` (`d0179602f80a5a40e7e5efe2aa6d48700ca8fb556269896e601473c4d4da5c7e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/agent_runs.json` (`f16fc6ce23fee8ba0820004f9f82cf6ed47df4263bd8393c0b038247ed574a37`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/blind_translation.json` (`259aadd189101a18cb04698719a26637636dd41e3d636b76a20ec57abd1e1c6c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/direct_judge.json` (`87b4935fda582e044d831704f0e0563d56b61e1cce6b1d4c802eb8fb2161f512`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`3ab436ac8f28c0fffc79115aed7650d28c7a5deabd079d036be8f689fcf1854d`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/source_contract.json` (`ab9bca49649d8bdeab963ae988b9f5e471c714d5987dc7a58a7074f43297c7da`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/decision.json` (`124f9c0c61c9d33f53d82b1770480dfe98bc474cdf06a06eeba257df8ad2f711`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`41c4979461f997f612ff8798c9a03cc006caca6db6d06242143ec2254801e0f6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/blind_dossier.md` (`e3830fd561cc49ae0ea4bea2241bc4233099af246d7a298907de6335c580c81a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/blind_review_packet.md` (`e3830fd561cc49ae0ea4bea2241bc4233099af246d7a298907de6335c580c81a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/declaration_dossier.md` (`55cf56473385b86c92f23614c7a196e4c0b2fd36e33d7d321d52d8104f7b94de`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/dependency_inventory.json` (`c3103c0b31305804dea725b1f3efd82c3d0dc678daf59b79834c552b98cacefc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/direct_review_packet.md` (`eeddf47a6e27981799cab3f63e3700ce19a11277064d3c692305a5e6077feacc`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/source_locator.json` (`61dcf25303d2179220cea1b1078af8b34034a16c316b97220ad0328b3110926b`)
