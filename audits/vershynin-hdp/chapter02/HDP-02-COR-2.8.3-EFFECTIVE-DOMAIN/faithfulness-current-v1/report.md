# Faithfulness audit: HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `d22121063bcf914b15704d8a469cec61f2ca97c87b59361f94804fd96bd11b72`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The pinned source, source contract, direct packet, blind packet, blind translation, and both judgments agree on the positive-scale theorem: a nonempty finite independent centered sub-exponential real family, its arithmetic average, K as the largest psi-one gauge, one universal positive constant, every nonnegative threshold, a two-sided event, exact prefactor 2, and exponent -c N min(t^2/K^2,t/K). The source leaves K = 0 undefined. The target avoids totalized division there by conjoining a separate, satisfiable K = 0 conclusion. Since it retains rather than restricts the original universal domain, this endpoint case is genuine mathematical strength. Accordingly Lean implies the source's well-defined content, the literal source does not imply the added branch, the classification is faithful-stronger, and the statement is accepted with the effective-domain extension recorded explicitly.

## Implications

- **Lean implies source:** `yes`. For K > 0, after identifying card(iota) with N, the target's random quantity is exactly the arithmetic average and its upper bound is exactly 2 exp(-c N min(t^2/K^2,t/K)), with the same universal positive c and every t >= 0. The extra K = 0 branch neither removes a source case nor weakens the positive-scale conclusion.
- **Source implies lean:** `no`. The hash-pinned source provides no defined values for t^2/K^2 and t/K at K = 0 and states no separate endpoint conclusion. The target nevertheless requires zero probability above every positive threshold in that case. That explicit completion cannot be obtained from the literal source statement without selecting a convention or supplying an additional argument.

## Findings

- **minor / explicit-effective-domain-extension:** The target is not literally equivalent to the source's incomplete endpoint semantics, but it is accepted as faithful-stronger because it retains the full well-defined corollary and adds nonvacuous coverage instead of narrowing the hypotheses.

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

- Blind translator covered `99` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `99` dependencies (`0` hash-reused); failing or unclear: `D001, D084`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/adjudicator.json` (`03c75fa13d509adaf10866d954c3aa7b5a7909a8c4952529a9ec914fe58de1ad`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/agent_runs.json` (`ff50dfcfafb793fd62f8f47de0326a5326985d1616c3224bca5fd6f40d360df8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/blind_translation.json` (`b815ac883c650bcf20413b389ffb580ffde68bdad25ec89369730e392f7206ee`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/direct_judge.json` (`1e1489d95e37ca66618b1f6d5fa2b232540561f036e7ff1017031ef9f9bd2b68`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`8e6f38276967ca2b3de2626b8a696e32dda43dd90636b004028b870e3fbf33f0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/agent_outputs/source_contract.json` (`df5bbefd473beadeb188bceb0d83aa94debb6b1304df257050448a9d2e55f0d0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/decision.json` (`64b4c5e2078e46aa66e525fef808e3b8a5126585c5344ff4f57e765f45785254`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`f53c9ac25c52f5332065dafeef2342101660991fca9512c7e42f549d3983ba82`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/blind_dossier.md` (`a45001c995a7cac8d1ebc44ea43fef934983476dba4f11a27331530c83583859`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/blind_review_packet.md` (`a45001c995a7cac8d1ebc44ea43fef934983476dba4f11a27331530c83583859`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/declaration_dossier.md` (`7f924c168f23e172bb3e5251570716032aae279c6d5f728163fd26763faa2ab7`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/dependency_inventory.json` (`30ddfe3d68ac11b5f4e629752b4729bcecb026a9fa79e748359263be76be66be`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/direct_review_packet.md` (`6a4e5340f086c77835b71ffa5837652def9df2ac1fe1e412bdeba12c36a1d6a2`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-COR-2.8.3-EFFECTIVE-DOMAIN/faithfulness-current-v1/inputs/source_locator.json` (`80afd981b0fcc8c492748648fa1a713da57e9bad461e6b1900276d5565915b78`)
