# Faithfulness audit: HDP-02-EQ-2.20

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `6c7b91009cc186d7301bdfb3e3bf8885ea10e99c6e2d41f34c8db7df3929f5a1`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Primary source and declaration evidence resolve the only trigger. On PDF page 19, Equation (2.20) is exactly the psi_2 triangle inequality for centering. The Lean target has the same binders, premise, centered function, constant expectation function, relation, and summands. D019 is the Bochner integral; although totalized outside Integrable, the sub-Gaussian square-exponential premise entails Integrable X, so its target value is the ordinary expectation. Both implications hold, the premise is nonvacuous, no uncertainty remains, and the statement is faithful-equivalent.

## Implications

- **Lean implies source:** `yes`. For every Lean instance of the premise, the positive square-exponential witness entails Integrable X, so D019 denotes E_mu[X] rather than its nonintegrable fallback. PsiTwoNorm is the same positive-scale square-exponential infimum used by the source, and the target's centered and constant functions therefore turn verbatim into the three terms of Equation (2.20).
- **Source implies lean:** `yes`. A source sub-Gaussian random variable satisfies the finite square-exponential condition at some positive scale and is integrable, giving the Lean IsSubGaussian premise and the same Bochner expectation. The source's triangle-inequality display then supplies exactly the target's ENNReal non-strict inequality, with E X explicitly embedded as a constant function.

## Findings

- **note / resolved integral totalization:** D019 has the source meaning of expectation throughout the selected proposition; its exceptional branch introduces no semantic discrepancy.
- **note / explicit source conventions:** These are faithful representations of inherited source context, not extra hypotheses that reduce applicability.
- **note / nonvacuity:** Acceptance is not caused by an impossible premise or by the nonintegrable fallback of the totalized integral.

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

- Blind translator covered `82` dependencies (`0` hash-reused); unclear: `D019`.
- Direct judge covered `82` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/agent_outputs/adjudicator.json` (`a9c1b2d01a1bd255488fd2ec31a28f6165995ebea461922c0a74a470b66f80d6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/agent_outputs/agent_runs.json` (`5302975d36dc5525dc04dc40a7ecf668fa414f7d674575b6f846078ab296d454`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/agent_outputs/batch_source_contract.json` (`5e82f43bf5a112305035d4efd27c8f1a6f7c0b08c6abb4c1f5d484e21f882571`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/agent_outputs/blind_translation.json` (`3b86b50c6d6b876c2e74e1e70c035a607d98f844452c47c1b344ec3f3b882912`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/agent_outputs/direct_judge.json` (`26e1e687c50fb645ddac5392df4820903a20128ad3017054aa5c3a2576da155d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/agent_outputs/roundtrip_judge.json` (`42277f60522cfe733cbd802bb5391536d48fcaf19366e1dd5054b2a0e5ff12d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/agent_outputs/source_contract.json` (`73a2e971038c377e7d6e41051254d081f3f04fd8ac16f704217172826ce2ef3f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/decision.json` (`bea4d4280de921f4787b207f066fce96570fd0ae9440bd79917b32612143531c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/inputs/batch_source_locator.json` (`aed4180b8cfa2d7d78b15411d28bd64f5f0a7c8f8e787a3b2dccb7e23e838773`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/inputs/blind_dependency_inventory.json` (`c8bfa8f49b0eeda9b85f9335c9b252d4d3ceac91d794d9b2b2173d82a9eca436`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/inputs/blind_dossier.md` (`d713fa3babd641036e2d8b8864b7c169639364f435fa1f29c1d8145445fdf434`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/inputs/blind_review_packet.md` (`d713fa3babd641036e2d8b8864b7c169639364f435fa1f29c1d8145445fdf434`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/inputs/declaration_dossier.md` (`119d1520367027ec4538c84e760fb9b5124dc497342e2ca68da743df92a63210`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/inputs/dependency_inventory.json` (`5316297be33be0057865e0e346372da79b7d60631834f1e9a016e1ae78033522`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/inputs/direct_review_packet.md` (`a0fb3e77c62ec8e79a0df07377badfd2f54a7d5c94ff0acb6573fda5a2c4c70a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.20/faithfulness/inputs/source_locator.json` (`aa75ebd0490571512759533ed0516975345025cbfae3e79f8627b003741c24bf`)
