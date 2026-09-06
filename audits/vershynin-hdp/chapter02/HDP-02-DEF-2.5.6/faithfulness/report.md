# Faithfulness audit: HDP-02-DEF-2.5.6

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `a349af15a85f93cd9b9e459f90e8ce97e63ef5fa9caf31c4baed85a8839e8d08`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The repaired declaration faithfully captures Definition 2.5.6. Its measurable binder and probability-measure instance give the intended real random-variable setting. IsSubGaussian is explicitly a measurable positive-witness instance of property (iv), and the finite enumeration plus i!=linearMGF yields exactly the four uncentered properties (i)-(iv), with each branch preserving its own existential scale and internal quantifiers. PsiTwoNorm names the admissible-scale infimum; conditioning the equality and finiteness on IsSubGaussian keeps the ENNReal totalization within the source's sub-gaussian domain. Both implication directions hold, all 109 dependencies and 12 core checks are resolved, and no adjudication is needed.

## Implications

- **Lean implies source:** `yes`. For a measurable real random variable on a probability space, D001 defines the named class by a positive property-(iv) witness, while the universally tagged Iff covers exactly tail, moment, square-window, and square-point and excludes only centered property (v). The conditional second conjunct gives the finite value of the named psi_2 quantity as the infimum over precisely the positive scales satisfying E exp(X^2/t^2)<=2. Thus the Lean proposition supplies both clauses of Definition 2.5.6 in its inherited Proposition 2.5.2 context.
- **Source implies lean:** `yes`. The source definition, together with the Proposition 2.5.2 equivalence it explicitly invokes, makes satisfaction of any one of (i)-(iv) equivalent to the named sub-gaussian class with independent positive witnesses. A property-(iv) witness makes the admissible set nonempty at a finite positive scale, so the infimum is finite; equation (2.13) is exactly the same infimum after identifying positive reals with finite nonzero ENNReal scales. Explicit measurability and integrability merely spell out what random-variable and finite-expectation notation already require.

## Findings

- **note / finite-extended-real-representation:** This is a faithful totalized representation of the source norm's finite nonnegative value, not an enlargement to non-sub-gaussian variables.
- **note / explicit-finite-expectations:** The extra-looking conjuncts prevent nonintegrable real integrals from becoming vacuous and preserve, rather than strengthen, the intended finite-expectation semantics.
- **note / explicit-formal-semantics:** These are faithful formal encodings of the source conventions and do not change either implication.
- **note / source-naming:** Only labels are absent; the mathematical class and functional are reconstructed without semantic loss.

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

