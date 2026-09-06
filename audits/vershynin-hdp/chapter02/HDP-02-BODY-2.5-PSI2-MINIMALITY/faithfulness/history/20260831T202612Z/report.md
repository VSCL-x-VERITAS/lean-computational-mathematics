# Faithfulness audit: HDP-02-BODY-2.5-PSI2-MINIMALITY

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `0d4a4e294d1454f1cf12439a9bb623c6bb14d0be5d7ee728174db5b60d848e2a`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The role disagreements reduce to two independent questions. First, fixed numerical forward bounds are stronger than a source assertion that merely supplies unspecified absolute constants, so source-implies-Lean is no; this is genuine strength rather than a domain restriction. Second, the target's finite-gauge hypothesis admits gauge zero and its quotient dependencies implement totalized Real division, but the selected source does not say how its quotient displays are to be interpreted at norm zero. The positive-gauge Lean proposition implies the source claim, and all four converse minimality clauses have the correct scopes and directions, but a global implication would require an unstated source convention. Under the protocol's rule to preserve missing source information as uncertainty, Lean-implies-source is unclear. The resulting classification is undetermined and acceptance is false.

## Implications

- **Lean implies source:** `unclear`. On the positive-gauge domain, yes: the fixed forward constants are valid instances of absolute constants, and the universal normalized converse bounds express per-inequality minimality up to an absolute factor. The full target also admits PsiTwoGauge = 0 and assigns Real's totalized meaning to quotient-bearing displays, while the selected source states no 0/0 or degenerate-gauge convention. The protocol forbids inventing that missing source intent, so the global implication remains unclear.
- **Source implies lean:** `no`. The source asserts only unspecified positive absolute constants. It does not entail the target's particular forward witnesses c = 1/4, 16e, and (128e)^2; it also does not specify the target's totalized zero-gauge quotient behavior. Thus the target is genuinely stronger on positive gauge but is not derivable from the selected source claim.

## Findings

- **critical / source-silent-zero-gauge-division:** This is the exact blocker to Lean-implies-source and therefore forces an undetermined, unaccepted audit decision unless the authoritative source scope or convention is clarified.
- **major / fixed-forward-constants:** Source-implies-Lean is no. On positive gauge this is genuine nonvacuous strength, not reduced applicability, but it cannot make the audit accepted while the opposite implication remains unclear.
- **note / standard-external-frontier-dependencies:** The blind translator's D037 and D039 uncertainties are resolved and do not add a blocker.
- **note / absolute-factor-quantification:** Using one non-sharp universal comparison constant is compatible with four per-characterization absolute factors by taking their finite maximum; this is not the discrepancy.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `unclear` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `fail` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `113` dependencies (`0` hash-reused); unclear: `D037, D039`.
- Direct judge covered `113` dependencies (`0` hash-reused); failing or unclear: `D002, D077, D079, D081, D090, D097, D107`.

## Remaining uncertainties

