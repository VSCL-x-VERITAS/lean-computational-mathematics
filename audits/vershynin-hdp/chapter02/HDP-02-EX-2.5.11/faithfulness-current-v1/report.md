# Faithfulness audit: HDP-02-EX-2.5.11

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `59523f88e063d27a4518e7f343a15ab90c8353bbfb1e38b8e61cacd697861903`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The Lean contract faithfully states the exercise's uniform lower bound for the expected signed maximum of a finite nonempty mutually independent standard-normal family. It preserves the N(0,1) law, independence, signed rather than absolute maximum, quantifier order, constant uniformity, logarithmic square-root scale, and inequality direction. Its explicit integrability conjunct formalizes what the source's real-valued expectation presupposes and what the Gaussian hypotheses entail. Exercise 2.5.11 does not itself impose N≥2; the target's inclusion of N=1 is appropriate and, even under an inherited N≥2 reading of the sharpness regime, adds only the valid boundary identity 0≤0.

## Implications

- **Lean implies source:** `yes`. Any finite independent standard-normal family in the source can be represented by the target's first N coordinates. The target then supplies the same uniform positive c and exactly the expected signed-maximum lower bound; any source reading restricted to N≥2 is a subset of the target's positive-N range.
- **Source implies lean:** `yes`. The source lower bound, understood with its absolute uniform c, applies to every arbitrary realization encoded by the target. Measurability is implicit in 'random variables,' and finite maxima of finitely many standard Gaussians are integrable. If the sharpness comparison is read as beginning at N≥2, the additional target case N=1 follows independently from E[X₁]=0, log 1=0, and integrability of a standard normal, using the same c.

## Findings

- **note / boundary-domain-interpretation:** This produces no implication failure: N>0 matches the literal nonempty-family wording, and the N=1 assertion is an automatic equality independent of c even if N≥2 is treated as inherited context.
- **note / explicit-integrability:** This is redundant rather than strengthening in substance: standard Gaussians are integrable, and the absolute value of their finite maximum is bounded by the sum of their absolute values.

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

- Blind translator covered `66` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `66` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/agent_outputs/agent_runs.json` (`4928339861a08e526138009e9c18345a4cd287cacc5d2c08678cfa5a5ed10465`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/agent_outputs/blind_translation.json` (`360f671a7922c33f975806e304b07d90dfbd72ccd55fc0edd23c65599cc9a0ac`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/agent_outputs/direct_judge.json` (`1f6379e5d767071b601854f08955118381f30633972a6c9fe35b1566fced9fff`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`9e1b9c05de8c860f36ddca3ad5396c3d0f76d59c60d48b42b59048504f075b86`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/agent_outputs/source_contract.json` (`904d3b8f9e0311281d476a24fce5efa09c5330e30cf925827d83d4ab19a37909`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/decision.json` (`71992da9c6696dc06d3a7cec4c54965d9f356756e68ec32ab033872275e6077f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`98bb6a842682024b3fd158a0ed2910d4c74325cd139cf19d0d2f245934dab268`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/inputs/blind_dossier.md` (`93cbf09a141e402d3693881df130e74b8d29693c1d67a8c0c3a0f32e501a1761`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/inputs/blind_review_packet.md` (`93cbf09a141e402d3693881df130e74b8d29693c1d67a8c0c3a0f32e501a1761`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/inputs/declaration_dossier.md` (`6b2cfd830e762c5768510d2a18fba371fd312db72aab8e972e9f203ef721eb9f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/inputs/dependency_inventory.json` (`ba07490779afa5d6df80ebd8a17c4bfc00ab547250bc8c6c8cd7aa1dd9d85b6c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/inputs/direct_review_packet.md` (`324243367d28bb28cf3aaaa8554c95585c6d6c83381a40bb16a1e94f4dc9a288`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.11/faithfulness-current-v1/inputs/source_locator.json` (`1725189c3f10bb3f1fe30b6bff7d4e4beee8b7203aaede5cbc1256e5fe3cd504`)
