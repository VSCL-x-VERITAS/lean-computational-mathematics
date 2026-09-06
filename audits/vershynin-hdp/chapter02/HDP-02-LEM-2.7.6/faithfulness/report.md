# Faithfulness audit: HDP-02-LEM-2.7.6

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `3b4f690984041a66d3360ba1a4c265c3ea7958734375ff8396809ce6da469fe0`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target faithfully states both parts of Lemma 2.7.6. Its first conjunct represents sub-gaussianity and sub-exponentiality as finiteness of the exact ENNReal gauges and relates them by iff. Its second conjunct gives the exact constant-one identity between the psi_1 gauge of the pointwise square and the square of the psi_2 gauge of X. The admissibility definitions reproduce displays (2.21) and (2.13), with finite positive scales, explicit integrability, and threshold 2. Measurability is inherent in X being a random variable, and no centering or independence assumption is introduced. The displayed formula and proof resolve the source's harmless prose cross-reference inconsistency, so adjudication is unnecessary.

## Implications

- **Lean implies source:** `yes`. For each measurable real random variable, gauge < top is equivalent to existence of a finite positive admissible scale, hence to membership in the corresponding sub-gaussian or sub-exponential class. The Lean iff therefore gives the source class equivalence for X and X^2, and the second conjunct is literally the source's exact extended-nonnegative norm identity.
- **Source implies lean:** `yes`. Using displays (2.13) and (2.21), the source proof's substitution K = L^2 identifies the admissible-scale infima for X^2 and X and yields PsiOneGauge(X^2) = PsiTwoGauge(X)^2. The source iff simultaneously says precisely that one gauge is finite iff the other is finite, which is the Lean first conjunct.

## Findings

- **note / source-cross-reference:** The source's local cross-reference typo does not create semantic uncertainty for this target because the displayed definition and lemma proof agree with the Lean gauge.

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

- Blind translator covered `79` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `79` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/agent_outputs/agent_runs.json` (`0142cea1d2e47ce294783694daf77c9c4eb0abe2d3f9625a837434b5e5445b4f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/agent_outputs/batch_source_contract.json` (`856d0400f37d309d6e394f4e5d704d0cd26bb8d59f2cdc4932f9f89bb4eb46e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/agent_outputs/blind_translation.json` (`e2eb86b16e3f19f0377fac7d1da19964bf65b00b1dd481e48cf9e87a778d950a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/agent_outputs/direct_judge.json` (`22e018a069f1abb4283b156137f8bcae732e1f2ef1d0fc57d2caad54037584a8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/agent_outputs/roundtrip_judge.json` (`83effa5b9e4e219546e648c2aadd79778097b665905533b6a26faf88e0811e0a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/agent_outputs/source_contract.json` (`9bff44fdee816408b48b46312aa88ab094d4db6370d5ceeb7c7fc925598b8e8b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/decision.json` (`7d9bbfd8441e0047617691d83f032e0ce65c652106cae0ede778ea4a3aaf7a76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T171655Z/agent_outputs/batch_source_contract.json` (`3e39d619b3c4737f1beebc1f4a6d89d80928155a0af9cf2c3a44f3fd92e95975`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T171655Z/agent_outputs/source_contract.json` (`05e87ed7146cfec20d3bd4314e6f521ad3e5dadd45f001ff0f3d128ca882d154`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T171655Z/inputs/batch_source_locator.json` (`96999ab9c93dd8971b343042a9dbb8df6ab0d66f4db2c3e00054f6ef1ac2564e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T171655Z/inputs/blind_dependency_inventory.json` (`aaea674db8de6973cdb3b7ba7efcaa35803f3d20ae0eef586de371db0a43514c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T171655Z/inputs/blind_dossier.md` (`eb4d23005605a4486584577906eeacb4b27b980f4263c8b2d46d6233cf39fcd7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T171655Z/inputs/blind_review_packet.md` (`eb4d23005605a4486584577906eeacb4b27b980f4263c8b2d46d6233cf39fcd7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T171655Z/inputs/declaration_dossier.md` (`ba2a6853f09828c01720da06507310f0d9fb553497653ad1f461b3d3826e0343`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T171655Z/inputs/dependency_inventory.json` (`7cacf63b63f93b14b2c7187947cfae1d867378009dd8a8806bc282eb189d2f2e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T171655Z/inputs/direct_review_packet.md` (`6944792ca848b71bc0460f3d0be63451a506024ff931009dfa0b47da83331d9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T171655Z/inputs/source_locator.json` (`4d5465e56e3aa48bb8d9cab31a88a1a3ff10ffdf003ece4a72a3b13859bc7501`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/agent_outputs/agent_runs.json` (`fa55ac072bf93ff1001b0b66acf776b4c7e013d26eb966a4399513109d65eed1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/agent_outputs/batch_source_contract.json` (`856d0400f37d309d6e394f4e5d704d0cd26bb8d59f2cdc4932f9f89bb4eb46e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/agent_outputs/source_contract.json` (`9bff44fdee816408b48b46312aa88ab094d4db6370d5ceeb7c7fc925598b8e8b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/inputs/batch_source_locator.json` (`344c2f15f875394c1b35c8732c25ff4482a74b2364f89e81c7bee4a9d3ea6fc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/inputs/blind_dependency_inventory.json` (`aaea674db8de6973cdb3b7ba7efcaa35803f3d20ae0eef586de371db0a43514c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/inputs/blind_dossier.md` (`eb4d23005605a4486584577906eeacb4b27b980f4263c8b2d46d6233cf39fcd7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/inputs/blind_review_packet.md` (`eb4d23005605a4486584577906eeacb4b27b980f4263c8b2d46d6233cf39fcd7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/inputs/declaration_dossier.md` (`ba2a6853f09828c01720da06507310f0d9fb553497653ad1f461b3d3826e0343`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/inputs/dependency_inventory.json` (`7cacf63b63f93b14b2c7187947cfae1d867378009dd8a8806bc282eb189d2f2e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/inputs/direct_review_packet.md` (`6944792ca848b71bc0460f3d0be63451a506024ff931009dfa0b47da83331d9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/history/20260831T204043Z/inputs/source_locator.json` (`5892ba65f0042b7d1318173162621a19d9869ff5197f46a4b1e8b66070fe5a99`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/inputs/blind_dependency_inventory.json` (`aaea674db8de6973cdb3b7ba7efcaa35803f3d20ae0eef586de371db0a43514c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/inputs/blind_dossier.md` (`eb4d23005605a4486584577906eeacb4b27b980f4263c8b2d46d6233cf39fcd7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/inputs/blind_review_packet.md` (`eb4d23005605a4486584577906eeacb4b27b980f4263c8b2d46d6233cf39fcd7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/inputs/declaration_dossier.md` (`a08dffbda5056ef6f99605eb8df69252f97d36b445277fc3546fbb245b140481`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/inputs/dependency_inventory.json` (`7cacf63b63f93b14b2c7187947cfae1d867378009dd8a8806bc282eb189d2f2e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/inputs/direct_review_packet.md` (`6944792ca848b71bc0460f3d0be63451a506024ff931009dfa0b47da83331d9b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.7.6/faithfulness/inputs/source_locator.json` (`5892ba65f0042b7d1318173162621a19d9869ff5197f46a4b1e8b66070fe5a99`)
