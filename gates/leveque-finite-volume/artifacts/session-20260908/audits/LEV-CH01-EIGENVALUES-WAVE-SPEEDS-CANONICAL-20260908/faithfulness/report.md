# Faithfulness audit: LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908

## Decision

- Classification: `not-faithful-different`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `6e6ab09b94e85a8be03dd1a47e2e63f638effa0edd7c9c950298206bbde6b60f`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source images and inline declaration evidence support the decision without majority voting or reliance on declaration names. The PDE, signed translation, real arithmetic, derivative witnesses, and finite-dimensional topology are correctly represented. The decisive difference is that translation is prescribed in a constructed single mode instead of derived for components of an arbitrary hyperbolic-system solution. N06's definite completeness failure is distinguished from the remaining regularity uncertainty. The theorem has nontrivial instances, but its broader matrix applicability does not restore the missing source conclusion. Source-byte and rendering hashes are supplied provenance and were not independently recomputed.

## Implications

- **Lean implies source:** `no`. As a statement-faithfulness comparison, verifying the PDE for prescribed fields f(x-λt)r does not establish that the eigenbasis coefficients of an arbitrary solution propagate at their corresponding eigenvalues. Even after supplying the source's complete eigenbasis, the target provides no extraction of those coefficients or evolution characterization. Additional mathematical results are needed; this is not a definitional reformulation. The omission persists entirely within smooth classical solutions.
- **Source implies lean:** `no`. The selected source claim has a complete real eigenbasis as inherited context and describes component propagation. The target universally asserts a sufficient construction under only one vector relation, including nonzero modes of defective matrices outside that context. These additional construction cases follow from calculus and matrix linearity, but are not specializations or definitional consequences of the selected source assertion. This scope comparison does not claim that the valid construction lemma is mathematically false.

## Findings

- **major / constructed-mode-versus-general-component-propagation:** The target represents a supporting construction lemma rather than the selected general component-propagation assertion.
- **major / missing-completeness-and-changed-domain:** The omitted component structure and extended matrix domain prevent classification as either equivalent or faithfully stronger.
- **minor / zero-vector-spectral-interpretation:** The parameter speed is not certified as an eigenvalue in every target instance, although substantive nonzero instances remain.
- **note / unspecified-source-regularity:** Full analytic-scope equivalence remains unestablished; the definite structural mismatch already determines rejection.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `fail` | `fail` |
| `C03` | `fail` | `fail` |
| `C04` | `fail` | `fail` |
| `C05` | `fail` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `fail` | `fail` |
| `C08` | `fail` | `fail` |
| `C09` | `pass` | `pass` |
| `C10` | `fail` | `fail` |
| `C11` | `fail` | `fail` |
| `C12` | `pass` | `pass` |
| `N01` | `fail` | `fail` |
| `N02` | `pass` | `fail` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `fail` | `unclear` |

## Dependency coverage

- Blind translator covered `86` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `86` dependencies (`71` hash-reused); failing or unclear: `D001, D002`.

## Remaining uncertainties