- Blind translator covered `109` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `109` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/agent_outputs/agent_runs.json` (`2b8dc057d92280b87195e180b63209024b33f89f45054c86c7c5822e764dfe59`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/agent_outputs/blind_translation.json` (`e26e9e269f88f35ca56e1a78e327026594ed1d4bb87fde5f6a8216e7ee1e7002`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/agent_outputs/direct_judge.json` (`5fed39cfb53fa313b396e89bbc45a1d67d1a2a023b6de320033adff08cfeadc4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/agent_outputs/roundtrip_judge.json` (`a4432695e24c224149de425b1a1a1807a2606f921ea97b753f3cc1201b463877`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/agent_outputs/source_contract.json` (`33ea3e7773efe77212b75aa1c1379c630ced987f95f3e249d8c9eeb0660efedf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/decision.json` (`933ef1cec87ffacf79aa3f43c1ccca8e2c72fe9edb9fa01f669b00223c0becb7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T140932Z/inputs/blind_dependency_inventory.json` (`af6904a6b9aa080f6d93cca46bbe0f1d665dd2981c514010ae2d40c60c2e8732`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T140932Z/inputs/blind_dossier.md` (`08b64dfae3e3107b83650d4763fcc7ab4f21e287c485d9bf0092df9ac0d5f17e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T140932Z/inputs/blind_review_packet.md` (`08b64dfae3e3107b83650d4763fcc7ab4f21e287c485d9bf0092df9ac0d5f17e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T140932Z/inputs/declaration_dossier.md` (`92663083592c7fed76475ac31428eda08130ff928cd11a561971cd8fec276d74`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T140932Z/inputs/dependency_inventory.json` (`145aa9faf8a954ce73eff8d5b20d92f5834a73931ddf5e3dc5d32bb0a59c3fd6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T140932Z/inputs/direct_review_packet.md` (`0eb6a03ed2a1e467a63878de37b567e3a6cd9ed204c3baab5841523d1fae5566`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T140932Z/inputs/source_locator.json` (`51dd9f00fa63046119060e13d66ef0fa01d1b9f18be7b2f15314c0e499dc0408`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/agent_outputs/adjudicator.json` (`e2e23cd6711dc89b387fa723b8a04d596a45c960a0c05b9bb5378774f7ef72a5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/agent_outputs/agent_runs.json` (`db8975590872eed7b31ae044247cfe5c3896f090a6004d97ee95613a7de47995`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/agent_outputs/blind_translation.json` (`3de4a310ab6042a62776506e09792426590aeba10f2bcb67642c33ed9c117461`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/agent_outputs/direct_judge.json` (`8a628b56ba3e614a1e7a7d53a01bacfe11ab28676b6a465316079943a869aa4e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/agent_outputs/roundtrip_judge.json` (`01cd4a0709dc3bf77b34d4b8c072bb3a9bf1da811687c1ccad42e6766d52e011`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/agent_outputs/source_contract.json` (`037c1ee6972c5a6c38222dbdbab8788fe2901348d8c425287ea9b46d9459b086`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/decision.json` (`2a98803fb2176b172721f31bb3436c2e934fcf4899f54e1edd1e173bb2910ba5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/inputs/blind_dependency_inventory.json` (`af6904a6b9aa080f6d93cca46bbe0f1d665dd2981c514010ae2d40c60c2e8732`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/inputs/blind_dossier.md` (`08b64dfae3e3107b83650d4763fcc7ab4f21e287c485d9bf0092df9ac0d5f17e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/inputs/blind_review_packet.md` (`08b64dfae3e3107b83650d4763fcc7ab4f21e287c485d9bf0092df9ac0d5f17e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/inputs/declaration_dossier.md` (`92663083592c7fed76475ac31428eda08130ff928cd11a561971cd8fec276d74`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/inputs/dependency_inventory.json` (`145aa9faf8a954ce73eff8d5b20d92f5834a73931ddf5e3dc5d32bb0a59c3fd6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/inputs/direct_review_packet.md` (`0eb6a03ed2a1e467a63878de37b567e3a6cd9ed204c3baab5841523d1fae5566`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T143323Z/inputs/source_locator.json` (`51dd9f00fa63046119060e13d66ef0fa01d1b9f18be7b2f15314c0e499dc0408`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/agent_outputs/agent_runs.json` (`37e74656df16c1d125e4a47a3b9d7e56903c32f4c5c20672a41f7066e79018e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/agent_outputs/blind_translation.json` (`e26e9e269f88f35ca56e1a78e327026594ed1d4bb87fde5f6a8216e7ee1e7002`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/agent_outputs/direct_judge.json` (`5fed39cfb53fa313b396e89bbc45a1d67d1a2a023b6de320033adff08cfeadc4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/agent_outputs/roundtrip_judge.json` (`a4432695e24c224149de425b1a1a1807a2606f921ea97b753f3cc1201b463877`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/agent_outputs/source_contract.json` (`33ea3e7773efe77212b75aa1c1379c630ced987f95f3e249d8c9eeb0660efedf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/decision.json` (`eb36dcaf402df8ed2e402d0ac8efacb0f14fbac2ecb2cc9a3462f5e258c54ca1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/inputs/blind_dependency_inventory.json` (`63bd670164830742f9dd8d3c8df50aa4fa0a369ef3a6f650aa2eaac771d319ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/inputs/blind_dossier.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/inputs/blind_review_packet.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/inputs/declaration_dossier.md` (`7c052ede52645cc49fd1d8d126cf274dea83fa50e97b208191355c990e5a6359`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/inputs/dependency_inventory.json` (`9a6b8aecc616d5984191bad2ae8d0da65983b59f1ca98c1ad0cf27c9438043fc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/inputs/direct_review_packet.md` (`af2c2771f495594871079b0702952b54b0b6b4a16f52e9bcbf9a0f7e601c166d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T145345Z/inputs/source_locator.json` (`51dd9f00fa63046119060e13d66ef0fa01d1b9f18be7b2f15314c0e499dc0408`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/agent_outputs/agent_runs.json` (`37e74656df16c1d125e4a47a3b9d7e56903c32f4c5c20672a41f7066e79018e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/agent_outputs/blind_translation.json` (`e26e9e269f88f35ca56e1a78e327026594ed1d4bb87fde5f6a8216e7ee1e7002`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/agent_outputs/direct_judge.json` (`5fed39cfb53fa313b396e89bbc45a1d67d1a2a023b6de320033adff08cfeadc4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/agent_outputs/roundtrip_judge.json` (`a4432695e24c224149de425b1a1a1807a2606f921ea97b753f3cc1201b463877`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/agent_outputs/source_contract.json` (`33ea3e7773efe77212b75aa1c1379c630ced987f95f3e249d8c9eeb0660efedf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/decision.json` (`02e88b6c9d03f1975112169f4e2c87842142f183fd07939499daed54c0a22068`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/inputs/blind_dependency_inventory.json` (`63bd670164830742f9dd8d3c8df50aa4fa0a369ef3a6f650aa2eaac771d319ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/inputs/blind_dossier.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/inputs/blind_review_packet.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/inputs/declaration_dossier.md` (`7c052ede52645cc49fd1d8d126cf274dea83fa50e97b208191355c990e5a6359`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/inputs/dependency_inventory.json` (`9a6b8aecc616d5984191bad2ae8d0da65983b59f1ca98c1ad0cf27c9438043fc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/inputs/direct_review_packet.md` (`af2c2771f495594871079b0702952b54b0b6b4a16f52e9bcbf9a0f7e601c166d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260830T152933Z/inputs/source_locator.json` (`51dd9f00fa63046119060e13d66ef0fa01d1b9f18be7b2f15314c0e499dc0408`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/agent_outputs/agent_runs.json` (`37e74656df16c1d125e4a47a3b9d7e56903c32f4c5c20672a41f7066e79018e5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/agent_outputs/blind_translation.json` (`e26e9e269f88f35ca56e1a78e327026594ed1d4bb87fde5f6a8216e7ee1e7002`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/agent_outputs/direct_judge.json` (`5fed39cfb53fa313b396e89bbc45a1d67d1a2a023b6de320033adff08cfeadc4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/agent_outputs/roundtrip_judge.json` (`a4432695e24c224149de425b1a1a1807a2606f921ea97b753f3cc1201b463877`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/agent_outputs/source_contract.json` (`33ea3e7773efe77212b75aa1c1379c630ced987f95f3e249d8c9eeb0660efedf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/decision.json` (`627932eebb057ac3ef24b2f89311b456a63d38b4821bd1b33abadcb1f95e6b73`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/inputs/blind_dependency_inventory.json` (`63bd670164830742f9dd8d3c8df50aa4fa0a369ef3a6f650aa2eaac771d319ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/inputs/blind_dossier.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/inputs/blind_review_packet.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/inputs/declaration_dossier.md` (`7c052ede52645cc49fd1d8d126cf274dea83fa50e97b208191355c990e5a6359`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/inputs/dependency_inventory.json` (`9a6b8aecc616d5984191bad2ae8d0da65983b59f1ca98c1ad0cf27c9438043fc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/inputs/direct_review_packet.md` (`af2c2771f495594871079b0702952b54b0b6b4a16f52e9bcbf9a0f7e601c166d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T083249Z/inputs/source_locator.json` (`51dd9f00fa63046119060e13d66ef0fa01d1b9f18be7b2f15314c0e499dc0408`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/agent_outputs/agent_runs.json` (`2b8dc057d92280b87195e180b63209024b33f89f45054c86c7c5822e764dfe59`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/agent_outputs/blind_translation.json` (`e26e9e269f88f35ca56e1a78e327026594ed1d4bb87fde5f6a8216e7ee1e7002`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/agent_outputs/direct_judge.json` (`5fed39cfb53fa313b396e89bbc45a1d67d1a2a023b6de320033adff08cfeadc4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/agent_outputs/roundtrip_judge.json` (`a4432695e24c224149de425b1a1a1807a2606f921ea97b753f3cc1201b463877`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/agent_outputs/source_contract.json` (`33ea3e7773efe77212b75aa1c1379c630ced987f95f3e249d8c9eeb0660efedf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/decision.json` (`e8cf485a650d5f5c0646d67d9387710f97275c893af5473f70d1b07d2c0855ad`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/inputs/blind_dependency_inventory.json` (`63bd670164830742f9dd8d3c8df50aa4fa0a369ef3a6f650aa2eaac771d319ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/inputs/blind_dossier.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/inputs/blind_review_packet.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/inputs/declaration_dossier.md` (`7c052ede52645cc49fd1d8d126cf274dea83fa50e97b208191355c990e5a6359`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/inputs/dependency_inventory.json` (`9a6b8aecc616d5984191bad2ae8d0da65983b59f1ca98c1ad0cf27c9438043fc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/inputs/direct_review_packet.md` (`af2c2771f495594871079b0702952b54b0b6b4a16f52e9bcbf9a0f7e601c166d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T100937Z/inputs/source_locator.json` (`51dd9f00fa63046119060e13d66ef0fa01d1b9f18be7b2f15314c0e499dc0408`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/agent_outputs/agent_runs.json` (`2b8dc057d92280b87195e180b63209024b33f89f45054c86c7c5822e764dfe59`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/agent_outputs/blind_translation.json` (`e26e9e269f88f35ca56e1a78e327026594ed1d4bb87fde5f6a8216e7ee1e7002`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/agent_outputs/direct_judge.json` (`5fed39cfb53fa313b396e89bbc45a1d67d1a2a023b6de320033adff08cfeadc4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/agent_outputs/roundtrip_judge.json` (`a4432695e24c224149de425b1a1a1807a2606f921ea97b753f3cc1201b463877`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/agent_outputs/source_contract.json` (`33ea3e7773efe77212b75aa1c1379c630ced987f95f3e249d8c9eeb0660efedf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/decision.json` (`bd769f5511834174122e069cadf2ffa76af97e3f59af595a0430f6143ad065b4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/inputs/blind_dependency_inventory.json` (`63bd670164830742f9dd8d3c8df50aa4fa0a369ef3a6f650aa2eaac771d319ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/inputs/blind_dossier.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/inputs/blind_review_packet.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/inputs/declaration_dossier.md` (`3089a7d9f2d40344c98313f13a78d607896718eb17085d2a784c6ea3b5cd6f67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/inputs/dependency_inventory.json` (`9a6b8aecc616d5984191bad2ae8d0da65983b59f1ca98c1ad0cf27c9438043fc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/inputs/direct_review_packet.md` (`af2c2771f495594871079b0702952b54b0b6b4a16f52e9bcbf9a0f7e601c166d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/history/20260831T203325Z/inputs/source_locator.json` (`51dd9f00fa63046119060e13d66ef0fa01d1b9f18be7b2f15314c0e499dc0408`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/inputs/blind_dependency_inventory.json` (`63bd670164830742f9dd8d3c8df50aa4fa0a369ef3a6f650aa2eaac771d319ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/inputs/blind_dossier.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/inputs/blind_review_packet.md` (`2d009fd5db7b0c79ad500081d4a3b9bebe32aca88c7909db511003c3250217cb`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/inputs/declaration_dossier.md` (`3089a7d9f2d40344c98313f13a78d607896718eb17085d2a784c6ea3b5cd6f67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/inputs/dependency_inventory.json` (`9a6b8aecc616d5984191bad2ae8d0da65983b59f1ca98c1ad0cf27c9438043fc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/inputs/direct_review_packet.md` (`af2c2771f495594871079b0702952b54b0b6b4a16f52e9bcbf9a0f7e601c166d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-DEF-2.5.6/faithfulness/inputs/source_locator.json` (`51dd9f00fa63046119060e13d66ef0fa01d1b9f18be7b2f15314c0e499dc0408`)
