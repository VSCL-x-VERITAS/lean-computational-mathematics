# Faithfulness audit: HDP-02-EX-2.8.5

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `75f95d4891e3ba80a9ff155b4501f1e08172d525dd278570ec40a7c39c3fe3c5`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The actual Lean target reproduces Exercise 2.8.5's upper MGF bound with the exact coefficient (lam^2/2)/(1-|lam|K/3), the exact raw second moment integral of X^2, both signs of lambda, and the strict source domain. The source's displayed interval |lambda|<3/K carries an implicit K>0 convention; Lean makes it explicit and uses the equivalent multiplication form. The source's bounded-random-variable language supplies measurability and, on a probability space, integrability of X, X^2, and exp(lambda X), so the formal regularity clauses are redundant rather than applicability-reducing. The almost-everywhere bound is the standard meaning of such a probabilistic inequality. All dependencies preserve ordinary real arithmetic, order, absolute value, exponential, and expectation semantics. The formal theorem and intended source result therefore imply each other.

## Implications

- **Lean implies source:** `yes`. With the source's implicit convention K>0 and its standard almost-sure interpretation of a random-variable bound, the Lean hypotheses instantiate exactly the source hypotheses. The condition |lam|*K<3 is equivalent to |lam|<3/K, and the Lean inequality is textually the same MGF bound with the same raw second moment and constants.
- **Source implies lean:** `yes`. A source random variable is measurable, and an almost-surely K-bounded real random variable on a probability space is integrable; its square and exp(lam X) are also integrable for every admissible lam. Therefore the source assumptions supply the explicit Lean regularity facts, while positive K converts the source domain exactly to |lam|*K<3, yielding both Lean conclusion conjuncts.

## Findings

- **note / implicit-positive-bound:** This makes an implicit source convention explicit and does not remove any intended application; it also handles the denominator and boundary conditions correctly.
- **note / almost-everywhere-boundedness:** This is the standard probabilistic interpretation. Even under a representative-level pointwise reading, null-set changes do not affect the expectations or inequality, so the mathematical applicability is unchanged.
- **note / explicit-regularity:** These properties follow from the source assumptions on a probability space, so their explicit formal treatment neither narrows the intended domain nor strengthens the substantive MGF claim.
- **note / explicit-regularity:** These additions are redundant consequences or explicit well-definedness conditions in the bounded probability-space setting and do not alter applicability or the bound.
- **note / boundedness-convention:** This matches the standard probability-theoretic convention and preserves the expectation-level mathematical content.

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

