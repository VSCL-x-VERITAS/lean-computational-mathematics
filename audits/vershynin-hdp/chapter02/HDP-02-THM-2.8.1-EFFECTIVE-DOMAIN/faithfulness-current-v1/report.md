# Faithfulness audit: HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `3e1dba792cd806e71359b6c4da002df0553aefb46f9a51e2f42b3e4648390cdb`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Adjudication used only the sealed statement-level evidence, the hash-matched pinned source page, and the two exact trigger reasons; no target proof or prior audit was inspected. The positive-scale branch has the same quantifier scope, hypotheses, two-sided event, threshold range, prefactor, constant, quadratic denominator, linear denominator, minimum, and inequality direction as the source. Because nonnegative finite gauges make S>0 equivalent to M>0, that branch covers all and only the source's unambiguously defined real-quotient cases. The conjoined S=0 implication does not replace or restrict those cases. It adds the natural degenerate behavior, and constant-zero families establish that this addition is satisfiable rather than vacuous. Therefore Lean implies the source, the source does not state the full Lean theorem, the classification is faithful-stronger, and the strengthening is accepted.

## Implications

- **Lean implies source:** `yes`. Whenever the source formula has its ordinary real meaning, M>0. Since all component gauges are nonnegative and the family is nonempty, M>0 is equivalent to S=Σ_i q_i²>0. The target's positive-S branch then states exactly the source's two-sided event and bound 2 exp(-c·min(t²/S,t/M)) for every t≥0, with the same universal positive constant and family scales.
- **Source implies lean:** `no`. The selected source passage states no proposition for the all-zero-scale case: both denominators vanish, including 0/0 at t=0, and no convention or separate clause is supplied. The target additionally proves a concrete bound for every t when S=0. Constant-zero families show this added branch is satisfiable, so it is not entailed by the source's stated effective-domain content.

## Findings

- **minor / effective-domain-extension:** The target preserves every well-defined source case and adds a nonvacuous degenerate-family theorem, so it is faithful-stronger rather than faithful-equivalent.
- **note / genuine-strength-not-reduced-applicability:** The guard does not narrow source applicability; the change is solely additional valid content.
- **note / zero-threshold-boundary:** The target makes the exceptional boundary explicit without claiming that this convention was printed in the source.

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
- Direct judge covered `95` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The source author's intended convention for the all-zero family remains unstated; an extended-real or limiting interpretation might recover the same degenerate values. This uncertainty concerns authorial intent only and does not change the literal hash-pinned classification.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/adjudicator.json` (`2de1ba0718288fbfa801dd35c17b51a46c8c05723061b110b3a33efe71fd99da`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/agent_runs.json` (`24ec1e6c44e2407380dafcf2361d3528da70374e4eb2fe747966ec76f278ae4b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/blind_translation.json` (`fcba2f9098ebc993784bdb046568226fa0305d7c180fbf705500d6f2dfb846f9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/direct_judge.json` (`f977d8cbb0c78e95c910dd50b5a62ecd1489dbcc82ce08b57c2c23366e30b1f3`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`a80c35257d3266c325d30f836f68810c6861ee0d64ab382896cb5576eea00f42`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/source_contract.json` (`4af9c7def2cfec96151699d4056aaf88c6ec9958a513cf7bc0b3804cfdb703f0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/decision.json` (`84d3d343bad942095f2c3c3457f20bd50a824a462126f5cce503bcd64c36da3e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`73fa722eeddae0c71bffb33f67293e6f851e4aeb783e7bbd4f6ae64191c4b853`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/blind_dossier.md` (`3d78ae8c208c62c3f0c30a269a968d4505f123a0daf60b20ed95602d82442bf1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/blind_review_packet.md` (`3d78ae8c208c62c3f0c30a269a968d4505f123a0daf60b20ed95602d82442bf1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/declaration_dossier.md` (`f4c9208889a72531228f6c81408a4c12b5484760984ddbf63031f755b44ad47f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/dependency_inventory.json` (`8a82c4deade085c032e9790c084ddf6a4993f7a8a0afbc3d92e7977a14dfca9a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/direct_review_packet.md` (`1b625746cbddbdee9c1b516d13bc5cc22a6dd8eab6425a5358c4c33b0072f65e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.1-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/source_locator.json` (`26af680372bfee12a337eb8435a8c02a14823e8fd9a8bfa48ec7842a07ca9eaa`)
