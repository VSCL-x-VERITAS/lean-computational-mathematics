# Faithfulness audit: HDP-02-EQ-2.12

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `65e584abe494f5fe5fc3b271394610e9ebf6b6e1f12b7d8204da7da92dfbe2f5`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

Equation (2.12) and the Lean proposition are semantically equivalent. The Mathlib declaration evidence omitted from the isolated round-trip packet resolves its two concerns: gaussianReal takes mean and variance, and gaussianReal 0 1 is the standard-normal Borel probability measure; MeasureTheory.integral is exactly the integral used for expectation and MGF. Although the integral is totalized to zero outside the integrable case, the theorem's strictly positive right-hand side makes its left side nonzero and hence proves integrability, while the Gaussian library also establishes exponential integrability for all real parameters. Therefore C05, C06, C08, and C11 pass, both implication directions hold, the statement is nonvacuous, and the correct accepted classification is faithful-equivalent.

## Implications

- **Lean implies source:** `yes`. The Lean equality is the MGF identity under the exact standard-normal probability law. Its positive right-hand side rules out the nonintegrable zero-totalization branch, so the integral is a finite ordinary expectation. Law invariance then gives the source formula for any X with distribution N(0,1).
- **Source implies lean:** `yes`. The source formula applied to the canonical N(0,1) law gaussianReal 0 1 gives the target integral equality. The source's finite equality supplies the corresponding integrability, and the binder, integrand, constants, and all-real scope match exactly.

## Findings