- Blind translator covered `62` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `62` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/agent_outputs/agent_runs.json` (`98149460fa42e73b733720ae622185db2c818c8a2f3eecf5261b45ba8a910d2f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/agent_outputs/blind_translation.json` (`e7196f839ad0f3e60d86f5538844abd5b8c81ec0c2b7a42bd5e65610450097f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/agent_outputs/direct_judge.json` (`9921c8acbb1269adaa41ca1d41ffd9478b348beee559c50ab7aeb8f247c7a907`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/agent_outputs/roundtrip_judge.json` (`7776c80bb4516d1e9eaae0e2c0cef62632e58e962f6123a07f67f795e0c26751`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/agent_outputs/source_contract.json` (`76f98d20c38b79547052fc21cda270efb011b0c6c959612db50df732a91da9c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/decision.json` (`b8ce27648e4091c58e34340feaa7f804a41a2ad7d87acd947630338a4d6b4220`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T024636Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T024636Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T024636Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T024636Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T024636Z/inputs/declaration_dossier.md` (`b018270b242a317d28160acc6fcc3a0ac589f71c8f9080815986b4a155a86d1c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T024636Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T024636Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T024636Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T030222Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T030222Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T030222Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T030222Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T030222Z/inputs/declaration_dossier.md` (`b018270b242a317d28160acc6fcc3a0ac589f71c8f9080815986b4a155a86d1c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T030222Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T030222Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T030222Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/agent_outputs/agent_runs.json` (`6d014ed03fd44d9f9216fc354f98bb7de7ecf57eca4854900f08d5e740d07008`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/agent_outputs/source_contract.json` (`76f98d20c38b79547052fc21cda270efb011b0c6c959612db50df732a91da9c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/inputs/declaration_dossier.md` (`b018270b242a317d28160acc6fcc3a0ac589f71c8f9080815986b4a155a86d1c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T221507Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/agent_outputs/agent_runs.json` (`eb75e8a6c0fed9dab388535faf2e27749f34c5d1271010e1cf117e2a4b96ffb1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/agent_outputs/blind_translation.json` (`e7196f839ad0f3e60d86f5538844abd5b8c81ec0c2b7a42bd5e65610450097f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/agent_outputs/direct_judge.json` (`9921c8acbb1269adaa41ca1d41ffd9478b348beee559c50ab7aeb8f247c7a907`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/agent_outputs/roundtrip_judge.json` (`7776c80bb4516d1e9eaae0e2c0cef62632e58e962f6123a07f67f795e0c26751`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/agent_outputs/source_contract.json` (`76f98d20c38b79547052fc21cda270efb011b0c6c959612db50df732a91da9c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/decision.json` (`a1c416697af5c08e52c082542dc296bf6aa2543a45a4cf02d4a3121e91462fb0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/inputs/declaration_dossier.md` (`f8f09b1dd7cd55c4b3e03bb0088c52e05b5911a4c2b95c4ccaa45dddd45692e8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260828T230029Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/agent_outputs/agent_runs.json` (`5b6431de2bda944420d1d5b08d7419a63235271124b36f349d45d87315b95d7b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/agent_outputs/blind_translation.json` (`e7196f839ad0f3e60d86f5538844abd5b8c81ec0c2b7a42bd5e65610450097f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/agent_outputs/direct_judge.json` (`9921c8acbb1269adaa41ca1d41ffd9478b348beee559c50ab7aeb8f247c7a907`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/agent_outputs/roundtrip_judge.json` (`7776c80bb4516d1e9eaae0e2c0cef62632e58e962f6123a07f67f795e0c26751`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/agent_outputs/source_contract.json` (`76f98d20c38b79547052fc21cda270efb011b0c6c959612db50df732a91da9c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/decision.json` (`0e24af08e0f4eb5fa0366afa8e45842be33db654d9750909f055eb9e7617db19`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/inputs/declaration_dossier.md` (`f8f09b1dd7cd55c4b3e03bb0088c52e05b5911a4c2b95c4ccaa45dddd45692e8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T002848Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/agent_outputs/agent_runs.json` (`116d2237f2902914491fff9346222fb55224d8bd2631444fe4b56203ebcb76af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/agent_outputs/blind_translation.json` (`e7196f839ad0f3e60d86f5538844abd5b8c81ec0c2b7a42bd5e65610450097f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/agent_outputs/direct_judge.json` (`9921c8acbb1269adaa41ca1d41ffd9478b348beee559c50ab7aeb8f247c7a907`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/agent_outputs/roundtrip_judge.json` (`7776c80bb4516d1e9eaae0e2c0cef62632e58e962f6123a07f67f795e0c26751`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/agent_outputs/source_contract.json` (`76f98d20c38b79547052fc21cda270efb011b0c6c959612db50df732a91da9c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/decision.json` (`78efdacc60845d5b988ca84b00f03baa0816639dc00534b879fe04a5a838fc78`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/inputs/declaration_dossier.md` (`f8f09b1dd7cd55c4b3e03bb0088c52e05b5911a4c2b95c4ccaa45dddd45692e8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T014629Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/agent_outputs/agent_runs.json` (`116d2237f2902914491fff9346222fb55224d8bd2631444fe4b56203ebcb76af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/agent_outputs/blind_translation.json` (`e7196f839ad0f3e60d86f5538844abd5b8c81ec0c2b7a42bd5e65610450097f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/agent_outputs/direct_judge.json` (`9921c8acbb1269adaa41ca1d41ffd9478b348beee559c50ab7aeb8f247c7a907`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/agent_outputs/roundtrip_judge.json` (`7776c80bb4516d1e9eaae0e2c0cef62632e58e962f6123a07f67f795e0c26751`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/agent_outputs/source_contract.json` (`76f98d20c38b79547052fc21cda270efb011b0c6c959612db50df732a91da9c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/decision.json` (`e0dc787ac5dd6149c9f44ad7dca7903d87f9ac1052b7442ed0b8196493a4ee47`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/inputs/declaration_dossier.md` (`f8f09b1dd7cd55c4b3e03bb0088c52e05b5911a4c2b95c4ccaa45dddd45692e8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T021246Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/agent_outputs/agent_runs.json` (`116d2237f2902914491fff9346222fb55224d8bd2631444fe4b56203ebcb76af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/agent_outputs/blind_translation.json` (`e7196f839ad0f3e60d86f5538844abd5b8c81ec0c2b7a42bd5e65610450097f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/agent_outputs/direct_judge.json` (`9921c8acbb1269adaa41ca1d41ffd9478b348beee559c50ab7aeb8f247c7a907`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/agent_outputs/roundtrip_judge.json` (`7776c80bb4516d1e9eaae0e2c0cef62632e58e962f6123a07f67f795e0c26751`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/agent_outputs/source_contract.json` (`76f98d20c38b79547052fc21cda270efb011b0c6c959612db50df732a91da9c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/decision.json` (`cc2b3b0dd36e888fd49468a2d9e7cfa91042cf6e624f956986794e110e5c5464`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/inputs/declaration_dossier.md` (`f8f09b1dd7cd55c4b3e03bb0088c52e05b5911a4c2b95c4ccaa45dddd45692e8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T023453Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/agent_outputs/agent_runs.json` (`116d2237f2902914491fff9346222fb55224d8bd2631444fe4b56203ebcb76af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/agent_outputs/blind_translation.json` (`e7196f839ad0f3e60d86f5538844abd5b8c81ec0c2b7a42bd5e65610450097f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/agent_outputs/direct_judge.json` (`9921c8acbb1269adaa41ca1d41ffd9478b348beee559c50ab7aeb8f247c7a907`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/agent_outputs/roundtrip_judge.json` (`7776c80bb4516d1e9eaae0e2c0cef62632e58e962f6123a07f67f795e0c26751`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/agent_outputs/source_contract.json` (`76f98d20c38b79547052fc21cda270efb011b0c6c959612db50df732a91da9c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/decision.json` (`f31a2d975e7f3ab7c5ef79f04d4bc8961d8f28de0cf6e04fe2d042c417879ff9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/inputs/declaration_dossier.md` (`f8f09b1dd7cd55c4b3e03bb0088c52e05b5911a4c2b95c4ccaa45dddd45692e8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260829T031511Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/agent_outputs/agent_runs.json` (`116d2237f2902914491fff9346222fb55224d8bd2631444fe4b56203ebcb76af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/agent_outputs/blind_translation.json` (`e7196f839ad0f3e60d86f5538844abd5b8c81ec0c2b7a42bd5e65610450097f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/agent_outputs/direct_judge.json` (`9921c8acbb1269adaa41ca1d41ffd9478b348beee559c50ab7aeb8f247c7a907`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/agent_outputs/roundtrip_judge.json` (`7776c80bb4516d1e9eaae0e2c0cef62632e58e962f6123a07f67f795e0c26751`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/agent_outputs/source_contract.json` (`76f98d20c38b79547052fc21cda270efb011b0c6c959612db50df732a91da9c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/decision.json` (`63f459cb0b03fbe17462a78cdba28675a7932289cd13bac8608cafc2615b468f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/inputs/declaration_dossier.md` (`7956649968c5ee036916edbd8b92fae248bacc33de608be1f537a0169db05718`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T084828Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/agent_outputs/agent_runs.json` (`98149460fa42e73b733720ae622185db2c818c8a2f3eecf5261b45ba8a910d2f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/agent_outputs/blind_translation.json` (`e7196f839ad0f3e60d86f5538844abd5b8c81ec0c2b7a42bd5e65610450097f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/agent_outputs/direct_judge.json` (`9921c8acbb1269adaa41ca1d41ffd9478b348beee559c50ab7aeb8f247c7a907`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/agent_outputs/roundtrip_judge.json` (`7776c80bb4516d1e9eaae0e2c0cef62632e58e962f6123a07f67f795e0c26751`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/agent_outputs/source_contract.json` (`76f98d20c38b79547052fc21cda270efb011b0c6c959612db50df732a91da9c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/decision.json` (`9e36c80b796dbb244349dd2e57da7d80ecdac8cb098b7e394657b24a5a6d1235`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/inputs/declaration_dossier.md` (`17b78da99bdfd840ac9c6af06612c7471ece50571f172345dd024a6e85b68ee3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/history/20260831T101720Z/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/inputs/blind_dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/inputs/blind_dossier.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/inputs/blind_review_packet.md` (`9637d5a4854339f2fab3f77beaf6b26dd64c13424a102be7435a76d41f9b157a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/inputs/declaration_dossier.md` (`1177eb6d0f6c46ff5c157c9d69da9739caa1fb3fa15c25a5de1a417a24ae504f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/inputs/dependency_inventory.json` (`d47e93ad4e87d3a901bfe37f95fa755fa647fa3c91b57c91844ebacbae02805a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/inputs/direct_review_packet.md` (`119897f62bac147d975a95275ddde2c938e07e331a86501b6133744193aee593`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.8.5/faithfulness/inputs/source_locator.json` (`fd0998200320dd7da4af5e18dfe796eb696bcbf0af6f4d88e9a3f071f5d275a2`)
