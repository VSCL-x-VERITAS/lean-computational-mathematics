# Faithfulness audit: HDP-02-EQ-2.23

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `5319df3075279c6e9711657afea0c1759250a2fb97d18bbc853dc900c9f9af48`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Both pinned hashes verify. The target preserves the complete inherited setting and the exact one-sided Equation (2.23): a nonempty finite independent family of real, centered, sub-exponential random variables; t ≥ 0; arbitrary λ > 0; event ∑ᵢXᵢ ≥ t; prefactor exp(−λt); and one MGF factor E exp(λXᵢ) per index, with no absolute value or factor 2. Its explicit measurability, integrability, probability-measure, and nonempty-index assumptions unpack source conventions, while ENNReal lintegrals correctly totalize the source's potentially infinite MGFs. Both implication directions therefore hold.

## Implications

- **Lean implies source:** `yes`. Under the supplied dependency meanings, every Lean hypothesis supplies the source's common probability space, nonempty finite independent centered sub-exponential family, t ≥ 0, and λ > 0. Its conclusion is exactly the ENNReal rendering of P{S ≥ t} ≤ exp(−λt)∏ᵢE exp(λXᵢ).
- **Source implies lean:** `yes`. The source's positive integer N can be represented by a nonempty finite index type; 'random variable', 'mean zero', 'sub-exponential', and 'independent' provide the explicit measurability, integrability/zero-integral, finite PsiOneGauge, and iIndepFun assumptions. The extended nonnegative lintegral faithfully represents finite or infinite MGFs, so the source conclusion yields the Lean conclusion.

## Findings

- **note / extended-valued MGF convention:** Lean makes the intended extended-valued interpretation explicit; this handles infinite-MGF cases without changing the inequality's strength.
- **note / extended-nonnegative-real-formulation:** This makes the source's finite-or-infinite MGF semantics explicit without changing the inequality.
- **note / indexing:** The difference is a harmless reindexing-invariant formulation.
- **note / formula-shape:** The central displayed proof inequality is preserved exactly.

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

