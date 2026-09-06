# Faithfulness audit: HDP-02-PROP-2.5.2

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `a349af15a85f93cd9b9e459f90e8ce97e63ef5fa9caf31c4baed85a8839e8d08`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The repaired Lean proposition is a faithful quantitative formalization of Proposition 2.5.2. It binds one universal comparison constant outside all probability spaces and variables, covers every directed conversion among the four unconditional properties, and admits the linear-MGF property exactly in a separate integrable mean-zero branch. The unfolded property definitions preserve every source constant, exponent, boundary, and parameter dependence. The few additional clauses are explicit formal counterparts of random-variable measurability and finite expectations, and the direct moment inequality is algebraically equivalent to the source's Lp-norm display. Both implication directions therefore hold, no dependency or semantic check remains unresolved, and adjudication is not requested.

## Implications

- **Lean implies source:** `yes`. Unfolding the indexed predicates yields exactly source properties (i)-(iv) in the uncentered clause and properties (i)-(v) in the integrable mean-zero clause. The outer C is absolute, each directed conversion produces positive Kj<=C Ki, and C>=1 is harmless because any valid comparison constant may be enlarged. The moment predicate's power inequality is equivalent to the displayed Lp-norm inequality for p>=1 and K>0.
- **Source implies lean:** `yes`. The source's quantitative footnote supplies one absolute C for every directed conversion among (i)-(iv), and among all five under E X=0. Choosing C at least 1 gives the Lean outer witness. Its formulas instantiate each local predicate exactly; explicit measurability and integrability are inherent in the source's random-variable and finite-expectation assertions, and the Lp inequality can equivalently be raised to the positive p-th power.

## Findings

- **note / explicit analytic side conditions:** These clauses make the source conventions and finiteness of expectations explicit; they do not reduce the intended applicability of any sub-gaussian property.
- **note / equivalent moment formulation:** For nonnegative expectations, p>=1, and K>0, raising to or taking the positive p-th root gives an equivalent inequality.

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

