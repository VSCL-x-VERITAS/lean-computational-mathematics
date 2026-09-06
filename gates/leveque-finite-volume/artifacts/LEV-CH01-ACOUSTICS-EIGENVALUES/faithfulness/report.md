# Faithfulness audit: LEV-CH01-ACOUSTICS-EIGENVALUES

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `def8202ebb334a085ca8e16566bf08e6c8fef2f2d05badab9dc79aedc11fe707`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The Lean proposition is a fully explicit, nonvacuous formulation of the source spectrum statement: it witnesses each signed eigenvalue with the correct nonzero eigenvector and makes the stated wave-speed interpretation precise through traveling-wave solutions. The extra explicit witnesses and profile clauses are consequences of the same fixed matrix and characteristic-speed semantics, so both implication directions hold.

## Implications

- **Lean implies source:** `yes`. The nonzero eigenvectors and equations A v_left=(-c)v_left and A v_right=c v_right establish -c and +c as eigenvalues. Positivity makes them distinct, and the eigenmode traveling-wave clauses realize the source interpretation of these eigenvalues as propagation speeds.
- **Source implies lean:** `yes`. For the fixed 2 by 2 matrix A=[[0,K],[1/rho,0]] with K,rho>0 and c=sqrt(K/rho), the source eigenvalue statement and its propagation-speed interpretation entail the displayed canonical eigenvectors; direct multiplication and the standard chain rule give the universally quantified differentiable eigenmode profiles. These are explicit consequences, not an independent restriction or unrelated claim.

## Findings

- **note / explicit-eigenmode-witnesses:** This is a consequence-level elaboration of the same fixed matrix and speed claim, not a change of applicability or conclusion.
- **note / derived-detail:** These are consequences of the same matrix and sound-speed relation, so logical strength is unchanged.

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
| `N01` | `pass` | `pass` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `110` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `110` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/agent_outputs/agent_runs.json` (`1acf6558e887a9a779cf2652b48ea27f2be09ab8371f632e85c0521e550d08e4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/agent_outputs/batch_source_contract.json` (`d0fd4bc8d51f4e43a915edd501472b75abc7eb59c4c22ba8049da4ed8c452133`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/agent_outputs/blind_translation.json` (`bd9214fe912ab7c952ad382aaafbea4be5d98bec516cd36ecdf2bd768b9e7fd0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/agent_outputs/direct_judge.json` (`dd2656aad597a921730cf4f1f4f981b02f03de2768d02fe20b14b0f329f1ff28`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/agent_outputs/roundtrip_judge.json` (`f3b089eb9675689b3efbac33c3abec8f01bf9aee9a7a2036c568d54d247b629a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/agent_outputs/source_contract.json` (`2824a36de8fdde7974767e410967eaf342ebd1edf9b9b6b8449d44d9f8763190`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/decision.json` (`84f7b46be3ce69077482f61df63c54ae12445d7ed152ab01f666b0810800c301`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/agent_outputs/agent_runs.json` (`c629cef8c2dd4992011bb23ac86c22c7df04e2d66df14a99a18e496ea18e4bde`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/agent_outputs/batch_source_contract.json` (`d8fdc23104f3a4ce44add59aa66515c36255136ffeac295b5f757fb7be5f1438`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/agent_outputs/blind_translation.json` (`ab1efd77cd574b4e78665ab051fc8df880a876adf93e5c8700bfc67d01bd5688`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/agent_outputs/direct_judge.json` (`3661abe6e13d59c2eb6cb0e5a72c49d6509b28de7ca015ad89ca2433baa4ced8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/agent_outputs/source_contract.json` (`8507584ca9e50c729bc97adc4728471dc7d7c8abff2a372d523391a34d382f78`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/inputs/blind_dependency_inventory.json` (`0bc07b6c3ef486cba4d918c64955b72073ae1dc26a764ab57bb8aa8bc7d8b962`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/inputs/blind_dossier.md` (`62cfe0a19d3d31c104f6302c803f558523e3c2ffcb8e7bfaaa3174d2f2d11564`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/inputs/blind_review_packet.md` (`62cfe0a19d3d31c104f6302c803f558523e3c2ffcb8e7bfaaa3174d2f2d11564`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/inputs/declaration_dossier.md` (`74715034f14807dc6a26b344f010711d63f81a56648ed7a972460c451c75c00a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/inputs/dependency_inventory.json` (`ba38abcbe00401625f0c9cc834afe6772da95e4ca30e93402fef38ed3dffad17`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/inputs/direct_review_packet.md` (`dab6a589d8471ed1b6858b1a2565c4d44b22092e881a40356dafec9145233a74`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/inputs/source_locator.json` (`9e4ed77ecd757b39d77689812cbe6ac0468651e3d664dcc5aabab320c68345bd`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/tmp/pdfs/leveque-ch1-context-023.png` (`aaf5cd3a4c029d675373a9b3ef7c6e4e4fdc6a1d858e04dc32900082ce222883`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/tmp/pdfs/leveque-ch1-context-024.png` (`f06cde84f0e1d3148f29764a8f1a4592889ef92c705b8505beafa42b5f0a9d56`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/tmp/pdfs/leveque-ch1-context-025.png` (`34970d4efa8fced752fd99222579b891e68fb6333fc7306967a5815080687263`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/history/20260901T052532Z/tmp/pdfs/leveque-ch1-context-026.png` (`cf499cbfc7d244bb799f401eb53e71e634dbf9f98bef4a4cf38c54f1f1f9a55b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/inputs/batch_source_locator.json` (`c4ec2035a85a5a30a2333db6a44ef5e187a130ebcd7f86c4c718de479f693893`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/inputs/blind_dependency_inventory.json` (`77c0b4616152d6ece1ae039d52d2c90aaf252d3947aba5d25dd1f8944c50a326`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/inputs/blind_dossier.md` (`b0eb3a7cfc9bbe7eb4201c6e47c3d92f18257d9889a0f02c362711e34945401d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/inputs/blind_review_packet.md` (`b0eb3a7cfc9bbe7eb4201c6e47c3d92f18257d9889a0f02c362711e34945401d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/inputs/declaration_dossier.md` (`003e883bc0ba85e0bd69238ac15338447d03305c9cda0c0d8649e49edc80e86a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/inputs/dependency_inventory.json` (`282d5fc4f130c57be1b895ba6bd7df8c79afd1a9d3b44a45e135c3993e2afd88`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/inputs/direct_review_packet.md` (`2aa7f21bd5d86b007c5e6abda06450dbd3cf3477b07900c5d21cc017907556d9`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ACOUSTICS-EIGENVALUES/faithfulness/inputs/source_locator.json` (`9e4ed77ecd757b39d77689812cbe6ac0468651e3d664dcc5aabab320c68345bd`)
