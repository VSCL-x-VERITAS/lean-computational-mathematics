# Faithfulness audit: HDP-02-DEF-2.7.5

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `2f3ed9fdf99976cf911025efdd88a954fd71e994bb46c5866f8f2e946aa33edd`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The judges correctly identified the source's internal mismatch between the property-(c) prose and the property-(d) display, but treated both as mandatory conclusions of this one target. The configured corpus resolves that source defect by separate gate rows and contracts: HDP-02-DEF-2.7.5 covers the classification plus the literal property-(c) prose, and HDP-02-EQ-2.21 covers display (2.21). Against the selected Definition row, every consequential binder, positivity condition, quantifier, property alternative, and gauge predicate is preserved. The only remaining wording issue, 'smallest', cannot coherently require attainment and is resolved as infimum language, as shown by the zero-variable boundary case. Both implication directions therefore hold, the proposition is nonvacuous, and the classification is faithful-equivalent.

## Implications

- **Lean implies source:** `yes`. Relative to the selected Definition 2.7.5 property-(c) contract, the Lean proposition states that the property-(c) infimum gauge is finite exactly when X satisfies one of Proposition 2.7.1(a)-(d) at a positive scale, and it exposes that gauge as the infimum of precisely the positive finite property-(c) admissible scales. These are the source classification and property-(c) norm clauses. The separately gated property-(d) display is not part of this implication obligation.
- **Source implies lean:** `yes`. The source classification and Proposition 2.7.1's four-way equivalence imply that an admissible property-(c) scale exists exactly for the sub-exponential class. Interpreting the norm's 'smallest K3' in its mathematically coherent infimum sense yields PsiOnePropertyThreeGauge and its defining sInf identity. ENNReal totalization gives top when no admissible scale exists and 0 for boundary infima, without adding an attainment claim.

## Findings

