# Faithfulness audit: HDP-02-EX-2.7.4

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `f16221c55985a82141bdb0975d20910d081e7ee3ac239c293c20ae43eb66e5b2`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The direct judge is right that the repaired theorem proves the mathematical obstruction requested by the exercise, including the inherited one-sided bound and a genuine negative-lambda failure. The round-trip judge is right on the reverse implication: the source claim is a general non-extendability exercise and does not force the exact Dirac-zero, K3 = 1 witness theorem. Under the methodology's two-direction table, yes/no gives faithful-stronger; this is genuine nonvacuous witness strength rather than reduced applicability or an impossible premise.

## Implications

- **Lean implies source:** `yes`. The Lean theorem gives a concrete admissible random variable and positive scale satisfying the original property-(c) bound on the entire source domain 0 <= lambda <= 1/K3, then exhibits an allowed negative lambda with |lambda| <= 1/K3 where the unchanged bound fails. A single such example refutes the proposed general extension requested by Exercise 2.7.4.
- **Source implies lean:** `no`. The source exercise asks for an argument that the bound cannot be extended in general. That existential or open-ended non-extendability claim permits the Dirac-zero witness, but it does not entail the particular formal package with mu fixed to dirac 0 on Real, X fixed to the constant-zero function, K3 fixed to 1, and the listed admissibility and failure conjuncts.

## Findings

- **note / specific-counterexample-strengthening:** The formalization is source-responsive and nonvacuous, but stronger than the source claim because it commits to a particular witness not required by the text.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `fail` |
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

