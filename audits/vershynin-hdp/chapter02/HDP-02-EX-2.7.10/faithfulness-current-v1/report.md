# Faithfulness audit: HDP-02-EX-2.7.10

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `06b7cf11377cbaefa3e1e8c66c533853bf67e804c50afb7dca846983ef0e4ebe`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target is a faithful equivalent formalization of Exercise 2.7.10. It uses the exact psi-one norm from display (2.21), quantifies one constant before all probability spaces and variables, assumes exactly measurable finite-gauge input, and centers by the same-law Bochner expectation. The explicit C >= 1 normalization and the absence of a syntactically separate closure conjunct do not change the proposition's mathematical content. All 83 semantic dependencies and all 12 configured checks were resolved without an unclear or failed item, so adjudication is not required.

## Implications

- **Lean implies source:** `yes`. The Lean proposition provides one universal C, exact psi-one gauge control for every measurable real X of finite gauge on every probability space, and centers by the ordinary expectation. The finite right side also entails that the centered variable is sub-exponential, recovering the analogue's class-preservation clause.
- **Source implies lean:** `yes`. The source's absolute-constant estimate applies uniformly to exactly the target's finite-gauge random variables and exact norm. Its positive constant can be enlarged to at least 1 without invalidating the estimate, then embedded unchanged into ENNReal; source sub-exponentiality ensures the expectation is integrable and ordinary.

## Findings

- **note / constant-normalization:** No semantic loss: any valid positive absolute constant can be replaced by max(C,1), which only enlarges the right side.
- **note / implicit-closure:** The omitted-looking conjunct is entailed: a gauge bounded by the finite product of two finite ENNReal values is itself finite.
- **note / explicit-constant-lower-bound:** This is equivalent, not additional applicability: any valid positive absolute factor can be enlarged to max(C,1), while every C >= 1 is positive.
- **note / implicit-class-preservation:** The omitted standalone closure clause is a direct consequence of the inequality because its right-hand side is finite, so no mathematical content is lost.

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

- Blind translator covered `83` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `83` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/agent_outputs/agent_runs.json` (`f156caeb324b6f08a2ea28105775861130e94d3abe10111216e8227938bc0f3e`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/agent_outputs/blind_translation.json` (`de780604fe33b1485b60d4222a8d35e642667d005620edf8ae6811c59ae27c01`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/agent_outputs/direct_judge.json` (`c32fcb535fb9bf928be4feb0f066e2ca05383940ceb10ec3d95d68927240469a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`17f12afe1118c6a996ea0004df9efff9157a7bea8119bba520d72bd9b81c26c1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/agent_outputs/source_contract.json` (`e25dfb7d02f5d8f9c2096ac433c767b6532e52ed18ac09d0cc9f19abf78a5460`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/decision.json` (`a248299f52967eabe5416e6fab065d6373a3b868be542b6e7fd5f2cd36c6e7b5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`944df8f0e11bc524ec9fbc692da2cf466851fdefa0e3db0e6818e89daf037986`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/inputs/blind_dossier.md` (`d76f652d53da4ee5c3581411876dcd3306764cea8f0b5f7fcbdec6c55b4fc6d1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/inputs/blind_review_packet.md` (`d76f652d53da4ee5c3581411876dcd3306764cea8f0b5f7fcbdec6c55b4fc6d1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/inputs/declaration_dossier.md` (`98c2b662810006c1a8a14d7391ae95b95712e5b77eb6c8bccf8a966bc79dd775`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/inputs/dependency_inventory.json` (`f5faf139d8de7be221145feb2ded7be2d8a545af2ad35f12722ff747d555d514`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/inputs/direct_review_packet.md` (`386a00b8d5e0bee92dac7d3b7ebc9d4efdd53c513606744e3707c2e3f5d9b472`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.7.10/faithfulness-current-v1/inputs/source_locator.json` (`a2c766e67d5c70264a6fe21d9ed435c2155fdf9a34d4a2b22282f124042c96b4`)