- The selected source gives no convention for quotient-bearing displays when ||X||_{psi_2} = 0, whereas the target admits PsiTwoGauge = 0 and uses totalized Real division. Consequently the global Lean-implies-source direction cannot be certified from the prepared evidence.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/agent_outputs/adjudicator.json` (`4be10dac1e2850584560dedde9753528e9dc2906d147ba4ca61eafcf30f3f511`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/agent_outputs/agent_runs.json` (`ab0c809316809c314c0cf0a59e4a504840c0465a8630f0ac6aa2bf4e16e4de1f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/agent_outputs/batch_source_contract.json` (`d47a31a769ee1032fe28914d5fbcee44503a1bba247dc3644474a184c023ce85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/agent_outputs/blind_translation.json` (`51e7f75897ad1cfaf8f85bab69bb5c3b256810a0236b83bd182b7b639dc4401e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/agent_outputs/direct_judge.json` (`f8d7bbb2c99bb9fc6c2d21af0b2f4f0eefbecf9beee79d231be439e8621257e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/agent_outputs/roundtrip_judge.json` (`4526f14fdbd8545e84d58ba8347a2637df2acd91138e5a61e512666c74398709`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/agent_outputs/source_contract.json` (`d553cc36d7f7d036400bc26be8a5ca3a458b16423b2666aca8e7c6b738a3c113`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/decision.json` (`8d6102ed554362c50a4a381e6696c39525c4dd8003a36b0fac6cf77e9a295993`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/agent_outputs/adjudicator.json` (`4be10dac1e2850584560dedde9753528e9dc2906d147ba4ca61eafcf30f3f511`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/agent_outputs/agent_runs.json` (`f9bea4eebd39dbd9bb80f8d0db364525a2bb7b5cc75a75fb4d8317d22c49466a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/agent_outputs/batch_source_contract.json` (`d47a31a769ee1032fe28914d5fbcee44503a1bba247dc3644474a184c023ce85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/agent_outputs/blind_translation.json` (`51e7f75897ad1cfaf8f85bab69bb5c3b256810a0236b83bd182b7b639dc4401e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/agent_outputs/direct_judge.json` (`f8d7bbb2c99bb9fc6c2d21af0b2f4f0eefbecf9beee79d231be439e8621257e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/agent_outputs/roundtrip_judge.json` (`4526f14fdbd8545e84d58ba8347a2637df2acd91138e5a61e512666c74398709`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/agent_outputs/source_contract.json` (`d553cc36d7f7d036400bc26be8a5ca3a458b16423b2666aca8e7c6b738a3c113`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/decision.json` (`4d0e572acf311622819482cdfb31b1a50888abc8aa152292843550aee427e830`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/inputs/batch_source_locator.json` (`f56421e644f3eec002ce3fc07fe2e980467902240b864fc7813676ef827eb91e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/inputs/blind_dependency_inventory.json` (`70033d23779bcf160e77d4a259ace697e00ae72c0e88eb9d9754829139df3220`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/inputs/blind_dossier.md` (`d1098521bc061b57bae1d276332a3789d9d3ea0a1967bda0672ebd70b6e51b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/inputs/blind_review_packet.md` (`d1098521bc061b57bae1d276332a3789d9d3ea0a1967bda0672ebd70b6e51b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/inputs/declaration_dossier.md` (`ad9de7fb0f86cdf52268dec4283098a5804da340c886d6c9efed9682ea62cb4c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/inputs/dependency_inventory.json` (`6a19627529046e634c8a9fab2e4f852976c5b43f18759227dac4c4fa16b509a0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/inputs/direct_review_packet.md` (`6ff7e18aeb21200b162757f6995c65ec3363a39dfc81d5b30701771f138c27ba`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T083027Z/inputs/source_locator.json` (`c3f5aaa0f7ac0e1fd7e51b9d13c345792267b233c69d68065075d1edc2bfda33`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/agent_outputs/adjudicator.json` (`4be10dac1e2850584560dedde9753528e9dc2906d147ba4ca61eafcf30f3f511`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/agent_outputs/agent_runs.json` (`ab0c809316809c314c0cf0a59e4a504840c0465a8630f0ac6aa2bf4e16e4de1f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/agent_outputs/batch_source_contract.json` (`d47a31a769ee1032fe28914d5fbcee44503a1bba247dc3644474a184c023ce85`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/agent_outputs/blind_translation.json` (`51e7f75897ad1cfaf8f85bab69bb5c3b256810a0236b83bd182b7b639dc4401e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/agent_outputs/direct_judge.json` (`f8d7bbb2c99bb9fc6c2d21af0b2f4f0eefbecf9beee79d231be439e8621257e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/agent_outputs/roundtrip_judge.json` (`4526f14fdbd8545e84d58ba8347a2637df2acd91138e5a61e512666c74398709`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/agent_outputs/source_contract.json` (`d553cc36d7f7d036400bc26be8a5ca3a458b16423b2666aca8e7c6b738a3c113`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/decision.json` (`3b770cbdaa9f1495feb57275ac5866be4697cdb25f3019614dc2810d1feb0f39`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/inputs/blind_dependency_inventory.json` (`70033d23779bcf160e77d4a259ace697e00ae72c0e88eb9d9754829139df3220`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/inputs/blind_dossier.md` (`d1098521bc061b57bae1d276332a3789d9d3ea0a1967bda0672ebd70b6e51b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/inputs/blind_review_packet.md` (`d1098521bc061b57bae1d276332a3789d9d3ea0a1967bda0672ebd70b6e51b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/inputs/declaration_dossier.md` (`73852842a6a6842ca94fb52941d1c7c26c31ce32ae602380796593e968006b11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/inputs/dependency_inventory.json` (`6a19627529046e634c8a9fab2e4f852976c5b43f18759227dac4c4fa16b509a0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/inputs/direct_review_packet.md` (`6ff7e18aeb21200b162757f6995c65ec3363a39dfc81d5b30701771f138c27ba`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/history/20260831T100902Z/inputs/source_locator.json` (`c3f5aaa0f7ac0e1fd7e51b9d13c345792267b233c69d68065075d1edc2bfda33`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/inputs/blind_dependency_inventory.json` (`70033d23779bcf160e77d4a259ace697e00ae72c0e88eb9d9754829139df3220`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/inputs/blind_dossier.md` (`d1098521bc061b57bae1d276332a3789d9d3ea0a1967bda0672ebd70b6e51b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/inputs/blind_review_packet.md` (`d1098521bc061b57bae1d276332a3789d9d3ea0a1967bda0672ebd70b6e51b66`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/inputs/declaration_dossier.md` (`c437386b56a9d2a54e7efabd226ee3382170d4c326007f626fa220394e913cb3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/inputs/dependency_inventory.json` (`6a19627529046e634c8a9fab2e4f852976c5b43f18759227dac4c4fa16b509a0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/inputs/direct_review_packet.md` (`6ff7e18aeb21200b162757f6995c65ec3363a39dfc81d5b30701771f138c27ba`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.5-PSI2-MINIMALITY/faithfulness/inputs/source_locator.json` (`c3f5aaa0f7ac0e1fd7e51b9d13c345792267b233c69d68065075d1edc2bfda33`)