- Blind translator covered `95` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `95` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/agent_outputs/agent_runs.json` (`f6b058edaf4d2bbef24036ccd5c2fec90029a4e18bc5a64db8af37ed25721c8d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/agent_outputs/blind_translation.json` (`f7d84497e3a58d1ef57f3d4f753b43a001390f4a563987e4308678241ba6f71b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/agent_outputs/direct_judge.json` (`9a84775db664c646c91235953f96935d6acf55b77e3c37bfb22ed58ce6e66cd2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/agent_outputs/roundtrip_judge.json` (`1243c356ce237afbfb92506962f278a4464955e746dfd22ce7c98bf632da3dcf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/agent_outputs/source_contract.json` (`894db76e160bbf698100d690e83940794a961375f621ae59dc3aea91bc97e7d2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/decision.json` (`f3e617b6591b5a4dac20baf2a27ce07cdc59234af94589a435c24a5e851f62c3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/agent_outputs/agent_runs.json` (`a9644ee8df923de94ef8636b598a52999a987b9111d3d6d77e6cce689e251c98`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/agent_outputs/blind_translation.json` (`f8eaf5f18a91c70a4ec60c129746813b461cd2e261537924b28d551d97c3c472`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/agent_outputs/source_contract.json` (`894db76e160bbf698100d690e83940794a961375f621ae59dc3aea91bc97e7d2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/inputs/batch_source_locator.json` (`ec5cb95affd594b55cf7a42816ff3bbe96a38c2a912b8e9588cc03c01faac3f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/inputs/blind_dependency_inventory.json` (`e854bf6749e53a1805a8aaf7d4b046d399e6a79010c3ffc5a9328b7d4278dd81`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/inputs/blind_dossier.md` (`3ff6d7edae936e7da5bb07eed5f8919da5edb24d9040c727244fec266b50fc6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/inputs/blind_review_packet.md` (`3ff6d7edae936e7da5bb07eed5f8919da5edb24d9040c727244fec266b50fc6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/inputs/declaration_dossier.md` (`13a1e1af00d68a123b66847a484432d791616dfcbf8674c84112bcec42c7813d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/inputs/dependency_inventory.json` (`e854bf6749e53a1805a8aaf7d4b046d399e6a79010c3ffc5a9328b7d4278dd81`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/inputs/direct_review_packet.md` (`baa8d88613616c57800a58ce1358b3d5566784089b541f43b1ea82f6cb62c410`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T025653Z/inputs/source_locator.json` (`3cf29c1e639574d3b65e6bef092e79e623713be46ee44f51ba0eb8684821883a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/agent_outputs/agent_runs.json` (`ed93ad7655378b122c192d4864a7a942cecf5c52bed654412aa41cdf9ccf3dea`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/agent_outputs/blind_translation.json` (`f8eaf5f18a91c70a4ec60c129746813b461cd2e261537924b28d551d97c3c472`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/agent_outputs/direct_judge.json` (`6109a35a7e79e9a54de54333989b9babcf8dbb4371a61bbd0706b74440e1547c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/agent_outputs/roundtrip_judge.json` (`104398b315ad90735047ba4718e761638e1abb9a4a627650996dd3b3944bc520`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/agent_outputs/source_contract.json` (`894db76e160bbf698100d690e83940794a961375f621ae59dc3aea91bc97e7d2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/inputs/batch_source_locator.json` (`ec5cb95affd594b55cf7a42816ff3bbe96a38c2a912b8e9588cc03c01faac3f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/inputs/blind_dependency_inventory.json` (`e854bf6749e53a1805a8aaf7d4b046d399e6a79010c3ffc5a9328b7d4278dd81`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/inputs/blind_dossier.md` (`3ff6d7edae936e7da5bb07eed5f8919da5edb24d9040c727244fec266b50fc6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/inputs/blind_review_packet.md` (`3ff6d7edae936e7da5bb07eed5f8919da5edb24d9040c727244fec266b50fc6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/inputs/declaration_dossier.md` (`43a09f20a0d6848e35dc74fc193ccab6a2eaaff896fc6baf0a2dda3e673c3e18`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/inputs/dependency_inventory.json` (`e854bf6749e53a1805a8aaf7d4b046d399e6a79010c3ffc5a9328b7d4278dd81`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/inputs/direct_review_packet.md` (`6b8d211dc63f2b70aabd699dccb7e84cc4cc5238b25d108a555a1b48e3e900c3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260829T031358Z/inputs/source_locator.json` (`3cf29c1e639574d3b65e6bef092e79e623713be46ee44f51ba0eb8684821883a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/agent_outputs/agent_runs.json` (`7e795df298bcc35f1b337b72d71d8897fc886d402e50c5099b05f4af5c55950b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/agent_outputs/blind_translation.json` (`f7d84497e3a58d1ef57f3d4f753b43a001390f4a563987e4308678241ba6f71b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/agent_outputs/direct_judge.json` (`9a84775db664c646c91235953f96935d6acf55b77e3c37bfb22ed58ce6e66cd2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/agent_outputs/roundtrip_judge.json` (`1243c356ce237afbfb92506962f278a4464955e746dfd22ce7c98bf632da3dcf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/agent_outputs/source_contract.json` (`894db76e160bbf698100d690e83940794a961375f621ae59dc3aea91bc97e7d2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/decision.json` (`6166559dff235c47636eb7eb75247b643536b10c67afe4f1c1755bdfa3e92f59`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/inputs/batch_source_locator.json` (`ec5cb95affd594b55cf7a42816ff3bbe96a38c2a912b8e9588cc03c01faac3f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/inputs/blind_dependency_inventory.json` (`fb16d4c9b16f8c643058adcdba2afb1a2c333050c0278b7ce50244c7c0c69f5b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/inputs/blind_dossier.md` (`2cea670754968c42dff9183a86312023b0d9d665a8f9555a83b4da75f58637b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/inputs/blind_review_packet.md` (`2cea670754968c42dff9183a86312023b0d9d665a8f9555a83b4da75f58637b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/inputs/declaration_dossier.md` (`2fa58215e7d8782782e362981d7becc6d2b052929a7054265662c8a20c60d09a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/inputs/dependency_inventory.json` (`63d591c85d474b5157908022ef20bc5194590b167c15a73087c2bdec09655f9c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/inputs/direct_review_packet.md` (`ad7f572242ca8cd47816163ef649d062fff9ae9439f0624f0aeb7c432f28b8fe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T083705Z/inputs/source_locator.json` (`3cf29c1e639574d3b65e6bef092e79e623713be46ee44f51ba0eb8684821883a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/agent_outputs/agent_runs.json` (`f6b058edaf4d2bbef24036ccd5c2fec90029a4e18bc5a64db8af37ed25721c8d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/agent_outputs/blind_translation.json` (`f7d84497e3a58d1ef57f3d4f753b43a001390f4a563987e4308678241ba6f71b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/agent_outputs/direct_judge.json` (`9a84775db664c646c91235953f96935d6acf55b77e3c37bfb22ed58ce6e66cd2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/agent_outputs/roundtrip_judge.json` (`1243c356ce237afbfb92506962f278a4464955e746dfd22ce7c98bf632da3dcf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/agent_outputs/source_contract.json` (`894db76e160bbf698100d690e83940794a961375f621ae59dc3aea91bc97e7d2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/decision.json` (`b92adcd924d29e12c963cbd48596b4ce973a2473a27119923314bf074c2522bc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/inputs/blind_dependency_inventory.json` (`fb16d4c9b16f8c643058adcdba2afb1a2c333050c0278b7ce50244c7c0c69f5b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/inputs/blind_dossier.md` (`2cea670754968c42dff9183a86312023b0d9d665a8f9555a83b4da75f58637b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/inputs/blind_review_packet.md` (`2cea670754968c42dff9183a86312023b0d9d665a8f9555a83b4da75f58637b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/inputs/declaration_dossier.md` (`cae2790693ecfa445d65b663373be6568382c73deb51d274cd8655bdffaa6c2b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/inputs/dependency_inventory.json` (`63d591c85d474b5157908022ef20bc5194590b167c15a73087c2bdec09655f9c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/inputs/direct_review_packet.md` (`ad7f572242ca8cd47816163ef649d062fff9ae9439f0624f0aeb7c432f28b8fe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T101244Z/inputs/source_locator.json` (`3cf29c1e639574d3b65e6bef092e79e623713be46ee44f51ba0eb8684821883a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/agent_outputs/agent_runs.json` (`f6b058edaf4d2bbef24036ccd5c2fec90029a4e18bc5a64db8af37ed25721c8d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/agent_outputs/blind_translation.json` (`f7d84497e3a58d1ef57f3d4f753b43a001390f4a563987e4308678241ba6f71b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/agent_outputs/direct_judge.json` (`9a84775db664c646c91235953f96935d6acf55b77e3c37bfb22ed58ce6e66cd2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/agent_outputs/roundtrip_judge.json` (`1243c356ce237afbfb92506962f278a4464955e746dfd22ce7c98bf632da3dcf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/agent_outputs/source_contract.json` (`894db76e160bbf698100d690e83940794a961375f621ae59dc3aea91bc97e7d2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/decision.json` (`5871af8d5383c4dca71725ed0af75348112b95b0212aa5c432e4baf59c1b9654`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/inputs/blind_dependency_inventory.json` (`fb16d4c9b16f8c643058adcdba2afb1a2c333050c0278b7ce50244c7c0c69f5b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/inputs/blind_dossier.md` (`2cea670754968c42dff9183a86312023b0d9d665a8f9555a83b4da75f58637b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/inputs/blind_review_packet.md` (`2cea670754968c42dff9183a86312023b0d9d665a8f9555a83b4da75f58637b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/inputs/declaration_dossier.md` (`63c3d1fe01bd4e56662863e8f1cd6f4450b1bb57a3720ddaa4b423d9bf36f96f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/inputs/dependency_inventory.json` (`63d591c85d474b5157908022ef20bc5194590b167c15a73087c2bdec09655f9c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/inputs/direct_review_packet.md` (`ad7f572242ca8cd47816163ef649d062fff9ae9439f0624f0aeb7c432f28b8fe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/history/20260831T203117Z/inputs/source_locator.json` (`3cf29c1e639574d3b65e6bef092e79e623713be46ee44f51ba0eb8684821883a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/inputs/blind_dependency_inventory.json` (`fb16d4c9b16f8c643058adcdba2afb1a2c333050c0278b7ce50244c7c0c69f5b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/inputs/blind_dossier.md` (`2cea670754968c42dff9183a86312023b0d9d665a8f9555a83b4da75f58637b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/inputs/blind_review_packet.md` (`2cea670754968c42dff9183a86312023b0d9d665a8f9555a83b4da75f58637b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/inputs/declaration_dossier.md` (`8fe7e5f06de2266c37b870001f3222c44e87102fb40fb4a222659c9330669c6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/inputs/dependency_inventory.json` (`63d591c85d474b5157908022ef20bc5194590b167c15a73087c2bdec09655f9c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/inputs/direct_review_packet.md` (`ad7f572242ca8cd47816163ef649d062fff9ae9439f0624f0aeb7c432f28b8fe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.23/faithfulness/inputs/source_locator.json` (`3cf29c1e639574d3b65e6bef092e79e623713be46ee44f51ba0eb8684821883a`)