- **note / selected-contract split for inconsistent source clauses:** Acceptance is limited to this row's property-(c) definition contract and must not be cited as certifying the distinct display-(2.21) equality or an exact equality between the two gauges.
- **note / smallest means infimum without attainment:** The Lean sInf construction is faithful to the coherent norm semantics. No admissibility-at-the-infimum conclusion should be inferred.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `fail` | `fail` |
| `C06` | `fail` | `fail` |
| `C07` | `fail` | `fail` |
| `C08` | `fail` | `fail` |
| `C09` | `fail` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `102` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `102` dependencies (`0` hash-reused); failing or unclear: `D002`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/agent_outputs/adjudicator.json` (`13bdde755cadcb0d78bcf02a4ebbedda7ba872c8ef40c6257b7d1452377a5f09`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/agent_outputs/agent_runs.json` (`6e87f06af643b651245125100b2c44de98b97430310fd12cdec0a7ea36022b77`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/agent_outputs/blind_translation.json` (`0406779c5b1bf89062e81ea8dcdb514a2085f53dfe6d954fbe9be22e27daf0fa`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/agent_outputs/direct_judge.json` (`30fa5e7ccb4d4016993215708e1aa66d4246550485785abe197d60e8d0b3af06`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/agent_outputs/roundtrip_judge.json` (`9d56f4d104983672bb806e0b08a988fcb6180dd2a7ee66bd9a342db160c44a52`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/agent_outputs/source_contract.json` (`71c1bfadec4255560afb3d13798c01e9c8ce132ada1fcc5587e8088843f5f700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/decision.json` (`9f7ade74b4ed8a249bdd70c56c303974004604403ae771a39056cd6539acd52b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/agent_outputs/adjudicator.json` (`73953bc20e57de5f2feb52985ede1a8b5936476b4925fb2be568f089b1f5a481`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/agent_outputs/agent_runs.json` (`3f19732f22e033185ac1b19450bd9e6985aef7cf9888060377269870bf4b71c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/agent_outputs/batch_source_contract.json` (`4ebe1af4c0627a3d03ad37d2e0f49d55aa03c0529180ace45df3de42da8b70b0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/agent_outputs/blind_translation.json` (`884a1b28fd39db92c4d546ef5fa4bf1e637b87598867b21d0c7d3127f2ea3138`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/agent_outputs/direct_judge.json` (`4de7c4697373f549c8136edda6a91f220e45529ac73e54bf28099ba149746343`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/agent_outputs/roundtrip_judge.json` (`37acf0fd0709c5f2286514e10782a37c7ef626f5f76dcbc1e6699612a4ebf1e6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/agent_outputs/source_contract.json` (`45c352e00533bc851b1284de83b0fe52d55bb6db3a8c70120b6cc23acb235416`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/decision.json` (`7ebf5b5fe8d855bb21ff1f9836013699b2065684ddc006df6982d9726296d394`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/inputs/batch_source_locator.json` (`71ac7c8fdc2c77a852751bf33b7ed201d5c8832272eb22e99a2e37ce5786de30`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/inputs/blind_dependency_inventory.json` (`6e693d87e84839aab3580764bccdceace40d8284dd27ddb9abc12dc36b0938dd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/inputs/blind_dossier.md` (`c2f1468a135220ea8205c807d5b88d40cc9e12265e0e2093ac39310d95808bc5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/inputs/blind_review_packet.md` (`c2f1468a135220ea8205c807d5b88d40cc9e12265e0e2093ac39310d95808bc5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/inputs/declaration_dossier.md` (`8a19cad4af3c7196238274448dac39e1092b52a4cbe0c617f02ce80e00ad788c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/inputs/dependency_inventory.json` (`97489f07173a3fbbe205361d4d0235673ab378726450336e00cc93ab052fd276`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/inputs/direct_review_packet.md` (`e880101c8faa5cc34ac2e8bae15972539591c336106683729dd6674564040c0b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T171602Z/inputs/source_locator.json` (`71e187b0b7518f344d622081c5171c2fafeadaee71906a680cfcefde3c111409`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T185727Z/agent_outputs/agent_runs.json` (`2cb515be424a839d85a34bd8a193c26566b9855cd18fde7d7788f93d89d3ee8b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T185727Z/agent_outputs/source_contract.json` (`71c1bfadec4255560afb3d13798c01e9c8ce132ada1fcc5587e8088843f5f700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T185727Z/inputs/blind_dependency_inventory.json` (`29634ec59e183db733201cdc47749ca13eb64b99435e9240da7ff8bed0b3fa3b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T185727Z/inputs/blind_dossier.md` (`d2a3297b0c13f58b3b59e1bd74104f496545e3b4f72b78aac17986b46acd7e81`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T185727Z/inputs/blind_review_packet.md` (`d2a3297b0c13f58b3b59e1bd74104f496545e3b4f72b78aac17986b46acd7e81`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T185727Z/inputs/declaration_dossier.md` (`53e211ade559865db6e675fbdc53aa3188f887ce2261e3fc84e4f883b7ddc0f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T185727Z/inputs/dependency_inventory.json` (`e51f1e8192dc5e06bb8c55b9b3a5def721cae5a7b7cd2b03268e315fbb6c4cc9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T185727Z/inputs/direct_review_packet.md` (`62e9e6423548fed940b01f9a28a098cbf3527c808a89dd889b39723a74e19a6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/history/20260831T185727Z/inputs/source_locator.json` (`71e187b0b7518f344d622081c5171c2fafeadaee71906a680cfcefde3c111409`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/inputs/blind_dependency_inventory.json` (`29634ec59e183db733201cdc47749ca13eb64b99435e9240da7ff8bed0b3fa3b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/inputs/blind_dossier.md` (`d2a3297b0c13f58b3b59e1bd74104f496545e3b4f72b78aac17986b46acd7e81`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/inputs/blind_review_packet.md` (`d2a3297b0c13f58b3b59e1bd74104f496545e3b4f72b78aac17986b46acd7e81`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/inputs/declaration_dossier.md` (`db5ec4d4dc9055e191a9bf8a9f01d42a7f65849e5174af703ebeea9fc543a40c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/inputs/dependency_inventory.json` (`e51f1e8192dc5e06bb8c55b9b3a5def721cae5a7b7cd2b03268e315fbb6c4cc9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/inputs/direct_review_packet.md` (`62e9e6423548fed940b01f9a28a098cbf3527c808a89dd889b39723a74e19a6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.7.5/faithfulness/inputs/source_locator.json` (`71e187b0b7518f344d622081c5171c2fafeadaee71906a680cfcefde3c111409`)
