# Faithfulness audit: HDP-02-LEM-2.6.8

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `b0fbc577022456dd5d55bf57d071559cb51d79e3efdf63e5c5a41b3daa69ab7f`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Direct inspection of the cited source pages and every D001-D087 declaration shows that the Lean target states the same centering lemma. It uses the source's real probability-space setting, chooses one absolute constant before all random-variable binders, assumes only sub-gaussianity, centers by the real expectation, preserves sub-gaussianity, and gives the same psi_2 inequality. The local definitions realize the exact infimum over finite positive scales satisfying E exp(Y^2/t^2) <= 2. The condition C >= 1 with ENNReal.ofReal is an equivalent normalization of an unspecified positive existential factor. Both implication directions therefore hold, all configured checks pass, and no unresolved issue requires adjudication.

## Implications

- **Lean implies source:** `yes`. Unfolding D001-D006, the Lean proposition gives one uniform real C >= 1 such that every real sub-gaussian random variable on every probability space remains sub-gaussian after subtraction of its Bochner expectation and satisfies the exact Equation (2.13) psi_2 bound. This directly supplies every clause of Lemma 2.6.8.
- **Source implies lean:** `yes`. The source's absolute constant is uniform over X and the implicit probability-space context. Its positive factor may be enlarged to max(C,1), after which ENNReal.ofReal is the exact nonnegative embedding. Definition 2.5.6/Equation (2.13) match D001-D006, so the source gives both Lean conjuncts for all quantified Ω, μ, and X.

## Findings

- **note / constant-normalization:** This is a harmless normalization, not a sharp-constant claim: any valid positive upper-bound factor can be enlarged to at least one, and the lower bound makes the coercion exact.
- **note / constant-witness-normalization:** This is logically harmless normalization, since a valid positive upper-bound constant can always be enlarged to max(C,1); it does not claim C = 1 or a sharp value.
- **note / extended-nonnegative-gauge-codomain:** On the sub-gaussian variables covered by the premise and centered conclusion, admissible finite scales exist and the ENNReal infimum represents the same nonnegative value, including the possible zero norm of the zero variable.

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

- Blind translator covered `87` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `87` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/agent_outputs/agent_runs.json` (`c8167129e1b836cef365a6e4572052a77bf608fdc6d84a2c5d3faa957a87c9db`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/agent_outputs/batch_source_contract.json` (`15524d331ce070bdc07ecfa36a361db146220c8cb28c61e673b0099f4c0e5c17`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/agent_outputs/blind_translation.json` (`7a4c07c442fa5ba44f54165de282ec41992d509d6d8fc8357a86fe5f90d1ae52`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/agent_outputs/direct_judge.json` (`d1a5c45a30bc6022ebe35e95029f18f5d78d059d8b277450af5d7c3b1c3e56e1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/agent_outputs/roundtrip_judge.json` (`48d9eb87a61fc555eab156750d95a66c4547c623428435fdfba573c20aff0d6a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/agent_outputs/source_contract.json` (`b64f6706e275a5c552b88fc6709f1a8ff6332cf23552efa022dd441ba5f10776`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/decision.json` (`687966b96163e20152a9d149fb0f20bcd01e4167983692071a1b63ffd705edef`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104702Z/inputs/batch_source_locator.json` (`3f474ebf22108e0212eb4a83d18a037ea4d530303d81a6c062ad8a49d5532b5a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104702Z/inputs/blind_dependency_inventory.json` (`a8f66d2a98c92a6816ab806b4600b023504b3d57f9eeaae25a617bda4a4341da`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104702Z/inputs/blind_dossier.md` (`e8d7d0ec11e8625d26741588e3624bdad5d26bf08ad750a531efcfb944af818d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104702Z/inputs/blind_review_packet.md` (`e8d7d0ec11e8625d26741588e3624bdad5d26bf08ad750a531efcfb944af818d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104702Z/inputs/declaration_dossier.md` (`680d3c2286588e26995235c8793c789ebb053309524f513cbf451f7d6ad55259`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104702Z/inputs/dependency_inventory.json` (`83cbc5edfbd0c599e9efa6a4b743d0acbd3e1b7588252a3836920602bc3a73fc`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104702Z/inputs/direct_review_packet.md` (`dd2af0d606a616c3a011e18a9d8595fc434fc3c1234fd3f79f89cabeb22777e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104702Z/inputs/source_locator.json` (`cdc3c1634bee8556eb1caf28b5f620c0c76c67adc5305ec593849dd5b71d1a5b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104839Z/inputs/blind_dependency_inventory.json` (`fde85ebac7dafb0f675020f28bc6f9fc02949d5189c7b3280a412bc64c30890b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104839Z/inputs/blind_dossier.md` (`ee8b8b29e1f2b8c4cfc8aedab341ae35b105ced367939c1f15c536759ecb9833`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104839Z/inputs/blind_review_packet.md` (`ee8b8b29e1f2b8c4cfc8aedab341ae35b105ced367939c1f15c536759ecb9833`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104839Z/inputs/declaration_dossier.md` (`467d1b1ccd51feb846e4d1d1aaab65ea89cf60d0616cc409bb136a941e8b79c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104839Z/inputs/dependency_inventory.json` (`1b455a3656e35d4b652b9ed19173a49bd168a845ef9d9eed994771221a696083`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104839Z/inputs/direct_review_packet.md` (`abcf47b167ee39a0dd6fce9a76da10e3338737519dfa67a9327ce90a34254e8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/history/20260831T104839Z/inputs/source_locator.json` (`cdc3c1634bee8556eb1caf28b5f620c0c76c67adc5305ec593849dd5b71d1a5b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/inputs/batch_source_locator.json` (`3f474ebf22108e0212eb4a83d18a037ea4d530303d81a6c062ad8a49d5532b5a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/inputs/blind_dependency_inventory.json` (`fde85ebac7dafb0f675020f28bc6f9fc02949d5189c7b3280a412bc64c30890b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/inputs/blind_dossier.md` (`ee8b8b29e1f2b8c4cfc8aedab341ae35b105ced367939c1f15c536759ecb9833`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/inputs/blind_review_packet.md` (`ee8b8b29e1f2b8c4cfc8aedab341ae35b105ced367939c1f15c536759ecb9833`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/inputs/declaration_dossier.md` (`467d1b1ccd51feb846e4d1d1aaab65ea89cf60d0616cc409bb136a941e8b79c2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/inputs/dependency_inventory.json` (`1b455a3656e35d4b652b9ed19173a49bd168a845ef9d9eed994771221a696083`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/inputs/direct_review_packet.md` (`abcf47b167ee39a0dd6fce9a76da10e3338737519dfa67a9327ce90a34254e8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-LEM-2.6.8/faithfulness/inputs/source_locator.json` (`cdc3c1634bee8556eb1caf28b5f620c0c76c67adc5305ec593849dd5b71d1a5b`)
