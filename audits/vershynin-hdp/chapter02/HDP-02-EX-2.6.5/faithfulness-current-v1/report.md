# Faithfulness audit: HDP-02-EX-2.6.5

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `a43bc5660f86cc0a6513da448fa1c03812b3d50dc8075a6de08ea9f756fb9aa5`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The proof-free target faithfully formalizes Exercise 2.6.5. It preserves the universal absolute constant, finite nonempty family, independence, sub-gaussianity, centering, unit variance, arbitrary real coefficients, all real p>=2, the exact lower constant, and the upper C*K*sqrt(p) scaling with K the maximum psi-two norm. Explicit measure-theoretic regularity and finite-type indexing are faithful formal encodings, while all totalized definitions are forced into their ordinary regime by the hypotheses.

## Implications

- **Lean implies source:** `yes`. Specializing the arbitrary finite nonempty index type to {1,...,N} yields every source family, and the target gives both source inequalities with the exact K and one universal absolute C.
- **Source implies lean:** `yes`. Every finite nonempty indexed family can be reindexed by {1,...,N}; source sub-gaussianity supplies the explicit regularity, and any positive absolute upper-bound constant can be enlarged to at least one without weakening the bound because K, sqrt(p), and coefficient energy are nonnegative.

## Findings

- **note / constant-normalization:** This is equivalent normalization rather than a strength change, since any positive valid C may be increased to max(C,1).
- **note / explicit-formal-context:** These choices expose the standard domain on which the source's expectations, variances, independence, maximum, and Lp norm are meaningful; they do not reduce intended applicability.

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

- Blind translator covered `92` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `92` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/agent_outputs/agent_runs.json` (`5cdac529828937dc204c0d44f49462a97b98c8b4d9e5df1152fd2f3740e04734`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/agent_outputs/blind_translation.json` (`9d00d73db957d442ba06b8003b47dc6327056f26dde27ce3629c691c536293a1`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/agent_outputs/direct_judge.json` (`cd121375fce6d874045458413fed20d0b0ff92d3c0a74ee13b5282fd4ee3f8b3`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`22566abc1d4a6c08df65c24564f072cae1b04f78ca2783a3b241c61ab35d39d9`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/agent_outputs/source_contract.json` (`a97f48937274cf8e02f79e4f8887b20022148150ce8ec07a2d13613185797590`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/decision.json` (`c35376db532beefd20c971a3413bfc71641b8c7f0c74839190182f4e83f93abb`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/history/20260910T162747Z/agent_outputs/blind_translation.json` (`e3f9f75fea03742f7180e5d2047d15bd2940ee418fac50a14755e3f6f379a4f3`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/history/20260910T162747Z/agent_outputs/source_contract.json` (`b2ffb568f01dc02ffc097d5d31cbb59a8de96759c60d07f54eb3b18c757d296c`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/history/20260910T162747Z/inputs/blind_dependency_inventory.json` (`ae29deb9ea27c13322410580caf3e2401438a5a3ebe86dfc080e2a4a553df002`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/history/20260910T162747Z/inputs/blind_dossier.md` (`b166b11161d9e493e2b6c012affebaca8f20c8687bcb6dd83520d299df546fb8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/history/20260910T162747Z/inputs/blind_review_packet.md` (`b166b11161d9e493e2b6c012affebaca8f20c8687bcb6dd83520d299df546fb8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/history/20260910T162747Z/inputs/declaration_dossier.md` (`5fae1c9242b84cc215aec93babe644419e61b0796dd0dcdc2adaa40c745a84c6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/history/20260910T162747Z/inputs/dependency_inventory.json` (`56dd751d1b6f60c77d2d9753e5d796c5b255bc6e1b4eeaf0037240bb697fecab`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/history/20260910T162747Z/inputs/direct_review_packet.md` (`5e2e6283cefde0a54b491e85c2b35643fd4b8d92b38f2df5583fe326802e852b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/history/20260910T162747Z/inputs/source_locator.json` (`b22aabbbbc0b887f8f212af5c64c489f933a906fbcb2287e054fcd5e62978eee`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`ae29deb9ea27c13322410580caf3e2401438a5a3ebe86dfc080e2a4a553df002`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/inputs/blind_dossier.md` (`b166b11161d9e493e2b6c012affebaca8f20c8687bcb6dd83520d299df546fb8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/inputs/blind_review_packet.md` (`b166b11161d9e493e2b6c012affebaca8f20c8687bcb6dd83520d299df546fb8`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/inputs/declaration_dossier.md` (`5fae1c9242b84cc215aec93babe644419e61b0796dd0dcdc2adaa40c745a84c6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/inputs/dependency_inventory.json` (`56dd751d1b6f60c77d2d9753e5d796c5b255bc6e1b4eeaf0037240bb697fecab`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/inputs/direct_review_packet.md` (`5e2e6283cefde0a54b491e85c2b35643fd4b8d92b38f2df5583fe326802e852b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.6.5/faithfulness-current-v1/inputs/source_locator.json` (`5672ec351395459d96b448a739c978d3b35ddf30370157139f37cd9178bef7d9`)