- Blind translator covered `88` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `88` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/agent_outputs/agent_runs.json` (`cb1927ac4f29ce6e6484a61355cabfd095492b38baa8d015f3b742b5e776e781`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/agent_outputs/blind_translation.json` (`98fc8e0c47c38ee9264d8254f4d0293d420bd44a908f6e2044b6fa28a3689b84`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/agent_outputs/direct_judge.json` (`98f38d7236329e8f7a4ea65f1363a5dcad0431686c3f0102fbcf0be84be9971c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/agent_outputs/roundtrip_judge.json` (`fd67b73ca4a6d411a775f6a17b9fdd8608c0684c5caf001bff123add2d19a9e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/agent_outputs/source_contract.json` (`145f5f6b8a7e887df7a606594f6223d17111583cccb9db9eb1a00d9539ce01c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/decision.json` (`dcb7bf5a49a8feb84f7c5992cc1b679989610e944699d6eb0cf8d7022a2f2d95`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/agent_outputs/agent_runs.json` (`f81dd0c4da07ba734d2833a69949359ecd62a0fb15cfd56e45005cfb809d407e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/agent_outputs/blind_translation.json` (`c87d7906cb14a72a32409c1f21fc8efaba97d2aaac6af112560227461559a007`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/agent_outputs/direct_judge.json` (`146fae3fa4664218e1ddade6a1c2b6a52d8e2b306200f3edd5f10deb26bbe04b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/agent_outputs/roundtrip_judge.json` (`abcde8eb40475ffef15eb0ce1b049c699d8a9a6fe354f939dfcfe9b6ff40d0c0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/agent_outputs/source_contract.json` (`a4e22e56a7ee7dd1c92b5e3737c325eef6aba4dcad84e2ed18f73ca2405183d1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/decision.json` (`1fd16f95791268a66d12ddbbcb8d9e06211cd173df619daca0bf938f937cc700`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/inputs/blind_dependency_inventory.json` (`5eef277e559a35e2c620cfbdb1bcfe57de0471a46eac9d334859aae33fd84d95`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/inputs/blind_dossier.md` (`00db76560bc28285e8c35b7f70011ed7a9ed32e90719fbcd7d193dd6bf61183b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/inputs/blind_review_packet.md` (`00db76560bc28285e8c35b7f70011ed7a9ed32e90719fbcd7d193dd6bf61183b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/inputs/declaration_dossier.md` (`f1cb695325499d0f431137bf3ca19a062b9ce2e443cc600136d7165385efeb77`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/inputs/dependency_inventory.json` (`0adc74bf9298fae5e1d2faa5f501827a763d47a7c59289bc4f760c37ce18a2be`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/inputs/direct_review_packet.md` (`ca4d35f7801a25fe1a2d7a104f256c486fab6d7ac14d73526ba2e476ff9bcd40`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T124604Z/inputs/source_locator.json` (`0611587a636fad5db51a1225401a19f67a86d9ac2009ada37899e8062d3fc051`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/agent_outputs/agent_runs.json` (`4cc6c9dd2777945f1761ee28d2447e142d79828a4061e2ea44a748352b8c77b1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/agent_outputs/blind_translation.json` (`98fc8e0c47c38ee9264d8254f4d0293d420bd44a908f6e2044b6fa28a3689b84`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/agent_outputs/direct_judge.json` (`98f38d7236329e8f7a4ea65f1363a5dcad0431686c3f0102fbcf0be84be9971c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/agent_outputs/roundtrip_judge.json` (`fd67b73ca4a6d411a775f6a17b9fdd8608c0684c5caf001bff123add2d19a9e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/agent_outputs/source_contract.json` (`145f5f6b8a7e887df7a606594f6223d17111583cccb9db9eb1a00d9539ce01c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/decision.json` (`2a16ebb829ead27b54334079631103cd055fa3b6755434789b8dfa3daaa9db02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/inputs/blind_dependency_inventory.json` (`1a702779f4ae0b1f2293661f85ee4121c791062e8bf0de09dbabc2ad78732059`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/inputs/blind_dossier.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/inputs/blind_review_packet.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/inputs/declaration_dossier.md` (`f166e4ad5fb5bc72f48423e1b19bfd55781d11e9c54ee9a45d46268d1cf88d58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/inputs/dependency_inventory.json` (`d1095925267e665bea20963b1c995b45c539b1bb4cae7047126466e2d24a2b76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/inputs/direct_review_packet.md` (`0c16f76124368e985f889b7981965d353df7c9beebdf5705befc58d9653edf49`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T132113Z/inputs/source_locator.json` (`0611587a636fad5db51a1225401a19f67a86d9ac2009ada37899e8062d3fc051`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/agent_outputs/agent_runs.json` (`4cc6c9dd2777945f1761ee28d2447e142d79828a4061e2ea44a748352b8c77b1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/agent_outputs/blind_translation.json` (`98fc8e0c47c38ee9264d8254f4d0293d420bd44a908f6e2044b6fa28a3689b84`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/agent_outputs/direct_judge.json` (`98f38d7236329e8f7a4ea65f1363a5dcad0431686c3f0102fbcf0be84be9971c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/agent_outputs/roundtrip_judge.json` (`fd67b73ca4a6d411a775f6a17b9fdd8608c0684c5caf001bff123add2d19a9e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/agent_outputs/source_contract.json` (`145f5f6b8a7e887df7a606594f6223d17111583cccb9db9eb1a00d9539ce01c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/decision.json` (`c0a567a28f65cc15acb662e8955a2e3cf9333075e08f58d9521dbdcce1686509`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/inputs/blind_dependency_inventory.json` (`1a702779f4ae0b1f2293661f85ee4121c791062e8bf0de09dbabc2ad78732059`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/inputs/blind_dossier.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/inputs/blind_review_packet.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/inputs/declaration_dossier.md` (`f166e4ad5fb5bc72f48423e1b19bfd55781d11e9c54ee9a45d46268d1cf88d58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/inputs/dependency_inventory.json` (`d1095925267e665bea20963b1c995b45c539b1bb4cae7047126466e2d24a2b76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/inputs/direct_review_packet.md` (`0c16f76124368e985f889b7981965d353df7c9beebdf5705befc58d9653edf49`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T145455Z/inputs/source_locator.json` (`0611587a636fad5db51a1225401a19f67a86d9ac2009ada37899e8062d3fc051`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/agent_outputs/agent_runs.json` (`4cc6c9dd2777945f1761ee28d2447e142d79828a4061e2ea44a748352b8c77b1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/agent_outputs/blind_translation.json` (`98fc8e0c47c38ee9264d8254f4d0293d420bd44a908f6e2044b6fa28a3689b84`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/agent_outputs/direct_judge.json` (`98f38d7236329e8f7a4ea65f1363a5dcad0431686c3f0102fbcf0be84be9971c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/agent_outputs/roundtrip_judge.json` (`fd67b73ca4a6d411a775f6a17b9fdd8608c0684c5caf001bff123add2d19a9e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/agent_outputs/source_contract.json` (`145f5f6b8a7e887df7a606594f6223d17111583cccb9db9eb1a00d9539ce01c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/decision.json` (`08175ff5a4e5cbbb9f25d70eb280852495d1d961968c9bad88e97e7da7dab1dc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/inputs/blind_dependency_inventory.json` (`1a702779f4ae0b1f2293661f85ee4121c791062e8bf0de09dbabc2ad78732059`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/inputs/blind_dossier.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/inputs/blind_review_packet.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/inputs/declaration_dossier.md` (`f166e4ad5fb5bc72f48423e1b19bfd55781d11e9c54ee9a45d46268d1cf88d58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/inputs/dependency_inventory.json` (`d1095925267e665bea20963b1c995b45c539b1bb4cae7047126466e2d24a2b76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/inputs/direct_review_packet.md` (`0c16f76124368e985f889b7981965d353df7c9beebdf5705befc58d9653edf49`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260830T153339Z/inputs/source_locator.json` (`0611587a636fad5db51a1225401a19f67a86d9ac2009ada37899e8062d3fc051`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/agent_outputs/agent_runs.json` (`4cc6c9dd2777945f1761ee28d2447e142d79828a4061e2ea44a748352b8c77b1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/agent_outputs/blind_translation.json` (`98fc8e0c47c38ee9264d8254f4d0293d420bd44a908f6e2044b6fa28a3689b84`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/agent_outputs/direct_judge.json` (`98f38d7236329e8f7a4ea65f1363a5dcad0431686c3f0102fbcf0be84be9971c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/agent_outputs/roundtrip_judge.json` (`fd67b73ca4a6d411a775f6a17b9fdd8608c0684c5caf001bff123add2d19a9e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/agent_outputs/source_contract.json` (`145f5f6b8a7e887df7a606594f6223d17111583cccb9db9eb1a00d9539ce01c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/decision.json` (`990271d1b6e00ce4c0b1ed9df9aaa4efbf731d3cea92f38489c5e35bf9f9dca5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/inputs/blind_dependency_inventory.json` (`1a702779f4ae0b1f2293661f85ee4121c791062e8bf0de09dbabc2ad78732059`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/inputs/blind_dossier.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/inputs/blind_review_packet.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/inputs/declaration_dossier.md` (`f166e4ad5fb5bc72f48423e1b19bfd55781d11e9c54ee9a45d46268d1cf88d58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/inputs/dependency_inventory.json` (`d1095925267e665bea20963b1c995b45c539b1bb4cae7047126466e2d24a2b76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/inputs/direct_review_packet.md` (`0c16f76124368e985f889b7981965d353df7c9beebdf5705befc58d9653edf49`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T085230Z/inputs/source_locator.json` (`0611587a636fad5db51a1225401a19f67a86d9ac2009ada37899e8062d3fc051`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/agent_outputs/agent_runs.json` (`cb1927ac4f29ce6e6484a61355cabfd095492b38baa8d015f3b742b5e776e781`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/agent_outputs/blind_translation.json` (`98fc8e0c47c38ee9264d8254f4d0293d420bd44a908f6e2044b6fa28a3689b84`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/agent_outputs/direct_judge.json` (`98f38d7236329e8f7a4ea65f1363a5dcad0431686c3f0102fbcf0be84be9971c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/agent_outputs/roundtrip_judge.json` (`fd67b73ca4a6d411a775f6a17b9fdd8608c0684c5caf001bff123add2d19a9e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/agent_outputs/source_contract.json` (`145f5f6b8a7e887df7a606594f6223d17111583cccb9db9eb1a00d9539ce01c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/decision.json` (`d409bd2e7444202225a674ccc01b1a80884ac008985eddd91d0fc88aefbbeb81`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/inputs/blind_dependency_inventory.json` (`1a702779f4ae0b1f2293661f85ee4121c791062e8bf0de09dbabc2ad78732059`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/inputs/blind_dossier.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/inputs/blind_review_packet.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/inputs/declaration_dossier.md` (`f166e4ad5fb5bc72f48423e1b19bfd55781d11e9c54ee9a45d46268d1cf88d58`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/inputs/dependency_inventory.json` (`d1095925267e665bea20963b1c995b45c539b1bb4cae7047126466e2d24a2b76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/inputs/direct_review_packet.md` (`0c16f76124368e985f889b7981965d353df7c9beebdf5705befc58d9653edf49`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T101751Z/inputs/source_locator.json` (`0611587a636fad5db51a1225401a19f67a86d9ac2009ada37899e8062d3fc051`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/agent_outputs/agent_runs.json` (`cb1927ac4f29ce6e6484a61355cabfd095492b38baa8d015f3b742b5e776e781`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/agent_outputs/blind_translation.json` (`98fc8e0c47c38ee9264d8254f4d0293d420bd44a908f6e2044b6fa28a3689b84`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/agent_outputs/direct_judge.json` (`98f38d7236329e8f7a4ea65f1363a5dcad0431686c3f0102fbcf0be84be9971c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/agent_outputs/roundtrip_judge.json` (`fd67b73ca4a6d411a775f6a17b9fdd8608c0684c5caf001bff123add2d19a9e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/agent_outputs/source_contract.json` (`145f5f6b8a7e887df7a606594f6223d17111583cccb9db9eb1a00d9539ce01c4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/decision.json` (`633f661e84f2f50dbdcad6cd8c6314ef1d487483350e64db95e3b4c880a9c3d4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/inputs/blind_dependency_inventory.json` (`1a702779f4ae0b1f2293661f85ee4121c791062e8bf0de09dbabc2ad78732059`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/inputs/blind_dossier.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/inputs/blind_review_packet.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/inputs/declaration_dossier.md` (`630f60f36a7232b91c9f7228d5b68c28d68894ea2e789b6c7bab81dcde1e24e8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/inputs/dependency_inventory.json` (`d1095925267e665bea20963b1c995b45c539b1bb4cae7047126466e2d24a2b76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/inputs/direct_review_packet.md` (`0c16f76124368e985f889b7981965d353df7c9beebdf5705befc58d9653edf49`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/history/20260831T203241Z/inputs/source_locator.json` (`0611587a636fad5db51a1225401a19f67a86d9ac2009ada37899e8062d3fc051`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/inputs/blind_dependency_inventory.json` (`1a702779f4ae0b1f2293661f85ee4121c791062e8bf0de09dbabc2ad78732059`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/inputs/blind_dossier.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/inputs/blind_review_packet.md` (`aa6b5ecd5224522825272544fa2612abe7ae2102631960ed54b89781f8d67088`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/inputs/declaration_dossier.md` (`630f60f36a7232b91c9f7228d5b68c28d68894ea2e789b6c7bab81dcde1e24e8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/inputs/dependency_inventory.json` (`d1095925267e665bea20963b1c995b45c539b1bb4cae7047126466e2d24a2b76`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/inputs/direct_review_packet.md` (`0c16f76124368e985f889b7981965d353df7c9beebdf5705befc58d9653edf49`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.5.2/faithfulness/inputs/source_locator.json` (`0611587a636fad5db51a1225401a19f67a86d9ac2009ada37899e8062d3fc051`)