- The selected source passage does not determine an exact solution regularity class or settle the extent of intended weak-solution coverage. The target explicitly uses classical pointwise derivatives. This analytic uncertainty does not change either structural scope comparison.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`c4483f40dc78f59dfe00f0f1aeae3a41c3812a6783988c6aae2d361cb7ad076b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`4025734a5874b293605ebc4da9006406e2f5da733ef7b26fd5b3c0b3ef06bb3d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`105da37651bf36b56e16f3288eb111e423fe0474212f69dd3c36c2201ce4e078`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`e9628ff22cecb829703432fd3fe9824cbc0af11fcc8413dd5de3b928168f4bae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`edd0f2e4e84b7a06b947770034ffc05339ef75f425eba440cd6af8cd98baebe7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`330d96372e65d353e9eac97ee87f59648928e0c0abf2e310f187052f5bc2df02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/decision.json` (`76b47f8b86892598730cf10051a9726470201d8a1993933e3a5cdf333c79d5dd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`b8d4aebdc909fdab01ec153aab8fd10c7477198272edea37605c63b3374abe82`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`dd82840a505303692423572d82c2f5cefd08245594d1491e44b4cc65d67293c8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`dd82840a505303692423572d82c2f5cefd08245594d1491e44b4cc65d67293c8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`d7fa9da01174f362f366b4fd5488802c5a0cebe34dc89aba0a06963675639938`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`86e48de3ed4d266845f5f4da8d0fa2de06415b1b02c3b99d166d9aa640ced9e5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`9cc6cb2e65159a35dd9584f68af7a5ed1a4f6342e1fc79de52c0fd15a4085f19`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`486527ad3639dbe8fed7cbebb4d04edd0b91852f9cf1c433702f6087c63689d4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`80521aee050f692b2751952d686241863313387510e21c966450862b3e012a21`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`4c89bc36be1d8e07fb96b7832a5e7f7b24bb86eb183bd78604ef52e32ef666b0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`c4483f40dc78f59dfe00f0f1aeae3a41c3812a6783988c6aae2d361cb7ad076b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`e6d7338963e51b5eebfdb08aefb5bed43b6f1bc2064a9550d7dbd3943abebdbc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`c6fb494bbe6a0ca9057ef01b6ee6abe99b940d0f8938658c453d8781dddd44a7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`95d5fdb85e8c73494a175da9723d57007e5b72588e8ff717beab175b8330035e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`87c85d33fe49c2e133cc7d7f18939980388acd452fb63bb5f8f217728c364875`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`e85e43986aea738b7fba43706f76d569361fdf5e4a51727db794a3fc48cdd5f9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`13825da1b1ec5959c4e3f1c48d412c8cfc54104324af01fc6372e96021e928a8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`105da37651bf36b56e16f3288eb111e423fe0474212f69dd3c36c2201ce4e078`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`23379937110fc8152c32d0be60a687d8a44436c906dfeefc70b9613f622edc25`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`bcbc35201e6332eeaef77376f57ab1cc9395361e7188979ddee36b7341a09b34`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`cd628fd8f311c4db9893bce04cf0383033d50e6224770ac15e7d6afc6a4257ef`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`3012b93c6f08aed39788f6bdd5c7b840eeab7e8da7dcc649e8cb01f96045b2d1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/coordinator_slot_drained_20260908.json` (`c436803e292795949673266419ebd8608813fcf72b9b4a5d2699393f443ac83d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/coordinator_slot_pause_20260908.json` (`883476159875d2eafc02ec135b22c172edf9a2ab12df1aff7eb87fd715ae39ac`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`682a216f2f8a73cd38df070df37d1069d462575869970066c9f7d132f30947cb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`e9628ff22cecb829703432fd3fe9824cbc0af11fcc8413dd5de3b928168f4bae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`9f4e63f8d4b17c089419653c47e86f0b96441c07ee9ff62c649f0c1e2db04af1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`3d9254710f9df2321a8260f91aa15f4ad14bcf98e3402529515e36aaee5cf4f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`0d536edc59340bb6cf9f32118c751326ec223a0bfbf37bd42ed128d7be7fb3a2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`187827e5b17a046cbeab2748b0a6a17250dd10af930d6fe39e9bb0468f2a33c3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`dcc761707270f58454ec8ee85550cd5a7ec1152080fd0670f4d88cbb91dda524`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`edd0f2e4e84b7a06b947770034ffc05339ef75f425eba440cd6af8cd98baebe7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`7b2f97171d6a94ec8ef4655d2b1e6905df5ee1ea465030fda9b3e575a1ac5ec2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`52a45dc004abd6855e769b6ddd32d918f171a8ad15727db06cef15e56ece31e3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`c8b6f40a90b43cc7e89919eb7fcd820de48f1a38063febfc7ce186296f480d90`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`e9a35e150c7c2028b107074695a9b506fe2900322b3d2dd212b55076c7de524b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`e96c064fcd1c54701badabc1c97288715b0cb312112cbb6e2eb932b64c05fd65`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`330d96372e65d353e9eac97ee87f59648928e0c0abf2e310f187052f5bc2df02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`b5f333b93104478ae3f398503eee2abd4afa7114968ba9058a3aaa666eb34807`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`1fdcd6a0380b700598c444e58ed2a1727ff60914fcc48d47168cefc49e59f8c9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`5cb6497bedf10ac05297a78e338f2bc7eee289888c1544902bc12a380cab039f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-WAVE-SPEEDS-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`6cdbe7f568784a1e30f1b3d6f4b65eb2ef838d3f8f5d52be81ea0560510e1d90`)
