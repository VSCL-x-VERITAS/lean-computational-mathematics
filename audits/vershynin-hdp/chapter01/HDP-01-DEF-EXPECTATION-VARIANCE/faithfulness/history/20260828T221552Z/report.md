# Faithfulness audit: HDP-01-DEF-EXPECTATION-VARIANCE

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `8086636f90225794f3985dc87b2e0266bb904c770c3e3dce07262d3ab3a39703`
- Source SHA-256: `855fdaf6870f664f1e470d47641b6d72758afdb9b87649a6494b027cecc02b17`

Independent comparison of the hash-verified source passage with the proof-free declaration and supplied dependency bodies establishes exact structural agreement: the same probability-space setting, measurable real random variable, expectation integral, centered subtraction, exponent two, outer expectation, conjunction, and equalities are present, and the statement is nonvacuous in the intended definitional sense. The decisive issue is not formula structure but exceptional-domain semantics. The source is silent about integrability and non-finite cases, while the formal operators are Real-valued for every measurable X; the authorized D012 declaration does not expose enough behavior to prove either equivalence or contradiction outside the ordinary finite-integral domain. Uncertainty must therefore be preserved, yielding an undetermined classification and no acceptance.

## Implications

- **Lean implies source:** `unclear`. After unfolding D001 and D002, Lean gives exactly the integral and centered-second-moment formulas, so the implication holds on the common ordinary finite-integral domain. The source does not specify exceptional cases, and D012's supplied opaque body does not establish a full-domain comparison.
- **Source implies lean:** `unclear`. The source yields the formal conjuncts once its finite Lebesgue integrals are identified with D012. It does not, however, determine the Real-valued formal convention for every measurable X, so the implication over the complete Lean domain cannot be certified.

## Findings

- **major / exceptional-domain-semantics:** Full-domain equivalence and both implication directions cannot be certified from the authorized evidence.
- **note / structural-agreement:** There is no demonstrated mismatch in binders, centering, squaring, measure identity, or formula strength on the shared finite-integral domain.
- **minor / terminology:** This affects recoverable terminology but not the two mathematical defining equalities.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `fail` |
| `C06` | `unclear` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `26` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `26` dependencies (`0` hash-reused); failing or unclear: `D012`.

## Remaining uncertainties

- The supplied declaration for D012 does not expose its behavior on non-integrable functions beyond showing a Real-valued operator.
- The selected source passage does not specify whether non-integrable expectations or variances are undefined, extended-valued, or governed by another convention.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/agent_outputs/adjudicator.json` (`96e54cc8d1a850b1c4fa60b9bd046c144b4799bba06c2e5b30be6072c6744a71`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/agent_outputs/agent_runs.json` (`40bb0e04d154924513bb22f90a45106a35a55a37bc56550deef38406784cc027`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/agent_outputs/blind_translation.json` (`41b9b21f541ee0be3a6a3bf354b7a58372c30224013f611662360ba30a386edc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/agent_outputs/direct_judge.json` (`7afe6dc4bd424e603ede6f6582948d353cf92cecf8ed7434b5ff07de3609b79b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/agent_outputs/roundtrip_judge.json` (`1c6cd438f7f217ecdd36ddca827975ee4c509e167c6e9ef4e8e50a4462360e0d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/agent_outputs/source_contract.json` (`bf2ce52ebf616a393ae3b505bfc268abe6e58419d1e43c971b07cd4824f45cd2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/decision.json` (`680fc2e2c0d3b8afa8fcc2948a0f30f478641585947b27c0ca375c5f20eb5286`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/agent_outputs/adjudicator.json` (`325522366873365ad2e0d535fb24a787ada9b9b49853896482ebd89470497ab8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/agent_outputs/agent_runs.json` (`242868be42c4c2b8ee63065841aa1f28d96aea1a376dbee7b2e795bbc795d205`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/agent_outputs/blind_translation.json` (`706aa548fcb9e722d428d0c12c246e3899ec55a57c7ac63a76dd54a3f081fc93`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/agent_outputs/direct_judge.json` (`88ebae6f2942967f9d3243f85831432d2ea54b9f70564caa7c30bef2ef616e3f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/agent_outputs/roundtrip_judge.json` (`9209cba646cdf4854d6a9d559d25479e84eb5dbbad964273db493dee6c786fa0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/agent_outputs/source_contract.json` (`215f0f6c7f5ba1a644b8c4181ecdead7a600bcda8e1a7d4c67de2fb4b2032330`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/decision.json` (`c282b4f6ec34100545924c8c47ab1251cefaba1acf8645960ffeccbebf53763b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/inputs/blind_dependency_inventory.json` (`1db389c92b7fb96173847dd1d4c411706ea915e5c6ae5b01d19b27e697b722d1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/inputs/blind_dossier.md` (`012867011f8bfa738fc4217b76246ad75cf0d2dbce5a602a46dba0403c533897`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/inputs/blind_review_packet.md` (`012867011f8bfa738fc4217b76246ad75cf0d2dbce5a602a46dba0403c533897`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/inputs/declaration_dossier.md` (`3916738031aebe9cd0812c5444a6a21999c3e149217847501c9c4badd883a759`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/inputs/dependency_inventory.json` (`e3463d788c3dfbe6e97ebec0bbe11aa65fdb4401d3ec4bb2756d044815ecc87b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/inputs/direct_review_packet.md` (`e40deffc2f1af092a1c2be890ce394efc29c31828e1cf63680f2dc9fe5b035c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/history/20260828T045653Z/inputs/source_locator.json` (`78297ef8f280aecfe2670967b0958e37d255900de7f3c2f43a5d4f03942e5594`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/inputs/blind_dependency_inventory.json` (`a69c3d11d8d434f4fd291ee3810fa2ea309eefd9e10a667f054f2f27b93ae1ad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/inputs/blind_dossier.md` (`0cfec7671a6094bdcf084b522093ea288a141fce9f7d05aa7bb38532e082fe78`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/inputs/blind_review_packet.md` (`0cfec7671a6094bdcf084b522093ea288a141fce9f7d05aa7bb38532e082fe78`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/inputs/declaration_dossier.md` (`cbce5d5c8d6fab7e0522b673981e978faea5940cf5058d2a6205754536ad29ef`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/inputs/dependency_inventory.json` (`204ed6ac749b32e0a6efdd65f0fba7bc5cf216985b113b41f7702d7d0fed4915`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/inputs/direct_review_packet.md` (`04369280041acead3cb69e5c4951db46942595848cf50d50fded5464050b33b3`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter01/HDP-01-DEF-EXPECTATION-VARIANCE/faithfulness/inputs/source_locator.json` (`78297ef8f280aecfe2670967b0958e37d255900de7f3c2f43a5d4f03942e5594`)