- Blind translator covered `33` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `33` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/agent_outputs/adjudicator.json` (`0322e1f9525007c48873dac5efd8f2e12ef24b50c73c1d5e4a07b5863d0a120e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/agent_outputs/agent_runs.json` (`75c8aad37e8d4c86774011a2690a749809207380eb6765ad080c398c1de1d7a5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/agent_outputs/batch_source_contract.json` (`a3c57923ae5d5a2fa17706ca651f261894e7f9aa660c1112ef39a8fdc8957c85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/agent_outputs/blind_translation.json` (`4c50ab7f8c39d7ec38ee461e04a122fbb29bc91fc0bb473337f9241f3b0680f2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/agent_outputs/direct_judge.json` (`0e0e6c7691f821e629c06085b550b1ea20bab25580025ab52161b80b0386703c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/agent_outputs/roundtrip_judge.json` (`269d68d99c8441e1b7b1be23a8529d5d5f5fb24c5e4002ede200faf5d04029f8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/agent_outputs/source_contract.json` (`cea75d6ef6489a0a04ebd35b0fafa45ac5046755fbcec46aa2e5838b14999502`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/decision.json` (`e96ec4e11e0de05199aa064448de955e47e4429a0b66e9a4ba5c0d4d50b33235`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/agent_outputs/adjudicator.json` (`08712b82a563718da8e34cd87de9536ee23bdf6336a34328eb06620d3b95c947`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/agent_outputs/agent_runs.json` (`1088248a87be28f3a1be1feac6cfcc39470b372011b904360007fb602974544c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/agent_outputs/batch_source_contract.json` (`3ccea7c98c2c28856a38ba911fe50e1c4e41481e32915de0fcfa6d31094b6fe1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/agent_outputs/blind_translation.json` (`a76d94c3fb08a875eb089654f34b750c5c2cd894de22da0cf27c511f142537c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/agent_outputs/direct_judge.json` (`f4f2abb9345edfed6a5c774758b3e85e735a67c2ef1528669e268ec2d540fe51`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/agent_outputs/roundtrip_judge.json` (`99aada7346ca43179bcb20de318610464c93299f0cf69f14d199f2b2644e97ce`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/agent_outputs/source_contract.json` (`db8ef8725bc42be86be8011a42b7634f4c1d0cb1cb3656cb4ecdf69afb56323e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/inputs/batch_source_locator.json` (`0122b6da6e056a30d6103e2b82bde2ab6e4ba73697779c6df5d1f7896d877889`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/inputs/blind_dependency_inventory.json` (`627c982f48c7a9ba679f19edf5ce42af9bb358b223b1dec87158870bb85dd299`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/inputs/blind_dossier.md` (`2bf5e72dcc38ea5a68dd7c2c8784248513a9ca74e2af71c980d252dbd4935544`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/inputs/blind_review_packet.md` (`2bf5e72dcc38ea5a68dd7c2c8784248513a9ca74e2af71c980d252dbd4935544`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/inputs/declaration_dossier.md` (`6a432a226d8b76a40c3bbdac31396254399643f0a8ccc9546a1e632be722fdac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/inputs/dependency_inventory.json` (`627c982f48c7a9ba679f19edf5ce42af9bb358b223b1dec87158870bb85dd299`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/inputs/direct_review_packet.md` (`9bb8869a46cef8066d6d8796a2e40a0284f88f7ee322057e48505796f7d753cd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T162601Z/inputs/source_locator.json` (`3f4974c6bb18b10e9a280542473ea278335175b074505e4932aa020a56b0ea58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/agent_outputs/adjudicator.json` (`0322e1f9525007c48873dac5efd8f2e12ef24b50c73c1d5e4a07b5863d0a120e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/agent_outputs/agent_runs.json` (`176a366f524e76708ffb59d069ac20c65e166c1388781c16482ee8c360cb9bf5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/agent_outputs/batch_source_contract.json` (`a3c57923ae5d5a2fa17706ca651f261894e7f9aa660c1112ef39a8fdc8957c85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/agent_outputs/blind_translation.json` (`4c50ab7f8c39d7ec38ee461e04a122fbb29bc91fc0bb473337f9241f3b0680f2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/agent_outputs/direct_judge.json` (`0e0e6c7691f821e629c06085b550b1ea20bab25580025ab52161b80b0386703c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/agent_outputs/roundtrip_judge.json` (`269d68d99c8441e1b7b1be23a8529d5d5f5fb24c5e4002ede200faf5d04029f8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/agent_outputs/source_contract.json` (`cea75d6ef6489a0a04ebd35b0fafa45ac5046755fbcec46aa2e5838b14999502`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/decision.json` (`bbc9f8a3062f1c529c60c96786c312dc613aa605b1dfaad8b727373c14237070`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/inputs/batch_source_locator.json` (`0122b6da6e056a30d6103e2b82bde2ab6e4ba73697779c6df5d1f7896d877889`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/inputs/blind_dependency_inventory.json` (`5256a91090bfc7b0f65166a9479882867ccfd3f878d4ce7e197f905ea8d58ef3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/inputs/blind_dossier.md` (`99ca1c6e97254e238aa87858c577f89a9a80e793f4131d415a7ed6a563bad6df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/inputs/blind_review_packet.md` (`99ca1c6e97254e238aa87858c577f89a9a80e793f4131d415a7ed6a563bad6df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/inputs/declaration_dossier.md` (`ad46fecbefd01a506c88a1831b387784cbf8de318efef8562e0f1f0fc667eb6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/inputs/dependency_inventory.json` (`5256a91090bfc7b0f65166a9479882867ccfd3f878d4ce7e197f905ea8d58ef3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/inputs/direct_review_packet.md` (`9febc9fda66b0ea55e76f0b920c66b7c43e202e4f90531da33105dd0b06d3e3a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/history/20260831T204450Z/inputs/source_locator.json` (`3f4974c6bb18b10e9a280542473ea278335175b074505e4932aa020a56b0ea58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/inputs/blind_dependency_inventory.json` (`5256a91090bfc7b0f65166a9479882867ccfd3f878d4ce7e197f905ea8d58ef3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/inputs/blind_dossier.md` (`99ca1c6e97254e238aa87858c577f89a9a80e793f4131d415a7ed6a563bad6df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/inputs/blind_review_packet.md` (`99ca1c6e97254e238aa87858c577f89a9a80e793f4131d415a7ed6a563bad6df`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/inputs/declaration_dossier.md` (`143682e2938fce358deb4991f6044f8d4d50334d225af46a5e50e81b3cbac3b0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/inputs/dependency_inventory.json` (`5256a91090bfc7b0f65166a9479882867ccfd3f878d4ce7e197f905ea8d58ef3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/inputs/direct_review_packet.md` (`9febc9fda66b0ea55e76f0b920c66b7c43e202e4f90531da33105dd0b06d3e3a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.4/faithfulness/inputs/source_locator.json` (`3f4974c6bb18b10e9a280542473ea278335175b074505e4932aa020a56b0ea58`)
