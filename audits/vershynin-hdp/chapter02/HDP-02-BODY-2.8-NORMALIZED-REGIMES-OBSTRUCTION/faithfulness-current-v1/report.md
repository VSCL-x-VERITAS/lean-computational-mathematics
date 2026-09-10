# Faithfulness audit: HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION

## Decision

- Classification: `not-faithful-different`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `cd2087eaa6fff550aa964fad9abe34272edd6a13f00c1e9abbdad6a1f3a44968`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The literal source is a positive universal two-regime statement. The target is a closed, nonvacuous counterexample package establishing one eligible singleton and denying the literal large branch after every cutoff. Editorial ambiguity does not alter hash-pinned semantics. Both implications are no, the classification is not-faithful-different, and acceptance is false. Adjudication was confined to the authorized sealed artifacts and no proof was inspected.

## Implications

- **Lean implies source:** `no`. The concrete N=1 obstruction neither supplies the universal two-regime theorem nor its quadratic branch and conflicts with the literal large conclusion.
- **Source implies lean:** `no`. The literal source positively asserts an eventual bound for eligible families, whereas the target denies every such cutoff for its eligible witness and adds distribution-specific facts not concluded by the source.

## Findings

- **critical / opposite-claim-polarity:** The target is an obstruction rather than a faithful rendering.
- **major / scope-and-conclusion-loss:** Universal scope and the quadratic branch are absent, so neither implication holds.
- **note / source-editorial-ambiguity:** This explains the obstruction but cannot change the immutable source during audit.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `fail` | `fail` |
| `C02` | `pass` | `fail` |
| `C03` | `fail` | `fail` |
| `C04` | `pass` | `fail` |
| `C05` | `pass` | `fail` |
| `C06` | `pass` | `fail` |
| `C07` | `pass` | `fail` |
| `C08` | `pass` | `fail` |
| `C09` | `pass` | `fail` |
| `C10` | `pass` | `fail` |
| `C11` | `pass` | `fail` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `90` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `90` dependencies (`0` hash-reused); failing or unclear: `D001, D012, D028`.

## Remaining uncertainties

- Whether the unit coefficient was intentional, a typographical omission, or shorthand for a K-dependent constant remains editorially uncertain; this does not alter the literal audit decision.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/agent_outputs/adjudicator.json` (`8de74823db8462cbee9e84e014cd689b97f8d64ffb1a73d579aafe9b0ea772e0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/agent_outputs/agent_runs.json` (`cc20333eb2ee19b8bfae6a78bb6c70da634bb1251ff4b5fff5297bbb777ad26a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/agent_outputs/blind_translation.json` (`236a5c021552ad544f0bb9b1dde2966d1199b063d5ebd9bc5f7b5e6620e7a7da`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/agent_outputs/direct_judge.json` (`d5c219b2ea570e3485bee72c3a779fed1d20f394bf1d4d30b33128a4fde3f61f`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`3a433c6a984d730205d0f704361113084e67aa8b28547328b949fabac9ea6864`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/agent_outputs/source_contract.json` (`be15d0bca5b2caac9985729ba7bb529c8009c0b3e79d5a29a96086aa6d6d45ba`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/decision.json` (`d273a21aeafa9de11fef618a551d4971a18c33c76771c4a1749eb43fbf74566b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`4aedc2b5b88588c2cc055951038914c3bba953c69296758342bf74896d73dcb0`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/inputs/blind_dossier.md` (`a056a423d022b3bf1641ca9d68e29f1ad51048957bf23b5e462133c850442bb6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/inputs/blind_review_packet.md` (`a056a423d022b3bf1641ca9d68e29f1ad51048957bf23b5e462133c850442bb6`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/inputs/declaration_dossier.md` (`723b25aacd778a749f83bb6b60a040d48f2abea4a2a8e5417bb2101bfb67a6ed`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/inputs/dependency_inventory.json` (`3220b283a878d248a09b9ad6317d396d0c7de99f97b383c20bdc62bd5bac123a`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/inputs/direct_review_packet.md` (`85d7ec189a584d1e2e68db24a0300f1ed5c04d8dda423b3fbcce7dc1341b26ea`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.8-NORMALIZED-REGIMES-OBSTRUCTION/faithfulness-current-v1/inputs/source_locator.json` (`132477a44aaf8074ae3b5170c72d1a004b9f6280ea1d311ce3db5a7b2894fb0e`)