- **note / canonical-law representation:** This is an equivalent law-based representation, not a specialization or change of object role.
- **note / integral totalization resolved:** The fallback convention cannot satisfy the target accidentally and causes no loss of the source's implicit finite-expectation content.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `unclear` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `34` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `34` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/agent_outputs/adjudicator.json` (`dd474168e6878b2c438848d83e778ac1f589902a433f0a7741e9dc1f2689cca2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/agent_outputs/agent_runs.json` (`fb73ab73e64c41f564d9bf8f98a547a3efda3ec4a61e5d0347b2acdde641df48`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/agent_outputs/blind_translation.json` (`1237bbc77b6d315653eaf52e38b2ddf674c16dc703c2d7d78e66ec23550722c8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/agent_outputs/direct_judge.json` (`103412cb3615063ecb38c6dbeb5994f0d8e85b35835b8c82b94966483949db26`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/agent_outputs/roundtrip_judge.json` (`bdc1fd53ba96b8168733e6c10ea617b985d43e241cacc58531b1e62f86df62c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/agent_outputs/source_contract.json` (`e891bb25200b570fd965c3feb39bb0860e3c5dde82b214f0f3fd2d7e499b0f6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/decision.json` (`ba829aa4ad03675ed153dfecb7cb61d69a9c806f875b372a79b8cf7d4a210f02`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/agent_outputs/adjudicator.json` (`dd474168e6878b2c438848d83e778ac1f589902a433f0a7741e9dc1f2689cca2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/agent_outputs/agent_runs.json` (`24a7b2b621c18dfd693c39a67ee171ca1bc4fd65f5919716e14cf0d408035bc9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/agent_outputs/blind_translation.json` (`1237bbc77b6d315653eaf52e38b2ddf674c16dc703c2d7d78e66ec23550722c8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/agent_outputs/direct_judge.json` (`103412cb3615063ecb38c6dbeb5994f0d8e85b35835b8c82b94966483949db26`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/agent_outputs/roundtrip_judge.json` (`bdc1fd53ba96b8168733e6c10ea617b985d43e241cacc58531b1e62f86df62c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/agent_outputs/source_contract.json` (`e891bb25200b570fd965c3feb39bb0860e3c5dde82b214f0f3fd2d7e499b0f6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/decision.json` (`ac424993df45f8eeb60d225c0dad40563b3af61df0d3f1cb4597f7b30bb2d42d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/inputs/blind_dependency_inventory.json` (`2710c86884deb82d88389b9fbf2e6f3afcfd0930fbeae35290cb37f91c2955fd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/inputs/blind_dossier.md` (`91f73f26690034195136de3c2558d321ade4bcc4b9f988eca42e89ea20e97764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/inputs/blind_review_packet.md` (`91f73f26690034195136de3c2558d321ade4bcc4b9f988eca42e89ea20e97764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/inputs/declaration_dossier.md` (`2ee0f57d3739fe0b77c886b2a55c560f9123d41670d27e7c201bc824c9b56a2e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/inputs/dependency_inventory.json` (`2710c86884deb82d88389b9fbf2e6f3afcfd0930fbeae35290cb37f91c2955fd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/inputs/direct_review_packet.md` (`971630ed3ff3bafb54979d88d20572f0ff2f342b42cdfea3da092c8093cebfb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T083447Z/inputs/source_locator.json` (`bd38a6128b0eb947385923d2153dd138a1bf43af30cb0b0266102b8f8071e250`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/agent_outputs/adjudicator.json` (`dd474168e6878b2c438848d83e778ac1f589902a433f0a7741e9dc1f2689cca2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/agent_outputs/agent_runs.json` (`fb73ab73e64c41f564d9bf8f98a547a3efda3ec4a61e5d0347b2acdde641df48`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/agent_outputs/blind_translation.json` (`1237bbc77b6d315653eaf52e38b2ddf674c16dc703c2d7d78e66ec23550722c8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/agent_outputs/direct_judge.json` (`103412cb3615063ecb38c6dbeb5994f0d8e85b35835b8c82b94966483949db26`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/agent_outputs/roundtrip_judge.json` (`bdc1fd53ba96b8168733e6c10ea617b985d43e241cacc58531b1e62f86df62c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/agent_outputs/source_contract.json` (`e891bb25200b570fd965c3feb39bb0860e3c5dde82b214f0f3fd2d7e499b0f6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/decision.json` (`485e06a9053306c74e82034287deb2d944c087934969d130a83c15de7f0986b1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/inputs/blind_dependency_inventory.json` (`2710c86884deb82d88389b9fbf2e6f3afcfd0930fbeae35290cb37f91c2955fd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/inputs/blind_dossier.md` (`91f73f26690034195136de3c2558d321ade4bcc4b9f988eca42e89ea20e97764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/inputs/blind_review_packet.md` (`91f73f26690034195136de3c2558d321ade4bcc4b9f988eca42e89ea20e97764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/inputs/declaration_dossier.md` (`d6c228b25bd8bad42470337b97d5e598ff5e4c97c9045b7e37fa89cbf337953c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/inputs/dependency_inventory.json` (`2710c86884deb82d88389b9fbf2e6f3afcfd0930fbeae35290cb37f91c2955fd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/inputs/direct_review_packet.md` (`971630ed3ff3bafb54979d88d20572f0ff2f342b42cdfea3da092c8093cebfb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T101054Z/inputs/source_locator.json` (`bd38a6128b0eb947385923d2153dd138a1bf43af30cb0b0266102b8f8071e250`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/agent_outputs/adjudicator.json` (`dd474168e6878b2c438848d83e778ac1f589902a433f0a7741e9dc1f2689cca2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/agent_outputs/agent_runs.json` (`fb73ab73e64c41f564d9bf8f98a547a3efda3ec4a61e5d0347b2acdde641df48`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/agent_outputs/blind_translation.json` (`1237bbc77b6d315653eaf52e38b2ddf674c16dc703c2d7d78e66ec23550722c8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/agent_outputs/direct_judge.json` (`103412cb3615063ecb38c6dbeb5994f0d8e85b35835b8c82b94966483949db26`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/agent_outputs/roundtrip_judge.json` (`bdc1fd53ba96b8168733e6c10ea617b985d43e241cacc58531b1e62f86df62c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/agent_outputs/source_contract.json` (`e891bb25200b570fd965c3feb39bb0860e3c5dde82b214f0f3fd2d7e499b0f6b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/decision.json` (`6cf2bd4d50731df8d55e29c8d8fbd2e522d6a575c29e7b2cbec7db6fede2f8d2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/inputs/blind_dependency_inventory.json` (`2710c86884deb82d88389b9fbf2e6f3afcfd0930fbeae35290cb37f91c2955fd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/inputs/blind_dossier.md` (`91f73f26690034195136de3c2558d321ade4bcc4b9f988eca42e89ea20e97764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/inputs/blind_review_packet.md` (`91f73f26690034195136de3c2558d321ade4bcc4b9f988eca42e89ea20e97764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/inputs/declaration_dossier.md` (`ccdfe032a57b6bca067b78b8c292ab8bb14d6ca2443998072570bc0dfd33c6d6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/inputs/dependency_inventory.json` (`2710c86884deb82d88389b9fbf2e6f3afcfd0930fbeae35290cb37f91c2955fd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/inputs/direct_review_packet.md` (`971630ed3ff3bafb54979d88d20572f0ff2f342b42cdfea3da092c8093cebfb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/history/20260831T203601Z/inputs/source_locator.json` (`bd38a6128b0eb947385923d2153dd138a1bf43af30cb0b0266102b8f8071e250`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/inputs/blind_dependency_inventory.json` (`2710c86884deb82d88389b9fbf2e6f3afcfd0930fbeae35290cb37f91c2955fd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/inputs/blind_dossier.md` (`91f73f26690034195136de3c2558d321ade4bcc4b9f988eca42e89ea20e97764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/inputs/blind_review_packet.md` (`91f73f26690034195136de3c2558d321ade4bcc4b9f988eca42e89ea20e97764`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/inputs/declaration_dossier.md` (`38be3294215abecfbcd9b996a6359ad9bffd8b395e02a2e0b6a6dfed593e0d5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/inputs/dependency_inventory.json` (`2710c86884deb82d88389b9fbf2e6f3afcfd0930fbeae35290cb37f91c2955fd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/inputs/direct_review_packet.md` (`971630ed3ff3bafb54979d88d20572f0ff2f342b42cdfea3da092c8093cebfb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.12/faithfulness/inputs/source_locator.json` (`bd38a6128b0eb947385923d2153dd138a1bf43af30cb0b0266102b8f8071e250`)
